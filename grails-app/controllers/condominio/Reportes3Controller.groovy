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
        document.setMargins(74, 60, 60, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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

        switch (params.tipo){
            case '1':
                document.add(tablasRolMes(rol))
                break;
            case '2':
                document.add(tablasRolDecimos(rol,1))
                break;
            case '3':
                document.add(tablasRolDecimos(rol,2))
                break;
            case '4':
                document.add(tablasRolVacaciones(rol))
                break;
        }


        document.add(new Phrase(" "))
        document.add(firmasRol())

        //2
        document.add(new Phrase("\n\n\n\n"))
        document.add(tituloRol(condominio,rol))
        document.add(new Phrase(" "))

        switch (params.tipo){
            case '1':
                document.add(tablasRolMes(rol))
                break;
            case '2':
                document.add(tablasRolDecimos(rol,1))
                break;
            case '3':
                document.add(tablasRolDecimos(rol,2))
                break;
            case '4':
                document.add(tablasRolVacaciones(rol))
                break;
        }


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
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.sueldoRol, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda("APORTES IESS",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.iess, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))

        tablaDatos.addCell(poneCelda("FONDOS DE RESERVA", Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.fondoReserva, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(rol?.descuentoDescripcion?.toUpperCase(),Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.descuentoValor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))

        tablaDatos.addCell(poneCelda("BONO " + (rol?.bono ?: ''), Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.bonoValor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))

        def totalIngresos = (rol?.sueldo?.valor ?: 0) + (rol?.fondoReserva ?: 0) + (rol?.bonoValor ?: 0)
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

    def tablasRolDecimos(RolPagos rol,tipo){
        def tablaDatos = new PdfPTable(5);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([30,17,6,30,17]))

        tablaDatos.addCell(poneCelda("INGRESOS", Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda("VALOR",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTd,1))
        tablaDatos.addCell(poneCelda("DESCUENTOS",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda("VALOR",Element.ALIGN_CENTER, fontTd10,1))

        if(tipo == 1){
            tablaDatos.addCell(poneCelda("SUELDO " + rol?.fechaDesde?.format("yyyy"), Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.sueldoRol, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))

            def anterior = (rol?.sueldoAnterior / 12)

            tablaDatos.addCell(poneCelda("SUELDO " + (rol?.fechaDesde?.format("yyyy")?.toInteger() - 1), Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda(g.formatNumber(number:anterior, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))
        }else{
            tablaDatos.addCell(poneCelda("DÉCIMO CUARTO SUELDO", Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.sueldoRol, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))
            tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))
        }


        tablaDatos.addCell(poneCelda("TOTAL INGRESOS", Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTd,1))
        tablaDatos.addCell(poneCelda("TOTAL DESCUENTOS",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number: rol?.totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))

        tablaDatos.addCell(poneCelda("NETO A RECIBIR", Element.ALIGN_CENTER, fontTd10,4))
        tablaDatos.addCell(poneCelda(g.formatNumber(number: rol?.valor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))

        tablaDatos
    }

    def tablasRolVacaciones(RolPagos rol){
        def tablaDatos = new PdfPTable(5);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([30,17,6,30,17]))

        tablaDatos.addCell(poneCelda("INGRESOS", Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda("VALOR",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTd,1))
        tablaDatos.addCell(poneCelda("DESCUENTOS",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda("VALOR",Element.ALIGN_CENTER, fontTd10,1))

        tablaDatos.addCell(poneCelda("SUELDO " + rol?.fechaDesde?.format("yyyy") + " ( " + g.formatNumber(number:rol?.sueldoRol, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US') + " )", Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda("",Element.ALIGN_CENTER, fontTh8N,1))

        tablaDatos.addCell(poneCelda("VACACIONES", Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(rol?.descuentoDescripcion,Element.ALIGN_CENTER, fontTh8N,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTh8N,1))

        tablaDatos.addCell(poneCelda("TOTAL INGRESOS", Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number:rol?.totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCeldaNoBorde("",Element.ALIGN_CENTER, fontTd,1))
        tablaDatos.addCell(poneCelda("TOTAL DESCUENTOS",Element.ALIGN_CENTER, fontTd10,1))
        tablaDatos.addCell(poneCelda(g.formatNumber(number: rol?.totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))

        tablaDatos.addCell(poneCelda("NETO A RECIBIR", Element.ALIGN_CENTER, fontTd10,4))
        tablaDatos.addCell(poneCelda(g.formatNumber(number: rol?.valor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(),Element.ALIGN_CENTER, fontTd10,1))

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



}
