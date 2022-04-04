package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield
import utilitarios.Anio

/**
 * Controlador que muestra las pantallas de manejo de Sueldo
 */
class SueldoController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

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


    def tablaSueldos_ajax(){
        def empleado = Empleado.get(params.id)
        def sueldos = Sueldo.findAllByEmpleado(empleado)
        return[sueldos:sueldos]
    }

    def saveSueldo_ajax(){

//        println("params ss " + params)

        def empleado = Empleado.get(params.empleado)
        def anio = Anio.get(params.anio)
        def existe = Sueldo.findAllByEmpleadoAndAnio(empleado, anio)
        def sueldo

        def s = Sueldo.get(1)
        def p = RolPagos.findAllBySueldo(s)

        println "--> p $p"


        if(params.id){
            sueldo = Sueldo.get(params.id)
            def rol = RolPagos.findAllBySueldo(sueldo)
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
