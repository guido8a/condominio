
<%@ page import="condominio.Empleado" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Nómina</title>
    <style type="text/css">

    .alinear {
        text-align: center !important;
    }
    </style>

</head>
<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="${createLink(controller: "empleado", action: "list")}" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    <div class="btn-group">
        <a href="#" class="btn btn-warning btnNuevo"> <i class="fa fa-user "></i> Sueldo anual
        </a>
        <a href="#" class="btn btn-info btnNuevo"> <i class="fa fa-user "></i> Décimo tercero
        </a>
        <a href="#" class="btn btn-primary btnNuevo"> <i class="fa fa-user "></i> Décimo cuarto
        </a>
        <a href="#" class="btn btn-success btnNuevo"> <i class="fa fa-user "></i> Vacaciones
        </a>
    </div>
</div>

<div style="text-align: center; margin-top: 20px;margin-bottom:20px">
    <h3>Nómina del empleado: ${empleado?.nombre + " " + empleado?.apellido}</h3>
</div>

<div style="margin-top: 30px; min-height: 350px" class="vertical-container">
    <p class="css-vertical-text">Nómina</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 100%">
        <tr>
            <th class="alinear" style="width: 12%">Tipo</th>
            <th class="alinear" style="width: 12%">Sueldo</th>
            <th class="alinear" style="width: 7%">Sueldo en el Rol</th>
            <th class="alinear" style="width: 19%">Fondo de reserva</th>
            <th class="alinear" style="width: 7%">Iess</th>
            <th class="alinear" style="width: 6%">Descuento</th>
            <th class="alinear" style="width: 9%">Valor del descuento</th>
            <th class="alinear" style="width: 8%">Fecha Inicio</th>
            <th class="alinear" style="width: 8%">Fecha Fin</th>
            <th class="alinear" style="width: 5%">Bono</th>
            <th class="alinear" style="width: 5%">Bono Valor</th>
        </tr>
    </table>

    <div class="" style="width: 100%;height: 350px; overflow-y: auto;float: right; margin-top: -15px" >
        <table class="table-bordered table-condensed table-hover" width="100%">
            %{--<g:each in="${empleados}" var="empleado">--}%
                %{--<tr data-id="${empleado?.id}">--}%
                    %{--<td style="width: 12%">${empleado?.nombre}</td>--}%
                    %{--<td style="width: 12%">${empleado?.apellido}</td>--}%
                    %{--<td style="width: 6%">${empleado?.cedula}</td>--}%
                    %{--<td style="width: 19%">${empleado?.direccion}</td>--}%
                    %{--<td style="width: 5%">${empleado?.telefono}</td>--}%
                    %{--<td style="width: 5%">${empleado?.sexo == 'M' ? 'Masculino' : 'Femenino'}</td>--}%
                    %{--<td style="width: 9%">${empleado?.cargo}</td>--}%
                    %{--<td style="width: 8%">${empleado?.fechaInicio?.format("dd-MM-yyyy")}</td>--}%
                    %{--<td style="width: 8%">${empleado?.fechaFin?.format("dd-MM-yyyy")}</td>--}%
                    %{--<td style="text-align: center;width: 5%; background-color: ${empleado?.activo == 1 ? '#47954B' : '#891523'}">${empleado?.activo == 1 ? 'SI' : 'NO'}</td>--}%
                %{--</tr>--}%
            %{--</g:each>--}%
        </table>
    </div>
</div>

<script type="text/javascript">

    $(".btnNuevo").click(function (){
        createEditRow();
    });

    function createEditRow(id) {
        var title = id ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'empleado', action:'form_ajax')}",
            data    : {
                id : id ? id : '',
                condominio: ${condominio?.id}
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Empleado",
//                    class   : "long",
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
                                return submitFormEmpleado();
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

    function submitFormEmpleado() {
        var $form = $("#frmEmpleado");
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
                        log("Empleado guardado correctamente","success");
                        setTimeout(function() {
//                            spinner.replaceWith($btn);
                            location.reload(true)
                        }, 100);
                    }else{
                        log("Error al guardar la información del empleado","error")
                    }
                }
            });
        } else {
            return false;
        } //else
    }

    function sueldoEmpleado(id){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'sueldo', action:'form_ajax')}",
            data    : {
                id : id ? id : ''
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgSueldo",
                    title   : "Sueldo",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : '<i class="fa fa-times"></i> Cancelar',
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
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
            label: " Editar",
            icon: "fa fa-edit",
            action : function ($element) {
                createEditRow(id);
            }
        };

        var sueldo = {
            label: "Sueldo",
            icon: "fa fa-money",
            action : function ($element) {
                sueldoEmpleado(id)
            }
        };

        items.editar = editar;
        items.sueldo = sueldo;

        return items
    }

    $(function () {
        $("tr").contextMenu({
            items  : createContextMenu,
            onShow : function ($element) {
                $element.addClass("trHighlight");
            },
            onHide : function ($element) {
                $(".trHighlight").removeClass("trHighlight");
            }
        });
    });


</script>

</body>
</html>
