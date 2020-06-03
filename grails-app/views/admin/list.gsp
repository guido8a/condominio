
<%@ page import="condominio.Admin" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Administradores</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-default btnCrear">
            <i class="fa fa-file-o"></i> Nueva Administración
        </a>
    </div>
    <div class="btn-group col-md-6" style="text-align: center; top: -20px">
        <h3>Administraciones del Condominio</h3>
    </div>
    <div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link controller="admin" action="list" class="btn btn-default btn-search">
                    <i class="fa fa-search"></i>&nbsp;
                </g:link>
            </span>
        </div><!-- /input-group -->
    </div>
</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th>Administrador</th>
        <th>Revisor</th>
        <g:sortableColumn property="fechaInicio" title="Fecha Inicio" />
        <g:sortableColumn property="saldoInicio" title="Saldo Incial" />
        <g:sortableColumn property="fechaFin" title="Fecha Fin" />
        <g:sortableColumn property="observaciones" title="Observaciones" />

    </tr>
    </thead>
    <tbody>
    <g:if test="${adminInstanceCount > 0}">
        <g:each in="${adminInstanceList}" status="i" var="adminInstance">
            <tr data-id="${adminInstance.id}">
                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${adminInstance}" field="administrador"/></elm:textoBusqueda></td>
                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${adminInstance}" field="revisor"/></elm:textoBusqueda></td>
                <td><g:formatDate date="${adminInstance.fechaInicio}" format="dd-MM-yyyy" /></td>
                <td><g:fieldValue bean="${adminInstance}" field="saldoInicial"/></td>
                <td>${adminInstance.fechaFin}</td>
                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${adminInstance}" field="observaciones"/></elm:textoBusqueda></td>
            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="7">
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

<elm:pagination total="${adminInstanceCount}" params="${params}"/>

<script type="text/javascript">
    var id = null;
    function submitFormAdmin() {
        var $form = $("#frmAdmin");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Administrador");
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
            "¿Está seguro que desea eliminar el Administrador seleccionado? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Admin");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'admin', action:'delete_ajax')}',
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
        var title = id ? "Editar el Administrador" : "Crear un Administrador";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'admin', action:'form_ajax')}",
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
                                return submitFormAdmin();
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
                            url     : "${createLink(controller:'admin', action:'show_ajax')}",
                            data    : {
                                id : id
                            },
                            success : function (msg) {
                                bootbox.dialog({
                                    title   : "Ver Admin",
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
//        editar   : {
//            label  : "Editar",
//                icon   : "fa fa-pencil",
//                action : function ($element) {
//                var id = $element.data("id");
//                createEditRow(id);
//            }
//        },
                cerrar   : {
                    label  : "Cerrar administración",
                    icon   : "fa fa-times-circle",
                    separator_before : true,
                    action : function ($element) {
                        var id = $element.data("id");
                        cerrarAdministracion(id);
                    }
                }
//                ,
//                eliminar : {
//                    label            : "Eliminar",
//                    icon             : "fa fa-trash-o",
//                    separator_before : true,
//                    action           : function ($element) {
//                        var id = $element.data("id");
//                        deleteRow(id);
//                    }
//                }
            },
            onShow : function ($element) {
                $element.addClass("success");
            },
            onHide : function ($element) {
                $(".success").removeClass("success");
            }
        });
    });


    function cerrarAdministracion(id) {
        $.ajax({
           type: 'POST',
            url:'${createLink(controller: 'admin', action: 'cerrar_ajax')}',
            data:{
                id:id
            },
            success: function (msg){
                bootbox.dialog({
                    title   : "Cierre de período de administración",
                    message : msg,
                    class   : "modal-lg",
                    buttons : {
                        cancelar      : {
                            label     : "Salir",
                            className : "btn-default",
                            callback  : function () {
                            }
                        },
                        guardar      : {
                            label     : "Guardar",
                            className : "btn-success",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }


</script>

</body>
</html>
