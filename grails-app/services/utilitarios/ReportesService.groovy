package utilitarios

import com.lowagie.text.Document
import com.lowagie.text.Element
import com.lowagie.text.Font
import com.lowagie.text.PageSize
import com.lowagie.text.Paragraph
import com.lowagie.text.Rectangle
import com.lowagie.text.pdf.PdfContentByte
import com.lowagie.text.pdf.PdfImportedPage
import com.lowagie.text.pdf.PdfPTable
import com.lowagie.text.pdf.PdfReader
import com.lowagie.text.pdf.PdfWriter

import java.awt.Color



class ReportesService {

    boolean transactional = true

    def encabezado (titulo, subtitulo, fontTitulo, fontSub) {
        Paragraph preface = new Paragraph();
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph(titulo, fontTitulo));
        preface.add(new Paragraph(subtitulo, fontSub));
        return preface
    }

    def numeracion(x, y) {
        PdfPTable table = new PdfPTable(2);
        table.setTotalWidth(327);
        table.setLockedWidth(true);
        table.getDefaultCell().setFixedHeight(20);
        table.getDefaultCell().setBorder(Rectangle.NO_BORDER);
        table.addCell("");
        table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(String.format("Página %d de %d", x, y));
        return table;
    }
}
