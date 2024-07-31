package contabilidad

class Gestor implements Serializable {
    String estado
    Date fecha
    String nombre
    Fuente fuente
    String observaciones
    String esDepreciacion // S si, N no
    String tipo // G gasto, I inventario
    String codigo

    static auditable = true
    static mapping = {
        table 'gstr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'gstr__id'
        id generator: 'identity'
        version false

        columns {
            estado column: 'gstretdo'
            fecha column: 'gstrfcha'
            nombre column: 'gstrnmbr'
            fuente column: 'fnte__id'
            observaciones column: 'gstrobsr'
            esDepreciacion column: 'gstrdprc'
            tipo column: 'gstrtipo'
            codigo column: 'gstrcdgo'
        }
    }
    static constraints = {
        estado(size: 1..1, blank: false, attributes: [title: 'estado'])
        fecha(blank: true, nullable: true, attributes: [title: 'fecha'])
        nombre(size: 1..127, blank: false, attributes: [title: 'nombre'])
        fuente(blank: true, nullable: true, attributes: [title: 'fuente'])
        observaciones(blank: true,nullable: true, maxSize: 127, attributes: [title: 'observaciones'])
        esDepreciacion(blank: true,nullable: true, maxSize: 1, attributes: [title: 'para definir si es el gestor de la depreciacion'])
        tipo(blank: false, nullable: false, attributes: [title: 'tipo de gestor'], inList: ['G', 'I', 'S', 'C'])
        codigo(blank: true, nullable: true)
    }
}