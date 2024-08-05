package seguridad

import contabilidad.Contabilidad
import utilitarios.Parametros

class LoginController {

    def mail

    def dbConnectionService

    private int borrarAlertas() {
//        def esTriangulo = session.usuario.esTriangulo()
        def fecha = new Date() - 3

        def fechaStr = fecha.format("yyyy-MM-dd")

        def sqlDeleteRecibidos = ""
        def sqlDeleteAntiguos = ""

        def cn = dbConnectionService.getConnection()
        cn.execute(sqlDeleteRecibidos.toString())
        cn.execute(sqlDeleteAntiguos.toString())
        cn.close()

//        return Alerta.withCriteria {
//            if (esTriangulo) {
//                eq("departamento", session.departamento)
//            } else {
//                eq("persona", session.usuario)
//            }
//            isNull("fechaRecibido")
//        }.size()

        0  //retorna numero de alertas

    }

    def conecta(user, pass) {

        def prmt = Parametros.findAll()[0]

        def connect = true
        try {
            println "ingresa..${user.login}"

        } catch (e) {
            println "no conecta ${user.login} error: " + e
            connect = false
        }
        return connect
    }

    def index() {
        redirect(action: 'login')
    }

    def cambiarPass() {
        def usu = Persona.get(session.usuario.id)
        return [usu: usu]
    }

    def validarPass() {
//        println params
        render "No puede ingresar este valor"
    }

    def guardarPass() {
        println "guardarPass: $params"
        def usu = Persona.get(params.id)
        usu.password = params.pass.toString().encodeAsMD5()
        usu.fechaPass = new Date() + 30
        if (!usu.save(flush: true)) {
            println "Error: guardarPass " + usu.errors
            flash.message = "Ha ocurrido un error al guardar su nuevo password"
            flash.tipo = "error"
            redirect(action: 'cambiarPass')
        } else {
//            redirect(controller: "inicio", action: "index")
            redirect(controller: "login", action: "logout")
        }
    }

    def validarSesion() {
        println "sesion creada el:" + new Date(session.getCreationTime()) + " hora actual: " + new Date()
        println "último acceso:" + new Date(session.getLastAccessedTime()) + " hora actual: " + new Date()

        println session.usuario
        if (session.usuario) {
            render "OK"
        } else {
            flash.message = "Su sesión ha caducado, por favor ingrese nuevamente."
            render "NO"
        }
    }

    def olvidoPass() {
        def mail = params.email
        def personas = Persona.findAllByMail(mail)
        def msg
        if (personas.size() == 0) {
            flash.message = "No se encontró un usuario con ese email"
        } else if (personas.size() > 1) {
            flash.message = "Ha ocurrido un error grave (n)"
        } else {
            def persona = personas[0]

            def random = new Random()
            def chars = []
            ['A'..'Z', 'a'..'z', '0'..'9', ('!@$%^&*' as String[]).toList()].each { chars += it }
            def newPass = (1..8).collect { chars[random.nextInt(chars.size())] }.join()

            persona.password = newPass.encodeAsMD5()
            if (persona.save(flush: true)) {
                sendMail {
                    to mail
                    subject "Recuperación de contraseña"
                    body 'Hola ' + persona.login + ", tu nueva contraseña es " + newPass + "."
                }
                msg = "OK*Se ha enviado un email a la dirección " + mail + " con una nueva contraseña."
            } else {
                msg = "NO*Ha ocurrido un error al crear la nueva contraseña. Por favor vuelva a intentar."
            }
        }
        redirect(action: 'login')
    }

    def login() {
        println "login " + params
        def usu = session.usuario
        def cn = "inicio"
        def an = "index"
        if (usu) {
            redirect(controller: cn, action: an)
        }
    }

