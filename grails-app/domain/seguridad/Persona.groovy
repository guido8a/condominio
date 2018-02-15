package seguridad

import condominio.Edificio
import condominio.TipoOcupacion

class Persona {
    TipoOcupacion tipoOcupacion
    Edificio edificio
    String nombre
    String apellido
    String sexo
    Date fecha
    Date fechaInicio
    Date fechaFin
    String mail
    String telefono
    String direccion
    String login
    String password
    Date fechaNacimiento
    String autorizacion
    int activo = 1
    String cargo
    String departamento    /* numero identificador de la vivienda */
    String ruc
    double alicuota
    String observaciones

    static hasMany = [perfiles: Sesn]

    def permisos = []

    static mapping = {
        table 'prsn'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'prsn__id'
            edificio column: 'edif__id'
            tipoOcupacion column: 'tpoc__id'
            nombre column: 'prsnnmbr'
            apellido column: 'prsnapll'
            sexo column: 'prsnsexo'
            fecha column: 'prsnfcha'
            fechaInicio column: 'prsnfcin'
            fechaFin column: 'prsnfcfn'
            mail column: 'prsnmail'
            telefono column: 'prsntelf'
            login column: 'prsnlogn'
            password column: 'prsnpass'
            autorizacion column: 'prsnatrz'
            activo column: 'prsnactv'
            cargo column: 'prsncrgo'
            departamento column: 'prsndpto'
            ruc column: 'prsn_ruc'
            direccion column: 'prsndire'
            fechaNacimiento column: 'prsnfcna'
            alicuota column: 'prsnalct'
            observaciones column: 'prsnobsr'
        }
    }
    static constraints = {
        nombre(size: 3..30, blank: false)
        apellido(size: 3..30, blank: false)
        ruc(blank: false, nullable: false)
        sexo(inList: ["F", "M"], size: 1..1, blank: false, attributes: ['mensaje': 'Sexo de la persona'])
        mail(size: 3..63, blank: true, nullable: true)
        login(size: 4..14, blank: false, unique: true)
        password(blank: false)
        autorizacion(matches: /^[a-zA-Z0-9ñÑáéíóúÁÉÍÚÓüÜ_-]+$/, blank: true, nullable: true, attributes: [mensaje: 'Contraseña para autorizaciones'])
        activo(blank: false, attributes: [title: 'activo'])
        telefono(blank: false, attributes: [title: 'teléfono'])
        fechaInicio(blank: true, nullable: true, attributes: [title: 'Fecha de inicio'])
        fechaFin(blank: true, nullable: true, attributes: [title: 'Fecha de finalización'])
        cargo(blank: true, nullable: true, size: 1..255, attributes: [mensaje: 'Cargo'])
        direccion(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)
        fechaNacimiento(blank: true, nullable: true)
    }

    String toString() {
        "${this.nombre} ${this.apellido} Departamento:(${this.departamento})"
    }

    def getEstaActivo() {
        if (this.activo != 1) {
            return false
        }
        def now = new Date()
        def accs = Accs.findAllByUsuarioAndAccsFechaFinalGreaterThanEquals(this, now)
//        println "accs "+accs?.accsFechaInicial+"  "+accs?.accsFechaFinal
        def res = true
        accs.each {
//            println "it  "+it.accsFechaInicial.format('dd-MM-yyyy')+"  "+(it.accsFechaInicial >= now)+"  "+now.format('dd-MM-yyyy')
            if (res) {
                if (it.accsFechaInicial <= now) {
//                println "ret false"
                    res = false
                }
            }

        }
        return res
    }

    def vaciarPermisos() {
        this.permisos = []
    }

    Boolean getEsDirector() {
        return this.cargo?.toLowerCase()?.contains("director")
    }

    Boolean getEsGerente() {
        return this.cargo?.toLowerCase()?.contains("gerente")
    }


}
