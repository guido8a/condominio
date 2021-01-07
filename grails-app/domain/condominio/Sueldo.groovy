package condominio

import utilitarios.Anio

class Sueldo {

    static auditable = true
    Anio anio
    Empleado empleado
    double valor
    static mapping = {
        table 'sldo'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'sldo__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'sldo__id'
            anio column: 'anio__id'
            empleado column: 'empl__id'
            valor column: 'sldovlor'
        }
    }
    static constraints = {
        anio(blank:false, nullable: false)
        empleado(blank:false, nullable: false)
        valor(blank:false, nullable:false)
    }
}

