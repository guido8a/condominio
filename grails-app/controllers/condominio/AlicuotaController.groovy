package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Alicuota
 */
class AlicuotaController extends Shield {

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
            def c = Alicuota.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("observaciones", "%" + params.search + "%")
                }
            }
        } else {
            list = Alicuota.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return alicuotaInstanceList: la lista de elementos filtrados, alicuotaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def alicuotaInstanceList = getList(params, false)
        def alicuotaInstanceCount = getList(params, true).size()
        return [alicuotaInstanceList: alicuotaInstanceList, alicuotaInstanceCount: alicuotaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return alicuotaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def alicuotaInstance = Alicuota.get(params.id)
            if(!alicuotaInstance) {
                render "ERROR*No se encontró Alicuota."
                return
            }
            return [alicuotaInstance: alicuotaInstance]
        } else {
            render "ERROR*No se encontró Alicuota."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return alicuotaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        println("params f" + params)
        def alicuota = new Alicuota()
        def prsn = Persona.get(params.id)
        if(prsn) {
            def alct = Alicuota.findByPersona(prsn)
            if(alct){
                alicuota = alct
            }
        }
        alicuota?.properties = params
        return [alicuotaInstance: alicuota, persona: prsn]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        println "params: $params"
        def alicuotaInstance = new Alicuota()
        def alicuotasAntiguas
        if(params.id) {
            alicuotaInstance = Alicuota.get(params.id)
            if(!alicuotaInstance) {
                render "ERROR*No se encontró Alicuota."
                return
            }
        }else{

            alicuotasAntiguas = Alicuota.findAllByPersona()

        }
        if(params.valor) params.valor = params.valor.toDouble()
        alicuotaInstance.properties = params




        println "valor: ${alicuotaInstance.valor}"
        if(!alicuotaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Alicuota: " + renderErrors(bean: alicuotaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Alicuota exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def alicuotaInstance = Alicuota.get(params.id)
            if (!alicuotaInstance) {
                render "ERROR*No se encontró Alicuota."
                return
            }
            try {
                alicuotaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Alicuota exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Alicuota"
                return
            }
        } else {
            render "ERROR*No se encontró Alicuota."
            return
        }
    } //delete para eliminar via ajax

    def tablaAlicuotas_ajax () {

        def persona = Persona.get(params.id)
        def alicuotas = Alicuota.findAllByPersona(persona)

        return [alicuotas: alicuotas, persona: persona]
    }


}
