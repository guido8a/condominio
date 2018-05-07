package utilitarios

import com.lowagie.text.Chapter
import com.lowagie.text.ChapterAutoNumber
import com.lowagie.text.Chunk
import com.lowagie.text.Phrase
import com.lowagie.text.pdf.DefaultFontMapper
import com.lowagie.text.pdf.PdfTemplate
import condominio.Condominio
import condominio.Ingreso
import groovy.json.JsonBuilder
import org.apache.poi.hwpf.usermodel.OfficeDrawing
import org.jfree.chart.ChartUtilities
import org.jfree.chart.plot.PlotOrientation
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer
import org.jfree.chart.renderer.xy.XYSplineRenderer
import org.jfree.data.category.DefaultCategoryDataset
import org.jfree.data.xy.XYDataset
import org.jfree.data.xy.XYSeries
import org.jfree.data.xy.XYSeriesCollection
import seguridad.Persona

import com.lowagie.text.Document
import com.lowagie.text.Element
import com.lowagie.text.Font
import com.lowagie.text.Image
import com.lowagie.text.PageSize
import com.lowagie.text.Paragraph
import com.lowagie.text.pdf.PdfContentByte
import com.lowagie.text.pdf.PdfImportedPage
import com.lowagie.text.pdf.PdfPCell
import com.lowagie.text.pdf.PdfPTable
import com.lowagie.text.pdf.PdfReader
import com.lowagie.text.pdf.PdfWriter
import seguridad.Shield

import java.awt.Color

import org.jfree.chart.ChartFactory
import org.jfree.chart.JFreeChart
import org.jfree.chart.labels.StandardPieSectionLabelGenerator
import org.jfree.chart.plot.PiePlot
import org.jfree.data.general.DefaultPieDataset

import java.awt.Color
import java.awt.Graphics2D
import java.awt.Paint
import java.awt.geom.Rectangle2D
import java.awt.image.BufferedImage


class ReportesController extends Shield{

    def dbConnectionService

    def index() {

        def cn = dbConnectionService.getConnection()
        def sql = 'select distinct cast (extract(year from pagofcpg) as INT) from pago order by 1;'
        def res = cn.rows(sql.toString())

        return [anios: res.date_part]

    }


    def revisarFecha_ajax() {
//        println("params revisar fecha " + params)
        if (params.desde && params.hasta) {
            def desde = new Date().parse("dd-MM-yyyy", params.desde)
            def hasta = new Date().parse("dd-MM-yyyy", params.hasta)

            if (desde > hasta) {
                render "no"
            } else {
                render "ok"
            }
        } else {
            render "ok"
        }
    }

    def pagosPendientes_modal() {

    }

    def pagosPendientes() {
//        println("params pp " + params)
//        def desde = new Date().parse("dd-MM-yyyy", params.desde)
//        def hasta = new Date().parse("dd-MM-yyyy", params.hasta)


        def cn = dbConnectionService.getConnection()
        def sql = "select prsndpto depart, prsnnmbr||' '||prsnapll nombre,   coalesce(ingrobsr, '')||' ('||oblgdscr||')' detalle,   ingrvlor - ingrabno por_pagar from prsn, ingr, oblg where prsn.prsn__id = ingr.prsn__id and oblg.oblg__id = ingr.oblg__id and   ingrvlor > ingrabno Order by prsndpto, oblgdscr;"
//        println("sql: " + sql)

        def res = cn.rows(sql.toString())
        def ultimo = res.last().depart
        def cont = res.size();

        return [res: res, ultimo: ultimo, cont: cont.toInteger()]
    }

    def reportePendientes() {
        println("params pp " + params)

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from pendientes('${fecha}')"
        println("sql: " + sql)

        def res = cn.rows(sql.toString())
        def ultimo = res.last().depart
        def cont = res.size();

        return [res: res, ultimo: ultimo, cont: cont.toInteger()]
    }

    private String numero(num, decimales, cero) {
        if (num == 0 && cero.toString().toLowerCase() == "hide") {
            return " ";
        }
        if (decimales == 0) {
            return formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec")
        } else {
            def format
            if (decimales == 2) {
                format = "##,##0"
            } else if (decimales == 3) {
                format = "##,###0"
            }
            return formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec", format: format)
        }
    }

    private String numero(num, decimales) {
        return numero(num, decimales, "show")
    }

    private String numero(num) {
        return numero(num, 3)
    }

    private static void addEmptyLine(Paragraph paragraph, int number) {
        for (int i = 0; i < number; i++) {
            paragraph.add(new Paragraph(" "));
        }
    }

    private static int[] arregloEnteros(array) {
        int[] ia = new int[array.size()]
        array.eachWithIndex { it, i ->
            ia[i] = it.toInteger()
        }
        return ia
    }

    private static void addCellTabla2(PdfPTable table, paragraph, params) {
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

        cell.fixedHeight = 30f

        table.addCell(cell);
    }

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


