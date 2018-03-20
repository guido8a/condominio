<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/03/18
  Time: 11:14
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="movil">
    %{--<meta name="layout" content="login">--}%
    <title>Pagos y Saldos Personales</title>

    <style type="text/css">

    .derecha{
        text-align: right;
    }

    </style>
</head>

<body>

<div class="row alert alert-info" style="margin-top:-1%">
    <div class="col-xs-5">
        <label><i class="fa fa-child"></i> ${(data[0].prsnnmbr ?: '') + " " + (data[0].prsnapll ?: '')}</label>
    </div>
    <div class="col-xs-4">
        <label><i class="fa fa-building"></i> ${data[0].edifdscr}</label>
    </div>
    <div class="col-xs-3">
        <label><i class="fa fa-columns"></i> ${data[0].prsndpto}</label>
    </div>
</div>

%{--
<div class="row alert alert-info">
    <div class="col-sm-1"></div>
    <div class="col-sm-3">
        <h3 style="color: #669aba"><i class="fa fa-child"></i> ${(data[0].prsnnmbr ?: '') + " " + (data[0].prsnapll ?: '')}</h3>
    </div>
    <div class="col-sm-3">
        <h3 style="color: #669aba"><i class="fa fa-building"></i> ${"Torre:" + data[0].edifdscr}</h3>
    </div>
    <div class="col-sm-3">
        <h3 style="color: #669aba"><i class="fa fa-columns"></i> ${"Departamento: " + data[0].prsndpto}</h3>
    </div>
</div>
--}%



<div class="row" style="text-align: center">
%{--
    <div class="col-md-3 col-xs-3 derecha">
        <label>Fecha:</label>
    </div>
--}%
    <div class="col-md-2 col-xs-6" style="margin-left: 0">
        <elm:datepicker name="fechaH_name" id="fechaHasta" class="datepicker form-control" value="${new Date()}"/>
    </div>
    <div class="col-sm-3 col-xs-6">
        <a href="#" class="btn btn-info btnBuscar" ><i class="fa fa-search"></i>Ver pendientes</a>
    </div>

</div>

<div class="row">
</div>

<div class="row alert alert-warning" style="margin-top: 10px">
    <div class="col-xs-6">
        <label>Alícuota: </label>
        <label class="text-info">${data[0].alctvlor}</label>
        %{--<g:textField name="saldo_name" class="form-control" readonly=""--}%
                     %{--value="${data[0].alctvlor}"/>--}%
    </div>

    <div class="col-xs-6">
        <label>por pagar: </label>
        <label class="${data[0].prsnsldo > 0 ? 'text-danger' : 'text-info'}">${data[0].prsnsldo}</label>
        %{--<g:textField name="saldo_name" class="form-control" readonly=""--}%
                     %{--value="${data[0].prsnsldo}"/>--}%
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