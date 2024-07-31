<%@ page import="cratos.Contabilidad" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Contabilidades</title>
</head>

<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-info btnCrear">
            <i class="fa fa-file-o"></i> Nueva contabilidad
        </a>
    </div>
</div>

<div class="vertical-container vertical-container-list">
    <p class="css-vertical-text">Lista de Contabilidades</p>

    <div class="linea"></div>
    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <tr>
            <g:sortableColumn property="fechaInicio" title="Fecha Inicio"/>
            <g:sortableColumn property="fechaCierre" title="Fecha Cierre"/>
            <g:sortableColumn property="prefijo" title="Prefijo"/>
            <g:sortableColumn property="descripcion" title="Descripción"/>
            <th width="110">Acciones</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${contabilidadInstanceList}" status="i" var="contabilidadInstance">
            <tr data-id="${contabilidadInstance.id}">
                <td style="color: #2fd152; text-align: center"><g:formatDate date="${contabilidadInstance.fechaInicio}" format="dd-MM-yyyy"/></td>
                <td style="text-align: center"><g:formatDate date="${contabilidadInstance.fechaCierre}" format="dd-MM-yyyy"/></td>
                <td>${fieldValue(bean: contabilidadInstance, field: "prefijo")}</td>
                <td>${fieldValue(bean: contabilidadInstance, field: "descripcion")}</td>
                <td>
                    <a href="#" data-id="${contabilidadInstance.id}" class="btn btn-info btn-sm btn-show btn-ajax" title="Ver">
                        <i class="fa fa-laptop"></i>
                    </a>
                    <a href="#" data-id="${contabilidadInstance.id}" class="btn btn-success btn-sm btn-edit btn-ajax" title="Editar">
                        <i class="fa fa-pencil"></i>
                    </a>
                    <a href="#" data-id="${contabilidadInstance.id}" class="btn btn-danger btn-sm btn-delete btn-ajax" title="Eliminar">
                        <i class="fa fa-trash-o"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>
<elm:pagination total="${contabilidadInstanceCount}" params="${params}"/>

<script type="text/javascript">



    $(".btnCrear").click(function () {
        if(${cuentas > 0}){
            createEditRow();
            return false;
        }else{
            $.ajax({
                type:'POST',
                url: '${createLink(controller: 'contabilidad', action: 'crear_ajax')}',
                data:{

                },
                success: function (msg){
                    bootbox.dialog({
                        title   : "Plan de cuentas",
                        message : msg,
                        class : 'long',
                        buttons : {
                            ok : {
                                label     : "<i class='fa fa-times'></i> Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
        }
    });



    var id = null;
    function submitForm() {
        var $form = $("#frmContabilidad");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Grabando");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("_");
                    log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
                    if (parts[0] == "OK") {
                        setTimeout(function () {
                            location.reload(true);
                        }, 1200);
                    } else {
                        closeLoader();
//                                spinner.replaceWith($btn);
                        return false;
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
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar la Contabilidad seleccionada? Esta acción no se puede deshacer.</p>",
            buttons : {
                cancelar : {
                    label     : "<i class='fa fa-times'></i> Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash-o'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Eliminando");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                var parts = msg.split("_");
                                log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] == "OK") {
                                    setTimeout(function () {
                                        location.reload(true);
                                    }, 1200);
                                } else {
                                    closeLoader();
//                                            spinner.replaceWith($btn);
                                    return false;
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
        var data = id ? { id : id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Contabilidad",
                    message : msg,
                    class : 'long',
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitForm();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").not(".datepicker").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    $(function () {



        $(".btn-show").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'show_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    bootbox.dialog({
                        title   : "Ver datos de la Contabilidad",
                        message : msg,
                        buttons : {
                            ok : {
                                label     : "<i class='fa fa-times'></i> Aceptar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
        });
        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            createEditRow(id);
        });
        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            deleteRow(id);
        });

    });


    $(".btnNueva").click(function () {
        $.ajax({
            type: 'POST',
            %{--url: '${createLink(controller: 'contabilidad', action: 'formPeriodo_ajax')}',--}%
            url: '${createLink(controller: 'contabilidad', action: 'form_ajax')}',
            data:{

            },
            success: function (msg){
                var b = bootbox.dialog({
                    id      : "dlgNuevaContabilidad",
                    title   : "Nueva Contabilidad",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSaveNueva",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {

                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {

                }, 500);
            }
        });
    });

</script>

</body>
</html>
