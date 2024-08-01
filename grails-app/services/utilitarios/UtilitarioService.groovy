package utilitarios

import java.text.NumberFormat

class UtilitarioService {

    def dbConnectionService

    def getLastDayOfMonth(fecha) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(fecha);

        calendar.add(Calendar.MONTH, 1);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.add(Calendar.DATE, -1);

        Date lastDayOfMonth = calendar.getTime();
        return lastDayOfMonth
    }

    def numero(nmro) {
        NumberFormat nf = NumberFormat.getInstance(Locale.US);
        nf.setGroupingUsed(false)
        nf.setMinimumFractionDigits(2)
        nf.format(nmro)
    }

    def numero4(nmro) {
        NumberFormat nf = NumberFormat.getInstance(Locale.US);
        nf.setGroupingUsed(false)
        nf.setMinimumFractionDigits(4)
        nf.format(nmro)
    }

    def valorIva(fcha) {
        def cn = dbConnectionService.getConnection()
        def sql = "select paux_iva from paux where '${fcha}' between pauxfcin and " +
                "coalesce(pauxfcfn, now())"
        println "sqlIva: $sql"
        return cn.rows(sql.toString())[0]?.paux_iva
    }



}
