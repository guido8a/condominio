package contabilidad

import condominio.Condominio
import org.springframework.dao.DataIntegrityViolationException

class CuentaController extends seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST", delete: "GET"]

    def dbConnectionService

    def index() {
        redirect(action: "list", params: params)
    }

    def cuentaResultados() {
//        def cuentas = Cuenta.findAllByNumeroLikeAndMovimiento("3%", "1", [sort: "numero"])
////        Cuenta.findAll("from Cuenta where numero like '3%' and movimiento='1' order by numero ")
//        def cuentaS = Cuenta.findByResultadoAndEmpresa("S", session.empresa)
//        def cuentaD = Cuenta.findByResultado("D", session.empresa)

        def cuentas = Cuenta.withCriteria {
            ilike("numero", "3%")
            eq("movimiento", "1")
            eq("empresa", session.empresa)
        }
        def cuentas1 = Cuenta.withCriteria {
            ilike("numero", "1%")
            eq("movimiento", "1")
            eq("empresa", session.empresa)
        }
        def cuentas2 = Cuenta.withCriteria {
            ilike("numero", "1%")
            eq("movimiento", "1")
            eq("empresa", session.empresa)
        }
        def cuentas5 = Cuenta.withCriteria {
            ilike("numero", "5%")
            eq("movimiento", "1")
            eq("empresa", session.empresa)
        }

        def cuentaS = Cuenta.findByResultadoAndEmpresa("S", session.empresa) // superavit
        def cuentaD = Cuenta.findByResultadoAndEmpresa("D", session.empresa) // deficit
        def cuentaA = Cuenta.findByResultadoAndEmpresa("A", session.empresa) // activos fijos
        def cuentaP = Cuenta.findByResultadoAndEmpresa("P", session.empresa) // depreciacion
        def cuentaG = Cuenta.findByResultadoAndEmpresa("G", session.empresa) // gasto

        return [cuentas: cuentas, cuentas1: cuentas1, cuentas2: cuentas2, cuentas5: cuentas5, cuentaS: cuentaS, cuentaD: cuentaD, cuentaA: cuentaA, cuentaP: cuentaP, cuentaG: cuentaG]
    }

    def grabarCuentaResultado() {
//        println "grabar cuentas resultado " + params

        def supOld = Cuenta.findByResultadoAndEmpresa("S", session.empresa)
        def deficitOld = Cuenta.findByResultadoAndEmpresa("D", session.empresa)

        def activoOld = Cuenta.findByResultadoAndEmpresa("A", session.empresa)
        def depreciacionOld = Cuenta.findByResultadoAndEmpresa("P", session.empresa)
        def gastoOld = Cuenta.findByResultadoAndEmpresa("G", session.empresa)

        def sup = Cuenta.get(params.super)
        if (!supOld || sup.id != supOld.id) {
            if (supOld) {
                supOld.resultado = null
                if (!supOld.save(flush: true)) {
                    println supOld.errors
                }
            }
            sup.resultado = "S"
            if (!sup.save(flush: true)) {
                println sup.errors
            }
        }

        def deficit = Cuenta.get(params.deficit)
        if (!deficitOld || deficit.id != deficitOld.id) {
            if (deficitOld) {
                deficitOld.resultado = null
                if (!deficitOld.save(flush: true)) {
                    println deficitOld.errors
                }
            }
            deficit.resultado = "D"
            if (!deficit.save(flush: true)) {
                println deficit.errors
            }
        }

        def activo = Cuenta.get(params.activo)
        if (!activoOld || activo.id != activoOld.id) {
            if (activoOld) {
                activoOld.resultado = null
                if (!activoOld.save(flush: true)) {
                    println activoOld.errors
                }
            }
            activo.resultado = "A"
            if (!activo.save(flush: true)) {
                println activo.errors
            }
        }

        def depreciacion = Cuenta.get(params.depreciacion)
        if (!depreciacionOld || depreciacion.id != depreciacionOld.id) {
            if (depreciacionOld) {
                depreciacionOld.resultado = null
                if (!depreciacionOld.save(flush: true)) {
                    println depreciacionOld.errors
                }
            }
            depreciacion.resultado = "P"
            if (!depreciacion.save(flush: true)) {
                println depreciacion.errors
            }
        }

        def gasto = Cuenta.get(params.gasto)
        if (!gastoOld || gasto.id != gastoOld.id) {
            if (gastoOld) {
                gastoOld.resultado = null
                if (!gastoOld.save(flush: true)) {
                    println gastoOld.errors
                }
            }
            gasto.resultado = "G"
            if (!gasto.save(flush: true)) {
                println gasto.errors
            }
        }
        flash.message = "Datos guardados"
        redirect(action: 'cuentaResultados')
    }

    def loadForm() {

//        println ">>>>  " + params

        def padreId = params.padre
        def id = params.id

        def cuenta = new Cuenta()
        def padre

        if (id) {
//            println "1"
            cuenta = Cuenta.get(id)
            padre = cuenta.padre
        }
        if (padreId) {
//            println "2"
            padre = Cuenta.get(padreId)
            cuenta.padre = padre
        }

//        println cuenta
//        println cuenta.nivel

        return [cuentaInstance: cuenta]
    }

    def loadTreePart() {
        render(makeTreeNode(params.id))
    }

    String makeTreeNode(id) {
        def condominio = Condominio.get(session.condominio.id)
        String tree = "", clase = "", rel = ""
        Cuenta padre
        Cuenta[] hijos

        if (id == "#") {
            println("aqui ")
            //root
            def hh = Cuenta.countByNivelAndCondominio(Nivel.get(1), condominio, [sort: "numero"])
            if (hh > 0) {
                clase = "hasChildren jstree-closed"
            }
            tree = "<li id='root' class='root ${clase}' data-jstree='{\"type\":\"root\"}' level='0' ><a href='#' class='label_arbol'>Plan de cuentas</a></li>"
        } else if (id == "root") {
            hijos = Cuenta.findAllByNivelAndCondominio(Nivel.get(1), condominio, [sort: "numero"])
        } else {
            def parts = id.split("_")
            def node_id = parts[1].toLong()

            padre = Cuenta.get(node_id)
            if (padre) {
                hijos = Cuenta.findAllByPadreAndCondominio(padre, condominio, [sort: "numero"])
            }
        }

        if (tree == "" && (padre || hijos.size() > 0)) {
            tree += "<ul>"

            hijos.each { hijo ->
                def hijosH = Cuenta.findAllByPadreAndCondominio(hijo, condominio, [sort: "numero"])

                def gestores = Genera.findAllByCuenta(hijo)
                def asientos = Asiento.findAllByCuenta(hijo)

                clase = (hijosH.size() > 0) ? "jstree-closed hasChildren" : ""
                rel = (hijosH.size() > 0) ? "padre" : "hijo"

                if (hijosH.size() > 0 || gestores.size() > 0 || asientos.size() > 0) {
                    clase += " ocupado "
                    if (gestores.size() > 0) {
                        clase += " conGestores "
                    }
                    if (asientos.size() > 0) {
                        clase += " conAsientos "
                    }
                }

                tree += "<li id='li_" + hijo.id + "' class='" + clase + "' data-jstree='{\"type\":\"${rel}\"}' level='" + hijo.nivel.id + "'>"
                tree += "<a href='#' class='label_arbol'>" + hijo + "</a>"
                tree += "</li>"
            }

            tree += "</ul>"
        }

        return tree
    }

    def ajaxSearch() {
//        println "ajax search"
//        println params
        def search = params.search_string
        def ret = "["
        def cuentas
        if (search.size() >= 3) {
            ret += '"#root",'
//            println "BUSCA"
            cuentas = Cuenta.findAllByDescripcionIlikeOrNumeroIlike("%" + search + "%", "%" + search + "%")
//            println "cuentas: " + cuentas
            cuentas.each { cuenta ->
                def p = cuenta.padre
                while (p) {
                    ret += '"#li_' + p.id + '",'
//                    println "\t" + ret
                    p = p.padre
                }
//                ret += '"#li_' + cuenta.id + '",'
//                println ret
            }

            if (ret != "[") {
                ret = ret[0..ret.size() - 2]
            }
        }
        ret += "]"
//        println ret
        render ret
    }

    def list() {
        def condominio = Condominio.get(session.condominio.id)
        def hh = Cuenta.countByNivelAndCondominio(Nivel.get(1), condominio, [sort: "numero"])
        return [hh: hh]
    }

    def list_loadAll() {
        def lvl1 = Cuenta.findAllByNivel(Nivel.get(1), [sort: "numero"]).id

        def res = ""
        res += "<ul>"
        lvl1.each {
            res += imprimeHijos(it)
        }
        res += "</ul>"

        return [res: res]
    }

    def imprimeHijos(padre) {
        def band = true
        def t = ""
        def txt = ""

        def cuenta = Cuenta.get(padre)
        def valor = 0
        def l = Cuenta.findAllByPadre(cuenta);
        l.each {
            band = false;
            t += imprimeHijos(it.id)
        }

        if (!band) {
            def clase = "jstree-open"
            if (cuenta.nivel.id >= 3) {
                clase = "jstree-closed"
            }

            if (l.size() > 0) {
                clase += " hasChildren "
            }

            txt += "<li id='li_" + cuenta.id + "' class='padre " + clase + "' rel='padre'>"
            txt += "<a href='#' class='label_arbol'>" + cuenta + "</a>"
            txt += "<ul>"
            txt += t
            txt += "</ul>"
        } else {
//            println "si band"
            txt += "<li id='li_" + cuenta.id + "' class='hijo jstree-leaf' rel='hijo'>"
            txt += "<a href='#' class='label_arbol'>" + cuenta + "</a>"
        }
        txt += "</li>"
        return txt
    }

    def create() {
        [cuentaInstance: new Cuenta(params)]
    }

    def saveAjax() {
        if (!params.estado) {
            params.estado = 'A'
        }

        println "***" + params

        if (params.impuesto.id) {
            params.retencion = "S"
        }

        def cuentaInstance = new Cuenta(params)

        if (params.id) {
            cuentaInstance = Cuenta.get(params.id)
            cuentaInstance.properties = params
        }
        cuentaInstance.empresa = Empresa.get(session.empresa.id)

        if (!cuentaInstance.save(flush: true)) {
            println cuentaInstance.errors
            render "NO_Error al guardar. Por favor espere...."
        } else {
            def padre = cuentaInstance.padre
            if (padre) {
                padre.movimiento = 0
                padre.auxiliar = 'N'
                if (!padre.save(flush: true)) {
                    println "error al poner movimiento=0 en el padre con id " + padre.id
                }
            }
            if (params.id) {
                render "OK_Cuenta actualizada. Por favor espere...."
            } else {
                render "OK_Cuenta creada. Por favor espere...."
            }
        }
    }

    def save() {
        def cuentaInstance = new Cuenta(params)

        if (params.id) {
            cuentaInstance = Cuenta.get(params.id)
            cuentaInstance.properties = params
        }

        cuentaInstance.empresa = Empresa.get(session.empresa.id)

        if (!cuentaInstance.save(flush: true)) {
            if (params.id) {
                render(view: "edit", model: [cuentaInstance: cuentaInstance])
            } else {
                render(view: "create", model: [cuentaInstance: cuentaInstance])
            }
            return
        }

        if (params.id) {
            flash.message = "Cuenta actualizado"
            flash.tipo = "success"
            flash.ico = "ss_accept"
        } else {
            flash.message = "Cuenta creado"
            flash.tipo = "success"
            flash.ico = "ss_accept"
        }
        redirect(action: "show", id: cuentaInstance.id)
    }

    def show() {
        def cuentaInstance = Cuenta.get(params.id)
        if (!cuentaInstance) {
            flash.message = "No se encontró Cuenta con id " + params.id
            flash.tipo = "error"
            flash.ico = "ss_delete"
            redirect(action: "list")
            return
        }

        [cuentaInstance: cuentaInstance]
    }

    def edit() {
        def cuentaInstance = Cuenta.get(params.id)
        if (!cuentaInstance) {
            flash.message = "No se encontró Cuenta con id " + params.id
            flash.tipo = "error"
            flash.ico = "ss_delete"
            redirect(action: "list")
            return
        }

        [cuentaInstance: cuentaInstance]
    }

    def deleteCuenta() {
        def cuentaInstance = Cuenta.get(params.id)
        if (!cuentaInstance) {
            render("NO_" + "No se encontró cuenta con id " + params.id)
            return
        }

        try {
            cuentaInstance.delete(flush: true)
            render("OK")
        }
        catch (DataIntegrityViolationException e) {
            render("NO_" + "No se pudo eliminar la cuenta con id " + params.id)
        }
    }

    def cargarCuentas() {
        def file = new File("/home/svt/cuentas4-9.csv")
        def empresa = Empresa.get(1)
        file.eachLine {
            def parts = it.split("&")

            // println "parts "+parts
            def cuenta = new Cuenta()
            cuenta.auxiliar = "S"
            cuenta.numero = parts[1].trim()
            cuenta.descripcion = parts[0].trim()
            if (parts[0].trim() == "")
                cuenta.descripcion = "CAMBIAR DESCRIPCION"
            cuenta.estado = "A"
            if (parts[2]) {
                cuenta.padre = Cuenta.findByNumero(parts[2].trim())
                if (!cuenta.padre) {
                    println "no encontro padre wtf"
                }
            } else {
                cuenta.padre = null
            }
            cuenta.movimiento = parts[4]
            cuenta.empresa = empresa
            cuenta.nivel = Nivel.get(Math.ceil(parts[1].size() / 2))
            if (!cuenta.save(flush: true)) {
                println "error " + cuenta.errors
            } else {
                println "save " + cuenta
            }
        }
    }


    def crearDefaults() {
        def emp = Empresa.get(1)
        recursivoCuentas2(null, null, emp, null)
        render "DONE"
    }

    /** se invoca con: recursivoCuentas2(null, null, null, empresa) **/
    def recursivoCuentas2(padreOrigen, padreDestino, empresaOrigen, empresaDestino) {
//        println "inicia recursivo con: $padreOrigen, $padreDestino, $empresaOrigen, $empresaDestino"
        def originales
        if (padreOrigen) {
            if (empresaOrigen) {
                originales = Cuenta.findAllByPadreAndEmpresa(padreOrigen, empresaOrigen)
            } else {
                originales = Cuenta.findAllByPadreAndEmpresaIsNull(padreOrigen)
            }
        } else {
            if (empresaOrigen) {
                originales = Cuenta.findAllByNivelAndEmpresa(Nivel.get(1), empresaOrigen)
            }
        }

        originales.each { cuenta ->
            def esp = ""
            (cuenta.nivelId - 1).times {
                esp += "\t"
            }
//            println esp + cuenta
            def nueva = new Cuenta()
            nueva.properties = cuenta.properties
            if (empresaDestino) {
                nueva.empresa = empresaDestino
            } else {
                nueva.empresa = null
            }
            if (padreDestino) {
                nueva.padre = padreDestino
            } else {
                nueva.padre = null
            }
            if (nueva.save(flush: true)) {
                recursivoCuentas2(cuenta, nueva, empresaOrigen, empresaDestino)
            } else {
                println nueva.errors
            }
        }
    }

    def copiaGestor() {
//        println "inicia copiaGestor"
        def sldo = Gestor.findByCodigo('SLDO')
        def gnraSldo = Genera.findAllByGestor(sldo)

//        println "gnra: $gnraSldo"
        def gstr = new Gestor()
        gstr.properties = sldo.properties
        gstr.save(flush: true)
//        println "... crea gestor de saldos ---"
        gnraSldo.each { gn ->
            def gnra = new Genera()
            gnra.properties = gn.properties
            gnra.cuenta = Cuenta.findByNumero(gn.cuenta.numero)
            gnra.gestor = gstr
            gnra.save(flush: true)
        }
    }

