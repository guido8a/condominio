package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Obra
 */
class ObraController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action:"list", params: params)
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Obra.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                }
            }
        } else {
            list = Obra.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return obraInstanceList: la lista de elementos filtrados, obraInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def obraInstanceList = getList(params, false)
        def obraInstanceCount = getList(params, true).size()
        return [obraInstanceList: obraInstanceList, obraInstanceCount: obraInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return obraInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def obraInstance = Obra.get(params.id)
            if(!obraInstance) {
                render "ERROR*No se encontró Obra."
                return
            }
            return [obraInstance: obraInstance]
        } else {
            render "ERROR*No se encontró Obra."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return obraInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def obraInstance = new Obra()
        if(params.id) {
            obraInstance = Obra.get(params.id)
            if(!obraInstance) {
                render "ERROR*No se encontró Obra."
                return
            }
        }
        obraInstance.properties = params
        return [obraInstance: obraInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        println("params " + params)

        def proveedor


        if(params."proveedor.id" == '0'){
            println("entro")
            proveedor = null
        }else{
            proveedor = Proveedor.get(params."proveedor.id")
        }

        def obraInstance = new Obra()
        if(params.id) {
            obraInstance = Obra.get(params.id)
            if(!obraInstance) {
                render "ERROR*No se encontró Obra."
                return
            }
        }
        params.presupuesto = params.presupuesto.toDouble()
        obraInstance.properties = params
        obraInstance.proveedor = proveedor

        if(!obraInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Obra: " + renderErrors(bean: obraInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Obra exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def obraInstance = Obra.get(params.id)
            if (!obraInstance) {
                render "ERROR*No se encontró Obra."
                return
            }
            try {
                obraInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Obra exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Obra"
                return
            }
        } else {
            render "ERROR*No se encontró Obra."
            return
        }
    } //delete para eliminar via ajax


    def listaObras () {

    }

    def buscador_ajax () {
//        println("params " + params)
        def ori
        def lista  = [:]

        def condominio = Condominio.get(session.condominio.id)
        def personas = Persona.findAllByCondominio(condominio)
        def obrasExistentes = Obra.findAllByPersonaInList(personas)

        switch (params.seleccionado){
            case '1': ori = obrasExistentes.tipoObra.unique().sort{it.descripcion}
                ori.each {
                    lista.put(it.id, it.descripcion)
                }
                break;
            case "2": ori = obrasExistentes.persona.unique().sort{it.nombre}
                ori.each {
                    lista.put(it.id, (it.nombre + " " + it.apellido))
                }
                break;
            case "3": ori = obrasExistentes.proveedor.unique().sort{it.nombre}
                ori.each {
                    lista.put(it.id,it.nombre)
                }
                break;
        }

        return[lista: lista, tipo: params.seleccionado]
    }

    def tablaObras_ajax () {
//        println("params tabla " + params)

        def condominio = Condominio.get(session.condominio.id)
        def personas = Persona.findAllByCondominio(condominio)
        def obras
        def tipoObra
        def persona
        def proveedor

        if(params.combo1 == '0') {
            obras = Obra.findAllByPersonaInList(personas)
        }else{

            if(params.combo2 && params.combo2 != '0'){
                    switch (params.combo1){
                        case '1':   tipoObra = TipoObra.get(params.combo2.toInteger())
                            obras = Obra.findAllByTipoObraAndPersonaInList(tipoObra, personas)
                            break;
                        case "2":   persona = Persona.get(params.combo2.toInteger())
                            obras = Obra.findAllByPersona(persona)
                            break;
                        case "3":   proveedor = Proveedor.get(params.combo2.toInteger())
                            obras = Obra.findAllByProveedorAndPersonaInList(proveedor,personas)
                            break;
                    }
            }
            else{
                if(params.texto != ''){
                    obras = Obra.withCriteria {

                        'in'("persona", personas)
                        ilike("descripcion", "%" + params.texto + "%")

                    }
                }
            }
        }


//        println("obras " + obras)
        return [obras: obras]

    }
}
