package extras;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPCellEvent;
import com.itextpdf.text.pdf.PdfPTable;

/**
 * Created by guido on 12/01/21.
 */
class RoundRectangle implements PdfPCellEvent {
    public void cellLayout(PdfPCell cell, Rectangle rect,
                           PdfContentByte[] canvas) {
        PdfContentByte cb = canvas[PdfPTable.LINECANVAS];
        cb.setLineWidth(0.1);
        cb.setColorStroke(BaseColor.GRAY);
        cb.roundRectangle(
                rect.getLeft() + 1.5f, rect.getBottom() + 1.5f, rect.getWidth() - 3,
                rect.getHeight() - 3, 4);
        cb.stroke();
    }
}

