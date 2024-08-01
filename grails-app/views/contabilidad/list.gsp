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
        <a href="#" class="btn btn-primary btnCrear">
            <i class="fa fa-file-o"></i> Nueva contabilidad
        </a>
    </div>
</div>

<div>
    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <tr>
            <g:sortableColumn property="fechaInicio" title="Fecha Inicio"/>
            <g:sortableColumn property="fechaCierre" title="Fecha Cierre"/>
            <g:sortableColumn property="prefijo" title="Prefijo"/>
            <g:sortableColumn property="descripcion" title="Descripción"/>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${contabilidadInstanceList}" status="i" var="contabilidadInstance">
            <tr data-id="${contabilidadInstance.id}">
                <td style="color: #2fd152; text-align: center"><g:formatDate date="${contabilidadInstance.fechaInicio}" format="dd-MM-yyyy"/></td>
                <td style="text-align: center"><g:formatDate date="${contabilidadInstance.fechaCierre}" format="dd-MM-yyyy"/></td>
                <td>${fieldValue(bean: contabilidadInstance, field: "prefijo")}</td>
                <td>${fieldValue(bean: contabilidadInstance, field: "descripcion")}</td>
                <td style="width: 15%; text-align: center">
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

    var id = null;

    $(".btnCrear").click(function () {

        <g:if test="${cuentas > 0}">
        createEditRowContabilidad();
        </g:if>
        <g:else>
        $.ajax({
            type:'POST',
            url: '${createLink(controller: 'contabilidad', action: 'crear_ajax')}',
            data:{
            },
            success: function (msg){
                bootbox.dialog({
                    title   : "Plan de cuentas",
                    message : msg,
                    // class : 'long',
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
        </g:else>


        %{--if(${cuentas > 0}){--}%
        %{--    createEditRowContabilidad();--}%
        %{--    return false;--}%
        %{--}else{--}%
        %{--    $.ajax({--}%
        %{--        type:'POST',--}%
        %{--        url: '${createLink(controller: 'contabilidad', action: 'crear_ajax')}',--}%
        %{--        data:{--}%
        %{--        },--}%
        %{--        success: function (msg){--}%
        %{--            bootbox.dialog({--}%
        %{--                title   : "Plan de cuentas",--}%
        %{--                message : msg,--}%
        %{--                // class : 'long',--}%
        %{--                buttons : {--}%
        %{--                    ok : {--}%
        %{--                        label     : "<i class='fa fa-times'></i> Cancelar",--}%
        %{--                        className : "btn-primary",--}%
        %{--                        callback  : function () {--}%
        %{--                        }--}%
        %{--                    }--}%
        %{--                }--}%
        %{--            });--}%
        %{--        }--}%
        %{--    });--}%
        %{--}--}%
    });

    function submitFormContabilidad() {
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
                    closeLoader();
                    var parts = msg.split("_");
                    if (parts[0] === "OK") {
                        log(parts[1], "success");
                        setTimeout(function () {
                            location.reload();
                        }, 1000);
                    }else {
                        log(parts[1], 'error');
                        return false;
                    }
                }
            });
        } else {
            return false;
        } //else
    }
    function deleteRowContabilidad(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p style='font-size: 14px'> Está seguro que desea eliminar la Contabilidad seleccionada? <br> Esta acción no se puede deshacer.</p>",
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
                                closeLoader();
                                var parts = msg.split("_");
                                if (parts[0] === "OK") {
                                    log(parts[1], "success");
                                    setTimeout(function () {
                                        location.reload();
                                    }, 1000);
                                }else {
                                    log(parts[1], 'error');
                                    return false;
                                }
                            }
                        });
                    }
                }
            }
        });
    }
    function createEditRowContabilidad(id) {
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
                    // class : 'long',
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
                                return submitFormContabilidad();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit


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
        createEditRowContabilidad(id);
    });
    $(".btn-delete").click(function () {
        var id = $(this).data("id");
        deleteRowContabilidad(id);
    });



    %{--$(".btnNueva").click(function () {--}%
    %{--    $.ajax({--}%
    %{--        type: 'POST',--}%
    %{--        url: '${createLink(controller: 'contabilidad', action: 'form_ajax')}',--}%
    %{--        data:{--}%

    %{--        },--}%
    %{--        success: function (msg){--}%
    %{--            var b = bootbox.dialog({--}%
    %{--                id      : "dlgNuevaContabilidad",--}%
    %{--                title   : "Nueva Contabilidad",--}%
    %{--                message : msg,--}%
    %{--                buttons : {--}%
    %{--                    cancelar : {--}%
    %{--                        label     : "<i class='fa fa-times'></i> Cancelar",--}%
    %{--                        className : "btn-primary",--}%
    %{--                        callback  : function () {--}%
    %{--                        }--}%
    %{--                    },--}%
    %{--                    guardar  : {--}%
    %{--                        id        : "btnSaveNueva",--}%
    %{--                        label     : "<i class='fa fa-save'></i> Guardar",--}%
    %{--                        className : "btn-success",--}%
    %{--                        callback  : function () {--}%

    %{--                        } //callback--}%
    %{--                    } //guardar--}%
    %{--                } //buttons--}%
    %{--            }); //dialog--}%
    %{--            setTimeout(function () {--}%

    %{--            }, 500);--}%
    %{--        }--}%
    %{--    });--}%
    %{--});--}%

</script>

</body>
</html>
