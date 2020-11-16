package condominio

class Talonario {

    Condominio condominio
    Date fecha
    Date fechaInicio
    Date fechaFin
    int numeroInicio
    int numeroFin
    String estado

    static mapping = {
        table 'tlnr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tlnr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tlnr__id'
            condominio column: 'cndm__id'
            fecha column: 'tlnrfcha'
            fechaInicio column: 'tlnrfcin'
            fechaFin column: 'tlnrfcfn'
            numeroInicio column: 'tlnrnmin'
            numeroFin column: 'tlnrnmfn'
            estado column: 'tlnretdo'
        }
    }

    static constraints = {
        condominio(blank:false, nullable: false)
        fecha(blank:true, nullable: true)
        fechaInicio(blank:true, nullable: true)
        fechaFin(blank:true, nullable: true)
        numeroInicio(blank:false, nullable: false)
        numeroFin(blank:true, nullable: true)
        estado(blank: true, nullable: true)
    }
}
