<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 01/03/18
  Time: 11:08
--%>


<style type="text/css">
.flotarderecha{
    float: right;

}

.derecha{
    text-align: right;
}
</style>


<div class="row">
    <div class="col-md-1"></div>
    <div class="col-md-8 alert alert-warning">
        <div class="col-md-8">
            <label>Saldo Inicial: </label>
        </div>
        <div class="col-md-2 flotarderecha">
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: data[0].sldoinic ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-1"></div>
    <div class="col-md-8 alert alert-success">
        <div class="col-md-12" style="height: 300px">
            <label>Ingresos</label>

            <table class="table-bordered table-condensed" style="width: 740px">
                <tr style="width:100%;">
                    <th style="width: 10%">Dpto.</th>
                    <th style="width: 15%">Tipo</th>
                    <th style="width: 20%">Persona</th>
                    <th style="width: 22%">Descripción</th>
                    <th style="width: 15%">Fecha</th>
                    <th style="width: 15%">Valor</th>
                    <th style="width: 3%"></th>
                </tr>
            </table>

            <div id="tablaIngresos">
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-1"></div>
    <div class="col-md-8 alert alert-info">
        <div class="col-md-12" style="height: 300px">
            <label>Egresos</label>

            <table class="table-bordered table-condensed" style="width: 740px">
                <tr style="width:100%;">
                    <th style="width: 32%">Proveedor</th>
                    <th style="width: 35%">Descripción</th>
                    <th style="width: 15%">Fecha</th>
                    <th style="width: 15%">Valor</th>
                    <th style="width: 3%"></th>
                </tr>
            </table>

            <div id="tablaEgresos">
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-1"></div>
    <div class="col-md-8 alert alert-warning">
        <div class="col-md-2">
            <label>Saldo a la fecha: </label>
        </div>
        <div class="col-md-2">
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: data[0].sldofnal, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>
        <div class="col-md-2">
            <label style="color: #42a151">Total Ingresos: </label>
        </div>
        <div class="col-md-2">
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: totalIngresos, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>
        <div class="col-md-2">
            <label style="color: #81c7eb">Total Egresos</label>
        </div>
        <div class="col-md-2">
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: totalEgresos, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-10 alert alert-warning">
        <div class="col-md-3">
            <label>Aportes y otras deudas por cobrar:</label>
        </div>
        <div class="col-md-2">
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: data[0].ingrsldo, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>

        <div class="col-md-2">
            <label>Pagos pendientes:</label>
        </div>
        <div class="col-md-2">
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${g.formatNumber(number: data[0].egrssldo, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
        </div>
        <div class="col-md-1">
            <label>Resultado final:</label>
        </div>
        <div class="col-md-2">
            <g:textField  name="saldoTotal_name" value="${g.formatNumber(number: data[0].ingrsldo - data[0].egrssldo, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}" class="form-control derecha" readonly=""/>
        </div>
    </div>
</div>


<script type="text/javascript">

    cargarIngresos('${desde}', '${hasta}');
    cargarEgresos('${desde}', '${hasta}');

    function cargarIngresos (desde, hasta){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'egreso', action: 'tablaIngresos_ajax')}',
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
