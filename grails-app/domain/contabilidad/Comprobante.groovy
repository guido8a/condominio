package contabilidad

class Comprobante implements Serializable {
    Date fecha
    String descripcion
    String prefijo
    int    numero
    TipoComprobante tipo
    String registrado
    String factura
    Contabilidad contabilidad

    static auditable = true
    static mapping = {
        table 'cmpr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cmpr__id'
        id generator: 'identity'
        version false
        columns {
            fecha column: 'cmprfcha'
            descripcion column: 'cmprdscr'
            numero column: 'cmprnmro'
            tipo column: 'tpcp__id'
            registrado column: 'cmprrgst'
            prefijo column: 'cmprprfj'
            factura column: 'cmprfctr'
            contabilidad column: 'cont__id'
        }
    }
    static constraints = {
        fecha(blank: false, attributes: [title: 'fecha'])
        descripcion(size: 1..255, blank: false, attributes: [title: 'descripcion'])
        numero(blank: true, nullable: true, attributes: [title: 'numero'])
        tipo(blank: false, attributes: [title: 'tipoProveedor'])
        registrado(blank: false, maxSize: 1, attributes: [title: 'registrado'])
        prefijo(blank: true,nullable: true,size: 1..20)
        factura(blank: true,nullable: true)
        contabilidad(blank: false, nullable: false)
    }
}