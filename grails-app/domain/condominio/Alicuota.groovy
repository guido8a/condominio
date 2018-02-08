package condominio

import seguridad.Persona

class Alicuota {

    static auditable = true
    Persona persona
    Date fechaDesde
    Date fechaHasta
    double valor
    String observaciones

    static mapping = {
        table 'alct'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'alct__id'
            persona column: 'prsn__id'
            fechaDesde column: 'alctfcds'
            fechaHasta column: 'alctfchs'
            valor column: 'alctvlor'
            observaciones column: 'alctobsr'
        }
    }

    static constraints = {
        observaciones(blank: true, nullable: true)
    }
}
