package condominio

import seguridad.Persona

class Admin {

    static auditable = true
    Persona administrador
    Persona revisor
    Date fechaInicio
    Date fechaFin
    double saldoInicial
    double saldoFinal
    double cajaChica = 0
    String observaciones

    static mapping = {
        table 'admn'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'admn__id'
            administrador column: 'prsn__id'
            revisor column: 'prsnrvsr'
            fechaInicio column: 'admnfcin'
            fechaFin column: 'admnfcfn'
            saldoInicial column: 'admnslin'
            saldoFinal column: 'admnslfn'
            cajaChica column: 'admncjch'
            observaciones column: 'admnobsr'
        }
    }

    static constraints = {
        fechaFin(blank: true, nullable: true)
        saldoFinal(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
    }
}
