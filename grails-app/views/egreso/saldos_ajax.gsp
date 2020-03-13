<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 01/03/18
  Time: 10:59
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Ingresos, Egresos y Saldos</title>
    <meta name="layout" content="main">
</head>

<body>
<div class="row">
    <div class="col-xs-4" style="top: -15px; height: 35px;">
        <h3>Ingresos, Egresos y Saldos</h3>
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

    <div class="col-xs-1">
        <a href="#" class="btn btn-info btnBuscar" ><i class="fa fa-search"></i> Buscar</a>
    </div>
</div>

<div class="row" id="divSaldos">

</div>


<script type="text/javascript">

    $(".btnBuscar").click(function () {
        var desde = $("#fechaDesde").val();
        var hasta = $("#fechaHasta").val();
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'egreso', action: 'tablaSaldos_ajax')}',
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