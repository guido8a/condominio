
<%@ page import="condominio.Proveedor" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Proveedores</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="col-md-3">
        <div class="btn-group">
            <a href="${createLink(controller: "egreso", action: "egresos")}" class="btn btn-primary">
                <i class="fa fa-arrow-left"></i> Regresar
            </a>
        </div>
        <div class="btn-group">
            <a href="#" class="btn btn-primary btnCrear">
                <i class="fa fa-file-o"></i> Nuevo Proveedor
            </a>
        </div>
    </div>
    <div class="col-md-3">
        <g:select from="${[2: 'NOMBRE', 3: 'APELLIDO', 4: 'DIRECCIÓN', 5: "TELÉFONO", 1:'RUC']}" optionValue="value" optionKey="key" class="form-control" name="campos" id="idCampos"/>
    </div>
    <div class="col-md-3">
        <g:textField name="busqueda" id="idBuscar" class="form-control"/>
    </div>
    <div class="col-md-2">
        <a href="#" class="btn btn-success btnBuscar">
            <i class="fa fa-search"></i> Buscar
        </a>
    </div>
</div>

<table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
    <thead>
    <tr>
        <th style="width: 10%">Ruc</th>
        <th style="width: 25%">Nombre</th>
        <th style="width: 13%">Apellido</th>
        <th style="width: 20%">Dirección</th>
        <th style="width: 11%">Teléfono</th>
        <th style="width: 18%">Mail</th>
        <th style="width: 8%">Estado</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div id="tablaProveedores"></div>


<script type="text/javascript">

    cargarTablaProveedores(null, null);

    $(".btnBuscar").click(function () {
        var campo = $("#idCampos").val();
        var busqueda = $("#idBuscar").val();
        cargarTablaProveedores(campo,busqueda)
    });

    function cargarTablaProveedores(campo, busqueda){
        openLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'proveedor', action: 'tablaProveedores_ajax')}',
            data:{
                campo: campo,
                busqueda: busqueda
            },
            success: function(msg){
                closeLoader();
                $("#tablaProveedores").html(msg)
            }
        });
    };


    $(".btnCrear").click(function() {
        createEditRow();
        return false;
    });


</script>

</body>
</html>
