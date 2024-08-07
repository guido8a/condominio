package utilitarios

import com.lowagie.text.Document
import com.lowagie.text.Element
import com.lowagie.text.Font
import com.lowagie.text.HeaderFooter
import com.lowagie.text.PageSize
import com.lowagie.text.Paragraph
import com.lowagie.text.Phrase
import com.lowagie.text.Rectangle
import com.lowagie.text.pdf.PdfContentByte
import com.lowagie.text.pdf.PdfImportedPage
import com.lowagie.text.pdf.PdfPCell
import com.lowagie.text.pdf.PdfPTable
import com.lowagie.text.pdf.PdfReader
import com.lowagie.text.pdf.PdfWriter
import condominio.CajaChica
import condominio.Condominio
import seguridad.Persona

import java.awt.Color

class Reportes2Controller {

    def reportesService
    def dbConnectionService

    private static void addCellTabla(PdfPTable table, paragraph, params) {
        PdfPCell cell = new PdfPCell(paragraph);
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

    private static int[] arregloEnteros(array) {
        int[] ia = new int[array.size()]
        array.eachWithIndex { it, i ->
            ia[i] = it.toInteger()
        }
        return ia
    }

    def encabezado (titulo, subtitulo, fontTitulo, fontSub) {
        Paragraph preface = new Paragraph();
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(titulo, fontTitulo));
        preface.add(new Paragraph(subtitulo, fontSub));
        return preface
    }

    def numeracion(x, y) {
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        PdfPTable table = new PdfPTable(2);
        table.setTotalWidth(327);
        table.setLockedWidth(true);
        table.getDefaultCell().setFixedHeight(20);
        table.getDefaultCell().setBorder(Rectangle.NO_BORDER);
        table.addCell("");
        table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(new Paragraph(String.format("Página %d de %d", x, y), fontTd10) );
        return table;
    }

    def tx_footer = "Sistema de Administración de Condominios " + " " * 136 + "www.tedein.com.ec/condominio"

    def encabezadoYnumeracion (f, tituloReporte, subtitulo, nombreReporte) {

        def titulo = new Color(30, 140, 160)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font fontTitulo8 = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL, titulo);

        def baos = new ByteArrayOutputStream()

        Document document
        document = new Document(PageSize.A4);

        def pdfw = PdfWriter.getInstance(document, baos);

        HeaderFooter footer1 = new HeaderFooter( new Phrase(tx_footer, new Font(fontTitulo8)), false);
        footer1.setBorder(Rectangle.NO_BORDER);
        footer1.setBorder(Rectangle.TOP);
        footer1.setAlignment(Element.ALIGN_CENTER);
        document.setFooter(footer1);

        document.open();

        PdfContentByte cb = pdfw.getDirectContent();

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

