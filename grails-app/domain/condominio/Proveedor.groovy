package condominio

class Proveedor {

    static auditable = true
    String ruc
    String nombre
    String apellido
    String direccion
    String telefono
    String mail
    Date fecha
    String activo
    String observaciones

    static mapping = {
        table 'prve'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'prve__id'
            ruc column: 'prve_ruc'
            nombre column: 'prvenmbr'
            apellido column: 'prveapll'
            direccion column: 'prvedire'
            telefono column: 'prvetelf'
            mail column: 'prvemail'
            fecha column: 'prvefcha'
            activo column: 'prveactv'
            observaciones column: 'prveobsr'
        }
    }

    static constraints = {
        ruc(blank: false, nullable: false)
        nombre(blank: false, nullable: false)
        apellido(blank: true, nullable: true)
        direccion(blank: true, nullable: true)
        telefono(blank: false, nullable: false)
        mail(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
    }
}
