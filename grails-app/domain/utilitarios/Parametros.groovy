package utilitarios

class Parametros {
    static auditable = true
    String nombre
    String ciudad
    String telefono
    String direccion
    int viviendas

    static mapping = {
        table 'prmt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prmt__id'
        id generator: 'identity'
        version false
        columns {
            nombre column: 'prmtnmbr'
            ciudad column: 'prmtcdad'
            telefono column: 'prmttelf'
            direccion column: 'prmtdire'
            viviendas column: 'prmtvvnd'
        }
    }
    static constraints = {
        nombre(blank: false, nullable: false, attributes: [title: 'Nombre del condominio'])
        direccion(blank: false, nullable: false, attributes: [title: 'Dirección'])
        ciudad(blank: false, nullable: false, attributes: [title: 'ciudad'])
        telefono(blank: false, nullable: false, size:0..63, attributes: [title: 'Teléfono'])
    }

}
