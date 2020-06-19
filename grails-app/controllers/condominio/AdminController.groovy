package condominio

import org.h2.api.DatabaseEventListener
import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona
import seguridad.Prfl
import seguridad.Sesn
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Admin
 */
class AdminController extends Shield {
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
            def c = Admin.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("observaciones", "%" + params.search + "%")
                }
            }
        } else {
            list = Admin.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return adminInstanceList: la lista de elementos filtrados, adminInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def adminInstanceList = getList(params, false).sort{it.fechaInicio}
        def adminInstanceCount = getList(params, true).size()
        return [adminInstanceList: adminInstanceList, adminInstanceCount: adminInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return adminInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def adminInstance = Admin.get(params.id)
            if(!adminInstance) {
                render "ERROR*No se encontró Admin."
                return
            }
            return [adminInstance: adminInstance]
        } else {
            render "ERROR*No se encontró Admin."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return adminInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def adminInstance = new Admin()
        if(params.id) {
            adminInstance = Admin.get(params.id)
            if(!adminInstance) {
                render "ERROR*No se encontró Admin."
                return
            }
        }
        adminInstance.properties = params
        return [adminInstance: adminInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        println "params: $params"
        def adminInstance = new Admin()
        if(params.id) {
            adminInstance = Admin.get(params.id)
            if(!adminInstance) {
                render "ERROR*No se encontró Admin."
                return
            }
        }
        adminInstance.properties = params
        if(!adminInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Admin: " + renderErrors(bean: adminInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Admin exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def adminInstance = Admin.get(params.id)
            if (!adminInstance) {
                render "ERROR*No se encontró Admin."
                return
            }
            try {
                adminInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Admin exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Admin"
                return
            }
        } else {
            render "ERROR*No se encontró Admin."
            return
        }
    } //delete para eliminar via ajax

    def revisar() {

    }

    def tablaIngresos_ajax () {
//        println("params " + params)
        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        def sql2 = "select * from rev_ingr(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') order by pagodcmt, pago__id"
        def cn2 = dbConnectionService.getConnection()
        def ingresos = cn2.rows(sql2.toString())

        return [desde: fechaDesde, hasta: fechaHasta, ingresos: ingresos]
    }

    def tablaEgresos_ajax () {
//        println("params " + params)
        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        def sql3 = "select * from rev_egrs(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') order by egrsfcha, pgeg__id"
        def cn3 = dbConnectionService.getConnection()
        def egresos = cn3.rows(sql3.toString())

        return [desde: fechaDesde, hasta: fechaHasta, egresos: egresos]
    }


    def comentario_ajax () {

        def ingreso

        if(params.proveedor){
            ingreso = PagoEgreso.get(params.id)
        }else{
            ingreso = Pago.get(params.id)
        }

        return [ingreso: ingreso, dpto: params.departamento, desc: params.descripcion, valor: params.valor, actual: params.estadoActual, comentario: ingreso?.revision, proveedor: params.proveedor]
    }

    def guardarEstadoIngreso_ajax (){

        def item

        if(params.tipo == '1'){
            item = Pago.get(params.id)
        }else{
            item = PagoEgreso.get(params.id)
        }

        if(params.estado){
            item.estado = params.estado
        }
        if(params.comentario){
            item.revision = params.comentario
        }

        if(!item.save(flush:true)){
            println("error al guardar el estado del ingreso/egreso")
            render("NO")
        }else{
            render "OK"
        }
    }

    def guardarRevision_ajax () {
//        println("params " + params)

        def item

        if(params.tipo == '1'){
            item = Pago.get(params.id)
        }else{
            item = PagoEgreso.get(params.id)
        }

        item.estadoAdministrador = (params.estado == 'true' ? 'S' : null)

        if(!item.save(flush: true)){
            render "no"
            println("error al guardar el estado por administrador")
        }else{
            render "ok"
        }
    }

    def showComentario_ajax () {

        def ingreso

        if(params.proveedor){
            ingreso = PagoEgreso.get(params.id)
        }else{
            ingreso = Pago.get(params.id)
        }

        return [ingreso: ingreso, dpto: params.departamento, desc: params.descripcion, valor: params.valor, actual: params.estadoActual, comentario: ingreso?.revision, proveedor: params.proveedor]
    }

    def cerrar_ajax(){

        def administración = Admin.get(params.id)
        def condominio = Condominio.get(session.condominio.id)
//        def sql3 = "select prsnnmbr, prsnapll, prsntelf, prsndpto from prsn, admn where prsn.prsn__id = admn.prsn__id and cndm__id = '${condominio?.id}' and admnfcfn is null"
//        println("sql " + sql3)
//        def cn3 = dbConnectionService.getConnection()
//        def data3 = cn3.rows(sql3.toString())




        return[adminInstance: administración]
    }

    def guardarAdministracion_ajax() {
        println("params " + params)
        def errores = 0
        def anterior = Admin.get(params.id)
        def administrador = Persona.get(params."administrador_name")
        def revisor = Persona.get(params."revisor_name")

        def perfilAdmin = Prfl.findByCodigo('ADC')
        def perfilRev = Prfl.findByCodigo('RVS')
        def perfilUsu = Prfl.findByCodigo('USU')

        def sesionAnteriorAdmin = Sesn.findByUsuarioAndPerfilAndFechaFinIsNull(anterior.administrador,perfilAdmin)
        def sesionAnteriorRev = Sesn.findByUsuarioAndPerfilAndFechaFinIsNull(anterior.revisor,perfilRev)

        def anteriorUsuAdmin = Sesn.findAllByUsuarioAndPerfilAndFechaFinIsNull(anterior.administrador,perfilUsu)
        def anteriorUsuRev = Sesn.findAllByUsuarioAndPerfilAndFechaFinIsNull(anterior.revisor,perfilUsu)


        def fechaActual = new Date().parse("dd-MM-yyyy",params."nuevaFechaInicio_input")
        def fechaAnterior = anterior.fechaInicio

        println("fan " + new Date().parse("dd-MM-yyyy", fechaAnterior.toString()).class)
        println("fac " + fechaActual.class)

        if(fechaAnterior >= fechaActual){
            render "er_Error: La fecha ingresada es menor a la fecha de inicio del período anterior."
        }else{


            //perfiles para usuarios admin-rev anteriores
            if(!anteriorUsuAdmin){
                def sesUsuario = new Sesn()
                sesUsuario.fechaInicio = new Date()
                sesUsuario.perfil = perfilUsu
                sesUsuario.usuario = anterior.administrador

                if(!sesUsuario.save(flush:true)){
                    println("error al guardar nueva sesion de admin anterior")
                    errores = 1
                }else{

                }
            }

            sesionAnteriorAdmin?.fechaFin =  new Date()

            if(!anteriorUsuRev){
                def sesUsuarioRev = new Sesn()
                sesUsuarioRev.fechaInicio = new Date()
                sesUsuarioRev.perfil = perfilUsu
                sesUsuarioRev.usuario = anterior.revisor

                if(!sesUsuarioRev.save(flush:true)){
                    println("error al guardar nueva sesion de revisor anterior")
                    errores = 1
                }else{

                }
            }

            sesionAnteriorRev?.fechaFin = new Date()

            //perfiles nuevos

            def actualUsuAdmin = Sesn.findByUsuarioAndPerfilAndFechaFinIsNull(administrador,perfilAdmin)
            def actualUsuRev = Sesn.findByUsuarioAndPerfilAndFechaFinIsNull(revisor,perfilRev)

            if(!actualUsuAdmin){
                def sesAdminNuevo = new Sesn()
                sesAdminNuevo.fechaInicio = new Date()
                sesAdminNuevo.perfil = perfilAdmin
                sesAdminNuevo.usuario = administrador

                if(!sesAdminNuevo.save(flush:true)){
                    println("error al guardar nueva sesion de admin nuevo")
                    errores = 1
                }
            }

            if(!actualUsuRev){
                def sesRevNuevo = new Sesn()
                sesRevNuevo.fechaInicio = new Date()
                sesRevNuevo.perfil = perfilRev
                sesRevNuevo.usuario = revisor

                if(!sesRevNuevo.save(flush:true)){
                    println("error al guardar nueva sesion de revisor nuevo")
                    errores = 1
                }
            }

            //saldos
            def sql = "select * from saldos(${session.condominio.id}, '${fechaAnterior.format("dd-MM-yyyy")}','${fechaActual.format("dd-MM-yyyy")}')"
            def cn = dbConnectionService.getConnection()
            def data = cn.rows(sql.toString())

            anterior.fechaFin = new Date().parse("dd-MM-yyyy",params."nuevaFechaInicio_input") - 1
            anterior.saldoFinal = (data[0].sldofnal ?: 0)

            if(!anterior.save(flush: true)){
                errores = 1
            }

            if(errores == 0){
                def fecha = fechaActual
                def nuevo = new Admin()
                nuevo.administrador = administrador
                nuevo.revisor = revisor
                nuevo.fechaInicio = fecha
                nuevo.saldoInicial = (data[0].sldofnal ?: 0)
                nuevo.observaciones = params.nuevasObservaciones

                if(!nuevo.save(flush: true)){
                    println("error al guardar el nuevo administrador")
                    render "no"
                }else{
                    render "ok"
                }
            }else{
                render "no"
            }
        }
    }

}
