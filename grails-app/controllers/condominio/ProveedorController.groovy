package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Proveedor
 */
class ProveedorController extends Shield {

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
            def c = Proveedor.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("activo", "%" + params.search + "%")  
                            ilike("apellido", "%" + params.search + "%")  
                            ilike("direccion", "%" + params.search + "%")  
                            ilike("mail", "%" + params.search + "%")  
                            ilike("nombre", "%" + params.search + "%")  
                            ilike("observaciones", "%" + params.search + "%")  
                            ilike("ruc", "%" + params.search + "%")  
                            ilike("telefono", "%" + params.search + "%")  
                }
            }
        } else {
            list = Proveedor.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return proveedorInstanceList: la lista de elementos filtrados, proveedorInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def proveedorInstanceList = getList(params, false)
        def proveedorInstanceCount = getList(params, true).size()
        return [proveedorInstanceList: proveedorInstanceList, proveedorInstanceCount: proveedorInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return proveedorInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def proveedorInstance = Proveedor.get(params.id)
            if(!proveedorInstance) {
                render "ERROR*No se encontró Proveedor."
                return
            }
            return [proveedorInstance: proveedorInstance]
        } else {
            render "ERROR*No se encontró Proveedor."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return proveedorInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def proveedorInstance = new Proveedor()
        if(params.id) {
            proveedorInstance = Proveedor.get(params.id)
            if(!proveedorInstance) {
                render "ERROR*No se encontró Proveedor."
                return
            }
        }
        proveedorInstance.properties = params
        return [proveedorInstance: proveedorInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def proveedorInstance = new Proveedor()
        if(params.id) {
            proveedorInstance = Proveedor.get(params.id)
            if(!proveedorInstance) {
                render "ERROR*No se encontró Proveedor."
                return
            }
        } else {
            proveedorInstance.fecha = new Date()
        }
        proveedorInstance.properties = params
        if(!proveedorInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Proveedor: " + renderErrors(bean: proveedorInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Proveedor exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def proveedorInstance = Proveedor.get(params.id)
            if (!proveedorInstance) {
                render "ERROR*No se encontró Proveedor."
                return
            }
            try {
                proveedorInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Proveedor exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Proveedor"
                return
            }
        } else {
            render "ERROR*No se encontró Proveedor."
            return
        }
    } //delete para eliminar via ajax
    
            /**
             * Acción llamada con ajax que valida que no se duplique la propiedad mail
             * @render boolean que indica si se puede o no utilizar el valor recibido
             */
            def validar_unique_mail_ajax() {
                params.mail = params.mail.toString().trim()
                if (params.id) {
                    def obj = Proveedor.get(params.id)
                    if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                        render true
                        return
                    } else {
                        render Proveedor.countByMailIlike(params.mail) == 0
                        return
                    }
                } else {
                    render Proveedor.countByMailIlike(params.mail) == 0
                    return
                }
            }
            
}
