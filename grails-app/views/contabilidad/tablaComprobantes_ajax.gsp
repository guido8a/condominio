<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 20/09/17
  Time: 12:31
--%>




<table class="table table-bordered table-hover table-condensed"  style="width: 1070px" id="tabla">
    <tbody>
    <g:each in="${comprobantes}" var="comprobante">
        <tr data-id="${comprobante?.proceso?.id}">
            <td style="width: 100px">${comprobante?.fecha?.format("dd-MM-yyyy")}</td>
            <td style="width: 100px">${comprobante?.tipo?.descripcion}</td>
            <td style="width: 500px">${comprobante?.descripcion}</td>
            <td style="width: 170px">${comprobante?.proceso?.documento}</td>
            <td style="width: 200px; text-align: right"><g:formatNumber number="${comprobante?.proceso?.valor}" format="##,##0" locale="ec" maxFractionDigits="2" minFractionDigits="2"/></td>
        </tr>
    </g:each>
    </tbody>
</table>

<script type="text/javascript">

    $(function () {
        $("tr").contextMenu({
            items  : createContextMenu,
            onShow : function ($element) {
                $element.addClass("trHighlight");
            },
            onHide : function ($element) {
                $(".trHighlight").removeClass("trHighlight");
            }
        });
    });
</script>
