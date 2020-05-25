<style type="text/css">
.flotarderecha{
    float: right;

}

.derecha{
    text-align: right;
}
</style>


<div class="row">
    %{--<div class="col-xs-1"></div>--}%
    <div class="col-xs-12 alert alert-info">
        <div class="col-xs-12" style="height: 600px">
            <label>Egresos</label>

            <table class="table-bordered table-condensed" style="width: 100%">
                <tr style="width:100%;">
                    <th style="width: 35%">Proveedor</th>
                    <th style="width: 40%">Descripción</th>
                    <th style="width: 10%">Fecha</th>
                    <th style="width: 10%">Valor</th>
                    <th style="width: 3%"></th>
                </tr>
            </table>

        %{--<div id="tablaEgresos"></div>--}%

            <g:if test="${egresos.size() > 0}">
                <div class="" style="width: 100%;height: 560px; overflow-y: auto;float: right;" >
                    <table class="table-bordered table-condensed table-hover" width="98%">
                        <g:each in="${egresos}" var="egreso">
                            <tr style="width: 100%">
                                <td style="width: 35%">${egreso.prve}</td>
                                <td style="width: 40%">${egreso.egrsdscr}</td>
                                <td style="width: 10%">${egreso.egrsfcha}</td>
                                <td class="derecha" style="width: 10%">${egreso.egrsvlor}</td>
                            </tr>
                        </g:each>
                    </table>
                </div>
            </g:if>
            <g:else>
                <div class="alert alert-danger" style="text-align: center; margin-top: 15px">
                    No existen datos!
                </div>
            </g:else>

        </div>
    </div>
</div>


<script type="text/javascript">

    %{--cargarIngresos('${desde}', '${hasta}');--}%
    %{--cargarEgresos('${desde}', '${hasta}');--}%

    /*
     function cargarIngresos (desde, hasta){
     $.ajax({
     type: 'POST',
     url: "${createLink(controller: 'egreso', action: 'tablaIngresos_ajax')}",
     async: true,
     data:{
     desde: desde,
     hasta: hasta
     },
     success: function (msg){
     $("#tablaIngresos").html(msg)
     }
     })
     }
     */

    function cargarEgresos (desde, hasta){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'egreso', action: 'tablaEgresos_ajax')}',
            async: true,
            data:{
                desde: desde,
                hasta: hasta
            },
            success: function (msg){
                $("#tablaEgresos").html(msg)
            }
        })
    }




</script>
