<style type="text/css">
.flotarderecha{
    float: right;

}

.derecha{
    text-align: right;
}
</style>


<div class="row">
    <div class="col-xs-12 alert alert-warning">
        <div class="col-xs-1" style="padding: 5px; width: 140px">
            <label>Saldo Inicial:</label>
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: data[0].sldoinic ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>

        <div class="col-xs-1" style="padding: 5px; width: 140px">
            <label style="color: #42a151">Total Ingresos:</label>
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: totalIngresos, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>

        <div class="col-xs-1" style="padding: 5px; width: 140px">
            <label style="color: #a34a23">Total Egresos</label>
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: totalEgresos, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>

        <div class="col-xs-1" style="padding: 5px; width: 140px">
            <label>Saldo a la fecha:</label>
            <strong><g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: data[0].sldofnal, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
            </strong>
        </div>


        <div class="col-xs-2" style="padding: 5px; width: 140px; margin-left: 120px">
            <label>Valores por cobrar:</label>
            <g:textField name="saldo_name" class="form-control derecha" readonly="" style="color: #804040"
                         value="${g.formatNumber(number: data[0].ingrsldo, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>

        <div class="col-xs-1" style="padding: 5px; width: 140px">
            <label>Pagos pendientes:</label>
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: data[0].egrssldo, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>
        <div class="col-xs-1" style="padding: 5px; width: 140px">
            <label>Resultado final:</label>
            <strong>
                <g:textField  name="saldoTotal_name" class="form-control derecha" readonly=""
                              value="${g.formatNumber(number: data[0].ingrsldo + data[0].sldofnal - data[0].egrssldo, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
            </strong>
        </div>
    </div>
</div>

<div class="row">
    %{--<div class="col-xs-1"></div>--}%
    <div class="col-xs-12 alert alert-success">
        <div class="col-xs-12" style="height: 300px">
            <label>Ingresos</label>

            <table class="table-bordered table-condensed" style="width: 100%">
                <tr style="width:100%;">
                    <th style="width: 10%">Dpto.</th>
                    <th style="width: 20%">Persona</th>
                    <th style="width: 12%">Ocupante</th>
                    <th style="width: 30%">Descripción de Ingreso</th>
                    <th style="width: 12%">Fecha</th>
                    <th style="width: 13%">Valor</th>
                    <th style="width: 3%"></th>
                </tr>
            </table>

            <g:if test="${ingresos.size() > 0}">
                <div class="" style="width: 100%;height: 260px; overflow-y: auto;float: right;" >
                    <table class="table-bordered table-condensed table-hover" width="98%">
                        <g:each in="${ingresos}" var="ingreso">
                            <tr style="width: 100%">
                                <td style="width: 10%">${ingreso.prsndpto}</td>
                                <td style="width: 20%">${ingreso.prsn}</td>
                                <td style="width: 12%">${ingreso.tpocdscr}</td>
                                <td style="width: 30%">${ingreso.pagodscr}</td>
                                <td style="width: 12%">${ingreso.pagofcha}</td>
                                <td class="derecha" style="width: 13%">${ingreso.pagovlor}</td>
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
</div>

<div class="row">
    %{--<div class="col-xs-1"></div>--}%
    <div class="col-xs-12 alert alert-info">
        <div class="col-xs-12" style="height: 300px">
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
                <div class="" style="width: 100%;height: 260px; overflow-y: auto;float: right;" >
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
