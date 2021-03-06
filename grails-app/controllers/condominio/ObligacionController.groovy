package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Obligacion
 */
class ObligacionController extends Shield {

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
            def c = Obligacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = Obligacion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return obligacionInstanceList: la lista de elementos filtrados, obligacionInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        println "params: $params"
        params.max = 15
        params.sort = 'tipoAporte'
//        def obligacionInstanceList = getList(params, false)
        def obligacionInstanceList
        def obligacionInstanceCount
        if(!params.search) {
            obligacionInstanceList = Obligacion.findAllByCondominio(session.condominio, [max: params.max,
                sort: params.sort, offset: params.offset])
            obligacionInstanceCount = Obligacion.findAllByCondominio(session.condominio).size()
        } else {
            obligacionInstanceList = Obligacion.findAllByCondominioAndDescripcionIlike(session.condominio, '%' + params.search + '%')
            obligacionInstanceCount = 14
        }
//        def obligacionInstanceList = Obligacion.findAllByCondominio(session.condominio, [params: params])
        return [obligacionInstanceList: obligacionInstanceList, obligacionInstanceCount: obligacionInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return obligacionInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def obligacionInstance = Obligacion.get(params.id)
            if(!obligacionInstance) {
                render "ERROR*No se encontró Obligacion."
                return
            }
            return [obligacionInstance: obligacionInstance]
        } else {
            render "ERROR*No se encontró Obligacion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return obligacionInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def obligacionInstance = new Obligacion()
        if(params.id) {
            obligacionInstance = Obligacion.get(params.id)
            if(!obligacionInstance) {
                render "ERROR*No se encontró Obligacion."
                return
            }
        }
        obligacionInstance.properties = params
        return [obligacionInstance: obligacionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        println "params: $params"
        params.valor = params.valor.toDouble()
        def obligacionInstance = new Obligacion()
        if(params.id) {
            obligacionInstance = Obligacion.get(params.id)
            if(!obligacionInstance) {
                render "ERROR*No se encontró Obligacion."
                return
            }
        }
        obligacionInstance.properties = params
        obligacionInstance.condominio = session.condominio
        if(!obligacionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Obligacion: " + renderErrors(bean: obligacionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Obligacion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def obligacionInstance = Obligacion.get(params.id)
            if (!obligacionInstance) {
                render "ERROR*No se encontró Obligacion."
                return
            }
            try {
                obligacionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Obligacion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Obligacion"
                return
            }
        } else {
            render "ERROR*No se encontró Obligacion."
            return
        }
    } //delete para eliminar via ajax
    
}
