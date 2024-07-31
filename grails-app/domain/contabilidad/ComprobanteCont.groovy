package contabilidad

class ComprobanteCont implements Serializable {
    Date fecha
    String descripcion
//    String prefijo
    int    numero
    TipoComprobante tipo
    String registrado
//    String factura
    Contabilidad contabilidad

    static auditable = true
    static mapping = {
        table 'cmco'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cmco__id'
        id generator: 'identity'
        version false
        columns {
            fecha column: 'cmcofcha'
            descripcion column: 'cmcodscr'
            numero column: 'cmconmro'
            tipo column: 'tpcp__id'
            registrado column: 'cmcorgst'
//            prefijo column: 'cmcoprfj'
//            factura column: 'cmcofctr'
            contabilidad column: 'cont__id'
        }
    }
    static constraints = {
        fecha(blank: false, attributes: [title: 'fecha'])
        descripcion(size: 1..255, blank: false, attributes: [title: 'descripcion'])
        numero(blank: true, nullable: true, attributes: [title: 'numero'])
        tipo(blank: false, attributes: [title: 'tipoProveedor'])
        registrado(blank: false, maxSize: 1, attributes: [title: 'registrado'])
//        prefijo(blank: true,nullable: true,size: 1..20)
//        factura(blank: true,nullable: true)
        contabilidad(blank: false, nullable: false)
    }
}