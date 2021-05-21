
<%@ page import="condominio.CajaChica" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Caja Chica</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-primary btnCrear">
            <i class="fa fa-file-o"></i> Nueva caja chica
        </a>
    </div>
</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th>Condominio</th>
        <th>Fecha</th>
        <th>Valor</th>
        <th>Cheque</th>
        <th>Observaciones</th>
    </tr>
    </thead>

    <tbody>
    <g:if test="${cajas.size() > 0}">
        <g:each in="${cajas}" status="i" var="caja">
            <tr data-id="${caja.id}">
                <td>${caja.condominio?.nombre}</td>
                <td>${caja.fecha.format("dd-MM-yyyy")}</td>
                <td>${caja.valor}</td>
                <td>${caja.cheque}</td>
                <td>${caja.observaciones}</td>
            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="5">
                No se encontraron registros que mostrar
            </td>
        </tr>
    </g:else>
    </tbody>
</table>


<script type="text/javascript">
    %{--var id = null;--}%
    function submitFormCaja() {
        var $form = $("#frmCajaChica");
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
                        log("Caja chica guardada correctamente","success");
                        setTimeout(function() {
                            location.reload(true);
                        },1000);
                    }else{
                        log("Error al guardar la caja chica","error")
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
            "¿Está seguro que desea eliminar la caja chica seleccionada? Esta acción no se puede deshacer.</p>",
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
                            url     : '${createLink(controller:'cajaChica', action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                closeLoader();
                                if(msg == 'ok'){
                                    log("Caja chica borrada correctamente","success");
                                    setTimeout(function() {
                                        location.reload(true);
                                    },1000);
                                }else{
                                    log("Error al borrar la caja chica","error")
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
            url     : "${createLink(controller:'cajaChica', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Caja Chica",

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
                                return submitFormCaja();
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
                %{--ver      : {--}%
                %{--label  : "Ver",--}%
                %{--icon   : "fa fa-search",--}%
                %{--action : function ($element) {--}%
                %{--var id = $element.data("id");--}%
                %{--$.ajax({--}%
                %{--type    : "POST",--}%
                %{--url     : "${createLink(controller:'edificio', action:'show_ajax')}",--}%
                %{--data    : {--}%
                %{--id : id--}%
                %{--},--}%
                %{--success : function (msg) {--}%
                %{--bootbox.dialog({--}%
                %{--title   : "Ver Edificio",--}%
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
