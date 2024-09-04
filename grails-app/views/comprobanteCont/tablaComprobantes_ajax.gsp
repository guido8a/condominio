<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Fecha</th>
            <th style="width: 10%">Tipo</th>
            <th style="width: 25%">Descripción</th>
            <th style="width: 10%">Debe</th>
            <th style="width: 10%">Haber</th>
            <th style="width: 10%">Número</th>
            <th style="width: 10%">Registrado</th>
            <th style="width: 15%; text-align: center">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<g:if test="${comprobantes.size() > 0}">
    <div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
            <tbody>
            <g:each in="${comprobantes}" var="comprobante">
                <g:set var="sumadebe" value="${0.0}"/>
                <g:set var="sumahber" value="${0.0}"/>
                <g:set var="asientos" value="${contabilidad.Asiento.findAllByComprobante(comprobante)}"/>
                <g:each in="${asientos}" var="asiento">
                    <g:set var="sumadebe" value="${sumadebe + (asiento?.debe ?: 0)}"/>
                    <g:set var="sumahber" value="${sumahber + (asiento?.haber ?: 0)}"/>
                </g:each>
                <tr data-id="${comprobante?.id}">
                    <td style="width: 10%">${comprobante?.fecha?.format("dd-MM-yyyy")}</td>
                    <td style="width: 10%">${comprobante?.tipo?.descripcion}</td>
                    <td style="width: 25%">${comprobante?.descripcion}</td>
                    <td style="width: 10%"><g:formatNumber number="${Math.round(sumadebe*100)/100}" format="##,##0" maxFractionDigits="2" minFractionDigits="2"/></td>
                    <td style="width: 10%"><g:formatNumber number="${Math.round(sumahber*100)/100}" format="##,##0" maxFractionDigits="2" minFractionDigits="2"/></td>
                    <td style="width: 10%">${comprobante?.numero}</td>
                    <td style="width: 10%; background-color: ${comprobante?.registrado == 'N' ? '#ffcc3b' : '#5e9cff'} ">${comprobante?.registrado == 'N' ? 'No registrado' : 'Registrado'}</td>
                    <td style="width: 15%; text-align: center">
                        <a href="#" data-id="${comprobante.id}" class="btn btn-info btn-sm btnVerComprobante" title="Ir a comprobante">
                            <i class="fa fa-laptop"></i>
                        </a>
                        <a href="#" data-id="${comprobante.id}" class="btn btn-success btn-sm btnEditarComprobante" title="Editar comprobante">
                            <i class="fa fa-pencil"></i>
                        </a>
                        <g:if test="${comprobante?.registrado == 'N'}">
                            <a href="#" data-id="${comprobante.id}" class="btn btn-info btn-sm btnMayorizar" title="Mayorizar">
                                <i class="fa fa-lock"></i>
                            </a>
                        </g:if>
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

    $(".btnMayorizar").click(function  () {
        var id = $(this).data("id");
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><strong style='font-size: 14px'>¿Está seguro que desea registrar el comprobante? <br> Una vez registrado NO podrá ser modificado.</strong>",
            buttons : {
                cancelar : {
                    label     : "<i class='fa fa-times'></i> Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                registrar : {
                    label     : "<i class='fa fa-lock'></i> Registrar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Guardando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'comprobanteCont', action:'registrarComprobante_ajax')}',
                            data    : {
                                id: id
                            },
                            success : function (msg) {
                                closeLoader();
                                var parts = msg.split("_");
                                if (parts[0] === 'ok') {
                                    log(parts[1], "success");
                                    buscarComprobantes();
                                } else {
                                    log(parts[1], "error");
                                }
                            }
                        });
                    }
                }
            }
        });
    })

</script>
