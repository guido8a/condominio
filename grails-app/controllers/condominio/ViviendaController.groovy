package condominio

import seguridad.Persona
import utilitarios.Parametros

class ViviendaController {

    def dbConnectionService
    def buscadorService

    def index() {

//        println "busqueda "
        def condominio = Parametros.get(1)
        params.ordenar = "prsndpto"
        return[condominio: condominio]
    }

    def tablaBuscar() {
        println "buscar .... $params"
        def cn = dbConnectionService.getConnection()
        params.old = params.criterio
        params.criterio = buscadorService.limpiaCriterio(params.criterio)
        params.ordenar  = buscadorService.limpiaCriterio(params.ordenar)

        def sql = armaSql(params)
        params.criterio = params.old
//        println "sql: $sql"
        def data = cn.rows(sql.toString())

        def msg = ""
        if(data?.size() > 50){
            data.pop()   //descarta el último puesto que son 21
            msg = "<div class='alert-danger' style='margin-top:-20px; diplay:block; height:25px;margin-bottom: 20px;'>" +
                    " <i class='fa fa-warning fa-2x pull-left'></i> Su búsqueda ha generado más de 30 resultados. " +
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
        def sqlSelect = "select * from personas() "
        //condicion fija
        def wh = " prsn__id is not null "


        def sqlWhere = "where (${wh})"

        def sqlOrder = "order by ${params.ordenar} limit 51"

        println "sql: $sqlSelect $sqlWhere $sqlOrder"
//        if(params.criterio) {
        if(params.operador && params.criterio) {
            if(campos.find {it.campo == params.buscador}?.size() > 0) {
                def op = operador.find {it.valor == params.operador}
                sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
            }
        }
//        println "-->sql: $sqlSelect $sqlWhere $sqlOrder"
        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }

    def creaIngresos() {

    }

    def tabla() {
        println "tabla " + params
        def oblg = Obligacion.get(params.oblg)
        def sql = "select * from ingresos(${oblg.id}) order by prsndpto"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        [personas: data, params: params, oblg: oblg]
    }

    def actualizar() {

        println "actualizar $params"
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
                    ingreso.fecha = new Date()
                } else {
                    ingreso.valor = valor
                    ingreso.fecha = new Date()
                    ingreso.estado = 'M'
                }

                ingreso.observaciones = obsr

                if (!ingreso.save(flush: true)) {
                    println "error $parts, --> ${ingreso.errors}"
                    if (nos != "") {
                        nos += ","
                    }
                    nos += "#" + prsnId
                } else {
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
                    ingreso.fecha = new Date()
                    ingreso.observaciones = obsr
                } else {
                    println "edita ingreso ${ingreso.id}"
                    ingreso.observaciones = obsr
                }

                if (!ingreso.save(flush: true)) {
                    println "error $p_obsr, --> ${ingreso.errors}"
                    if (nos != "") {
                        nos += ","
                    }
                    nos += "#" + id
                } else {
                    if (oks != "") {
                        oks += ","
                    }
                    oks += "#" + id
                }
            }
        }

        render oks + "_" + nos
    }



}
