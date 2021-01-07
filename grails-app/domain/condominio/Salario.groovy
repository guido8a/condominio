package condominio

class Salario {

    static auditable = true
    String descripcion
    static mapping = {
        table 'slro'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'slro__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'slro__id'
            descripcion column: 'slrodscr'
        }
    }
    static constraints = {
       descripcion(blank:false, nullable: false)
    }
}
