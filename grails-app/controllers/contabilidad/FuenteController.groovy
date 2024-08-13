package contabilidad
import seguridad.Shield
/**
 * Controlador que muestra las pantallas de manejo de Fuente
 */
class FuenteController extends Shield {

    def list() {
        def fuenteInstanceList = Fuente.list().sort{it.descripcion}
        return [fuenteInstanceList: fuenteInstanceList]
    } //list

    def form_ajax() {
        def fuenteInstance

        if(params.id){
            fuenteInstance = Fuente.get(params.id)
        }else{
            fuenteInstance = new Fuente()
        }

        return [fuenteInstance: fuenteInstance]
    } //form para cargar con ajax en un dialog

    def save_ajax() {

        def fuente

        if(params.id){
            fuente = Fuente.get(params.id)
            if(!fuente){
                render "no_Error al guardar la fuente"
                return
            }
        }else{
            fuente = new Fuente()
        }

        params.descripcion = params.descripcion.toUpperCase()
        fuente.properties = params

        if (!fuente.save(flush: true)) {
            println("Error al guardar la fuente " + fuente.errors)
           render "no_Error al guardar la fuente"
        }else{
            render "ok_Fuente guardada correctamente"
        }
    } //save para grabar desde ajax

    def delete_ajax() {
            def fuenteInstance = Fuente.get(params.id)
            if (fuenteInstance) {
                try {
                    fuenteInstance.delete(flush: true)
                    render "ok_Fuente borrada correctamente"
                } catch (e) {
                    println("Error al borrar la fuente " + fuenteInstance.errors)
                    render "no_Error al borrar la fuente"
                }
            } else {
                render "no_Error al borrar la fuente"
            }
    } //delete para eliminar via ajax

}
