package seguridad

class Modulo {
    String nombre
    String descripcion
    int orden
    static auditable = [ignore: []]

    static mapping = {
        table 'mdlo'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'mdlo__id'
            nombre column: 'mdlonmbr'
            descripcion column: 'mdlodscr'
            orden column: 'mdloordn'
        }
    }

    static constraints = {
        nombre(blank: false, size: 0..31)
        descripcion(blank: false, size: 0..63)
    }

    String toString() {
        "${this.nombre}"
    }
}
