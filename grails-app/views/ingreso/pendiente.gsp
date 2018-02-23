
<%@ page import="condominio.Ingreso" %>
<%@ page import="condominio.Pago" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Cuentas pendientes</title>

    <style type="text/css">

    .colorFondo{
        background-color: lightslategrey;
        text-align: center;
    }

    .derecha{
        text-align: right;
    }

    .centro{
        text-align: center;
    }

    .dd{
        font-weight: bold;
    }

    </style>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<h3 style="text-align: center">Pendientes de <strong>${ingreso[0].persona.nombre} ${ingreso[0].persona.apellido}</strong></h3>
<!-- botones -->
<div class="btn-toolbar toolbar">
    %{--
        <div class="btn-group">
            <a href="#" class="btn btn-default btnCrear">
                <i class="fa fa-file-o"></i> Regresar
            </a>
        </div>
    --}%
    <div class="btn-group">
        <a href="${createLink(controller: "vivienda", action: "index")}" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    %{--<div class="btn-group pull-right col-md-3">--}%
    %{--<div class="input-group">--}%
    %{--<input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">--}%
    %{--<span class="input-group-btn">--}%
    %{--<g:link controller="ingreso" action="list" class="btn btn-default btn-search">--}%
    %{--<i class="fa fa-search"></i>&nbsp;--}%
    %{--</g:link>--}%
    %{--</span>--}%
    %{--</div><!-- /input-group -->--}%
    %{--</div>--}%
</div>



<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr style="width: 100%">

        <th style="width: 35%">Concepto</th>
        <th style="width: 10%">Fecha</th>
        <th style="width: 15%">Valor</th>
        <th style="width: 15%">Abono</th>
        <th style="width: 15%">Saldo</th>
        <th style="width: 10%; text-align: center"><i class="fa fa-pencil"></i></th>
    </tr>
    </thead>
    <tbody>
    <g:if test="${ingrCount > 0}">
        <g:each in="${ingreso}" status="i" var="ingr">
            <tr data-id="${ingr.id}" data-obsr="${ingr.obligacion.descripcion}: ${ingr.observaciones}" style="background-color: #76aed1">

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${ingr}" field="observaciones"/></elm:textoBusqueda></td>

                <td><g:formatDate date="${ingr.fecha}" format="dd-MM-yyyy" /></td>

                <td class="derecha"><g:fieldValue bean="${ingr}" field="valor" /></td>

                %{--<td><g:fieldValue bean="${ingr}" field="abono"/></td>--}%
                <td class="derecha">${(Pago.findAllByIngreso(ingr).valor?.sum()?.toDouble() ?: 0)}</td>
                %{--<td>${ingr.valor - ingr.abono}</td>--}%
                <td class="derecha">${ingr?.valor?.toDouble() - (Pago.findAllByIngreso(ingr).valor?.sum()?.toDouble() ?: 0)}</td>

                %{--<td><g:formatDate date="${ingr.fechaPago}" format="dd-MM-yyyy" /></td>--}%

                %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${ingr}" field="documento"/></elm:textoBusqueda></td>--}%

                %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${ingr}" field="estado"/></elm:textoBusqueda></td>--}%
                <td class="centro">
                <g:if test="${(ingr.valor.toDouble() - (Pago.findAllByIngreso(ingr)?.valor?.sum()?.toDouble() ?: 0)) > 0}">
                    <a href="#" class="btn btn-success btn-sm btnAdd" data-ing="${ingr?.id}" title="Ingresar Pago">
                        <i class="fa fa-plus"></i>
                    </a>
                </g:if>

                    %{--<a href="#" class="btn btn-danger btn-sm btnEliminarIngreso" data-id="${ingr?.id}" title="Eliminar Registro">--}%
                        %{--<i class="fa fa-trash-o"></i>--}%
                    %{--</a>--}%
                </td>
            </tr>
            <g:if test="${Pago.findAllByIngreso(ingr)}">
                <g:set var="cabecera" value="N"/>
                <g:set var="pagosUsuario" value="${Pago.findAllByIngreso(ingr).sort{it.fechaPago}}"/>
                <g:each in="${pagosUsuario}" var="pagoUsuario">
                    <g:if test="${cabecera != 'S'}">
                        <tr style="color: #0b0b0b!important;">
                            <td class="colorFondo">Documento</td>
                            <td class="colorFondo">Fecha Pago</td>
                            <td class="colorFondo">Abono</td>
                            <td class="colorFondo"colspan="2">Observaciones</td>
                            <td class="colorFondo"><i class="fa fa-pencil"></i></td>
                            <g:set var="cabecera" value="S"/>
                        </tr>
                    </g:if>
                    <tr data-id="${pagoUsuario.id}" style="background-color: #95ef9b !important;">
                        <td>${pagoUsuario?.documento}</td>
                        <td><g:formatDate date="${pagoUsuario?.fechaPago}" format="dd-MM-yyyy"/></td>
                        <td class="derecha dd"><g:formatNumber number="${pagoUsuario?.valor}" format="##,##0" locale="en_US" maxFractionDigits="2" minFractionDigits="2"/></td>
                        <td colspan="2">${pagoUsuario?.observaciones}</td>
                        <td class="centro">
                            <a href="#" class="btn btn-info btn-sm btnEditar" data-id="${pagoUsuario?.id}" data-ing="${ingr?.id}" title="Editar Pago">
                                <i class="fa fa-pencil"></i>
                            </a>
                            <a href="#" class="btn btn-danger btn-sm btnEliminar" data-id="${pagoUsuario?.id}" title="Borrar Pago">
                                <i class="fa fa-trash-o"></i>
                            </a>
                        </td>
                    </tr>
                </g:each>
            </g:if>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="9">
                <g:if test="${params.search && params.search!= ''}">
                    No se encontraron resultados para su búsqueda
                </g:if>
                <g:else>
                    No se encontraron registros que mostrar
                </g:else>
            </td>
        </tr>
    </g:else>
    </tbody>
</table>

<elm:pagination total="${ingrCount}" params="${params}"/>

<script type="text/javascript">

    $(".btnAdd").click(function () {
        var idIngreso = $(this).data("ing");
        createEditRow(idIngreso,null)
    });

    $(".btnEditar").click(function () {
        var idPago = $(this).data("id");
        var idIngreso = $(this).data("ing");
        createEditRow(idIngreso, idPago)
    });

    $(".btnEliminar").click(function () {
        var pago = $(this).data("id");
        bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea eliminar el pago seleccionado?", function (res) {
            if (res) {
                openLoader("Borrando Pago...");
                $.ajax({
                    type    : "POST",
                    url : "${createLink(controller:'ingreso', action:'borrarPago_ajax')}",
                    data    : {
                        id: pago
                    },
                    success : function (msg) {
                        if(msg == 'ok'){
                            closeLoader();
                            log("Pago borrado correctamente","success");
                            setTimeout(function() {
                                location.reload(true);
                            }, 1000);
                        }else{
                            log("Error al borrar el pago","error")
                        }
                    }
                });
            }
        });
    });


    var id = null;
    function submitFormIngreso() {
        var $form = $("#frmIngreso");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
//            openLoader("Guardando Ingreso");
            openLoader("Guardando Pago");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
//                    var parts = msg.split("*");
//                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
//                    setTimeout(function() {
//                        if (parts[0] == "SUCCESS") {
//                            location.reload(true);
//                        } else {
//                            spinner.replaceWith($btn);
//                            return false;
//                        }
//                    }, 1000);

                    if(msg == 'ok'){
                        log("Pago guardado correctamente!" , "success");
                        closeLoader();
                        setTimeout(function() {
                            location.reload(true);
                        }, 1000);
                    }else{
                        if(msg == 'di'){
                            closeLoader();
                            bootbox.alert("<i class='fa fa-warning fa-3x pull-left text-warning text-shadow'></i> El abono ingresado supera el valor del saldo")
                        }
                        else{
                            log("Error al guardar el pago","error");
                            closeLoader();
                        }
                    }
                }
            });
        } else {
            return false;
        } //else
    }

    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
            "¿Está seguro que desea eliminar el Ingreso seleccionado? Esta acción no se puede deshacer.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash-o'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Eliminando Ingreso");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'ingreso', action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] == "SUCCESS") {
                                    setTimeout(function() {
                                        location.reload(true);
                                    }, 1000);
                                } else {
                                    closeLoader();
                                }
                            }
                        });
                    }
                }
            }
        });
    }

