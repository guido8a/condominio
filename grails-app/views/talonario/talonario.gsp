<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 16/11/20
  Time: 12:42
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista comprobantes digitales </title>

    <style type="text/css">

    .alinear {
        text-align: center !important;
    }
    </style>
</head>

<body>

<div style="text-align: center; margin-top: -30px;">
    <h3>Comprobantes digitales</h3>
</div>

<div style="margin-top: -15px;" class="vertical-container">
    <p class="css-icono" style="margin-bottom: -15px"><i class="fa fa-folder-open-o"></i></p>

    <div class="linea45"></div>

    <div class="row" style="margin-bottom: 10px;">

        <div class="row-fluid">
            <div style="margin-left: 20px;">
                <div class="col-xs-3 col-md-5">
                    <div class="btn-group col-xs-3 col-md-4" style="margin-left: -10px; margin-top: 20px;">
                        <a href="#" class="btn btn-success" id="btnNuevo" title="Crear Obra">
                            <i class="fa fa-building"></i> Nuevo talonario
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div style="margin-top: 30px; min-height: 450px" class="vertical-container">
    <p class="css-vertical-text">Comprobantes digitales</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 100%">
        <thead>
        <tr>
            <th class="alinear" style="width: 25%">Número inicial</th>
            <th class="alinear" style="width: 25%">Último número usado</th>
            <th class="alinear" style="width: 15%">Fecha</th>
            <th class="alinear" style="width: 15%">Fecha fin</th>
            <th class="alinear" style="width: 10%">Estado</th>
            <th class="alinear" style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>


    <div class="alert alert-danger hidden" id="mensaje" style="text-align: center">
    </div>

    <div id="tabla">
    </div>
</div>


<script type="text/javascript">

    cargarTablaTalonarios();

    $("#btnNuevo").click(function () {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'talonario', action: 'comprobar_ajax')}',
            data:{
                id: '${condominio?.id}'
            },
            success:function (msg) {
                if(msg == 'ok'){
                    createEditRow();
                    return false;
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No se puede crear un talonario, existe uno en estado vigente" + '</strong>');
                    return false;
                }
            }
        });
    });

    function createEditRow(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id: id, condominio: '${condominio?.id}' } : {condominio: '${condominio?.id}'};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'talonario', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Talonario",
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
                                return submitFormTalonario();
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

    function submitFormTalonario() {
        var $form = $("#frmTalonario");
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
                        if(msg == 'ok'){
                            log("Talonario guardado correctamente","success");
                            cargarTablaTalonarios();
                        }else{
                            log("Error al guardar el talonario","error")
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



    function cargarTablaTalonarios(){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'talonario', action: 'tablaTalonario_ajax')}',
            data:{
                id: '${condominio?.id}'
            },
            success: function (msg){
                $("#tabla").html(msg)
            }
        });
    }


    %{--function createContextMenu(node) {--}%
        %{--var $tr = $(node);--}%
        %{--var items = {--}%
            %{--header: {--}%
                %{--label: "Acciones",--}%
                %{--header: true--}%
            %{--}--}%
        %{--};--}%

        %{--var id = $tr.data("id");--}%


        %{--var editar = {--}%
            %{--label: " Editar Obra",--}%
            %{--icon: "fa fa-building",--}%
            %{--action : function ($element) {--}%
                %{--var id = $element.data("id");--}%
                %{--createEditRow(id);--}%
            %{--}--}%
        %{--};--}%

        %{--var ver = {--}%
            %{--label: "Ver Obra",--}%
            %{--icon: "fa fa-search",--}%
            %{--action : function ($element) {--}%
                %{--var id = $element.data("id");--}%
                %{--$.ajax({--}%
                    %{--type    : "POST",--}%
                    %{--url     : "${createLink(controller:'obra', action:'show_ajax')}",--}%
                    %{--data    : {--}%
                        %{--id : id--}%
                    %{--},--}%
                    %{--success : function (msg) {--}%
                        %{--bootbox.dialog({--}%
                            %{--title   : "Ver Obra",--}%
                            %{--message : msg,--}%
                            %{--buttons : {--}%
                                %{--ok : {--}%
                                    %{--label     : "Aceptar",--}%
                                    %{--className : "btn-primary",--}%
                                    %{--callback  : function () {--}%
                                    %{--}--}%
                                %{--}--}%
                            %{--}--}%
                        %{--});--}%
                    %{--}--}%
                %{--});--}%
            %{--}--}%
        %{--};--}%

        %{--var eliminar = {--}%
            %{--label: "Eliminar Obra",--}%
            %{--icon: "fa fa-trash",--}%
            %{--separator_before : true,--}%
            %{--action : function ($element) {--}%
                %{--var id = $element.data("id");--}%
                %{--deleteRow(id);--}%
            %{--}--}%
        %{--};--}%

        %{--if('${session.perfil.codigo}' == 'ADC'){--}%
            %{--items.ver = ver;--}%
            %{--items.editar = editar;--}%
            %{--items.eliminar = eliminar;--}%
        %{--} else {--}%
            %{--items.ver = ver;--}%
        %{--}--}%

        %{--return items--}%
    %{--}--}%


</script>

</body>
</html>