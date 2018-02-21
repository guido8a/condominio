package condominio

class TipoGasto {

    static auditable = true
    String descripcion

    static mapping = {
        table 'tpgs'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'tpgs__id'
            descripcion column: 'tpgsdscr'
        }
    }

    static constraints = {
        descripcion(blank: false, nullable: false)
    }

    String toString() {
        this.descripcion
    }
}
