package condominio

class Obligacion {

    static auditable = true
    String descripcion
    Date fecha
    String tipo
    double valor

    static mapping = {
        table 'oblg'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'oblg__id'
            descripcion column: 'oblgsdscr'
            fecha column: 'oblgfcha'
            tipo column: 'oblgtipo'
            valor column: 'oblgvlor'
        }
    }

    static constraints = {
        descripcion(blank: false, nullable: false)
    }
}
