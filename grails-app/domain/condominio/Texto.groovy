package condominio

class Texto {

    Condominio condominio
    String codigo
    String parrafoUno
    String parrafoDos
    String parrafoTres
    String nota

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
        }
    }

    static constraints = {
        codigo(blank: false, nullable: false)
        parrafoUno(blank: true, nullable: true)
        parrafoDos(blank: true, nullable: true)
        parrafoTres(blank: true, nullable: true)
        nota(blank: true, nullable: true)
    }
}
