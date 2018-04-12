<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Informe</title>
    <meta name="layout" content="main">
</head>

<body>
<div style="text-align: center; margin-top: -30px"><h3>Informe mensual de Aportes y Gastos</h3></div>
<div class="row">
    <div class="btn-group col-xs-2">
        <a href="${createLink(controller: "reportes", action: "index")}" class="btn btn-default">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    <div class="col-xs-2">
        <label>Mes a reportar:</label>
    </div>
    <div class="col-xs-2">
        <g:select from="${['01':'Enero',  '02':'Febrero', '03':'Marzo', '04':'Abril', '05':'Mayo', '06':'Junio',
                           '07':'Julio' , '08':'Agosto' , '09':'Septiembre' , '10':'Octubre', '11':'Noviembre',
                           '12':'Diciembre']}" optionValue="value" optionKey="key" name="mesesHasta_name"
                  id="mesesHasta" class="form-control"/>
    </div>

    <div class="col-xs-1">
        <label>Año:</label>
    </div>

    <div class="col-xs-2">
        <g:select from="${anios}" name="anio_name" id="anio" class="form-control"/>
    </div>

    <div class="col-xs-1">
        <a href="#" class="btn btn-info btnBuscar" ><i class="fa fa-search"></i> Buscar</a>
    </div>

    <div class="col-xs-2">
        <a href="#" id="btnImprimir" class="btn btn-warning" >
            <i class="fa fa-print"></i> Imprimir Detalle
        </a>

    </div>
</div>


<div id="divDetalle">

</div>


<script type="text/javascript">

    $("#btnImprimir").click(function () {
        var mes = $("#mesesHasta").val();
        var anio = $("#anio").val();

        location.href='${createLink(controller: 'reportes', action: 'imprimirReporteGeneral')}?mes=' + mes + "&anio=" + anio

    });

    $(".btnBuscar").click(function () {
        var mes = $("#mesesHasta").val();
        var anio = $("#anio").val();
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'reportes', action: 'detalle_ajax')}',
            data:{
                mes: mes,
                anio: anio
            },
            success: function (msg) {
                $("#divDetalle").html(msg)
            }
        });
    });

</script>


</body>
</html>