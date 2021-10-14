package condominio

class Texto {

    Condominio condominio
    String codigo
    String parrafoUno
    String parrafoDos
    String parrafoTres
    String nota
    String nombre
    String cargo
    String contacto

    static mapping = {
        table 'txto'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'txto__id'
            condominio column: 'cndm__id'
            codigo column: 'txtocdgo'
            parrafoUno column: 'txtoslp1'
            parrafoDos column: 'txtoslp2'
            parrafoTres column: 'txtoslp3'
            nota column: 'txtoslnt'
            nombre column: 'txtoln01'
            cargo column: 'txtoln02'
            contacto column: 'txtoln03'
        }
    }

    static constraints = {
        codigo(blank: false, nullable: false)
        parrafoUno(blank: true, nullable: true)
        parrafoDos(blank: true, nullable: true)
        parrafoTres(blank: true, nullable: true)
        nota(blank: true, nullable: true)
        nombre(blank: true, nullable: true)
        cargo(blank: true, nullable: true)
        contacto(blank: true, nullable: true)
    }
}
