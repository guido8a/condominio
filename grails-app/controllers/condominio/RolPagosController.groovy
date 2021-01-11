package condominio

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield

/**
 * Controlador que muestra las pantallas de manejo de RolPagos
 */
class RolPagosController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    def mensual_ajax(){
        def mensual
        if(params.id){
            mensual = RolPagos.get(params.id)
        }else{
            mensual = new RolPagos()
        }

        return [mensual:mensual]
    }

    def cuarto_ajax(){

    }

    def tercero_ajax(){

    }

    def vacaciones_ajax(){

    }
    
}
