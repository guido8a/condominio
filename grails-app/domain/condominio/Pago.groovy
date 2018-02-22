package condominio

class Pago {

    static auditable = true
    Ingreso ingreso
    double valor = 0
    Date fechaPago
    String documento
    String observaciones

    static mapping = {
        table 'pago'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'pago__id'
            ingreso column: 'ingr__id'
            valor column: 'pagovlor'
            fechaPago column: 'pagofcpg'
            documento column: 'pagodcmt'
            observaciones column: 'pagoobsr'
        }
    }

    static constraints = {
        documento(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
    }
}
