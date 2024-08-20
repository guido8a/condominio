package contabilidad

import condominio.Comprobante
import condominio.Condominio
import seguridad.Shield

/**
 * Controlador que muestra las pantallas de manejo de Asiento
 */
class AsientoController extends Shield {

    def form_ajax(){
        println("params " + params)

        def asiento

        if(params.id){
            asiento = Asiento.get(params.id)
        }else{
            asiento = new Asiento()
        }

        return [asiento: asiento]
    }

    def buscarCuenta_ajax(){

    }

    def tablaCuentas_ajax () {
//        println("params tc" + params)
        def condominio = Condominio.get(session.condominio.id)
        def res = Cuenta.withCriteria {
            eq("condominio", condominio)

            and{
                ilike("descripcion", '%' + params.nombre + '%')
                ilike("numero", '%' + params.codigo + '%')
                eq("movimiento", '1')
            }
            order ("numero","asc")
        }
        return [cuentas: res]
    }

    def guardarAsiento_ajax () {
        println("params guardar asiento " + params)
        def asiento
        def cuenta = Cuenta.get(params.cuenta)
        def comprobante = ComprobanteCont.get(params.comprobante)
        def asientos = Asiento.findAllByComprobante(comprobante, [sort: 'numero'])
        def siguiente = 0

        if(!cuenta){
            render "err_Seleccione una cuenta"
            return
        }

        if(!params.debe && !params.haber){
            render "err_Ingrese un valor"
            return
        }

        if(!params.debe){
            params.debe = 0
        }

        if(!params.haber){
            params.haber = 0
        }

        if(asientos){
            siguiente = asientos.numero.last() + 1
        }

        if(params.asiento){
            asiento = Asiento.get(params.asiento)
        }else{
            asiento = new Asiento()
            asiento.comprobante = comprobante
            asiento.numero = siguiente
        }

        asiento.cuenta = cuenta
        asiento.debe = params.debe.toDouble()
        asiento.haber = params.haber.toDouble()

        if(!asiento.save(flush: true)){
            render "no_Error al guardar el asiento"
            println("error " + asiento.errors)
        }else{
            render "ok_Asiento guardado correctamente"
        }
    }

    def borrarAsiento_ajax () {
//        println("borrar asiento params " + params)
        def comprobante = ComprobanteCont.get(params.comprobante)
        def asiento = Asiento.get(params.id)

        if(comprobante.registrado == 'N'){
                try{
                    asiento.delete(flush: true)
                    render "ok_Asiento borrado correctamente"
                }catch (e){
                    println("error " + asiento.errors)
                    render "no_Error al borrar el asiento"
                }
        }else{
            render "no_No se puede borrar el asiento, el comprobante ya se encuentra registrado"
        }
    }

    def borrarCeros_ajax(){

        def comprobante = ComprobanteCont.get(params.comprobante)
        def asientos = Asiento.findAllByComprobanteAndDebeAndHaber(comprobante,0.0,0.0)

        def errores = ''

        if(asientos.size() > 0){
            asientos.each {
                try{
                    it.delete(flush: true)
                }catch (e){
                    errores += e
                    println("error al borrar los asientos con 0 " + e)
                }
            }

            if(errores == ''){
                render "ok_Asientos borrados correctamente"
            }else{
                println("Error al borrar los asientos " + errores)
                render "no_Error al borrar los asientos"
            }
        }else{
            render"err_No existen asientos con 0"
        }
    }

}
