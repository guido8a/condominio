package condominio

import seguridad.Persona

class Ingreso {

    static auditable = true
    Persona persona
    Obligacion obligacion
    Date fecha
    double valor
    String estado = 'E'
    String observaciones

    static mapping = {
        table 'ingr'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'ingr__id'
            persona column: 'prsn__id'
            obligacion column: 'oblg__id'
            fecha column: 'ingrfcha'
            valor column: 'ingrvlor'
            estado column: 'ingretdo'
//            abono column: 'ingrabno'
//            fechaPago column: 'ingrfcpg'
//            documento column: 'ingrdcmt'
            observaciones column: 'ingrobsr'
        }
    }

    static constraints = {
//        documento(blank: true, nullable: true)
//        fechaPago(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
    }
}
