<%@ page import="condominio.Egreso; condominio.PagoEgreso" contentType="text/html;charset=UTF-8" %>

<%
    def buscadorServ = grailsApplication.classLoader.loadClass('utilitarios.BuscadorService').newInstance()
%>

<html>
<head>
    <meta name="layout" content="main">
    <title>Ingresos</title>

    <style type="text/css">
    .alinear {
        text-align: center !important;
    }
    .selecionado {
        background-color: #ffffdf;
    }
    </style>

</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<div style="text-align: center; margin-top: -30px;">
    <h3>Consulta de Ingresos</h3>
</div>

<div class="row">
    <div class="row-fluid">

        <div class="col-sm-2" style="margin-left: -30px">
            Tipo de Aporte
            <g:select from="${condominio.TipoAporte.list()}" optionValue="descripcion" optionKey="id"
                      name="tp" id="tipoAporte" noSelection="['0':'--- Todos los tipos ---']" class="form-control"
                      style="width: 180px;"/>
        </div>

        <div style="margin-left: -20px;">
            <div class="col-xs-6">
                <div class="col-xs-3">
                    <b>Buscar por: </b>
                    <elm:select name="buscador" from = "${buscadorServ.parmIngr()}" value="${params.buscador}"
                                optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con"
                                style="width: 120px" class="form-control"/>
                </div>
                <div class="col-xs-3">
                    <strong style="margin-left: 20px;">Operación:</strong>
                    <span id="selOpt"></span>
                </div>
                <div class="col-xs-3">
                    <b style="margin-left: 20px">Criterio: </b>
                    <g:textField name="criterio" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                                 id="criterio_con" class="form-control"/>

                </div>
                <div class="col-xs-3" style="margin-left: -10px;">
                    <b>Ordenado por:</b>
                    <elm:select name="buscador" from="${buscadorServ.parmIngr()}" value="${params.ordenar}"
                                optionKey="campo" optionValue="nombre" optionClass="operador" id="ordenar_por"
                                style="margin-left:-10px; width: 100%" class="form-control"/>
                </div>
            </div>

            <div class="col-xs-4" style="margin-left: -40px">
                <div class="col-xs-6" style="margin-left: -20px; width: 50%">
                    Desde:
                    <elm:datepicker name="fechaDesde" title="Fecha desde" id="fd" class="datepicker form-control fechaD"
                                    maxDate="new Date()" value="${fcds?: new Date() - 30}"/>
                </div>

                <div class="col-xs-6" style="margin-left: -20px;">
                    Hasta:
                    <elm:datepicker name="fechaHasta" title="Fecha hasta" class="datepicker form-control fechaH"
                                    value="${new Date()}"/>
                </div>
            </div>

            <div class="btn-group col-xs-1" style="margin-left: -80px; margin-top: 20px; width: 100px">

                <a href="#" name="busqueda" class="btn btn-info" id="btnBusqueda" title="Buscar"
                   style="height: 34px; padding: 9px; width: 36px">
                    <i class="fa fa-search"></i></a>

                <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                   title="Borrar criterios" style="height: 34px; padding: 9px; width: 34px">
                    <i class="fa fa-eraser"></i></a>
            </div>

        </div>
    </div>
</div>

<div style="margin-top: 10px; border-bottom: solid; border-style: solid; border-width: 1px; border-color: #C0C0C0"></div>

<div style="margin-top: 20px; min-height: 650px; width: 55%; float: left">
    %{--<div class="linea"></div>--}%
    <table class="table table-bordered table-hover table-condensed">
        <thead>
        <tr>
            <th class="alinear" style="width: 16%">Tipo</th>
            <th class="alinear" style="width: 24%">Concepto</th>
            <th class="alinear" style="width: 18%">Persona</th>
            <th class="alinear" style="width: 12%">Fecha</th>
            <th class="alinear" style="width: 10%">Valor</th>
            <th class="alinear" style="width: 10%">Saldo</th>
        </tr>
        </thead>
    </table>

    <div class="alert alert-danger hidden" id="mensaje" style="text-align: center">
    </div>

    <div id="tabla">
    </div>
</div>

<div style="margin-top: 20px; min-height: 650px; width: 43%; float: right ">
    %{--<div class="linea"></div>--}%
    <div id="tdPagosEgresos" style="width: 100%">

    </div>

    <div class="alert alert-danger hidden" id="mensaje" style="text-align: center">
    </div>

    <div id="tabla">
    </div>
</div>

