package utilitarios

class Anio {
    static auditable = true
    String numero
    Integer estado          //1-> activo, 0-> no activo
    double sueldoBasico
    static mapping = {
        table 'anio'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'anio__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'anio__id'
            numero column: 'anionmro'
            estado column: 'anioetdo'
            sueldoBasico column: 'anio_sbu'
        }
    }
    static constraints = {
        numero(maxSize: 4, blank: false, attributes: [title: 'numero'])
        sueldoBasico(blank:true, nullable:true)
    }
}