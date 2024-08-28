
<%@ page import="contabilidad.Periodo" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Períodos</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:if test="${!periodos}">
            <a href="#" class="btn btn-success btnCrearPeriodos">
                <i class="fa fa-file-o"></i> Generar Períodos
            </a>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center; font-size: 14px; font-weight: bold"> Períodos de la contabilidad: ${" desde " + contabilidad?.fechaInicio?.format("dd-MM-yyyy") + " hasta " + contabilidad?.fechaCierre?.format("dd-MM-yyyy") }</div>
        </g:else>
    </div>
</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th style="width: 15%">Número</th>
        <th style="width: 15%">Fecha Inicio</th>
        <th style="width: 15%">Fecha Fin</th>
        <th style="width: 40%">Contabilidad</th>
        <th style="width: 15%">Acciones</th>
    </tr>
    </thead>
    <tbody>
    <g:if test="${periodos.size() > 0}">
        <g:each in="${periodos}" status="i" var="periodo">
            <tr data-id="${periodo.id}">
                <td style="width: 15%">
                    <g:textField name="periodo" value="${periodo?.numero}" class="form-control" />
                </td>
                <td style="width: 15%">
                    <elm:datepicker name="fechaInicio"  class="datepicker form-control" value="${periodo?.fechaInicio}"  />
                </td>
                <td style="width: 15%">
                    <elm:datepicker name="fechaFin"  class="datepicker form-control" value="${periodo?.fechaFin}"  />
                </td>
                <td style="width: 40%">
                    ${periodo?.contabilidad?.descripcion}
                </td>
                <td style="width: 15%; text-align: center">
                    <a href="#" class="btn btn-success btnGuardarPeriodo" data-id="${periodo?.id}">
                        <i class="fa fa-save"></i> Guardar
                    </a>
                </td>
            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr >
            <td colspan="5">
                <div class="alert alert-warning" style="text-align: center; font-size: 14px; font-weight: bold"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> No existen registros</div>
            </td>
        </tr>
    </g:else>
    </tbody>
</table>


<script type="text/javascript">

    $(".btnCrearPeriodos").click(function () {
        openLoader("Creando...");
        $.ajax({
            type    : "POST",
            url : "${createLink(controller:'periodo', action:'crearPeriodos_ajax')}",
            data    : {
            },
            success : function (msg) {
                closeLoader();
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1],"success");
                    setTimeout(function() {
                        location.reload()
                    }, 1000);
                }else{
                    log(parts[1],"error")
                }
            }
        });
    });

    $(".btnGuardarPeriodo").click(function () {
        var id = $(this).data("id");
        openLoader("Guardando...");
        $.ajax({
            type    : "POST",
            url : "${createLink(controller:'periodo', action:'guardarPeriodo_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                closeLoader();
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1],"success");
                    setTimeout(function() {
                        location.reload()
                    }, 1000);
                }else{
                    log(parts[1],"error")
                }
            }
        });
    });

</script>

</body>
</html>
