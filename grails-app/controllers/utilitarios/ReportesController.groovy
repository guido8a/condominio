package utilitarios

import seguridad.Persona

class ReportesController {

    def dbConnectionService
    def index() { }


    def revisarFecha_ajax() {
//        println("params revisar fecha " + params)
        if(params.desde && params.hasta){
            def desde = new Date().parse("dd-MM-yyyy", params.desde)
            def hasta = new Date().parse("dd-MM-yyyy", params.hasta)

            if(desde > hasta){
                render "no"
            }else{
                render "ok"
            }
        }else{
            render "ok"
        }
    }

    def pagosPendientes_modal () {

    }

    def pagosPendientes () {
//        println("params pp " + params)
//        def desde = new Date().parse("dd-MM-yyyy", params.desde)
//        def hasta = new Date().parse("dd-MM-yyyy", params.hasta)

        def cn = dbConnectionService.getConnection()
        def sql = "select prsndpto depart, prsnnmbr||' '||prsnapll nombre,   coalesce(ingrobsr, '')||' ('||oblgdscr||')' detalle,   ingrvlor - ingrabno por_pagar from prsn, ingr, oblg where prsn.prsn__id = ingr.prsn__id and oblg.oblg__id = ingr.oblg__id and   ingrvlor > ingrabno Order by prsndpto, oblgdscr;"

//        println("sql: " + sql)

        def res =  cn.rows(sql.toString())
        def ultimo = res.last().depart
        def cont = res.size();

        return [res: res, ultimo: ultimo, cont: cont.toInteger()]
    }


}
