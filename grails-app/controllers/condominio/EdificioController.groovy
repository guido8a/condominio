package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Edificio
 */
class EdificioController extends Shield {

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
            def c = Edificio.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = Edificio.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return edificioInstanceList: la lista de elementos filtrados, edificioInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        params.max = 15
        params.sort = 'descripcion'
        def edificioInstanceList
        def edificioInstanceCount

        if(session.perfil.codigo == 'ADM'){
            edificioInstanceList = getList(params, false)
            edificioInstanceCount = getList(params, true).size()
        }else{
            edificioInstanceList = Edificio.findAllByCondominio(session.condominio)
            edificioInstanceCount = 1
        }
//        def edificioInstanceList = getList(params, false)
//        def edificioInstanceCount = getList(params, true).size()
        return [edificioInstanceList: edificioInstanceList, edificioInstanceCount: edificioInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return edificioInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def edificioInstance = Edificio.get(params.id)
            if(!edificioInstance) {
                render "ERROR*No se encontró Edificio."
                return
            }
            return [edificioInstance: edificioInstance]
        } else {
            render "ERROR*No se encontró Edificio."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return edificioInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def edificioInstance = new Edificio()
        if(params.id) {
            edificioInstance = Edificio.get(params.id)
            if(!edificioInstance) {
                render "ERROR*No se encontró Edificio."
                return
            }
        }
        edificioInstance.properties = params
        return [edificioInstance: edificioInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def edificioInstance = new Edificio()
//        def condominio = Condominio.get(session.condominio.id)
        println "params: $params"
        if(params.id) {
            edificioInstance = Edificio.get(params.id)
            if(!edificioInstance) {
                render "ERROR*No se encontró Edificio."
                return
            }
        }
        edificioInstance.properties = params
//        edificioInstance.condominio = condominio
        println "edif: ${edificioInstance.condominio}"
        if(!edificioInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Edificio: " + renderErrors(bean: edificioInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Edificio exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def edificioInstance = Edificio.get(params.id)
            if (!edificioInstance) {
                render "ERROR*No se encontró Edificio."
                return
            }
            try {
                edificioInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Edificio exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Edificio"
                return
            }
        } else {
            render "ERROR*No se encontró Edificio."
            return
        }
    } //delete para eliminar via ajax
    
}
