package condominio

class Canton implements Serializable {

    String nombre
    String provincia

    static mapping = {
        table 'cntn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cntn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cntn__id'
            nombre column: 'cntnnmbr'
            provincia column: 'cntnprov'
        }
    }
    static constraints = {

        nombre(nullable: false, blank: false, attributes: [title: 'nombre del canton'])

    }
}