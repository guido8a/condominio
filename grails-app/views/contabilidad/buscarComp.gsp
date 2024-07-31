<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Buscar Comprobantes</title>
</head>

<body>
<div style="margin-top: -15px;" class="vertical-container">
    <p class="css-icono" style="margin-bottom: -15px"><i class="fa fa-folder-open-o"></i></p>

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

            <a href="#" name="busqueda" class="btn btn-info btnBusqueda btn-ajax">
                <i class="fa fa-check-square-o"></i> Buscar</a>

            <a href="#" name="limpiarBus" class="btn btn-warning btnLimpiarBusqueda btn-ajax" title="Borrar criterios" style="height: 34px">
                <i class="fa fa-eraser"></i></a>
        </div>

        <div  class="col-xs-2" style="width: 260px; border-style: solid; border-radius:10px; border-width: 1px;
        margin-left: 0px; height: 68px; border-color: #0c6cc2">
            <div class="col-xs-3" style="padding: 5px; height:30px;
            text-align: center; width: 100%;">
                <span class="text-info" style="font-size: 15px"><strong>${session.contabilidad.descripcion}</strong></span>
            </div>
            <div style="width: 100%; text-align: center;">
                <a href="#" class="btn btn-azul btn-sm" id="btnCambiarConta" style="margin-left: 5px;" title="Cambiar a otra Contabilidad">
                    <i class="fa fa-refresh"></i> Cambiar Contabilidad
                </a>
            </div>
        </div>

    </div>
</div>


<div style="margin-top: 30px; min-height: 650px" class="vertical-container">
    <p class="css-vertical-text">Comprobantes encontrados</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 1070px">
        <thead>
        <tr>
            <th class="alinear" style="width: 100px">Fecha</th>
            <th class="alinear" style="width: 100px">Tipo</th>
            <th class="alinear" style="width: 500px">Descripción</th>
            <th class="alinear" style="width: 170px">Documento</th>
            <th class="alinear" style="width: 200px">Valor</th>
        </tr>
        </thead>
    </table>

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
            url: '${createLink(controller: 'proceso', action: 'revisarFecha_ajax')}',
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
                        url: '${createLink(controller: 'contabilidad', action: 'tablaComprobantes_ajax')}',
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

    $("#btnCambiarConta").click(function () {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'proceso', action: 'cambiarContabilidad_ajax')}",
            data:{
                tipo : 1
            },
            success: function(msg){
                bootbox.dialog({
                    title   : "",
                    message : msg,
                    class    : "long",
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        })
    });

    $(".btnLimpiarBusqueda").click(function () {
        $("#descripcionComp").val('');
        $(".fechaDC").val('');
        $(".fechaHC").val('');
        buscarComprobantes();
    });

    function createContextMenu(node) {
        var $tr = $(node);

        var items = {
            header: {
                label: "Acciones",
                header: true
            }
        };

        var id = $tr.data("id");

        var comprobante = {
            label: 'ComprobanteCont',
            icon: 'fa fa-calendar-o',
            action: function () {
                location.href="${createLink(controller: 'proceso', action: 'comprobante')}/?proceso=" + id
            }
        };

        items.comprobante = comprobante;


        return items
    }

</script>



</body>
</html>