//    function createEditRow(id, obsr) {
    function createEditRow(id, pago, obsr) {
        var title = "Registrar el pago de: ${ingreso[0].persona.nombre} ${ingreso[0].persona.apellido}" +
            "<br/>";
//        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            %{--url     : "${createLink(controller:'ingreso', action:'form_ajax')}",--}%
            url     : "${createLink(controller:'ingreso', action:'pago_ajax')}",
            data    : {
                id: id,
                pago: pago
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title,
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormIngreso();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    $(function () {

        $(".btnCrear").click(function() {
            createEditRow();
            return false;
        });

        %{--$("tbody>tr").contextMenu({--}%
            %{--items  : {--}%
                %{--header   : {--}%
                    %{--label  : "Acciones",--}%
                    %{--header : true--}%
                %{--},--}%
                %{--ver      : {--}%
                    %{--label  : "Ver",--}%
                    %{--icon   : "fa fa-search",--}%
                    %{--action : function ($element) {--}%
                        %{--var id = $element.data("id");--}%
                        %{--$.ajax({--}%
                            %{--type    : "POST",--}%
                            %{--url     : "${createLink(controller:'ingreso', action:'show_ajax')}",--}%
                            %{--data    : {--}%
                                %{--id : id--}%
                            %{--},--}%
                            %{--success : function (msg) {--}%
                                %{--bootbox.dialog({--}%
                                    %{--title   : "Ver Ingreso",--}%
                                    %{--message : msg,--}%
                                    %{--buttons : {--}%
                                        %{--ok : {--}%
                                            %{--label     : "Aceptar",--}%
                                            %{--className : "btn-primary",--}%
                                            %{--callback  : function () {--}%
                                            %{--}--}%
                                        %{--}--}%
                                    %{--}--}%
                                %{--});--}%
                            %{--}--}%
                        %{--});--}%
                    %{--}--}%
                %{--},--}%
                %{--editar   : {--}%
                    %{--label  : "Ingresar pago",--}%
                    %{--icon   : "fa fa-pencil",--}%
                    %{--action : function ($element) {--}%
                        %{--var id = $element.data("id");--}%
                        %{--var obsr = $element.data("obsr");--}%
                        %{--createEditRow(id, obsr);--}%
                    %{--}--}%
                %{--},--}%
                %{--eliminar : {--}%
                    %{--label            : "Eliminar",--}%
                    %{--icon             : "fa fa-trash-o",--}%
                    %{--separator_before : true,--}%
                    %{--action           : function ($element) {--}%
                        %{--var id = $element.data("id");--}%
                        %{--deleteRow(id);--}%
                    %{--}--}%
                %{--}--}%
            %{--},--}%
            %{--onShow : function ($element) {--}%
                %{--$element.addClass("success");--}%
            %{--},--}%
            %{--onHide : function ($element) {--}%
                %{--$(".success").removeClass("success");--}%
            %{--}--}%
        %{--});--}%
    });
</script>

</body>
</html>