<script type="text/javascript">


    $(function () {
        $("#limpiaBuscar").click(function () {
            $("#buscar").val('');
        });
    });

    cargarBusqueda();

    function cargarBusqueda() {
        $("#bandeja").html("").append($("<div style='width:100%; text-align: center;'/>").append(spinnerSquare64));
        var desde = $(".fechaD").val();
        var hasta = $(".fechaH").val();
        var tpap = $("#tipoAporte").val();
        $.ajax({
            type: "POST",
            url: "${g.createLink(action: 'tablaBuscar')}",
            data: {
                buscador: $("#buscador_con").val(),
                ordenar: $("#ordenar_por").val(),
                criterio: $("#criterio_con").val(),
                operador: $("#oprd").val(),
                desde: desde,
                hasta: hasta,
                tpap: tpap
            },
            success: function (msg) {
                $("#tabla").html(msg);
            },
            error: function (msg) {
                $("#tabla").html("Ha ocurrido un error");
            }
        });
    }

    $("#btnBusqueda").click(function () {
        cargarBusqueda();
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            $("#btnBusqueda").click();
        }
    });

    $("#btnLimpiarBusqueda").click(function () {
        $("#criterio_con").val('');
        $(".fechaD, .fechaH").val('${new Date().format("dd-MM-yyyy")}');
    });

    $("#nuevo").click(function () {
        createEditRow(null);
    });

    $("#buscador_con").change(function () {
        var anterior = "${params.operador}";
        var opciones = $(this).find("option:selected").attr("class").split(",");

        poneOperadores(opciones);
        /* regresa a la opción seleccionada */
//        $("#oprd option[value=" + anterior + "]").prop('selected', true);
    });


    function poneOperadores(opcn) {
        var $sel = $("<select name='operador' id='oprd' style='width: 120px' class='form-control'>");
        for (var i = 0; i < opcn.length; i++) {
            var opt = opcn[i].split(":");
            var $opt = $("<option value='" + opt[0] + "'>" + opt[1] + "</option>");
            $sel.append($opt);
        }
        $("#selOpt").html($sel);
    }

    /* inicializa el select de oprd con la primea opción de busacdor */
    $(document).ready(function () {
        $("#buscador_con").change();
    });

    %{--function createEditRow(id) {--}%
        %{--var title = id ? "Editar" : "Nueva";--}%
        %{--var data = id ? {id: id} : {};--}%
        %{--$.ajax({--}%
            %{--type: "POST",--}%
            %{--url: "${createLink(controller:'egreso', action:'form_ajax')}",--}%
            %{--data: data,--}%
            %{--success: function (msg) {--}%
                %{--var b = bootbox.dialog({--}%
                    %{--id: "dlgCreateEdit",--}%
                    %{--title: title + " Egreso",--}%
                    %{--size: 'large',--}%
                    %{--message: msg,--}%
                    %{--buttons: {--}%
                        %{--cancelar: {--}%
                            %{--label: "Cancelar",--}%
                            %{--className: "btn-primary",--}%
                            %{--callback: function () {--}%
                            %{--}--}%
                        %{--},--}%
                        %{--guardar: {--}%
                            %{--id: "btnSave",--}%
                            %{--label: "<i class='fa fa-save'></i> Guardar",--}%
                            %{--className: "btn-success",--}%
                            %{--callback: function () {--}%
                                %{--return submitFormPersona();--}%
                            %{--} //callback--}%
                        %{--} //guardar--}%
                    %{--} //buttons--}%
                %{--}); //dialog--}%
                %{--setTimeout(function () {--}%
                    %{--b.find(".form-control").first().focus()--}%
                %{--}, 500);--}%
            %{--} //success--}%
        %{--}); //ajax--}%
    %{--} //createEdit--}%

//    function submitFormPersona() {
//        var $form = $("#frmPersona");
//        var $btn = $("#dlgCreateEdit").find("#btnSave");
//        if ($form.valid()) {
//            $btn.replaceWith(spinner);
//            openLoader("Guardando Persona");
//            $.ajax({
//                type: "POST",
//                url: $form.attr("action"),
//                data: $form.serialize(),
//                success: function (msg) {
//                    if (msg == 'ok') {
//                        log("Persona guardada correctamente", "success");
//                        setTimeout(function () {
//                            spinner.replaceWith($btn);
//                            closeLoader();
////                            cargarBusqueda();
//                        }, 100);
//                    } else {
//                        log("Error al guardar la información de persona", "error")
//                        closeLoader();
//                    }
//                }
//            });
//        } else {
//            return false;
//        } //else
//    }

    %{--function alicuotaEdit(id) {--}%
        %{--$.ajax({--}%
            %{--type: "POST",--}%
            %{--url: "${createLink(controller:'alicuota', action:'form_ajax')}",--}%
            %{--data: {--}%
                %{--id: id--}%
            %{--},--}%
            %{--success: function (msg) {--}%
                %{--var b = bootbox.dialog({--}%
                    %{--id: "dlgAsignarPerfilxx",--}%
                    %{--title: "Alícuota",--}%
%{--//                    class   : "modal-lg",--}%
                    %{--message: msg,--}%
                    %{--buttons: {--}%
                        %{--cancelar: {--}%
                            %{--label: "<i class='fa fa-times'></i> Cerrar",--}%
                            %{--className: "btn-primary",--}%
                            %{--callback: function () {--}%
                            %{--}--}%
                        %{--},--}%
                        %{--guardar: {--}%
                            %{--id: "btnSave",--}%
                            %{--label: "<i class='fa fa-save'></i> Guardar",--}%
                            %{--className: "btn-success",--}%
                            %{--callback: function () {--}%
                                %{--return submitFormAlicuota();--}%
                            %{--} //callback--}%
                        %{--}--}%
                    %{--} //buttons--}%
                %{--}); //dialog--}%
                %{--setTimeout(function () {--}%
                    %{--b.find(".form-control").first().focus()--}%
                %{--}, 100);--}%
            %{--} //success--}%
        %{--}); //ajax--}%
    %{--}--}%

    %{--function submitFormAlicuota() {--}%
        %{--var $form = $("#frmAlicuota");--}%
        %{--var $btn = $("#dlgCreateEdit").find("#btnSave");--}%
        %{--if ($form.valid()) {--}%
            %{--$btn.replaceWith(spinner);--}%
            %{--openLoader("Guardando Alicuota");--}%
            %{--$.ajax({--}%
                %{--type: "POST",--}%
                %{--url: $form.attr("action"),--}%
                %{--data: $form.serialize(),--}%
                %{--success: function (msg) {--}%
                    %{--var parts = msg.split("*");--}%
                    %{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
                    %{--setTimeout(function () {--}%
                        %{--if (parts[0] == "SUCCESS") {--}%
                            %{--spinner.replaceWith($btn);--}%
                            %{--closeLoader();--}%
                            %{--cargarBusqueda();--}%
                            %{--return false;--}%
                        %{--} else {--}%
                            %{--spinner.replaceWith($btn);--}%
                            %{--return false;--}%
                        %{--}--}%
                    %{--}, 100);--}%
                %{--}--}%
            %{--});--}%
        %{--} else {--}%
            %{--return false;--}%
        %{--} //else--}%
    %{--}--}%

    %{--function eliminar (id){--}%
        %{--bootbox.dialog({--}%
            %{--title   : "Alerta",--}%
            %{--message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +--}%
            %{--"¿Está seguro que desea eliminar el Egreso seleccionado? Esta acción no se puede deshacer.</p>",--}%
            %{--buttons : {--}%
                %{--cancelar : {--}%
                    %{--label     : "Cancelar",--}%
                    %{--className : "btn-primary",--}%
                    %{--callback  : function () {--}%
                    %{--}--}%
                %{--},--}%
                %{--eliminar : {--}%
                    %{--label     : "<i class='fa fa-trash-o'></i> Eliminar",--}%
                    %{--className : "btn-danger",--}%
                    %{--callback  : function () {--}%
                        %{--openLoader("Eliminando Egreso");--}%
                        %{--$.ajax({--}%
                            %{--type    : "POST",--}%
                            %{--url     : '${createLink(controller:'egreso', action:'delete_ajax')}',--}%
                            %{--data    : {--}%
                                %{--id : id--}%
                            %{--},--}%
                            %{--success : function (msg) {--}%
                                %{--var parts = msg.split("*");--}%
                                %{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
                                %{--if (parts[0] == "SUCCESS") {--}%
                                    %{--closeLoader();--}%
                                    %{--cargarBusqueda();--}%
                                %{--} else {--}%
                                    %{--closeLoader();--}%
                                %{--}--}%
                            %{--}--}%
                        %{--});--}%
                    %{--}--}%
                %{--}--}%
            %{--}--}%
        %{--});--}%
    %{--}--}%

</script>
</body>
</html>