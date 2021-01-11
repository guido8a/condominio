package utilitarios

import condominio.RolPagos
import condominio.Sueldo
import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Anio
 */
class AnioController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que muestra la lista de elementos
     * @return anioInstanceList: la lista de elementos filtrados, anioInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def anioInstanceList = Anio.list().sort{it.numero}
        return [anioInstanceList: anioInstanceList]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return anioInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def anioInstance = Anio.get(params.id)
            if(!anioInstance) {
                render "ERROR*No se encontró Anio."
                return
            }
            return [anioInstance: anioInstance]
        } else {
            render "ERROR*No se encontró Anio."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return anioInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def anioInstance = new Anio()
        if(params.id) {
            anioInstance = Anio.get(params.id)
            if(!anioInstance) {
                render "ERROR*No se encontró Anio."
                return
            }
        }
        anioInstance.properties = params
        return [anioInstance: anioInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {

        def anio

        if(params.id){
            anio = Anio.get(params.id)
            def sueldo = Sueldo.findAllByAnio(anio)
            def roles = RolPagos.findAllBySueldoInList(sueldo)

            if(roles){
                render "er_El año no puede ser editado, ya está siendo usado en un rol de pagos"
                return
            }

        }else{
            anio = new Anio()
        }

        anio.numero = params.numero
        anio.sueldoBasico = params.sueldoBasico.toDouble()
        anio.estado = 0

        if(!anio.save(flush:true)){
            println("error al guardar el año" + anio.errors)
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
            def anioInstance = Anio.get(params.id)
            if (!anioInstance) {
                render "ERROR*No se encontró Anio."
                return
            }
            try {
                anioInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Anio exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Anio"
                return
            }
        } else {
            render "ERROR*No se encontró Anio."
            return
        }
    } //delete para eliminar via ajax

}
