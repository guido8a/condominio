package condominio

class PagoEgreso {

        static auditable = true
        Egreso egreso
        double valor = 0
        Date fechaPago
        String documento
        String observaciones
        String cheque
//        String comprobante

        static mapping = {
            table 'pgeg'
            cache usage: 'read-write', include: 'non-lazy'
            version false
            id generator: 'identity'
            columns {
                id column: 'pgeg__id'
                egreso column: 'egrs__id'
                valor column: 'pgegvlor'
                fechaPago column: 'pgegfcpg'
                documento column: 'pgegdcmt'
                observaciones column: 'pgegobsr'
                cheque column: 'pgegchqe'
//                comprobante column: 'pgegcmpr'
            }
        }

        static constraints = {
            documento(blank: true, nullable: true)
            observaciones(blank: true, nullable: true)
            cheque(blank: true, nullable: true)
//            comprobante(blank: true, nullable: true)
        }

    }
