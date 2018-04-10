package seguridad

import condominio.Condominio
import condominio.Ingreso
import org.apache.tomcat.util.security.MD5Encoder
import org.springframework.dao.DataIntegrityViolationException
import sun.security.provider.MD5


/**
 * Controlador que muestra las pantallas de manejo de Persona
 */
class PersonaController extends Shield {

    def dbConnectionService

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
            def c = Persona.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("apellido", "%" + params.search + "%")
                    ilike("autorizacion", "%" + params.search + "%")
                    ilike("cargo", "%" + params.search + "%")
                    ilike("departamento", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("login", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("ruc", "%" + params.search + "%")
                    ilike("sexo", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Persona.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return personaInstanceList: la lista de elementos filtrados, personaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def personaInstanceList = getList(params, false)
        def personaInstanceCount = getList(params, true).size()
        return [personaInstanceList: personaInstanceList, personaInstanceCount: personaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return personaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def personaInstance = Persona.get(params.id)
            if(!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
            return [personaInstance: personaInstance]
        } else {
            render "ERROR*No se encontró Persona."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return personaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def personaInstance = new Persona()
        def perfiles = []
        if(params.id) {
            personaInstance = Persona.get(params.id)
            if(!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }

            perfiles = Sesn.withCriteria {
                eq("usuario", personaInstance)
                perfil {
                    order("nombre", "asc")
                }
            }
        }
        personaInstance.properties = params
        return [personaInstance: personaInstance, perfiles: perfiles]
    } //form para cargar con ajax en un dialog


    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
//        println("params " + params)

        def persona
        params.sexo = (params.sexo == 'Masculino' ? 'M' : 'F')

        params.alicuota = params.alicuota.toDouble()

        if(params.fechaInicio_input){
            params.fechaInicio_input = new Date().parse('dd-MM-yyyy', params.fechaInicio_input)
            params.fechaFin_input = new Date().parse('dd-MM-yyyy', params.fechaFin_input)
        }

        if(params.id){
            persona = Persona.get(params.id)
        }else{
            persona = new Persona()
            persona.fecha = new Date()
        }
        if(params.activo){
            params.activo = 1
        }else{
            params.activo = 0
        }

        persona.properties = params

        persona.password = params.password.encodeAsMD5()

        if(!persona.fecha) persona.fecha = new Date()

        if(!persona.save(flush: true)){
            println("persona " + persona.errors)
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
            def personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
            try {
                personaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Persona exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Persona"
                return
            }
        } else {
            render "ERROR*No se encontró Persona."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad login
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_login_ajax() {
        params.login = params.login.toString().trim()
        if (params.id) {
            def obj = Persona.get(params.id)
            if (obj?.login?.toLowerCase() == params?.login?.toLowerCase()) {
                render true
                return
            } else {
                render Persona.countByLoginIlike(params.login) == 0
                return
            }
        } else {
            render Persona.countByLoginIlike(params.login) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad mail
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_mail_ajax() {
        params.mail = params.mail.toString().trim()
        if (params.id) {
            def obj = Persona.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Persona.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Persona.countByMailIlike(params.mail) == 0
            return
        }
    }

    def perfil_ajax() {
        def usuario = Persona.get(params.id)
        return[usuario: usuario]
    }

    def tablaPerfiles_ajax () {

        def perfiles = []
        def usuario = Persona.get(params.id)
        perfiles = Sesn.withCriteria {
            eq("usuario", usuario)
            perfil {
                order("nombre", "asc")
            }
        }

        return[perfiles: perfiles]
    }

    def guardarPerfil_ajax () {
//        println("params gperfil " + params)
        def usuario = Persona.get(params.id)
        def perfilSeleccionado = Prfl.get(params.perfil)

        def perfiles = Sesn.withCriteria {
            eq("usuario", usuario)
            perfil {
                order("nombre", "asc")
            }
        }

        if(perfiles.perfil.id.contains(perfilSeleccionado.id)){
            render "no_Este perfil ya se encuentra asignado al usuario"
        }else{
            def sesion = new Sesn()
            sesion.fechaInicio = new Date()
            sesion.perfil = perfilSeleccionado
            sesion.usuario = usuario


            if(!sesion.save(flush: true)){
                println("error al guardar el perfil")
                render "no_Erro al guardar el perfil"
            }else{
                render "ok"
            }
        }
    }

    def borrarPerfil_ajax () {
//        println("params " + params)
        def sesion = Sesn.get(params.id)

        try{
            sesion.delete(flush: true)
            render "ok"
        }catch (e){
            println("error al borrar el perfil " + e)
            render "no"
        }
    }

    def personal () {
        def persona = Persona.get(session.usuario.id)
        def condominio = Condominio.get(session.condominio.id)
        def sql = "select * from personas(${condominio?.id}) where prsn__id= ${persona.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())
        return[data: data]
    }

    def deudas_ajax (){

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def persona = Persona.get(session.usuario.id)
        def ingresos = Ingreso.findAllByPersonaAndFechaLessThanEquals(persona,fecha).sort{it.obligacion.descripcion}
        def sql = "select * from pendiente('${fecha.format("yyyy-MM-dd")}') where prsn__id= ${persona.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        return[ingresos: ingresos, pendientes: data]

    }

}
