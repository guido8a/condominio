package condominio

class Comprobante {

    Condominio condominio
    Pago pago
    String texto
    Date fecha
    int numero
    String estado

    static mapping = {
        table 'cmpr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cmpr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cmpr__id'
            condominio column: 'cndm__id'
            pago column: 'pago__id'
            texto column: 'cmprtxto'
            fecha column: 'cmprfcha'
            numero column: 'cmprnmro'
            estado column: 'cmpretdo'
        }
    }

    static constraints = {
        condominio(blank: false, nullable: false)
        pago(blank:false, nullable: false)
        texto(blank: true, nullable: true)
        fecha(blank: true, nullable: true)
        numero(blank: true, nullable: true)
        estado(blank: true, nullable: true)
    }
}
