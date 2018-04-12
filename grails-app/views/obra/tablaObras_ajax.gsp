<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 11/04/18
  Time: 12:33
--%>

<g:if test="${obras?.size() > 0}">
    <div class="" style="width: 99.7%;height:375px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1060px">
        <g:each in="${obras}" var="obra">
            <tr data-id="${obra?.id}">
                <td style="width: 15%">${obra?.tipoObra?.descripcion}</td>
                <td style="width: 25%">${obra?.descripcion}</td>
                <td style="width: 15%">${obra?.proveedor?.nombre + " " + (obra?.proveedor?.apellido ? obra?.proveedor?.apellido : '')}</td>
                <td style="width: 15%">${obra?.persona?.nombre + " " + obra?.persona?.apellido}</td>
                <td style="width: 10%">${obra?.fecha?.format("dd-MM-yyyy")}</td>
                <td style="width: 20%">${obra?.observaciones}</td>
            </tr>
        </g:each>
    </table>
    </div>
</g:if>
<g:else>
    <div class="alert alert-danger"  style="text-align: center">
        <i class='fa fa-exclamation-circle fa-2x text-danger text-shadow'></i> No existen resultados para su búsqueda.
    </div>
</g:else>

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