package contabilidad
import seguridad.Shield

/**
 * Controlador que muestra las pantallas de manejo de Asiento
 */
class AsientoController extends Shield {

    def form_ajax(){
        def asiento

        if(params.id){
            asiento = Asiento.get(params.id)
        }else{
            asiento = new Asiento()
        }

        return [asiento: asiento]
    }

    
}
