package utilitarios

import com.lowagie.text.Chapter
import com.lowagie.text.ChapterAutoNumber
import com.lowagie.text.Chunk
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

import java.awt.Color

class ReportesController {

    def dbConnectionService
    def index() { }


    def revisarFecha_ajax() {
//        println("params revisar fecha " + params)
        if(params.desde && params.hasta){
            def desde = new Date().parse("dd-MM-yyyy", params.desde)
            def hasta = new Date().parse("dd-MM-yyyy", params.hasta)

            if(desde > hasta){
                render "no"
            }else{
                render "ok"
            }
        }else{
            render "ok"
        }
    }

    def pagosPendientes_modal () {

    }

    def pagosPendientes () {
//        println("params pp " + params)
//        def desde = new Date().parse("dd-MM-yyyy", params.desde)
//        def hasta = new Date().parse("dd-MM-yyyy", params.hasta)


      def cn = dbConnectionService.getConnection()
      def sql = "select prsndpto depart, prsnnmbr||' '||prsnapll nombre,   coalesce(ingrobsr, '')||' ('||oblgdscr||')' detalle,   ingrvlor - ingrabno por_pagar from prsn, ingr, oblg where prsn.prsn__id = ingr.prsn__id and oblg.oblg__id = ingr.oblg__id and   ingrvlor > ingrabno Order by prsndpto, oblgdscr;"
//        println("sql: " + sql)

        def res =  cn.rows(sql.toString())
        def ultimo = res.last().depart
        def cont = res.size();

        return [res: res, ultimo: ultimo, cont: cont.toInteger()]
    }

