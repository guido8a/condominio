package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield
import utilitarios.Anio


/**
 * Controlador que muestra las pantallas de manejo de Egreso
 */
class EgresoController extends Shield {

    def dbConnectionService
    def buscadorService

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
            def c = Egreso.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                }
            }
        } else {
            list = Egreso.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return egresoInstanceList: la lista de elementos filtrados, egresoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        println "egrsos: $params"
        params.sort = 'fecha'
        def egresoInstanceList = getList(params, false)
//        def egresoInstanceList = getList(params, [sort: 'fecha'])
        def egresoInstanceCount = getList(params, true).size()
        return [egresoInstanceList: egresoInstanceList, egresoInstanceCount: egresoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return egresoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def egresoInstance = Egreso.get(params.id)
            if(!egresoInstance) {
                render "ERROR*No se encontró Egreso."
                return
            }
            return [egresoInstance: egresoInstance]
        } else {
            render "ERROR*No se encontró Egreso."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return egresoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def egresoInstance = new Egreso()
        def proveedores = Proveedor.findAllByCondominio(session.condominio, [sort: 'nombre'])
        def pago

        if(params.id) {
            egresoInstance = Egreso.get(params.id)
            if(!egresoInstance) {
                render "ERROR*No se encontró Egreso."
                return
            }
            pago = PagoEgreso.findByEgreso(egresoInstance)
        }
        println "pago: $pago"
        egresoInstance.properties = params
        return [egresoInstance: egresoInstance, proveedores: proveedores, pago: pago]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        println "params: $params"
        def egresoInstance = new Egreso()
        def pagos

        if(params.id) {
            egresoInstance = Egreso.get(params.id)
            if(!egresoInstance) {
                render "ERROR*No se encontró Egreso."
                return
            }
            pagos = PagoEgreso.findAllByEgreso(egresoInstance)
        }  else {
            egresoInstance.fecha = new Date()
            egresoInstance.estado = 'E'
        }
        params.valor = params.valor.toDouble()
        egresoInstance.properties = params

        if(params.valor.toDouble() >= pagos?.valor?.sum()){
            if(egresoInstance.save(flush: true)) {
                if(params.pagar && !pagos){
                    println("entro")
                    pagos = new PagoEgreso()
                    pagos.egreso = egresoInstance
                    pagos.fechaPago = egresoInstance.fecha
                    pagos.valor = egresoInstance.valor
                    pagos.observaciones = egresoInstance.descripcion
                    pagos.cheque = params.pg_chqe
                    pagos.documento = params.pg_cmpr
                    pagos.cajaChica = params.pagar_CC
                    pagos.save(flush: true)
                }
                render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Egreso exitosa."
                return
            } else {
                render "ERROR*Ha ocurrido un error al guardar Egreso: " + renderErrors(bean: egresoInstance)
                return
            }
            render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Egreso exitosa."
            return
        } else {
            render "ERROR*El valor ingresado es menor al valor de los pagos"
            return
        }
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def egresoInstance = Egreso.get(params.id)
            if (!egresoInstance) {
                render "ERROR*No se encontró Egreso."
                return
            }
            try {
                egresoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Egreso exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Egreso"
                return
            }
        } else {
            render "ERROR*No se encontró Egreso."
            return
        }
    } //delete para eliminar via ajax

    def pagoEgreso_ajax () {

        def pago
        def egreso = Egreso.get(params.id)
        if(params.pago){
            pago = PagoEgreso.get(params.pago)
        }
        def pagos = PagoEgreso.findAllByEgreso(egreso)
        def saldo = (egreso.valor - (pagos?.valor?.sum() ?: 0))

        return[egreso: egreso, pagos: pagos, saldo: saldo, pago: pago]
    }

    def guardarPagoEgreso_ajax () {

        //        println("params " + params)

        def egreso = Egreso.get(params.egreso)
        def pagos = PagoEgreso.findAllByEgreso(egreso)
        def saldo = (egreso.valor - (pagos?.valor?.sum() ?: 0))
        def saldo2
        def pago

        if(params.id){
            pago = PagoEgreso.get(params.id)
            saldo2 = saldo + (pago.valor ? pago.valor.toDouble() : 0)
            if(params.abono.toDouble() > saldo2){
                render "di"
                return
            }
        }else{
            if(params.abono.toDouble() > saldo){
                render "di"
                return
            }
        }



        if(params.id){
            pago = PagoEgreso.get(params.id)
        }else{
            pago = new PagoEgreso()
        }

        params.fecha = new Date().parse("dd-MM-yyyy", params.fechaPago_input)

        pago.egreso = egreso
        pago.valor = params.abono.toDouble()
        pago.fechaPago = params.fecha
        pago.documento = params.documento.toUpperCase();
        pago.cheque = params.cheque.toUpperCase();
        pago.observaciones = params.observaciones
        pago.cajaChica = params.pagar_CC

        if(!pago.save(flush: true)){
            println("error al guardar el pago " + pago.errors)
            render "no"
        }else{
            render "ok"
        }
    }


    def borrarPagoEgreso_ajax () {
        def pago = PagoEgreso.get(params.id)

        try{
            pago.delete(flush: true)
            render "ok"
        }catch (e){
            println("error al borrar el pago " + e)
            render "no"
        }
    }

    def borrarEgreso_ajax () {
        def egreso = Egreso.get(params.id)
        def pagos = PagoEgreso.findAllByEgreso(egreso)

        if(!pagos){
            try{
                egreso.delete(flush: true)
                render "ok"
            }catch (e){
                println("error al borrar el egreso " + e)
                render "no"
            }
        }else{
            render "di"
        }
    }

    def saldos() {

    }

    def tablaSaldos_ajax () {

//        println("params " + params)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

//        println "fechas: '${fechaDesde}','${fechaHasta}'"
        //saldos
        def sql = "select * from saldos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') "
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())
        println "....sql: $sql"

        def sql2 = "select * from aportes(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') " +
                "order by pagodcmt, ingrfcha"
        def cn2 = dbConnectionService.getConnection()
        def ingresos = cn2.rows(sql2.toString())
        println "ingr...sql: $sql2"

        def sql3 = "select * from egresos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') order by egrsfcha"
        def cn3 = dbConnectionService.getConnection()
        def egresos = cn3.rows(sql3.toString())
        println "egrs ...sql: $sql3"

        def totalMora = (ingresos.pagomora.sum() ?: 0)
        def totalIngresos = (ingresos.pagovlor.sum() ?: 0)
        def totalEgresos = (egresos.egrsvlor.sum() ?: 0)

        return [data: data, desde: fechaDesde, hasta: fechaHasta, totalIngresos: totalIngresos, totalEgresos: totalEgresos,
                ingresos: ingresos, egresos: egresos, totalMora: totalMora]
    }

    def tablaIngresos_ajax () {

        def sql2 = "select * from aportes(${session.condominio.id}, ${session.condominio.id}, '${params.desde}','${params.hasta}') order by egrsfcha"
        def cn2 = dbConnectionService.getConnection()
        def ingresos = cn2.rows(sql2.toString())

        return [ingresos: ingresos]
    }

    def tablaEgresos_ajax () {
        def sql3 = "select * from egresos(${session.condominio.id}, '${params.desde}','${params.hasta}')"
        def cn3 = dbConnectionService.getConnection()
        def egresos = cn3.rows(sql3.toString())

        return[egresos: egresos]
    }

    def egresos_ajax () {
        def egresos = Egreso.list().sort{it.descripcion}
        return[egresos: egresos]
    }

    def pagoEgresos_ajax  () {
        def egreso = Egreso.get(params.egreso)
        def pagos = PagoEgreso.findAllByEgreso(egreso).sort{it.fechaPago}

//        def saldo = Math.round(egreso?.valor?:0*100)/100 - Math.round((pagos?.valor?.sum() ?: 0) * 100)/100
        def saldo = (egreso?.valor ?: 0) - (pagos?.valor?.sum() ?: 0)

        return[egreso: egreso, pagos: pagos, saldo: saldo]
    }

    def egresos() {
        params.ordenar = "prsndpto"
    }

    def tablaBuscar() {
//        println "buscar .... $params"
        def cn = dbConnectionService.getConnection()
        params.old = params.criterio
        params.criterio = buscadorService.limpiaCriterio(params.criterio)
        params.ordenar  = buscadorService.limpiaCriterio(params.ordenar)

        def sql = armaSql(params)
        params.criterio = params.old
        println "sql: $sql"
        def data = cn.rows(sql.toString())

        def msg = ""
        if(data?.size() > 50){
            data.pop()   //descarta el último puesto que son 21
            msg = "<div class='alert-danger' style='margin-top:-20px; diplay:block; height:25px;margin-bottom: 20px;'>" +
                    " <i class='fa fa-warning fa-2x pull-left'></i> Su búsqueda ha generado más de 30 resultados. " +
                    "Use más letras para especificar mejor la búsqueda.</div>"
        }
        cn.close()

        return [data: data, msg: msg, fcds: params.desde]
    }

    def armaSql(params){
//        println "armaSql: $params"
        def campos = buscadorService.parmEgrs()
        def operador = buscadorService.operadores()
        //condicion fija
        def wh = " egrs__id is not null "
        def fcds = "null"
        def fchs = "null"
        if(params.desde) fcds = "'" + new Date().parse("dd-MM-yyyy",params.desde).format('yyyy-MM-dd') + "'"
        if(params.hasta) fchs = "'" + new Date().parse("dd-MM-yyyy",params.hasta).format('yyyy-MM-dd') + "'"

//        def sqlSelect = "select * from ls_egrs(${session.empresa.id}, ${cont}, ${fcds}, ${fchs}) "
        def sqlSelect = "select * from ls_egrs(${session.condominio.id}, ${fcds}, ${fchs}) "
        def sqlWhere = "where (${wh})"
        def sqlOrder = "order by egrsfcha, ${params.ordenar} limit 51"
//        println "sql: $sqlSelect $sqlWhere $sqlOrder"

//        println "operador: $operador"
        if(params.operador && params.criterio) {
            if(campos.find {it.campo == params.buscador}?.size() > 0) {
                def op = operador.find {it.valor == params.operador}
                sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
            }
        }
        if(params.saldo == 'true') {
            sqlWhere += " and egrssldo > 0 "
        }

//        println "-->sql: $sqlSelect $sqlWhere $sqlOrder"
        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }

    def costos_ajax(){
        def meses = [1:"Enero",2:"Febrero",3:'Marzo',4:'Abril',5:'Mayo',6:'Junio',7:'Julio',8:'Agosto',9:'Septiembre',10:'Octubre',11:'Noviembre',12:'Diciembre']
        return[meses:meses]
    }

    def guardarCostosBancarios_ajax() {
        println("params " + params)
        def anio = Anio.get(params.anio)
        def condominio = Condominio.get(session.condominio.id)
        def cn = dbConnectionService.getConnection()
        def sql ="select * from transferencias(${condominio?.id},${params.mes},${anio.numero},52);"
        def data = cn.rows(sql.toString())

//        println("data " + data[0].transferencias)

        if(data == null){
            println("error al guardar el costo bancario ")
            render "no"
        }else{
            render "ok_" + data[0].transferencias
        }

    }




}
