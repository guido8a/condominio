package seguridad

import condominio.Alicuota

class InicioController extends seguridad.Shield {
    def dbConnectionService
    def diasLaborablesService

    def index() {
/*
        if (session.usuario.getPuedeDirector()) {
            redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidadoDir", params: [dpto: Persona.get(session.usuario.id).departamento.id, inicio: "1", dir: "1"])
        } else {
            if (session.usuario.getPuedeJefe()) {
                redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidado", params: [dpto: Persona.get(session.usuario.id).departamento.id, inicio: "1"])
            } else {
            }

        }
*/

//        def fcha = new Date()
//        def fa = new Date(fcha.time - 2*60*60*1000)
//        def fb = new Date(fcha.time + 25*60*60*1000)
//        println "fechas: fa: $fa, fb: $fb"
//        def nada = diasLaborablesService.tmpoLaborableEntre(fa,fb)

    }

    def parametros = {

        if (session.usuario && session.perfil.codigo == 'ADM') {
            return []
        } else {
            flash.message = "Está tratando de ingresar a un pantalla restringida para su perfil. Está acción será registrada."
            response.sendError(403)
        }
    }

    def parametrosCondominio = {
        if (session.usuario && session.perfil.codigo == 'ADC') {
            return []
        } else {
            flash.message = "Está tratando de ingresar a un pantalla restringida para su perfil. Está acción será registrada."
            response.sendError(403)
        }
    }


    /** carga datos desde un CSV - utf-8: si ya existe lo actualiza
     * */
    def leeCSV() {
//        println ">>leeCSV.."
        def contador = 0
        def cn = dbConnectionService.getConnection()
        def estc
        def rgst = []
        def cont = 0
        def repetidos = 0
        def procesa = 5
        def crea_log = false
        def inserta
        def fcha
        def magn
        def sqlp
        def directorio
//        def tipo = 'prueba'
        def tipo = 'prod'

        if (grails.util.Environment.getCurrent().name == 'development') {
            directorio = '/home/guido/proyectos/condominio/data/'
        } else {
            directorio = '/home/data/ventas'
        }

        if (tipo == 'prueba') { //botón: Cargar datos Minutos
            procesa = 5
            crea_log = false
        } else {
            procesa = 1000000000
            crea_log = true
        }

        def nmbr = ""
        def arch = ""
        def cuenta = 0
        def fechas = []
        new File(directorio).traverse(type: groovy.io.FileType.FILES, nameFilter: ~/.*\.csv/) { ar ->
            nmbr = ar.toString() - directorio
            arch = nmbr.substring(nmbr.lastIndexOf("/") + 1)

            /*** procesa las 5 primeras líneas del archivo  **/
            def line
//            cont = 0
//            repetidos = 0
            ar.withReader('UTF-8') { reader ->
                print "Cargando datos desde: $ar "
                cuenta = 0
                while ((line = reader.readLine()) != null) {
                    println ">>${line}"
                    if(cuenta < 2){
                        cuenta++
                    } else if(cuenta < procesa && line?.size() > 20) {
                        rgst = line.split('\t')
                        rgst = rgst*.trim()
                        println "***** $rgst"
                        if(rgst[6]) {
                            inserta = cargaData(rgst, fechas)
                            cont += inserta.insertados
                            repetidos += inserta.repetidos
                            cuenta++
                        }
//                    } else {
//                        break
                    }
                }
            }
            println "---> archivo: ${ar.toString()} --> cont: $cont, repetidos: $repetidos"

        }
//        return "Se han cargado ${cont} líneas de datos y han existido : <<${repetidos}>> repetidos"
        render "Se han cargado ${cont} líneas de datos y han existido : <<${repetidos}>> repetidos<br/>${verifica()}"
    }


    def cargaData(rgst, fechas) {
        def errores = ""
        def cnta = 0
        def insertados = 0
        def repetidos = 0
        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def sql = ""
        def sqlEdif = ""
        def sqlAlct = ""
        def cndm = 0
        def edif = 0
//        def fcha = new Date().format("yyyy-MM-dd HH:mm:ss")
        def fcha = new Date().format("yyyy-MM-dd")
        def tx = ""
        def id = 0
        def resp = 0

        println "\ninicia cargado de datos para $rgst"
        println "fechas: $fechas"
        cnta = 0
        cndm = limpia(rgst[0]).toInteger()

        if (cndm > 0) {
            tx = limpia(rgst[6])
            sqlEdif = "select edif__id from edif where edifdscr ilike '%${tx}%' and cndm__id = ${cndm}"
            println "sqlEdif: $sqlEdif"
            edif = cn.rows(sqlEdif.toString())[0]?.edif__id

            sql = "select count(*) nada from prsn where cndm__id = ${cndm} and edif__id = ${edif} and " +
                    "prsndpto = '${rgst[6]}'"
            cnta = cn.rows(sql.toString())[0]?.nada

            if (edif && (cnta == 0)) {
                sql = "insert into prsn (prsn__id, edif__id, prsn_ruc, prsnnmbr, prsnapll, " +
                        "prsnsexo, prsnlogn, prsnpass, prsnprnb, " +
                        "prsnprap, tpoc__id, prsnextr, prsnactv, cndm__id, prsndpto, " +
                        "prsntelf, prsnfcha, prsnalct) " +
                        "values(default, '${edif}', '${limpia(rgst[5])}', '${limpia(rgst[1])}', '${limpia(rgst[2])}', " +
                        "'${limpia(rgst[12])[0]}', '${login(rgst[1], rgst[2])}', md5('123'), '${limpia(rgst[3])}', " +
                        "'${limpia(rgst[4])}', '${limpia(rgst[8])[0] == 'P'? 1:2}', 0, 1, ${cndm}, '${limpia(rgst[7])}', " +
                        "'00', '${fcha}', 0) " +
                        "returning prsn__id"
                println "sql ---> ${sql}"

                try {
                    cn.eachRow(sql.toString()) { d ->
                        id = d.prsn__id
                        sqlAlct = "insert into alct(prsn__id, alctfcds, alctvlor) values(${id}, '1-feb-2021', ${rgst[9]})"
                        println "sqlAlct: $sqlAlct"
                        cn1.execute(sqlAlct.toString())

                        sqlAlct = "insert into sesn(prsn__id, prfl__id, sesnfcin) values(${id}, 2, '1-feb-2021')"
                        println "sqlAlct: $sqlAlct"
                        cn1.execute(sqlAlct.toString())
                        insertados++
                    }
                    println "---> id: ${id}"
                } catch (Exception ex) {
                    repetidos++
                    println "Error principal $ex"
                    println "sql: $sql"
                }
            }
        }
        cnta++
        return [errores: errores, insertados: insertados, repetidos: repetidos]
    }

    def limpia(tx) {
        tx.toString().trim()
    }

    def login(nmbr, apll) {
        def txto = "${limpia(nmbr)[0]}${limpia(apll)}".toLowerCase()
        if(txto.indexOf(" ") > 0) {
            txto[0..txto.indexOf(" ")-1]
        } else {
            txto
        }
    }

    def verifica() {
        def txto = ""
        def prsn = Persona.list()
        txto += "Personas ok"
        def alct = Alicuota.list()
        txto += "\tAlicuotas ok"
        def sesn = Sesn.list()
        txto += "\tSesn ok"
        txto
    }


}
