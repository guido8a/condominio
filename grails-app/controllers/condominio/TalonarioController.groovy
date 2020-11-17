package condominio

class TalonarioController {

    def talonario(){
        def condominio = Condominio.get(params.id)
        return[condominio:condominio]
    }

    def tablaTalonario_ajax(){
        def condominio = Condominio.get(params.id)
        def talonarios = Talonario.findAllByCondominio(condominio)
        return[talonarios:talonarios.reverse(true)]

    }

    def form_ajax(){

        def condominio = Condominio.get(params.condominio)

        def talonario
        if(params.id){
            talonario = Talonario.get(params.id)
        }else{
            talonario = new Talonario()
        }

        return[talonarioInstance:talonario, condominio: condominio]
    }

    def save_ajax(){
        println("params " + params)

        def fechaIni = new Date().parse("dd-MM-yyyy", params."fechaInicio_input")
        def talonario
        def condominio = Condominio.get(params.condominio)

        if(params.id){
            talonario = Talonario.get(params.id)
        }else{
            talonario = new Talonario()
            talonario.condominio = condominio
            talonario.fecha = new Date()
            talonario.estado = 'V'
        }

        talonario.fechaInicio = fechaIni


        def existeTalonarios = Talonario.findAllByCondominio(condominio)
        def numeroMax = 0

        if(existeTalonarios){
            numeroMax = existeTalonarios?.numeroFin?.max()
            println("max " + numeroMax)
            if(params.numeroInicio.toInteger() <= numeroMax){
                render "er_El número ingresado es menor o igual al último número del talonario anterior."
                return
            }else{
                talonario.numeroInicio = params.numeroInicio.toInteger()
            }
        }else{
            talonario.numeroInicio = params.numeroInicio.toInteger()
        }

        if(!talonario.save(flush:true)){
            println("error al guardar el talonario " + talonario.errors)
            render "no"
        }else{
            render "ok"
        }
    }

    def comprobar_ajax(){
        def condominio = Condominio.get(params.id)
        def existe = Talonario.findAllByCondominioAndEstado(condominio, 'V')

        if(existe){
            render "no"
        }else{
            render "ok"
        }
    }

    def comprobarEdicion_ajax(){
        println("params " + params)
        def talonario = Talonario.get(params.id)

        if(talonario.numeroFin != 0){
            render "no"
        }else{
            render "ok"
        }
    }

    def borrar_ajax(){
        def talonario = Talonario.get(params.id)

        talonario.estado = 'I'
        talonario.fechaFin = new Date()

        if(talonario.numeroFin == 0){
            talonario.numeroFin = talonario.numeroInicio
        }

        if(!talonario.save(flush:true)){
            println("error al borrar el talonario " + talonario.errors)
            render "no"
        }else{
            render "ok"
        }
    }

}
