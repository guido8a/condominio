
<%@ page import="condominio.Ingreso" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Cuentas pendientes</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<h3 style="text-align: center">Pendientes de ${ingreso[0].persona.nombre} ${ingreso[0].persona.apellido}</h3>
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
        <a href="${createLink(controller: "vivienda", action: "index")}" class="btn btn-default">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    <div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link controller="ingreso" action="list" class="btn btn-default btn-search">
                    <i class="fa fa-search"></i>&nbsp;
                </g:link>
            </span>
        </div><!-- /input-group -->
    </div>
</div>



<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>

        <g:sortableColumn property="observaciones" title="Concepto" />

        <g:sortableColumn property="fecha" title="Fecha" />

        <g:sortableColumn property="valor" title="Valor" />

        <g:sortableColumn property="abono" title="Abono" />

        <th>Saldo</th>

        <g:sortableColumn property="fechaPago" title="Fecha Pago" />

        <g:sortableColumn property="documento" title="Documento" />

        <g:sortableColumn property="estado" title="Estado" />
        

    </tr>
    </thead>
    <tbody>
    <g:if test="${ingrCount > 0}">
        <g:each in="${ingreso}" status="i" var="ingr">
            <tr data-id="${ingr.id}" data-obsr="${ingr.obligacion.descripcion}: ${ingr.observaciones}">

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${ingr}" field="observaciones"/></elm:textoBusqueda></td>

                <td><g:formatDate date="${ingr.fecha}" format="dd-MM-yyyy" /></td>

                <td><g:fieldValue bean="${ingr}" field="valor" /></td>

                <td><g:fieldValue bean="${ingr}" field="abono"/></td>

                <td>${ingr.valor - ingr.abono}</td>

                <td><g:formatDate date="${ingr.fechaPago}" format="dd-MM-yyyy" /></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${ingr}" field="documento"/></elm:textoBusqueda></td>
                
                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${ingr}" field="estado"/></elm:textoBusqueda></td>
                
            </tr>
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
    var id = null;
    function submitFormIngreso() {
        var $form = $("#frmIngreso");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
        $btn.replaceWith(spinner);
            openLoader("Guardando Ingreso");
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

    function createEditRow(id, obsr) {
        var title = "Registrar el pago de: ${ingreso[0].persona.nombre} ${ingreso[0].persona.apellido}" +
                "<br/><span style='color:#800'>" + obsr + "</span>";
        var data = id ? { id: id } : {};
                $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'ingreso', action:'form_ajax')}",
            data    : data,
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

                $("tbody>tr").contextMenu({
            items  : {
                header   : {
                    label  : "Acciones",
                    header : true
                },
                ver      : {
                    label  : "Ver",
                    icon   : "fa fa-search",
                    action : function ($element) {
            var id = $element.data("id");
                                $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'ingreso', action:'show_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    bootbox.dialog({
                        title   : "Ver Ingreso",
                        message : msg,
                        buttons : {
                            ok : {
                                label     : "Aceptar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
        }
    },
        editar   : {
            label  : "Ingresar pago",
                icon   : "fa fa-pencil",
                action : function ($element) {
                var id = $element.data("id");
                var obsr = $element.data("obsr");
                createEditRow(id, obsr);
            }
        },
        eliminar : {
            label            : "Eliminar",
                icon             : "fa fa-trash-o",
                separator_before : true,
                action           : function ($element) {
                var id = $element.data("id");
                deleteRow(id);
            }
        }
    },
        onShow : function ($element) {
        $element.addClass("success");
        },
        onHide : function ($element) {
        $(".success").removeClass("success");
        }
    });
    });
</script>

</body>
</html>
