package contabilidad

class TipoComprobante implements Serializable {
    String codigo
    String descripcion

    static mapping = {
        table 'tpcp'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpcp__id'
        id generator: 'identity'
        version false
        columns {
            codigo column: 'tpcpcdgo'
            descripcion column: 'tpcpdscr'
        }
    }
    static constraints = {
        codigo(size: 1..1, blank: true, nullable: true, attributes: [title: 'codigo'])
        descripcion(blank: true, nullable: true, size: 1..31, attributes: [title: 'descripcion'])
    }
}