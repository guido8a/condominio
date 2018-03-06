<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 01/03/18
  Time: 10:59
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Saldos</title>
    <meta name="layout" content="main">
</head>

<body>
<div class="row">
    <div class="col-md-2">
        <label>Fecha desde:</label>
    </div>
    <div class="col-md-2">
        <elm:datepicker name="fecha_name" id="fecha" class="datepicker form-control" value="${new Date()}"/>
    </div>

    <div class="col-md-1">
        <label>Fecha Fin:</label>
    </div>
    <div class="col-md-2">
        <elm:datepicker name="fecha_name" id="fecha" class="datepicker form-control" value="${new Date()}"/>
    </div>

    <div class="col-md-2">
        <a href="#" class="btn btn-info btnBuscar" ><i class="fa fa-search"></i> Buscar</a>
    </div>
</div>

<div class="row" id="divSaldos">

</div>


<script type="text/javascript">

    $(".btnBuscar").click(function () {
        var fecha = $(this).val();
        $.ajax({
          type: 'POST',
            url:'${createLink(controller: 'egreso', action: 'tablaSaldos_ajax')}',
            data:{
                fecha: fecha
            },
            success: function (msg) {
                $("#divSaldos").html(msg)
            }
        });
    });

</script>


</body>
</html>