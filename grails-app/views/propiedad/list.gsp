
<%@ page import="condominio.Propiedad" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Propiedad</title>

    <style type="text/css">

        .centro {
            text-align: center;
        }

        .derecha{
            text-align: right;
        }

    </style>

</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

%{--<!-- botones -->--}%
%{--<div class="btn-toolbar toolbar">--}%
    %{--<div class="btn-group">--}%
        %{--<a href="#" class="btn btn-primary btnCrear">--}%
            %{--<i class="fa fa-file-o"></i> Agregar Propiedad--}%
        %{--</a>--}%
    %{--</div>--}%
%{--</div>--}%

<div class="row" style="margin-bottom: 20px">


    <div class="col-md-3"></div>

    <div class="col-md-1">
        <label>Persona</label>
    </div>


    <div class="col-md-4">
        <g:select from="${seguridad.Persona.list().sort{it.apellido}}"
                  name="persona_name" id="personaId" optionValue="${{it.apellido + " " + it.nombre + " - Departamento: " + it.departamento }}" optionKey="id" class="form-control"/>
    </div>

    <div class="btn-group">
        <a href="#" class="btn btn-primary btnCrear">
            <i class="fa fa-file-o"></i> Agregar Propiedad
        </a>
    </div>
</div>



<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>
        <th style="width: 23%">Tipo de Propiedad</th>
        <th style="width: 15%">Número</th>
        <th style="width: 10%">Área</th>
        <th style="width: 10%">Valor</th>
        <th style="width: 10%">Alícuota</th>
        <th style="width: 14%">Fecha Desde</th>
        <th style="width: 14%">Fecha Hasta</th>
        <th style="width: 2%"></th>
    </tr>
    </thead>
    <tbody>

    </tbody>
</table>

<div id="divTablaPropiedades">


</div>

<script type="text/javascript">


    cargarTablaPropiedades($("#personaId option:selected").val());

    $("#personaId").change(function () {
        cargarTablaPropiedades($("#personaId option:selected").val());
    });


    function cargarTablaPropiedades (persona) {
       $.ajax({
           type: 'POST',
            url: "${createLink(controller: 'propiedad', action: 'tablaPropiedades_ajax')}",
            data:{
                id: persona
            },
            success: function (msg){
                $("#divTablaPropiedades").html(msg)
            }
        });
    }


    var id = null;
    function submitFormPropiedad() {
        var $form = $("#frmPropiedad");
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
                        log("Propiedad guardada correctamente","success");
                        cargarTablaPropiedades($("#personaId option:selected").val());
                    }else{
                        log("Error al guardar la propiedad","error")
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
            "¿Está seguro que desea eliminar el Propiedad seleccionado? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Propiedad");
                                $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'propiedad', action:'delete_ajax')}',
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
        var title = id ? "Editar" : "Nueva ";
        var data = id ? { id: id } : {};
                $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'propiedad', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Propiedad",
                    
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
                                return submitFormPropiedad();
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

                %{--$("tbody>tr").contextMenu({--}%
            %{--items  : {--}%
                %{--header   : {--}%
                    %{--label  : "Acciones",--}%
                    %{--header : true--}%
                %{--},--}%
                %{--ver      : {--}%
                    %{--label  : "Ver",--}%
                    %{--icon   : "fa fa-search",--}%
                    %{--action : function ($element) {--}%
            %{--var id = $element.data("id");--}%
                                %{--$.ajax({--}%
                %{--type    : "POST",--}%
                %{--url     : "${createLink(controller:'propiedad', action:'show_ajax')}",--}%
                %{--data    : {--}%
                    %{--id : id--}%
                %{--},--}%
                %{--success : function (msg) {--}%
                    %{--bootbox.dialog({--}%
                        %{--title   : "Ver Propiedad",--}%
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
    %{--},--}%
        %{--editar   : {--}%
            %{--label  : "Editar",--}%
                %{--icon   : "fa fa-pencil",--}%
                %{--action : function ($element) {--}%
                %{--var id = $element.data("id");--}%
                %{--createEditRow(id);--}%
            %{--}--}%
        %{--},--}%
        %{--eliminar : {--}%
            %{--label            : "Eliminar",--}%
                %{--icon             : "fa fa-trash-o",--}%
                %{--separator_before : true,--}%
                %{--action           : function ($element) {--}%
                %{--var id = $element.data("id");--}%
                %{--deleteRow(id);--}%
            %{--}--}%
        %{--}--}%
    %{--},--}%
        %{--onShow : function ($element) {--}%
        %{--$element.addClass("success");--}%
        %{--},--}%
        %{--onHide : function ($element) {--}%
        %{--$(".success").removeClass("success");--}%
        %{--}--}%
    %{--});--}%
    });
</script>

</body>
</html>
