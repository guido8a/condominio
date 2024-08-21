<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Buscar Comprobantes</title>
</head>

<body>
<div style="margin-top: -15px;" class="vertical-container">
    <p class="css-icono" style="margin-bottom: -15px"><i class="fa fa-file"></i></p>

    <div class="linea45"></div>

    <div class="row" style="margin-bottom: 10px;">

        <div class="col-xs-3" style="margin-left: 10px; margin-right: 30px">
            Descripción Comprobante:
            <g:textField name="descripcion_name" id="descripcionComp" class="form-control" style="width: 300px"/>
        </div>

        <div class="col-xs-2" style="width: 160px;">
            Desde:
            <elm:datepicker name="fechaDesde" title="Fecha desde" id="fd" class="datepicker form-control fechaDC"
                            maxDate="new Date()"/>
        </div>

        <div class="col-xs-2" style="width: 160px; margin-left: -20px">
            Hasta:
            <elm:datepicker name="fechaHasta" title="Fecha hasta" class="datepicker form-control fechaHC"
                            maxDate="new Date()"/>
        </div>

        <div class="btn-group col-xs-2" style="margin-left: -20px; margin-top: 20px; width: 160px;">

            <a href="#" name="busqueda" class="btn btn-info btnBusqueda btn-ajax" title="Buscar comprobante">
                <i class="fa fa-search"></i></a>

            <a href="#" name="limpiarBus" class="btn btn-warning btnLimpiarBusqueda btn-ajax" title="Borrar criterios">
                <i class="fa fa-eraser"></i></a>
        </div>

        %{--        <div  class="col-xs-2" style="width: 260px; border-style: solid; border-radius:10px; border-width: 1px;--}%
        %{--        margin-left: 0px; height: 68px; border-color: #0c6cc2">--}%
        %{--            <div class="col-xs-3" style="padding: 5px; height:30px;--}%
        %{--            text-align: center; width: 100%;">--}%
        %{--                <span class="text-info" style="font-size: 15px"><strong>${contabilidad?.descripcion}</strong></span>--}%
        %{--            </div>--}%
        %{--            <div style="width: 100%; text-align: center;">--}%
        %{--                <a href="#" class="btn btn-azul btn-sm" id="btnCambiarConta" style="margin-left: 5px;" title="Cambiar a otra Contabilidad">--}%
        %{--                    <i class="fa fa-refresh"></i> Cambiar Contabilidad--}%
        %{--                </a>--}%
        %{--            </div>--}%
        %{--        </div>--}%

    </div>
</div>


<div style="margin-top: 30px; min-height: 550px" class="vertical-container">
    <p class="css-vertical-text">Comprobantes</p>

    <div class="linea"></div>

    <div id="divComprobantes">
    </div>
</div>



<script type="text/javascript">

    $("input").keyup(function (ev) {
        if (ev.keyCode === 13) {
            $(".btnBusqueda").click();
        }
    });

    buscarComprobantes();

    $(".btnBusqueda").click(function () {
        buscarComprobantes();
    });

    function buscarComprobantes () {
        var desc = $("#descripcionComp").val();
        var fechaD = $(".fechaDC").val();
        var fechaH = $(".fechaHC").val();

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'comprobanteCont', action: 'revisarFecha_ajax')}',
            data:{
                desde: fechaD,
                hasta: fechaH
            },
            success: function (msg){
                if(msg !== 'ok'){
                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                    return false;
                }else{

                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'comprobanteCont', action: 'tablaComprobantes_ajax')}',
                        data:{
                            descripcion: desc,
                            desde: fechaD,
                            hasta: fechaH
                        },
                        success: function (msg) {
                            $("#divComprobantes").html(msg)
                        }
                    });
                }
            }
        });
    }

    %{--$("#btnCambiarConta").click(function () {--}%
    %{--    $.ajax({--}%
    %{--        type: 'POST',--}%
    %{--        url: "${createLink(controller: 'proceso', action: 'cambiarContabilidad_ajax')}",--}%
    %{--        data:{--}%
    %{--            tipo : 1--}%
    %{--        },--}%
    %{--        success: function(msg){--}%
    %{--            bootbox.dialog({--}%
    %{--                title   : "",--}%
    %{--                message : msg,--}%
    %{--                class    : "long",--}%
    %{--                buttons : {--}%
    %{--                    cancelar : {--}%
    %{--                        label     : "<i class='fa fa-times'></i> Cancelar",--}%
    %{--                        className : "btn-primary",--}%
    %{--                        callback  : function () {--}%
    %{--                        }--}%
    %{--                    }--}%
    %{--                }--}%
    %{--            });--}%
    %{--        }--}%
    %{--    })--}%
    %{--});--}%

    $(".btnLimpiarBusqueda").click(function () {
        $("#descripcionComp").val('');
        $(".fechaDC").val('');
        $(".fechaHC").val('');
        buscarComprobantes();
    });

    function createEditRowComprobante(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Comprobante",
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
                                return submitFormComprobante();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormComprobante() {
        var $form = $("#frmFuente");
        if ($form.valid()) {
            openLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    closeLoader();
                    var parts = msg.split("_");
                    if (parts[0] === "ok") {
                        log(parts[1], "success");
                        buscarComprobantes();
                    } else {
                        log(parts[1], "error");
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
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar la Fuente seleccionada? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Borrando....");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                closeLoader();
                                var parts = msg.split("_");
                                if (parts[0] === "ok") {
                                    log(parts[1], "success");
                                    buscarComprobantes();
                                } else {
                                    log(parts[1], "error");
                                    return false;
                                }
                            }
                        });
                    }
                }
            }
        });
    }

    $(".btnCrear").click(function() {
        createEditRowComprobante();
        return false;
    });


</script>



</body>
</html>