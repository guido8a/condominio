
<%@ page import="condominio.Obligacion" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Obligaciones</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<div style="text-align: center; margin-top: -30px;">
    <h3>Aportes y Obligaciones</h3>
</div>
<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="${createLink(controller: "inicio", action: "index")}" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    <div class="btn-group">
        <a href="#" class="btn btn-primary btnCrear">
            <i class="fa fa-file-o"></i> Nueva Obligación
        </a>
    </div>
    <div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link controller="obligacion" action="list" class="btn btn-default btn-search">
                    <i class="fa fa-search"></i>&nbsp;
                </g:link>
            </span>
        </div><!-- /input-group -->
    </div>
</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        
        <g:sortableColumn property="descripcion" title="Descripción" />
        
        <g:sortableColumn property="fecha" title="Fecha" />

        <g:sortableColumn property="valor" title="Valor" />

        <th>Tipo de Aporte</th>
        
    </tr>
    </thead>
    <tbody>
    <g:if test="${obligacionInstanceCount > 0}">
        <g:each in="${obligacionInstanceList}" status="i" var="obligacionInstance">
            <tr data-id="${obligacionInstance.id}">
                
                <td>${obligacionInstance.descripcion}</td>
                
                <td><g:formatDate date="${obligacionInstance.fecha}" format="dd-MM-yyyy" /></td>
                
                %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${obligacionInstance}" field="tipo"/></elm:textoBusqueda></td>--}%

                %{--<td><g:fieldValue bean="${obligacionInstance}" field="valor"/></td>--}%
               <td><g:formatNumber number="${obligacionInstance?.valor}" format="##,##0" locale="en_US" maxFractionDigits="2" minFractionDigits="2"/></td>

                <td>${obligacionInstance?.tipoAporte?.descripcion}</td>


            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="4">
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

<elm:pagination total="${obligacionInstanceCount}" params="${params}"/>

<script type="text/javascript">
    var id = null;
    function submitFormObligacion() {
        var $form = $("#frmObligacion");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
        $btn.replaceWith(spinner);
            openLoader("Guardando Obligación");
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
            "¿Está seguro que desea eliminar la Obligación seleccionada? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Obligacion");
                                $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'obligacion', action:'delete_ajax')}',
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
        var title = id ? "Editar" : "Nueva";
        var data = id ? { id: id } : {};
            $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'obligacion', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Obligación",
                    
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
                                return submitFormObligacion();
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
                url     : "${createLink(controller:'obligacion', action:'show_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    bootbox.dialog({
                        title   : "Ver Obligacion",
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
</script>

</body>
</html>
