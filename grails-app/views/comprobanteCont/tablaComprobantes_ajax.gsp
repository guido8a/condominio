<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Fecha</th>
            <th style="width: 20%">Tipo</th>
            <th style="width: 30%">Descripción</th>
            <th style="width: 10%">Número</th>
            <th style="width: 10%">Registrado</th>
            <th style="width: 20%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<g:if test="${comprobantes.size() > 0}">
    <div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
            <tbody>
            <g:each in="${comprobantes}" var="comprobante">
                <tr data-id="${comprobante?.id}">
                    <td style="width: 10%">${comprobante?.fecha?.format("dd-MM-yyyy")}</td>
                    <td style="width: 20%">${comprobante?.tipo?.descripcion}</td>
                    <td style="width: 30%">${comprobante?.descripcion}</td>
                    <td style="width: 10%">${comprobante?.numero}</td>
                    <td style="width: 10%; background-color: ${comprobante?.registrado == 'N' ? '#ffcc3b' : '#5e9cff'} ">${comprobante?.registrado == 'N' ? 'No registrado' : 'Registrado'}</td>
                    <td style="width: 20%; text-align: center">
                        <a href="#" data-id="${comprobante.id}" class="btn btn-info btn-sm btnVerComprobante" title="Ir a comprobante">
                            <i class="fa fa-laptop"></i>
                        </a>
                        <a href="#" data-id="${comprobante.id}" class="btn btn-success btn-sm btnEditarComprobante" title="Editar comprobante">
                            <i class="fa fa-pencil"></i>
                        </a>
                        <a href="#" data-id="${comprobante.id}" class="btn btn-danger btn-sm btnBorrarComprobante" title="Borrar comprobante">
                            <i class="fa fa-trash"></i>
                        </a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</g:if>
<g:else>
    <div class="alert alert-warning" style="margin-top: -20px; text-align: center; font-size: 14px; font-weight: bold"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> No existen registros</div>
</g:else>

<script type="text/javascript">

    $(".btnVerComprobante").click(function () {
        var id = $(this).data("id");
       location.href="${createLink(controller: 'comprobanteCont', action: 'form')}/" + id
    });

    $(".btnEditarComprobante").click(function () {
        var id = $(this).data("id");
        createEditRowComprobante(id);
    });
    $(".btnBorrarComprobante").click(function () {
        var id = $(this).data("id");
        deleteRow(id);
    });

</script>
