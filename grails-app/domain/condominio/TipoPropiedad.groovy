package condominio

class TipoPropiedad {

    String descripcion

    static mapping = {
        table 'tppp'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'tppp__id'
            descripcion column: 'tpppdscr'
        }
    }

    static constraints = {

        descripcion(nullable: false, blank: false, size: 1..63)

    }
}
