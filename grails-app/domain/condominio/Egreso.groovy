package condominio

class Egreso {

    static auditable = true
    Proveedor proveedor
    TipoGasto tipoGasto
    Date fecha
    double valor
    String estado
//    double abono = 0
//    Date fechaPago = new Date()
    String descripcion

    static mapping = {
        table 'egrs'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'egrs__id'
            proveedor column: 'prve__id'
            tipoGasto column: 'tpgs__id'
            fecha column: 'egrsfcha'
            valor column: 'egrsvlor'
            estado column: 'egrsetdo'
//            abono column: 'egrsabno'
//            fechaPago column: 'egrsfcpg'
            descripcion column: 'egrsdscr'
        }
    }

    static constraints = {
        descripcion(blank: true, nullable: true)
    }
}
