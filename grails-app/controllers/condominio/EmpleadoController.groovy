package condominio

import org.springframework.dao.DataIntegrityViolationException


/**
 * Controlador que muestra las pantallas de manejo de Empleado
 */
class EmpleadoController {

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
            def c = Empleado.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("apellido", "%" + params.search + "%")
                    ilike("cargo", "%" + params.search + "%")
                    ilike("cedula", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("sexo", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Empleado.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return empleadoInstanceList: la lista de elementos filtrados, empleadoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {

        def condominio = Condominio.get(params.id)
        def empleados = Empleado.findAllByCondominio(condominio)

        return[empleados: empleados, condominio: condominio]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return empleadoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def empleadoInstance = Empleado.get(params.id)
            if(!empleadoInstance) {
                render "ERROR*No se encontró Empleado."
                return
            }
            return [empleadoInstance: empleadoInstance]
        } else {
            render "ERROR*No se encontró Empleado."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return empleadoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {

        println("params "  + params)

        def condominio = Condominio.get(params.condominio)
        def empleadoInstance = new Empleado()
        if(params.id) {
            empleadoInstance = Empleado.get(params.id)
            if(!empleadoInstance) {
                render "ERROR*No se encontró Empleado."
                return
            }
        }
        empleadoInstance.properties = params
        return [empleadoInstance: empleadoInstance, condominio: condominio]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {

        def empleado

        if(params.id){
            empleado = Empleado.get(params.id)
        }else{
            empleado = new Empleado()
            empleado.fechaRegistro = new Date()
        }

        empleado.properties = params

        if(!empleado.save(flush:true)){
            println("error al guardar el empleado " + empleado.errors)
            render "no"
        }else{
            render "ok"
        }

    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def empleadoInstance = Empleado.get(params.id)
            if (!empleadoInstance) {
                render "ERROR*No se encontró Empleado."
                return
            }
            try {
                empleadoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Empleado exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Empleado"
                return
            }
        } else {
            render "ERROR*No se encontró Empleado."
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
            def obj = Empleado.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Empleado.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Empleado.countByMailIlike(params.mail) == 0
            return
        }
    }

    def nomina(){

        def condominio = Condominio.get(params.con)
        def empleado = Empleado.get(params.id)
        def sueldos = Sueldo.findAllByEmpleado(empleado)
        def roles = RolPagos.findAllBySueldoInList(sueldos).sort{it.salario.id}

        return[roles: roles, empleado: empleado, condominio: condominio]
    }

}
