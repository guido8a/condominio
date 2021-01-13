package condominio

import com.itextpdf.text.DocumentException
import com.itextpdf.text.Element
import com.itextpdf.text.Image
import com.itextpdf.text.Phrase
import com.itextpdf.text.pdf.PdfContentByte
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.pdf.PdfPTable
import com.itextpdf.text.pdf.PdfWriter
import com.itextpdf.text.Rectangle
import com.itextpdf.text.Document
import com.itextpdf.text.PageSize
import com.itextpdf.text.Font
import com.itextpdf.text.Paragraph

import adicional.Redondea
import java.awt.Color


class Reportes3Controller {

    /* variables para el reporte */
    def titulo = new Color(40, 140, 180)
    Font nota = new Font(Font.FontFamily.TIMES_ROMAN, 9, Font.ITALIC)
    Font nota7 = new Font(Font.FontFamily.TIMES_ROMAN, 6, Font.ITALIC)
    Font fontTh = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
    Font fontThn = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
    Font fontTh8 = new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD);
    Font fontTh8N = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL);
    Font fontTd = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);
    Font fontTd10 = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
    Font fontTdRojo = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
    Font fontTd16 = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);


    private static int[] arregloEnteros(array) {
        int[] ia = new int[array.size()]
        array.eachWithIndex { it, i ->
            ia[i] = it.toInteger()
        }
        return ia
    }

    /* caja redondeada */
    def poneCelda(txto, align, font, colspan) {
        Redondea borde = new Redondea();
        PdfPCell celda;
//        celda = new PdfPCell(new Paragraph(txto, font))
        celda = new PdfPCell(new Phrase(txto, font))
        celda.setHorizontalAlignment(align);
        celda.setBorder(Rectangle.NO_BORDER);
        celda.setPadding(4);
        celda.setCellEvent(borde);
        celda.setColspan(colspan)
        celda
    }

    def poneCeldaNoBorde(txto, align, font, colspan) {
        PdfPCell celda;
//        celda = new PdfPCell(new Paragraph(txto, font))
        celda = new PdfPCell(new Phrase(txto, font))
        celda.setHorizontalAlignment(align);
        celda.setBorder(Rectangle.NO_BORDER);
        celda.setPadding(4);
        celda.setColspan(colspan)
        celda
    }

    def poneCeldaImag(imag) {
        PdfPCell celda = new PdfPCell(imag)
        celda.setHorizontalAlignment(Element.ALIGN_CENTER)
        celda.setBorder(Rectangle.NO_BORDER)
        celda
    }

    def reporteRolPagos(){
        def baos = new ByteArrayOutputStream()
        def condominio = Condominio.get(params.condominio)
        def rol = RolPagos.get(params.id)

        Document document
        document = new Document(PageSize.A4)
        document.setMargins(74, 60, 74, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos)

        document.open();

        document.addTitle("RolPagos");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        //1
        document.add(tituloRol(condominio,rol))
        document.add(new Phrase(" "))

        document.add(tablasRolMes(rol))
        document.add(new Phrase(" "))
        document.add(firmasRol())

        //2
        document.add(new Phrase(" "))
        document.add(tituloRol(condominio,rol))
        document.add(new Phrase(" "))

        document.add(tablasRolMes(rol))
        document.add(new Phrase(" "))
        document.add(firmasRol())

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=rolPagos_${rol?.salario?.descripcion}_${new Date().format("dd-MM-yyyy")}")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }


    def comprobante() {
        def baos = new ByteArrayOutputStream()
        def condominio = Condominio.get(session.condominio.id)
        def comprobante = Comprobante.get(params.comp)

        Document document
//        document = new Document(PageSize.A5.rotate())
        document = new Document(PageSize.A4)
        document.setMargins(74, 60, 74, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos)

        document.open();

//        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Solicitud");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");


        /* ---------- inicio del documento ------------- */
        document.add(tituloCmpr(comprobante, condominio))
        document.add(new Phrase(" "))

        document.add(tablaDatos(comprobante))

        def tblaValores = tablaValores(comprobante)
        tblaValores.setSpacingBefore(10.0)
        document.add(tblaValores)
        tblaValores.setSpacingAfter(10.0)

        if(comprobante.estado == 'A'){
//        if(comprobante.estado != 'A'){
            document.add(new Phrase(" "))
            document.add(anulado())
        }

        document.add(tablaFirma(comprobante))
        document.add(tablaNota())

        /* ---------- segunda copia ---------- */
        document.add(new Phrase("\n\n\n\n"))  // espacio intermedio

        document.add(tituloCmpr(comprobante, condominio))
        document.add(new Phrase(" "))

        document.add(tablaDatos(comprobante))

        def tblaValores2 = tablaValores(comprobante)
        tblaValores.setSpacingBefore(10.0)
        document.add(tblaValores)
        tblaValores.setSpacingAfter(10.0)

        if(comprobante.estado == 'A'){
//        if(comprobante.estado != 'A'){
            document.add(new Phrase(" "))
            document.add(anulado())
        }

        document.add(tablaFirma(comprobante))
        document.add(tablaNota())

        /* fin */

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=comprobantePago_${comprobante?.pago?.ingreso?.persona?.nombre + " " + comprobante?.pago?.ingreso?.persona?.apellido}_${new Date().format("dd-MM-yyyy")}")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def tituloRol(condominio,RolPagos rol){
        def tablaTitl = new PdfPTable(2);
        tablaTitl.setWidthPercentage(100);
        tablaTitl.setWidths(arregloEnteros([45,55]))

        tablaTitl.addCell(poneCeldaNoBorde(condominio?.nombre, Element.ALIGN_CENTER, fontTd16, 2))
        tablaTitl.addCell(poneCeldaNoBorde("ROL DE PAGOS", Element.ALIGN_CENTER, fontTh, 2))
        tablaTitl.addCell(poneCeldaNoBorde("PERÍODO:", Element.ALIGN_RIGHT, fontTh8, 1))
        tablaTitl.addCell(poneCeldaNoBorde(rol?.salario?.descripcion + " " + rol?.fechaDesde?.format("yyyy"), Element.ALIGN_LEFT, fontTh8, 1))
        tablaTitl.addCell(poneCeldaNoBorde("NOMBRE:", Element.ALIGN_RIGHT, fontTh8, 1))
        tablaTitl.addCell(poneCeldaNoBorde(rol?.sueldo?.empleado?.nombre + " " + rol?.sueldo?.empleado?.apellido, Element.ALIGN_LEFT, fontTh8, 1))
        tablaTitl.addCell(poneCeldaNoBorde("C.C.:", Element.ALIGN_RIGHT, fontTh8, 1))
        tablaTitl.addCell(poneCeldaNoBorde(rol?.sueldo?.empleado?.cedula ?: '', Element.ALIGN_LEFT, fontTh8, 1))
        tablaTitl.addCell(poneCeldaNoBorde("CARGO:", Element.ALIGN_RIGHT, fontTh8, 1))
        tablaTitl.addCell(poneCeldaNoBorde(rol?.sueldo?.empleado?.cargo, Element.ALIGN_LEFT, fontTh8, 1))

        tablaTitl
    }

    def tablasRolMes(RolPagos rol){
        def tablaDatos = new PdfPTable(5);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([30,17,6,30,17]))

        tablaDatos.addCell(poneCelda("INGRESOS", Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda("VALOR",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTd,1))
        tablaDatos.addCell(poneCelda("DESCUENTOS",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda("VALOR",Element.ALIGN_CENTER, fontTd10,1))

        tablaDatos.addCell(poneCelda("SUELDO BÁSICO", Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(rol?.sueldo?.valor?.toString(),Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda("APORTES IESS",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(rol?.iess?.toString(),Element.ALIGN_CENTER, fontTh8N,1))

        tablaDatos.addCell(poneCelda("FONDOS DE RESERVA", Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(rol?.fondoReserva?.toString(),Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(rol?.descuentoDescripcion?.toUpperCase(),Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(rol?.descuentoValor?.toString(),Element.ALIGN_CENTER, fontTh8N,1))

        def totalIngresos = (rol?.sueldo?.valor ?: 0) + (rol?.fondoReserva ?: 0)
        def totalDescuentos = (rol?.iess ?: 0 ) + (rol?.descuentoValor ?: 0)

        tablaDatos.addCell(poneCelda("TOTAL INGRESOS", Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTd,1))
        tablaDatos.addCell(poneCelda("TOTAL DESCUENTOS",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number: totalDescuentos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))

        tablaDatos.addCell(poneCelda("NETO A RECIBIR", Element.ALIGN_CENTER, fontTd10,4))
        tablaDatos.addCell(poneCelda(g.formatNumber(number: (totalIngresos - totalDescuentos), format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))

        tablaDatos
    }

    def firmasRol(){
        def tablaTitl = new PdfPTable(3);
        tablaTitl.setWidthPercentage(100);
        tablaTitl.setWidths(arregloEnteros([40,10,40]))

        tablaTitl.addCell(poneCeldaNoBorde("_"*20, Element.ALIGN_CENTER, fontThn, 1))
        tablaTitl.addCell(poneCeldaNoBorde("", Element.ALIGN_CENTER, fontThn, 1))
        tablaTitl.addCell(poneCeldaNoBorde("_"*20, Element.ALIGN_CENTER, fontThn, 1))

        tablaTitl.addCell(poneCeldaNoBorde("EMPLEADO", Element.ALIGN_CENTER, fontTh, 1))
        tablaTitl.addCell(poneCeldaNoBorde("", Element.ALIGN_CENTER, fontTh, 1))
        tablaTitl.addCell(poneCeldaNoBorde("ADMINISTRADOR", Element.ALIGN_CENTER, fontTh, 1))

        tablaTitl.addCell(poneCeldaNoBorde("FECHA: " + new Date().format("dd-MM-yyyy"), Element.ALIGN_LEFT, fontTh8N, 3))

        tablaTitl
    }

    def tituloCmpr(comprobante, condominio){
        def tablaTitl = new PdfPTable(2);
        tablaTitl.setWidthPercentage(100);
        tablaTitl.setWidths(arregloEnteros([64,36]))

        tablaTitl.addCell(poneCeldaNoBorde("CONJUNTO RESIDENCIAL 'LOS VIÑEDOS'", Element.ALIGN_CENTER, fontTh, 1))
        tablaTitl.addCell(poneCelda("COMPROBANTE DE PAGO\n${comprobante?.numero}", Element.ALIGN_CENTER, fontTh,1));
        def tx_titl = "Dirección: ${condominio?.direccion} \n Teléfono: ${condominio?.telefono?.toString()}\nQuito - Ecuador"

        tablaTitl.addCell(poneCeldaNoBorde(tx_titl, Element.ALIGN_CENTER, fontTd,1))
        tablaTitl.addCell(poneCelda("R.U.C. ${condominio?.ruc}\n\nFecha: ${comprobante.pago.fechaPago.format('dd-MMM-yyyy')}",
                Element.ALIGN_CENTER, fontTd,1))

        tablaTitl
    }

    def tablaDatos(comprobante) {
        def tablaDatos = new PdfPTable(4);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([17,50,13, 20]))

        tablaDatos.addCell(poneCelda("Recibí de : ", Element.ALIGN_RIGHT, fontTd,1))
        tablaDatos.addCell(poneCelda("${comprobante?.pago?.ingreso?.persona?.nombre} ${comprobante?.pago?.ingreso?.persona?.apellido}",
                Element.ALIGN_LEFT, fontTd10,1))
        tablaDatos.addCell(poneCelda("RUC/CI : ", Element.ALIGN_RIGHT, fontTd,1))
        tablaDatos.addCell(poneCelda(comprobante?.pago?.ingreso?.persona?.ruc?.toString() ?: '', Element.ALIGN_LEFT, fontTd,1))

        tablaDatos.addCell(poneCelda("Departamento : ", Element.ALIGN_RIGHT, fontTd,1))
        tablaDatos.addCell(poneCelda(comprobante?.pago?.ingreso?.persona?.departamento?.toString() ?: '',
                Element.ALIGN_LEFT, fontTd,1))
        tablaDatos.addCell(poneCelda("Teléfono : ", Element.ALIGN_RIGHT, fontTd,1))
        tablaDatos.addCell(poneCelda(comprobante?.pago?.ingreso?.persona?.telefono?.toString() ?: '',
                Element.ALIGN_LEFT, fontTd,1))
        tablaDatos
    }

    def tablaValores(comprobante) {
        def tablaValores = new PdfPTable(3);
        tablaValores.setWidthPercentage(100);
        tablaValores.setWidths(arregloEnteros([20,60,20]))

        def txto = (comprobante?.pago?.observaciones ?: '') + " (${comprobante.pago.ingreso.obligacion.tipoAporte.descripcion})"
//        println "txto: $txto"
        tablaValores.addCell(poneCelda("Por concepto de : ", Element.ALIGN_RIGHT, fontTd,1))
        tablaValores.addCell(poneCelda(txto, Element.ALIGN_LEFT, fontTd,1))
        txto = g.formatNumber(number:comprobante?.pago?.valor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString()
        tablaValores.addCell(poneCelda(txto, Element.ALIGN_CENTER, fontTd,1))

        tablaValores.addCell(poneCelda("Total \$ ", Element.ALIGN_RIGHT, fontTd10, 2))
        txto = g.formatNumber(number:comprobante?.pago?.valor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString()
        tablaValores.addCell(poneCelda(txto, Element.ALIGN_CENTER, fontTd10,1))

        tablaValores
    }

    def anulado() {
        Paragraph h = new Paragraph();
        h.setAlignment(Element.ALIGN_CENTER);
        h.add(new Phrase("ANULADO", fontTdRojo))
        h
    }

    def tablaFirma(comprobante) {
        def firma_img = Image.getInstance('/var/condominio/firmas/' + comprobante.ruta)
        def tbFirma = new PdfPTable(2);
        def txto = "Ing. Guido Ochoa Moreno\nADMINISTRADOR\nCel: 098 491 6620, dpto. 214"

        tbFirma.setWidthPercentage(60);
        tbFirma.setWidths(arregloEnteros([70,30]))
        tbFirma.addCell(poneCeldaNoBorde(txto, Element.ALIGN_CENTER, fontTd,1))
        firma_img.scaleToFit(60, 60)
        firma_img.setAlignment(Image.RIGHT | Image.TEXTWRAP)

        tbFirma.addCell(poneCeldaImag(firma_img))
        tbFirma.setSpacingBefore(15.0)

        tbFirma
    }

    def tablaNota() {
        def tbNota = new PdfPTable(2);
        tbNota.setWidthPercentage(100);
        tbNota.setWidths(arregloEnteros([8,92]))
        tbNota.addCell(poneCeldaNoBorde("Nota:", Element.ALIGN_LEFT, fontTd10,1))
        tbNota.addCell(poneCeldaNoBorde("Sr. Copropietario y/o arrendatario pague su cuota condominal los 5 " +
                "primeros días de cada mes, caso contrario se cobrará el 8% de intereses por mora, aprobado en la " +
                "Asamblea de Copropietarios.", Element.ALIGN_JUSTIFIED, nota,1))
        tbNota.addCell(poneCeldaNoBorde(" ", Element.ALIGN_JUSTIFIED, nota7,1))
        tbNota.addCell(poneCeldaNoBorde(" ", Element.ALIGN_JUSTIFIED, nota7,1))
        tbNota.addCell(poneCeldaNoBorde(" ", Element.ALIGN_JUSTIFIED, nota7,1))
        tbNota.addCell(poneCeldaNoBorde("Sistema de Administración de Condominios.         www.tedein.com.ec/vinedos",
                Element.ALIGN_RIGHT, nota7,1))

        tbNota
    }

}
