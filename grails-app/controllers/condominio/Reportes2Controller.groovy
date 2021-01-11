package condominio

import com.lowagie.text.*
import com.lowagie.text.pdf.PdfContentByte
import com.lowagie.text.pdf.PdfPCell
import com.lowagie.text.pdf.PdfPTable
import com.lowagie.text.pdf.PdfWriter
import extras.RoundRectangle

import java.awt.*

class Reportes2Controller {

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

    private static void addEmptyLine(Paragraph paragraph, int number) {
        for (int i = 0; i < number; i++) {
            paragraph.add(new Paragraph(" "));
        }
    }


    /* caja redondeada */

    def poneCelda(txto, align, font, colspan) {
        RoundRectangle borde = new RoundRectangle();
        PdfPCell celda;
        celda = new PdfPCell(new Paragraph(txto, font))
        celda.setHorizontalAlignment(align);
        celda.setBorder(Rectangle.NO_BORDER);
        celda.setPadding(4);
        celda.setCellEvent(borde);
        celda.setColspan(colspan)
        celda
    }
    


    def comprobante() {

        def baos = new ByteArrayOutputStream()
        def condominio = Condominio.get(session.condominio.id)
        def comprobante = Comprobante.get(params.comp)

        def titulo = new Color(40, 140, 180)
        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font nota = new Font(Font.TIMES_ROMAN, 8, Font.ITALIC)
        Font notaTitulo = new Font(Font.TIMES_ROMAN, 11, Font.BOLD)
        Font fontTitle = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTh = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTd10 = new Font(Font.TIMES_ROMAN, 8, Font.BOLD);
        Font fontThTiny = new Font(Font.TIMES_ROMAN, 7, Font.BOLD);
        Font fontTdTiny = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL, Color.RED);
        Font fontTdRojo = new Font(Font.TIMES_ROMAN, 14, Font.BOLD, Color.RED);
        def frmtHd = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def frmtHd2 = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, colspan: 2]
        def frmtDato = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def frmtHdr = [border: Color.LIGHT_GRAY, bwb: 0.1, bcb: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def frmtDatoDere = [bwt: 0.1, bct: Color.BLACK, bwb: 0.1, bcb: Color.BLACK, border: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def fondoTotal = new Color(240, 240, 240);

        def prmsTdNoBorder = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        Document document
        document = new Document(PageSize.A5.rotate());
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

        /**/
        def tablaTitl = new PdfPTable(2);
        tablaTitl.setWidthPercentage(100);
        tablaTitl.setWidths(arregloEnteros([64,36]))

        tablaTitl.defaultCell.border  = PdfPCell.NO_BORDER;
        tablaTitl.defaultCell.cellEvent = new RoundRectangle();

        addCellTabla(tablaTitl, new Paragraph("CONJUNTO RESIDENCIAL 'LOS VIÑEDOS'", fontTh), prmsTdNoBorder)
        tablaTitl.addCell(poneCelda("COMPROBANTE DE PAGO\n${comprobante?.numero}", Element.ALIGN_CENTER, fontTh,1));
        def tx_titl = "Dirección: ${condominio?.direccion} \n Teléfono: ${condominio?.telefono?.toString()}\nQuito-Ecuador"

        addCellTabla(tablaTitl, new Paragraph(tx_titl, fontTd), prmsTdNoBorder)
        tablaTitl.addCell(poneCelda("R.U.C. ${condominio?.ruc}\n\nFecha: ${comprobante.pago.fechaPago.format('dd-MMM-yyyy')}",
                Element.ALIGN_CENTER, fontTd,1))
        document.add(tablaTitl)
        /**/

        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 2);
        document.add(preface);

        def tablaDatos = new PdfPTable(4);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([15,50,15, 20]))

//        addCellTabla(tablaDatos, new Paragraph("Recibí de : ", fontTd10), frmtHd)
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

        document.add(tablaDatos)

        Paragraph preface2 = new Paragraph();
        addEmptyLine(preface2, 1);
        document.add(preface2);

        def tablaValores = new PdfPTable(3);
        tablaValores.setWidthPercentage(100);
        tablaValores.setWidths(arregloEnteros([20,60,20]))

        def txto = (comprobante?.pago?.observaciones ?: '') + " (${comprobante.pago.ingreso.obligacion.tipoAporte.descripcion})"
        println "txto: $txto"
        tablaValores.addCell(poneCelda("Por concepto de : ", Element.ALIGN_RIGHT, fontTd,1))
        tablaValores.addCell(poneCelda(txto, Element.ALIGN_LEFT, fontTd,1))
        txto = g.formatNumber(number:comprobante?.pago?.valor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString()
        tablaValores.addCell(poneCelda(txto, Element.ALIGN_CENTER, fontTd,1))
//        addCellTabla(tablaValores, new Paragraph(g.formatNumber(number:comprobante?.pago?.valor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString(), fontTd10), frmtHd)

        tablaValores.addCell(poneCelda("Total \$ ", Element.ALIGN_RIGHT, fontTd10, 2))
        txto = g.formatNumber(number:comprobante?.pago?.valor, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'en_US').toString()
        tablaValores.addCell(poneCelda(txto, Element.ALIGN_CENTER, fontTd10,1))

        document.add(tablaValores)

        if(comprobante.estado == 'A'){
            Paragraph h1 = new Paragraph();
            addEmptyLine(h1, 1);
            document.add(h1)

            Paragraph h = new Paragraph();
            h.setAlignment(Element.ALIGN_CENTER);
            h.add(new Paragraph("ANULADO", fontTdRojo))
            document.add(h)
        }

        Paragraph a = new Paragraph();
        addEmptyLine(a, comprobante?.estado == 'A' ? 1 : 2);

        document.add(a)
        Paragraph f = new Paragraph();
        f.setAlignment(Element.ALIGN_CENTER);
        f.add(new Paragraph("Ing. Guido Ochoa Moreno", info))
        f.add(new Paragraph("ADMINISTRADOR", info))
        f.add(new Paragraph("Cel: 0984916620, dpto. 214", info))
        document.add(f)

        Paragraph a1 = new Paragraph();
        addEmptyLine(a1, 2);
        document.add(a1)

        Paragraph t4 = new Paragraph();
        t4.setAlignment("Justify");
        t4.add(new Paragraph("Nota: Sr. Copropietario y/o arrendatario pague su cuota condominal los 5 primeros días de cada mes, caso contrario se cobrará % intereses por mora, aprobado en la asamblea de Copropietarios.", nota))
        document.add(t4)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=comprobantePago_${comprobante?.pago?.ingreso?.persona?.nombre + " " + comprobante?.pago?.ingreso?.persona?.apellido}_${new Date().format("dd-MM-yyyy")}")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

}
