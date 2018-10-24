package condominio

import seguridad.Persona

class Propiedad {

    Persona persona
    TipoPropiedad tipoPropiedad
    Date fechaDesde
    Date fechaHasta
    double valor
    String observaciones
    double alicuota
    String numero
    double area

    static mapping = {
        table 'prop'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'prop__id'
            persona column: 'prsn__id'
            tipoPropiedad column: 'tppp__id'
            fechaDesde column: 'propfcds'
            fechaHasta column: 'propfchs'
            valor column: 'propvlor'
            observaciones column: 'propobsr'
            alicuota column: 'propalct'
            numero column: 'propnmro'
            area column: 'proparea'
        }
    }


    static constraints = {
        persona(nullable: false, blank: false)
        tipoPropiedad(nullable: false, blank: false)
        fechaDesde(nullable: true, blank: true)
        fechaHasta(blank: true, nullable: true)
        valor(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
        alicuota(blank: false, nullable: false)
        numero(blank: true, nullable: true)   // TODO: cambiar luego a false
        area(blank: true, nullable: true)
    }
}
