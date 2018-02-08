package condominio

import seguridad.Persona

class Obra {

    static auditable = true
    Proveedor proveedor
    Persona persona
    TipoObra tipoObra
    String descripcion
    Date fecha
    Date fechaInicio
    Date fechaFin
    double presupuesto
    int plazo
    String observaciones

    static mapping = {
        table 'obra'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'obra__id'
            proveedor column: 'prve__id'
            persona column: 'prsn__id'
            tipoObra column: 'tpob__id'
            descripcion column: 'obradscr'
            fecha column: 'obrafcha'
            fechaInicio column: 'obrafcin'
            fechaFin column: 'obrafcfn'
            presupuesto column: 'obraprsp'
            plazo column: 'obraplzo'
            observaciones column: 'obraobsr'
        }
    }
    static constraints = {
        descripcion(blank: false, nullable: false)
        observaciones(blank: true, nullable: true)
    }
}
