package condominio

class Pago {

    static auditable = true
    Ingreso ingreso
    double valor = 0
    Date fechaPago
    String documento
    String observaciones
    double mora = 0;
    double tasa = 0;
    int mess = 0;

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
            mora column: 'pagomora'
            tasa column: 'pagotasa'
            mess column: 'pagomess'
        }
    }

    static constraints = {
        documento(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
    }
}
