package contabilidad

class Genera implements Serializable {
    double ice = 0
    double porcentajeImpuestos = 0
    double porcentaje = 0
    double baseSinIva = 0
    double flete = 0
    double valor = 0
    TipoComprobante tipoComprobante
    Cuenta cuenta
    Gestor gestor
    String debeHaber

    static auditable = true

    static mapping = {
        table 'gnra'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'gnra__id'
        id generator: 'identity'
        version false
        columns {
            ice column: 'gnra_ice'
            porcentajeImpuestos column: 'gnrapcim'
            porcentaje column: 'gnrapcnt'
            tipoComprobante column: 'tpcp__id'
            cuenta column: 'cnta__id'
            gestor column: 'gstr__id'
            debeHaber column: 'gnradbhb'
            baseSinIva column: 'gnrapcbz'
            flete column: 'gnraflte'
            valor column: 'gnravlor'
//            retRenta column: 'gnrartrn'
        }
    }
    static constraints = {
        tipoComprobante(blank: false, attributes: [title: 'tipoProveedor'])
        cuenta(blank: true, nullable: true, attributes: [title: 'cuenta'])
        gestor(blank: false, nullable: false, attributes: [title: 'gestor'])
        debeHaber(blank: false, maxSize: 1, attributes: [title: 'debe o haber'])
    }
}