package contabilidad

import condominio.Condominio

class Contabilidad implements Serializable {
    Date fechaCierre
    Date fechaInicio
    String prefijo
    String descripcion
    Condominio condominio

    static mapping = {
        table 'cont'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cont__id'
        id generator: 'identity'
        version false
        columns {
            fechaCierre column: 'contfcci'
            fechaInicio column: 'contfcin'
            prefijo column: 'contpref'
            descripcion column: 'contdscr'
            condominio column: 'cndm__id'
        }
    }

    static constraints = {
        fechaCierre(blank: true, nullable: true, attributes: [title: 'Fecha de cierre del periodo comtable'])
        fechaInicio(blank: false, attributes: [title: 'Fecha de inicio del periodo comtable'])
        prefijo(size: 1..8, blank: true, nullable: true, attributes: [title: 'Prefijo del periodo para reportes'])
        descripcion(size: 1..63, blank: false, attributes: [title: 'Descripción del periodo contable'])
        condominio(blank: true, nullable: true, attributes: [title: 'Institución o empresa a la que pertenece el periodo contable'])
    }

    String toString() {
        return this.descripcion + ": desde " + this.fechaInicio.format("dd-MM-yyyy") + " hasta " + this.fechaCierre.format("dd-MM-yyyy")
    }
}