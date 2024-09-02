package contabilidad

import condominio.Condominio
import condominio.TipoAporte
import condominio.TipoGasto

class Gestor implements Serializable {
    Condominio condominio
    TipoAporte tipoAporte
    TipoGasto tipoGasto
    TipoComprobante tipoComprobante
    String estado
//    String tipo
    Date fecha
    String nombre
    String observaciones

    static auditable = true
    static mapping = {
        table 'gstr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'gstr__id'
        id generator: 'identity'
        version false

        columns {
            condominio column: 'cndm__id'
            tipoAporte column: 'tpap__id'
            tipoGasto column: 'tpgs__id'
            tipoComprobante column: 'tpcp__id'
            estado column: 'gstretdo'
            fecha column: 'gstrfcha'
            nombre column: 'gstrnmbr'
            observaciones column: 'gstrobsr'
//            tipo column: 'gstrtipo'
//            codigo column: 'gstrcdgo'
        }
    }
    static constraints = {
        condominio(blank: false, nullable: false)
        tipoAporte(blank: true, nullable: true)
        tipoGasto(blank: true, nullable: true)
        tipoComprobante(blank: false, nullable: false)
        estado(size: 1..1, blank: false, attributes: [title: 'estado'])
//        tipo(blank: false, nullable: false, attributes: [title: 'tipo de gestor'], inList: ['G', 'I', 'S', 'C'])
        fecha(blank: true, nullable: true, attributes: [title: 'fecha'])
        nombre(size: 1..127, blank: false, attributes: [title: 'nombre'])
//        fuente(blank: true, nullable: true, attributes: [title: 'fuente'])
        observaciones(blank: true,nullable: true, maxSize: 127, attributes: [title: 'observaciones'])
//        esDepreciacion(blank: true,nullable: true, maxSize: 1, attributes: [title: 'para definir si es el gestor de la depreciacion'])
//        codigo(blank: true, nullable: true)
    }
}