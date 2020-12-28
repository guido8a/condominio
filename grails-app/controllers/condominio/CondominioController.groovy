package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield
import utilitarios.Parametros


/**
 * Controlador que muestra las pantallas de manejo de Condominio
 */
class CondominioController extends Shield {

    def dbConnectionService
    def buscadorService
    
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
            def c = Condominio.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("direccion", "%" + params.search + "%")
                    ilike("email", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("ruc", "%" + params.search + "%")
                    ilike("sigla", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Condominio.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return condominioInstanceList: la lista de elementos filtrados, condominioInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {

        def condominioInstanceList
        def condominioInstanceCount


        if(session.perfil.codigo == 'ADM'){
            condominioInstanceList = getList(params, false)
            condominioInstanceCount = getList(params, true).size()
        }else{
            condominioInstanceList = Condominio.get(session.condominio.id)
            condominioInstanceCount = 1
        }

        return [condominioInstanceList: condominioInstanceList, condominioInstanceCount: condominioInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return condominioInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def condominioInstance = Condominio.get(params.id)
            if(!condominioInstance) {
                render "ERROR*No se encontró Condominio."
                return
            }
            return [condominioInstance: condominioInstance]
        } else {
            render "ERROR*No se encontró Condominio."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return condominioInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def condominioInstance = new Condominio()
        if(params.id) {
            condominioInstance = Condominio.get(params.id)
            if(!condominioInstance) {
                render "ERROR*No se encontró Condominio."
                return
            }
        }
        condominioInstance.properties = params
        return [condominioInstance: condominioInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def condominioInstance = new Condominio()
        if(params.id) {
            condominioInstance = Condominio.get(params.id)
            if(!condominioInstance) {
                render "ERROR*No se encontró Condominio."
                return
            }
        }
        condominioInstance.properties = params
        if(!condominioInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Condominio: " + renderErrors(bean: condominioInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Condominio exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def condominioInstance = Condominio.get(params.id)
            if (!condominioInstance) {
                render "ERROR*No se encontró Condominio."
                return
            }
            try {
                condominioInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Condominio exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Condominio"
                return
            }
        } else {
            render "ERROR*No se encontró Condominio."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad email
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_email_ajax() {
        params.email = params.email.toString().trim()
        if (params.id) {
            def obj = Condominio.get(params.id)
            if (obj.email.toLowerCase() == params.email.toLowerCase()) {
                render true
                return
            } else {
                render Condominio.countByEmailIlike(params.email) == 0
                return
            }
        } else {
            render Condominio.countByEmailIlike(params.email) == 0
            return
        }
    }

    def cobro_ajax(){
        def condominio = Condominio.get(params.id)
        return[condominio:condominio]
    }

    def guardarValor_ajax(){
        def condominio = Condominio.get(params.id)
        condominio.monitorio = params.valor.toDouble()

        if(!condominio.save(flush:true)){
            println("error al guardar el valor del monitorio " + condominio.errors)
            render "no"
        }else{
            render "ok"
        }
    }

    def alicuotas() {
        //        println "busqueda "
        def cn = dbConnectionService.getConnection()
        def condominio = Parametros.get(1)
        params.ordenar = "prsndpto"
        def sql = "select count(*) cnta from cuotas(1000, ${condominio?.id}) where prsndpto is null"
        def no_aportan = cn.rows(sql.toString())[0].cnta
        return[condominio: condominio, base: 2000, no_aportan: no_aportan]
    }

    def tablaBuscar() {
//        println "buscar .... $params"
        def cn = dbConnectionService.getConnection()
        params.old = params.criterio
        params.criterio = buscadorService.limpiaCriterio(params.criterio)
        params.ordenar  = buscadorService.limpiaCriterio(params.ordenar)
        params.base  = params.base ?: 2000

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
        def condominio

        if (params.condo){
            condominio = Condominio.get(params.condo)
        }else{
            condominio = Condominio.get(session.condominio.id)
        }

        def sqlSelect = "select * from cuotas(${params.base}, ${condominio?.id}) "

        //condicion fija
        def wh = " prsnnmbr is not null "


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
//        println "-->sql: $sqlSelect $sqlWhere $sqlOrder"
        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }


}
