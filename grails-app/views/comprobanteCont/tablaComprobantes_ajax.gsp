<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Fecha</th>
            <th style="width: 20%">Tipo</th>
            <th style="width: 30%">Descripción</th>
            <th style="width: 15%">Registrado</th>
            <th style="width: 15%">Valor</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<g:if test="${comprobantes.size() > 0}">
    <div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
            <tbody>
            <g:each in="${comprobantes}" var="comprobante">
                <tr data-id="${comprobante?.id}">
                    <td style="width: 10%">${comprobante?.fecha?.format("dd-MM-yyyy")}</td>
                    <td style="width: 10%">${comprobante?.tipo?.descripcion}</td>
                    <td style="width: 10%">${comprobante?.descripcion}</td>
                    <td style="width: 10%">${comprobante?.numero}</td>
                    <td style="width: 10%">${comprobante?.registrado}</td>
                    %{--            <td style="width: 170px">${comprobante?.proceso?.documento}</td>--}%
                    <td style="width: 10%; text-align: right">
                        %{--            <g:formatNumber number="${comprobante?.proceso?.valor}" format="##,##0" locale="ec" maxFractionDigits="2" minFractionDigits="2"/>--}%
                    </td>
                    <td style="width: 10%">

                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</g:if>
<g:else>
    <div class="alert alert-warning" style="margin-top: -20px; text-align: center; font-size: 14px; font-weight: bold"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> No existen registros</div>
</g:else>


<script type="text/javascript">

    // $(function () {
    //     $("tr").contextMenu({
    //         items  : createContextMenu,
    //         onShow : function ($element) {
    //             $element.addClass("trHighlight");
    //         },
    //         onHide : function ($element) {
    //             $(".trHighlight").removeClass("trHighlight");
    //         }
    //     });
    // });
</script>
