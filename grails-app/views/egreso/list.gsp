
<%@ page import="condominio.Egreso" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Egreso</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-primary btnCrear">
            <i class="fa fa-file-o"></i> Crear
        </a>
        <a href="#" class="btn btn-info" id="btnImprimir">
            <i class="fa fa-print"></i> Imprimir
        </a>
    </div>
    <div class="btn-group">
        <g:link controller="proveedor" action="list" class="btn btn-default">
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
</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>

        <g:sortableColumn property="descripcion" title="Descripcion" />

        <g:sortableColumn property="abono" title="Abono" />

        <g:sortableColumn property="estado" title="Estado" />

        <g:sortableColumn property="fecha" title="Fecha" />

        <g:sortableColumn property="fechaPago" title="Fecha Pago" />

        <th>Proveedor</th>

    </tr>
    </thead>
    <tbody>
    <g:if test="${egresoInstanceCount > 0}">
        <g:each in="${egresoInstanceList}" status="i" var="egresoInstance">
            <tr data-id="${egresoInstance.id}">

                <td>${egresoInstance.descripcion}</td>

                <td><g:fieldValue bean="${egresoInstance}" field="abono"/></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${egresoInstance}" field="estado"/></elm:textoBusqueda></td>

                <td><g:formatDate date="${egresoInstance.fecha}" format="dd-MM-yyyy" /></td>

                <td><g:formatDate date="${egresoInstance.fechaPago}" format="dd-MM-yyyy" /></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${egresoInstance}" field="proveedor"/></elm:textoBusqueda></td>

            </tr>
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
        var title = id ? "Editar" : "Crear";
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
                            url     : "${createLink(controller:'egreso', action:'show_ajax')}",
                            data    : {
                                id : id
                            },
                            success : function (msg) {
                                bootbox.dialog({
                                    title   : "Ver Egreso",
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
                    label  : "Editar",
                    icon   : "fa fa-pencil",
                    action : function ($element) {
                        var id = $element.data("id");
                        createEditRow(id);
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



    $("#btnImprimir").click(function () {

        url = "${g.createLink(controller:'reportes', action: 'pagosPendientes')}";
        location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + '&filename=pagosPendientes.pdf';


        %{--$.ajax({--}%
            %{--type: 'POST',--}%
            %{--url:'${createLink(controller: 'reportes', action: 'pagosPendientes_modal')}',--}%
            %{--data:{--}%

            %{--},--}%
            %{--success: function (msg){--}%
                %{--var b = bootbox.dialog({--}%
                    %{--id      : "dlgPagosPen",--}%
                    %{--title   : "Pagos Pendientes",--}%
                    %{--message : msg,--}%
                    %{--buttons : {--}%
                        %{--cancelar : {--}%
                            %{--label     : "<i class='fa fa-times'></i> Cancelar",--}%
                            %{--className : "btn-primary",--}%
                            %{--callback  : function () {--}%
                            %{--}--}%
                        %{--}--}%
                    %{--} //buttons--}%
                %{--}); //dialog--}%
            %{--}--}%
        %{--});--}%
    });


</script>

</body>
</html>
