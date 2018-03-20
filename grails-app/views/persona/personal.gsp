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



<div class="row">
    <div class="col-md-2 col-xs-2">
        <label>Deudas a la fecha:</label>
    </div>
    <div class="col-md-2 col-xs-2">
        <elm:datepicker name="fechaH_name" id="fechaHasta" class="datepicker form-control" value="${new Date()}"/>
    </div>
</div>

<div class="row">
    <div class="col-sm-2 col-xs-2">
        <a href="#" class="btn btn-info btnBuscar" ><i class="fa fa-search"></i> Buscar</a>
    </div>
</div>

<div class="row col-xs-6 alert alert-warning" style="margin-top: 10px">
    <div class="col-xs-4">
        <label>Alícuota:</label>
        <g:textField name="saldo_name" class="form-control" readonly=""
                     value="${data[0].alctvlor}"/>
    </div>

    <div class="col-xs-4">
        <label>Saldo Total:</label>
        <g:textField name="saldo_name" class="form-control" readonly=""
                     value="${data[0].prsnsldo}"/>
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