package condominio

class TipoOcupacion {
    static auditable = true
    String codigo
    String descripcion

    static mapping = {
        table 'tpoc'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'tpoc__id'
            codigo column: 'tpoccdgo'
            descripcion column: 'tpocdscr'
        }
    }

    static constraints = {
        codigo(blank: false)
        descripcion(blank: false)
    }

    String toString() {
        "${this.descripcion}"
    }
}
