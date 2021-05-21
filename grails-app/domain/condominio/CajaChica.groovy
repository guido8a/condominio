package condominio

class CajaChica {

    Condominio condominio
    Date fecha
    double valor
    String observaciones
    String cheque

    static mapping = {
        table 'cjch'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cjch__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cjch__id'
            condominio column: 'cndm__id'
            fecha column: 'cjchfcha'
            valor column: 'cjchvlor'
            observaciones column: 'cjchobsr'
            cheque column: 'cjchchqe'
        }
    }
    static constraints = {
        condominio(nullable: false, blank: false)
        fecha(nullable: false, blank: false)
        valor(nullable: false, blank: false)
        observaciones(nullable: true, blank: true)
        cheque(nullable: true, blank: true)
    }
}
