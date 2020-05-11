package condominio

class Obligacion {

    static auditable = true
    String descripcion
    Date fecha
    double valor
    TipoAporte tipoAporte
    Condominio condominio

    static mapping = {
        table 'oblg'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'oblg__id'
            descripcion column: 'oblgdscr'
            tipoAporte column: 'tpap__id'
            condominio column: 'cndm__id'
            fecha column: 'oblgfcha'
            valor column: 'oblgvlor'
        }
    }

    static constraints = {
        descripcion(blank: false, nullable: false)
    }
}