//    def creaSubgrupos() {
//        def empresa = Empresa.get(session.empresa.id)
//        (1..3).each {
//            def sbgr = new SubgrupoItems()
//            def grpo = Grupo.get(it)
//            sbgr.empresa = empresa
//            sbgr.codigo = '001'
//            sbgr.descripcion = "Grupo 1 ${grpo.descripcion}"
//            sbgr.grupo = grpo
//            sbgr.save(flush: true)
//        }
//    }

    def copiarCuentas() {
        def condominio = Condominio.get(session.condominio.id)
        if (Cuenta.countByCondominio(empresa) == 0) {
            recursivoCuentas2(null, null, origen, empresa)
            copiaGestor()
//            creaSubgrupos()
        }
        redirect(action: 'list')
    }

    def show_ajax() {
        if (params.id) {
            def cuentaInstance = Cuenta.get(params.id)
            if (!cuentaInstance) {
                notFound_ajax()
                return
            }
            return [cuentaInstance: cuentaInstance]
        } else {
            notFound_ajax()
        }
    } //show para cargar con ajax en un dialog

    def form_ajax() {
        def condominio = Condominio.get(session.condominio.id)
        def cuentaInstance = new Cuenta(params)
        def hijos = 0
        if (params.id) {
            cuentaInstance = Cuenta.get(params.id)
            if (!cuentaInstance) {
                notFound_ajax()
                return
            }
            hijos = Cuenta.countByPadreAndCondominio(cuentaInstance, condominio)
        } else {
            cuentaInstance.padre = Cuenta.get(params.padre)
            cuentaInstance.nivel = Nivel.get(params.lvl.toInteger() + 1)
            def siblings = Cuenta.findAllByPadreAndCondominio(cuentaInstance.padre, condominio, [sort: "numero"])
            if (siblings) {
                def last = siblings.last()
                def parts = last.numero.split("\\.")
                if (parts.size() > 0) {
                    def next = parts.last().toInteger() + 1
                    def num = ""
                    for (def i = 0; i < parts.size() - 1; i++) {
                        num += parts[i] + "."
                    }
                    num += next.toString().padLeft(2, "0")
                    cuentaInstance.numero = num
                }
            } else {
                cuentaInstance.numero = " "
            }
        }
        return [cuentaInstance: cuentaInstance, hijos: hijos]
    } //form para cargar con ajax en un dialog

    def validarNumero_ajax() {
        def condominio = Condominio.get(session.condominio.id)
        params.numero = params.numero.toString().trim()
        if (params.id) {
            def cuenta = Cuenta.get(params.id)
            if (cuenta.numero == params.numero) {
                render true
                return
            } else {
                render Cuenta.countByNumeroAndCondominio(params.numero, condominio) == 0
                return
            }
        } else {
            render Cuenta.countByNumeroAndCondominio(params.numero, session.condominio) == 0
            return
        }
    }

    def save_ajax() {

//        println("params---> " + params)

        def condominio = Condominio.get(session.condominio.id)

//        params.each { k, v ->
//            if (v != "date.struct" && v instanceof java.lang.String) {
//                params[k] = v.toUpperCase()
//            }
//        }

        params.estado = 'A'
        params.condominio = condominio

        def cuentaInstance
        if (params.id) {
            cuentaInstance = Cuenta.get(params.id)
            if (!cuentaInstance) {
                notFound_ajax()
                return
            }
        }else{
            cuentaInstance = new Cuenta()
        }

        cuentaInstance.properties = params

        if (!cuentaInstance.save(flush: true)) {
//            def msg = "NO_No se pudo ${params.id ? 'actualizar' : 'crear'} Cuenta."
//            msg += renderErrors(bean: cuentaInstance)
//            render msg
//            return
            println("error al guardar la cuenta " + cuentaInstance.errors)
            render "NO_Error al guardar la cuenta"
        }else{
            render "OK_Cuenta guardada correctamente"
        }
//        render "OK_${params.id ? 'Actualización' : 'Creación'} de Cuenta exitosa."
    } //save para grabar desde ajax

    def delete_ajax() {
        if (params.id) {
            def cuentaInstance = Cuenta.get(params.id)
            if (cuentaInstance) {
                try {
                    cuentaInstance.delete(flush: true)
                    render "OK_Eliminación de Cuenta exitosa."
                } catch (e) {
                    render "NO_No se pudo eliminar Cuenta."
                }
            } else {
                notFound_ajax()
            }
        } else {
            notFound_ajax()
        }
    } //delete para eliminar via ajax

    protected void notFound_ajax() {
        render "NO_No se encontró Cuenta."
    } //notFound para ajax

    def buscadorCuentas_ajax () {

    }

    def tablaCuentas_ajax () {
//        println("params " + params)
        def empresa = Empresa.get(session.empresa.id)

        def res = Cuenta.withCriteria {
            eq("empresa",empresa)
            and{
                ilike("descripcion", "%" + params.desc + "%")
                ilike("numero", "%" + params.numero + "%")
            }
            order("numero","asc")
        }
        return[cuentas: res]
    }

    def padre_ajax () {
        def padreActual = Cuenta.get(params.nodo).padre
        def cn = dbConnectionService.getConnection()
        def cuenta = Cuenta.get(params.nodo)
        def empresa = Empresa.get(session.empresa.id)
//        def sql = "select * from cnta where cnta__id in (select cntapdre from cnta where empr__id = ${empresa?.id}) order by cntanmro;"
        def sql = "select padre.cntapdre abuelo, padre.cnta__id, padre.cntanmro padre, abuelo.cntanmro ablonmro, " +
                "abuelo.cntadscr ablodscr from cnta, cnta padre, cnta abuelo where cnta.cnta__id = ${cuenta?.id} and padre.cnta__id = cnta.cntapdre and abuelo.cnta__id = padre.cntapdre;"
        def res = cn.rows(sql.toString());
//        def filtrada = res.cnta__id - padreActual.id
//        def todas = Cuenta.findAllByIdInList(filtrada).sort{it.numero}
        println("res " + res.first())

//        return[padres: todas]
        return[padres: res]

    }

    def cambiarPadre_ajax () {
        println("params " + params)
        def cuenta = Cuenta.get(params.cuenta)
        def nuevoPadre = Cuenta.get(params.padre)

//        cuenta.padre = nuevoPadre
//
//        try{
//            cuenta.save(flush: true)
//            render "ok"
//        }catch (e){
//            println("error al cambiar de padre " + e)
//            render "no"
//        }

    }

}