    def imprimirCajaChica(){

//        println("params " + params)

        def condominio = Condominio.get(session.condominio.id)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        def totalIngresos = 0
        def totalEgresos = 0

        def baos = new ByteArrayOutputStream()
        def name = "cajaChica_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 100, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Detalle Caja Chica del ${fechaDesde} al ${fechaHasta}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [bwl: 0.1, border: Color.BLACK, bwb: 0.1, bwt: 0.1, bcb: Color.BLACK, bct: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(4);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([20,56,12,12]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Concepto", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Ingresos", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Egresos", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])
        }

        tablaDetalles = new PdfPTable(4);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([20,56,12,12]))
        tablaDetalles.setSpacingAfter(1f);


        def frmtDato = [bwl: 0.1, border: Color.BLACK, bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK,  align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwl: 0.1, border: Color.BLACK, bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

//        def cajas = CajaChica.findAllByFechaBetween(new Date().parse("dd-MM-yyyy", params.desde), new Date().parse("dd-MM-yyyy", params.hasta))

        def cn = dbConnectionService.getConnection()
        def sql = "select * from cajachica(${condominio?.id}, '${fechaDesde}', '${fechaHasta}');"
        def res = cn.rows(sql.toString())

        res.each {caja ->
            if(caja.cjchfcha){
                addCellTabla(tablaDetalles, new Paragraph(caja.cjchfcha.toString(), fontTd10), frmtDato)
                addCellTabla(tablaDetalles, new Paragraph(caja.cjchdscr.toString(), fontTd10), frmtDato)
                addCellTabla(tablaDetalles, new Paragraph(caja.cjchingr.toString(), fontTd10), frmtNmro)
                addCellTabla(tablaDetalles, new Paragraph("", fontTd10), frmtDato)
                totalIngresos += caja.cjchingr
            }else{
                addCellTabla(tablaDetalles, new Paragraph(caja.pgegfcha.toString(), fontTd10), frmtDato)
                addCellTabla(tablaDetalles, new Paragraph(caja.pgegdscr.toString(), fontTd10), frmtDato)
                addCellTabla(tablaDetalles, new Paragraph("", fontTd10), frmtDato)
                addCellTabla(tablaDetalles, new Paragraph(caja.cjchegrs.toString(), fontTd10), frmtNmro)
                totalEgresos += caja.cjchegrs
            }
        }

        def tablaTotal = new PdfPTable(3);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([76, 12, 12]))

        addCellTabla(tablaTotal, new Paragraph("Total: ", fontTh), [border: Color.BLACK, bwb: 0.1, bwt: 0.1, bcb: Color.BLACK, bct: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), [bwl: 0.1, border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), [bwl: 0.1, border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])

        def tablaSaldo = new PdfPTable(2);
        tablaSaldo.setWidthPercentage(100);
        tablaSaldo.setWidths(arregloEnteros([88, 12]))

        addCellTabla(tablaSaldo, new Paragraph("Saldo: ", fontTh), [border: Color.BLACK, bwb: 0.1, bwt: 0.1, bcb: Color.BLACK,  bct: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaSaldo, new Paragraph(g.formatNumber(number:totalIngresos - totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), [bwl: 0.1, border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetalles, tablaSaldo, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();

        encabezadoYnumeracion(b, session.condominio.nombre,"Detalle de Caja Chica del ${fechaDesde} al ${fechaHasta}", "cajaChica_${new Date().format("dd-MM-yyyy")}.pdf")

    }


    def desde_ajax (){

    }

    private static void addEmptyLine(Paragraph paragraph, int number) {
        for (int i = 0; i < number; i++) {
            paragraph.add(new Paragraph(" "));
        }
    }

    def reporteValoresPagados (){
//        println("params vp  " + params)
        def cn = dbConnectionService.getConnection()
        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def persona = Persona.get(params.id)

        def sql = "select * from dtpago_actual(${persona?.id}, '${fechaDesde}') order by 2,1,5;"
        def detalle = cn.rows(sql.toString())
//        println("--> " + sql)

        def baos = new ByteArrayOutputStream()
        def titulo = new Color(40, 140, 180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo14 = new Font(Font.TIMES_ROMAN, 14, Font.BOLD, titulo);
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);
        def fondo = new Color(240, 248, 250);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def totalValor = 0
        def totalPago = 0
        def totalMlta = 0
        def totalDsct = 0
        def totalSaldo = 0

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 60, 50)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Detalle de Valores Pagados desde ${fechaDesde.format("dd-MM-yyyyy")}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, saldos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph("", fontTitle));
        preface.add(new Paragraph("Detalle de Valores Pagados de ${persona.nombre} ${persona.apellido} (" +
                "${persona.departamento} - ${persona.edificio.descripcion})", fontTitulo14));
        preface.add(new Paragraph("Período desde ${fechaDesde}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null

        def tablaHeaderDetalles = new PdfPTable(9);
        tablaHeaderDetalles.setWidthPercentage(100);
        tablaHeaderDetalles.setWidths(arregloEnteros([12,33,10,12,10,12,10,10,10]))

        tablaDetalles = new PdfPTable(9);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([12,33,10,12,10,12,10,10,10]))
        def frmtDato = [bwb: 0.1, bcb: Color.LIGHT_GRAY, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwb: 0.1, bcb: Color.LIGHT_GRAY, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmtDoc = [bwb: 0.1, bcb: Color.LIGHT_GRAY, border: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtcol3 = [bwb: 0.1, bcb: Color.LIGHT_GRAY, border: Color.LIGHT_GRAY, colspan:3]
        def frmtTotl2 = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.LIGHT_GRAY, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE, colspan: 2]
        def frmtTotl = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.LIGHT_GRAY, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha", fontTh), frmtHd)
        addCellTabla(tablaHeaderDetalles, new Paragraph("Concepto", fontTh), frmtHd)
        addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
        addCellTabla(tablaHeaderDetalles, new Paragraph("Pago F.", fontTh), frmtHd)
        addCellTabla(tablaHeaderDetalles, new Paragraph("Pago", fontTh), frmtHd)
        addCellTabla(tablaHeaderDetalles, new Paragraph("Docum.", fontTh), frmtHd)
        addCellTabla(tablaHeaderDetalles, new Paragraph("Multas", fontTh), frmtHd)
        addCellTabla(tablaHeaderDetalles, new Paragraph("Desc.", fontTh), frmtHd)
        addCellTabla(tablaHeaderDetalles, new Paragraph("Saldo", fontTh), frmtHd)
        addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 9, pl: 0])

        detalle.each { d->
            addCellTabla(tablaDetalles, new Paragraph(d.ingrfcha?.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(d.ingrdscr?.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(d.ingrvlor?.toString(), fontTd10), frmtNmro)
            addCellTabla(tablaDetalles, new Paragraph(d.pagofcha?.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(d.pagovlor?.toString(), fontTd10), frmtNmro)
            addCellTabla(tablaDetalles, new Paragraph(d.pagodcmt?.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(d.ingrmlta?.toString(), fontTd10), frmtNmro)
            addCellTabla(tablaDetalles, new Paragraph(d.ingrdsct?.toString(), fontTd10), frmtNmro)
            addCellTabla(tablaDetalles, new Paragraph(d.ingrsldo?.toString(), fontTd10), frmtNmro)

            totalValor += d.ingrvlor ?: 0
            totalPago += d.pagovlor ?: 0
            totalMlta += d.ingrmlta ?: 0
            totalDsct += d.ingrdsct ?: 0
            totalSaldo += d.ingrsldo ?: 0

        }

        def tablaTotal = new PdfPTable(9);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([12,33,10,12,10,12,10,10,10]))
        addCellTabla(tablaTotal, new Paragraph("Totales: ", fontTh), frmtTotl2)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalValor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtTotl)
        addCellTabla(tablaTotal, new Paragraph('', fontTd10), frmtTotl)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalPago, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtTotl)
        addCellTabla(tablaTotal, new Paragraph('', fontTd10), frmtTotl)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalMlta, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtTotl)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalDsct, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtTotl)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalSaldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtTotl)
        addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 9, pl: 0])

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        encabezadoYnumeracion(b, session.condominio.nombre,"", "valoresPagados_${persona.nombre}.pdf")
    }
}
