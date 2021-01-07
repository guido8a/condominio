
<%@ page import="condominio.Empleado" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Empleados</title>
</head>
<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="${createLink(controller: "condominio", action: "list")}" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
</div>

<div style="text-align: center; margin-top: -30px;margin-bottom:20px">
    <h3>Lista de empleados del condominio: ${condominio?.nombre}</h3>
</div>

<div style="margin-top: 30px; min-height: 350px" class="vertical-container">
    <p class="css-vertical-text">Empleados</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 1070px">
        <tr>
            <th class="alinear" style="width: 13%">Nombre</th>
            <th class="alinear" style="width: 13%">Apellido</th>
            <th class="alinear" style="width: 6%">Cédula</th>
            <th class="alinear" style="width: 20%">Dirección</th>
            <th class="alinear" style="width: 5%">Teléfono</th>
            <th class="alinear" style="width: 5%">Sexo</th>
            <th class="alinear" style="width: 10%">Cargo</th>
            <th class="alinear" style="width: 8%">Fecha Inicio</th>
            <th class="alinear" style="width: 8%">Fecha Fin</th>
            <th class="alinear" style="width: 5%">Activo</th>
        </tr>
    </table>

    <div class="" style="width: 100%;height: 350px; overflow-y: auto;float: right; margin-top: -15px" >
        <table class="table-bordered table-condensed table-hover" width="98%">
            <g:each in="${empleados}" var="empleado">
                <tr>
                    <td style="width: 13%">${empleado?.nombre}</td>
                    <td style="width: 13%">${empleado?.apellido}</td>
                    <td style="width: 6%">${empleado?.cedula}</td>
                    <td style="width: 20%">${empleado?.direccion}</td>
                    <td style="width: 5%">${empleado?.telefono}</td>
                    <td style="width: 5%">${empleado?.sexo == 'M' ? 'Masculino' : 'Femenino'}</td>
                    <td style="width: 10%">${empleado?.cargo}</td>
                    <td style="width: 8%">${empleado?.fechaInicio?.format("dd-MM-yyyy")}</td>
                    <td style="width: 8%">${empleado?.fechaFin?.format("dd-MM-yyyy")}</td>
                    <td style="width: 5%; background-color: ${empleado?.activo == 1 ? '#47954B' : '#891523'}">${empleado?.activo == 1 ? 'SI' : 'NO'}</td>
                </tr>
            </g:each>
        </table>
    </div>
</div>

<script type="text/javascript">

</script>

</body>
</html>