    def validar() {
        println "valida " + params
        def user = Persona.withCriteria {
            eq("login", params.login, [ignoreCase: true])
            eq("activo", 1)
        }
//        println "usuario: ${user.nombre} pass: ${user.password}"

        if (user.size() == 0) {
            flash.message = "No se ha encontrado el usuario"
            flash.tipo = "error"
        } else if (user.size() > 1) {
            flash.message = "Ha ocurrido un error grave"
            flash.tipo = "error"
        } else {
            user = user[0]

//            println "está activo " + user.estaActivo

            if (!user.estaActivo) {
                flash.message = "El usuario ingresado no esta activo."
                flash.tipo = "error"
                redirect(controller: 'login', action: "login")
                return
            } else {
                println "pone usuario ******************"
                session.usuario = user
//                session.time = new Date()
                session.condominio = user.condominio
                session.departamento = user.departamento

//                println "pone valores " + session.usuario

                def perf = Sesn.findAllByUsuario(user)
                def perfiles = []
                perf.each { p ->
//                    println "añade a perfiles $p activo:${p.estaActivo}"
                    if (p.estaActivo) {
                        perfiles.add(p)
                    }
                }

                if (perfiles.size() == 0) {
                    flash.message = "No puede ingresar porque no tiene ningun perfil asignado a su usuario. Comuníquese con el administrador."
                    flash.tipo = "error"
                    flash.icon = "icon-warning"
                    session.usuario = null
                } else {

//                    println "el md5 del pass: ${params.pass} es ${params.pass.encodeAsMD5()} contraseña: ${user.password}"
                    if (params.pass.encodeAsMD5() != user.password) {
                        flash.message = "Contraseña incorrecta"
                        flash.tipo = "error"
                        flash.icon = "icon-warning"
                        session.usuario = null
                        session.departamento = null
                        redirect(controller: 'login', action: "login")
                        return
                    }


                    if(Persona.get(session.usuario.id).fechaPass < new Date()){
                        redirect(controller: 'login', action: 'cambiarPass')
                        return
                    }


                    if (params.pass.encodeAsMD5() == '202cb962ac59075b964b07152d234b70') {
                        redirect(controller: 'login', action: 'cambiarPass')
                        return
                    }

                    // registra sesion activa ------------------------------
                    //                println  "sesion ingreso: $session.id  desde ip: ${request.getRemoteAddr()}"  //activo
                    def activo = new SesionActiva()
                    activo.idSesion = session.id
                    activo.fechaInicio = new Date()
                    activo.activo = 'S'
                    activo.dirIP = request.getRemoteAddr()
                    activo.login = user.login
                    activo.save()
                    // pone X en las no .... cerradas del mismo login e ip
                    def abiertas = SesionActiva.findAllByLoginAndDirIPAndFechaFinIsNullAndIdSesionNotEqual(session.usuario.login,
                            request.getRemoteAddr(), session.id)
                    if (abiertas.size() > 0) {
                        abiertas.each { sa ->
                            sa.fechaFin = new Date()
                            sa.activo = 'X'
                            sa.save()
                        }
                    }
                    // ------------------fin de sesion activa --------------

                    if (perfiles.size() == 1) {
                        session.usuario.vaciarPermisos()
                        session.perfil = perfiles.first().perfil
//                        session.codigo = perfiles.first().perfil.codigo
                        cargarPermisos()
                        def cn = "inicio"
                        def an = "index"

//                        println "perf: $perfiles"
                        if (perfiles[0].perfil.codigo == 'USU') {
                            redirect(controller: 'persona', action: 'personal')
                            return
                        }

                        def permisos = Prpf.findAllByPerfil(session.perfil)
                        permisos.each {
                            def perm = PermisoUsuario.findAllByPersonaAndPermisoTramite(session.usuario, it.permiso)
                            perm.each { pr ->
                                if (pr.estaActivo) {
                                    session.usuario.permisos.add(pr.permisoTramite)
                                }
                            }
                        }

                        def count = borrarAlertas()
                        if (count > 0) {
                            redirect(controller: 'alertas', action: 'list')
                        } else {
                            redirect(controller: 'inicio', action: 'index')
                        }


                        /** pone contabilidad */
                        def ahora = new Date().clearTime()
//                        def user = Persona.get(session.usuario.id)

                        def cont = Contabilidad.withCriteria {
                            eq("condominio", user.condominio)
                            le("fechaInicio", ahora)
                            ge("fechaCierre", ahora)
                            order("fechaCierre", "desc")
                        }
                        if (cont.size() == 0) {
                            def conts = Contabilidad.findAllByCondominio(user.condominio, [sort: "fechaCierre", order: "desc"])
                            if (conts.size() > 0) {
                                cont = conts[0]
                            }
                        } else if (cont.size() == 1) {
                            cont = cont[0]
                        } else {
                            cont = cont[0]
                        }
                        session.contabilidad = cont
                        println "contabilidad asignada: ${session.contabilidad}"


                        return

                    } else {
                        session.usuario.vaciarPermisos()
                        redirect(action: "perfiles")
                        return
                    }
                }
            }
        }
        redirect(controller: 'login', action: "login")
    }

