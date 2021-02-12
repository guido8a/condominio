package utilitarios

import com.lowagie.text.Chapter
import com.lowagie.text.ChapterAutoNumber
import com.lowagie.text.Chunk
import com.lowagie.text.HeaderFooter
import com.lowagie.text.Phrase
import com.lowagie.text.Rectangle
import com.lowagie.text.html.simpleparser.HTMLWorker
import com.lowagie.text.pdf.BaseFont
import com.lowagie.text.pdf.DefaultFontMapper
import com.lowagie.text.pdf.PdfGState
import com.lowagie.text.pdf.PdfTemplate
import condominio.Comprobante
import condominio.Condominio
import condominio.Edificio
import condominio.Ingreso
import condominio.Obra
import condominio.Pago
import condominio.Talonario
import condominio.Texto
import condominio.TipoAporte
import grails.converters.JSON
import groovy.json.JsonBuilder
import jxl.Workbook
import jxl.WorkbookSettings
import jxl.write.Label
import jxl.write.Number
import jxl.write.NumberFormat
import jxl.write.WritableCellFormat
import jxl.write.WritableFont
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import org.apache.poi.hwpf.usermodel.OfficeDrawing
import org.apache.poi.xwpf.usermodel.TextAlignment
import org.jfree.chart.ChartUtilities
import org.jfree.chart.plot.PlotOrientation
import org.jfree.chart.plot.XYPlot
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer
import org.jfree.chart.renderer.xy.XYSplineRenderer
import org.jfree.data.category.DefaultCategoryDataset
import org.jfree.data.xy.XYDataset
import org.jfree.data.xy.XYSeries
import org.jfree.data.xy.XYSeriesCollection
import org.jfree.ui.VerticalAlignment
import org.xhtmlrenderer.pdf.ITextRenderer
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
    def reportesService

    def tx_footer = "Sistema de Administración de Condominios " + " " * 144 + "www.tedein.com.ec/vinedos"

    def index() {
        def cn = dbConnectionService.getConnection()
        def sql = 'select distinct cast (extract(year from pagofcpg) as INT) from pago order by 1;'
        def res = cn.rows(sql.toString())
        def condominio = Condominio.get(session.condominio.id)
        def edificios = Edificio.findAllByCondominio(condominio)
        def fcha = new Date()
        def inicioAnio = fcha - fcha[Calendar.DAY_OF_YEAR] + 1
        inicioAnio.clearTime()

        return [anios: res.date_part, edificios: edificios, condominio: condominio, inicioAnio: inicioAnio]
    }

    def reportes() {

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
        preface.add(new Paragraph("CONJUNTO RESIDENCIAL 'LOS VIÑEDOS'", fontTitulo));
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
        def max = 43
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
        Font fontTh = new Font(Font.TIMES_ROMAN, 11, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);

        def fondoTotal = new Color(245, 243, 245);


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
            tablaHeaderDetalles.setWidths(arregloEnteros([7, 7, 22, 53, 11]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Dpto.", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Cuota", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Nombre", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Detalle", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Pendiente", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 6, pl: 0])
        }

        def printTotales = { params ->
            def tablaTotal = new PdfPTable(2);
            tablaTotal.setWidthPercentage(100);
            tablaTotal.setWidths(arregloEnteros([89, 11]))

            addCellTabla(tablaTotal, new Paragraph("Total: ", fontTh), [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, height: 16, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaTotal, new Paragraph("${numero(params.total, 2)}", fontTh), [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, height: 16, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])

            addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 5, pl: 0])
        }

        def currentPag = 1
        def totalPags = Math.ceil(tamano / max)
        def pagActual = 1

        tablaDetalles = new PdfPTable(5);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([7, 7, 22, 53, 11]))
        tablaDetalles.setSpacingAfter(1f);


        def anterior
        def nuevo
        def total = 0
        def contador = 0
        def ultimo = res.last().prsndpto
        def adicionales = 0
        def u = 0

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]


        res.each { fila ->
            if (actual == 0) {
                printHeaderDetalle()
            }
            if ((actual.toInteger() + adicionales.toInteger()) >= max) {
                max = 43
                printHeaderDetalle()
                actual = 0
                adicionales = 0
            }


            nuevo = fila.prsndpto
            contador++

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
        addCellTabla(tablaDetalles, new Paragraph(alct.toString(), fontTd10), frmtNmro)
        addCellTabla(tablaDetalles, new Paragraph(prsn, fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph(oblg, fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph(sldo.toString(), fontTd10), frmtNmro)
    }

    def poneDatos(tabla, fila) {
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        addCellTabla(tabla, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph(fila.alct.toString(), fontTd10), frmtNmro)
/*
        if(fila.tipo in [2,3]){
            addCellTabla(tabla, new Paragraph(fila.prop, fontTd10), frmtDato)
        } else {
            addCellTabla(tabla, new Paragraph(' ' + fila.prsn, fontTd10), frmtDato)
        }
*/
        if(fila.prop != fila.prsn) {
            if(fila.tipo in [2,3]){
                addCellTabla(tabla, new Paragraph(fila.prop, fontTd10), frmtDato)
            } else {
                addCellTabla(tabla, new Paragraph(fila.prop + ' / ' + fila.prsn, fontTd10), frmtDato)
            }
        } else {
            addCellTabla(tabla, new Paragraph(fila.prsn, fontTd10), frmtDato)
        }
        addCellTabla(tabla, new Paragraph(fila.oblg, fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph(fila.sldo.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(fila.ingrintr.toString(), fontTd10), frmtNmro)
//        addCellTabla(tabla, new Paragraph(fila.ingrintr.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph((fila.sldo + fila.ingrintr).toString(), fontTd10), frmtNmro)
    }

    def poneDatos2(tabla, fila) {
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        addCellTabla(tabla, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph(fila.alct.toString(), fontTd10), frmtNmro)

        addCellTabla(tabla, new Paragraph(fila.prsn, fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph(fila.tpapdscr, fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph(fila.sldo.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(fila.intr.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(fila.total.toString(), fontTd10), frmtNmro)
    }

    def totales(tabla,total,fontTd10,frmtDato,frmtNmro) {
        addCellTabla(tabla, new Paragraph('', fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph('', fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph('', fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph("TOTAL:", fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(total.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(total.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(total.toString(), fontTd10), frmtNmro)
    }


    def totalesDeudas(tabla,total, total2, fontTd10,frmtDato,frmtNmro) {
        addCellTabla(tabla, new Paragraph('', fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph('', fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph('', fontTd10), frmtDato)
        addCellTabla(tabla, new Paragraph("TOTAL:", fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(total.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(total2.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph((total + total2).toString(), fontTd10), frmtNmro)
    }

    def totalesDeudas2(tabla,total, total2, fontTd10,frmtDato,frmtNmro) {

//        addCellTabla(tabla, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
//        addCellTabla(tabla, new Paragraph(fila.alct.toString(), fontTd10), frmtNmro)

//        if(fila.prop != fila.prsn) {
//            if(fila.tipo in [2,3]){
//                addCellTabla(tabla, new Paragraph(fila.prop, fontTd10), frmtDato)
//            } else {
//                addCellTabla(tabla, new Paragraph(fila.prop + ' / ' + fila.prsn, fontTd10), frmtDato)
//            }
//        } else {
//            addCellTabla(tabla, new Paragraph(fila.prsn, fontTd10), frmtDato)
//        }

        addCellTabla(tabla, new Paragraph("", fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph("", fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph("", fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(total.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph(total2.toString(), fontTd10), frmtNmro)
        addCellTabla(tabla, new Paragraph((total + total2).toString(), fontTd10), frmtNmro)
    }



    def fecha_ajax() {

    }

    def solicitud() {

        def pl = new ByteArrayOutputStream()
        byte[] b
        def per = Persona.get(params.id)

        def condominio = Condominio.get(session.condominio.id)
        def sql = "select * from personas(${condominio?.id}) where prsn__id = ${per?.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())
        def fctr = params.vlor.toInteger()


        data.each { persona ->
            if (persona.prsnsldo > (persona.alctvlor * fctr)) {
                pl = solicitudes(persona.prsn__id)
//                pdfs.add(pl.toByteArray())
//                contador++
            }
        }

//        pl = solicitudes(params.id)
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
//        println "solicitudes ... params $id"

        def persona = Persona.get(id)
        def condominio = Condominio.get(session.condominio.id)
        def texto = Texto.findByCondominio(condominio)
        def p1 = texto.parrafoUno.decodeHTML()
        def p2 = texto.parrafoDos.decodeHTML()


        def sql = "select * from personas(${condominio?.id}) where prsn__id= ${persona.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        def sql2 = "select * from pendiente('${new Date().format("yyyy-MM-dd")}', ${persona.edificio.id}) where prsn__id= ${persona.id} order by ingrfcha"
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
        document.setMargins(64, 50, 30, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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
        preface.add(new Paragraph("CONJUNTO RESIDENCIAL 'LOS VIÑEDOS'", fontTitle));
        addEmptyLine(preface, 1);
        document.add(preface);

        def tabla = new PdfPTable(4);
        tabla.setWidthPercentage(90);
        tabla.setWidths(arregloEnteros([55, 15, 15, 15]))

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
        if(persona?.nombre != persona?.nombrePropietario) {
            c.add(new Paragraph((persona?.nombre ?: '') + ' ' + (persona?.apellido ?: '') + ' / ' +
                    (persona?.nombrePropietario ?: '') + ' ' + (persona?.apellidoPropietario ?: ''), info))
        } else {
            c.add(new Paragraph((persona?.nombre ?: '') + ' ' + (persona?.apellido ?: ''), info))
        }
        document.add(c)
        Paragraph d = new Paragraph();
        d.add(new Paragraph((persona?.edificio?.descripcion ?: '') + ', Departamento: ' + (persona?.departamento ?: ''), info))
        document.add(d)
        Paragraph p = new Paragraph();
        p.add(new Paragraph("Presente,", info))
        addEmptyLine(p, 1);
        document.add(p)

        def totalF = 0

        data2.each { pendienteF ->
            if (pendienteF.sldo > 0) {
                totalF += (pendienteF.sldo + pendienteF.ingrintr)
            }
        }

        Paragraph t1 = new Paragraph();
        t1.setAlignment("Justify");
//        t1.add(new Paragraph("Luego de un atento saludo, me permito solicitarle el pago de la deuda que mantiene " +
//                "con el conjunto residencial \"Los Viñedos\", la misma que asciende a un valor de " +
//                "\$ ${totalF}, de acuerdo con el siguiente desglose:", info))
        t1.add(new Paragraph(cambiarHtml(p1), info))
        addEmptyLine(t1, 1);
        document.add(t1)

        def totalIntereses = 0
        def totalFinal = 0

        addCellTabla(tabla, new Paragraph("Concepto", fontTh), frmtHd)
        addCellTabla(tabla, new Paragraph("Valor", fontTh), frmtHd)
        addCellTabla(tabla, new Paragraph("Intereses", fontTh), frmtHd)
        addCellTabla(tabla, new Paragraph("Total", fontTh), frmtHd)
        data2.each { pendiente ->
            if (pendiente.sldo > 0) {
                addCellTabla(tabla, new Paragraph(pendiente.oblg, fontTd10), frmtDato)
                addCellTabla(tabla, new Paragraph(pendiente.sldo.toString(), fontTd10), frmtDatoDere)
                addCellTabla(tabla, new Paragraph(pendiente.ingrintr.toString(), fontTd10), frmtDatoDere)
                addCellTabla(tabla, new Paragraph((pendiente.sldo + pendiente.ingrintr).toString(), fontTd10), frmtDatoDere)
                totalIntereses += pendiente.ingrintr
                totalFinal += (pendiente.sldo + pendiente.ingrintr)
            }
        }
        addCellTabla(tabla, new Paragraph('Total', fontTh), frmtHdr)
        addCellTabla(tabla, new Paragraph("${data[0].prsnsldo}", fontTh), frmtHdr)
        addCellTabla(tabla, new Paragraph("${totalIntereses}", fontTh), frmtHdr)
        addCellTabla(tabla, new Paragraph("${totalFinal}", fontTh), frmtHdr)
        document.add(tabla)

        Paragraph e = new Paragraph();
        e.add(new Paragraph("", info))
        document.add(e)

        Paragraph t2 = new Paragraph();
        t2.setAlignment("Justify");
//        t2.add(new Paragraph( "El cobro de intereses por mora se aplica desde el 1° de abril de 2018, conforme lo determina " +
//                "nuestro Reglamento Interno en el artículo 39 literal 'p', a los valores adeudados hasta el 31 de enero " +
//                "de 2018, así como también a las deudas que superen los 2 meses de alícuotas. Por esta razón me " +
//                "permito insistir en que realice el pago lo antes posible o proponga una forma de pago enviando " +
//                "la misma al correo electrónico vinedos269@gmail.com.", info))


        t2.add(new Paragraph(cambiarHtml(p2), info))
        addEmptyLine(t2, 1);
        document.add(t2)

        Paragraph t3 = new Paragraph();
        t3.setAlignment("Justify");
        t3.add(new Paragraph("Agradezco su oportuna atención a la presente, lo que nos ayudará " +
                "a cubrir los gastos de servicios básicos, mantenimiento, conserje, vigilancia " +
                "y mejora de los bienes comunales. ", info))
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
//        addEmptyLine(f, 1);
        document.add(f)

        Paragraph t4 = new Paragraph();
        t4.setAlignment("Justify");
//        t4.add(new Paragraph("PD: ART. 39 literal p:", notaTitulo))
//        t4.add(new Paragraph("«Por no pago de alícuotas ordinarias y/o extraordinarias, " +
//                "a partir del segundo mes:", nota))
//        t4.add(new Paragraph("ACCIÓN: Recorte de servicios básicos y cobro de interés por mora» 'Suspensión del servicio de AGUA'", nota))
        t4.add(new Paragraph("Nota: No se cobrarán los intereses si el pago se realiza hasta el 1° de Octubre de 2019", nota))
        document.add(t4)

        document.close();
        pdfw.close()
        return baos

    }

    def slctMonitorio(id) {
//        println "solicitudes ... params " + params

        def persona = Persona.get(id)
        def condominio = Condominio.get(session.condominio.id)
        def sql = "select * from personas(${condominio?.id}) where prsn__id= ${persona.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())
        def suma = 0;

        def sql2 = "select prsn__id, oblg, prsn, prsndpto, sldo, mess, ingrintr, sldo + ingrintr total " +
                "from pendiente('${new Date().format("yyyy-MM-dd")}', ${persona.edificio.id}) where prsn__id = " +
                "${persona.id} order by ingrfcha"
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
        def frmtHd = [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtHdr = [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtDatoDere = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmtCol4 = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4]


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
        preface.add(new Paragraph("CONJUNTO RESIDENCIAL 'LOS VIÑEDOS'", fontTitle));
        addEmptyLine(preface, 1);
        document.add(preface);

        def tabla = new PdfPTable(5);
        tabla.setWidthPercentage(90);
        tabla.setWidths(arregloEnteros([40,10,8,10,12]))

        PdfPTable table = new PdfPTable(1);
        table.setWidthPercentage(100);
//        table.addCell(getCell12(" ", PdfPCell.ALIGN_LEFT));
//        table.addCell(getCell12(" ", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell12("Quito, ${util.fechaConFormato(fecha: new Date(), formato: 'dd MMMM yyyy')} ", PdfPCell.ALIGN_RIGHT));
        table.addCell(getCell12(" ", PdfPCell.ALIGN_LEFT));
//        table.addCell(getCell12(" ", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell12(para, PdfPCell.ALIGN_LEFT));
        document.add(table);

        def prsnpara
/*
        if(persona.nombre != persona.nombrePropietario) {
            prsnpara = "${persona.nombrePropietario} ${persona.apellidoPropietario} / ${persona.nombre} ${persona.apellido}"
        } else {
            prsnpara = "${persona.nombre} ${persona.apellido}"
        }
*/
        prsnpara = "${persona.nombrePropietario} ${persona.apellidoPropietario}"
//        println "prsnpara: $prsnpara"

        Paragraph c = new Paragraph();
        c.add(new Paragraph((prsnpara), info))
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

        t1.add(new Paragraph("Luego de un atento saludo, me permito indicarle que conforme a lo acordado en la " +
                "Asamblea General de condóminos realizada el 28 de enero de 2020, se utilizará un proceso legal " +
                "para el cobro de los valores que mantiene pendientes de pago:", info))
        addEmptyLine(t1, 1);
        document.add(t1)

        addCellTabla(tabla, new Paragraph("Concepto", fontTh), frmtHd)
        addCellTabla(tabla, new Paragraph("Valor", fontTh), frmtHd)
        addCellTabla(tabla, new Paragraph("Meses", fontTh), frmtHd)
        addCellTabla(tabla, new Paragraph("Intereses", fontTh), frmtHd)
        addCellTabla(tabla, new Paragraph("Total", fontTh), frmtHd)
        data2.each { pendiente ->
            if (pendiente.sldo > 0) {
                addCellTabla(tabla, new Paragraph(pendiente.oblg, fontTd10), frmtDato)
                addCellTabla(tabla, new Paragraph(pendiente.sldo.toString(), fontTd10), frmtDatoDere)
                addCellTabla(tabla, new Paragraph(pendiente.mess.toString(), fontTd10), frmtDatoDere)
                addCellTabla(tabla, new Paragraph(pendiente.ingrintr.toString(), fontTd10), frmtDatoDere)
                addCellTabla(tabla, new Paragraph(pendiente.total.toString(), fontTd10), frmtDatoDere)
                suma += pendiente.total
            }
        }
        addCellTabla(tabla, new Paragraph('Total', fontTh), frmtCol4)
        addCellTabla(tabla, new Paragraph("${suma}", fontTh), frmtHdr)

        def ttal1 = Math.round(0.1 * suma * 100)/100
        def ttal2 = ttal1 + suma + 25

        addCellTabla(tabla, new Paragraph('Abogado - Gestión de cobro', fontTd10), frmtCol4)
        addCellTabla(tabla, new Paragraph("25.00", fontTd10), frmtDatoDere)
        addCellTabla(tabla, new Paragraph('Abogado - 10% de comisión por el cobro realizado', fontTd10), frmtCol4)
        addCellTabla(tabla, new Paragraph("${ttal1}", fontTd10), frmtDatoDere)
        addCellTabla(tabla, new Paragraph('Gran Total', fontTh), frmtCol4)
        addCellTabla(tabla, new Paragraph("${ttal2}", fontTh), frmtHdr)

        document.add(tabla)

        Paragraph e = new Paragraph();
        e.add(new Paragraph("", info))
        document.add(e)

        Paragraph t2 = new Paragraph();
        t2.setAlignment("Justify");
        t2.add(new Paragraph( "El abogado llevará su trámite mediante un Proceso Monitorio y ofrece realizar el cobro " +
                "de todos sus adeudos en un plazo de 15 días término, añadiendo a su deuda actual el valor de \$25 por gestión " +
                "de cobro y el 10% de comisión, tal como se detalla en el cuadro anterior.", info))
        addEmptyLine(t2, 1);
        document.add(t2)

        Paragraph t3 = new Paragraph();
        t3.setAlignment("Justify");
        t3.add(new Paragraph("Para evitar este proceso legal le invito a acercarse a conversar con la adminstración hasta el " +
                "viernes 20 de febrero de 2020, para acordar un compromiso de pago.", info))
        addEmptyLine(t3, 1);
        document.add(t3)
        Paragraph a = new Paragraph();
        a.add(new Paragraph("Atentamente,", info))
        addEmptyLine(a, 2);
        document.add(a)
        Paragraph f = new Paragraph();
        f.add(new Paragraph("Ing. Guido Ochoa Moreno", info))
        f.add(new Paragraph("ADMINISTRADOR", info))
        f.add(new Paragraph("Cel: 0984916620, dpto. 214", info))
        addEmptyLine(f, 1);
        document.add(f)


/*
        Paragraph t4 = new Paragraph();
        t4.setAlignment("Justify");
        t4.add(new Paragraph("PD: ART. 39 literal p:", notaTitulo))
        t4.add(new Paragraph("«Por no pago de alícuotas ordinarias y/o extraordinarias, " +
                "a partir del segundo mes:", nota))
        t4.add(new Paragraph("ACCIÓN: Recorte de servicios básicos y cobro de interés por mora» 'Suspensión del servicio de AGUA'", nota))
        document.add(t4)
*/

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

        println "sql: $sql"
        data.each { persona ->
            if (persona?.prsnsldo > (persona?.alctvlor?:0 * fctr)) {
                pl = solicitudes(persona?.prsn__id)
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

    def imprimirMonitorio() {
//        println "params imprimirMonitorio: $params"

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
//            println "${persona.prsndpto} -- factor: $fctr, ${persona.alctvlor * fctr}, saldo: ${persona.prsnsldo}"

            if (persona?.prsnsldo > (persona?.alctvlor?:0 * fctr)) {
                pl = slctMonitorio(persona?.prsn__id)
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
        document.setMargins(74, 60, 100, 55)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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

//        Paragraph preface = new Paragraph();
//        addEmptyLine(preface, 1);
//        preface.setAlignment(Element.ALIGN_CENTER);
//        preface.add(new Paragraph("CONJUNTO RESIDENCIAL 'LOS VIÑEDOS'", fontTitle));
//        addEmptyLine(preface, 2);
//        document.add(preface);

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

        //mes anterior
        def cn1 = dbConnectionService.getConnection()
        def mesAnterior = "select count(distinct prsn__id) from pago, ingr, oblg " +
                "where pago.ingr__id = ingr.ingr__id and " +
                "  pagofcpg between '${txfcinAn}' and '${txfcfnAn}' and oblg.oblg__id = ingr.oblg__id and " +
                "tpap__id = 1"
        def res1 = cn1.rows(mesAnterior.toString())

        //valores vencidos
        def cn2 = dbConnectionService.getConnection()
        def vencidos = "select count(distinct prsn__id) from pago, ingr, oblg " +
                "where pago.ingr__id = ingr.ingr__id and pagofcpg between '${txfcin}' and '${txfcfn}' and " +
                "oblg.oblg__id = ingr.oblg__id and tpap__id = 1 and ingrfcha < '${txfcin}'"
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
        def valores = "select * from saldos(${session.condominio.id}, '${txfcin}', '${txfcfn}');"
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

            def posyGraf2 = 570
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

        encabezadoYnumeracion(b, session.condominio.nombre, "Aportes y Gastos",   "aportesGastos_${new Date().format("dd-MM-yyyy")}.pdf")

//        response.setContentType("application/pdf")
//        response.setHeader("Content-disposition", "attachment; filename=" + name)
//        response.setContentLength(b.length)
//        response.getOutputStream().write(b)
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
        def valores = "select * from saldos(${session.condominio.id}, '${txfcin}', '${txfcfn}');"
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

    def ingresosEgresos () {
        println "ingresosEgresos params: $params"

        def valoresCobrar = []
        def totalIngreso = 0
        def totalEgreso = 0
        def totalPorCobrar = 0
        def totalTotal = 0
        def meses = []

        def resGraph = []
        def condominio = Condominio.get(session.condominio.id)

        def fcdsde = new Date().parse("dd-MM-yyyy", params.desde)
        def fchsta = new Date().parse("dd-MM-yyyy", params.hasta)
        def desde = fcdsde.format('yyyy-MM-dd')
        def hasta = fchsta.format('yyyy-MM-dd')

        //grafico ingresos y egresos

        def cn8 = dbConnectionService.getConnection()
        def valores2 = "select sum(pagovlor) vlor, to_char(pagofcha, 'TMMonth')||' '|| substr(pagofcha::varchar, 1, 4) fcha, " +
                "substr(pagofcha::varchar, 6, 2) mes, substr(pagofcha::varchar, 1, 4) anio " +
                "from aportes(1, '${desde}','${hasta}') group by 2,3,4 order by 3"
        def res8 = cn8.rows(valores2.toString())

        def cn9 = dbConnectionService.getConnection()
        def valores3 = "select sum(egrsvlor) vlor, to_char(egrsfcha, 'TMMonth')||' '|| substr(egrsfcha::varchar, 1, 4) fcha, " +
                "substr(egrsfcha::varchar, 6, 2) " +
                "from egresos(1, '${desde}','${hasta}') " +
                "group by 2,3 order by 3"
        def res9 = cn9.rows(valores3.toString())

        res8.each{

            def nuevaFecha

            def a = new Date().parse("dd-MM-yyyy", 01 + "-" + it.mes + "-" + it.anio)
            nuevaFecha = ultimoDiaDelMes(a).format("yyyy-MM-dd")

            def cn7 = dbConnectionService.getConnection()
            def valores4 = "select ingrsldo + sldopgad por_cobrar, ingrsldo + sldofnal total\n" +
                    "from saldos(1, '${nuevaFecha}', '${nuevaFecha}');"
            def res7 = cn7.rows(valores4.toString())
            valoresCobrar.add(res7[0])
            totalPorCobrar += res7[0].por_cobrar.toDouble()
            totalTotal += res7[0].total.toDouble()
            totalIngreso += it.vlor.toDouble()

            meses.add('"' + it.fcha + '"')
        }

        res9.each{
            totalEgreso += it.vlor.toDouble()
        }

        def promedioIngreso = totalIngreso == 0 ? 0 : totalIngreso/res8.size()
        def promedioEgreso = totalEgreso == 0 ? 0 : totalEgreso/res8.size()
        def promedioPorCobrar = totalPorCobrar == 0 ? 0 : totalPorCobrar/res8.size()
        def promedioTotal = totalTotal == 0 ? 0 : totalTotal/res8.size()

        def jsonGraph = new JsonBuilder(resGraph)

        return [jsonGraph : jsonGraph.toString(), ingresos: res8, egresos:res9, desde: fcdsde.format('dd-MMM-yyyy'),
                hasta: fchsta.format('dd-MMM-yyyy'), meses:meses,cobrar: valoresCobrar, promedioIngreso: promedioIngreso,
                promedioEgreso: promedioEgreso, promedioPorCobrar: promedioPorCobrar, promedioTotal: promedioTotal]
    }

    def ingresosEgresosNuevo () {
        println "ingresosEgresosNuevo params: $params"

        def valoresCobrar = []
        def totalIngreso = 0
        def totalEgreso = 0
        def totalPorCobrar = 0
        def totalTotal = 0
        def meses = []

        def condominio = Condominio.get(session.condominio.id)

        def desde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def hasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        def cn8 = dbConnectionService.getConnection()
        def valores2 = "select sum(pagovlor) vlor, to_char(pagofcha, 'TMMonth')||' '||substr(pagofcha::varchar, 1, 4) fcha, " +
                "substr(pagofcha::varchar, 6, 2) mes, substr(pagofcha::varchar, 1, 4) anio " +
                "from aportes(1, '${desde}','${hasta}') group by 2,3,4 order by 4,3"
//        println "sql2: $valores2"
        def res8 = cn8.rows(valores2.toString())

        def cn9 = dbConnectionService.getConnection()
        def valores3 = "select sum(egrsvlor) vlor, to_char(egrsfcha, 'TMMonth')||' '||substr(egrsfcha::varchar, 1, 4) fcha," +
                "substr(egrsfcha::varchar, 6, 2) from egresos(1, '${desde}','${hasta}') group by 2,3 order by 3"
//        println "sql3: $valores3"
        def res9 = cn9.rows(valores3.toString())

        if(res8.size() > res9.size()) {
            res8.pop()
        }
//        println "--> res8: ${res8.size()} > res9: ${res9.size()}"
//        println "res8: ${res8}"
//        println "res9: ${res9}"

        res8.eachWithIndex{ r, k->
            def nuevaFecha

            def a = new Date().parse("dd-MM-yyyy", 01 + "-" + r.mes + "-" + r.anio)
            nuevaFecha = ultimoDiaDelMes(a).format("yyyy-MM-dd")

            def cn7 = dbConnectionService.getConnection()
            def valores4 = "select ingrsldo + sldopgad por_cobrar, ingrsldo + sldofnal total\n" +
                    "from saldos(1, '${nuevaFecha}', '${nuevaFecha}');"
            def res7 = cn7.rows(valores4.toString())

            totalPorCobrar += (res7[0]?.por_cobrar?.toDouble() ?: 0)
            totalTotal += (res7[0]?.total?.toDouble() ?: 0)
            totalIngreso += (r?.vlor?.toDouble() ?: 0)
        }

        res9.each{
            totalEgreso += (it?.vlor?.toDouble() ?: 0)
        }

        def promedioIngreso = totalIngreso == 0 ? 0 : totalIngreso/res8.size()
        def promedioEgreso = totalEgreso == 0 ? 0 : totalEgreso/res8.size()
        def promedioPorCobrar = totalPorCobrar == 0 ? 0 : totalPorCobrar/res8.size()
        def promedioTotal = totalTotal == 0 ? 0 : totalTotal/res8.size()


        return [desde:params.desde, hasta: params.hasta, promedioIngreso: promedioIngreso, promedioEgreso: promedioEgreso, promedioPorCobrar: promedioPorCobrar, promedioTotal: promedioTotal]
    }

    def ultimoDiaDelMes(fecha) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(fecha);

        calendar.add(Calendar.MONTH, 1);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.add(Calendar.DATE, -1);

        return calendar.getTime();
    }

    def ingresoEgresoData_ajax(){
//        println("params id" + params)

        def valoresCobrar = []
        def totalIngreso = 0
        def totalEgreso = 0
        def totalPorCobrar = 0
        def totalTotal = 0
        def meses = []
        def data = [:]

        def resGraph = []
        def condominio = Condominio.get(session.condominio.id)

        def desde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def hasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        //grafico ingresos y egresos

        def cn8 = dbConnectionService.getConnection()
        def valores2 = "select sum(pagovlor) vlor, to_char(pagofcha, 'TMMonth')||' '||substr(pagofcha::varchar, 1, 4) fcha, " +
                "substr(pagofcha::varchar, 6, 2) mes, substr(pagofcha::varchar, 1, 4) anio " +
                "from aportes(1, '${desde}','${hasta}') group by 2,3,4 order by 4, 3"
        def res8 = cn8.rows(valores2.toString())

        def cn9 = dbConnectionService.getConnection()
        def valores3 = "select sum(egrsvlor) vlor, to_char(egrsfcha, 'TMMonth')||' '||substr(egrsfcha::varchar, 1, 4) fcha, " +
                "substr(egrsfcha::varchar, 6, 2) from egresos(1, '${desde}','${hasta}') group by 2,3 order by 3"
        def res9 = cn9.rows(valores3.toString())

//        println("sql " + valores2)
//        println("sql " + valores3)
//        println("res 8 " + res8)
        if(res8.size() > res9.size()) {
            res8.pop()
        }

        res8.eachWithIndex{ r, k->

            def nuevaFecha
            def a = new Date().parse("dd-MM-yyyy", 01 + "-" + r.mes + "-" + r.anio)
            nuevaFecha = ultimoDiaDelMes(a).format("yyyy-MM-dd")

/*
            if(r.mes.toInteger() == 2){
                nuevaFecha = "${r.anio}-${r.mes}- + "28-" + r.mes + "-" +
            }else{
                nuevaFecha = "30-" + r.mes + "-" + r.anio
            }
*/

            def cn7 = dbConnectionService.getConnection()
            def valores4 = "select ingrsldo + sldopgad por_cobrar, ingrsldo + sldofnal total\n" +
                    "from saldos(1, '${nuevaFecha}', '${nuevaFecha}');"
            def res7 = cn7.rows(valores4.toString())
//            println("res7 " + res7)
//            valoresCobrar.add(res7[0])
            totalPorCobrar += (res7[0]?.por_cobrar?.toDouble() ?: 0)
            totalTotal += (res7[0]?.total?.toDouble() ?: 0)
            totalIngreso += (r?.vlor?.toDouble() ?: 0)
//
//            meses.add('"' + it.fcha + '"')


            data.put((r.fcha), (r?.vlor ?: 0) + "_" + (res9[k]?.vlor ?: 0) + "_" + (res7[0]?.por_cobrar ?: 0) + "_" + (res7[0]?.total ?: 0))

        }

//        println("data " + data)

        def respuesta = "${data as JSON}"

        render respuesta
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
        Font fontTh = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);

        def prmsTdNoBorder = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 100, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

//        HeaderFooter footer1 = new HeaderFooter(
//                new Phrase("Manuel Larrea N. 13-45 y Antonio Ante / Teléfonos troncal: (593-2)252 7077 - 254 9222 - 254 9020 - 254 9163 / www.pichincha.gob.ec", new Font(fontTd)), false);
//        footer1.setBorder(Rectangle.NO_BORDER);
//        footer1.setBorder(Rectangle.TOP);
//        footer1.setAlignment(Element.ALIGN_CENTER);
//        document.setFooter(footer1);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Lista de condóminos");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

//        Paragraph preface = new Paragraph();
//        addEmptyLine(preface, 1);
//        preface.setAlignment(Element.ALIGN_CENTER);
//        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
//        preface.add(new Paragraph("LISTA DE CONDÓMINOS", fontTitulo));
//        addEmptyLine(preface, 1);
//        document.add(preface);

        PdfPTable tablaDetalles = null


        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(5);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([7, 15, 20, 20, 34]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Dpto.", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Nombre", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Apellido", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Teléfono", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Firma", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT,
                                                              valign: Element.ALIGN_MIDDLE, colspan: 5, pl: 0])
        }

        tablaDetalles = new PdfPTable(5);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([7, 15, 20, 20, 34]))
        tablaDetalles.setSpacingAfter(1f);


        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]

        def condominio = Condominio.get(session.condominio.id)
        def lista = Persona.findAllByCondominioAndActivoAndExterno(condominio, 1, 0).sort{it.departamento}
        printHeaderDetalle()

        lista.each { persona ->
            addCellTabla2(tablaDetalles, new Paragraph(persona.departamento, fontTd10), frmtDato)
            addCellTabla2(tablaDetalles, new Paragraph(persona.nombre, fontTd10), frmtDato)
            addCellTabla2(tablaDetalles, new Paragraph(persona.apellido, fontTd10), frmtDato)
            addCellTabla2(tablaDetalles, new Paragraph('', fontTd10), frmtDato)
            addCellTabla2(tablaDetalles, new Paragraph('', fontTd10), frmtDato)
        }

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();


        encabezadoYnumeracion(b, session.condominio.nombre,"LISTADO DE CONDÓMINOS", "listadoCondominos_${new Date().format("dd-MM-yyyy")}.pdf")


//        response.setContentType("application/pdf")
//        response.setHeader("Content-disposition", "attachment; filename=" + name)
//        response.setContentLength(b.length)
//        response.getOutputStream().write(b)

    }

    def imprimirEgresos () {

//        println("params " + params)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

//        println "fechas: '${fechaDesde}','${fechaHasta}'"

        def sql3 = "select * from egresos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') order by egrsfcha"
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
        document.setMargins(50, 30, 100, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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

//        Paragraph preface = new Paragraph();
//        addEmptyLine(preface, 1);
//        preface.setAlignment(Element.ALIGN_CENTER);
//        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
//        preface.add(new Paragraph("Detalle de Egresos del ${fechaDesde} al ${fechaHasta}", fontTitulo));
//        addEmptyLine(preface, 1);
//        document.add(preface);

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

        encabezadoYnumeracion(b, session.condominio.nombre,"Detalle de Egresos del ${fechaDesde} al ${fechaHasta}", "detalleEgresos_${new Date().format("dd-MM-yyyy")}.pdf")

//        response.setContentType("application/pdf")
//        response.setHeader("Content-disposition", "attachment; filename=" + name)
//        response.setContentLength(b.length)
//        response.getOutputStream().write(b)

    }

    def pdfEgresos(desde, hasta) {

        println("params " + params)

        def d = desde.format("dd-MM-yyyy")
        def h = hasta.format("dd-MM-yyyy")

        def fechaDesde = new Date().parse("dd-MM-yyyy", d).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", h).format('yyyy-MM-dd')

        println "fechas: '${fechaDesde}','${fechaHasta}'"

        def sql3 = "select * from egresos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') order by egrsfcha"
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
        return baos
    }

    def imprimirIngresos () {

        println("imprimirIngresos " + params)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        println "fechas: '${fechaDesde}','${fechaHasta}'"

        def sql2 = "select * from aportes(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') order by prsndpto"
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
        document.setMargins(50, 30, 100, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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

//        Paragraph preface = new Paragraph();
//        addEmptyLine(preface, 1);
//        preface.setAlignment(Element.ALIGN_CENTER);
//        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
//        preface.add(new Paragraph("Detalle de Ingresos del ${fechaDesde} al ${fechaHasta}", fontTitulo));
//        addEmptyLine(preface, 1);
//        document.add(preface);

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

        encabezadoYnumeracion(b, session.condominio.nombre,"Detalle de Ingresos del ${fechaDesde} al ${fechaHasta}", "detalleIngresos_${new Date().format("dd-MM-yyyy")}.pdf")

//        response.setContentType("application/pdf")
//        response.setHeader("Content-disposition", "attachment; filename=" + name)
//        response.setContentLength(b.length)
//        response.getOutputStream().write(b)
    }

    def rpInforme() {
//        println "rpInforme --> params: $params"
        def desde = new Date().parse("dd-MM-yyyy", params.desde)
        def hasta = new Date().parse("dd-MM-yyyy", params.hasta)

        def titulo = new Color(30, 140, 160)
        Font fontTitulo8 = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL, titulo);

        def rp = new ByteArrayOutputStream()
        def ob = new ByteArrayOutputStream()
        def pd = new ByteArrayOutputStream()
        def eg = new ByteArrayOutputStream()
        byte[] b
        def pdfs = []  /** pdfs a armar en el nuevo documento **/
        def contador = 0
        def name = "informe_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";

        /* 1. Balance */
//        rp = pdfBalance1(desde, hasta)
        rp = pdfBalance(desde, hasta)
        if (rp) {
            pdfs.add(rp.toByteArray())
            contador++
        }
        /* obras */
//        ob = pdfObras(desde,hasta)
        ob = pdfMantenimientoMejoras(desde,hasta)
        if(ob){
            pdfs.add(ob.toByteArray())
            contador++
        }
        /*Pendientes 1*/

        pd = pdfPendientes(hasta,1)
        if(pd){
            pdfs.add(pd.toByteArray())
            contador++
        }

        /*Pendientes 2*/

        pd = pdfPendientes(hasta,2)
        if(pd){
            pdfs.add(pd.toByteArray())
            contador++
        }

        /*egresos*/

        eg = pdfEgresosProveedor(desde,hasta)
        if(eg){
            pdfs.add(eg.toByteArray())
            contador++
        }

        if (contador > 1) {
            def baos = new ByteArrayOutputStream()

            Document document
            document = new Document(PageSize.A4);

            def pdfw = PdfWriter.getInstance(document, baos);

//            println "footer: $tx_footer"
            
            HeaderFooter footer1 = new HeaderFooter( new Phrase(tx_footer, new Font(fontTitulo8)), false);
            footer1.setBorder(Rectangle.NO_BORDER);
            footer1.setBorder(Rectangle.TOP);
            footer1.setAlignment(Element.ALIGN_CENTER);
            document.setFooter(footer1);

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
                    reportesService.numeracion(i,reader.getNumberOfPages()).writeSelectedRows(0, -1, -1, 25, cb)
                }
            }

            document.close();
            b = baos.toByteArray();
        } else {
            b = rp.toByteArray();
        }

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=${name}")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def rpBalance() {
//        println "rpBalance --> params: $params"
        def desde = new Date().parse("dd-MM-yyyy", params.desde)
        def hasta = new Date().parse("dd-MM-yyyy", params.hasta)
        byte[] b
        def name = "balance_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";

        b = pdfBalance(desde, hasta).toByteArray()
//        b = pdfBalance(desde, hasta)

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=${name}")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def balance() {

//        println("balance " + params)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')
        def fechaAntes = new Date().parse("dd-MM-yyyy", params.desde) - 1

//        println "balance fechas: '${fechaDesde}','${fechaHasta}' antes: ${fechaAntes.format('yyyy-MM-dd')}"

        def sql2 = "select sum(pagovlor) vlor, substr(pagofcha::varchar, 1,7) fcha, tpapdscr " +
                "from aportes(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') group by 2,3 order by 2"
//        println "$sql2"

        def cn2 = dbConnectionService.getConnection()
        def ingresos = cn2.rows(sql2.toString())
        def totalIngresos = (ingresos.vlor.sum() ?: 0)

        sql2 = "select sum(egrsvlor) vlor, substr(egrsfcha::varchar, 1,7) fcha, tpgsdscr " +
                "from egresos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') group by 2,3 order by 2"
//        println "egrs: $sql2"
        def egresos = cn2.rows(sql2.toString())

        def totalEgresos = (egresos.vlor.sum() ?: 0)
//        println "tot egresos: $totalEgresos"

        sql2 = "select * from saldos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}')"
        def saldo = cn2.rows(sql2.toString())[0].sldoinic


        def baos = new ByteArrayOutputStream()
        def name = "balance_" + new Date().format("ddMMyyyy_hhmm") + ".pdf"
        def titulo = new Color(40, 140, 180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo)
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo)
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
        document.addTitle("Balance General del ${fechaDesde} al ${fechaHasta}");
        document.addSubject("Generado por el sistema Condominio");
//        document.addKeywords("reporte, condominio, pagos");
//        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("Balance General del ${fechaDesde} al ${fechaHasta}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tblaIngr = null

        def fondo = new Color(240, 248, 250);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtHdR = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def frmtHdb = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtNm = [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def printHeaderDetalle = {


            def tablaHeaderDetalles = new PdfPTable(2);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([8,2]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Saldo inicial - Periodo anterior (hasta: ${fechaAntes.format('yyyy-MM-dd')})", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph(g.formatNumber(number: saldo, format: '##,##0',
                    minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd)
//            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)

//            addCellTabla(tablaHeaderDetalles, new Paragraph("Concepto", fontTh), frmtHd)
//            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
            addCellTabla(tblaIngr, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])
        }

        tblaIngr = new PdfPTable(2);
        tblaIngr.setWidthPercentage(100);
        tblaIngr.setWidths(arregloEnteros([8,2]))
        tblaIngr.setSpacingAfter(1f);

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        addCellTabla(tblaIngr, new Paragraph("Ingresos", fontTh), frmtHd)
        addCellTabla(tblaIngr, new Paragraph(g.formatNumber(number:totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)

        ingresos.each {ingreso ->
            addCellTabla(tblaIngr, new Paragraph("${ingreso.fcha}  Concepto: ${ingreso.tpapdscr}", fontTd10), frmtDato)
            addCellTabla(tblaIngr, new Paragraph(ingreso.vlor.toString(), fontTd10), frmtNm)
        }

        addCellTabla(tblaIngr, new Paragraph("Egresos", fontTh), frmtHd)
        addCellTabla(tblaIngr, new Paragraph(g.formatNumber(number:totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)

        egresos.each {ingreso ->
            addCellTabla(tblaIngr, new Paragraph("${ingreso.fcha}  Concepto: ${ingreso.tpgsdscr}", fontTd10), frmtDato)
            addCellTabla(tblaIngr, new Paragraph(ingreso.vlor.toString(), fontTd10), frmtNm)
        }

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([8, 2]))

        addCellTabla(tablaTotal, new Paragraph("Saldo al ${fechaHasta} (SaldoInicial + Ingresos - Egresos): ", fontTh), frmtNmro)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: totalIngresos - totalEgresos + saldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)
        addCellTabla(tblaIngr, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])

        Paragraph preface2 = new Paragraph();
        addEmptyLine(preface2, 1);
        preface2.setAlignment(Element.ALIGN_CENTER);
        preface2.add(new Paragraph("Resumen de Valores al ${fechaHasta}", fontTitulo));
//        addEmptyLine(preface2, 1);

        def tablaSaldos = new PdfPTable(2);
        tablaSaldos.setWidthPercentage(100);
        tablaSaldos.setWidths(arregloEnteros([8,2]))
        tablaSaldos.setSpacingBefore(5f);

        def cn3 = dbConnectionService.getConnection()
        def vc = cn3.rows(sql2.toString())[0].ingrsldo
        def pp = cn3.rows(sql2.toString())[0].egrssldo
        def rf = cn3.rows(sql2.toString())[0].ingrsldo + cn3.rows(sql2.toString())[0].sldofnal - cn3.rows(sql2.toString())[0].egrssldo

//        addCellTabla(tablaSaldos, new Paragraph("Valores pendientes al ${fechaHasta}", fontTh), frmtHd)
//        addCellTabla(tablaSaldos, new Paragraph('', fontTh), frmtHdR)

        addCellTabla(tablaSaldos, new Paragraph("Saldo al ${fechaHasta}", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number: totalIngresos - totalEgresos + saldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)

        addCellTabla(tablaSaldos, new Paragraph("(+) Valores por cobrar", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number:vc, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)

        addCellTabla(tablaSaldos, new Paragraph("(-) Pagos pendientes", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number:pp, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)


        addCellTabla(tablaSaldos, new Paragraph("Resultado Final al ${fechaHasta}", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number:rf, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)

        document.add(tblaIngr)
        document.add(preface2);
        document.add(tablaSaldos)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def pdfBalance(desde, hasta) {
//    def pdfBalance() {
        println "pdfBalance: $params"

//        def desde = new Date().parse("dd-MM-yyyy", params.desde)
//        def hasta = new Date().parse("dd-MM-yyyy", params.hasta)

        def fechaDesde = desde.format('yyyy-MM-dd')
        def fechaHasta = hasta.format('yyyy-MM-dd')

        def fechaAntes = desde - 1

//        println "balance fechas: '${fechaDesde}','${fechaHasta}' antes: ${fechaAntes.format('yyyy-MM-dd')}"

//        def sql2 = "select sum(pagovlor) vlor, substr(pagofcha::varchar, 1,7) fcha, tpapdscr " +
        def sql2 = "select sum(pagovlor) vlor, to_char(pagofcha, 'TMMonth')||' '|| substr(pagofcha::varchar, 1, 4) fcha, " +
                "substr(pagofcha::varchar, 1, 7), tpapdscr " +
                "from aportes(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') " +
                "group by 2,3,4 order by 3"
//        println "--> $sql2"

        def cn2 = dbConnectionService.getConnection()
        def ingresos = cn2.rows(sql2.toString())
        def totalIngresos = (ingresos.vlor.sum() ?: 0)

        sql2 = "select sum(egrsvlor) vlor, to_char(egrsfcha, 'TMMonth')||' '|| substr(egrsfcha::varchar, 1, 4) fcha, " +
                "substr(egrsfcha::varchar, 1, 7), tpgsdscr " +
                "from egresos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') " +
                "group by 2,3,4 order by 3"
//        println "egrs: $sql2"
        def egresos = cn2.rows(sql2.toString())

        def totalEgresos = (egresos.vlor.sum() ?: 0)
//        println "tot egresos: $totalEgresos"

        sql2 = "select * from saldos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}')"
        def saldo = cn2.rows(sql2.toString())[0].sldoinic


        def baos = new ByteArrayOutputStream()
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
        document.setMargins(50, 30, 100, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Balance General del ${fechaDesde} al ${fechaHasta}");
        document.addSubject("Generado por el sistema Condominio");
//        document.addKeywords("reporte, condominio, pagos");
//        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph()
//        addEmptyLine(preface, 1)
        preface.setAlignment(Element.ALIGN_CENTER)
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16))
        preface.add(new Paragraph("Balance General del ${fechaDesde} al ${fechaHasta}", fontTitulo))
        addEmptyLine(preface, 1)
        document.add(preface)

        PdfPTable tblaIngr = null

        def fondo = new Color(240, 248, 250);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtHdR = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def frmtHdb = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtNm = [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def printHeaderDetalle = {


            def tablaHeaderDetalles = new PdfPTable(2);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([8,2]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Saldo inicial - Periodo anterior (hasta: ${fechaAntes.format('yyyy-MM-dd')})", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph(g.formatNumber(number: saldo, format: '##,##0',
                    minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd)
//            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)

//            addCellTabla(tablaHeaderDetalles, new Paragraph("Concepto", fontTh), frmtHd)
//            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
            addCellTabla(tblaIngr, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])
        }

        tblaIngr = new PdfPTable(2);
        tblaIngr.setWidthPercentage(100);
        tblaIngr.setWidths(arregloEnteros([8,2]))
        tblaIngr.setSpacingAfter(1f);

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        addCellTabla(tblaIngr, new Paragraph("Ingresos", fontTh), frmtHd)
        addCellTabla(tblaIngr, new Paragraph(g.formatNumber(number:totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)

        ingresos.each {ingreso ->
            addCellTabla(tblaIngr, new Paragraph("${ingreso.fcha}: ${ingreso.tpapdscr}", fontTd10), frmtDato)
            addCellTabla(tblaIngr, new Paragraph(ingreso.vlor.toString(), fontTd10), frmtNm)
        }

        addCellTabla(tblaIngr, new Paragraph("Egresos", fontTh), frmtHd)
        addCellTabla(tblaIngr, new Paragraph(g.formatNumber(number:totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)

        egresos.each {ingreso ->
            addCellTabla(tblaIngr, new Paragraph("${ingreso.fcha}: ${ingreso.tpgsdscr}", fontTd10), frmtDato)
            addCellTabla(tblaIngr, new Paragraph(ingreso.vlor.toString(), fontTd10), frmtNm)
        }

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([8, 2]))

        addCellTabla(tablaTotal, new Paragraph("Saldo al ${fechaHasta} (Saldo Inicial + Ingresos - Egresos): ", fontTh), frmtNmro)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: totalIngresos - totalEgresos + saldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)
        addCellTabla(tblaIngr, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])

        Paragraph preface2 = new Paragraph();
        addEmptyLine(preface2, 1);
        preface2.setAlignment(Element.ALIGN_CENTER);
        preface2.add(new Paragraph("Resumen de Valores al ${fechaHasta}", fontTitulo));
//        addEmptyLine(preface2, 1);

        def tablaSaldos = new PdfPTable(2);
        tablaSaldos.setWidthPercentage(100);
        tablaSaldos.setWidths(arregloEnteros([8,2]))
        tablaSaldos.setSpacingBefore(5f);

        def cn3 = dbConnectionService.getConnection()
//        println "sql2: $sql2"
        def sldo = cn3.rows(sql2.toString())[0]
//        println "sql2: $sql2 --> ${sldo}"
        def rstt = sldo.ingrsldo + sldo.sldofnal - sldo.egrssldo + sldo.sldomora

        addCellTabla(tablaSaldos, new Paragraph("Saldo al ${fechaHasta}", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number: totalIngresos - totalEgresos + saldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)

        addCellTabla(tablaSaldos, new Paragraph("(+) Valores por cobrar", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number: sldo.ingrsldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)

        addCellTabla(tablaSaldos, new Paragraph("(-) Pagos pendientes", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number: sldo.egrssldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)

        addCellTabla(tablaSaldos, new Paragraph("(+) Pagos por mora", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number: sldo.sldomora, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)


        addCellTabla(tablaSaldos, new Paragraph("Resultado Final al ${fechaHasta}", fontTh), frmtHdR)
        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number:rstt, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)

        document.add(tblaIngr)
        document.add(preface2);
        document.add(tablaSaldos)
        document.close();
        pdfw.close()
        return baos
//        byte[] b = baos.toByteArray();

//        encabezadoYnumeracion(b, session.condominio.nombre,"Balance General del ${fechaDesde} al ${fechaHasta}", "balanceGeneral_${new Date().format("dd-MM-yyyy")}.pdf")

    }

//        def pdfBalance1(desde, hasta) {
//
//        def fechaDesde = desde.format('yyyy-MM-dd')
//        def fechaHasta = hasta.format('yyyy-MM-dd')
//
//        def fechaAntes = desde - 1
//
//        println "balance fechas: '${fechaDesde}','${fechaHasta}' antes: ${fechaAntes.format('yyyy-MM-dd')}"
//
////        def sql2 = "select sum(pagovlor) vlor, substr(pagofcha::varchar, 1,7) fcha, tpapdscr " +
//        def sql2 = "select sum(pagovlor) vlor, to_char(pagofcha, 'TMMonth')||' '|| substr(pagofcha::varchar, 1, 4) fcha, " +
//                "substr(pagofcha::varchar, 1, 7), tpapdscr " +
//                "from aportes(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') " +
//                "group by 2,3,4 order by 3"
//        println "--> $sql2"
//
//        def cn2 = dbConnectionService.getConnection()
//        def ingresos = cn2.rows(sql2.toString())
//        def totalIngresos = (ingresos.vlor.sum() ?: 0)
//
//        sql2 = "select sum(egrsvlor) vlor, to_char(egrsfcha, 'TMMonth')||' '|| substr(egrsfcha::varchar, 1, 4) fcha, " +
//                "substr(egrsfcha::varchar, 1, 7), tpgsdscr " +
//                "from egresos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') " +
//                "group by 2,3,4 order by 3"
//        println "egrs: $sql2"
//        def egresos = cn2.rows(sql2.toString())
//
//        def totalEgresos = (egresos.vlor.sum() ?: 0)
//        println "tot egresos: $totalEgresos"
//
//        sql2 = "select * from saldos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}')"
//        def saldo = cn2.rows(sql2.toString())[0].sldoinic
//
//
//        def baos = new ByteArrayOutputStream()
//        def titulo = new Color(40, 140, 180)
//        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
//        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
//        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
//        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
//        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
//        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
//        Font fontTd = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
//        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
//        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
//        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);
//
//        def fondoTotal = new Color(240, 240, 240);
//
//
//        Document document
//        document = new Document(PageSize.A4);
////        document = new Document(PageSize.A4.rotate());
//        document.setMargins(50, 30, 60, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
//        def pdfw = PdfWriter.getInstance(document, baos);
//        document.resetHeader()
//        document.resetFooter()
//
//        document.open();
//        PdfContentByte cb = pdfw.getDirectContent();
//        document.addTitle("Balance General del ${fechaDesde} al ${fechaHasta}");
//        document.addSubject("Generado por el sistema Condominio");
////        document.addKeywords("reporte, condominio, pagos");
////        document.addAuthor("Condominio");
//        document.addCreator("Tedein SA");
//
//        Paragraph preface = new Paragraph();
//        addEmptyLine(preface, 1);
//        preface.setAlignment(Element.ALIGN_CENTER);
//        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
//        preface.add(new Paragraph("Balance General del ${fechaDesde} al ${fechaHasta}", fontTitulo));
//        addEmptyLine(preface, 1);
//        document.add(preface);
//
//        PdfPTable tblaIngr = null
//
//        def fondo = new Color(240, 248, 250);
//        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
//        def frmtHdR = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
//        def frmtHdb = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
//        def frmtNm = [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
//        def frmtNmro = [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
//        def printHeaderDetalle = {
//
//
//            def tablaHeaderDetalles = new PdfPTable(2);
//            tablaHeaderDetalles.setWidthPercentage(100);
//            tablaHeaderDetalles.setWidths(arregloEnteros([8,2]))
//
//            addCellTabla(tablaHeaderDetalles, new Paragraph("Saldo inicial - Periodo anterior (hasta: ${fechaAntes.format('yyyy-MM-dd')})", fontTh), frmtHd)
//            addCellTabla(tablaHeaderDetalles, new Paragraph(g.formatNumber(number: saldo, format: '##,##0',
//                    minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd)
////            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
//
////            addCellTabla(tablaHeaderDetalles, new Paragraph("Concepto", fontTh), frmtHd)
////            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
//            addCellTabla(tblaIngr, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])
//        }
//
//        tblaIngr = new PdfPTable(2);
//        tblaIngr.setWidthPercentage(100);
//        tblaIngr.setWidths(arregloEnteros([8,2]))
//        tblaIngr.setSpacingAfter(1f);
//
//        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
//
//        printHeaderDetalle()
//
//        addCellTabla(tblaIngr, new Paragraph("Ingresos", fontTh), frmtHd)
//        addCellTabla(tblaIngr, new Paragraph(g.formatNumber(number:totalIngresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)
//
//        ingresos.each {ingreso ->
//            addCellTabla(tblaIngr, new Paragraph("${ingreso.fcha}: ${ingreso.tpapdscr}", fontTd10), frmtDato)
//            addCellTabla(tblaIngr, new Paragraph(ingreso.vlor.toString(), fontTd10), frmtNm)
//        }
//
//        addCellTabla(tblaIngr, new Paragraph("Egresos", fontTh), frmtHd)
//        addCellTabla(tblaIngr, new Paragraph(g.formatNumber(number:totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)
//
//        egresos.each {ingreso ->
//            addCellTabla(tblaIngr, new Paragraph("${ingreso.fcha}: ${ingreso.tpgsdscr}", fontTd10), frmtDato)
//            addCellTabla(tblaIngr, new Paragraph(ingreso.vlor.toString(), fontTd10), frmtNm)
//        }
//
//        def tablaTotal = new PdfPTable(2);
//        tablaTotal.setWidthPercentage(100);
//        tablaTotal.setWidths(arregloEnteros([8, 2]))
//
//        addCellTabla(tablaTotal, new Paragraph("Saldo al ${fechaHasta} (Saldo Inicial + Ingresos - Egresos): ", fontTh), frmtNmro)
//        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: totalIngresos - totalEgresos + saldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtNmro)
//        addCellTabla(tblaIngr, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])
//
//        Paragraph preface2 = new Paragraph();
//        addEmptyLine(preface2, 1);
//        preface2.setAlignment(Element.ALIGN_CENTER);
//        preface2.add(new Paragraph("Resumen de Valores al ${fechaHasta}", fontTitulo));
////        addEmptyLine(preface2, 1);
//
//        def tablaSaldos = new PdfPTable(2);
//        tablaSaldos.setWidthPercentage(100);
//        tablaSaldos.setWidths(arregloEnteros([8,2]))
//        tablaSaldos.setSpacingBefore(5f);
//
//        def cn3 = dbConnectionService.getConnection()
//        def vc = cn3.rows(sql2.toString())[0].ingrsldo
//        def pp = cn3.rows(sql2.toString())[0].egrssldo
//        def rf = cn3.rows(sql2.toString())[0].ingrsldo + cn3.rows(sql2.toString())[0].sldofnal - cn3.rows(sql2.toString())[0].egrssldo
//
////        addCellTabla(tablaSaldos, new Paragraph("Valores pendientes al ${fechaHasta}", fontTh), frmtHd)
////        addCellTabla(tablaSaldos, new Paragraph('', fontTh), frmtHdR)
//
//        addCellTabla(tablaSaldos, new Paragraph("Saldo al ${fechaHasta}", fontTh), frmtHdR)
//        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number: totalIngresos - totalEgresos + saldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)
//
//        addCellTabla(tablaSaldos, new Paragraph("(+) Valores por cobrar", fontTh), frmtHdR)
//        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number:vc, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)
//
//        addCellTabla(tablaSaldos, new Paragraph("(-) Pagos pendientes", fontTh), frmtHdR)
//        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number:pp, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)
//
//
//        addCellTabla(tablaSaldos, new Paragraph("Resultado Final al ${fechaHasta}", fontTh), frmtHdR)
//        addCellTabla(tablaSaldos, new Paragraph(g.formatNumber(number:rf, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHdR)
//
//        document.add(tblaIngr)
//        document.add(preface2);
//        document.add(tablaSaldos)
//        document.close();
//        pdfw.close()
//        return baos
//    }


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
        Font fontTitle3 = new Font(Font.TIMES_ROMAN, 18, Font.NORMAL);
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
        preface.add(new Paragraph(condominio?.nombre?.toUpperCase() ?: '', fontTitle3));
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
        f.add(new Paragraph("CI: ${administrador?.ruc ?: ''}", info))
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
        document.setMargins(40, 40, 40, 30)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()
        document.open();

        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Ingresos y Egresos");
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
                "Ingresos y Egresos",
                "Meses",
                "Valores",
                dataset,
                PlotOrientation.VERTICAL,
                true,
                true,
                false
        );
        XYPlot ColorConfigurator5 = (XYPlot) chartSinRecepcion.getXYPlot()
        ColorConfigurator5.setBackgroundAlpha(0f)
        ColorConfigurator5.setDomainGridlinePaint(Color.BLACK)
        ColorConfigurator5.setRangeGridlinePaint(Color.BLACK)

        chartSinRecepcion.getXYPlot().setRenderer(new XYSplineRenderer());
        chartSinRecepcion.draw(graphics2d2, rectangle2dSinRecepcion);

        graphics2d2.dispose();

        def posyGraf3 =100
        contentByte.addTemplate(template2, 0, posyGraf3);

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();

//        encabezadoYnumeracionRotado(b, session.condominio.nombre, "Ingresos y Egresos", "ingresosEgresos_${new Date().format("dd-MM-yyyy")}.pdf")
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + "graficoIngresosEgresos")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def encabezadoYnumeracionRotado (f, tituloReporte, subtitulo, nombreReporte) {

        def titulo = new Color(30, 140, 160)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font fontTitulo8 = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL, titulo);

        def baos = new ByteArrayOutputStream()

        Document document
        document = new Document(PageSize.A4.rotate());

        def pdfw = PdfWriter.getInstance(document, baos);

        HeaderFooter footer1 = new HeaderFooter(
                new Phrase("Sistema de Administración de Condominios                                                          " +
                        "           www.tedein.com.ec", new Font(fontTitulo8)), false);
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
//            if(nombreReporte == 'pagosPendientes') {
//                reportesService.numeracion3(i,reader.getNumberOfPages()).writeSelectedRows(0, -1, -1, 25, cb)
//            } else {
            reportesService.numeracion(i,reader.getNumberOfPages()).writeSelectedRows(0, -1, -1, 25, cb)
//            }
            document.add(en)
        }

        document.close();
        byte[] b = baos.toByteArray();

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + nombreReporte)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def reporteObras (){


        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde)
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta)

        def condominio = Condominio.get(session.condominio.id)
        def personas = Persona.findAllByCondominio(condominio)

        def obras = Obra.findAllByPersonaInListAndFechaBetween(personas, fechaDesde, fechaHasta, [sort: 'fecha'])

        def baos = new ByteArrayOutputStream()
        def name = "listaObras" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
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
        document.addTitle("Detalle de Obras del ${fechaDesde.format("dd-MM-yyyyy")} al ${fechaHasta.format("dd-MM-yyyy")}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

//        Paragraph preface = new Paragraph();
//        addEmptyLine(preface, 1);
//        preface.setAlignment(Element.ALIGN_CENTER);
//        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
//        preface.add(new Paragraph("Detalle de Obras del ${fechaDesde.format("dd-MM-yyyyy")} al ${fechaHasta.format("dd-MM-yyyyy")}", fontTitulo));
//        addEmptyLine(preface, 1);
//        document.add(preface);

        PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(6);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([30,20,10,10,10,8]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Descripción", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Proveedor", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha Solicitud", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha Inicio", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha Fin", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor Aprox.", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])
        }

        tablaDetalles = new PdfPTable(6);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([30,20,10,10,10,8]))
        tablaDetalles.setSpacingAfter(1f);

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        def total = 0
        obras.each {obra ->
            addCellTabla(tablaDetalles, new Paragraph(obra?.descripcion, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph("${obra?.proveedor?.nombre?:""} ${obra?.proveedor?.apellido?:""}", fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(obra?.fecha?.format("dd-MM-yyyy"), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(obra?.fechaInicio?.format("dd-MM-yyyy"), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(obra?.fechaFin?.format("dd-MM-yyyy"), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(obra?.presupuesto.toString(), fontTd10), frmtNmro)
            total += obra?.fechaFin? obra?.presupuesto : 0
        }

        addCellTabla(tablaDetalles, new Paragraph("Obras realizadas", fontTh), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph("", fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph("", fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph("", fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph("Total", fontTh), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph(total.toString(), fontTh), frmtNmro)

        document.add(tablaDetalles)
        document.close();
        pdfw.close()

        byte[] b = baos.toByteArray();

        encabezadoYnumeracion(b, session.condominio.nombre,"Detalle de Obras del ${fechaDesde.format("dd-MM-yyyy")} al ${fechaHasta.format("dd-MM-yyyy")}", "detalleObras_${new Date().format("dd-MM-yyyy")}.pdf")
    }

    def pdfObras (desde, hasta){

        def f = desde.format("dd-MM-yyyy")
        def  h = hasta.format("dd-MM-yyyy")

        def fechaDesde = new Date().parse("dd-MM-yyyy", f)
        def fechaHasta = new Date().parse("dd-MM-yyyy", h)

        def condominio = Condominio.get(session.condominio.id)
        def personas = Persona.findAllByCondominio(condominio)

        def obras = Obra.findAllByPersonaInListAndFechaBetween(personas, fechaDesde, fechaHasta, [sort: 'fecha'])

        println("obras " + obras)

        def baos = new ByteArrayOutputStream()
        def name = "listaObras" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
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
        document.addTitle("Detalle de Obras del ${fechaDesde.format("dd-MM-yyyy")} al ${fechaHasta.format("dd-MM-yyyy")}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("Detalle de Obras del ${fechaDesde.format("dd-MM-yyyy")} al ${fechaHasta.format("dd-MM-yyyy")}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(6);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([30,20,10,10,10,8]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Descripción", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Proveedor", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha Solicitud", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha Inicio", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha Fin", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor Aprox.", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])
        }

        tablaDetalles = new PdfPTable(6);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([30,20,10,10,10,8]))
        tablaDetalles.setSpacingAfter(1f);

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        def total = 0
        obras.each {obra ->
            addCellTabla(tablaDetalles, new Paragraph(obra?.descripcion, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph("${obra?.proveedor?.nombre?:""} ${obra?.proveedor?.apellido?:""}", fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(obra?.fecha?.format("dd-MM-yyyy"), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(obra?.fechaInicio?.format("dd-MM-yyyy"), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(obra?.fechaFin?.format("dd-MM-yyyy"), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(obra?.presupuesto.toString(), fontTd10), frmtNmro)
            total += obra?.fechaFin? obra?.presupuesto : 0
        }

        addCellTabla(tablaDetalles, new Paragraph("Obras realizadas", fontTh), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph("", fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph("", fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph("", fontTd10), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph("Total", fontTh), frmtDato)
        addCellTabla(tablaDetalles, new Paragraph(total.toString(), fontTh), frmtNmro)

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        return baos

    }



    def pagosPendientes4() {

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from pendiente('${fecha.format('yyy-MM-dd')}', '${params.torre}')"
//        println "sql: $sql"
        def res = cn.rows(sql.toString())
        def tamano = res.size()
        def max = 43
        def malox = 46
        def actual = 0

        def baos = new ByteArrayOutputStream()
        def titulo = new Color(30, 140, 160)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 11, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontTd11 = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        def fondo = new Color(240, 248, 250);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        def fondoTotal = new Color(245, 243, 245);

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 100, 55)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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

        def currentPag = 1
        def totalPags = Math.ceil(tamano / max)
        def pagActual = 1
        def anterior
        def nuevo
        def total = 0
        def total2 = 0
        def total3 = 0
        def contador = 0
        def ultimo = (res ? res.last().prsndpto : 0)
        def adicionales = 0
        def u = 0

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(100);
        table.setWidths(arregloEnteros([5, 8, 45, 20, 10, 8, 10]))
        addCellTabla(table, new Paragraph("Dp.", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Cuota", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Nombre", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Detalle", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Saldo", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Interés", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Total", fontTh), frmtHd)
        table.setHeaderRows(1);

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([89, 11]))

        if(res){
            res.each { fila ->

                if ((actual.toInteger() + adicionales.toInteger()) >= max) {
                    max = 43
                    actual = 0
                    adicionales = 0
                }

                nuevo = fila.prsndpto
                contador++

                if (anterior == nuevo) {
                    if (nuevo == ultimo && (tamano.toInteger()) == contador) {
                        poneDatos(table, fila)
                        total += fila.sldo
                        total2 += fila.ingrintr
                        anterior = fila.prsndpto
                        totalesDeudas(table, total, total2, fontTd11, frmtDato, frmtNmro)
                        adicionales++
                    } else {
                        poneDatos(table, fila)
                        total += fila.sldo
                        total2 += fila.ingrintr
                        anterior = fila.prsndpto
                    }
                } else {
                    if (contador == 1) {
                        poneDatos(table, fila)
                        total += fila.sldo
                        total2 += fila.ingrintr
                        anterior = fila.prsndpto
                    } else {
                        if (tamano.toInteger() == contador) {
                            totalesDeudas(table, total, total2, fontTd11, frmtDato, frmtNmro)
                            poneDatos(table, fila)
                            total = fila.sldo
                            total2 = fila.ingrintr
                            anterior = fila.prsndpto
                            totalesDeudas(table, fila.sldo, total2, fontTd11, frmtDato, frmtNmro)
                            adicionales++
                        } else {
                            totalesDeudas(table, total, total2, fontTd11, frmtDato, frmtNmro)
                            poneDatos(table, fila)
                            total = fila.sldo
                            total2 = fila.ingrintr
                            anterior = fila.prsndpto
                            adicionales++
                        }
                    }
                }

                actual++
                u = (actual.toInteger() + adicionales.toInteger())

                if (actual <= max) {
                    pagActual = 1
                } else {
                    pagActual = Math.ceil(actual / max).toInteger()
                }
            }
        } else {
            println "...1"
            Paragraph preface = new Paragraph();
            addEmptyLine(preface, 1);
            preface.setAlignment(Element.ALIGN_CENTER);
            preface.add(new Paragraph("-- sin datos --", fontTitulo16));
            addEmptyLine(preface, 1);
            document.add(preface);

            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtNmro)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtNmro)
        }


        document.add(table);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();

        encabezadoYnumeracion(b, session.condominio.nombre,"Deudas pendientes al ${util.fechaConFormato(fecha: fecha, formato: 'dd MMMM yyyy')}",
                "pagosPendientes_${new Date().format("dd-MM-yyyy")}.pdf")
    }


    def pdfPendientes(hasta,torre) {

        def h = hasta.format("dd-MM-yyyy")
        def fecha = new Date().parse("dd-MM-yyyy", h)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from pendiente('${fecha.format('yyyy-MM-dd')}', '${torre}')"
//        println "sql: $sql"
        def res = cn.rows(sql.toString())
        def tamano = res.size()
        def max = 43
        def malox = 46
        def actual = 0

        def baos = new ByteArrayOutputStream()
        def titulo = new Color(30, 140, 160)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 11, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontTd11 = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        def fondo = new Color(240, 248, 250);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        def fondoTotal = new Color(245, 243, 245);

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 60, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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

        Paragraph prefaceT = new Paragraph();
        addEmptyLine(prefaceT, 1);
        prefaceT.setAlignment(Element.ALIGN_CENTER);
        prefaceT.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        prefaceT.add(new Paragraph("Deudas pendientes al ${fecha.format("dd-MM-yyyy")} - Torre ${torre}" , fontTitulo));
        addEmptyLine(prefaceT, 1);
        document.add(prefaceT);

        def currentPag = 1
        def totalPags = Math.ceil(tamano / max)
        def pagActual = 1
        def anterior
        def nuevo
        def total = 0
        def total2 = 0
        def total3 = 0
        def contador = 0
        def ultimo = (res ? res.last().prsndpto : 0)
        def adicionales = 0
        def u = 0

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(100);
        table.setWidths(arregloEnteros([5, 8, 45, 20, 10, 8, 10]))
        addCellTabla(table, new Paragraph("Dp.", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Cuota", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Nombre", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Detalle", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Saldo", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Interés", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Total", fontTh), frmtHd)
        table.setHeaderRows(1);

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([89, 11]))


        if(res){
            res.each { fila ->

                if ((actual.toInteger() + adicionales.toInteger()) >= max) {
                    max = 43
                    actual = 0
                    adicionales = 0
                }

                nuevo = fila.prsndpto
                contador++

                if (anterior == nuevo) {
                    if (nuevo == ultimo && (tamano.toInteger()) == contador) {
                        poneDatos(table, fila)
                        total += fila.sldo
                        total2 += fila.ingrintr
                        anterior = fila.prsndpto
                        totalesDeudas(table, total, total2, fontTd11, frmtDato, frmtNmro)
                        adicionales++
                    } else {
                        poneDatos(table, fila)
                        total += fila.sldo
                        total2 += fila.ingrintr
                        anterior = fila.prsndpto
                    }
                } else {
                    if (contador == 1) {
                        poneDatos(table, fila)
                        total += fila.sldo
                        total2 += fila.ingrintr
                        anterior = fila.prsndpto
                    } else {
                        if (tamano.toInteger() == contador) {
                            totalesDeudas(table, total, total2, fontTd11, frmtDato, frmtNmro)
                            poneDatos(table, fila)
                            total = fila.sldo
                            total2 = fila.ingrintr
                            anterior = fila.prsndpto
                            totalesDeudas(table, fila.sldo, total2, fontTd11, frmtDato, frmtNmro)
                            adicionales++
                        } else {
                            totalesDeudas(table, total, total2, fontTd11, frmtDato, frmtNmro)
                            poneDatos(table, fila)
                            total = fila.sldo
                            total2 = fila.ingrintr
                            anterior = fila.prsndpto
                            adicionales++
                        }
                    }
                }

                actual++
                u = (actual.toInteger() + adicionales.toInteger())

                if (actual <= max) {
                    pagActual = 1
                } else {
                    pagActual = Math.ceil(actual / max).toInteger()
                }
            }
        } else {
            println "...1"
            Paragraph preface = new Paragraph();
            addEmptyLine(preface, 1);
            preface.setAlignment(Element.ALIGN_CENTER);
            preface.add(new Paragraph("-- sin datos --", fontTitulo16));
            addEmptyLine(preface, 1);
            document.add(preface);

            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtNmro)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtNmro)
        }


        document.add(table);
        document.close();
        pdfw.close()
//        byte[] b = baos.toByteArray();
//
//
//        encabezadoYnumeracion(b, session.condominio.nombre,
//                "Deudas pendientes al ${util.fechaConFormato(fecha: fecha, formato: 'dd MMMM yyyy')}",
//                "pagosPendientes.pdf")

        return baos

    }

    def pagosPendientesTotales() {

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)

        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def sql = "select * from pendiente('${fecha.format('yyyy-MM-dd')}', '${params.torre}')"
//        println "sql: $sql"
        def res = cn.rows(sql.toString())

        def sql2 = "select prsndpto, alct, prsn, tpapdscr, sum(sldo) sldo, sum(ingrintr) intr, sum(sldo) + " +
                "sum(ingrintr) total from pendiente('${fecha.format('yyy-MM-dd')}', '${params.torre}'), tpap " +
                "where tpap__id = tipo and sldo > 0 group by prsndpto, alct, prsn, tpapdscr order by prsndpto, tpapdscr"
        def res1 = cn2.rows(sql2.toString())
        println "sql: $sql2"

        def tamano = res1.size()
        def max = 43
        def malox = 46
        def actual = 0

        def baos = new ByteArrayOutputStream()
        def titulo = new Color(30, 140, 160)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 11, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd11 = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def fondo = new Color(240, 248, 250);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtHd4c = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE, colspan: 4]
        def frmtHd1 = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def fondoTotal = new Color(245, 243, 245);

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 100, 55)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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

        def currentPag = 1
        def totalPags = Math.ceil(tamano / max)
        def pagActual = 1
        def anterior = ''
        def nuevo
        def total = 0
        def total2 = 0
        def total3 = 0
        def contador = 0
        def ultimo = (res ? res.last().prsndpto : 0)
        def adicionales = 0
        def u = 0

        def pActual
        def pAnterior

        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(100);
        table.setWidths(arregloEnteros([5, 8, 40, 25, 10, 8, 10]))
        addCellTabla(table, new Paragraph("Dp.", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Cuota", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Nombre", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Concepto", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Saldo", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Interés", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Total", fontTh), frmtHd)
        table.setHeaderRows(1);

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([89, 11]))

        def totales = 0
        def totalPersona = 0
        def tam = res1.size() - 1
        def totalSaldo = 0
        def totalInteres = 0
        def ts = 0
        def ti = 0

        if(res1){
            res1.eachWithIndex { fila,k ->

                pActual = fila.prsndpto

                if ((actual.toInteger() + adicionales.toInteger()) >= max) {
                    max = 43
                    actual = 0
                    adicionales = 0
                }

                if(k == 0){
                    totalPersona += fila.total
                    totalSaldo += fila.sldo
                    totalInteres += fila.intr
                }else{
                    if(pActual == pAnterior){
                        totalPersona += fila.total
                        totalSaldo += fila.sldo
                        totalInteres += fila.intr
                    }else{
                        addCellTabla(table, new Paragraph("Total", fontTh), frmtHd4c)
                        addCellTabla(table, new Paragraph(g.formatNumber(number:totalSaldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
                        addCellTabla(table, new Paragraph(g.formatNumber(number:totalInteres, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
                        addCellTabla(table, new Paragraph(g.formatNumber(number:totalPersona, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)

                        totalPersona = fila.total
                        totalSaldo = fila.sldo
                        totalInteres = fila.intr
                    }
                }

                addCellTabla(table, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
                addCellTabla(table, new Paragraph(fila.alct.toString(), fontTd10), frmtNmro)
                addCellTabla(table, new Paragraph(fila.prsn, fontTd10), frmtDato)
                addCellTabla(table, new Paragraph(fila.tpapdscr, fontTd10), frmtDato)
                addCellTabla(table, new Paragraph(fila.sldo.toString(), fontTd10), frmtNmro)
                addCellTabla(table, new Paragraph(fila.intr.toString(), fontTd10), frmtNmro)
                addCellTabla(table, new Paragraph(fila.total.toString(), fontTd10), frmtNmro)

                total += (fila.total ? fila.total.toDouble() : 0)
                ts += (fila.sldo ? fila.sldo.toDouble() : 0)
                ti += (fila.intr ? fila.intr.toDouble() : 0)

                pAnterior = fila.prsndpto

                if(k == tam.toInteger()){
                    addCellTabla(table, new Paragraph("Total", fontTh), frmtHd4c)
                    addCellTabla(table, new Paragraph(g.formatNumber(number:totalSaldo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
                    addCellTabla(table, new Paragraph(g.formatNumber(number:totalInteres, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
                    addCellTabla(table, new Paragraph(g.formatNumber(number:totalPersona, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
                }

                contador++

                if (actual <= max) {
                    pagActual = 1
                } else {
                    pagActual = Math.ceil(actual / max).toInteger()
                }
            }
        } else {
            println "...1"
            Paragraph preface = new Paragraph();
            addEmptyLine(preface, 1);
            preface.setAlignment(Element.ALIGN_CENTER);
            preface.add(new Paragraph("-- sin datos --", fontTitulo16));
            addEmptyLine(preface, 1);
            document.add(preface);

            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtNmro)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
            addCellTabla(table, new Paragraph(" ", fontTd10), frmtDato)
        }

        addCellTabla(table, new Paragraph("GRAN TOTAL", fontTh), frmtHd4c)
        addCellTabla(table, new Paragraph(g.formatNumber(number:ts, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
        addCellTabla(table, new Paragraph(g.formatNumber(number:ti, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
        addCellTabla(table, new Paragraph(g.formatNumber(number:total, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)

        document.add(table);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();

                encabezadoYnumeracion(b, session.condominio.nombre, "Deudas pendientes totales al ${util.fechaConFormato(fecha: fecha, formato: 'dd MMMM yyyy')}",
                "pagosPendientesTotales_${new Date().format("dd-MM-yyyy")}.pdf")

    }

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
/*
        HeaderFooter footer1 = new HeaderFooter(
        new Phrase("Sistema de Administración de Condominios " + " " * 144 +
                "www.tedein.com.ec/vinedos", new Font(fontTitulo8)), false);
*/
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
//            if(nombreReporte == 'pagosPendientes') {
//                reportesService.numeracion3(i,reader.getNumberOfPages()).writeSelectedRows(0, -1, -1, 25, cb)
//            } else {
                reportesService.numeracion(i,reader.getNumberOfPages()).writeSelectedRows(0, -1, -1, 25, cb)
//            }
            document.add(en)
        }

        document.close();
        byte[] b = baos.toByteArray();

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + nombreReporte)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

//    public static PdfPTable getHeaderTable(int x, int y) {
//        PdfPTable table = new PdfPTable(2);
//        table.setTotalWidth(327);
//        table.setLockedWidth(true);
//        table.getDefaultCell().setFixedHeight(20);
//        table.getDefaultCell().setBorder(Rectangle.NO_BORDER);
//        table.addCell("");
//        table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
//        table.addCell(String.format("Página %d de %d", x, y));
//        return table;
//    }

    def expensas () {
        def persona = Persona.get(params.id)
        def condominio = Condominio.get(session.condominio.id)
//        def admn = Persona.get(condominio.administrador)
        def admn = Persona.get(1)
        def texto = """
      Yo, <b>${admn.nombrePropietario} ${admn.apellidoPropietario}</b> portador de la C.I. ${admn.ruc} en mi calidad
      de Administrador del
      <b>Conjunto Residencial “LOS VIÑEDOS”</b>, luego de haber revisado la documentación pertinente, donde
      constan los nombres de las siguientes personas <b>${persona.nombrePropietario} ${persona.apellidoPropietario} con número de cédula 0104124029,
      JOHANNA VANESSA FLORES MOLINA con número de cédula 0104368071</b>,  ubicado en la Torre  1,
      departamento Nº 134, parqueadero N° 25, secadero N° 12 y bodega N° 34, previo análisis de los documentos:
      <br><br>CERTIFICO NO TENER ADEUDO ALGUNO PENDIENTE DE LIQUIDAR EN NINGUNO DE LOS RUBROS DE ESTA DEPENDENCIA
      ADEMÁS LEGALIZO QUE SE ENCUENTRA AL DÍA EN EL PAGO DE LAS ALÍCUOTAS ORDINARIAS Y EXTRAORDINARIAS
      DEL CONDOMINIO.
      <br><br>Se extiende el presente CERTIFICADO DE EXPENSAS el 11 del mes de Febrero del año 2020 en
      EL DISTRITO METROPOLITANO DE QUITO.
      <br><br>Atentamente<br><br>Ing. Guido E. Ochoa Moreno<br>ADMINISTRADOR<br>CI: 0601983869
      """
        return[persona: persona, texto: texto]
    }

    def guardarTexto_ajax(){
        def persona = Persona.get(params.persona)
        persona.expensa = params.editor

        if(persona.save(flush: true)){
            render "ok"
        }else{
            render "no"
        }
    }

    def expensas_pdf () {
//        println("params exp" + params)

        def persona = Persona.get(params.id)


//        def titulo = new Color(30, 140, 160)
//        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
//        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
//
//        def baos = new ByteArrayOutputStream()
//        Document document
//        document = new Document(PageSize.A4);
//
//        def pdfw = PdfWriter.getInstance(document, baos);
//        document.open();
//
//        PdfContentByte cb = pdfw.getDirectContent();
//
//        document.add((new Paragraph(persona.expensa, fontTitulo)))
//
//        document.close();
//        pdfw.close()

        def baos = crearPdfExpensas(persona)

        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + "certificadoExpensas")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

        return

    }

    def crearPdfExpensas (persona) {

        def text = (persona.expensa ?: '')

        text = text.replaceAll("&lt;", "*lt*")
        text = text.replaceAll("&gt;", "*gt*")
        text = text.replaceAll("&amp;", "*amp*")
        text = text.replaceAll("<p>&nbsp;</p>", "<br/>")
        text = text.replaceAll("&nbsp;", " ")

        text = text.decodeHTML()

        text = text.replaceAll("\\*lt\\*", "&lt;")
        text = text.replaceAll("\\*gt\\*", "&gt;")
        text = text.replaceAll("\\*amp\\*", "&amp;")
        text = text.replaceAll("\\*nbsp\\*", " ")
        text = text.replaceAll(/<tr>\s*<\/tr>/, / /)


        def nombre = "${persona.condominio.nombre.toUpperCase()}"
        def direccion = "${persona.condominio.direccion.toUpperCase()}"
        def q =       "QUITO - ECUADOR "
        def titulo =  "CERTIFICADO DE EXPENSAS"

        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        def content = "<!DOCTYPE HTML>\n<html>\n"
        content += "<head>\n"
        content += "<style language='text/css'>\n"
        content += "" +
                " div.header {\n" +
                "   display    : block;\n" +
                "   text-align : center;\n" +
                "   position   : running(header);\n" +
                "}\n" +
                "div.footer {\n" +
                "   display    : block;\n" +
                "   text-align : center;\n" +
                "   font-size  : 9pt;\n" +
                "   position   : running(footer);\n" +
                "} " +
                " @page {\n" +
                "   size   : 21cm 29.7cm;  /*width height */\n" +
                "   margin : 2cm 2cm 2cm 2cm;\n" +
                "}\n" +
                "@page {\n" +
                "   @top-center {\n" +
                "       content : element(header)\n" +
                "   }\n" +
                "}" +
                "@page {\n" +
                "   @bottom-center {\n" +
                "       content : element(footer)\n" +
                "   }\n" +
                "}" +
                "p{\n" +
                "   text-align: justify;\n" +
                "   margin-bottom: 0;\n" +
                "}\n" +
                ".tam {\n" +
                "   font-size: 20pt;\n" +
                "}\n" +
                ".centrado {\n" +
                "   text-align: center;\n" +
                "}\n"

        content += "</style>\n"
        content += "</head>\n"
        content += "<body>\n"
        content += "<p class='centrado tam'>" + nombre + "</p>"
        content += "<p class='centrado'>" + direccion + "</p>"
        content += "<p class='centrado'>" + q + "</p>"
        content += "<p class='centrado tam' style='margin-bottom: 10px'>" + titulo + "</p>"
        content += text
        content += "</body>\n"
        content += "</html>"

        ITextRenderer renderer = new ITextRenderer();
        renderer.setDocumentFromString(content);
        renderer.layout();
        renderer.createPDF(baos);
        byte[] b = baos.toByteArray();

        return baos

    }

    def reporteDetallePagos (){
//        println("params " + params)
        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde)
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta)
        def persona = Persona.get(params.id)

        def ingresos = Ingreso.withCriteria {
            eq("persona",persona)
            ge("fecha", fechaDesde)
            le("fecha",fechaHasta)
            order("fecha","asc")
        }

        def pagos = Pago.findAllByIngresoInList(ingresos,[sort: 'ingreso.obligacion.descripcion', order: 'asc'])
//        println("ingresos " + ingresos)

        def baos = new ByteArrayOutputStream()
        def name = "listaObras" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font fontTitulo14 = new Font(Font.TIMES_ROMAN, 14, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);
        def fondoN = new Color(240, 248, 250);
        def frmN = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondoN, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmN2 = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondoN, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmN3 = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondoN, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmTT = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondoN, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]


        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 30, 28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Detalle de Pagos del ${fechaDesde.format("dd-MM-yyyyy")} al ${fechaHasta.format("dd-MM-yyyy")}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("", fontTitle));
        preface.add(new Paragraph("Detalle de Pagos de " + persona.nombre + " " + persona.apellido + " (" + persona.departamento + ")", fontTitulo14));
        preface.add(new Paragraph("Período del ${fechaDesde.format("dd-MMM-yyyy")} al ${fechaHasta.format("dd-MMM-yyyy")}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null
        PdfPTable nested1 = null
        PdfPTable nested2 = null;
        PdfPTable nested3 = null;
        def total = 0

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

//            def tablaHeaderDetalles = new PdfPTable(6);
            def tablaHeaderDetalles = new PdfPTable(4);
            tablaHeaderDetalles.setWidthPercentage(100);
//            tablaHeaderDetalles.setWidths(arregloEnteros([25,20,15,15,15,10]))
            tablaHeaderDetalles.setWidths(arregloEnteros([10,40,25,25]))

            addCellTabla(tablaHeaderDetalles, new Paragraph(" ", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Fecha de Pago", fontTh), frmtHd)
//            addCellTabla(tablaHeaderDetalles, new Paragraph("Concepto", fontTh), frmtHd)
//            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor Pagado", fontTh), frmtHd)
//            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor Restante", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Comprobante", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 7, pl: 0])
        }

        tablaDetalles = new PdfPTable(3);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([60,20,20]))
        tablaDetalles.setSpacingAfter(1f);

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtR = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

//        printHeaderDetalle()

        ingresos.each {ingreso->

            nested1 = new PdfPTable(2);
            nested2 = new PdfPTable(1);
            nested3 = new PdfPTable(1);

            addCellTabla(tablaDetalles, new Paragraph("Concepto: " + ingreso?.obligacion?.descripcion, fontTh), frmN2)
            addCellTabla(tablaDetalles, new Paragraph("Valor: " + ingreso?.valor + " ", fontTh), frmN)
            addCellTabla(tablaDetalles, new Paragraph("Pendiente: " + (ingreso?.valor?.toDouble() - (Pago.findAllByIngreso(ingreso).valor?.sum()?.toDouble() ?: 0) ?: 0.00) + " ", fontTh), frmN)

            total += ingreso?.valor?.toDouble() - (Pago.findAllByIngreso(ingreso).valor?.sum()?.toDouble() ?: 0) ?: 0.00

//            printHeaderDetalle()
            if( Pago.findAllByIngreso(ingreso)){
                Pago.findAllByIngreso(ingreso).eachWithIndex {pago, u->
                    addCellTabla(nested1, new Paragraph("Pago " + (u+1), fontTd10), frmtR)
                    addCellTabla(nested1, new Paragraph(pago?.fechaPago?.format("dd-MM-yyyy")?.toString() ?: '', fontTd10), frmtNmro)
//                addCellTabla(nested1, new Paragraph(pago?.ingreso?.obligacion?.descripcion + " ", fontTd10), frmtDato)
//                addCellTabla(nested2, new Paragraph(pago?.ingreso?.valor + " ", fontTd10), frmtNmro)
                    addCellTabla(nested2, new Paragraph(pago?.valor + " ", fontTd10), frmtNmro)
//                addCellTabla(nested3, new Paragraph(pago?.ingreso?.valor?.toDouble() - (pago?.valor ?: 0) + " ", fontTd10), frmtNmro)
                    addCellTabla(nested3, new Paragraph("Comprobante: " + pago?.documento, fontTd10), frmtDato)
                }
            }else{
                addCellTabla(nested1, new Paragraph(" -- Sin pagos realizados--", fontTd10), frmtNmro)
                addCellTabla(nested1, new Paragraph("", fontTd10), frmtDato)
                addCellTabla(nested2, new Paragraph("", fontTd10), frmtDato)
                addCellTabla(nested3, new Paragraph("", fontTd10), frmtDato)

            }

            tablaDetalles.addCell(new PdfPCell(nested1));
            tablaDetalles.addCell(new PdfPCell(nested2));
            tablaDetalles.addCell(new PdfPCell(nested3));

        }

        def tablaTotales = new PdfPTable(3);
        tablaTotales.setWidthPercentage(100);
        tablaTotales.setWidths(arregloEnteros([60,20,20]))
        addCellTabla(tablaDetalles, new Paragraph("", fontTh), frmN2)
        addCellTabla(tablaDetalles, new Paragraph("Total Pendiente: ", fontTh), frmN3)
        addCellTabla(tablaDetalles, new Paragraph(total + " ", fontTh), frmTT)


        document.add(tablaDetalles)
        document.add(tablaTotales)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + "detallePagos_" + new Date().format("dd-MM-yyyy"))
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def fechasDetalle_ajax () {

    }

    def reporteEgresosProveedor () {

//        println("params egp " + params)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')
        def suma = 0
        def cuenta = 0

        def sql3 = "select prve, sum(egrsvlor) from egresos(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}'::date) group by prve order by 2 desc;"
        def cn3 = dbConnectionService.getConnection()
        def egresos = cn3.rows(sql3.toString())

        def totalEgresos = (egresos.sum.sum() ?: 0)

        def baos = new ByteArrayOutputStream()
        def name = "listaEgresosProveedor_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 100, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Detalle de Egresos por Proveedor del ${fechaDesde} al ${fechaHasta}");
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

        PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(2);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([80,20]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Proveedor", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 2, pl: 0])
        }

        tablaDetalles = new PdfPTable(2);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([80,20]))
        tablaDetalles.setSpacingAfter(1f);


        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        egresos.each {egreso ->
            if(egreso.sum > params.valor.toInteger()) {
                addCellTabla(tablaDetalles, new Paragraph(egreso.prve, fontTd10), frmtDato)
                addCellTabla(tablaDetalles, new Paragraph(egreso.sum.toString(), fontTd10), frmtNmro)
            } else {
                cuenta++
                suma += egreso.sum
            }
        }

        if(suma > 0) {
            addCellTabla(tablaDetalles, new Paragraph("Otros: ${cuenta} proveedores menores cuyo valor no supera los " +
                    "\$${params.valor.toInteger()}, con promedio individual: " +
                    "\$${Math.round(suma/cuenta *100)/100}", fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(suma.toString(), fontTd10), frmtNmro)
        }

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([80, 20]))

        addCellTabla(tablaTotal, new Paragraph("Total: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 2, pl: 0])

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();

        encabezadoYnumeracion(b, session.condominio.nombre, "Detalle de Egresos por Proveedor del ${fechaDesde} al ${fechaHasta}",
                "egresosProveedores_${new Date().format("dd-MM-yyyy")}.pdf")



    }

    def pdfEgresosProveedor (desde, hasta) {

//        println("params egp " + params)

        def f = desde.format("dd-MM-yyyy")
        def  h = hasta.format("dd-MM-yyyy")

        def fechaDesde = new Date().parse("dd-MM-yyyy", f)
        def fechaHasta = new Date().parse("dd-MM-yyyy", h)

        def suma = 0
        def cuenta = 0

//        println "fechas: '${fechaDesde}','${fechaHasta}'"

        def sql3 = "select prve, sum(egrsvlor) from egresos(${session.condominio.id}, '${fechaDesde.format('yyyy-MM-dd')}', " +
                "'${fechaHasta.format('yyyy-MM-dd')}'::date) group by prve order by 2 desc;"
        def cn3 = dbConnectionService.getConnection()
        def egresos = cn3.rows(sql3.toString())

        def totalEgresos = (egresos.sum.sum() ?: 0)

        def baos = new ByteArrayOutputStream()
        def name = "listaEgresosProveedor_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40, 140, 180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTitle1 = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 30, 28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Detalle de Egresos por Proveedor del ${fechaDesde.format('dd-MM-yyyy')} al ${fechaHasta.format('dd-MM-yyyy')}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("Detalle de Egresos por Proveedor del ${fechaDesde.format('dd-MM-yyyy')} al ${fechaHasta.format('dd-MM-yyyy')}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(2);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([80,20]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Proveedor", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Valor", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 2, pl: 0])
        }

        tablaDetalles = new PdfPTable(2);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([80,20]))
        tablaDetalles.setSpacingAfter(1f);


        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        egresos.each {egreso ->
            if(egreso.sum > 10) {
                addCellTabla(tablaDetalles, new Paragraph(egreso.prve, fontTd10), frmtDato)
                addCellTabla(tablaDetalles, new Paragraph(egreso.sum.toString(), fontTd10), frmtNmro)
            } else {
                cuenta++
                suma += egreso.sum
            }
        }

        if(suma > 0) {
            addCellTabla(tablaDetalles, new Paragraph("Otros: ${cuenta} proveedores menores cuyo valor no supera los " +
                    "\$10.00, con promedio individual: " +
                    "\$${Math.round(suma/cuenta *100)/100}", fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new Paragraph(suma.toString(), fontTd10), frmtNmro)
        }

        def tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([80, 20]))

        addCellTabla(tablaTotal, new Paragraph("Total: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number:totalEgresos, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 2, pl: 0])

        document.add(tablaDetalles)
        document.close();
        pdfw.close()
        return baos;
    }

    def solicitudPago () {
        def condominio = Condominio.get(params.id)
        def texto = Texto.findByCondominioAndCodigo(condominio,'SLCT')

        if(!texto){
            texto = new Texto()
            texto.codigo = 'SLCT'
            texto.condominio = condominio
            texto.save(flush: true)
        }

        def parrafo1 = "Luego de un atento saludo, me permito solicitarle el pago de la deuda que mantiene con el " +
                "conjunto residencial ${condominio?.nombre}, la misma que se detalla a continuación:"
        def parrafo2 = "El cobro de intereses por mora se aplica desde el 1° de abril de XXXX, conforme lo determina " +
                "nuestro Reglamento Interno en el artículo 39 literal 'p', a los valores adeudados hasta el 31 de enero " +
                "de XXXX, así como también a las deudas que superen los 2 meses de alícuotas. Por esta razón me " +
                "permito insistir en que realice el pago lo antes posible o proponga una forma de pago enviando la " +
                "misma al correo electrónico ${condominio?.email ?: ''}.<br>" +
                "Agradezco su oportuna atención a la presente, lo que nos ayudará a cubrir los gastos de servicios " +
                "básicos, mantenimiento, conserje, vigilancia y mejora de los bienes comunales."
        def nota = "Nota: No se cobrarán los intereses si el pago se realiza hasta el 1° de Octubre de xxxx"

        return [condominio:condominio, parrafo1: parrafo1, parrafo2: parrafo2, texto: texto, nota: nota]
    }

    def guardarParrafosSolicitud_ajax() {

        def texto = Texto.get(params.id)
        texto.parrafoUno = params.parrafo1
        texto.parrafoDos = params.parrafo2
        if(params.tipo == '1'){
            texto.nota = params.nota
        }

        if(!texto.save(flush: true)){
            render "no"
        }else{
            render "ok"
        }
    }

    def cambiarHtml(texto){
        String gt = ''
        ArrayList p2 = new ArrayList()
        StringReader sh2 = new StringReader(texto)
        p2 = HTMLWorker.parseToList(sh2, null)
        for (int k = 0; k < p2[0].size(); ++k){
            gt += p2[0].get(k)
        }

        return gt
    }

    def alicuotas_ajax(){

    }

    def reporteSolicitudPago () {

        println("params p")

        def persona = Persona.get(params.id)
        def condominio = Condominio.get(session.condominio.id)
        def texto = Texto.findByCondominioAndCodigo(condominio, 'SLCT')
        def para = persona.sexo == 'M' ? 'Señor' : 'Señora(ita)'

        def sql = "select * from personas(${condominio?.id}) where prsn__id= ${persona.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        def sql2 = "select * from pendiente('${new Date().format("yyyy-MM-dd")}', ${persona.edificio.id}) where prsn__id= ${persona.id} order by ingrfcha"
        def cn2 = dbConnectionService.getConnection()
        def data2 = cn2.rows(sql2.toString())

        def sql3 = "select prsnnmbr, prsnapll, prsntelf, prsndpto from prsn, admn where prsn.prsn__id = admn.prsn__id and cndm__id = '${condominio?.id}' and admnfcfn is null"
        def cn3 = dbConnectionService.getConnection()
        def data3 = cn3.rows(sql3.toString())

        def totalIntereses = 0
        def totalFinal = 0

        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        def texto1 = formatearTexto(texto?.parrafoUno ?: '')
        def texto2 = formatearTexto(texto?.parrafoDos ?: '')
        def nota = formatearTexto(texto?.nota ?: '')
        def nombreAPoner = ''

        if(persona?.nombre != persona?.nombrePropietario) {
            nombreAPoner =  (persona?.nombre ?: '') + ' ' + (persona?.apellido ?: '') + ' / ' + (persona?.nombrePropietario ?: '') + ' ' + (persona?.apellidoPropietario ?: '')
        } else {
            nombreAPoner = (persona?.nombre ?: '') + ' ' + (persona?.apellido ?: '')
        }

        def content = "<!DOCTYPE HTML>\n<html>\n"
        content += "<head>\n"
        content += "<style language='text/css'>\n"
        content += "" +
                " div.header {\n" +
                "   display    : block;\n" +
                "   text-align : center;\n" +
                "   position   : running(header);\n" +
                "}\n" +
                "div.footer {\n" +
                "   display    : block;\n" +
                "   text-align : center;\n" +
                "   font-size  : 9pt;\n" +
                "   position   : running(footer);\n" +
                "} " +
                " @page {\n" +
                "   size   : 21cm 29.7cm;  /*width height */\n" +
                "   margin : 2.0cm 1.5cm 1.5cm 2.0cm;\n" +
                "}\n" +
                "@page {\n" +
                "   @top-center {\n" +
                "       content : element(header)\n" +
                "   }\n" +
                "}" +
                "@page {\n" +
                "   @bottom-center {\n" +
                "       content : element(footer)\n" +
                "   }\n" +
                "}" +
                ".hoja {\n" +
                "   width       : 16.5cm; /*21-2.5-3*/\n" +
                "   font-family : arial;\n" +
                "   font-size   : 12pt;\n" +
                "}\n" +
                "table {\n" +
                "   border-collapse: collapse;\n" +
                "}\n"
        "table, th, td {\n" +
                "   border: 1px solid black;\n" +
                "}\n"
        content += "</style>\n"
        content += "</head>\n"
        content += "<body>\n"
        content += "<div class='footer'>" +
                (condominio?.nombre ?: '') + "  •  " + (condominio?.direccion ?: '') + "  •  " + (condominio?.telefono ?: '') +
                "</div>"

        content += "<div class='hoja'>\n"
        content += "<p style='font-size:16pt; font-weight : bold; text-align: center'>" + (condominio?.nombre?.toUpperCase() ?: '') + "</p>\n"
        content += "<p style='font-size:12pt; text-align: right'>" + "Quito, " + util.fechaConFormato(fecha: new Date(), formato: 'dd MMMM yyyy') + "</p>\n"

        content += "<p style='font-size:12pt; text-align: left'>" + para + "</p>\n"
        content += "<p style='font-size:12pt; text-align: left; margin-top: -13px'>" + nombreAPoner + "</p>\n"
        content += "<p style='font-size:12pt; text-align: left; margin-top: -13px'>" +  (persona?.edificio?.descripcion ?: '') + ', Departamento: ' + (persona?.departamento ?: '')+ "</p>\n"
        content += "<p style='font-size:12pt; text-align: left; margin-top: -13px'>" + "Presente," + "</p>\n"
        content += texto1
        content += "<div style='text-align:center'>"
        content += "<table border='1' style='width: 90%;'>"
        content += "<thead>"
        content += "<tr>"
        content += "<th width='55%' style='text-align:center'>"
        content += "Concepto"
        content += "</th>"
        content += "<th width='15%' style='text-align:center'>"
        content += "Valor"
        content += "</th>"
        content += "<th width='15%' style='text-align:center'>"
        content += "Intereses"
        content += "</th>"
        content += "<th width='15%' style='text-align:center'>"
        content += "Total"
        content += "</th>"
        content += "</tr>"
        content += "</thead>"
        content += "<tbody>"
        data2.each {pendiente->
            if (pendiente.sldo > 0) {
                content += "<tr>"
                content += "<td>"
                content += pendiente.oblg
                content += "</td>"
                content += "<td style='text-align: right'>"
                content += pendiente.sldo
                content += "</td>"
                content += "<td style='text-align: right'>"
                content += pendiente.ingrintr
                content += "</td>"
                content += "<td style='text-align: right'>"
                content += (pendiente.sldo + pendiente.ingrintr)
                content += "</td>"
                content += "</tr>"
                totalIntereses += pendiente.ingrintr
                totalFinal += (pendiente.sldo + pendiente.ingrintr)
            }
        }
        content += "<tr style='font-weight : bold'>"
        content += "<td>"
        content += "Total"
        content += "</td>"
        content += "<td style='text-align: right'>"
        content += data[0].prsnsldo
        content += "</td>"
        content += "<td style='text-align: right'>"
        content += totalIntereses
        content += "</td>"
        content += "<td style='text-align: right'>"
        content +=  totalFinal
        content += "</td>"
        content += "</tr>"
        content += "</tbody>"
        content += "</table>"
        content += "</div>"
        content += texto2
        content += "Agradezco su oportuna atención a la presente, lo que nos ayudará a cubrir los gastos de servicios\n" +
                "básicos, mantenimiento, conserje, vigilancia y mejora de los bienes comunales."
        content += "<br/>"
        content += "<p style='margin-bottom: 60px'>Atentamente,</p>"
        content += data3[0].prsnnmbr + " " + data3[0].prsnapll + "<br/>"
        content += "ADMINISTRADOR <br/>"
        content += "Cel: " + (data3[0].prsntelf ?: '') + ", dpto.: " + (data3[0].prsndpto ?: '') + "<br/>"
        content += nota
        content += "</div>\n"
        content += "</body>\n"
        content += "</html>"

        ITextRenderer renderer = new ITextRenderer();
        renderer.setDocumentFromString(content);
        renderer.layout();
        renderer.createPDF(baos);
        byte[] b = baos.toByteArray();

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=solicituPago_${persona?.nombre + "_" + persona?.apellido + "_" +new Date().format("dd-MM-yyyy")}")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def formatearTexto(text){
        text = text.replaceAll("&lt;", "*lt*")
        text = text.replaceAll("&gt;", "*gt*")
        text = text.replaceAll("&amp;", "*amp*")
        text = text.replaceAll("<p>&nbsp;</p>", "<br/>")
        text = text.replaceAll("&nbsp;", " ")

        text = text.decodeHTML()

        text = text.replaceAll("\\*lt\\*", "&lt;")
        text = text.replaceAll("\\*gt\\*", "&gt;")
        text = text.replaceAll("\\*amp\\*", "&amp;")
        text = text.replaceAll("\\*nbsp\\*", " ")
        text = text.replaceAll(/<tr>\s*<\/tr>/, / /)    //2 <tr> seguidos <tr>espacios</tr>

        text = text.replaceAll(~"\\?\\_debugResources=y\\&n=[0-9]*", "")

        return text
    }

    def tablaSolicitudPago_ajax() {

        println("params tsp " + params)

        def condominio = Condominio.get(params.id)
        def valor = params.valor

        def sql = "select * from personas(${condominio?.id}) where prsnsldo > alctvlor * ${valor} order by edifdscr, prsndpto"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        def deudas = []

        data.each { persona->

            def suma = 0

            def sql2 = "select prsn__id, sldo, sldo + ingrintr total " +
                    "from pendiente('${new Date().format("yyyy-MM-dd")}', ${Persona.get(persona.prsn__id).edificio.id}) where prsn__id = " +
                    "${persona.prsn__id} order by ingrfcha"
            def cn2 = dbConnectionService.getConnection()
            def data2 = cn2.rows(sql2.toString())

            data2.each {pendiente->
                if (pendiente.sldo > 0) {
                    suma += pendiente.total
                }
            }

            deudas.add(suma)
        }

        return [condominio: condominio, alicuota:valor, personas: data, tipo: params.tipo, deudas:deudas]
    }

    def solicitudMonitorio(){
        def condominio = Condominio.get(params.id)
        def texto = Texto.findByCondominioAndCodigo(condominio,'MNTR')

        if(!texto){
            texto = new Texto()
            texto.codigo = 'MNTR'
            texto.condominio = condominio
            texto.save(flush: true)
        }

        def parrafo1 = "Luego de un atento saludo, me permito indicarle que conforme a lo acordado en la Asamblea " +
                "General de condóminos realizada el 28 de enero de 2020, se utilizará un proceso legal para el " +
                "cobro de los valores que mantiene pendientes de pago:"
        def parrafo2 = "El abogado llevará su trámite mediante un Proceso Monitorio y ofrece realizar el cobro de " +
                "todos sus adeudos en un plazo de 15 días término, añadiendo a su deuda actual el valor de \$ 25" +
                "por gestión de cobro y el 10% de comisión, tal como se detalla en el cuadro anterior." +
                "Para evitar este proceso legal le invito a acercarse a conversar con la adminstración hasta el" +
                "viernes 20 de febrero de 2020, para acordar un compromiso de pago."

        return [condominio:condominio, parrafo1: parrafo1, parrafo2: parrafo2, texto: texto]
    }

    def reporteSolicitudMonitorio() {

        println("params m " + params)

        def persona = Persona.get(params.id)
        def condominio = Condominio.get(session.condominio.id)
        def texto = Texto.findByCondominioAndCodigo(condominio,'MNTR')
        def para = persona.sexo == 'M' ? 'Señor' : 'Señora(ita)'

        def sql = "select * from personas(${condominio?.id}) where prsn__id= ${persona.id}"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        def sql2 = "select prsn__id, oblg, prsn, prsndpto, tipo, sldo, mess, ingrintr, sldo + ingrintr total " +
                "from pendiente('${new Date().format("yyyy-MM-dd")}', ${persona.edificio.id}) where prsn__id = " +
                "${persona.id} order by ingrfcha"
        def cn2 = dbConnectionService.getConnection()
        def data2 = cn2.rows(sql2.toString())

        def sql3 = "select prsnnmbr, prsnapll, prsntelf, prsndpto from prsn, admn where prsn.prsn__id = admn.prsn__id and cndm__id = '${condominio?.id}' and admnfcfn is null"
        def cn3 = dbConnectionService.getConnection()
        def data3 = cn3.rows(sql3.toString())

        def totalIntereses = 0
        def totalFinal = 0
        def suma = 0

        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        def texto1 = formatearTexto(texto?.parrafoUno ?: '')
        def texto2 = formatearTexto(texto?.parrafoDos ?: '')
        def nombreAPoner = "${persona.nombrePropietario} ${persona.apellidoPropietario}"

        def content = "<!DOCTYPE HTML>\n<html>\n"
        content += "<head>\n"
        content += "<style language='text/css'>\n"
        content += "" +
                " div.header {\n" +
                "   display    : block;\n" +
                "   text-align : center;\n" +
                "   position   : running(header);\n" +
                "}\n" +
                "div.footer {\n" +
                "   display    : block;\n" +
                "   text-align : center;\n" +
                "   font-size  : 9pt;\n" +
                "   position   : running(footer);\n" +
                "} " +
                " @page {\n" +
                "   size   : 21cm 29.7cm;  /*width height */\n" +
                "   margin : 2.0cm 1.5cm 1.5cm 2.0cm;\n" +
                "}\n" +
                "@page {\n" +
                "   @top-center {\n" +
                "       content : element(header)\n" +
                "   }\n" +
                "}" +
                "@page {\n" +
                "   @bottom-center {\n" +
                "       content : element(footer)\n" +
                "   }\n" +
                "}" +
                ".hoja {\n" +
                "   width       : 16.5cm; /*21-2.5-3*/\n" +
                "   font-family : arial;\n" +
                "   font-size   : 12pt;\n" +
                "}\n" +
                "table {\n" +
                "   border-collapse: collapse;\n" +
                "}\n"
        "table, th, td {\n" +
                "   border: 1px solid black;\n" +
                "}\n"
        content += "</style>\n"
        content += "</head>\n"
        content += "<body>\n"
        content += "<div class='footer'>" +
                (condominio?.nombre ?: '') + "  •  " + (condominio?.direccion ?: '') + "  •  " + (condominio?.telefono ?: '') +
                "</div>"

        content += "<div class='hoja'>\n"
        content += "<p style='font-size:16pt; font-weight : bold; text-align: center'>" + (condominio?.nombre?.toUpperCase() ?: '') + "</p>\n"
        content += "<p style='font-size:12pt; text-align: right'>" + "Quito, " + util.fechaConFormato(fecha: new Date(), formato: 'dd MMMM yyyy') + "</p>\n"

        content += "<p style='font-size:12pt; text-align: left'>" + para + "</p>\n"
        content += "<p style='font-size:12pt; text-align: left; margin-top: -13px'>" + nombreAPoner + "</p>\n"
        content += "<p style='font-size:12pt; text-align: left; margin-top: -13px'>" +  (persona?.edificio?.descripcion ?: '') + ', Departamento: ' + (persona?.departamento ?: '')+ "</p>\n"
        content += "<p style='font-size:12pt; text-align: left; margin-top: -13px'>" + "Presente," + "</p>\n"
        content += texto1
        content += "<div style='text-align:center'>"
        content += "<table border='1' style='width: 90%;'>"
        content += "<thead>"
        content += "<tr>"
        content += "<th width='30%' style='text-align:center'>"
        content += "Concepto"
        content += "</th>"
        content += "<th width='15%' style='text-align:center'>"
        content += "Valor"
        content += "</th>"
        content += "<th width='15%' style='text-align:center'>"
        content += "Meses"
        content += "</th>"
        content += "<th width='15%' style='text-align:center'>"
        content += "Intereses"
        content += "</th>"
        content += "<th width='15%' style='text-align:center'>"
        content += "Total"
        content += "</th>"
        content += "</tr>"
        content += "</thead>"
        content += "<tbody>"
        data2.each {pendiente->
            if (pendiente.sldo > 0) {
                content += "<tr>"
                content += "<td>"
                content += (pendiente.oblg == '' ? TipoAporte.get(pendiente.tipo).descripcion : pendiente.oblg)
                content += "</td>"
                content += "<td style='text-align: right'>"
                content += pendiente.sldo
                content += "</td>"
                content += "<td style='text-align: right'>"
                content += pendiente.mess
                content += "</td>"
                content += "<td style='text-align: right'>"
                content += pendiente.ingrintr
                content += "</td>"
                content += "<td style='text-align: right'>"
                content += pendiente.total
                content += "</td>"
                content += "</tr>"
                suma += pendiente.total
            }
        }

        def ttal1 = Math.round(0.1 * suma * 100)/100
        def ttal2 = ttal1 + suma + condominio?.monitorio

        content += "<tr style='font-weight : bold'>"
        content += "<td colspan='4' style='text-align: left'>"
        content += "Total"
        content += "</td>"
        content += "<td style='text-align: right'>"
        content += (suma ?:0)
        content += "</td>"
        content += "</tr>"
        content += "<tr>"
        content += "<td colspan='4' style='text-align: left'>"
        content += "Abogado - Gestión de cobro"
        content += "</td>"
        content += "<td style='text-align: right'>"
        content += condominio?.monitorio
        content += "</td>"
        content += "</tr>"
        content += "<tr>"
        content += "<td colspan='4' style='text-align: left'>"
        content += "Abogado - 10% de comisión por el cobro realizado"
        content += "</td>"
        content += "<td style='text-align: right'>"
        content += (ttal1 ?: 0)
        content += "</td>"
        content += "</tr>"
        content += "<tr style='font-weight : bold'>"
        content += "<td colspan='4' style='text-align: left'>"
        content += "<strong>Gran Total</strong>"
        content += "</td>"
        content += "<td style='text-align: right'>"
        content += (ttal2 ?: 0)
        content += "</td>"
        content += "</tr>"
        content += "</tbody>"
        content += "</table>"
        content += "</div>"
        content += texto2
        content += "<p style='margin-bottom: 60px'>Atentamente,</p>"
        content += data3[0].prsnnmbr + " " + data3[0].prsnapll + "<br/>"
        content += "ADMINISTRADOR <br/>"
        content += "Cel: " + (data3[0].prsntelf ?: '') + ", dpto.: " + (data3[0].prsndpto ?: '') + "<br/>"
//        content += nota
        content += "</div>\n"
        content += "</body>\n"
        content += "</html>"

        ITextRenderer renderer = new ITextRenderer();
        renderer.setDocumentFromString(content);
        renderer.layout();
        renderer.createPDF(baos);
        byte[] b = baos.toByteArray();

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=solicitudMonitorio_${persona?.nombre + "_" + persona?.apellido + "_" +new Date().format("dd-MM-yyyy")}")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def tablaSolicitudMonitorio_ajax(){

        println("params tsm " + params)

        def condominio = Condominio.get(params.id)
        def valor = params.valor

        def sql = "select * from personas(${condominio?.id}) where prsnsldo > alctvlor * ${valor} order by edifdscr, prsndpto"
        def cn = dbConnectionService.getConnection()
        def data = cn.rows(sql.toString())

        def deudas = []

        data.each { persona->

            def suma = 0

            def sql2 = "select prsn__id, sldo, sldo + ingrintr total " +
                    "from pendiente('${new Date().format("yyyy-MM-dd")}', ${Persona.get(persona.prsn__id).edificio.id}) where prsn__id = " +
                    "${persona.prsn__id} order by ingrfcha"
            def cn2 = dbConnectionService.getConnection()
            def data2 = cn2.rows(sql2.toString())

            data2.each {pendiente->
                if (pendiente.sldo > 0) {
                    suma += pendiente.total
                }
            }

            deudas.add(suma)
        }

        return [condominio: condominio, alicuota:valor, personas: data, deudas:deudas]
    }

    def nuevaAlicuotaReporte () {

        def condominio = Condominio.get(session.condominio.id)
        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def sql = "select * from cuotas('${params.valor}', '${condominio?.id}') order by prsndpto"
//        println "sql: $sql"
        def res = cn.rows(sql.toString())

        def tamano = res.size()
        def total = 0
        def totalAli = 0
        def totalValor = 0
        def totalDif = 0
        def baos = new ByteArrayOutputStream()

        def titulo = new Color(30, 140, 160)
        def fondoTotal = new Color(245, 243, 245);
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 11, Font.BOLD, titulo);
        Font fontTitulo16 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD, titulo);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontTd8 = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def fondo = new Color(240, 248, 250);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtHd4c = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE, colspan: 4]
        def frmtHd1 = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(50, 30, 100, 55)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = PdfWriter.getInstance(document, baos);

        document.resetHeader()
        document.resetFooter()

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Nuevas alícuotas");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        PdfPTable table = new PdfPTable(8);
        table.setWidthPercentage(100);
        table.setWidths(arregloEnteros([5, 14, 16, 40, 7, 9, 9, 8]))
        addCellTabla(table, new Paragraph("Dp.", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Nombre", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Apellido", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Propiedades y Alícuotas", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Total", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Nueva", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Actual", fontTh), frmtHd)
        addCellTabla(table, new Paragraph("Dif.", fontTh), frmtHd)
        table.setHeaderRows(1);

        if(res){
            res.eachWithIndex { fila, k ->

//                if(fila.diff != 0) {    /* para que impriman sólo los reg. con diferencias */
                    addCellTabla(table, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
                    addCellTabla(table, new Paragraph(fila.prsnnmbr.toString(), fontTd10), frmtDato)
                    addCellTabla(table, new Paragraph(fila.prsnapll, fontTd10), frmtDato)
                    addCellTabla(table, new Paragraph(fila.propdtlle, fontTd8), frmtDato)
                    addCellTabla(table, new Paragraph(g.formatNumber(number:fila.proptotl, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), frmtNmro)
                    addCellTabla(table, new Paragraph(g.formatNumber(number:fila.prsnalct, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), frmtNmro)
                    addCellTabla(table, new Paragraph(g.formatNumber(number:fila.alctvlor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), frmtNmro)
                    addCellTabla(table, new Paragraph(g.formatNumber(number:fila.diff, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), frmtNmro)

                    total += (fila.proptotl ? fila.proptotl.toDouble() : 0)
                    totalAli += (fila.prsnalct ? fila.prsnalct.toDouble() : 0)
                    totalValor += (fila.alctvlor ? fila.alctvlor.toDouble() : 0)
                    totalDif += (fila.diff ? fila.diff.toDouble() : 0)
//                }
            }
        } else {
            Paragraph preface2 = new Paragraph();
            addEmptyLine(preface2, 1);
            preface2.setAlignment(Element.ALIGN_CENTER);
            preface2.add(new Paragraph("-- sin datos --", fontTitulo16));
            addEmptyLine(preface2, 1);
            document.add(preface2);
        }

        addCellTabla(table, new Paragraph("TOTAL", fontTh), frmtHd4c)
        addCellTabla(table, new Paragraph(g.formatNumber(number:total, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
        addCellTabla(table, new Paragraph(g.formatNumber(number:totalAli, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
        addCellTabla(table, new Paragraph(g.formatNumber(number:totalValor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)
        addCellTabla(table, new Paragraph(g.formatNumber(number:totalDif, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTh), frmtHd1)

        document.add(table);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();

        encabezadoYnumeracion(b, session.condominio.nombre, "Cálculo de la Alícuota Nueva - Base: ${params.valor}",
                "alicuotaNueva_${new Date().format("dd-MM-yyyy")}.pdf")
    }

    def mantenimientoMejoras(){
//        println("params " + params)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

//        println "fechas: '${fechaDesde}','${fechaHasta}'"

        def sql3 = "select * from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}') where tpgsdscr = 'Mantenimiento';"
        def cn3 = dbConnectionService.getConnection()
        def mantenimientos = cn3.rows(sql3.toString())

        def sql6 = "select * from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}') where tpgsdscr = 'Mejoras';"
        def cn6 = dbConnectionService.getConnection()
        def mejoras = cn6.rows(sql6.toString())

        def baos = new ByteArrayOutputStream()
        def titulo = new Color(40, 140, 180)
        com.lowagie.text.Font fontTitulo = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 12, com.lowagie.text.Font.BOLD, titulo);
        com.lowagie.text.Font fontTitulo16 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 16, com.lowagie.text.Font.BOLD, titulo);
        com.lowagie.text.Font info = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.NORMAL)
        com.lowagie.text.Font fontTitle = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 14, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTitle1 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTh = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTd = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.NORMAL);
        com.lowagie.text.Font fontTd10 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.NORMAL);
        com.lowagie.text.Font fontThTiny = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 7, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTdTiny = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 7, com.lowagie.text.Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);

        com.lowagie.text.Document document
        document = new com.lowagie.text.Document(com.lowagie.text.PageSize.A4);
        document.setMargins(50, 30, 100, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = com.lowagie.text.pdf.PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        com.lowagie.text.pdf.PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Mantenimiento y Mejoras del ${fechaDesde} al ${fechaHasta}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        com.lowagie.text.pdf.PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: com.lowagie.text.Element.ALIGN_CENTER, valign: com.lowagie.text.Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new com.lowagie.text.pdf.PdfPTable(5);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([16,30,30,12,12]))

            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Tipo", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Proveedor", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Descripción", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Fecha", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Valor", fontTh), frmtHd)

            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 5, pl: 0])
        }

        tablaDetalles = new com.lowagie.text.pdf.PdfPTable(5);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([16,30,30,12,12]))
        tablaDetalles.setSpacingAfter(1f);

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        def tablaTotalMantenimiento = new com.lowagie.text.pdf.PdfPTable(2);
        tablaTotalMantenimiento.setWidthPercentage(100);
        tablaTotalMantenimiento.setWidths(arregloEnteros([88, 12]))

        def sql4 = "select sum(egrsvlor) from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}') where tpgsdscr = 'Mejoras';"
        def cn4 = dbConnectionService.getConnection()
        def totalMejoras = cn4.rows(sql4.toString())

        def sql5 = "select sum(egrsvlor) from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}') where tpgsdscr = 'Mantenimiento';"
        def cn5 = dbConnectionService.getConnection()
        def totalMantenimiento = cn5.rows(sql5.toString())

        mantenimientos.each {mantenimiento ->
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.tpgsdscr.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.prve, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.egrsdscr, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.egrsfcha.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.egrsvlor.toString(), fontTd10), frmtNmro)
        }

        addCellTabla(tablaTotalMantenimiento, new com.lowagie.text.Paragraph("Total mantenimiento: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotalMantenimiento, new com.lowagie.text.Paragraph(g.formatNumber(number:totalMantenimiento[0].sum, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetalles, tablaTotalMantenimiento, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 5, pl: 0])


        def tablaDetallesMejora = new com.lowagie.text.pdf.PdfPTable(5);
        tablaDetallesMejora.setWidthPercentage(100);
        tablaDetallesMejora.setWidths(arregloEnteros([16,30,30,12,12]))
        tablaDetallesMejora.setSpacingAfter(1f);

        mejoras.each {mejora ->
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.tpgsdscr.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.prve, fontTd10), frmtDato)
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.egrsdscr, fontTd10), frmtDato)
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.egrsfcha.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.egrsvlor.toString(), fontTd10), frmtNmro)
        }

        def tablaTotalMejora = new com.lowagie.text.pdf.PdfPTable(2);
        tablaTotalMejora.setWidthPercentage(100);
        tablaTotalMejora.setWidths(arregloEnteros([88, 12]))

        addCellTabla(tablaTotalMejora, new com.lowagie.text.Paragraph("Total Mejoras: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotalMejora, new com.lowagie.text.Paragraph(g.formatNumber(number:totalMejoras[0].sum, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetallesMejora, tablaTotalMejora, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 5, pl: 0])


        def tablaTotal = new com.lowagie.text.pdf.PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([88, 12]))

        def sql7 = "select sum(egrsvlor) from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}');"
        def cn7= dbConnectionService.getConnection()
        def total = cn7.rows(sql7.toString())

        def granTotal = ( total[0].sum ?: 0)

        addCellTabla(tablaTotal, new com.lowagie.text.Paragraph("Total: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotal, new com.lowagie.text.Paragraph(g.formatNumber(number:granTotal, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetallesMejora, tablaTotal, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 5, pl: 0])

        document.add(tablaDetalles)
        document.add(tablaDetallesMejora)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();

        encabezadoYnumeracion(b, session.condominio.nombre,"Mantenimiento y Mejoras del ${fechaDesde} al ${fechaHasta}", "mantenimientoMejoras_${new Date().format("dd-MM-yyyy")}.pdf")
    }

    def pdfMantenimientoMejoras(desde,hasta){
//        println("params " + params)

        def f = desde.format("dd-MM-yyyy")
        def  h = hasta.format("dd-MM-yyyy")

        def fechaDesde = new Date().parse("dd-MM-yyyy", f).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", h).format('yyyy-MM-dd')

//        println "fechas: '${fechaDesde}','${fechaHasta}'"

        def sql3 = "select * from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}') where tpgsdscr = 'Mantenimiento';"
        def cn3 = dbConnectionService.getConnection()
        def mantenimientos = cn3.rows(sql3.toString())

        def sql6 = "select * from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}') where tpgsdscr = 'Mejoras';"
        def cn6 = dbConnectionService.getConnection()
        def mejoras = cn6.rows(sql6.toString())

        def baos = new ByteArrayOutputStream()
        def titulo = new Color(40, 140, 180)
        com.lowagie.text.Font fontTitulo = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 12, com.lowagie.text.Font.BOLD, titulo);
        com.lowagie.text.Font fontTitulo16 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 16, com.lowagie.text.Font.BOLD, titulo);
        com.lowagie.text.Font info = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.NORMAL)
        com.lowagie.text.Font fontTitle = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 14, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTitle1 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTh = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTd = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.NORMAL);
        com.lowagie.text.Font fontTd10 = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 10, com.lowagie.text.Font.NORMAL);
        com.lowagie.text.Font fontThTiny = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 7, com.lowagie.text.Font.BOLD);
        com.lowagie.text.Font fontTdTiny = new com.lowagie.text.Font(com.lowagie.text.Font.TIMES_ROMAN, 7, com.lowagie.text.Font.NORMAL);

        def fondoTotal = new Color(240, 240, 240);

        com.lowagie.text.Document document
        document = new com.lowagie.text.Document(com.lowagie.text.PageSize.A4);
        document.setMargins(50, 30, 60, 45)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
        def pdfw = com.lowagie.text.pdf.PdfWriter.getInstance(document, baos);
        document.resetHeader()
        document.resetFooter()

        document.open();
        com.lowagie.text.pdf.PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Mantenimiento y Mejoras del ${fechaDesde} al ${fechaHasta}");
        document.addSubject("Generado por el sistema Condominio");
        document.addKeywords("reporte, condominio, pagos");
        document.addAuthor("Condominio");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(session.condominio.nombre, fontTitulo16));
        preface.add(new Paragraph("Mantenimiento y Mejoras del ${fechaDesde} al ${fechaHasta}", fontTitulo));
        addEmptyLine(preface, 1);
        document.add(preface);

        com.lowagie.text.pdf.PdfPTable tablaDetalles = null

        def printHeaderDetalle = {
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: com.lowagie.text.Element.ALIGN_CENTER, valign: com.lowagie.text.Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new com.lowagie.text.pdf.PdfPTable(5);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([16,30,30,12,12]))

            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Tipo", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Proveedor", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Descripción", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Fecha", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new com.lowagie.text.Paragraph("Valor", fontTh), frmtHd)

            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 5, pl: 0])
        }

        tablaDetalles = new com.lowagie.text.pdf.PdfPTable(5);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([16,30,30,12,12]))
        tablaDetalles.setSpacingAfter(1f);

        def frmtDato = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE]
        def frmtNmro = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE]

        printHeaderDetalle()

        def tablaTotalMantenimiento = new com.lowagie.text.pdf.PdfPTable(2);
        tablaTotalMantenimiento.setWidthPercentage(100);
        tablaTotalMantenimiento.setWidths(arregloEnteros([88, 12]))

        def sql4 = "select sum(egrsvlor) from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}') where tpgsdscr = 'Mejoras';"
        def cn4 = dbConnectionService.getConnection()
        def totalMejoras = cn4.rows(sql4.toString())

        def sql5 = "select sum(egrsvlor) from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}') where tpgsdscr = 'Mantenimiento';"
        def cn5 = dbConnectionService.getConnection()
        def totalMantenimiento = cn5.rows(sql5.toString())

        mantenimientos.each {mantenimiento ->
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.tpgsdscr.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.prve, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.egrsdscr, fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.egrsfcha.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetalles, new com.lowagie.text.Paragraph(mantenimiento.egrsvlor.toString(), fontTd10), frmtNmro)
        }

        addCellTabla(tablaTotalMantenimiento, new com.lowagie.text.Paragraph("Total mantenimiento: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotalMantenimiento, new com.lowagie.text.Paragraph(g.formatNumber(number:totalMantenimiento[0].sum, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetalles, tablaTotalMantenimiento, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 5, pl: 0])


        def tablaDetallesMejora = new com.lowagie.text.pdf.PdfPTable(5);
        tablaDetallesMejora.setWidthPercentage(100);
        tablaDetallesMejora.setWidths(arregloEnteros([16,30,30,12,12]))
        tablaDetallesMejora.setSpacingAfter(1f);

        mejoras.each {mejora ->
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.tpgsdscr.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.prve, fontTd10), frmtDato)
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.egrsdscr, fontTd10), frmtDato)
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.egrsfcha.toString(), fontTd10), frmtDato)
            addCellTabla(tablaDetallesMejora, new com.lowagie.text.Paragraph(mejora.egrsvlor.toString(), fontTd10), frmtNmro)
        }

        def tablaTotalMejora = new com.lowagie.text.pdf.PdfPTable(2);
        tablaTotalMejora.setWidthPercentage(100);
        tablaTotalMejora.setWidths(arregloEnteros([88, 12]))

        addCellTabla(tablaTotalMejora, new com.lowagie.text.Paragraph("Total Mejoras: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotalMejora, new com.lowagie.text.Paragraph(g.formatNumber(number:totalMejoras[0].sum, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetallesMejora, tablaTotalMejora, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 5, pl: 0])


        def tablaTotal = new com.lowagie.text.pdf.PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([88, 12]))

        def sql7 = "select sum(egrsvlor) from mejoras(${session.condominio.id}, '${fechaDesde}', '${fechaHasta}');"
        def cn7= dbConnectionService.getConnection()
        def total = cn7.rows(sql7.toString())

        def granTotal = ( total[0].sum ?: 0)

        addCellTabla(tablaTotal, new com.lowagie.text.Paragraph("Total: ", fontTh), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaTotal, new com.lowagie.text.Paragraph(g.formatNumber(number:granTotal, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: com.lowagie.text.Element.ALIGN_RIGHT, valign: com.lowagie.text.Element.ALIGN_MIDDLE])
        addCellTabla(tablaDetallesMejora, tablaTotal, [border: Color.WHITE, align: com.lowagie.text.Element.ALIGN_LEFT, valign: com.lowagie.text.Element.ALIGN_MIDDLE, colspan: 5, pl: 0])

        document.add(tablaDetalles)
        document.add(tablaDetallesMejora)
        document.close();
        pdfw.close()
        return baos
    }


    def imprimirIngresosExcel () {

//        println("imprimirIngresos " + params)

        def condominio = Condominio.get(session.condominio.id)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')

        def sql2 = "select * from aportes(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') order by prsndpto"
        def cn2 = dbConnectionService.getConnection()
        def ingresos = cn2.rows(sql2.toString())

        def totalIngresos = (ingresos.pagovlor.sum() ?: 0)

        //excel
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()

        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)

        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
        // fija el ancho de la columna
        // sheet.setColumnView(1,40)

        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        sheet.setColumnView(0, 10)
        sheet.setColumnView(1, 40)
        sheet.setColumnView(2, 20)
        sheet.setColumnView(3, 30)
        sheet.setColumnView(4, 12)
        sheet.setColumnView(5, 12)
        sheet.setColumnView(6, 10)
        // inicia textos y numeros para asocias a columnas

        def label
        def nmro
        def number

        def fila = 6;

        NumberFormat nf = new NumberFormat("#.##");
        WritableCellFormat cf2obj = new WritableCellFormat(nf);

        label = new Label(1, 1, (condominio?.nombre ?: ''), times16format); sheet.addCell(label);
        label = new Label(1, 2, "Detalle de Ingresos del ${fechaDesde} al ${fechaHasta}", times16format); sheet.addCell(label);

        label = new Label(0, 4, "Dpto: ", times16format); sheet.addCell(label);
        label = new Label(1, 4, "Persona", times16format); sheet.addCell(label);
        label = new Label(2, 4, "Ocupante", times16format); sheet.addCell(label);
        label = new Label(3, 4, "Descripción del ingreso", times16format); sheet.addCell(label);
        label = new Label(4, 4, "Fecha", times16format); sheet.addCell(label);
        label = new Label(5, 4, "Documento", times16format); sheet.addCell(label);
        label = new Label(6, 4, "Valor", times16format); sheet.addCell(label);

        ingresos.eachWithIndex {i, j->
            label = new Label(0, fila, i.prsndpto.toString()); sheet.addCell(label);
            label = new Label(1, fila, i.prsn.toString()); sheet.addCell(label);
            label = new Label(2, fila, i?.tpocdscr?.toString()); sheet.addCell(label);
            label = new Label(3, fila, i?.pagodscr?.toString()); sheet.addCell(label);
            label = new Label(4, fila, i?.pagofcha?.toString()); sheet.addCell(label);
            label = new Label(5, fila, i?.pagodcmt?.toString()); sheet.addCell(label);
            number = new Number(6, fila, i?.pagovlor); sheet.addCell(number)
            fila++
        }

        label = new Label(0, fila, ''); sheet.addCell(label);
        label = new Label(1, fila, ''); sheet.addCell(label);
        label = new Label(2, fila, ''); sheet.addCell(label);
        label = new Label(3, fila, ''); sheet.addCell(label);
        label = new Label(4, fila, ''); sheet.addCell(label);
        label = new Label(5, fila,'TOTAL'); sheet.addCell(label);
        number = new Number(6, fila, totalIngresos); sheet.addCell(number);

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "DetalleIngresosExcel.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    def imprimirEgresosExcel () {

//        println("imprimirIngresos " + params)

        def condominio = Condominio.get(session.condominio.id)

        def fechaDesde = new Date().parse("dd-MM-yyyy", params.desde).format('yyyy-MM-dd')
        def fechaHasta = new Date().parse("dd-MM-yyyy", params.hasta).format('yyyy-MM-dd')
        def sql3 = "select * from egresos(${session.condominio.id}, '${fechaDesde}','${fechaHasta}') order by egrsfcha"
        def cn3 = dbConnectionService.getConnection()
        def egresos = cn3.rows(sql3.toString())

        def totalEgresos = (egresos.egrsvlor.sum() ?: 0)

        //excel
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()

        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)

        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
        // fija el ancho de la columna
        // sheet.setColumnView(1,40)

        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        sheet.setColumnView(0, 60)
        sheet.setColumnView(1, 60)
        sheet.setColumnView(2, 12)
        sheet.setColumnView(3, 10)
        sheet.setColumnView(4, 20)
        // inicia textos y numeros para asocias a columnas

        def label
        def nmro
        def number

        def fila = 6;

        NumberFormat nf = new NumberFormat("#.##");
        WritableCellFormat cf2obj = new WritableCellFormat(nf);

        label = new Label(1, 1, (condominio?.nombre ?: ''), times16format); sheet.addCell(label);
        label = new Label(1, 2, "Detalle de Egresos del ${fechaDesde} al ${fechaHasta}", times16format); sheet.addCell(label);

        label = new Label(0, 4, "Proveedor: ", times16format); sheet.addCell(label);
        label = new Label(1, 4, "Descripción de egresos", times16format); sheet.addCell(label);
        label = new Label(2, 4, "Fecha", times16format); sheet.addCell(label);
        label = new Label(3, 4, "Valor", times16format); sheet.addCell(label);
        label = new Label(4, 4, "Factura", times16format); sheet.addCell(label);

        egresos.eachWithIndex {i, j->
            label = new Label(0, fila, i.prve.toString()); sheet.addCell(label);
            label = new Label(1, fila, i.egrsdscr.toString()); sheet.addCell(label);
            label = new Label(2, fila, i?.egrsfcha?.toString()); sheet.addCell(label);
            number = new Number(3, fila, i?.egrsvlor); sheet.addCell(number);
            label = new Label(4, fila, i?.egrsfctr?.toString()); sheet.addCell(label);
            fila++
        }

        label = new Label(0, fila, ''); sheet.addCell(label);
        label = new Label(1, fila, ''); sheet.addCell(label);
        label = new Label(2, fila,'TOTAL'); sheet.addCell(label);
        number = new Number(3, fila, totalEgresos); sheet.addCell(number);

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "DetalleEgresosExcel.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }


}