    def pagosPendientes2() {

        def cn = dbConnectionService.getConnection()
        def fcha = new Date()

        //"select prsndpto depart, prsnnmbr||' '||prsnapll nombre,   coalesce(ingrobsr, '')||' ('||oblgdscr||')' detalle,
        //   ingrvlor - ingrabno por_pagar from prsn, ingr, oblg
        // where prsn.prsn__id = ingr.prsn__id and oblg.oblg__id = ingr.oblg__id and   ingrvlor > ingrabno Order by prsndpto, oblgdscr;"

        def sql = "select * from pendiente('${fcha.format('yyyy-MM-dd')} 23:59')"
        println "sql: $sql"
        def res = cn.rows(sql.toString())
        def tamano = res.size()
        def max = 54
        def actual = 0

//        println("tamaño " + tamano)

        def fondoTotal = new Color(250, 250, 240);
        def baos = new ByteArrayOutputStream()
        def name = "pagosPendientes_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 8, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);

        def prmsTdNoBorder = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        Document document
//        document = new Document(PageSize.A4.rotate());
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 30, 28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Pagos Pendientes");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph("CONJUNTO HABITACIONAL 'LOS VIÑEDOS'", fontTitulo));
        preface.add(new Paragraph("PAGOS PENDIENTES", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
//            document.newPage()
            def tablaHeaderDetalles = new PdfPTable(4);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([6, 20, 62, 12]))
            def fondo = new Color(240, 240, 240);


            addCellTabla(tablaHeaderDetalles, new Paragraph("Dpto.", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaHeaderDetalles, new Paragraph("Nombre", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaHeaderDetalles, new Paragraph("Detalle", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaHeaderDetalles, new Paragraph("Por Pagar", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])
        }


        def printTotales = { params ->

            def tablaTotal = new PdfPTable(2);
            tablaTotal.setWidthPercentage(100);
            tablaTotal.setWidths(arregloEnteros([88, 12]))

            addCellTabla(tablaTotal, new Paragraph("Total: ", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaTotal, new Paragraph("" + params.total, fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])

            addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])

        }

        def currentPag = 1
        def totalPags = Math.ceil(tamano / max)
        def pagActual = 1

        tablaDetalles = new PdfPTable(4);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([6, 20, 62, 12]))
        tablaDetalles.setSpacingAfter(1f);


        def anterior
        def nuevo
        def total = 0
        def contador = 0
        def ultimo = res.last().prsndpto
        def adicionales = 0
        def u = 0

        res.each { fila ->

//            println("actual " + actual)
//            println("adicionales " + adicionales)
//            println("pagActual " + pagActual)

            if (actual == 0) {
                printHeaderDetalle()
            }

//            if((actual.toInteger() + adicionales.toInteger()) == (max*(pagActual))){
            if ((actual.toInteger() + adicionales.toInteger()) >= max) {
                max = (max + 6)
                printHeaderDetalle()
                actual = 0
                adicionales = 0
            }

            nuevo = fila.prsndpto
            contador++

//            println("contador " + contador)
//            println("tamaño " + tamano)
//            println("anterior " + anterior)
//            println("nuevo " + nuevo)

            if (anterior == nuevo) {
                if (nuevo == ultimo && (tamano.toInteger()) == contador) {
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                    total += fila.sldo
                    anterior = fila.prsndpto
                    printTotales([total: total])
                    adicionales++
                } else {
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                    total += fila.sldo
                    anterior = fila.prsndpto
                }
            } else {
                if (contador == 1) {
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                    total += fila.sldo
                    anterior = fila.prsndpto
                } else {
                    if (tamano.toInteger() == contador) {
                        printTotales([total: total])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                        total = fila.sldo
                        anterior = fila.prsndpto
                        printTotales([total: fila.sldo])
                        adicionales++
                    } else {
                        printTotales([total: total])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                        total = fila.sldo
                        anterior = fila.prsndpto
                        adicionales++
                    }
                }
            }

            actual++
            u = (actual.toInteger() + adicionales.toInteger())

//            println("--- " + u)
            if (actual <= max) {
                pagActual = 1
            } else {
                pagActual = Math.ceil(actual / max).toInteger()
            }
        }


        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def pagosPendientes3() {

//        println "params pagosPendientes3: " + params

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from pendiente('${fecha.format('yyy-MM-dd')}')"
//        println("sql " + sql)

        def res = cn.rows(sql.toString())
        def tamano = res.size()
        def max = 48
        def malox = 46
        def actual = 0
//        println("tamaño " + tamano)


        def baos = new ByteArrayOutputStream()
        def name = "pagosPendientes_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(30, 140, 160)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);

        def fondoTotal = new Color(245, 243, 245);

        def prmsTdNoBorder = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        Document document
//        document = new Document(PageSize.A4.rotate());
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 30, 28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Pagos Pendientes");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
//        preface.add(new Paragraph("CONJUNTO HABITACIONAL 'LOS VIÑEDOS'", fontTitulo));
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("Deudas pendientes al ${util.fechaConFormato(fecha: fecha, formato: 'dd MMMM yyyy')}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null



        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(5);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([8, 20, 52, 9, 11]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Dpto.", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Nombre", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Detalle", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Cuota", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Por Pagar", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 6, pl: 0])
        }


        def printTotales = { params ->
            def tablaTotal = new PdfPTable(2);
            tablaTotal.setWidthPercentage(100);
            tablaTotal.setWidths(arregloEnteros([89, 11]))

            addCellTabla(tablaTotal, new Paragraph("Total: ", fontTh), [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaTotal, new Paragraph("${numero(params.total, 2)}", fontTh), [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])

            addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 5, pl: 0])
        }

        def currentPag = 1
        def totalPags = Math.ceil(tamano / max)
        def pagActual = 1

        tablaDetalles = new PdfPTable(5);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([8, 20, 52, 9, 11]))
        tablaDetalles.setSpacingAfter(1f);


        def anterior
        def nuevo
        def total = 0
        def contador = 0
        def ultimo = res.last().prsndpto
        def adicionales = 0
        def u = 0

//        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        res.each { fila ->
            if (actual == 0) {
                printHeaderDetalle()
            }
            if ((actual.toInteger() + adicionales.toInteger()) >= max) {
//                max = (max + 7)
                max = 48
                printHeaderDetalle()
                actual = 0
                adicionales = 0
            }


            nuevo = fila.prsndpto
            contador++

//            println("contador " + contador)
//            println("tamaño " + tamano)
//            println("anterior " + anterior)
//            println("nuevo " + nuevo)


            if (anterior == nuevo) {
                if (nuevo == ultimo && (tamano.toInteger()) == contador) {
                    celdas(tablaDetalles, fila.prsndpto, fila.prsn, fila.oblg, fila.alct, fila.sldo, fontTd10, frmtDato, frmtNmro)
                    total += fila.sldo
                    anterior = fila.prsndpto
                    printTotales([total: total])
                    adicionales++
                } else {
                    celdas(tablaDetalles, fila.prsndpto, fila.prsn, fila.oblg, fila.alct, fila.sldo, fontTd10, frmtDato, frmtNmro)
                    total += fila.sldo
                    anterior = fila.prsndpto
                }
            } else {
                if (contador == 1) {
                    celdas(tablaDetalles, fila.prsndpto, fila.prsn, fila.oblg, fila.alct, fila.sldo, fontTd10, frmtDato, frmtNmro)
                    total += fila.sldo
                    anterior = fila.prsndpto
                } else {
                    if (tamano.toInteger() == contador) {
                        printTotales([total: total])
                        celdas(tablaDetalles, fila.prsndpto, fila.prsn, fila.oblg, fila.alct, fila.sldo, fontTd10, frmtDato, frmtNmro)

                        total = fila.sldo
                        anterior = fila.prsndpto
                        printTotales([total: fila.sldo])
                        adicionales++
                    } else {
                        printTotales([total: total])
                        celdas(tablaDetalles, fila.prsndpto, fila.prsn, fila.oblg, fila.alct, fila.sldo, fontTd10, frmtDato, frmtNmro)
                        total = fila.sldo
                        anterior = fila.prsndpto
                        adicionales++
                    }
                }
            }

            actual++
            u = (actual.toInteger() + adicionales.toInteger())

//            println("--- " + u)
            if (actual <= max) {
                pagActual = 1
            } else {
                pagActual = Math.ceil(actual / max).toInteger()
            }
        }


        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def celdas(tablaDetalles, dpto, prsn, oblg, alct, sldo, fontTd10, frmtDato, frmtNmro) {
        addCellTabla(tablaDetalles, new Paragraph(dpto, fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph(prsn, fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph(oblg, fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph(alct.toString(), fontTd10), frmtNmro)
        addCellTabla(tablaDetalles, new Paragraph(sldo.toString(), fontTd10), frmtNmro)
    }

    def fecha_ajax() {

    }

    def solicitud() {

        def pl = new ByteArrayOutputStream()
        byte[] b

        pl = solicitudes(params.id)
        b = pl.toByteArray();

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=solicitud_${new Date().format("dd-MM-yyyy")}")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    public PdfPCell getCell(String text, int alignment) {
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        PdfPCell cell = new PdfPCell(new Phrase(text, fontTd10));
        cell.setPadding(0);
        cell.setHorizontalAlignment(alignment);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }

    public PdfPCell getCell12(String text, int alignment) {
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        PdfPCell cell = new PdfPCell(new Phrase(text, fontTd10));
        cell.setPadding(0);
        cell.setHorizontalAlignment(alignment);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }

    def solicitudes(id) {

//        println "params " + params

        def persona = Persona.get(id)
        def condominio = Condominio.get(session.condominio.id)
        def sql = "select * from personas(${condominio?.id}) where prsn__id= ${persona.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        def sql2 = "select * from pendiente('${new Date().format("yyyy-MM-dd")}') where prsn__id= ${persona.id} order by ingrfcha"
        def cn2 = dbConnectionService.getConnection()
        def data2 = cn2.rows(sql2.toString())

        def baos = new ByteArrayOutputStream()
        def name = "solicitud_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        Font info = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL)
        Font nota = new Font(Font.TIMES_ROMAN, 11, Font.ITALIC)
        Font notaTitulo = new Font(Font.TIMES_ROMAN, 11, Font.BOLD)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtHdr = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtDatoDere = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]


        def fondoTotal = new Color(240, 240, 240);

        def prmsTdNoBorder = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def para = persona.sexo == 'M' ? 'Señor' : 'Señora(ita)'

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(74, 60, 30, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Solicitud");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph("CONJUNTO HABITACIONAL 'LOS VIÑEDOS'", fontTitle));
        addEmptyLine(preface, 2);
        document.add(preface);

        def tabla = new PdfPTable(2);
        tabla.setWidthPercentage(90);
        tabla.setWidths(arregloEnteros([75, 15]))

        PdfPTable table = new PdfPTable(1);
        table.setWidthPercentage(100);
//        table.addCell(getCell12(" ", PdfPCell.ALIGN_LEFT));
//        table.addCell(getCell12(" ", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell12("Quito, ${util.fechaConFormato(fecha: new Date(), formato: 'dd MMMM yyyy')} ", PdfPCell.ALIGN_RIGHT));
        table.addCell(getCell12(" ", PdfPCell.ALIGN_LEFT));
//        table.addCell(getCell12(" ", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell12(para, PdfPCell.ALIGN_LEFT));
        document.add(table);

        Paragraph c = new Paragraph();
        c.add(new Paragraph((persona?.nombre ?: '') + ' ' + (persona?.apellido ?: ''), info))
        document.add(c)
        Paragraph d = new Paragraph();
        d.add(new Paragraph((persona?.edificio?.descripcion ?: '') + ', Departamento: ' + (persona?.departamento ?: ''), info))
        document.add(d)
        Paragraph p = new Paragraph();
        p.add(new Paragraph("Presente,", info))
        addEmptyLine(p, 1);
        document.add(p)
        Paragraph t1 = new Paragraph();
        t1.setAlignment("Justify");

        t1.add(new Paragraph("Luego de un atento saludo, me permito solicitarle el pago de la deuda que mantiene " +
                "con el conjunto residencial \"Los Viñedos\", la misma que asciende a un valor de " +
                "\$ ${data[0].prsnsldo}, de acuerdo con el siguiente desglose:", info))
        addEmptyLine(t1, 1);
        document.add(t1)

        addCellTabla(tabla, new Paragraph("Concepto", fontTh), frmtHd)
        addCellTabla(tabla, new Paragraph("Valor", fontTh), frmtHd)
        data2.each { pendiente ->
            if (pendiente.sldo > 0) {
                addCellTabla(tabla, new Paragraph(pendiente.oblg, fontTd10), frmtDato)
                addCellTabla(tabla, new Paragraph(pendiente.sldo.toString(), fontTd10), frmtDatoDere)
            }
        }
        addCellTabla(tabla, new Paragraph('Total', fontTh), frmtHdr)
        addCellTabla(tabla, new Paragraph("${data[0].prsnsldo}", fontTh), frmtHdr)
        document.add(tabla)

        Paragraph e = new Paragraph();
        e.add(new Paragraph("", info))
        document.add(e)

        Paragraph t2 = new Paragraph();
        t2.setAlignment("Justify");
        t2.add(new Paragraph( "El cobro de intereses por mora se aplica desde el 1° de abril de 2018, conforme lo determina " +
                "nuestro Reglamento Interno en el artículo 39 literal 'p', a los valores adeudados hasta el 31 de enero " +
                "de 2018, así como también a las deudas que superen los 2 meses de alícuotas. Por esta razón me " +
                "permito insistir en que realice el pago lo antes posible o proponga una forma de pago enviando " +
                "la misma al correo electrónico vinedos269@gmail.com.", info))
        addEmptyLine(t2, 1);
        document.add(t2)

        Paragraph t3 = new Paragraph();
        t3.setAlignment("Justify");
        t3.add(new Paragraph("Agradezco su tiempo y la oportuna atención que de a la presente, lo que nos ayudará " +
                "a pagar oportunamente las planillas de agua, luz, mantenimeinto del ascensor, conserje, vigilancia " +
                "y destinar recursos para la limpieza, conservación y mejora de los bienes comunales. ", info))
        addEmptyLine(t3, 1);
        document.add(t3)
        Paragraph a = new Paragraph();
        a.add(new Paragraph("Atentamente,", info))
        addEmptyLine(a, 3);
        document.add(a)
        Paragraph f = new Paragraph();
        f.add(new Paragraph("Ing. Guido Ochoa Moreno", info))
        f.add(new Paragraph("ADMINISTRADOR", info))
        f.add(new Paragraph("Cel: 0984916620, dpto. 214", info))
        addEmptyLine(f, 1);
        document.add(f)

        Paragraph t4 = new Paragraph();
        t4.setAlignment("Justify");
        t4.add(new Paragraph("PD: ART. 39 literal p:", notaTitulo))
        t4.add(new Paragraph("«Por no pago de alícuotas ordinarias y/o extraordinarias, " +
                "a partir del segundo mes:", nota))
        t4.add(new Paragraph("ACCIÓN: Recorte de servicios básicos y cobro de interés por mora»", nota))
        document.add(t4)

        document.close();
        pdfw.close()
        return baos

    }

    def imprimirSolicitudes() {
        println "params imprimirSolicitudes: $params"

        def pl = new ByteArrayOutputStream()
        byte[] b
        def pdfs = []
        def contador = 0
        def condominio = Condominio.get(session.condominio.id)
        def sql = "select * from personas(${condominio?.id})"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())
        def fctr = params.vlor.toInteger()


        data.each { persona ->
            if (persona.prsnsldo > (persona.alctvlor * fctr)) {
                pl = solicitudes(persona.prsn__id)
                pdfs.add(pl.toByteArray())
                contador++
            }
        }

        if (contador > 1) {
            def baos = new ByteArrayOutputStream()
            Document document
            document = new Document(PageSize.A4);

            def pdfw = PdfWriter.getInstance(document, baos);
            document.open();
            PdfContentByte cb = pdfw.getDirectContent();

            pdfs.each { f ->
                PdfReader reader = new PdfReader(f);
                for (int i = 1; i <= reader.getNumberOfPages(); i++) {
                    //nueva página
                    document.newPage();
                    //importa la página "i" de la fuente "reader"
                    PdfImportedPage page = pdfw.getImportedPage(reader, i);
                    //añade página
                    cb.addTemplate(page, 0, 0);
                }
            }
            document.close();
            b = baos.toByteArray();
        } else {
            b = pl.toByteArray();
        }

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=solicitudes")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def imprimirReporteGeneral() {

//        println("params " + params)

        def anioMes = params.anio + params.mes
        def mesA

        def anioMesAnterior
        if (params.mes == '01') {
            anioMesAnterior = (params.anio.toInteger() - 1) + "12"
        } else {
            mesA = (params.mes == '11' || params.mes == '12') ? (params.mes.toInteger() - 1) : ("0" + (params.mes.toInteger() - 1).toString())
            anioMesAnterior = params.anio + mesA
        }

        def cnn = dbConnectionService.getConnection()
//        def sqln="SELECT (date_trunc('MONTH', ('201802'||'01')::date) + INTERVAL '1 MONTH - 1 day')::DATE;"
        def sqln = "SELECT (date_trunc('MONTH', ('${anioMes}'||'01')::date) + INTERVAL '1 MONTH - 1 day')::DATE;"

        def fechaInicio = new Date().parse("dd-MM-yyy", "01-" + params.mes + "-" + params.anio)
        def fechaFin = cnn.rows(sqln.toString()).first().date

        def fechaInicioAnterior
        if (params.mes == '01') {
            fechaInicioAnterior = new Date().parse("dd-MM-yyy", "01-12-" + (params.anio.toInteger() - 1))
        } else {
            fechaInicioAnterior = new Date().parse("dd-MM-yyy", "01-" + (params.mes.toInteger() - 1) + "-" + params.anio)
        }

        def cna = dbConnectionService.getConnection()
        def sqla = "SELECT (date_trunc('MONTH', ('${anioMesAnterior}'||'01')::date) + INTERVAL '1 MONTH - 1 day')::DATE;"
        def fechaFinAnterior = cna.rows(sqla.toString()).first().date

        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);

        def baos = new ByteArrayOutputStream()
        def name = "reporteGeneral_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def jefe = params.jefe == '1'
        def results = [], resGraph = [], dep = null, per = null

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(74, 60, 30, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();

        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Solicitud");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph("CONJUNTO HABITACIONAL 'LOS VIÑEDOS'", fontTitle));
        addEmptyLine(preface, 2);
        document.add(preface);

        /***************SQL************************/
        def txfcin = fechaInicio.format('yyyy-MM-dd')
        def txfcfn = fechaFin.format('yyyy-MM-dd')
        def txfcinAn = fechaInicioAnterior.format('yyyy-MM-dd')
        def txfcfnAn = fechaFinAnterior.format('yyyy-MM-dd')

        //total de Personas
        def condominio = Condominio.get(session.condominio.id)
        def cn0 = dbConnectionService.getConnection()
        def totalPersonas = "select count(prsnnmbr) from personas(${condominio?.id})"
        def res0 = cn0.rows(totalPersonas.toString())

        //este mes pagado
        def cn = dbConnectionService.getConnection()
        def esteMes = "select count(distinct prsn__id) from pago, ingr where pago.ingr__id = ingr.ingr__id and pagofcpg between '${txfcin}' and '${txfcfn}' and oblg__id in (2,7);"
        def res = cn.rows(esteMes.toString())

        //mes anterior
        def cn1 = dbConnectionService.getConnection()
        def mesAnterior = "select count(distinct prsn__id) from pago, ingr where pago.ingr__id = ingr.ingr__id and \n" +
                "  pagofcpg between '${txfcinAn}' and '${txfcfnAn}' and oblg__id in (2,7);"
        def res1 = cn1.rows(mesAnterior.toString())

        //valores vencidos
        def cn2 = dbConnectionService.getConnection()
        def vencidos = "select count(distinct prsn__id) from pago, ingr where pago.ingr__id = ingr.ingr__id and\n" +
                "  pagofcpg between '${txfcin}' and '${txfcfn}' and oblg__id in (2,7) and\n" +
                "  ingrfcha < '${txfcin}';"
        def res2 = cn2.rows(vencidos.toString())

        //ingresos mes anterior
        def cn3 = dbConnectionService.getConnection()
        def ingresosAnterior = "select sum(pagovlor) from pago where pagofcpg between '${txfcinAn}' and '${txfcfnAn}';"
        def res3 = cn3.rows(ingresosAnterior.toString())

        //ingresos mes actual
        def cn4 = dbConnectionService.getConnection()
        def ingresosActual = "select sum(pagovlor) from pago where pagofcpg between '${txfcin}' and '${txfcfn}';"
        def res4 = cn4.rows(ingresosActual.toString())

        //egresos mes anterior
        def cn5 = dbConnectionService.getConnection()
        def egresosAnterior = "select sum(pgegvlor) from pgeg where pgegfcpg between '${txfcinAn}' and '${txfcfnAn}';"
        def res5 = cn5.rows(egresosAnterior.toString())

        //egresos mes actual
        def cn6 = dbConnectionService.getConnection()
        def egresosActual = "select sum(pgegvlor) from pgeg where pgegfcpg between '${txfcin}' and '${txfcfn}';"
        def res6 = cn6.rows(egresosActual.toString())

        //valores por cobrar a la fecha y saldos

        def cn7 = dbConnectionService.getConnection()
        def valores = "select * from saldos('${txfcin}', '${txfcfn}');"
        def res7 = cn7.rows(valores.toString())

        /* ************************************************* Graficos *************************** */
        boolean conGraficos
        try {
            def width = 550
            def width2 = 350
            def height = 180
            def height2 = 180
            PdfContentByte contentByte = pdfw.getDirectContent();
            PdfTemplate templateSinRecepcion = contentByte.createTemplate(width2, height);
            PdfTemplate templateRetrasados = contentByte.createTemplate(width2, height2);
            PdfTemplate template2 = contentByte.createTemplate(width2, height);
            PdfTemplate template3 = contentByte.createTemplate(width2, height);
            PdfTemplate template4 = contentByte.createTemplate(width2, height2);
            PdfTemplate template5 = contentByte.createTemplate(width2, height2);

            Graphics2D graphics2dSinRecepcion = templateSinRecepcion.createGraphics(width2, height, new DefaultFontMapper());
            Graphics2D graphics2d2 = template2.createGraphics(width2, height, new DefaultFontMapper());
            Graphics2D graphics2d3 = template3.createGraphics(width2, height, new DefaultFontMapper());
            Graphics2D graphics2dRetrasados = templateRetrasados.createGraphics(width2, height2, new DefaultFontMapper());
            Graphics2D graphics2d4 = template4.createGraphics(width2, height2, new DefaultFontMapper());
            Graphics2D graphics2d5 = template5.createGraphics(width2, height2, new DefaultFontMapper());

            Rectangle2D rectangle2dSinRecepcion = new Rectangle2D.Double(0, 0, width2, height);
            Rectangle2D rectangle2dRetrasados = new Rectangle2D.Double(0, 0, width2, height2);
            Rectangle2D rectangle2d2 = new Rectangle2D.Double(0, 0, width2, height);
            Rectangle2D rectangle2d3 = new Rectangle2D.Double(0, 0, width2, height);
            Rectangle2D rectangle2d4 = new Rectangle2D.Double(0, 0, width2, height2);
            Rectangle2D rectangle2d5 = new Rectangle2D.Double(0, 0, width2, height2);

////        PARA GRAFICO PASTEL
            DefaultPieDataset dataSetRet = new DefaultPieDataset();
            DefaultPieDataset dataSetNoRec = new DefaultPieDataset();
            DefaultPieDataset dataSet4 = new DefaultPieDataset();
            DefaultCategoryDataset dataSetBarras = new DefaultCategoryDataset();
            DefaultCategoryDataset dataSetBarras2 = new DefaultCategoryDataset();
            DefaultCategoryDataset dataSetBarras3 = new DefaultCategoryDataset();
            DefaultPieDataset dataSet5 = new DefaultPieDataset();

            dataSetRet.setValue("Pagado", res.first().count.toInteger())
            dataSetRet.setValue("No Pago", res0.first().count.toInteger() - res.first().count.toInteger())

            dataSet4.setValue("Pagado", res1.first().count.toInteger())
            dataSet4.setValue("No Pago", res0.first().count.toInteger() - res1.first().count.toInteger())

            dataSet5.setValue("Pago Vencidos", res2.first().count.toInteger())
            dataSet5.setValue("No Pago", res0.first().count.toInteger() - res2.first().count.toInteger())

            dataSetBarras.addValue(res3.first().sum?.toDouble() ?: 0, 'Ingresos mes anterior', 'Anterior: ' + (res3.first().sum == null ? 0 : res3.first().sum?.toDouble()));
            dataSetBarras.addValue(res4.first().sum?.toDouble() ?: 0, 'Ingresos este mes', 'Actual: ' + (res4.first().sum == null ? 0 : res4.first().sum?.toDouble()));

            dataSetBarras2.addValue(res5.first().sum?.toDouble() ?: 0, 'Egresos mes anterior', 'Anterior: ' + (res5.first().sum == null ? 0 : res5.first().sum?.toDouble()));
            dataSetBarras2.addValue(res6.first().sum?.toDouble() ?: 0, 'Egresos este mes', 'Actual: ' + (res6.first().sum == null ? 0 : res6.first().sum?.toDouble()));

            dataSetBarras3.addValue(res7.first().sldofnal?.toDouble() ?: 0, 'Saldo Inicial', res7.first().sldofnal?.toDouble() ?: 0);
            dataSetBarras3.addValue(res7.first().ingrsldo?.toDouble() ?: 0, 'Por Cobrar', res7.first().ingrsldo?.toDouble() ?: 0);
            dataSetBarras3.addValue(res7.first().egrssldo?.toDouble() ?: 0, 'Por Pagar', res7.first().egrssldo?.toDouble() ?: 0);
            dataSetBarras3.addValue(res7.first().sldofnal?.toDouble() + res7.first().ingrsldo?.toDouble() - res7.first().egrssldo?.toDouble(), 'Resul. Final', '' + (res7.first().sldofnal?.toDouble() + res7.first().ingrsldo?.toDouble() - res7.first().egrssldo?.toDouble()));


            JFreeChart chartSinRecepcion = ChartFactory.createPieChart("Gráfico", dataSetNoRec, true, true, false);
            chartSinRecepcion.setTitle(
                    new org.jfree.chart.title.TextTitle("Gráfico 2",
                            new java.awt.Font("SansSerif", java.awt.Font.BOLD, 15)
                    )
            );
            JFreeChart chartRetrasados = ChartFactory.createPieChart("Gráfico 3", dataSetRet, true, true, false);
            chartRetrasados.setTitle(
                    new org.jfree.chart.title.TextTitle("Pagos Mes Actual",
                            new java.awt.Font("SansSerif", java.awt.Font.BOLD, 15)
                    )
            );

            JFreeChart barChart = ChartFactory.createBarChart("", "", "Ingresos", dataSetBarras, PlotOrientation.VERTICAL, true, true, false);
            barChart.setTitle(
                    new org.jfree.chart.title.TextTitle("Ingresos (Anterior/Actual)",
                            new java.awt.Font("SansSerif", java.awt.Font.BOLD, 15)
                    )
            );


            JFreeChart barChart2 = ChartFactory.createBarChart("", "", "Egresos", dataSetBarras2, PlotOrientation.VERTICAL, true, true, false);
            barChart2.setTitle(
                    new org.jfree.chart.title.TextTitle("Egresos (Anterior/Actual)",
                            new java.awt.Font("SansSerif", java.awt.Font.BOLD, 15)
                    )
            );


            JFreeChart barChart3 = ChartFactory.createBarChart("","", "", dataSetBarras3 , PlotOrientation.VERTICAL, true, true, false);
            barChart3.setTitle(
                    new org.jfree.chart.title.TextTitle("Valores por cobrar a la fecha y saldos",
                            new java.awt.Font("SansSerif", java.awt.Font.BOLD, 15)
                    )
            );

            JFreeChart chart4 = ChartFactory.createPieChart("", dataSet4, true, true, false);
            chart4.setTitle(
                    new org.jfree.chart.title.TextTitle("Pagos mes anterior",
                            new java.awt.Font("SansSerif", java.awt.Font.BOLD, 15)
                    )
            )

            JFreeChart chart5 = ChartFactory.createPieChart("", dataSet5, true, true, false);
            chart5.setTitle(
                    new org.jfree.chart.title.TextTitle("Pagos valores vencidos",
                            new java.awt.Font("SansSerif", java.awt.Font.BOLD, 15)
                    )
            )

            /* getPlot method of JFreeChart class returns the PiePlot object back to us */
            PiePlot ColorConfigurator = (PiePlot) chartSinRecepcion.getPlot(); /* get PiePlot object for changing */
            PiePlot ColorConfigurator2 = (PiePlot) chartRetrasados.getPlot(); /* get PiePlot object for changing */
            PiePlot ColorConfigurator4 = (PiePlot) chart4.getPlot()
            PiePlot ColorConfigurator5 = (PiePlot) chart5.getPlot()

            ColorConfigurator.setBackgroundAlpha(0f)
            ColorConfigurator2.setBackgroundAlpha(0f)
            ColorConfigurator4.setBackgroundAlpha(0f)
            ColorConfigurator5.setBackgroundAlpha(0f)

            /* A format mask specified to display labels. Here {0} is the section name, and {1} is the value.
            We can also use {2} which will display a percent value */
            ColorConfigurator.setLabelGenerator(new StandardPieSectionLabelGenerator("{0}:{1} ({2})"));
            ColorConfigurator2.setLabelGenerator(new StandardPieSectionLabelGenerator("{0}:{1} ({2})"));
            ColorConfigurator4.setLabelGenerator(new StandardPieSectionLabelGenerator("{0}:{1} ({2})"));
            ColorConfigurator5.setLabelGenerator(new StandardPieSectionLabelGenerator("{0}:{1} ({2})"));
            /* Set color of the label background on the pie chart */
            ColorConfigurator.setLabelBackgroundPaint(new Color(220, 220, 220))
            ColorConfigurator2.setLabelBackgroundPaint(new Color(220, 220, 220));
            ColorConfigurator4.setLabelBackgroundPaint(new Color(220, 220, 220));
            ColorConfigurator5.setLabelBackgroundPaint(new Color(220, 220, 220));

            chartSinRecepcion.draw(graphics2dSinRecepcion, rectangle2dSinRecepcion);
            chart4.draw(graphics2d4, rectangle2d4);
            chart5.draw(graphics2d5, rectangle2d5);
            barChart.draw(graphics2dSinRecepcion, rectangle2dSinRecepcion);
            barChart2.draw(graphics2d2, rectangle2d2);
            barChart3.draw(graphics2d3, rectangle2d3);
            chartRetrasados.draw(graphics2dRetrasados, rectangle2dRetrasados);


            graphics2dSinRecepcion.dispose();
            graphics2d4.dispose();
            graphics2d5.dispose();
            graphics2dRetrasados.dispose();
            graphics2d2.dispose();
            graphics2d3.dispose();

            def posyGraf5 = 550
            def posyGraf1 = 350
            def posyGraf55 = 150

            def posyGraf2 = 600
            def posyGraf3 = 380
            def posyGraf4 = 150

            contentByte.addTemplate(template4, 110, posyGraf5);
            contentByte.addTemplate(templateRetrasados, 110, posyGraf1);
            contentByte.addTemplate(template5, 110, posyGraf55);

            document.newPage();

            contentByte.addTemplate(templateSinRecepcion, 110, posyGraf2);
            contentByte.addTemplate(template2, 110, posyGraf3);
            contentByte.addTemplate(template3, 110, posyGraf4);

        } catch (e) {
            println "ERROR GRAFICOS::::::: "
            e.printStackTrace();
            conGraficos = false
        }


        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def detalle() {

        def cn = dbConnectionService.getConnection()
        def sql = 'select distinct cast (extract(year from pagofcpg) as INT) from pago order by 1;'
        def res = cn.rows(sql.toString())

        return [anios: res.date_part]
    }

    def detalle_ajax() {
//        println("params " + params)

        def resGraph = [], dep = null, per = null
        def anioMes = params.anio + params.mes
        def mesA

        def anioMesAnterior
        if (params.mes == '01') {
            anioMesAnterior = (params.anio.toInteger() - 1) + "12"
        } else {
            mesA = (params.mes.toInteger() == 11 || params.mes.toInteger() == 12) ? (params.mes.toInteger() - 1) : ("0" + (params.mes.toInteger() - 1))
            anioMesAnterior = params.anio + mesA
        }

        def cnn = dbConnectionService.getConnection()
        def sqln = "SELECT (date_trunc('MONTH', ('${anioMes}'||'01')::date) + INTERVAL '1 MONTH - 1 day')::DATE;"

        def fechaInicio = new Date().parse("dd-MM-yyy", "01-" + params.mes + "-" + params.anio)
        def fechaFin = cnn.rows(sqln.toString()).first().date

        def fechaInicioAnterior
        if (params.mes == '01') {
            fechaInicioAnterior = new Date().parse("dd-MM-yyy", "01-12-" + (params.anio.toInteger() - 1))
        } else {
            fechaInicioAnterior = new Date().parse("dd-MM-yyy", "01-" + (params.mes.toInteger() - 1) + "-" + params.anio)
        }

        def cna = dbConnectionService.getConnection()
        def sqla = "SELECT (date_trunc('MONTH', ('${anioMesAnterior}'||'01')::date) + INTERVAL '1 MONTH - 1 day')::DATE;"
        def fechaFinAnterior = cna.rows(sqla.toString()).first().date

        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);

        /***************SQL************************/

        def txfcin = fechaInicio.format('yyyy-MM-dd')
        def txfcfn = fechaFin.format('yyyy-MM-dd')
        def txfcinAn = fechaInicioAnterior.format('yyyy-MM-dd')
        def txfcfnAn = fechaFinAnterior.format('yyyy-MM-dd')

        //total de Personas
        def condominio = Condominio.get(session.condominio.id)
        def cn0 = dbConnectionService.getConnection()
        def totalPersonas = "select count(prsnnmbr) from personas(${condominio?.id})"
        def res0 = cn0.rows(totalPersonas.toString())

        //este mes pagado
        def cn = dbConnectionService.getConnection()
        def esteMes = "select count(distinct prsn__id) from pago, ingr, oblg " +
                "where pago.ingr__id = ingr.ingr__id and " +
                "pagofcpg between '${txfcin}' and '${txfcfn}' and oblg.oblg__id = ingr.oblg__id and " +
                "tpap__id = 1"
        def res = cn.rows(esteMes.toString())

        def pagados = res.first().count.toInteger()
        def noPagados = res0.first().count.toInteger() - (res.first().count?.toInteger() ?: 0)

        //mes anterior
        def cn1 = dbConnectionService.getConnection()
        def mesAnterior = "select count(distinct prsn__id) from pago, ingr, oblg " +
                "where pago.ingr__id = ingr.ingr__id and " +
                "  pagofcpg between '${txfcinAn}' and '${txfcfnAn}' and oblg.oblg__id = ingr.oblg__id and " +
                "tpap__id = 1"
        def res1 = cn1.rows(mesAnterior.toString())

        def pagadosAnterior = res1.first().count.toInteger()
        def noPagadosAnterior = res0.first().count.toInteger() - (res1.first().count?.toInteger() ?: 0)

        //valores vencidos
        def cn2 = dbConnectionService.getConnection()
        def vencidos = "select count(distinct prsn__id) from pago, ingr, oblg " +
                "where pago.ingr__id = ingr.ingr__id and pagofcpg between '${txfcin}' and '${txfcfn}' and " +
                "oblg.oblg__id = ingr.oblg__id and tpap__id = 1 and ingrfcha < '${txfcin}'"
        def res2 = cn2.rows(vencidos.toString())

        def venci = res2.first().count.toInteger()
        def noVencidos = res0.first().count.toInteger() - (res2.first().count?.toInteger() ?: 0)

        //ingresos mes anterior
        def cn3 = dbConnectionService.getConnection()
        def ingresosAnterior = "select sum(pagovlor) from pago where pagofcpg between '${txfcinAn}' and '${txfcfnAn}';"
        def res3 = cn3.rows(ingresosAnterior.toString())

        def ingresosAnt = (res3.first().sum == null ? 0 : res3.first().sum?.toDouble())


        def cn10 = dbConnectionService.getConnection()
        def ingresoTotalAnt = "select sum(alctvlor) from alct where prsn__id in (select prsn__id from prsn where cndm__id = ${session.condominio.id} and prsnactv = 1) and '${txfcinAn}' between alctfcds and coalesce(alctfchs, now());"
        def res10 = cn10.rows(ingresoTotalAnt.toString())

        def ingresoTA = res10.first().sum?.toDouble() ?: 0

        //ingresos mes actual
        def cn4 = dbConnectionService.getConnection()
        def ingresosActual = "select sum(pagovlor) from pago where pagofcpg between '${txfcin}' and '${txfcfn}'"
        def res4 = cn4.rows(ingresosActual.toString())

        def ingresosAct = (res4.first().sum == null ? 0 : res4.first().sum?.toDouble())


        def cn11 = dbConnectionService.getConnection()
        def ingresoTotalAct = "select sum(alctvlor) from alct where prsn__id in (select prsn__id from prsn where cndm__id = ${session.condominio.id} and prsnactv = 1) and '${txfcin}' between alctfcds and coalesce(alctfchs, now());"
        def res11 = cn11.rows(ingresoTotalAct.toString())

        def ingresoTAC = res11.first().sum?.toDouble() ?: 0

        //egresos mes anterior
        def cn5 = dbConnectionService.getConnection()
        def egresosAnterior = "select sum(pgegvlor) from pgeg where pgegfcpg between '${txfcinAn}' and '${txfcfnAn}';"
        def res5 = cn5.rows(egresosAnterior.toString())

        def egresosAnt = (res5.first().sum == null ? 0 : res5.first().sum?.toDouble())

        //egresos mes actual
        def cn6 = dbConnectionService.getConnection()
        def egresosActual = "select sum(pgegvlor) from pgeg where pgegfcpg between '${txfcin}' and '${txfcfn}';"
        def res6 = cn6.rows(egresosActual.toString())

        def egresosAct = (res6.first().sum == null ? 0 : res6.first().sum?.toDouble())

        //valores por cobrar a la fecha y saldos

        def cn7 = dbConnectionService.getConnection()
        def valores = "select * from saldos('${txfcin}', '${txfcfn}');"
        def res7 = cn7.rows(valores.toString())

        def si = res7.first().sldofnal?.toDouble() ?: 0
        def is = res7.first().ingrsldo?.toDouble() ?: 0
        def es = res7.first().egrssldo?.toDouble() ?: 0
        def sf = res7.first().sldofnal?.toDouble() + res7.first().ingrsldo?.toDouble() - res7.first().egrssldo?.toDouble()

        //grafico ingresos y egresos

        def cn8 = dbConnectionService.getConnection()
        def valores2 = "select * from ingr_egrs(${params.anio}, ${condominio?.id});"
        def res8 = cn8.rows(valores2.toString())


        def jsonGraph = new JsonBuilder(resGraph)

        return [jsonGraph        : jsonGraph.toString(), pagados: pagados, noPagados: noPagados, pagadosAnterior: pagadosAnterior,
                noPagadosAnterior: noPagadosAnterior, vencidos: venci, noVencidos: noVencidos, ingresosAnt: ingresosAnt,
                ingresosAct      : ingresosAct, egresosAnt: egresosAnt, egresosAct: egresosAct, saldoInicial: si, ingresoSaldo: is,
                egresoSaldo: es, saldoFinal: sf, ingresoTotalAnt: ingresoTA, ingresoTotalAct: ingresoTAC, ingresoEgreso: res8]

    }


    def ingresosImprimir () {
        println("params " + params)

        def resGraph = []
        def condominio = Condominio.get(session.condominio.id)
        //grafico ingresos y egresos

        def cn8 = dbConnectionService.getConnection()
        def valores2 = "select * from ingr_egrs(${params.anio}, ${condominio?.id});"
        def res8 = cn8.rows(valores2.toString())

        def jsonGraph = new JsonBuilder(resGraph)

        return [jsonGraph : jsonGraph.toString(), ingresoEgreso: res8, anio: params.anio]
    }


    def listaCondominos() {


        def baos = new ByteArrayOutputStream()
        def name = "listaCondominos_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);

        def prmsTdNoBorder = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 30, 28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Lista de condóminos");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("LISTA DE CONDÓMINOS", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null


        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(4);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([15, 25,25, 35]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Dpto.", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Nombre", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Apellido", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Firma", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])
        }

        tablaDetalles = new PdfPTable(4);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([15,25,25,35]))
        tablaDetalles.setSpacingAfter(1f);


        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]

