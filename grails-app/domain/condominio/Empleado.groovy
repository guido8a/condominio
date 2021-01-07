package condominio

class Empleado {

    static auditable = true
    Condominio condominio
    String nombre
    String apellido
    String cedula
    String sexo
    String direccion
    String telefono
    String mail
    Date fechaRegistro
    Date fechaNacimiento
    Date fechaInicio
    Date fechaFin
    int activo
    String cargo
    String observaciones

    static mapping = {
        table 'empl'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'empl__id'
            condominio column: 'cndm__id'
            nombre column: 'emplnmbr'
            apellido column: 'emplapll'
            cedula column: 'emplcdla'
            sexo column: 'emplsexo'
            direccion column: 'empldire'
            telefono column: 'empltelf'
            mail column: 'emplmail'
            fechaRegistro column: 'emplfcha'
            fechaNacimiento column: 'emplfcna'
            activo column: 'emplactv'
            cargo column: 'emplcrgo'
            fechaInicio column: 'emplfcin'
            fechaFin column: 'emplfcfn'
            observaciones column: 'emplobsr'

        }
    }

    static constraints = {
        condominio(blank: false, nullable: false)
        nombre(size: 3..31, blank: false, nullable: false)
        apellido(size: 3..31, blank: false, nullable: false)
        cedula(blank: true, nullable: true)
        sexo(inList: ["F", "M"], size: 1..1, blank: false, attributes: ['mensaje': 'Sexo de la persona'])
        direccion(size: 3..255, blank: true, nullable: true)
        telefono(size: 3..63, blank: true, nullable: true)
        mail(size: 3..63, blank: true, nullable: true)
        activo(blank:false, nullable: false)
        fechaRegistro(blank:true, nullable: true)
        fechaNacimiento(blank:true, nullable: true)
        cargo(size: 1..127,blank:false, nullable: false)
        fechaInicio(blank:true, nullable: true)
        fechaFin(blank:true, nullable: true)
        observaciones(size: 1..255,blank:false, nullable: false)
    }
}
