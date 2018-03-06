package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Egreso
 */
class EgresoController extends Shield {

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
        def egresoInstanceList = getList(params, false)
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
        if(params.id) {
            egresoInstance = Egreso.get(params.id)
            if(!egresoInstance) {
                render "ERROR*No se encontró Egreso."
                return
            }
        }
        egresoInstance.properties = params
        return [egresoInstance: egresoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def egresoInstance = new Egreso()
        if(params.id) {
            egresoInstance = Egreso.get(params.id)
            if(!egresoInstance) {
                render "ERROR*No se encontró Egreso."
                return
            }
        }  else {
           egresoInstance.fecha = new Date()
           egresoInstance.estado = 'E'
        }
        params.valor = params.valor.toDouble()
//        params.abono = params.abono.toDouble()
        egresoInstance.properties = params
//        if(egresoInstance.valor <= egresoInstance.abono) egresoInstance.estado = 'P'

        def pagos

        if(params.valor.toDouble() >= pagos?.valor?.sum()){
            if(!egresoInstance.save(flush: true)) {
                render "ERROR*Ha ocurrido un error al guardar Egreso: " + renderErrors(bean: egresoInstance)
                return
            }
            render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Egreso exitosa."
            pagos = PagoEgreso.findAllByEgreso(egresoInstance)

            return
        }else{
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
        pago.observaciones = params.observaciones

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

    def saldos_ajax() {

    }

    def tablaSaldos_ajax () {

    }


}
