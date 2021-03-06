package condominio

class RolPagos {

    static auditable = true
    Salario salario
    Sueldo sueldo
    double sueldoRol
    double fondoReserva
    double iess
    double descuentoValor
    String descuentoDescripcion
    Date fechaDesde
    Date fechaHasta
    double sueldoAnterior
    String bono
    double bonoValor
    double totalIngresos
    double totalEgresos
    double valor


    static mapping = {
        table 'rlpg'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'rlpg__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'rlpg__id'
            salario column: 'slro__id'
            sueldo column: 'sldo__id'
            sueldoRol column: 'rlpgsldo'
            fondoReserva column: 'rlpgfnrs'
            iess column: 'rlpgiess'
            descuentoValor column: 'rlpgdsvl'
            descuentoDescripcion column: 'rlpgdsds'
            fechaDesde column: 'rlpgfcds'
            fechaHasta column: 'rlpgfchs'
            sueldoAnterior column: 'rlpgslan'
            bono column: 'rlpgbono'
            bonoValor column: 'rlpgbnvl'
            totalIngresos column: 'rlpgttin'
            totalEgresos column: 'rlpgtteg'
            valor column: 'rlpgvlor'
        }
    }
    static constraints = {
        salario(blank:false, nullable: false)
        sueldo(blank:false, nullable: false)
        sueldoRol(blank:false, nullable: false)
        fondoReserva(blank:true, nullable: true)
        iess(blank:true, nullable: true)
        descuentoValor(blank:true, nullable: true)
        descuentoDescripcion(blank:true, nullable: true)
        fechaDesde(blank:true, nullable: true)
        fechaHasta(blank:true, nullable: true)
        sueldoAnterior(blank:true, nullable: true)
        bono(blank:true, nullable: true)
        bonoValor(blank:true, nullable: true)
        totalIngresos(blank:true, nullable: true)
        totalEgresos(blank:true, nullable: true)
        valor(blank:true, nullable: true)

    }
}
