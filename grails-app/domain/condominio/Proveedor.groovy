package condominio

class Proveedor {

    static auditable = true
    String tipoPersona = 'N'
    String ruc
    String nombre
    String apellido
    String direccion
    String telefono
    String mail
    Date fecha
    String activo
    String observaciones
    Condominio  condominio

    static mapping = {
        table 'prve'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'prve__id'
            tipoPersona column: 'prvetppr'
            ruc column: 'prve_ruc'
            nombre column: 'prvenmbr'
            apellido column: 'prveapll'
            direccion column: 'prvedire'
            telefono column: 'prvetelf'
            mail column: 'prvemail'
            fecha column: 'prvefcha'
            activo column: 'prveactv'
            observaciones column: 'prveobsr'
            condominio column: 'cndm__id'
        }
    }

    static constraints = {
        tipoPersona(blank: false, nullable: false, inList: ['N', 'J'])
        ruc(blank: false, nullable: false)
        nombre(blank: false, nullable: false)
        apellido(blank: true, nullable: true)
        direccion(blank: true, nullable: true)
        telefono(blank: false, nullable: false)
        mail(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
    }

    String toString(){
        "${this.nombre} ${this.apellido?:''}"
    }
}
