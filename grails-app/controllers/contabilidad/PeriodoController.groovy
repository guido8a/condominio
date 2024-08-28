package contabilidad

import seguridad.Shield

import java.text.SimpleDateFormat
import java.time.LocalDate
import java.util.Date;
import java.time.ZoneId

/**
 * Controlador que muestra las pantallas de manejo de Periodo
 */
class PeriodoController extends Shield {

    def list(){
        def contabilidad = Contabilidad.get(session.contabilidad.id)
        def periodos = Periodo.findAllByContabilidad(contabilidad)
//        def periodos = []
        return [periodos: periodos, contabilidad: contabilidad]
    }

    def form_ajax(){

        def periodoInstance

        if(params.id){
            periodoInstance = Periodo.get(params.id)
        }else{
            periodoInstance = new Periodo()
        }

        return [periodoInstance: periodoInstance]
    }

    def guardarPeriodo_ajax(){
//        println("params " + params)

        def periodo = Periodo.get(params.id)

        if(periodo){
            periodo.properties = params

            if(!periodo.save(flush: true)){
                println("Error al guardar el período " + periodo.errors)
                render "no_Error al guardar el período"
            }else{
                render "ok_Período guardado correctamente"
            }
        }else{
            render "no_No se encontró el período"
        }
    }

    def crearPeriodos_ajax(){
        def errores = ''
        def contabilidad = Contabilidad.get(session.contabilidad.id)
//        def periodos = Periodo.findAllByContabilidad(contabilidad)
                def periodos = []

        if(periodos){
            render "no_Ya existen períodos creados para la contabilidad actual"
        }else{

            Date date = new Date();
            LocalDate localDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            int year  = localDate.getYear();
            int month = localDate.getMonthValue();
            int day   = localDate.getDayOfMonth();

            println("año " + year)
            println("mes " + month)
            println("dia " + day)

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            Calendar calendar = Calendar.getInstance()
//            calendar.set(Calendar.DAY_OF_MONTH,1)
//            println("calendar " + sdf.format(calendar.getTime()))
//            calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH));
//            println("calendar " + sdf.format(calendar.getTime()))
//            println("calendar " + calendar.getActualMaximum(Calendar.DAY_OF_MONTH))


            calendar.set(Calendar.YEAR, year);
            calendar.set(Calendar.MONTH, 1);

            def anio = new Date().getYear()


//            println("primer dia " + calendar.getActualMinimum(Calendar.DAY_OF_MONTH))
//            println("ultimo dia " + calendar.getActualMaximum(Calendar.DAY_OF_MONTH))

            for(int i= 0;  i < 12 ;i++ ){
                calendar.set(Calendar.MONTH, i);
                println("mes " + calendar.get(Calendar.MONTH))
                println("primer dia " + calendar.getActualMinimum(Calendar.DAY_OF_MONTH))
                println("ultimo dia " + calendar.getActualMaximum(Calendar.DAY_OF_MONTH))
                println(new Date(anio, i, (calendar.getActualMinimum(Calendar.DAY_OF_MONTH))).format("dd-MM-yyyy"))
                println(new Date(anio, i, (calendar.getActualMaximum(Calendar.DAY_OF_MONTH))))

                def periodo

                periodo = new Periodo()
                periodo.contabilidad = contabilidad
                periodo.numero = i + 1
                periodo.fechaInicio = new Date(anio, i, (calendar.getActualMinimum(Calendar.DAY_OF_MONTH)))
                periodo.fechaFin = new Date(anio, i, (calendar.getActualMaximum(Calendar.DAY_OF_MONTH)))

                if(!periodo.save(flush:true)){
                    errores += periodo.errors
                }
            }


            if(errores != ''){
                println("error al guardar el periodo " + errores)
                render "no_Error al guardar el período"
            }else{
                render "ok_Período guardado correctamente"
            }

        }

    }


    
}
