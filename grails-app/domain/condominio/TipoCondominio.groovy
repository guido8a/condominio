package condominio

class TipoCondominio implements Serializable {

        String descripcion

        static mapping = {
            table 'tpcd'
            cache usage: 'read-write', include: 'non-lazy'
            id column: 'tpcd__id'
            id generator: 'identity'
            version false
            columns {
                id column: 'tpcd__id'
                descripcion column: 'tpcddscr'
            }
        }
        static constraints = {

            descripcion(nullable: false, blank: false, attributes: [title: 'tipo de condominio'])

        }
}
