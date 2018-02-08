package condominio

class Edificio {

    static auditable = true
    String descripcion

    static mapping = {
        table 'edif'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'edif__id'
            descripcion column: 'edifdscr'
        }
    }

    static constraints = {
        descripcion(blank: false, nullable: false)
    }
}
