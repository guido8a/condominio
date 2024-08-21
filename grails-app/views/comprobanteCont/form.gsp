<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Comprobante</title>
</head>

<body>

<div class="btn-group" style="margin-bottom: 10px">
    <g:link class="btn btn-info" controller="comprobanteCont" action="list">
        <i class="fa fa-chevron-left"></i>
        Lista de comprobantes
    </g:link>
</div>

<div class="alert alert-info">
    <div role="main" style="margin-top: 10px;">
        <table class="table table-bordered table-striped table-condensed">
            <thead>
            <tr>
                <th colspan="6" style="text-align: center">
                    Comprobante
                </th>
            </tr>
            <tr>
                <th style="width: 10%">Fecha</th>
                <th style="width: 20%">Tipo</th>
                <th style="width: 30%">Descripción</th>
                <th style="width: 10%">Número</th>
                <th style="width: 10%">Registrado</th>
            </tr>
            </thead>
            <tbody>
            <tr style="font-weight: bold">
                <td style="width: 10%">${comprobante?.fecha?.format("dd-MM-yyyy")}</td>
                <td style="width: 20%">${comprobante?.tipo?.descripcion}</td>
                <td style="width: 30%">${comprobante?.descripcion}</td>
                <td style="width: 10%">${comprobante?.numero}</td>
                <td style="width: 10%; background-color: ${comprobante?.registrado == 'N' ? '#ffcc3b' : '#5e9cff'}  ">${comprobante?.registrado == 'N' ? 'No registrado' : 'Registrado'}</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<div id="divAsientos">

</div>

<script type="text/javascript">

    cargarAsientos('${comprobante?.id}');

    function cargarAsientos(comprobante) {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'comprobanteCont',action: 'asientos_ajax')}",
            data: {
                id: comprobante
            },
            success: function (msg) {
                $("#divAsientos").html(msg);
            }
        });
    }

</script>

</body>
</html>