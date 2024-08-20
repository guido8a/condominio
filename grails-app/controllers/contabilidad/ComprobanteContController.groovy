package contabilidad
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de ComprobanteCont
 */
class ComprobanteContController extends Shield {

    def form(){

        def comprobante = ComprobanteCont.get(params.id)
        return [comprobante: comprobante]

    }

    def list() {
        def contabilidad = Contabilidad.get(session.contabilidad.id)
        return [contabilidad: contabilidad]
    }

    def tablaComprobantes_ajax () {
//        println("params c " + params)

        def contabilidad = Contabilidad.get(session.contabilidad.id)
        def desde
        def hasta
        if(params.desde){
            desde = new Date().parse("dd-MM-yyyy", params.desde)
        }

        if(params.hasta){
            hasta = new Date().parse("dd-MM-yyyy", params.hasta)
        }

        def comprobantes = ComprobanteCont.withCriteria {

//            proceso{
//                eq("contabilidad", contabilidad)
//            }

            eq("registrado", 'N')

            if(params.desde && params.hasta){
                between("fecha", desde, hasta)
            }

            if(params.descripcion){
                ilike("descripcion", "%" + params.descripcion.trim() + "%")

            }

            order("fecha","asc")
        }

        return [comprobantes: comprobantes]
    }

    def revisarFecha_ajax() {
//        println("params revisar fecha " + params)
        if(params.desde && params.hasta){
            def desde = new Date().parse("dd-MM-yyyy", params.desde)
            def hasta = new Date().parse("dd-MM-yyyy", params.hasta)

            if(desde > hasta){
                render "no"
            }else{
                render "ok"
            }
        }else{
            render "ok"
        }
    }

    def asientos_ajax(){
        def comprobante = ComprobanteCont.get(params.id)
        def asientos = Asiento.findAllByComprobante(comprobante, [sort: 'numero'])
        return [asientos: asientos, comprobante: comprobante]
    }


}
