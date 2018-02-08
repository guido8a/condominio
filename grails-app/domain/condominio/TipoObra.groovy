package condominio

class TipoObra {

    static auditable = true
    String descripcion

    static mapping = {
        table 'tpob'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'tpob__id'
            descripcion column: 'tpobdscr'
        }
    }

    static constraints = {
        descripcion(blank: false, nullable: false)
    }
}
