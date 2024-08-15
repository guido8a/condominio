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

    def form_ajax() {
        def tipoComprobanteInstance
        if (params.id) {
            tipoComprobanteInstance = TipoComprobante.get(params.id)
        }else{
            tipoComprobanteInstance = new TipoComprobante()
        }

        return [tipoComprobanteInstance: tipoComprobanteInstance]
    } //form para cargar con ajax en un dialog

    def save_ajax() {

        def tipoComprobante

        params.descripcion = params.descripcion.toUpperCase()
        params.codigo = params.codigo.toUpperCase()

        if (params.id) {
            tipoComprobante = TipoComprobante.get(params.id)
            if (!tipoComprobante) {
                render "no_Error al guardar el tipo de comprobante"
                return
            }
        }else{
            tipoComprobante = new TipoComprobante()
        }

        tipoComprobante.properties = params

        if(!tipoComprobante.save()){
            println("error al guardar el tipo de comprobante " + tipoComprobante.errors)
            render "no_Error al guardar el tipo de comprobante"
        }else{
            render "ok_Tipo de comprobante guardado correctamente"
        }

    } //save para grabar desde ajax

    def delete_ajax() {

        def tipoComprobante = TipoComprobante.get(params.id)
        if (!tipoComprobante) {
            render "no_Error al guardar el tipo de comprobante"
            return
        }else{
            try{
                tipoComprobante.delete(flush:true)
                render "ok_Tipo de comprobante borrado correctamente"
            }catch(e){
                render "no_Error al guardar el tipo de comprobante"
            }
        }
    } //delete para eliminar via ajax


}
