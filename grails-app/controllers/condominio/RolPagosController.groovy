package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield

/**
 * Controlador que muestra las pantallas de manejo de RolPagos
 */
class RolPagosController extends Shield {

    def dbConnectionService

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    def mensual_ajax(){
        def condominio = Condominio.get(params.condominio)
        def empleado = Empleado.get(params.empleado)
        def no = [13,14,15]
        def salarios = Salario.findAllByIdNotInList(no).sort{it.id}
        def mensual
        if(params.id){
            mensual = RolPagos.get(params.id)
        }else{
            mensual = new RolPagos()
        }

        return [mensual:mensual, condominio:condominio, salarios: salarios, empleado: empleado]
    }

    def cuarto_ajax(){
        def condominio = Condominio.get(params.condominio)
        def empleado = Empleado.get(params.empleado)
        def si = [14]
        def salarios = Salario.findAllByIdInList(si).sort{it.id}
        def cuarto
        if(params.id){
            cuarto = RolPagos.get(params.id)
        }else{
            cuarto = new RolPagos()
        }

        return [cuarto:cuarto, condominio:condominio, salarios: salarios, empleado: empleado]
    }

    def tercero_ajax(){
        def condominio = Condominio.get(params.condominio)
        def empleado = Empleado.get(params.empleado)
        def si = [13]
        def salarios = Salario.findAllByIdInList(si).sort{it.id}
        def tercero
        if(params.id){
            tercero = RolPagos.get(params.id)
        }else{
            tercero = new RolPagos()
        }

        return [tercero:tercero, condominio:condominio, salarios: salarios, empleado: empleado]
    }

    def vacaciones_ajax(){
        def condominio = Condominio.get(params.condominio)
        def empleado = Empleado.get(params.empleado)
        def si = [15]
        def salarios = Salario.findAllByIdInList(si).sort{it.id}
        def vaca
        if(params.id){
            vaca = RolPagos.get(params.id)
        }else{
            vaca = new RolPagos()
        }

        return [vacaciones:vaca, condominio:condominio, salarios: salarios, empleado: empleado]
    }

    def save_ajax(){

        println("params " + params)
        println("params " + params + "")

        def empleado = Empleado.get(params.empleado)
        def condominio = Condominio.get(params."condominio.id")
        def fechaInicio
        def fechaFin
        def band = 0

        switch (params.tipo){
            case 'mensual':
                def salario = Salario.get(params."salario.id")
                fechaInicio = sacarFechas(salario.id).inicio
                fechaFin = sacarFechas(salario.id).fin

                def cn = dbConnectionService.getConnection()
                def sql = "select * from nomina('${condominio?.id}', '${salario?.id}', '${empleado?.id}', '${fechaInicio}', '${fechaFin}', '${params.descuentoDescripcion}', '${params.descuentoValor.toDouble()}', '${params.bono}', '${params.bonoValor.toDouble()}');"
                def res = cn.rows(sql.toString())
                if(res != null){
                    render "ok"
                }else{
                    render "no"
                }
                break;
            case "tercero":
                def salario = Salario.get(params."salario.id")
                def fecha1 = "1-jan-" + new Date().format("yyyy")
                def fecha2 = "30-nov-" + new Date().format("yyyy")

                def cn2 = dbConnectionService.getConnection()
                def sql2 = "select * from nomina('${condominio?.id}', '${salario?.id}', '${empleado?.id}', '${fecha1}', '${fecha2}', null,0, null,0);"
                def res2 = cn2.rows(sql2.toString())
                if(res2 != null){
                    render "ok"
                }else{
                    render "no"
                }
                break;

            case "cuarto":
                def salario = Salario.get(params."salario.id")
                def fecha1 = "1-jan-" + new Date().format("yyyy")
                def fecha2 = "31-dec-" + new Date().format("yyyy")

                def cn3 = dbConnectionService.getConnection()
                def sql3 = "select * from nomina('${condominio?.id}', '${salario?.id}', '${empleado?.id}', '${fecha1}', '${fecha2}', null,0, null,0);"
                def res3 = cn3.rows(sql3.toString())
                if(res3 != null){
                    render "ok"
                }else{
                    render "no"
                }
                break;
            case "vacaciones":
                def salario = Salario.get(params."salario.id")
                def fecha1 = "1-jan-" + new Date().format("yyyy")
                def fecha2 = "31-dec-" + new Date().format("yyyy")
                def sql4
                def cn4 = dbConnectionService.getConnection()
                if(params.descuentoValor == '0'){
                    sql4 = "select * from nomina('${condominio?.id}', '${salario?.id}', '${empleado?.id}', '${fecha1}', '${fecha2}', null, 0, null,0);"
                }else{
                    sql4 = "select * from nomina('${condominio?.id}', '${salario?.id}', '${empleado?.id}', '${fecha1}', '${fecha2}', '${"Vacaciones tomadas..................................._" + params.descuentoValor.toInteger() + "_días" }', '${params.descuentoValor.toInteger()}', null,0);"
                }
                def res4 = cn4.rows(sql4.toString())
                if(res4 != null){
                    render "ok"
                }else{
                    render "no"
                }
                break;
        }
    }

    def sacarFechas(id) {

        def anioActual = new Date().format("yyyy")
        def inicio
        def fin

        switch (id){
            case '1':
                inicio = '1-jan-' + anioActual
                fin = '31-jan-' + anioActual
                break;
            case "2":
                inicio = '1-feb-' + anioActual
                fin = '28-feb-' + anioActual
                break;
            case "3":
                inicio = '1-mar-' + anioActual
                fin = '31-mar-' + anioActual
                break;
            case "4":
                inicio = '1-apr-' + anioActual
                fin = '30-apr-' + anioActual
                break;
            case "5":
                inicio = '1-may-' + anioActual
                fin = '31-may-' + anioActual
                break;
            case "6":
                inicio = '1-jun-' + anioActual
                fin = '30-jun-' + anioActual
                break;
            case "7":
                inicio = '1-jul-' + anioActual
                fin = '31-jul-' + anioActual
                break;
            case "8":
                inicio = '1-aug-' + anioActual
                fin = '31-aug-' + anioActual
                break;
            case "9":
                inicio = '1-sep-' + anioActual
                fin = '30-sep-' + anioActual
                break;
            case "10":
                inicio = '1-oct-' + anioActual
                fin = '31-oct-' + anioActual
                break;
            case "11":
                inicio = '1-nov-' + anioActual
                fin = '30-nov-' + anioActual
                break;
            case "12":
                inicio = '1-dec-' + anioActual
                fin = '31-dec-' + anioActual
                break;
        }


        return[inicio:inicio, fin:fin]

    }

}
