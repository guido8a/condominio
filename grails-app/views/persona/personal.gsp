<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/03/18
  Time: 11:14
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Pagos y Saldos Personales</title>

    <style type="text/css">

    .derecha{
        text-align: right;
    }

    </style>
</head>

<body>

<div class="row alert alert-info">
    <div class="col-md-1"></div>
    <div class="col-md-3">
        <h3 style="color: #669aba"><i class="fa fa-child"></i> ${(data[0].prsnnmbr ?: '') + " " + (data[0].prsnapll ?: '')}</h3>
    </div>
    <div class="col-md-3">
        <h3 style="color: #669aba"><i class="fa fa-building"></i> ${"Torre:" + data[0].edifdscr}</h3>
    </div>
    <div class="col-md-3">
        <h3 style="color: #669aba"><i class="fa fa-columns"></i> ${"Departamento: " + data[0].prsndpto}</h3>
    </div>
</div>



<div class="row">
    %{--<div class="col-xs-2">--}%
    %{--<label>Fecha Desde:</label>--}%
    %{--</div>--}%
    %{--<div class="col-xs-2">--}%
    %{--<elm:datepicker name="fechaD_name" id="fechaDesde" class="datepicker form-control" value="${new Date() - 30}" />--}%
    %{--</div>--}%
    <div class="col-md-3"></div>
    <div class="col-md-2">
        <label>Deudas a la fecha:</label>
    </div>
    <div class="col-md-2">
        <elm:datepicker name="fechaH_name" id="fechaHasta" class="datepicker form-control" value="${new Date()}"/>
    </div>

    <div class="col-md-2">
        <a href="#" class="btn btn-info btnBuscar" ><i class="fa fa-search"></i> Buscar</a>
    </div>
</div>


<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-7 alert alert-warning">
        <div class="col-md-2">
            <label>Alícuota:</label>
        </div>
        <div class="col-md-3">

            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${data[0].alctvlor}"/>
        </div>
        <div class="col-md-2">
            <label>Saldo Total:</label>
        </div>
        <div class="col-md-3">
            <g:textField name="saldo_name" class="form-control derecha" readonly=""
                         value="${data[0].prsnsldo}"/>
        </div>
    </div>
</div>

<div id="divDeudas">

</div>


<script type="text/javascript">

    $(".btnBuscar").click(function () {
        var fecha = $("#fechaHasta").val();
        cargarDeudas(fecha);
    });

    cargarDeudas($("#fechaHasta").val());

    function cargarDeudas (fecha) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'persona', action: 'deudas_ajax')}',
            data:{
                fecha:fecha
            },
            success: function (msg){
                $("#divDeudas").html(msg)
            }
        });
    }


</script>

</body>
</html>