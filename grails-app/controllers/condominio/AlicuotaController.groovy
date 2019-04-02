package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Alicuota
 */
class AlicuotaController extends Shield {

    def dbConnectionService

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
            def c = Alicuota.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("observaciones", "%" + params.search + "%")
                }
            }
        } else {
            list = Alicuota.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return alicuotaInstanceList: la lista de elementos filtrados, alicuotaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def alicuotaInstanceList = getList(params, false)
        def alicuotaInstanceCount = getList(params, true).size()
        return [alicuotaInstanceList: alicuotaInstanceList, alicuotaInstanceCount: alicuotaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return alicuotaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def alicuotaInstance = Alicuota.get(params.id)
            if(!alicuotaInstance) {
                render "ERROR*No se encontró Alicuota."
                return
            }
            return [alicuotaInstance: alicuotaInstance]
        } else {
            render "ERROR*No se encontró Alicuota."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return alicuotaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
//        println("params f" + params)

        def alicuota
        if(params.id){
            alicuota = Alicuota.get(params.id)
        }else{
            alicuota = new Alicuota()
        }

        def persona

        if(params.persona){
            persona = Persona.get(params.persona)
        }else{
            persona = alicuota.persona
        }

        return[alicuotaInstance: alicuota, persona: persona]

    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
//        println "params: $params"
        def alicuotaInstance
        def alicuotasAntiguas
        def per
        if(params.id) {
            alicuotaInstance = Alicuota.get(params.id)
            if(!alicuotaInstance) {
                render "ERROR*No se encontró Alicuota."
                return
            }
        }
        else{
            alicuotaInstance = new Alicuota()
            per = Persona.get(params."persona.id")
            alicuotasAntiguas = Alicuota.findAllByPersonaAndFechaHastaIsNull(per)
            if(alicuotasAntiguas){
                alicuotasAntiguas.last().fechaHasta = new Date()
            }

//            println("---- " + alicuotasAntiguas)
        }


        if(params.valor) params.valor = params.valor.toDouble()
        alicuotaInstance.properties = params

//        println "valor: ${alicuotaInstance.valor}"
        if(!alicuotaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Alicuota: " + renderErrors(bean: alicuotaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Alicuota exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def alicuotaInstance = Alicuota.get(params.id)
            if (!alicuotaInstance) {
                render "ERROR*No se encontró Alicuota."
                return
            }
            try {
                alicuotaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Alicuota exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Alicuota"
                return
            }
        } else {
            render "ERROR*No se encontró Alicuota."
            return
        }
    } //delete para eliminar via ajax

    def tablaAlicuotas_ajax () {

        def persona = Persona.get(params.id)
        def alicuotas = Alicuota.findAllByPersona(persona).sort{it.fechaHasta}

        return [alicuotas: alicuotas, persona: persona]
    }

    def alicuota_siguiente () {


        def listaMeses = [1:'Enero',2:'Febrero',3:'Marzo',4:'Abril',5:'Mayo', 6:'Junio', 7:'Julio', 8:'Agosto', 9:'Septiembre',10:'Octubre',11:'Noviembre',12:'Diciembre']

        return [lista: listaMeses]

    }

    def tablaAlicuotasNuevas_ajax () {

        def condominio = Condominio.get(session.condominio.id)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from cuotas(${params.valor},${condominio?.id})"

        def res = cn.rows(sql.toString())

        return[datos: res]
    }

    def guardarAlicuotas_ajax () {

//        println("params " + params)

        def errores = ''
        def condominio = Condominio.get(session.condominio.id)
        def nuevaFecha = '01' + "-" + params.mes + "-" + params.fecha
        def mesesMas = ['1','3','5','7', '8','10','12']
        def mesesMenos = ['4','6','9','11']
        def mesMenor = params.mes == '1' ? '12' : (params.mes.toInteger() -1)
        def diaHasta = mesesMas.contains(mesMenor.toString()) ? '31' : mesesMenos.contains(mesMenor.toString())  ? '30' : '28'
        def anteriorFecha = params.mes == '1' ? (diaHasta + "-" + (params.mes = '12') + "-" + (params.fecha.toInteger() - 1)) : (diaHasta + "-" + (params.mes.toInteger() - 1) + "-" + params.fecha)

        def fecha = new Date().parse("dd-MM-yyyy", nuevaFecha)
        def fechaHasta = new Date().parse("dd-MM-yyyy", anteriorFecha)
//
//        println("nueva " + fecha)
//        println("anterior " + fechaHasta)


        def cn = dbConnectionService.getConnection()
        def sql = "select * from cuotas(${params.valor},${condominio?.id})"

        def res = cn.rows(sql.toString())

        def personas = []
        def valorNuevo = [:]
        def nueva

        res.each {
            personas.add(it.prsn__id)
            valorNuevo.put(it.prsn__id, it.prsnalct)
        }

        def alicuotasId = Alicuota.findAllByPersonaInListAndFechaHastaIsNull(Persona.findAllByIdInList(personas))


        alicuotasId.each {ali->

            ali.fechaHasta = fechaHasta

            try{
                ali.save(flush: true)
            }catch (e){
                errores += e
            }
        }


        valorNuevo.each { vn->

           nueva = new Alicuota()
           nueva.persona = Persona.get(vn.key.toInteger())
           nueva.valor = vn.value.toDouble()
           nueva.fechaDesde = fecha

            try{
                nueva.save(flush: true)
            }catch (e){
                errores += e
            }

        }

        if(errores == ''){
            render "ok"
        }else{
            render "no"
        }


    }


}
