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
    String estado
    String revision
    String estadoAdministrador
    String transferencia = 'N'
    double descuento
    double banco = 0
    String anterior = 'N'
    String registrado = 'N'


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
            estado column: 'pagoetdo'
            revision column: 'pagorevs'
            estadoAdministrador column: 'pagoedad'
            transferencia column: 'pagotrnf'
            descuento column: 'pagodsct'
            banco column: 'pagobnco'
            anterior column: 'pagoantr'
            registrado column: 'pagorgst'
        }
    }

    static constraints = {
        documento(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
        estado(blank: true, nullable: true)
        revision(blank: true, nullable: true)
        estadoAdministrador(blank: true, nullable: true)
        transferencia(inList: ["S", "N"], size: 1..1, blank: false, attributes: ['mensaje': 'Transferencia'])
        descuento(blank:true, nullable:true)
        banco(blank:true, nullable:true)
        registrado(blank:true, nullable:true)
    }
}
