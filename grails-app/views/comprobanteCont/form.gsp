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
                <th style="width: 10%">Valor</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td style="width: 10%">${comprobante?.fecha?.format("dd-MM-yyyy")}</td>
                <td style="width: 20%">${comprobante?.tipo?.descripcion}</td>
                <td style="width: 30%">${comprobante?.descripcion}</td>
                <td style="width: 10%">${comprobante?.numero}</td>
                <td style="width: 10%">${comprobante?.registrado}</td>
                <td style="width: 10%; text-align: right">
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

%{--<g:if test="${}">--}%
%{--    <div class="vertical-container" style="margin-top: 5px; color:black; margin-bottom:20px; height:700px; max-height: 720px; overflow: auto;">--}%
%{--        <p class="css-vertical-text">Asientos</p>--}%

%{--        <div class="linea"></div>--}%

%{--        <div id="divAsientos" class="col-xs-12"style="margin-bottom: 0px ;padding: 0px;margin-top: 5px; height: 650px">--}%
%{--        </div>--}%
%{--    </div>--}%
%{--</g:if>--}%

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

    %{--$("#irProceso").click(function () {--}%
    %{--    location.href='${createLink(controller: 'proceso', action: 'nuevoProceso')}/?id=' + '${proceso?.id}'--}%
    %{--});--}%

    %{--$("#reembolsoN").click(function () {--}%
    %{--    location.href="${createLink(controller: 'proceso', action: 'reembolso')}/?proceso=" + '${proceso?.id}'--}%
    %{--});--}%

</script>

</body>
</html>