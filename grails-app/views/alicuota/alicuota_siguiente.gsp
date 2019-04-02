<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 28/03/19
  Time: 15:45
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Alícuota</title>
</head>

<body>

<div class="row">
    <div class="col-xs-12 col-md-12">
        <div class="col-md-1">
            <label>Valor total :</label>
        </div>
        <div class="col-xs-2 col-md-2" style="padding: 5px;">
            <g:textField name="valor_name" id="valor" class="form-control derecha number"
                         value="${g.formatNumber(number: 0, format: '##,##0', maxFractionDigits: 0, minFractionDigits: 0, locale: 'en_US')}"/>
        </div>

        <div class="btn-group col-md-2" style="margin-top: 7px; margin-left: -2px">
            <a href="#" class="btn btn-azul" id="btn-alicuotas"><i class="fa fa-search"></i> Generar Alícuotas</a>
        </div>

        <div class="btn-group col-md-4" style="margin-left: 5px; margin-top: 7px">

            <div class="col-md-6">
                <g:select name="meses_name" from="${lista}"
                          optionKey="key" optionValue="value" id="meses" class="form-control"/>
            </div>

            <g:datePicker name="fecha_name" value="${new Date()}" id="fecha" precision="year"
                          noSelection="['':'-Seleccione-']" relativeYears="[0..2]" class="form-control"/>

        </div>
        <div class="btn-group col-md-1" style="margin-top: 7px;">
            <a href="#" class="btn btn-success btn-guardar" style="margin-left: 5px"><i class="fa fa-save"></i> Guardar</a>
        </div>

    </div>
</div>


<table class="table-bordered table-condensed" style="width: 100%">
    <tr style="width:100%;">
        <th style="width: 17%">Dpto.</th>
        <th style="width: 20%">Nombre</th>
        <th style="width: 20%">Apellido</th>
        <th style="width: 15%">Alícuota Actual</th>
        <th style="width: 15%">Alícuota Calculada</th>
        <th style="width: 10%">Diferencia</th>
        <th style="width: 3%"></th>
    </tr>
</table>

<div id="tablaAlicuotasNuevas">

</div>

<script type="text/javascript">


    $(".btn-guardar").click(function () {
        var fecha = $("#fecha_year").val();
        var valor = $("#valor").val();
        var mes = $("#meses option:selected").val();
        bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea guardar las alícuotas generadas a la fecha: " + '<strong>' +
            (mes == '1' ? 'ENERO' : mes == '2' ? 'FEBRERO' : mes == '3' ? 'MARZO' : mes == '4' ? 'ABRIL' : mes == '5' ? 'MAYO' : mes == '6' ? 'JUNIO' : mes == '7' ? 'JULIO' : mes == '8' ? 'AGOSTO' : mes == '9' ? 'SEPTIEMBRE'
            : mes == '10' ? 'OCTUBRE' : mes == '11' ? 'NOVIEMBRE' : mes == '12' ? 'DICIEMBRE' : '') + " - " + fecha + '</strong>' + "?", function (res) {
            if (res) {
                openLoader("Guardando alícuotas");
                $.ajax({
                    type    : "POST",
                    url : "${createLink(controller:'alicuota', action:'guardarAlicuotas_ajax')}",
                    data    : {
                        fecha: fecha,
                        valor: valor,
                        mes: mes
                    },
                    success : function (msg) {
                        if(msg == 'ok'){
                            closeLoader();
                            log("Alícuotas guardadas correctamente","success");
                            setTimeout(function() {
                                location.reload(true);
                            }, 1000);
                        }else{
                            closeLoader();
                            log("Error al guardar las alícuotas ","error")
                        }
                    }
                });
            }
        });
    });

    $("#btn-alicuotas").click(function () {
        cargarTabla();
    });

    function cargarTabla() {
        var valor = $("#valor").val();
        $.ajax({
            type:'POST',
            url: "${createLink(controller: 'alicuota', action: 'tablaAlicuotasNuevas_ajax')}",
            data:{
                valor: valor
            },
            success: function (msg){
                $("#tablaAlicuotasNuevas").html(msg)
            }
        });
    }

</script>


</body>
</html>