package condominio

import org.springframework.dao.DataIntegrityViolationException
import utilitarios.Anio


/**
 * Controlador que muestra las pantallas de manejo de Sueldo
 */
class SueldoController {

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
            def c = Sueldo.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                }
            }
        } else {
            list = Sueldo.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return sueldoInstanceList: la lista de elementos filtrados, sueldoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def sueldoInstanceList = getList(params, false)
        def sueldoInstanceCount = getList(params, true).size()
        return [sueldoInstanceList: sueldoInstanceList, sueldoInstanceCount: sueldoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return sueldoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def sueldoInstance = Sueldo.get(params.id)
            if(!sueldoInstance) {
                render "ERROR*No se encontró Sueldo."
                return
            }
            return [sueldoInstance: sueldoInstance]
        } else {
            render "ERROR*No se encontró Sueldo."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return sueldoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        println("params " + params)
        def empleado = Empleado.get(params.id)
        def sueldos = Sueldo.findAllByEmpleado(empleado)
        def sueldoInstance = new Sueldo()

        return[sueldos:sueldos, sueldoInstance: sueldoInstance, empleado: empleado]

    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def sueldoInstance = new Sueldo()
        if(params.id) {
            sueldoInstance = Sueldo.get(params.id)
            if(!sueldoInstance) {
                render "ERROR*No se encontró Sueldo."
                return
            }
        }
        sueldoInstance.properties = params
        if(!sueldoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Sueldo: " + renderErrors(bean: sueldoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Sueldo exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def sueldoInstance = Sueldo.get(params.id)
            if (!sueldoInstance) {
                render "ERROR*No se encontró Sueldo."
                return
            }
            try {
                sueldoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Sueldo exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Sueldo"
                return
            }
        } else {
            render "ERROR*No se encontró Sueldo."
            return
        }
    } //delete para eliminar via ajax

    def tablaSueldos_ajax(){
        def empleado = Empleado.get(params.id)
        def sueldos = Sueldo.findAllByEmpleado(empleado)
        return[sueldos:sueldos]
    }

    def saveSueldo_ajax(){

        println("params ss " + params)

        def empleado = Empleado.get(params.empleado)
        def anio = Anio.get(params.anio)
        def existe = Sueldo.findAllByEmpleadoAndAnio(empleado, anio)
        def sueldo

        def s = Sueldo.get(1)
        def p = RolPagos.findAllBySueldo(s)

        println("p " + p)


        if(params.id){
            sueldo = Sueldo.get(params.id)
            println("id " + sueldo)
            def rol = RolPagos.findAllBySueldo(sueldo)
            println("rol " + rol)
            if(rol){
                render "er_No se puede modificar el sueldo, ya está siendo usado en un rol de pagos!"
                return
            }else{
                sueldo.anio = anio
                sueldo.valor = params.valor.toDouble()
            }
        }else{
            if(existe){
                render "er_Ya existe asignado un sueldo para este año!"
                return
            }else{
                sueldo = new Sueldo()
                sueldo.empleado =  empleado
                sueldo.anio = anio
                sueldo.valor = params.valor.toDouble()
            }
        }

        if(!sueldo.save(flush:true)){
            println("error al guardar el sueldo")
            render "no"
        }else{
            render "ok"
        }
    }
    
}
