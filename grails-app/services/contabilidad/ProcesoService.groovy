package contabilidad

class ProcesoService {

    static transactional = true
    def dbConnectionService


    def registrar(id, cdgo) {
        def lista = [true]
        def cn = dbConnectionService.getConnection()
        def cmpr
        def asnt

        println "registrar proceso: ${proceso.id} --> select * from generar(${id}, $cdgo)"
        try {
            cn.execute("select * from generar($proceso.id)".toString())
            cmpr = Comprobante.findAllByProceso(proceso)
            asnt = Asiento.findAllByComprobanteInList(cmpr)
            lista.add(cmpr)
            lista.add(asnt)
        } catch (e) {
            lista[0] = false
            println "errores: $e"
        }

        return lista
    }


    def mayorizar(cmpr) {
        def cn = dbConnectionService.getConnection()
        def msg = ""
            try {
                cn.eachRow("select mayorizar from mayorizar($cmpr, 1)".toString()) {d ->
                    msg = "ok_" + d.mayorizar
                }
            } catch (e) {
                println "errores: $e"
                msg = "no_Error al mayorizar"
            }
        return msg
    }

    def desmayorizar(cmpr) {
        def cn1 = dbConnectionService.getConnection()
        def msg = ""
        try {
            cn1.eachRow("select mayorizar from mayorizar($cmpr.id, -1)".toString()) {d ->
                msg = "ok_" + d.mayorizar
            }
        } catch (e) {
            println "errores: $e"
            msg = "no_Error al Desmayorizar"
        }
        return msg
    }

}
