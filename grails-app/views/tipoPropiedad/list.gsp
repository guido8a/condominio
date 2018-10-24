
<%@ page import="condominio.TipoPropiedad" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Tipo de Propiedades</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-primary btnCrear">
            <i class="fa fa-file-o"></i> Nuevo Tipo
        </a>
    </div>
    <div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link controller="tipopropiedad" action="list" class="btn btn-default btn-search">
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
        
    </tr>
    </thead>
    <tbody>
    <g:if test="${tipoPropiedadInstanceCount > 0}">
        <g:each in="${tipoPropiedadInstanceList}" status="i" var="tipoPropiedadInstance">
            <tr data-id="${tipoPropiedadInstance.id}">
                
                <td>${tipoPropiedadInstance.descripcion}</td>
                
            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="1">
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

<elm:pagination total="${tipoPropiedadInstanceCount}" params="${params}"/>

<script type="text/javascript">
    var id = null;
    function submitFormTipoPropiedad() {
        var $form = $("#frmTipoPropiedad");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
        $btn.replaceWith(spinner);
            openLoader("Guardando...");
                    $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    closeLoader();
                    if (msg == "ok") {
                        log("Tipo de propiedad guardado correctamente","success");
                        setTimeout(function() {
                            location.reload(true);
                        }, 1000);
                    } else {
                        log("Error al guardar el tipo de propiedad","success");
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
            "¿Está seguro que desea eliminar el Tipo de Propiedad seleccionado? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando...");
                                $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'tipoPropiedad', action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                closeLoader();
                                if (msg == "ok") {
                                    log("Tipo de propiedad borrado correctamente","success");
                                    setTimeout(function() {
                                        location.reload(true);
                                    }, 1000);
                                } else {
                                    log("Error al borrar el tipo de propiedad","success");
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
            url     : "${createLink(controller:'tipoPropiedad', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Tipo de Propiedad",
                    
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
                                return submitFormTipoPropiedad();
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
                url     : "${createLink(controller:'tipoPropiedad', action:'show_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    bootbox.dialog({
                        title   : "Ver TipoPropiedad",
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