        def condominio = Condominio.get(session.condominio.id)
        def lista = Persona.findAllByCondominioAndActivo(condominio, 1).sort{it.departamento}
        printHeaderDetalle()

        lista.each { persona ->
            addCellTabla2(tablaDetalles, new Paragraph(persona.departamento, fontTd10), frmtDato)
            addCellTabla2(tablaDetalles, new Paragraph(persona.nombre, fontTd10), frmtDato)
            addCellTabla2(tablaDetalles, new Paragraph(persona.apellido, fontTd10), frmtDato)
            addCellTabla2(tablaDetalles, new Paragraph('', fontTd10), frmtDato)
        }

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def imprimirEgresos () {

        println("params " + params)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        println "fechas: '${fechaDesde}','${fechaHasta}'"

        def sql3 = "select * from egresos('${fechaDesde}','${fechaHasta}') order by egrsfcha"
        def cn3 = dbConnectionService.getConnection()
        def egresos = cn3.rows(sql3.toString())

        def totalEgresos = (egresos.egrsvlor.sum() ?: 0)

        def baos = new ByteArrayOutputStream()
        def name = "listaEgresos_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
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
        document.setMargins(50, 30, 30, 28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Detalle de Egresos del ${fechaDesde} al ${fechaHasta}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("Detalle de Egresos del ${fechaDesde} al ${fechaHasta}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(4);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([38,38,12,12]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Proveedor", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Descripción de Egresos", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])
        }

        tablaDetalles = new PdfPTable(4);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([38,38,12,12]))
        tablaDetalles.setSpacingAfter(1f);


        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        egresos.each {egreso ->
            addCellTabla(tablaDetalles, new Paragraph(egreso.prve, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(egreso.egrsdscr, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(egreso.egrsfcha.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(egreso.egrsvlor.toString(), fontTd10), frmtNmro)
        }

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([88, 12]))

        addCellTabla(tablaTotal, new Paragraph("Total: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def imprimirIngresos () {

        println("imprimirIngresos " + params)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        println "fechas: '${fechaDesde}','${fechaHasta}'"

        def sql2 = "select * from aportes('${fechaDesde}','${fechaHasta}') order by prsndpto"
        def cn2 = dbConnectionService.getConnection()
        def ingresos = cn2.rows(sql2.toString())

        def totalIngresos = (ingresos.pagovlor.sum() ?: 0)

        def baos = new ByteArrayOutputStream()
        def name = "listaIngresos_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
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
//        document = new Document(PageSize.A4.rotate());
        document.setMargins(50, 30, 30, 28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Detalle de Ingresos del ${fechaDesde} al ${fechaHasta}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("Detalle de Ingresos del ${fechaDesde} al ${fechaHasta}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(7);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([6,18,8,36,11,8,9]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Dpto.", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Persona", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Ocup.", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Descripción del Ingreso", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Doc.", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])
        }

        tablaDetalles = new PdfPTable(7);
        tablaDetalles.setWidthPercentage(100);
//        tablaDetalles.setWidths(arregloEnteros([10,20,10,30,10,10,10]))
        tablaDetalles.setWidths(arregloEnteros([6,18,8,36,11,8,9]))
        tablaDetalles.setSpacingAfter(1f);

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        ingresos.each {ingreso ->
            addCellTabla(tablaDetalles, new Paragraph(ingreso.prsndpto, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(ingreso.prsn, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph("${ingreso.tpocdscr.toString()[0..5]}..", fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(ingreso.pagodscr.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(ingreso.pagofcha.toString(), fontTd10), frmtNmro)
            addCellTabla(tablaDetalles, new Paragraph(ingreso.pagodcmt ? ingreso.pagodcmt.toString() : '', fontTd10), frmtNmro)
            addCellTabla(tablaDetalles, new Paragraph(ingreso.pagovlor.toString(), fontTd10), frmtNmro)

        }

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([87, 9]))

        addCellTabla(tablaTotal, new Paragraph("Total: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }


    def certificadoExpensas () {

//        println "params " + params

        def persona = Persona.get(params.id)
        def condominio = Condominio.get(session.condominio.id)
        def administrador = Persona.findByCondominioAndCargoLike(condominio, 'Administrador')


        def baos = new ByteArrayOutputStream()
        def name = "certificadoExpensas_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        Font info = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL)
        Font nota = new Font(Font.TIMES_ROMAN, 11, Font.ITALIC)
        Font notaTitulo = new Font(Font.TIMES_ROMAN, 11, Font.BOLD)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle2 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontTh = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtHdr = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtDatoDere = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]


        def fondoTotal = new Color(240, 240, 240);

        def prmsTdNoBorder = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def para = persona.sexo == 'M' ? 'Señor' : 'Señora(ita)'

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(74, 60, 30, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Solicitud");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(condominio?.nombre ?: '', fontTitle));
        addEmptyLine(preface, 1);
        document.add(preface);

        Paragraph preface2 = new Paragraph();
        preface2.setAlignment(Element.ALIGN_CENTER);
        preface2.add(new Paragraph(condominio?.direccion ?: '', fontTitle));
        addEmptyLine(preface2, 1);
        document.add(preface2);

        Paragraph preface3 = new Paragraph();
        preface3.setAlignment(Element.ALIGN_CENTER);
        preface3.add(new Paragraph('QUITO - ECUADOR', fontTitle2));
        addEmptyLine(preface3, 2);
        document.add(preface3);


//        Paragraph c = new Paragraph();
//        c.add(new Paragraph((persona?.nombre ?: '') + ' ' + (persona?.apellido ?: ''), info))
//        document.add(c)
//        Paragraph d = new Paragraph();
//        d.add(new Paragraph((persona?.edificio?.descripcion ?: '') + ', Departamento: ' + (persona?.departamento ?: ''), info))
//        document.add(d)
//        Paragraph p = new Paragraph();
//        p.add(new Paragraph("Presente,", info))
//        addEmptyLine(p, 1);
//        document.add(p)

        Paragraph t1 = new Paragraph();
        t1.setAlignment("Justify");

        t1.add(new Paragraph("Yo, ${(administrador?.apellido?.toUpperCase() ?: '') + " " + (administrador?.nombre?.toUpperCase() ?: '')} portador de la C.I. ${administrador?.ruc ?: ''} , en mi " +
                "calidad de Administrador del ${condominio?.nombre}, luego de haber " +
                "revisado la documentación pertinente, donde consta el nombre de " +
                "${persona?.nombre?.toUpperCase() + " " + persona?.apellido?.toUpperCase()} con número de cédula ${persona?.ruc}, como propietario " +
                "del departamento Nº ${persona?.departamento} y otras propiedades consignadas a este departamento" +
                ", y previo análisis de los documentos:", info))
        addEmptyLine(t1, 1);
        document.add(t1)

        Paragraph t2 = new Paragraph();
        t2.setAlignment("Justify");
        t2.add(new Paragraph( "CERTIFICO NO TENER ADEUDO ALGUNO PENDIENTE DE " +
                "LIQUIDAR EN NINGUNO DE LOS RUBROS DE ESTA DEPENDENCIA " +
                "ADEMÁS LEGALIZO QUE SE ENCUENTRA AL DÍA EN EL PAGO DE " +
                "LAS ALÍCUOTAS ORDINARIAS Y EXTRAORDINARIAS DEL " +
                "CONDOMINIO.", info))
        addEmptyLine(t2, 1);
        document.add(t2)

        Paragraph t3 = new Paragraph();
        t3.setAlignment("Justify");
        t3.add(new Paragraph("Se extiende el presente CERTIFICADO DE EXPENSAS el ${util.fechaConFormato(fecha: new Date(), formato: 'dd MMMM yyyy')} " +
                "en EL DISTRITO METROPOLITANO DE QUITO. ", info))
        addEmptyLine(t3, 1);
        document.add(t3)
        Paragraph a = new Paragraph();
        a.add(new Paragraph("Atentamente,", info))
        addEmptyLine(a, 3);
        document.add(a)
        Paragraph f = new Paragraph();
        f.add(new Paragraph((administrador?.nombre ?: '') + " " + (administrador?.apellido ?: ''), info))
        f.add(new Paragraph("ADMINISTRADOR", info))
        f.add(new Paragraph("Tel: ${administrador?.telefono ?: ''}, dpto. ${administrador?.departamento ?: ''}", info))
        addEmptyLine(f, 1);
        document.add(f)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def imprimirGraficoIng () {

        def baos = new ByteArrayOutputStream()
        def condominio = Condominio.get(session.condominio.id)

        Document document
        document = new Document(PageSize.A4.rotate());
        document.setMargins(74, 60, 30, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()
        document.open();

        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Ingresos vs Egresos");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(condominio?.nombre ?: '', fontTitle));
        addEmptyLine(preface, 2);
        document.add(preface);

        def width2 = 800
        def height = 350
        PdfContentByte contentByte = pdfw.getDirectContent();
        PdfTemplate template2 = contentByte.createTemplate(width2, height);

        Graphics2D graphics2d2 = template2.createGraphics(width2, height, new DefaultFontMapper());

        Rectangle2D rectangle2dSinRecepcion = new Rectangle2D.Double(0, 0, width2, height);


        def cn8 = dbConnectionService.getConnection()
        def valores2 = "select * from ingr_egrs(${params.anio}, ${condominio?.id});"
        def res8 = cn8.rows(valores2.toString())

//        DefaultCategoryDataset line_chart_dataset = new DefaultCategoryDataset();
//
//        line_chart_dataset.addValue( res8[0].egrsvlor.toDouble() , "Egresos" , "Enero" );
//        line_chart_dataset.addValue( res8[1].egrsvlor.toDouble()  , "Egresos" , "Febrero" );
//        line_chart_dataset.addValue( res8[2].egrsvlor.toDouble()  , "Egresos" , "Marzo" );
//        line_chart_dataset.addValue( res8[3].egrsvlor.toDouble()  , "Egresos" , "Abril" );
//        line_chart_dataset.addValue( res8[4].egrsvlor.toDouble() , "Egresos" , "Mayo" );
//        line_chart_dataset.addValue( res8[5].egrsvlor.toDouble() , "Egresos" , "Junio" );
//        line_chart_dataset.addValue( res8[6].egrsvlor.toDouble() , "Egresos" , "Julio" );
//        line_chart_dataset.addValue( res8[7].egrsvlor.toDouble() , "Egresos" , "Agosto" );
//        line_chart_dataset.addValue( res8[8].egrsvlor.toDouble() , "Egresos" , "Septiembre" );
//        line_chart_dataset.addValue( res8[9].egrsvlor.toDouble() , "Egresos" , "Octubre" );
//        line_chart_dataset.addValue( res8[10].egrsvlor.toDouble() , "Egresos" , "Noviembre" );
//        line_chart_dataset.addValue( res8[11].egrsvlor.toDouble() , "Egresos" , "Diciembre" );
//        line_chart_dataset.addValue( res8[0].ingrvlor.toDouble() , "Ingresos" , "Enero" );
//        line_chart_dataset.addValue( res8[1].ingrvlor.toDouble()  , "Ingresos" , "Febrero" );
//        line_chart_dataset.addValue( res8[2].ingrvlor.toDouble()  , "Ingresos" , "Marzo" );
//        line_chart_dataset.addValue( res8[3].ingrvlor.toDouble()  , "Ingresos" , "Abril" );
//        line_chart_dataset.addValue( res8[4].ingrvlor.toDouble() , "Ingresos" , "Mayo" );
//        line_chart_dataset.addValue( res8[5].ingrvlor.toDouble() , "Ingresos" , "Junio" );
//        line_chart_dataset.addValue( res8[6].ingrvlor.toDouble() , "Ingresos" , "Julio" );
//        line_chart_dataset.addValue( res8[7].ingrvlor.toDouble() , "Ingresos" , "Agosto" );
//        line_chart_dataset.addValue( res8[8].ingrvlor.toDouble() , "Ingresos" , "Septiembre" );
//        line_chart_dataset.addValue( res8[9].ingrvlor.toDouble() , "Ingresos" , "Octubre" );
//        line_chart_dataset.addValue( res8[10].ingrvlor.toDouble() , "Ingresos" , "Noviembre" );
//        line_chart_dataset.addValue( res8[11].ingrvlor.toDouble() , "Ingresos" , "Diciembre" );


        XYSeries series = new XYSeries("Egresos");
        series.add(1, res8[0].egrsvlor.toDouble());
        series.add(2, res8[1].egrsvlor.toDouble());
        series.add(3, res8[2].egrsvlor.toDouble());
        series.add(4, res8[3].egrsvlor.toDouble());
        series.add(5, res8[4].egrsvlor.toDouble());
        series.add(6, res8[5].egrsvlor.toDouble());
        series.add(7, res8[6].egrsvlor.toDouble());
        series.add(8, res8[7].egrsvlor.toDouble());
        series.add(9, res8[8].egrsvlor.toDouble());
        series.add(10, res8[9].egrsvlor.toDouble());
        series.add(11, res8[10].egrsvlor.toDouble());
        series.add(12, res8[11].egrsvlor.toDouble());

        XYSeries series2 = new XYSeries("Ingresos");
        series2.add(1, res8[0].ingrvlor.toDouble());
        series2.add(2, res8[1].ingrvlor.toDouble());
        series2.add(3, res8[2].ingrvlor.toDouble());
        series2.add(4, res8[3].ingrvlor.toDouble());
        series2.add(5, res8[4].ingrvlor.toDouble());
        series2.add(6, res8[5].ingrvlor.toDouble());
        series2.add(7, res8[6].ingrvlor.toDouble());
        series2.add(8, res8[7].ingrvlor.toDouble());
        series2.add(9, res8[8].ingrvlor.toDouble());
        series2.add(10, res8[9].ingrvlor.toDouble());
        series2.add(11, res8[10].ingrvlor.toDouble());
        series2.add(12, res8[11].ingrvlor.toDouble());

        XYSeriesCollection dataset = new XYSeriesCollection();
        dataset.addSeries(series);
        dataset.addSeries(series2);

        JFreeChart chartSinRecepcion = ChartFactory.createXYLineChart(
                "Ingresos vs Egresos",
                "Meses",
                "Valores",
                dataset,
                PlotOrientation.VERTICAL,
                true,
                true,
                false
        );

        chartSinRecepcion.getXYPlot().setRenderer(new XYSplineRenderer());
        chartSinRecepcion.draw(graphics2d2, rectangle2dSinRecepcion);

        graphics2d2.dispose();

        def posyGraf3 = 100
        contentByte.addTemplate(template2, 10, posyGraf3);

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + "graficoIngresosEgresos")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }


}
