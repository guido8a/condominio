package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Canton
 */
class CantonController extends Shield {

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
            def c = Canton.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("nombre", "%" + params.search + "%")  
                            ilike("provincia", "%" + params.search + "%")  
                }
            }
        } else {
            list = Canton.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return cantonInstanceList: la lista de elementos filtrados, cantonInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def cantonInstanceList = getList(params, false)
        def cantonInstanceCount = getList(params, true).size()
        return [cantonInstanceList: cantonInstanceList, cantonInstanceCount: cantonInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return cantonInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def cantonInstance = Canton.get(params.id)
            if(!cantonInstance) {
                render "ERROR*No se encontró Canton."
                return
            }
            return [cantonInstance: cantonInstance]
        } else {
            render "ERROR*No se encontró Canton."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return cantonInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def cantonInstance = new Canton()
        if(params.id) {
            cantonInstance = Canton.get(params.id)
            if(!cantonInstance) {
                render "ERROR*No se encontró Canton."
                return
            }
        }
        cantonInstance.properties = params
        return [cantonInstance: cantonInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def cantonInstance = new Canton()
        if(params.id) {
            cantonInstance = Canton.get(params.id)
            if(!cantonInstance) {
                render "ERROR*No se encontró Canton."
                return
            }
        }
        cantonInstance.properties = params
        if(!cantonInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Canton: " + renderErrors(bean: cantonInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Canton exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def cantonInstance = Canton.get(params.id)
            if (!cantonInstance) {
                render "ERROR*No se encontró Canton."
                return
            }
            try {
                cantonInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Canton exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Canton"
                return
            }
        } else {
            render "ERROR*No se encontró Canton."
            return
        }
    } //delete para eliminar via ajax
    
}
