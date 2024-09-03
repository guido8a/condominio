package condominio

class PagoEgreso {

        static auditable = true
        Egreso egreso
        double valor = 0
        Date fechaPago
        String documento
        String observaciones
        String cheque
        String estado
        String revision
        String estadoAdministrador
        String cajaChica = 'N'
        String registrado = 'N'

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
                estado column: 'pgegetdo'
                revision column: 'pgegrevs'
                estadoAdministrador column: 'pgegedad'
                cajaChica column: 'pgegcjch'
                registrado column: 'pgegrgst'
            }
        }

        static constraints = {
            documento(blank: true, nullable: true)
            observaciones(blank: true, nullable: true)
            cheque(blank: true, nullable: true)
            estado(blank: true, nullable: true)
            revision(blank: true, nullable: true)
            estadoAdministrador(blank: true, nullable: true)
            cajaChica(blank: true, nullable: true)
            registrado(blank: true, nullable: true)
        }

    }
