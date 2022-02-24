package condominio

class Documento {
    /**
     * Condominio al cual pertenece el documento
     */
    Condominio condominio
    /**
     * Tipo de documento
     */
    TipoDocumento tipoDocumento
    /**
     * Descripción del documento
     */
    String descripcion
    /**
     * Palabras claves del documento
     */
    String clave
    /**
     * Resumen del documento
     */
    String resumen
    /**
     * Path del archivo del documento
     */
    String ruta

    Date fecha

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dcmt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dcmt__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'dcmt__id'
            condominio column: 'cndm__id'
            tipoDocumento column: 'tpdc__id'
            descripcion column: 'dcmtdscr'
            clave column: 'dcmtclve'
            resumen column: 'dcmtrsmn'
            ruta column: 'dcmtruta'
            fecha column: 'dcmtfcha'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        condominio(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        tipoDocumento(blank: true, nullable: true, attributes: [mensaje: 'Grupo de Procesos'])
        descripcion(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Descripción del documento'])
        clave(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Palabras clave'])
        resumen(size: 1..1024, blank: true, nullable: true, attributes: [mensaje: 'Resumen'])
        ruta(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Ruta del documento'])
        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha del documento'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}