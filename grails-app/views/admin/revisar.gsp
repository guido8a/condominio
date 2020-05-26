<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Revisar</title>
    <meta name="layout" content="main">

    <script src="${resource(dir: 'js', file: 'jquery.twbs-toggle-buttons.js')}"></script>
    <script src="${resource(dir: 'js', file: 'TwbsToggleButtons.js')}"></script>

    <style>
    .ui-radio:nth-child(1) .ui-radio-on span.ui-btn-inner{
        background-color:green;
    }
    .ui-radio:nth-child(2) .ui-radio-on span.ui-btn-inner{
        background-color:grey;
    }
    .ui-radio:nth-child(3) .ui-radio-on span.ui-btn-inner{
        background-color:red;
    }​

    </style>

</head>

<body>
<div class="row">
    <div class="col-xs-2" style="top: -15px; height: 35px; margin: 0; width: 230px">
        <h3>Revisión de datos</h3>
    </div>
    <div class="col-xs-1">
        <label>Desde:</label>
    </div>
    <div class="col-xs-2">
        <elm:datepicker name="fechaD_name" id="fechaDesde" class="datepicker form-control" value="${new Date() - 30}" />
    </div>

    <div class="col-xs-1">
        <label>Hasta:</label>
    </div>
    <div class="col-xs-2">
        <elm:datepicker name="fechaH_name" id="fechaHasta" class="datepicker form-control" value="${new Date()}"/>
    </div>

    <div class="col-xs-1" style="width: 105px">
        <a href="#" class="btn btn-verde btnBuscar" ><i class="fa fa-search"></i> Ingresos</a>
    </div>
    <div class="col-xs-1">
        <a href="#" class="btn btn-info btnEgresos" ><i class="fa fa-search"></i> Egresos</a>
    </div>
    <div class="col-xs-1">
        <a href="#" class="btn btn-warning btnGuardar" ><i class="fa fa-save"></i> Guardar</a>
    </div>
</div>

<div class="row" id="divSaldos">

</div>


<script type="text/javascript">

    function cargarIngresos(desde, hasta){
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'admin', action: 'tablaIngresos_ajax')}',
            data:{
                desde: desde,
                hasta: hasta
            },
            success: function (msg) {
                $("#divSaldos").html(msg)
            }
        });
    }

    $(".btnBuscar").click(function () {
        var desde = $("#fechaDesde").val();
        var hasta = $("#fechaHasta").val();
        cargarIngresos(desde, hasta);
    });

    $(".btnEgresos").click(function () {
        var desde = $("#fechaDesde").val();
        var hasta = $("#fechaHasta").val();
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'admin', action: 'tablaEgresos_ajax')}',
            data:{
                desde: desde,
                hasta: hasta
            },
            success: function (msg) {
                $("#divSaldos").html(msg)
            }
        });
    });

</script>


</body>
</html>