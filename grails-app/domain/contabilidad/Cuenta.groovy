package contabilidad

import condominio.Condominio

class Cuenta implements Serializable {
    String auxiliar
    String movimiento
    String descripcion
    Cuenta padre
    String numero
    Condominio condominio
    Nivel nivel
    String estado

    static mapping = {
        table 'cnta'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cnta__id'
        id generator: 'identity'
        version false
        columns {
            auxiliar column: 'cntaauxl'
            movimiento column: 'cntamvmt'
            descripcion column: 'cntadscr'
            padre column: 'cntapdre'
            numero column: 'cntanmro'
            condominio column: 'cndm__id'
            nivel column: 'nvel__id'
            estado column: 'cntaetdo'
        }
    }

    static constraints = {
        auxiliar(size: 1..1, inList: ['S', 'N'], blank: true, nullable: true, attributes: [title: 'Si puede o no tener auxiliares'])
        movimiento(size: 1..1, inList: ['1', '0'], blank: true, nullable: true, attributes: [title: 'Si puede o no tener movimientos'])
        descripcion(size: 1..255, blank: false, attributes: [title: 'Descripción'])
        padre(size: 1..20, blank: true, nullable: true, attributes: [title: 'Cuenta padre'])
        numero(size: 1..20, blank: false, attributes: [title: 'Número de cuenta'])
        condominio(blank: true, nullable: true, attributes: [title: 'Empresa a la que pertenece la cuenta'])
        nivel(blank: false, attributes: [title: 'Nivel'])
        estado(blank: false, maxSize: 1, attributes: [title: 'Estado'])
    }

    String toString() {
        return this.numero + " - " + this.descripcion
    }

}