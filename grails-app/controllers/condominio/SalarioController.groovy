package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Salario
 */
class SalarioController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que muestra la lista de elementos
     * @return salarioInstanceList: la lista de elementos filtrados, salarioInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def salarioInstanceList = Salario.list().sort{it.id}
        return [salarioInstanceList: salarioInstanceList]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return salarioInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def salarioInstance = Salario.get(params.id)
            if(!salarioInstance) {
                render "ERROR*No se encontró Salario."
                return
            }
            return [salarioInstance: salarioInstance]
        } else {
            render "ERROR*No se encontró Salario."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return salarioInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def salarioInstance = new Salario()
        if(params.id) {
            salarioInstance = Salario.get(params.id)
            if(!salarioInstance) {
                render "ERROR*No se encontró Salario."
                return
            }
        }
        salarioInstance.properties = params
        return [salarioInstance: salarioInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {

        def salario

        if(params.id){
            salario = Salario.get(params.id)
        }else{
            salario = new Salario()
        }

        salario.descripcion = params.descripcion.toUpperCase();

        if(!salario.save(flush: true)){
            println("error al guardar el salario " + salario.errors)
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
            def salarioInstance = Salario.get(params.id)
            if (!salarioInstance) {
                render "ERROR*No se encontró Salario."
                return
            }
            try {
                salarioInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Salario exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Salario"
                return
            }
        } else {
            render "ERROR*No se encontró Salario."
            return
        }
    } //delete para eliminar via ajax
    
}
