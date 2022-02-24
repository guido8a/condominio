package condominio

class TipoDocumento {

    static auditable = true
    String descripcion

    static mapping = {
        table 'tpdc'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'tpdc__id'
            descripcion column: 'tpdcdscr'
        }
    }

    static constraints = {
        descripcion(blank: false, nullable: false)
    }
}
