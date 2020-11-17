package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Ingreso
 */
class IngresoController extends Shield {

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
            def c = Ingreso.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                            ilike("documento", "%" + params.search + "%")  
                            ilike("estado", "%" + params.search + "%")  
                            ilike("observaciones", "%" + params.search + "%")  
                }
            }
        } else {
            list = Ingreso.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return ingresoInstanceList: la lista de elementos filtrados, ingresoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def ingresoInstanceList = getList(params, false)
        def ingresoInstanceCount = getList(params, true).size()
        return [ingresoInstanceList: ingresoInstanceList, ingresoInstanceCount: ingresoInstanceCount]
    }

    /**
     * Acción que muestra la lista de elementos
     * @return ingresoInstanceList: la lista de elementos filtrados, ingresoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def pendiente() {
//        println "params: $params"
        def prsn = Persona.get(params.id)
        def condominio = Condominio.get(session.condominio.id)
        def ingr = Ingreso.findAllByPersona(prsn, [sort: 'fecha'])
        def sql = "select * from personas(${condominio?.id}) where prsn__id= ${prsn.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())
        return [ingreso: ingr, ingrCount: ingr.size(), persona: prsn, data:data]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return ingresoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def ingresoInstance = Ingreso.get(params.id)
            if(!ingresoInstance) {
                render "ERROR*No se encontró Ingreso."
                return
            }
            return [ingresoInstance: ingresoInstance]
        } else {
            render "ERROR*No se encontró Ingreso."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return ingresoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
/*
        def ingreso = new Ingreso()
        def prsn = Persona.get(params.id)
        if(prsn) {
            def ingr = Ingreso.findByPersona(prsn)
            if(alct){
                alicuota = alct
            }
        }
        alicuota?.properties = params
        return [alicuotaInstance: alicuota, persona: prsn]
*/
        def ingresoInstance = new Ingreso()
        if(params.id) {
            ingresoInstance = Ingreso.get(params.id)
            if(!ingresoInstance) {
                render "ERROR*No se encontró Ingreso."
                return
            }
        }
        ingresoInstance.properties = params
        return [ingresoInstance: ingresoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def ingresoInstance = new Ingreso()
        if(params.id) {
            ingresoInstance = Ingreso.get(params.id)
            if(!ingresoInstance) {
                render "ERROR*No se encontró Ingreso."
                return
            }
        }
        params.abono = params.abono.toDouble()
        ingresoInstance.properties = params
        if((ingresoInstance.estado == 'E') && Math.abs(ingresoInstance.valor - ingresoInstance.abono) <= 0.001) {
            ingresoInstance.estado = 'P'
        } else if((ingresoInstance.estado == 'E') && (ingresoInstance.abono > 0)) {
            ingresoInstance.estado = 'A'
        }
        if(!ingresoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Ingreso: " + renderErrors(bean: ingresoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Ingreso exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def ingresoInstance = Ingreso.get(params.id)
            if (!ingresoInstance) {
                render "ERROR*No se encontró Ingreso."
                return
            }
            try {
                if(ingresoInstance.estado == 'E') {
                    ingresoInstance.delete(flush: true)
                    render "SUCCESS*Eliminación de Ingreso exitosa."
                    return
                } else {
                    render "ERROR*No es posible borrar un valor pendiente de pago"
                    return
                }
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Ingreso"
                return
            }
        } else {
            render "ERROR*No se encontró Ingreso."
            return
        }
    } //delete para eliminar via ajax


    def pago_ajax () {
        println "--> $params"
        def cn = dbConnectionService.getConnection()
        def pago
        def tx = ""
        def mora = 0, mess = 0
        def ingreso = Ingreso.get(params.id)
        tx = "select ingrintr, mess from pendiente(now()::date, ${ingreso.persona.edificio.id}) " +
                "where ingr__id = ${params.id}"
        println "sql: $tx"
        cn.eachRow(tx.toString()) { d ->
            mora = d.ingrintr
            mess = d.mess
        }
        println "---> mora: $mora, meses: $mess"

        if(params.pago){
            pago = Pago.get(params.pago)
        }

        def pagos = Pago.findAllByIngreso(ingreso)
        def saldo = (ingreso.valor - (pagos?.valor?.sum() ?: 0))
        def dscr  = "${ingreso.observaciones?: ingreso?.obligacion?.descripcion}"

        return[ingreso: ingreso, pagos: pagos, saldo: saldo, pago: pago, dscr: dscr, mora: mora, mess: mess]
    }


    def guardarPago_ajax (){
        println("guardarPago_ajax: " + params)
        def condominio = Condominio.get(session.condominio.id)
        def ingreso = Ingreso.get(params.ingreso)
        def pagos = Pago.findAllByIngreso(ingreso)
        def saldo = ingreso.valor - (pagos?.valor?.sum() ?: 0)
        def saldo2
        def pago, mess
        def band = 0
        def band2 = 0

        saldo = Math.round(saldo*100)/100
        if(params.id){
            pago = Pago.get(params.id)
            saldo2 = saldo + (pago.valor ? pago.valor.toDouble() : 0)
            println "saldo2: $saldo2, pago: ${params.abono.toDouble()}"
            if(params.abono.toDouble() > saldo2){
                render "er_El abono ingresado supera el valor del saldo"
                return
            }
        }else{
            println "saldo: $saldo, pago: ${params.abono.toDouble()}"
            if(params.abono.toDouble() > saldo){
                render "er_El abono ingresado supera el valor del saldo"
                return
            }
        }

        if(params.id){
            pago = Pago.get(params.id)
        }else{
            pago = new Pago()
        }

        params.fecha = new Date().parse("dd-MM-yyyy", params.fechaPago_input)

        pago.ingreso = ingreso
        pago.valor = params.abono.toDouble()
        pago.fechaPago = params.fecha
        pago.documento = params.documento
        pago.observaciones = params.observaciones
        mess = params.mess.toInteger()
        pago.transferencia = params.transferencia == 'SI' ? 'S' :'N'

        if(mess > 2) {
            pago.mora = params.mora.toDouble()
            pago.tasa = 8.0  //todo -> obtener ta de parámetros geenrales del sistema
            pago.mess = mess
        }

        if(!pago.save(flush: true)){
            println("error al guardar el pago " + pago.errors)
            band = 0
        }else{
            band = 1
        }

        if(condominio?.comprobante == 'S'){
            if(band == 1){
                if(params.id){
                    render "er_Ya existe un pago, no es posible generar un comprobante"
                }else{

                    def talonarioActual = Talonario.findByCondominioAndEstado(condominio,'V')

                    if(talonarioActual){

//                        def existen = Comprobante.findAllByCondominio(condominio)
                        def numero

//                        if(existen){
//                            numero = existen.numero.max() + 1
//                        }else{
//
//                            numero = (condominio.numero == 0 ? 1 : condominio.numero)
//                        }

                        numero = talonarioActual.numeroFin == 0 ?  talonarioActual.numeroInicio : (talonarioActual.numeroFin +1)


                        def comprobante = new Comprobante()
                        comprobante.condominio = condominio
                        comprobante.pago = pago
                        comprobante.texto = Texto.findByCodigo('CMPR').parrafoUno ?: ''
                        comprobante.fecha = new Date()
                        comprobante.estado = 'V'
                        comprobante.numero = numero

                        if(!comprobante.save(flush:true)){
                            println("error al guardar el comprobante " + comprobante.errors)
                            render "er_Error al guardar el comprobante"
                        }else{
                            talonarioActual.numeroFin = numero
                            talonarioActual.save(flush:true)
                            render "ok"
                        }

                    }else{
                        render "er_No existe un talonario digital creado, no es posible generar un comprobante"
                        return
                    }
                }
            }else{
                render "no"
            }
        }else{
            if(band == 1){
                render "ok"
            }else{
                render "no"
            }
        }



    }

    def borrarPago_ajax () {
        def pago = Pago.get(params.id)

        try{
            pago.delete(flush: true)
            render "ok"
        }catch (e){
            println("error al borrar el pago " + e)
            render "no"
        }
    }

    def obligaciones_ajax () {
        println("params " + params)

        def persona = Persona.get(params.persona)
        def ingresos= Ingreso.findAllByPersona(persona).sort{it.fecha}

        def sql = "select * from pagos(${persona?.id}) "
        if(!params.band) {
            sql += "order by pagofcha desc"
        } else {
            sql += "where coalesce(pagofcha, now()::date) > now()::date - 180 order by ingrsldo desc, ingrfcha"
        }
        println("sql " + sql)

        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        return[ingreso: data, band: params.band]
    }

    def pagos_ajax () {
        def ingreso = Ingreso.get(params.ingreso)
        def pagos = Pago.findAllByIngreso(ingreso)

        def saldo = Math.round(ingreso?.valor*100)/100 - Math.round((pagos.valor?.sum() ?: 0) * 100)/100

        return[ingreso: ingreso, pagos: pagos, saldo: saldo]
    }

    def ingresos () {

    }


    def tablaBuscar() {
        println "buscar .... $params"
        def cn = dbConnectionService.getConnection()
        params.old = params.criterio
        params.criterio = buscadorService.limpiaCriterio(params.criterio)
        params.ordenar  = buscadorService.limpiaCriterio(params.ordenar)

        def sql = armaSql(params)
        params.criterio = params.old
        println "sql: $sql"
        def data = cn.rows(sql.toString())

        def msg = ""
/*
        if(data?.size() > 50){
            data.pop()   //descarta el último puesto que son 21
            msg = "<div class='alert-danger' style='margin-top:-20px; diplay:block; height:25px;margin-bottom: 20px;'>" +
                    " <i class='fa fa-warning fa-2x pull-left'></i> Su búsqueda ha generado más de 30 resultados. " +
                    "Use más letras para especificar mejor la búsqueda.</div>"
        }
*/
        cn.close()

        return [data: data, msg: msg, fcds: params.desde]
    }

    def armaSql(params){
//        println "armaSql: $params"
        def campos = buscadorService.parmIngr()
        def operador = buscadorService.operadores()
        //condicion fija
        def wh = " ingr__id is not null "
        def fcds = "null"
        def fchs = "null"
        if(params.desde) fcds = "'" + new Date().parse("dd-MM-yyyy",params.desde).format('yyyy-MM-dd') + "'"
        if(params.hasta) fchs = "'" + new Date().parse("dd-MM-yyyy",params.hasta).format('yyyy-MM-dd') + "'"

//        def sqlSelect = "select * from ls_egrs(${session.empresa.id}, ${cont}, ${fcds}, ${fchs}) "
        def sqlSelect = "select * from ls_ingr(${session.condominio.id}, ${fcds}, ${fchs}) "
        def sqlWhere = "where (${wh})"
        def sqlOrder = "order by ingrfcha, ${params.ordenar}"
//        println "sql: $sqlSelect $sqlWhere $sqlOrder"

//        println "operador: $operador"
        if(params.operador && params.criterio) {
            if(campos.find {it.campo == params.buscador}?.size() > 0) {
                def op = operador.find {it.valor == params.operador}
                sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
            }
        }
        if(params.tpap.toInteger() > 0) {
            sqlWhere += " and tpap__id = ${params.tpap} "
        }

//        println "-->sql: $sqlSelect $sqlWhere $sqlOrder"
        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }

    def pagoIngreso_ajax  () {
        def ingreso = Ingreso.get(params.egreso)
        def pagos = Pago.findAllByIngreso(ingreso).sort{it.fechaPago}

//        def saldo = Math.round(egreso?.valor?:0*100)/100 - Math.round((pagos?.valor?.sum() ?: 0) * 100)/100
        def saldo = (ingreso?.valor ?: 0) - (pagos?.valor?.sum() ?: 0)

        return[egreso: ingreso, pagos: pagos, saldo: saldo]
    }

    def infoIngreso_ajax() {

//        println("params ii " + params)

        def ingreso = Ingreso.get(params.ingreso)
        def pagos = Pago.findAllByIngreso(ingreso)
        return[ingreso: ingreso, saldo: params.saldo, valor: params.valor, pagos: pagos]
    }

    def comprobantes_ajax(){
    def pago = Pago.get(params.id)
//        def comprobante

    }

}
