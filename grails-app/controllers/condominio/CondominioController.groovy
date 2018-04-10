package condominio

import org.springframework.dao.DataIntegrityViolationException


/**
 * Controlador que muestra las pantallas de manejo de Condominio
 */
class CondominioController  {

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
            def c = Condominio.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("direccion", "%" + params.search + "%")  
                            ilike("email", "%" + params.search + "%")  
                            ilike("nombre", "%" + params.search + "%")  
                            ilike("ruc", "%" + params.search + "%")  
                            ilike("sigla", "%" + params.search + "%")  
                            ilike("telefono", "%" + params.search + "%")  
                }
            }
        } else {
            list = Condominio.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return condominioInstanceList: la lista de elementos filtrados, condominioInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def condominioInstanceList = getList(params, false)
        def condominioInstanceCount = getList(params, true).size()
        return [condominioInstanceList: condominioInstanceList, condominioInstanceCount: condominioInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return condominioInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def condominioInstance = Condominio.get(params.id)
            if(!condominioInstance) {
                render "ERROR*No se encontró Condominio."
                return
            }
            return [condominioInstance: condominioInstance]
        } else {
            render "ERROR*No se encontró Condominio."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return condominioInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def condominioInstance = new Condominio()
        if(params.id) {
            condominioInstance = Condominio.get(params.id)
            if(!condominioInstance) {
                render "ERROR*No se encontró Condominio."
                return
            }
        }
        condominioInstance.properties = params
        return [condominioInstance: condominioInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def condominioInstance = new Condominio()
        if(params.id) {
            condominioInstance = Condominio.get(params.id)
            if(!condominioInstance) {
                render "ERROR*No se encontró Condominio."
                return
            }
        }
        condominioInstance.properties = params
        if(!condominioInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Condominio: " + renderErrors(bean: condominioInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Condominio exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def condominioInstance = Condominio.get(params.id)
            if (!condominioInstance) {
                render "ERROR*No se encontró Condominio."
                return
            }
            try {
                condominioInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Condominio exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Condominio"
                return
            }
        } else {
            render "ERROR*No se encontró Condominio."
            return
        }
    } //delete para eliminar via ajax
    
            /**
             * Acción llamada con ajax que valida que no se duplique la propiedad email
             * @render boolean que indica si se puede o no utilizar el valor recibido
             */
            def validar_unique_email_ajax() {
                params.email = params.email.toString().trim()
                if (params.id) {
                    def obj = Condominio.get(params.id)
                    if (obj.email.toLowerCase() == params.email.toLowerCase()) {
                        render true
                        return
                    } else {
                        render Condominio.countByEmailIlike(params.email) == 0
                        return
                    }
                } else {
                    render Condominio.countByEmailIlike(params.email) == 0
                    return
                }
            }
            
}
