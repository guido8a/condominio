package condominio

class Condominio {
    TipoCondominio tipoCondominio
    Canton canton
    String nombre
    String ruc
    String direccion
    String telefono
    Date fechaInicio
    Date fechaFin
    String email
    String sigla
    int numeroViviendas = 0

    static mapping = {
        table 'cndm'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cndm__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cndm__id'
            tipoCondominio column: 'tpcd__id'
            canton column: 'cntn__id'
            nombre column: 'cndmnmbr'
            ruc column: 'cndm_ruc'
            direccion column: 'cndmdire'
            telefono column: 'cndmtelf'
            fechaInicio column: 'cndmfcin'
            fechaFin column: 'cndmfcfn'
            email column: 'cndmmail'
            sigla column: 'cndmsgla'
            numeroViviendas column: 'cndmnmvv'
        }
    }
    static constraints = {
        tipoCondominio(blank: false, nullable: false, attributes: [title: 'tipo'])
        canton(blank: false, nullable: false, attributes: [title: 'Cantón'])
        nombre(size: 1..63, blank: false, nullable: false, attributes: [title: 'Nombre'])
        ruc(size: 1..13, blank: true, nullable: true, attributes: [title: 'RUC'])
        direccion(size: 1..127, blank: true, nullable: true, attributes: [title: 'Dirección'])
        telefono(size: 1..63, blank: true, nullable: true, attributes: [title: 'Teléfono'])
        fechaInicio(blank: false, nullable: false, attributes: [title: 'Fecha de inicio'])
        fechaFin(blank: true, nullable: true, attributes: [title: 'Fecha de fin'])
        email(size: 1..63, blank: true, nullable: true, email: true, attributes: [title: 'E-mail'])
        sigla(blank: true, nullable: true, attributes: [title: 'Sigla'])
        numeroViviendas(blank: false, nullable: false, attributes: [title: 'Número de viviendas'])
    }

    String toString() {
        return this.nombre
    }
}
