<%@ page contentType="text/html;charset=UTF-8" %>

<%
    def buscadorServ = grailsApplication.classLoader.loadClass('utilitarios.BuscadorService').newInstance()
%>

<html>
<head>
    <meta name="layout" content="main">
    <title>Propietarios del Condominio</title>

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
                <div class="col-xs-6">
                    <div class="col-xs-4">
                        <b>Buscar por: </b>
                        <elm:select name="buscador" from = "${buscadorServ.parmProcesos()}" value="${params.buscador}"
                                    optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con"
                                    style="width: 120px" class="form-control"/>
                    </div>
                    <div class="col-xs-4">
                        <strong style="margin-left: 20px;">Operación:</strong>
                        <span id="selOpt"></span>
                    </div>
                    <div class="col-xs-4">
                        <b style="margin-left: 20px">Criterio: </b>
                        <g:textField name="criterio" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                                     id="criterio_con" class="form-control"/>

                    </div>
                </div>

                <div class="btn-group col-xs-1" style="margin-left: -10px; margin-top: 20px; width: 110px;">

                    <a href="#" name="busqueda" class="btn btn-info" id="btnBusqueda" title="Buscar"
                       style="height: 34px; padding: 9px; width: 46px">
                        <i class="fa fa-search"></i></a>

                    <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                       title="Borrar criterios" style="height: 34px; padding: 9px; width: 34px">
                        <i class="fa fa-eraser"></i></a>
                </div>

            </div>

        </div>
    </div>

%{--
    <div class="row" style="border-style: solid; border-radius:6px; border-width: 1px;
    height: 40px; border-color: #0c6cc2; margin-left: 10px;">
        <div class="col-xs-5" style="margin-left: 5px; margin-top: 2px;">
            <g:link class="btn btn-success" action="nuevoProceso" style="margin-left: -15px">
                <i class="fa fa-file-o"></i> Crear Persona
            </g:link>
            <g:link class="btn btn-primary" action="procesosAnulados">
                <i class="fa fa-times-circle"></i> Ir a Gastos
            </g:link>
        </div>
    </div>
--}%

</div>

<div style="margin-top: 30px; min-height: 650px" class="vertical-container">
    <p class="css-vertical-text">Procesos encontrados</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 1070px">
        <thead>
        <tr>
            <th class="alinear" style="width: 10%">Edificio</th>
            <th class="alinear" style="width: 20%">Nombre</th>
            <th class="alinear" style="width: 20%">Apellido</th>
            <th class="alinear" style="width: 7%">Dept.</th>
            <th class="alinear" style="width: 10%">Teléfono</th>
            <th class="alinear" style="width: 15%">Correo electrónico</th>
            <th class="alinear" style="width: 8%">Alícutoa</th>
            <th class="alinear" style="width: 10%">Cargo</th>
        </tr>
        </thead>
    </table>


    <div class="alert alert-danger hidden" id="mensaje" style="text-align: center">
    </div>

    <div id="bandeja">
    </div>
</div>

<div><strong>Nota</strong>: Si existen muchos registros que coinciden con el criterio de búsqueda, se retorna
como máximo 30 <span style="margin-left: 40px; color: #0b2c89">Se ordena por fecha de proceso desde el más reciente</span>
</div>

<div class="modal fade " id="dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                Problema y Solución..
            </div>

            <div class="modal-body" id="dialog-body" style="padding: 15px">

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>


<script type="text/javascript">


    $(function () {
        $("#limpiaBuscar").click(function () {
            $("#buscar").val('');
        });
    });

    <g:if test="${condominio}">
    cargarBusqueda();
    </g:if>
    <g:else>
    $("#mensaje").removeClass('hidden').append("No existen registros de propietarios");
    </g:else>


    function cargarBusqueda () {
        var vvnd = parseInt(${condominio?.viviendas})
        console.log("cont", vvnd);
        if(vvnd > 0) {
            $("#bandeja").html("").append($("<div style='width:100%; text-align: center;'/>").append(spinnerSquare64));
            var desde = $(".fechaD").val();
            var hasta = $(".fechaH").val();
            $.ajax({
                type: "POST",
                url: "${g.createLink(controller: 'vivienda', action: 'tablaBuscar')}",
                data: {
                    buscador: $("#buscador_con").val(),
                    criterio: $("#criterio_con").val(),
                    operador: $("#oprd").val()
                },
                success: function (msg) {
                    $("#bandeja").html(msg);
                },
                error: function (msg) {
                    $("#bandeja").html("Ha ocurrido un error");
                }
            });
        }
    }

    $("#btnBusqueda").click(function () {
        cargarBusqueda();
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            $("#btnBusqueda").click();
        }
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

        var editar = {
            label: " Editar Persona",
            icon: "fa fa-file-text-o",
            action: function () {
                location.href = '${createLink(controller: "proceso", action: "nuevoProceso")}?id=' + id;
            }
        };

        items.editar = editar;

//        if(tp == 'Compras' || tp == 'Ventas' || tp == 'Transferencias' || tp == 'Nota de crédito'){

        return items
    }

    $("#btnLimpiarBusqueda").click(function () {
        $(".fechaD, .fechaH, #criterio_con").val('');
    });

    $("#buscador_con").change(function(){
        console.log("hola");
        var anterior = "${params.operador}";
        var opciones = $(this).find("option:selected").attr("class").split(",");

        poneOperadores(opciones);
        /* regresa a la opción seleccionada */
//        $("#oprd option[value=" + anterior + "]").prop('selected', true);
    });


    function poneOperadores (opcn) {
        var $sel = $("<select name='operador' id='oprd' style='width: 120px' class='form-control'>");
        for(var i=0; i<opcn.length; i++) {
            var opt = opcn[i].split(":");
            var $opt = $("<option value='"+opt[0]+"'>"+opt[1]+"</option>");
            $sel.append($opt);
        }
        $("#selOpt").html($sel);
    };

    /* inicializa el select de oprd con la primea opción de busacdor */
    $(document).ready(function() {
        $("#buscador_con").change();
    });




</script>

</body>
</html>