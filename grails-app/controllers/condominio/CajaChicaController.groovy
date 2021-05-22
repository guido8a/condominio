package condominio

class CajaChicaController {

    def list(){
        def cajas = CajaChica.list().sort{it.fecha}
        return[cajas:cajas]
    }

    def form_ajax(){
        def condominio = Condominio.get(session.condominio.id)
        def cajaChicaInstance

        if(params.id){
            cajaChicaInstance = CajaChica.get(params.id)
        }else{
            cajaChicaInstance = new CajaChica()
        }

        return[cajaChicaInstance: cajaChicaInstance, condominio: condominio]
    }

    def save_ajax(){
        println("params " + params)

        def cajaChica

        if(params.id){
            cajaChica = CajaChica.get(params.id)
        }else{
            cajaChica = new CajaChica()
        }

        cajaChica.properties = params
        cajaChica.valor = params.valor.toDouble()

        if(!cajaChica.save(flush: true)){
            println("error al guardar la caha chica" + cajaChica.errors)
            render "no"
        }else{
            render "ok"
        }
    }

    def delete_ajax(){
       def  cajaChica = CajaChica.get(params.id)

        try{
            cajaChica.delete(flush:true)
            render "ok"
        }catch(e){
            println("error al borrar la caja chica " + cajaChica.errors)
            render "no"
        }
    }

}
