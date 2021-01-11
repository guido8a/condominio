package extras;


import java.io.FileOutputStream;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.GrayColor;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPCellEvent;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

class RoundRectangle implements PdfPCellEvent {
    public void cellLayout(PdfPCell cell, Rectangle rect, PdfContentByte[] canvas) {
        PdfContentByte cb = canvas[PdfPTable.LINECANVAS];
        cb.setColorStroke(new GrayColor(0.8f));
//        cb.roundRectangle(rect.left() + 4, rect.bottom(), rect.width() - 8, rect.height() - 4, 4);
        cb.roundRectangle(rect.left() + 2, rect.bottom(), rect.width() -4, rect.height() -2, 2);
        cb.stroke();
    }
}
