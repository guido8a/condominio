package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Ingreso
 */
class IngresoController extends Shield {

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
            def c = Ingreso.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("documento", "%" + params.search + "%")  
                            ilike("estado", "%" + params.search + "%")  
                            ilike("observaciones", "%" + params.search + "%")  
                }
            }
        } else {
            list = Ingreso.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return ingresoInstanceList: la lista de elementos filtrados, ingresoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def ingresoInstanceList = getList(params, false)
        def ingresoInstanceCount = getList(params, true).size()
        return [ingresoInstanceList: ingresoInstanceList, ingresoInstanceCount: ingresoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return ingresoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def ingresoInstance = Ingreso.get(params.id)
            if(!ingresoInstance) {
                render "ERROR*No se encontró Ingreso."
                return
            }
            return [ingresoInstance: ingresoInstance]
        } else {
            render "ERROR*No se encontró Ingreso."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return ingresoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def ingresoInstance = new Ingreso()
        if(params.id) {
            ingresoInstance = Ingreso.get(params.id)
            if(!ingresoInstance) {
                render "ERROR*No se encontró Ingreso."
                return
            }
        }
        ingresoInstance.properties = params
        return [ingresoInstance: ingresoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def ingresoInstance = new Ingreso()
        if(params.id) {
            ingresoInstance = Ingreso.get(params.id)
            if(!ingresoInstance) {
                render "ERROR*No se encontró Ingreso."
                return
            }
        }
        ingresoInstance.properties = params
        if(!ingresoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Ingreso: " + renderErrors(bean: ingresoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Ingreso exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def ingresoInstance = Ingreso.get(params.id)
            if (!ingresoInstance) {
                render "ERROR*No se encontró Ingreso."
                return
            }
            try {
                ingresoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Ingreso exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Ingreso"
                return
            }
        } else {
            render "ERROR*No se encontró Ingreso."
            return
        }
    } //delete para eliminar via ajax
    
}