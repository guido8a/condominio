package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Propiedad
 */
class PropiedadController extends Shield {

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
            def c = Propiedad.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("numero", "%" + params.search + "%")  
                            ilike("observaciones", "%" + params.search + "%")  
                }
            }
        } else {
            list = Propiedad.list(params)

        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return propiedadInstanceList: la lista de elementos filtrados, propiedadInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
//        println "--> $params"
        def dueno = Persona.get(params.id)
        def propiedadInstanceList = Propiedad.findAllByPersona(dueno)
        def propiedadInstanceCount = propiedadInstanceList.size()
        return [propiedadInstanceList: propiedadInstanceList, propiedadInstanceCount: propiedadInstanceCount, dueno: dueno]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return propiedadInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def propiedadInstance = Propiedad.get(params.id)
            if(!propiedadInstance) {
                render "ERROR*No se encontró Propiedad."
                return
            }
            return [propiedadInstance: propiedadInstance]
        } else {
            render "ERROR*No se encontró Propiedad."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return propiedadInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {

        def persona

        if(params.dueno){
         persona = Persona.get(params.dueno)
        }

        def propiedadInstance = new Propiedad()
        if(params.id) {
            propiedadInstance = Propiedad.get(params.id)
            if(!propiedadInstance) {
                render "ERROR*No se encontró Propiedad."
                return
            }
        }
        propiedadInstance.properties = params
        return [propiedadInstance: propiedadInstance, persona: persona]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {

//        println("params save " + params)

        params.area = params.area.toDouble()
        params.valor = params.valor.toDouble()
        params.alicuota = params.alicuota.toDouble()


        def propiedadInstance = new Propiedad()
        if(params.id) {
            propiedadInstance = Propiedad.get(params.id)
            if(!propiedadInstance) {
                render "no"
                return
            }
        }
        propiedadInstance.properties = params
        if(!propiedadInstance.save(flush: true)) {
            render "no"
            return
        }
        render "ok"
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def propiedadInstance = Propiedad.get(params.id)
            if (!propiedadInstance) {
                render "no"
                return
            }
            try {
                propiedadInstance.delete(flush: true)
                render "ok"
                return
            } catch (DataIntegrityViolationException e) {
                render "no"
                return
            }
        } else {
            render "no"
            return
        }
    } //delete para eliminar via ajax

    def tablaPropiedades_ajax () {

        def persona = Persona.get(params.id)
        def propiedades = Propiedad.findAllByPersona(persona)

        return[propiedades: propiedades]

    }
    
}
