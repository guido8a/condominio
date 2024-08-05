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
import com.lowagie.text.HeaderFooter
import com.lowagie.text.pdf.PdfImportedPage
import com.lowagie.text.pdf.PdfReader
import contabilidad.Contabilidad
import contabilidad.Cuenta
import seguridad.Persona

import java.awt.Color


class Reportes3Controller {

    def cuentasService
    def reportesService

    def tx_footer = "Sistema de Administración de Condominios " + " " * 136 + "www.tedein.com.ec/condominio"

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

    private static void addCellTabla(com.lowagie.text.pdf.PdfPTable table, paragraph, params) {
        com.lowagie.text.pdf.PdfPCell cell = new com.lowagie.text.pdf.PdfPCell(paragraph);
        if (params.height) {
            cell.setFixedHeight(params.height.toFloat());
        }
        if (params.border) {
            cell.setBorderColor(params.border);
        }
        if (params.bg) {
            cell.setBackgroundColor(params.bg);
        }
        if (params.colspan) {
            cell.setColspan(params.colspan);
        }
        if (params.align) {
            cell.setHorizontalAlignment(params.align);
        }
        if (params.valign) {
            cell.setVerticalAlignment(params.valign);
        }
        if (params.w) {
            cell.setBorderWidth(params.w);
            cell.setUseBorderPadding(true);
        }
        if (params.bwl) {
            cell.setBorderWidthLeft(params.bwl.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwb) {
            cell.setBorderWidthBottom(params.bwb.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwr) {
            cell.setBorderWidthRight(params.bwr.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwt) {
            cell.setBorderWidthTop(params.bwt.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bcl) {
            cell.setBorderColorLeft(params.bcl);
        }
        if (params.bcb) {
            cell.setBorderColorBottom(params.bcb);
        }
        if (params.bcr) {
            cell.setBorderColorRight(params.bcr);
        }
        if (params.bct) {
            cell.setBorderColorTop(params.bct);
        }
        if (params.padding) {
            cell.setPadding(params.padding.toFloat());
        }
        if (params.pl) {
            cell.setPaddingLeft(params.pl.toFloat());
        }
        if (params.pr) {
            cell.setPaddingRight(params.pr.toFloat());
        }
        if (params.pt) {
            cell.setPaddingTop(params.pt.toFloat());
        }
        if (params.pb) {
            cell.setPaddingBottom(params.pb.toFloat());
        }
        table.addCell(cell);
    }

    def encabezadoYnumeracion (f, tituloReporte, subtitulo, nombreReporte) {

        def titulo = new Color(30, 140, 160)
        com.lowagie.text.Font fontTitulo = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 12, com.lowagie.text.Font.BOLD, titulo);
        com.lowagie.text.Font fontTitulo16 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 16, com.lowagie.text.Font.BOLD, titulo);
        com.lowagie.text.Font fontTitulo8 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 8, com.lowagie.text.Font.NORMAL, titulo);

        def baos = new ByteArrayOutputStream()

        com.lowagie.text.Document document
        document = new com.lowagie.text.Document(com.lowagie.text.PageSize.A4);

        def pdfw = com.lowagie.text.pdf.PdfWriter.getInstance(document, baos);

        HeaderFooter footer1 = new HeaderFooter( new com.lowagie.text.Phrase(tx_footer, new com.lowagie.text.Font(fontTitulo8)), false);
        footer1.setBorder(com.lowagie.text.Rectangle.NO_BORDER);
        footer1.setBorder(com.lowagie.text.Rectangle.TOP);
        footer1.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        document.setFooter(footer1);

        document.open();

        com.lowagie.text.pdf.PdfContentByte cb = pdfw.getDirectContent();

        PdfReader reader = new PdfReader(f);
        for (int i = 1; i <= reader.getNumberOfPages(); i++) {
            document.newPage();
            PdfImportedPage page = pdfw.getImportedPage(reader, i);
            cb.addTemplate(page, 0, 0);
            def en = reportesService.encabezado(tituloReporte, subtitulo, fontTitulo16, fontTitulo)
            reportesService.numeracion(i,reader.getNumberOfPages()).writeSelectedRows(0, -1, -1, 25, cb)
            document.add(en)
        }

        document.close();
        byte[] b = baos.toByteArray();

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + nombreReporte)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
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

    def planDeCuentas(){
        println "planDeCuentas: $params --> ${session?.usuario}"
        def usro = Persona.get(session?.usuario?.id)
        def condominio = Condominio.get(session.condominio.id)
        [cuentas: cuentasService.getCuentas(params.cont, condominio.id), empresa: condominio.id]
    }

    def reportePlanCuentas(){
        def condominio = Condominio.get(session.condominio.id)
        def contabilidad = Contabilidad.get(params.cont)
        def cuentas = Cuenta.findAllByCondominio(condominio, [sort: "numero"])

        def baos = new ByteArrayOutputStream()
        def name = "planDeCuentas_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        com.lowagie.text.Font fontTitulo = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 12, com.lowagie.text.Font.BOLD, titulo);
        com.lowagie.text.Font fontTitulo16 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 16, com.lowagie.text.Font.BOLD, titulo);
        com.lowagie.text.Font info = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.NORMAL)
        com.lowagie.text.Font fontTitle = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 14, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTitle1 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTh = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTd10 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.NORMAL);

//        def fondoTotal = new Color(240, 240, 240);

        com.lowagie.text.Document document
        document = new com.lowagie.text.Document(com.lowagie.text.PageSize.A4);
        document.setMargins(50, 30, 100, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = com.lowagie.text.pdf.PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        com.lowagie.text.pdf.PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Plan de cuentas de la contabilidad del ${contabilidad?.fechaInicio?.format("dd-MM-yyyy")} al ${contabilidad?.fechaCierre?.format("dd-MM-yyyy")}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

//        Paragraph preface = new Paragraph();
//        addEmptyLine(preface, 1);
//        preface.setAlignment(Element.ALIGN_CENTER);
//        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
//        preface.add(new Paragraph("Detalle de Egresos por Proveedor del ${fechaDesde} al ${fechaHasta}", fontTitulo));
//        addEmptyLine(preface, 1);
//        document.add(preface);

        com.lowagie.text.pdf.PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: com.lowagie.text.Element.ALIGN_CENTER, valign: com.lowagie.text.Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new com.lowagie.text.pdf.PdfPTable(4);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([20,20,20,40]))

            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Número", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Padre", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Nivel", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Descripción", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 4, pl: 0])
        }

        tablaDetalles = new com.lowagie.text.pdf.PdfPTable(4);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([20,20,20,40]))
        tablaDetalles.setSpacingAfter(1f);


        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        cuentas.each {cuenta ->
                addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(cuenta?.numero, fontTd10), frmtNmro)
                addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(cuenta?.padre?.numero?.toString(), fontTd10), frmtNmro)
                addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(cuenta?.nivel?.descripcion?.toString(), fontTd10), frmtDato)
                addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(cuenta?.descripcion?.toString(), fontTd10), frmtDato)
        }

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();

        encabezadoYnumeracion(b, condominio?.nombre, "Plan de cuentas de la contabilidad del ${contabilidad?.fechaInicio?.format("dd-MM-yyyy")} al ${contabilidad?.fechaCierre?.format("dd-MM-yyyy")}",
                "planDeCuentas_${new Date().format("dd-MM-yyyy")}.pdf")
    }

}
