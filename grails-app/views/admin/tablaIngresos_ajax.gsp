<style type="text/css">
.flotarderecha{
    float: right;

}

.derecha{
    text-align: right;
}
</style>


<div class="row">
    <div class="col-xs-12 alert alert-success">
        <div class="col-xs-12" style="height: 600px">
            <label>Ingresos</label>

            <table class="table-bordered table-condensed" style="width: 100%">
                <tr style="width:100%;">
                    <th style="width: 5%">Dpto.</th>
                    <th style="width: 15%">Persona</th>
                    <th style="width: 12%">Ocupante</th>
                    <th style="width: 15%">Descripción de Ingreso</th>
                    <th style="width: 9%">Fecha</th>
                    <th style="width: 9%">Valor</th>
                    <th style="width: 7%">Doc.</th>
                    <th style="width: 4%; text-align: center" title="Revisado (Correcto)"><i class="fa fa-check-square"></i></th>
                    <th style="width: 4%; text-align: center" title="Corregir valor"><i class="fa fa-edit"></th>
                    <th style="width: 4%; text-align: center" title="Borrar"><i class="fa fa-trash"></th>
                    <th style="width: 13%" title="Comentario">Comentario</th>
                    <th style="width: 3%"></th>
                </tr>
            </table>

            <g:if test="${ingresos.size() > 0}">
                <div class="" style="width: 100%;height: 560px; overflow-y: auto;float: right;" >
                    <table class="table-bordered table-condensed table-hover" width="98%">
                        <g:each in="${ingresos}" var="ingreso">
                            <tr style="width: 100%">
                                <td style="width: 5%">${ingreso.prsndpto}</td>
                                <td style="width: 15%">${ingreso.prsn}</td>
                                <td style="width: 12%">${ingreso.tpocdscr}</td>
                                <td style="width: 15%">${ingreso.pagodscr}</td>
                                <td style="width: 9%">${ingreso.pagofcha}</td>
                                <td class="derecha" style="width: 9%">${ingreso.pagovlor}</td>
                                <td class="derecha" style="width: 7%">${ingreso.pagodcmt}</td>
                            <td style="text-align: center; width: 4%" class="chk">
                                <g:if test="${ingreso?.prsn == 'R'}">
                                    <i class="icon-ok"></i>
                                </g:if>
                                <g:else>
                                    <input type="radio" name="rd${ingreso.pago__id}"/>
                                </g:else>
                            </td> 
                            <td style="text-align: center; width: 4%" class="chk">
                                <g:if test="${ingreso?.prsn == 'R'}">
                                    <i class="icon-ok"></i>
                                </g:if>
                                <g:else>
                                    <input type="radio" name="rd${ingreso.pago__id}"/>
                                </g:else>
                            </td>
                            <td style="text-align: center; width: 4%" class="chk">
                                <g:if test="${ingreso?.prsn == 'R'}">
                                    <i class="icon-ok"></i>
                                </g:if>
                                <g:else>
                                    <input type="radio" name="rd${ingreso.pago__id}"/>
                                </g:else>
                            </td>
                                <td class="derecha" style="width: 13%"><input type="text" class="form-control-sm"
                                   style="width: 100%"/></td>
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
