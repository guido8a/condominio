package condominio

class TipoAporte {

    static auditable = true
    String codigo
    String descripcion

    static mapping = {
        table 'tpap'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'tpap__id'
            descripcion column: 'tpapdscr'
        }
    }

    static constraints = {
        descripcion(blank: false, nullable: false)
    }
}
