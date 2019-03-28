package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield



/**
 * Controlador que muestra las pantallas de manejo de TipoCondominio
 */
class TipoCondominioController extends Shield {

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
            def c = TipoCondominio.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = TipoCondominio.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return tipoCondominioInstanceList: la lista de elementos filtrados, tipoCondominioInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def tipoCondominioInstanceList = getList(params, false)
        def tipoCondominioInstanceCount = getList(params, true).size()
        return [tipoCondominioInstanceList: tipoCondominioInstanceList, tipoCondominioInstanceCount: tipoCondominioInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return tipoCondominioInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def tipoCondominioInstance = TipoCondominio.get(params.id)
            if(!tipoCondominioInstance) {
                render "ERROR*No se encontró TipoCondominio."
                return
            }
            return [tipoCondominioInstance: tipoCondominioInstance]
        } else {
            render "ERROR*No se encontró TipoCondominio."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return tipoCondominioInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def tipoCondominioInstance = new TipoCondominio()
        if(params.id) {
            tipoCondominioInstance = TipoCondominio.get(params.id)
            if(!tipoCondominioInstance) {
                render "ERROR*No se encontró TipoCondominio."
                return
            }
        }
        tipoCondominioInstance.properties = params
        return [tipoCondominioInstance: tipoCondominioInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def tipoCondominioInstance = new TipoCondominio()
        if(params.id) {
            tipoCondominioInstance = TipoCondominio.get(params.id)
            if(!tipoCondominioInstance) {
                render "ERROR*No se encontró TipoCondominio."
                return
            }
        }
        tipoCondominioInstance.properties = params
        if(!tipoCondominioInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar TipoCondominio: " + renderErrors(bean: tipoCondominioInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de TipoCondominio exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def tipoCondominioInstance = TipoCondominio.get(params.id)
            if (!tipoCondominioInstance) {
                render "ERROR*No se encontró TipoCondominio."
                return
            }
            try {
                tipoCondominioInstance.delete(flush: true)
                render "SUCCESS*Eliminación de TipoCondominio exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar TipoCondominio"
                return
            }
        } else {
            render "ERROR*No se encontró TipoCondominio."
            return
        }
    } //delete para eliminar via ajax
    
}
