package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Ingreso
 */
class IngresoController extends Shield {

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
        println "params: $params"
        def prsn = Persona.get(params.id)
        def ingr = Ingreso.findAllByPersona(prsn, [sort: 'fecha'])
        return [ingreso: ingr, ingrCount: ingr.size()]
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

        def pago
        def ingreso = Ingreso.get(params.id)
        if(params.pago){
            pago = Pago.get(params.pago)
        }
        def pagos = Pago.findAllByIngreso(ingreso)
        def saldo = (ingreso.valor - (pagos?.valor?.sum() ?: 0))
        def dscr  = "${ingreso.obligacion.descripcion} ${ingreso.observaciones?:''}"

        return[ingreso: ingreso, pagos: pagos, saldo: saldo, pago: pago, dscr: dscr]
    }


    def guardarPago_ajax (){
        println("params " + params)

        def ingreso = Ingreso.get(params.ingreso)
        def pagos = Pago.findAllByIngreso(ingreso)
        def saldo = (ingreso.valor - (pagos?.valor?.sum() ?: 0))
        def saldo2
        def pago

        if(params.id){
            pago = Pago.get(params.id)
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

        if(!pago.save(flush: true)){
            println("error al guardar el pago " + pago.errors)
            render "no"
        }else{
            render "ok"
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

}
