package condominio

import contabilidad.Contabilidad
import org.hibernate.criterion.MatchMode
import seguridad.Persona
import seguridad.Shield
import utilitarios.Parametros

class ViviendaController extends Shield {

    def dbConnectionService
    def buscadorService
    def procesoService

    def index() {

//        println "busqueda "
        def condominio = Parametros.get(1)
        params.ordenar = "prsndpto"
        def torres = Edificio.findAllByCondominio(session.usuario.condominio)
        torres.add([id:0, descripcion: 'Todas...'])

        println "actual: ${params}"
        return[condominio: condominio, torres: torres, actual: params.edif]
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
                    " <i class='fa fa-warning fa-2x pull-left'></i> Su búsqueda ha generado más de 50 resultados. " +
                    "Use más letras para especificar mejor la búsqueda.</div>"
        }
        cn.close()

        return [data: data, msg: msg]
    }

    def armaSql(params){
//        println "armaSql: $params"
        def campos = buscadorService.parmProcesos()
        def operador = buscadorService.operadores()
//        def wh = " edif.edif__id = prsn.edif__id and tpoc.tpoc__id = prsn.tpoc__id and prsnactv = 1 " //condicion fija
        def condominio

        if (params.condo){
            condominio = Condominio.get(params.condo)
        }else{
            condominio = Condominio.get(session.condominio.id)
        }

        def sqlSelect = "select * from personas(${condominio?.id}) "
        if(session.perfil.codigo == 'ADM') {
            sqlSelect = "select * from admin(${condominio?.id}) "
        }

        //condicion fija
        def wh = " prsn__id is not null "


        def sqlWhere = "where (${wh})"

        def sqlOrder = "order by ${params.ordenar} limit 51"

//        println "sql: $sqlSelect $sqlWhere $sqlOrder"
//        if(params.criterio) {
        if(params.operador && params.criterio) {
            if(campos.find {it.campo == params.buscador}?.size() > 0) {
                def op = operador.find {it.valor == params.operador}
                sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
            }
        }
        if(params.edif != 'Todas...') {
            sqlWhere += " and edifdscr = '${params.edif}' ";
        }
//        println "-->sql: $sqlSelect $sqlWhere $sqlOrder"
        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }

    def creaIngresos() {

    }

    def tabla() {
        println "tabla " + params
        def oblg = Obligacion.get(params.oblg)
        def sql = "select * from ingresos( ${session.condominio.id}, ${oblg.id}) order by prsndpto"
        println("sql " + sql)
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        def administracion = Admin.findByFechaFinIsNull()
        def fecha = administracion.fechaInicio + 90

        def band = new Date().before(fecha)

//        println "fecha: $fecha"
//        println "data: $data"
//        println "params: $params"
//        println "band: $band"
//        println "oblg: $oblg"
        [personas: data, params: params, oblg: oblg, band: band]
    }

    def actualizar() {
        println "actualizar $params"
        def contabilidad = Contabilidad.get(session.contabilidad.id)
        if (params.item instanceof java.lang.String) {
            params.item = [params.item]
        }
        if (params.obsr instanceof java.lang.String) {
            params.obsr = [params.obsr]
        }

        def oks = "", nos = ""

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha);
        println "fecha: $fecha"

        def oblg = Obligacion.get(params.oblg)

        println "oblg: ${oblg.id}"

        if(params.item) {
            params.item.each {
                def parts = it.split("_")

                def prsnId = parts[0]
                def valor  = parts[1].toDouble()
                def ingr   = parts[2]
                def obsr = null
                if(it.contains('_ob')) {
                    obsr   = parts[3]
                    if(obsr.size() > 2) {
                        obsr = obsr[2..-1]
                    } else {
                        obsr = null
                    }
                }

                if(ingr.size() > 2) {
                    ingr = ingr[2..-1]
                } else {
                    ingr = null
                }

                def ingreso = Ingreso.get(ingr);

                if (!ingreso) {
                    ingreso = new Ingreso()
                    ingreso.persona = Persona.get(prsnId)
                    ingreso.obligacion = oblg
                    ingreso.valor = valor
//                    ingreso.fecha = new Date()
                    ingreso.fecha = fecha
                } else {
                    ingreso.valor = valor
                    ingreso.fecha = fecha
                    ingreso.estado = 'M'
                }

                if(obsr) ingreso.observaciones = obsr

                if (!ingreso.save(flush: true)) {
                    println "error $parts, --> ${ingreso.errors}"
                    if (nos != "") {
                        nos += ","
                    }
                    nos += "#" + prsnId
                } else {

/* "select * from generar(${pago?.id}, tpcp__id=3, tpap__id=1, tpgs__id=null, ${contabilidad?.id})" */
                    def sql = "select * from generar(${ingreso?.id}, 3, 1, null, ${contabilidad?.id})"
                    def cn = dbConnectionService.getConnection()
                    cn.execute(sql.toString())

                    if (oks != "") {
                        oks += ","
                    }
                    oks += "#" + prsnId
                }

            }

        }

        def obsr
        def id
        if(params.obsr){
            params.obsr.each {
                def p_obsr = it.split("_")
                id = p_obsr[0]
                def ingr   = p_obsr[1]
                if(ingr.size() > 2) {
                    ingr = ingr[2..-1]
                } else {
                    ingr = null
                }

                obsr = p_obsr[2]
                if(obsr.size() > 2) {
                    obsr = obsr[2..-1]
                } else {
                    obsr = null
                }
                println "id: $id, ingr: $ingr, obsr: $obsr"

                def ingreso = Ingreso.get(ingr);

                if (!ingreso) {
                    println "crea ingreso"
                    ingreso = new Ingreso()
                    ingreso.persona = Persona.get(id)
                    ingreso.fecha = fecha
                    ingreso.observaciones = obsr
                } else {
                    println "edita ingreso ${ingreso.id}"
                    ingreso.observaciones = obsr
                    ingreso.fecha = fecha
                }

                if (!ingreso.save(flush: true)) {
                    println "error $p_obsr, --> ${ingreso.errors}"
                    if (nos != "") {
                        nos += ","
                    }
                    nos += "#" + id
                } else {

                    def sql = "select * from generar(${ingreso?.id}, 3, 1, null, ${contabilidad?.id})"
                    def cn = dbConnectionService.getConnection()
                    cn.execute(sql.toString())

                    if (oks != "") {
                        oks += ","
                    }
                    oks += "#" + id
                }
            }
        }

        render oks + "_" + nos
    }

    def generar_ajax () {

    }

    def genera () {
        println "params: ${params.fecha}"
        def fc = params.fecha.split('-').toList()
        def fecha = new Date().parse("dd-MM-yyyy", "1-${fc[1]}-${fc[2]}")
        def mesNumero = params.fecha.split("-")[1]
        def anio = params.fecha.split("-")[2]

        def meses = ["", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
        def mes = meses[mesNumero.toInteger()]

        def observacion = mes + " " + anio
//        println("obsr: " + observacion)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from alicuota(${session.condominio.id}, '${fecha.format('yyyy-MM-dd')}','${observacion}')"
//        println "sql: $sql"

        def res = cn.rows(sql.toString())

        if(res[0].alicuota == 0){
            render "no"
        } else {
            render "ok"
        }
    }

    def comboMes_ajax () {

//        println("params " + params)
        def mesNumero = params.fecha.split("-")[1]
        def meses = ["", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
        def mes = meses[mesNumero.toInteger()]

        return[mes: mes]
    }

    def obligaciones_ajax () {
        def condominio = Condominio.get(session.condominio.id)
        def tipoAporte = TipoAporte.get(params.tipoAporte)
        def obligaciones = Obligacion.findAllByTipoAporteAndCondominio(tipoAporte, condominio)

        return[obligaciones: obligaciones]
    }


    def borrarRegistro_ajax () {

//        println("params bi " + params)

        def persona = Persona.get(params.persona)
        def obligacion = Obligacion.get(params.obligacion)

        def ingreso = Ingreso.findByObligacionAndPersona(obligacion, persona)

        ingreso.valor = 0

        try{
            ingreso.save(flush: true)
            render "ok"
        }catch (e){
            println("error al modificar el ingreso " + e + " " + ingreso?.errors)
            render "no"
        }
    }

    def cambiarEstado_ajax(){

        println("params ce " + params)

        def ingreso = Ingreso.get(params.id)
        ingreso.estado = 'B'
        ingreso.observaciones = ingreso.observaciones + ", Pagado a la administración anterior"

        if(!ingreso.save()){
            render "no"
        }else{

            def pago = Pago.findByIngreso(ingreso)

            if(!pago){
                pago = new Pago()
                pago.ingreso = ingreso
            }

            pago.valor = ingreso.valor
            pago.fechaPago = new Date()
            pago.documento = 'NA'
            pago.observaciones = ingreso.observaciones + ", Pagado a la administración anterior"
            pago.mora = 0
            pago.tasa = 0
            pago.mess = 0

            if(!pago.save(flush: true)){
                println("error al guardar el pago generado por cambio de estado B")
                ingreso.estado = null
                ingreso.save(flush: true)
                render "no"
            }else{
                render "ok"
            }
        }
    }

/*
    def admnAnterior() {
        def sql1 = "update ingr set ingretdo = 'N' where prsn__id in " +
                "(select prsn__id from prsn where cndm__id = ${session.usuario.condominio.id})"
        def sql = "update ingr set ingretdo = 'N' where ingr__id in (select distinct ingr__id from pago " +
                "where pagoantr = 'S') and prsn__id in " +
                "(select prsn__id from prsn where cndm__id = ${session.usuario.condominio.id})"
//        println("sql " + sql)
        def cn = dbConnectionService.getConnection()
        def data = cn.executeUpdate(sql1.toString())
        data = cn.executeUpdate(sql.toString())
//        println "data: $data"
        if(data) {
            flash.message = "Se han actualizado ${data} pagos realizados a la Administración anterior"
        } else {
            flash.message = "Error en la actualización"
            flash.tipo = "error"
        }
        redirect(action:"index", params: params)
    }
*/

    def verificarDescripcion_ajax(){
//        println("params vd " + params)
        def cn = dbConnectionService.getConnection()
        def sql = "select count(*) nada, oblgdscr, tpapdscr from oblg, tpap where oblgdscr = '${params.texto.trim()}' and " +
                "tpap.tpap__id = oblg.tpap__id group by tpapdscr, oblgdscr"
//        println "sql: $sql"
        def cantidad = cn.rows(sql.toString())[0]?.nada?:0
        def oblg = cn.rows(sql.toString())[0]?.oblgdscr
        def tpap = cn.rows(sql.toString())[0]?.tpapdscr

//        println "cantidad: $cantidad --> no_ya existe un aporte para: ${oblg} en ${tpap}"
        if(cantidad > 0 ){
            render "no_Ya existe un aporte para: '${oblg}' en <strong>${tpap}</strong>"
        }else{
            println "--> ok"
            render "ok"
        }
    }

    def fecha_ajax(){
        def persona = Persona.get(params.persona)
        def obligacion = Obligacion.get(params.obligacion)
        def ingreso = Ingreso.findByObligacionAndPersona(obligacion, persona)
        return [ingreso: ingreso]
    }

    def guardarFecha_ajax(){
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def persona = Persona.get(params.persona)
        def obligacion = Obligacion.get(params.obligacion)
        def ingreso = Ingreso.findByObligacionAndPersona(obligacion, persona)

        ingreso.fecha = fecha

        if(!ingreso.save(flush:true)){
            println("error al guardar la fecha " + ingreso.errors)
            render "no"
        }else{
            render "ok"
        }
    }


}
