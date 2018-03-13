
<%@ page import="condominio.Egreso" %>
<%@ page import="condominio.PagoEgreso" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Egreso</title>

    <style type="text/css">

    .colorFondo{
        background-color: #eae8df;
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

<!-- botones -->
<h3 style="text-align: center">Egresos y Gastos</h3>
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-primary btnCrear">
            <i class="fa fa-file-o"></i> Nuevo
        </a>
    </div>
    <div class="btn-group">
        <g:link controller="reportes" action="pagosPendientes2"
        class="btn btnPrint btn-info" rel="tooltip" title="Imprimir pagos pendientes">
        <i class="fa fa-print"></i> Pendientes
        </g:link>
        <a href="#" class="btn btn-info" id="btnImprimir">
            <i class="fa fa-print"></i> Imprimir
        </a>
    </div>
    <div class="btn-group">
        <g:link controller="proveedor" action="list" class="btn btn-warning">
            <i class="fa fa-user-o"></i> Proveedores
        </g:link>
    </div>
    <div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link controller="egreso" action="list" class="btn btn-default btn-search">
                    <i class="fa fa-search"></i>&nbsp;
                </g:link>
            </span>
        </div><!-- /input-group -->
    </div>
    <div class="btn-group">
        <g:link controller="egreso" action="saldos_ajax" class="btn btn-success">
            <i class="fa fa-dollar"></i> Saldos
        </g:link>
    </div>

</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th style="width: 30%">Descripción del Gasto</th>
        <th style="width: 27%">Proveedor</th>
        <th style="width: 8%">Fecha</th>
        <th style="width: 7%">Valor</th>
        <th style="width: 7%">Pagado</th>
        <th style="width: 7%">Saldo</th>
        <th class="centro" style="width: 14%"><i class="fa fa-pencil"></i> Pagos</th>
    </tr>
    </thead>
    <tbody>
    <g:if test="${egresoInstanceCount > 0}">
        <g:each in="${egresoInstanceList}" status="i" var="egresoInstance">
            <tr data-id="${egresoInstance.id}" style="background-color: #faf8ef">

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${egresoInstance}" field="descripcion"/></elm:textoBusqueda></td>
                %{--<td><g:fieldValue bean="${egresoInstance}" field="descripcion"/></td>--}%
                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${egresoInstance}" field="proveedor"/></elm:textoBusqueda></td>
                %{--<td><g:fieldValue bean="${egresoInstance}" field="descripcion"/></td>--}%
                <td><g:formatDate date="${egresoInstance.fecha}" format="dd-MM-yyyy" /></td>
                <td class="derecha"><g:formatNumber number="${egresoInstance?.valor}" format="##,##0" locale="en" maxFractionDigits="2" minFractionDigits="2"/></td>
                <td class="derecha"><g:formatNumber number="${(PagoEgreso.findAllByEgreso(egresoInstance).valor?.sum()?.toDouble() ?: 0)}" format="##,##0" locale="en" maxFractionDigits="2" minFractionDigits="2"/></td>
                <td class="derecha"><g:formatNumber number="${egresoInstance?.valor?.toDouble() - (PagoEgreso.findAllByEgreso(egresoInstance).valor?.sum()?.toDouble() ?: 0)}" format="##,##0" locale="en" maxFractionDigits="2" minFractionDigits="2"/></td>
                <td style="background-color: #a0a0a0">
                    <a href="#" class="btn btn-primary btn-sm btnEditarEgg" data-ing="${egresoInstance?.id}" title="Editar Egreso">
                        <i class="fa fa-pencil"></i>
                    </a>
                    <g:if test="${(egresoInstance.valor.toDouble() - (PagoEgreso.findAllByEgreso(egresoInstance)?.valor?.sum()?.toDouble() ?: 0)) > 0}">
                        <a href="#" class="btn btn-success btn-sm btnPago" data-ing="${egresoInstance?.id}" title="Ingresar Pago">
                            <i class="fa fa-plus"></i> Pagar
                        </a>
                    </g:if>
                    <g:if test="${!PagoEgreso.findAllByEgreso(egresoInstance)}">
                        <a href="#" class="btn btn-danger btn-sm btnBorrarEgg" data-ing="${egresoInstance?.id}" title="Borrar Egreso">
                            <i class="fa fa-trash-o"></i>
                        </a>
                    </g:if>
                </td>
            </tr>
            <g:if test="${PagoEgreso.findAllByEgreso(egresoInstance)}">
                <g:set var="cabecera" value="N"/>
                <g:set var="pagosEgreso" value="${PagoEgreso.findAllByEgreso(egresoInstance).sort{it.fechaPago}}"/>
                <g:each in="${pagosEgreso}" var="pagoUsuario">
                    <g:if test="${cabecera != 'S'}">
                        <tr style="color: #0b0b0b!important;">
                            <td class="colorFondo">Concepto del egreso</td>
                            <td class="colorFondo">Documento de Pago</td>
                            <td class="colorFondo" colspan="2">Fecha Pago</td>
                            <td class="colorFondo" colspan="2">Pago</td>
                            <td style="background-color: #C0C0C0"><i class="fa fa-pencil">** Pagar</i></td>
                            <g:set var="cabecera" value="S"/>
                        </tr>
                    </g:if>
                    <tr data-id="${pagoUsuario.id}" style="background-color: #ffffff !important;">
                        <td >${pagoUsuario?.observaciones}</td>
                        <td>${pagoUsuario?.documento}</td>
                        <td colspan="2"><g:formatDate date="${pagoUsuario?.fechaPago}" format="dd-MM-yyyy"/></td>
                        <td class="derecha dd" colspan="2"><g:formatNumber number="${pagoUsuario?.valor}" format="##,##0" locale="en_US" maxFractionDigits="2" minFractionDigits="2"/></td>
                        <td style="background-color: #E0E0E0; text-align: center">
                            <a href="#" class="btn btn-info btn-sm btnEditar" data-id="${pagoUsuario?.id}" data-ing="${egresoInstance?.id}" title="Editar Pago">
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
            <td class="text-center" colspan="8">
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

<elm:pagination total="${egresoInstanceCount}" params="${params}"/>

<script type="text/javascript">



    $(".btnEditarEgg").click(function () {
        var egreso = $(this).data('ing');
        createEditRow(egreso);
    });


    var id = null;
    function submitFormEgreso() {
        var $form = $("#frmEgreso");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Egreso");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        if (parts[0] == "SUCCESS") {
                            location.reload(true);
                        } else {
                            closeLoader();
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 1000);
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
            "¿Está seguro que desea eliminar el Egreso seleccionado? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Egreso");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'egreso', action:'delete_ajax')}',
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

    function createEditRow(id) {
        var title = id ? "Editar" : "Nuevo";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'egreso', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Egreso",

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
                                return submitFormEgreso();
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
        %{--url     : "${createLink(controller:'egreso', action:'show_ajax')}",--}%
        %{--data    : {--}%
        %{--id : id--}%
        %{--},--}%
        %{--success : function (msg) {--}%
        %{--bootbox.dialog({--}%
        %{--title   : "Ver Egreso",--}%
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
        %{--label  : "Editar",--}%
        %{--icon   : "fa fa-pencil",--}%
        %{--action : function ($element) {--}%
        %{--var id = $element.data("id");--}%
        %{--createEditRow(id);--}%
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



    $("#btnImprimir").click(function () {
        %{--url = "${g.createLink(controller:'reportes', action: 'pagosPendientes')}";--}%
        %{--location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + '&filename=pagosPendientes.pdf';--}%

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'fecha_ajax')}',
            data:{},
            success: function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgFecha",
                    title   : "Imprimir pagos pendientes",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });


    });

    $(".btnPago").click(function () {
        var egreso = $(this).data('ing');
        createEditPago(egreso, null)
    });

    $(".btnEditar").click(function () {
        var egreso = $(this).data('ing');
        var pago = $(this).data('id');
        createEditPago(egreso, pago)
    });

    $(".btnBorrarEgg").click(function () {
        var egreso = $(this).data("ing");
        bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea eliminar el egreso seleccionado?", function (res) {
            if (res) {
                openLoader("Borrando Egreso...");
                $.ajax({
                    type    : "POST",
                    url : "${createLink(controller:'egreso', action:'borrarEgreso_ajax')}",
                    data    : {
                        id: egreso
                    },
                    success : function (msg) {
                        if(msg == 'ok'){
                            closeLoader();
                            log("Egreso borrado correctamente","success");
                            setTimeout(function() {
                                location.reload(true);
                            }, 1000);
                        }else{
                            if(msg == 'di'){
                                closeLoader();
                                log("No se puede borrar este egreso, contiene pagos","error")
                            }else{
                                closeLoader();
                                log("Error al borrar el egreso","error")
                            }
                        }
                    }
                });
            }
        });
    });

    $(".btnEliminar").click(function () {
        var pago = $(this).data("id");
        bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea eliminar el pago seleccionado?", function (res) {
            if (res) {
                openLoader("Borrando Pago...");
                $.ajax({
                    type    : "POST",
                    url : "${createLink(controller:'egreso', action:'borrarPagoEgreso_ajax')}",
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

    function createEditPago(id, pago) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'egreso', action:'pagoEgreso_ajax')}",
            data    : {
                id: id,
                pago: pago
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : "Pago Egreso",
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
                                return submitFormPagoEgreso();
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

    function submitFormPagoEgreso() {
        var $form = $("#frmEgresoPago");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Pago...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
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


</script>

</body>
</html>
