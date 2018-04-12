<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 11/04/18
  Time: 11:24
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Obras </title>

    <style type="text/css">

    .alinear {
        text-align: center !important;
    }
    </style>
</head>

<body>



<div style="margin-top: -15px;" class="vertical-container">
    <p class="css-icono" style="margin-bottom: -15px"><i class="fa fa-folder-open-o"></i></p>

    <div class="linea45"></div>

    <div class="row" style="margin-bottom: 10px;">

        <div class="row-fluid">
            <div style="margin-left: 20px;">
                <div class="col-xs-7 col-md-7">
                    <div class="col-xs-3 col-md-5">
                        <b>Buscar por: </b>
                        <g:select name="buscardor_name" id="buscador" from="${[0: 'Seleccione...', 1 : 'Tipo Obra', 2: 'Solicitante', 3: 'Proveedor', 4: 'Descripción de la Obra']}"  class="form-control" optionKey="key" optionValue="value"/>

                    </div>
                    <div class="col-xs-3 col-md-5">
                        <b style="margin-left: 20px">Criterio: </b>

                        <div id="divRes">

                        </div>
                    </div>
                </div>

                <div class="col-xs-3 col-md-5">
                    <div class="btn-group col-xs-6 col-md-5" style="margin-left: -10px; margin-top: 20px;">

                        <a href="#" name="busqueda" class="btn btn-info" id="btnBusqueda" title="Buscar">
                            <i class="fa fa-search"></i> Buscar
                        </a>

                        <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                           title="Borrar criterios" style="height: 38px; padding: 9px; width: 34px">
                            <i class="fa fa-eraser"></i></a>
                    </div>
                    <div class="btn-group col-xs-3 col-md-4" style="margin-left: -10px; margin-top: 20px;">
                        <a href="#" class="btn btn-success" id="btnObra" title="Crear Obra">
                            <i class="fa fa-building"></i> Nueva Obra
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div style="margin-top: 30px; min-height: 450px" class="vertical-container">
    <p class="css-vertical-text">Obras</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 1070px">
        <thead>
        <tr>
            <th class="alinear" style="width: 15%">Tipo Obra</th>
            <th class="alinear" style="width: 25%">Descripción</th>
            <th class="alinear" style="width: 15%">Proveedor</th>
            <th class="alinear" style="width: 15%">Solicitante</th>
            <th class="alinear" style="width: 10%">Fecha</th>
            <th class="alinear" style="width: 20%">Observaciones</th>
        </tr>
        </thead>
    </table>


    <div class="alert alert-danger hidden" id="mensaje" style="text-align: center">
    </div>

    <div id="tabla">
    </div>
</div>


<script type="text/javascript">

    $("#btnLimpiarBusqueda").click(function () {
        $("#buscador").val(0);
        cargarCombo($("#buscador").val());
        cargarTablaObras($("#buscador").val(),$("#combo").val(), '');
    });

    cargarTablaObras($("#buscador").val(),$("#combo").val(), '');

    $("#btnObra").click(function () {
        createEditRow();
        return false;
    });

    function createEditRow(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'obra', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Obra",

                    class   : "modal-lg",

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
                                return submitFormObra();
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

    function submitFormObra() {
        var $form = $("#frmObra");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Obra");
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
            "¿Está seguro que desea eliminar la Obra seleccionada? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Obra");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'obra', action:'delete_ajax')}',
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

    cargarCombo($("#buscador").val());

    $("#buscador").change(function () {
        var sel = $(this).val();
        cargarCombo(sel)
    });

    function cargarCombo (sel) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'obra', action: 'buscador_ajax')}',
            data:{
                seleccionado: sel
            },
            success: function (msg){
                $("#divRes").html(msg)
            }
        });
    }

    $("#btnBusqueda").click(function () {
        var combo1 = $("#buscador").val();
        var combo2 = $("#combo").val();
        var txto = ($("#buscador").val() == '4' ?  $("#criterio").val() : '');

        cargarTablaObras(combo1, combo2, txto)
    });

    function cargarTablaObras(combo1, combo2, txto){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'obra', action: 'tablaObras_ajax')}',
            data:{
                combo1 : combo1,
                combo2: combo2,
                texto: txto
            },
            success: function (msg){
                $("#tabla").html(msg)
            }
        });
    }


    function createContextMenu(node) {
        var $tr = $(node);
        var items = {
            header: {
                label: "Acciones",
                header: true
            }
        };

        var id = $tr.data("id");


        var editar = {
            label: " Editar Obra",
            icon: "fa fa-building",
            action : function ($element) {
                var id = $element.data("id");
                createEditRow(id);
            }
        };

        var ver = {
            label: "Ver Obra",
            icon: "fa fa-search",
            action : function ($element) {
                var id = $element.data("id");
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'obra', action:'show_ajax')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        bootbox.dialog({
                            title   : "Ver Obra",
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
        };

        var eliminar = {
            label: "Eliminar Obra",
            icon: "fa fa-trash",
            separator_before : true,
            action : function ($element) {
                var id = $element.data("id");
                deleteRow(id);
            }
        };

        items.ver = ver;
        items.editar = editar;
        items.eliminar = eliminar;

        return items
    }


</script>

</body>
</html>