    def perfiles() {
        def usuarioLog = session.usuario
        def perfilesUsr = Sesn.findAllByUsuario(usuarioLog, [sort: 'perfil'])
        def perfiles = []
        perfilesUsr.each { p ->
            if (p.estaActivo) {
                perfiles.add(p)
            }
        }
        return [perfilesUsr: perfiles]
    }

    def savePer() {
        def sesn = Sesn.get(params.prfl)
        def perf = sesn.perfil

        if (perf) {

            def permisos = Prpf.findAllByPerfil(perf)
//            println "perfil "+perf.descripcion+"  "+perf.codigo
            permisos.each {
//                println "perm "+it.permiso+"  "+it.permiso.codigo
                def perm = PermisoUsuario.findAllByPersonaAndPermisoTramite(session.usuario, it.permiso)
//                println "***************************** " + perm
                perm.each { pr ->
//                    println pr.permisoTramite.descripcion + "  fechas " + pr.fechaInicio + "  " + pr.fechaFin + " " + pr.id + " " + pr.estaActivo
                    if (pr.estaActivo) {
                        session.usuario.permisos.add(pr.permisoTramite)
                    }
                }

            }
            session.perfil = perf
            session.codigo = perf.codigo
            cargarPermisos()

            def ahora = new Date().clearTime()
            def user = Persona.get(session.usuario.id)

            def cont = Contabilidad.withCriteria {
                eq("condominio", user.condominio)
                le("fechaInicio", ahora)
                ge("fechaCierre", ahora)
                order("fechaCierre", "desc")
            }
            if (cont.size() == 0) {
                def conts = Contabilidad.findAllByCondominio(user.condominio, [sort: "fechaCierre", order: "desc"])
                if (conts.size() > 0) {
                    cont = conts[0]
                }
            } else if (cont.size() == 1) {
                cont = cont[0]
            } else {
                cont = cont[0]
            }
            session.contabilidad = cont
            println "contabilidad asignada: ${session.contabilidad}"

            def count = borrarAlertas()
            if (count > 0) {
                redirect(controller: 'alertas', action: 'list')
            } else {//
                redirect(controller: "inicio", action: "index")
            }
//            }
        } else {
            redirect(action: "login")
        }
    }

    def logout() {

        // registra fin de sesion activa --------------
        def activo = SesionActiva.findByIdSesion(session.id)
//        println "sesion out: $session.id, activo: $activo"  //activo
        if (activo) {
            activo.fechaFin = new Date()
            activo.activo = 'N'
            activo.save(flush: true)
//            println "grabando... ${activo.fechaFin}"
        }
        // -------------- fin -------------------------

        session.usuario = null
        session.perfil = null
        session.permisos = null
        session.menu = null
        session.an = null
        session.cn = null
        session.invalidate()

        redirect(controller: 'login', action: 'login')
    }

    def finDeSesion() {

    }

    def cargarPermisos() {
        def permisos = Prms.findAllByPerfil(session.perfil)
//        println "CARGAR PERMISOS  perfil: " + session.perfil + "  " + session.perfil.id
//        println "Permisos:    " + permisos
        def hp = [:]
        permisos.each {
//                println(it.accion.accnNombre+ " " + it.accion.control.ctrlNombre)
            if (hp[it.accion.control.ctrlNombre.toLowerCase()]) {
                hp[it.accion.control.ctrlNombre.toLowerCase()].add(it.accion.accnNombre.toLowerCase())
            } else {
                hp.put(it.accion.control.ctrlNombre.toLowerCase(), [it.accion.accnNombre.toLowerCase()])
            }

        }
        session.permisos = hp
//        println "permisos menu " + session.permisos
    }



}