    def reportePendientes(){
                println("params pp " + params)

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from pendientes('${fecha}')"
        println("sql: " + sql)

        def res =  cn.rows(sql.toString())
        def ultimo = res.last().depart
        def cont = res.size();

        return [res: res, ultimo: ultimo, cont: cont.toInteger()]
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


    def pagosPendientes2 () {

        def cn = dbConnectionService.getConnection()
        def fcha = new Date()

        //"select prsndpto depart, prsnnmbr||' '||prsnapll nombre,   coalesce(ingrobsr, '')||' ('||oblgdscr||')' detalle,
        //   ingrvlor - ingrabno por_pagar from prsn, ingr, oblg
        // where prsn.prsn__id = ingr.prsn__id and oblg.oblg__id = ingr.oblg__id and   ingrvlor > ingrabno Order by prsndpto, oblgdscr;"

        def sql = "select * from pendiente('${fcha.format('yyyy-MM-dd')} 23:59')"
        println "sql: $sql"
        def res =  cn.rows(sql.toString())
        def tamano = res.size()
        def max = 54
        def actual = 0

//        println("tamaño " + tamano)

        def fondoTotal = new Color(250, 250, 240);
        def baos = new ByteArrayOutputStream()
        def name = "pagosPendientes_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40,140,180)
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
        document.setMargins(50,30,30,28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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
            tablaHeaderDetalles.setWidths(arregloEnteros([6,20,62,12]))
            def fondo = new Color(240, 240, 240);


            addCellTabla(tablaHeaderDetalles, new Paragraph("Dpto.", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaHeaderDetalles, new Paragraph("Nombre", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaHeaderDetalles, new Paragraph("Detalle", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaHeaderDetalles, new Paragraph("Por Pagar", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])
        }


        def printTotales = {params->

            def tablaTotal = new PdfPTable(2);
            tablaTotal.setWidthPercentage(100);
            tablaTotal.setWidths(arregloEnteros([88,12]))

            addCellTabla(tablaTotal, new Paragraph("Total: ", fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaTotal, new Paragraph("" + params.total, fontThTiny), [border: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])

            addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])

        }

        def currentPag = 1
        def totalPags = Math.ceil(tamano/max)
        def pagActual = 1

        tablaDetalles = new PdfPTable(4);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([6,20,62,12]))
        tablaDetalles.setSpacingAfter(1f);


        def anterior
        def nuevo
        def total = 0
        def contador = 0
        def ultimo = res.last().prsndpto
        def adicionales = 0
        def u = 0

        res.each{fila->

//            println("actual " + actual)
//            println("adicionales " + adicionales)
//            println("pagActual " + pagActual)

            if(actual == 0){
                printHeaderDetalle()
            }

//            if((actual.toInteger() + adicionales.toInteger()) == (max*(pagActual))){
            if((actual.toInteger() + adicionales.toInteger()) >= max){
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

            if(anterior  ==  nuevo){
                if(nuevo ==  ultimo && (tamano.toInteger()) == contador){
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                    total += fila.sldo
                    anterior = fila.prsndpto
                    printTotales([total:total])
                    adicionales ++
                }else{
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                    total += fila.sldo
                    anterior = fila.prsndpto
                }
            }else{
                if(contador == 1){
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                    total += fila.sldo
                    anterior = fila.prsndpto
                }else{
                    if(tamano.toInteger() == contador){
                        printTotales([total:total])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                        total = fila.sldo
                        anterior = fila.prsndpto
                        printTotales([total:fila.sldo])
                        adicionales ++
                    }else{
                        printTotales([total:total])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
                        addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTdTiny), [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, height: 13, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
                        total = fila.sldo
                        anterior = fila.prsndpto
                        adicionales ++
                    }
                }
            }

            actual ++
            u = (actual.toInteger() + adicionales.toInteger())

//            println("--- " + u)
            if(actual <= max){
                pagActual = 1
            }else{
                pagActual = Math.ceil(actual/max).toInteger()
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

    def pagosPendientes3 () {

//        println("params " + params)

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from pendiente('${fecha.format('yyy-MM-dd')}')"
//        println("sql " + sql)

        def res =  cn.rows(sql.toString())
        def tamano = res.size()
//        def max = 54
        def max = 46
        def actual = 0
//        println("tamaño " + tamano)


        def baos = new ByteArrayOutputStream()
        def name = "pagosPendientes_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def titulo = new Color(40,140,180)
        Font fontTitulo = new Font(Font.TIMES_ROMAN, 12, Font.BOLD, titulo);
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
//        document = new Document(PageSize.A4.rotate());
        document = new Document(PageSize.A4);
        document.setMargins(50,30,30,28)  //se 28 equivale a 1 cm: izq, derecha, arriba y abajo
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
            def fondo = new Color(240, 248, 250);
            def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, bg: fondo, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

            def tablaHeaderDetalles = new PdfPTable(4);
            tablaHeaderDetalles.setWidthPercentage(100);
            tablaHeaderDetalles.setWidths(arregloEnteros([10,20,55,15]))

            addCellTabla(tablaHeaderDetalles, new Paragraph("Dpto.", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Nombre", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Detalle", fontTh), frmtHd)
            addCellTabla(tablaHeaderDetalles, new Paragraph("Por Pagar", fontTh), frmtHd)
            addCellTabla(tablaDetalles, tablaHeaderDetalles, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])
        }


        def printTotales = {params->

            def tablaTotal = new PdfPTable(2);
            tablaTotal.setWidthPercentage(100);
            tablaTotal.setWidths(arregloEnteros([85,15]))

            addCellTabla(tablaTotal, new Paragraph("Total: ", fontTh), [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaTotal, new Paragraph("" + params.total, fontTh), [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, height: 15, bg: fondoTotal, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])

            addCellTabla(tablaDetalles, tablaTotal, [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4, pl: 0])

        }

        def currentPag = 1
        def totalPags = Math.ceil(tamano/max)
        def pagActual = 1

        tablaDetalles = new PdfPTable(4);
        tablaDetalles.setWidthPercentage(100);
        tablaDetalles.setWidths(arregloEnteros([10,20,55,15]))
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

        res.each { fila ->
            if (actual == 0) {
                printHeaderDetalle()
            }
            if ((actual.toInteger() + adicionales.toInteger()) >= max) {
//                max = (max + 7)
                max = 52
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


            if(anterior  ==  nuevo){
                if(nuevo ==  ultimo && (tamano.toInteger()) == contador){
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTd10), frmtDato)
                    total += fila.sldo
                    anterior = fila.prsndpto
                    printTotales([total:total])
                    adicionales ++
                }else{
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTd10), frmtDato)
                    total += fila.sldo
                    anterior = fila.prsndpto
                }
            }else{
                if(contador == 1){
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTd10), frmtDato)
                    addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTd10), frmtDato)
                    total += fila.sldo
                    anterior = fila.prsndpto
                }else{
                    if(tamano.toInteger() == contador){
                        printTotales([total:total])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTd10), frmtDato)
                        addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTd10), frmtDato)
                        addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTd10), frmtDato)
                        total = fila.sldo
                        anterior = fila.prsndpto
                        printTotales([total:fila.sldo])
                        adicionales ++
                    }else{
                        printTotales([total:total])
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsndpto, fontTd10), frmtDato)
                        addCellTabla(tablaDetalles, new Paragraph(fila.prsn, fontTd10), frmtDato)
                        addCellTabla(tablaDetalles, new Paragraph(fila.oblg, fontTd10), frmtDato)
                        addCellTabla(tablaDetalles, new Paragraph(fila.sldo.toString(), fontTd10), frmtDato)
                        total = fila.sldo
                        anterior = fila.prsndpto
                        adicionales ++
                    }
                }
            }

            actual ++
            u = (actual.toInteger() + adicionales.toInteger())

//            println("--- " + u)
            if(actual <= max){
                pagActual = 1
            }else{
                pagActual = Math.ceil(actual/max).toInteger()
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

    def fecha_ajax(){

    }


}
