package condominio

class ComprobanteController {

    def comprobante (){
        def condominio = Condominio.get(params.id)

        def texto = Texto.findByCondominioAndCodigo(condominio,'CMPR')

        if(!texto){
            texto = new Texto()
            texto.codigo = 'CMPR'
            texto.condominio = condominio
            texto.save(flush: true)
        }

        def parrafo1 = "ComprobanteCont de pago......."


        return[condominio:condominio, texto:texto, parrafo1: parrafo1]
    }

    def guardarComprobante_ajax() {

        def texto = Texto.get(params.id)
        texto.parrafoUno = params.parrafo1

        if(!texto.save(flush: true)){
            render "no"
        }else{
            render "ok"
        }
    }

    def verificarImpresion_ajax(){
        def comprobante = Comprobante.get(params.id)

        if(comprobante.estado == 'I'){
            render "ok"
        }else{
            if(comprobante.estado == 'V'){

                comprobante.estado = 'I'

                if(!comprobante.save(flush:true)){
                    println("error al cambiar de estado al comprobante " + comprobante.errors)
                    render "no"
                }else{
                    render "ok"
                }
            }else{
                render "ok"
            }
        }
    }
}
