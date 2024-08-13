package contabilidad
import seguridad.Shield

/**
 * Controlador que muestra las pantallas de manejo de TipoComprobante
 */
class TipoComprobanteController extends Shield {

    def list() {
        def tipoComprobanteInstanceList = TipoComprobante.list([sort:"descripcion"])
        return [tipoComprobanteInstanceList: tipoComprobanteInstanceList]
    } //list

    def show_ajax() {


        if (params.id) {
            def tipoComprobanteInstance = TipoComprobante.get(params.id)
            if (!tipoComprobanteInstance) {
                notFound_ajax()
                return
            }
            return [tipoComprobanteInstance: tipoComprobanteInstance]
        } else {
            notFound_ajax()
        }
    } //show para cargar con ajax en un dialog

    def form_ajax() {
        def tipoComprobanteInstance = new TipoComprobante(params)
        if (params.id) {
            tipoComprobanteInstance = TipoComprobante.get(params.id)
            if (!tipoComprobanteInstance) {
                notFound_ajax()
                return
            }
        }
        return [tipoComprobanteInstance: tipoComprobanteInstance]
    } //form para cargar con ajax en un dialog

    def save_ajax() {

//        println("params:" + params)

//        params.each { k, v ->
//            if (v != "date.struct" && v instanceof java.lang.String) {
//                params[k] = v.toUpperCase()
//            }
//        }

        //nuevo

        def persona

        params.descripcion = params.descripcion.toUpperCase()
        params.codigo = params.codigo.toUpperCase()

        //original
        def tipoComprobanteInstance = new TipoComprobante()
        if (params.id) {
            tipoComprobanteInstance = TipoComprobante.get(params.id)
            tipoComprobanteInstance.properties = params
            if (!tipoComprobanteInstance) {
                notFound_ajax()
                return
            }
        }else {

            tipoComprobanteInstance = new TipoComprobante()
            tipoComprobanteInstance.properties = params
//            tipocomprobanteInstance.estado = '1'
//            tipoComprobanteInstance.empresa = session.empresa


        } //update


        if (!tipoComprobanteInstance.save(flush: true)) {
            def msg = "NO_No se pudo ${params.id ? 'actualizar' : 'crear'} Tipo de Comprobante."
            msg += renderErrors(bean: tipoComprobanteInstance)
            render msg
            return
        }
        render "OK_${params.id ? 'Actualización' : 'Creación'} de Tipo de Comprobante."
    } //save para grabar desde ajax

    def delete_ajax() {
        if (params.id) {
            def tipoComprobanteInstance = TipoComprobante.get(params.id)
            if (tipoComprobanteInstance) {
                try {
                    tipoComprobanteInstance.delete(flush: true)
                    render "OK_Eliminación de Tipo de Comprobante exitosa."
                } catch (e) {
                    render "NO_No se pudo eliminar el Tipo de Comprobante"
                }
            } else {
                notFound_ajax()
            }
        } else {
            notFound_ajax()
        }
    } //delete para eliminar via ajax

            
}
