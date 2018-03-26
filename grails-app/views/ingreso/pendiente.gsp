
<%@ page import="condominio.Ingreso" %>
<%@ page import="condominio.Pago" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Cuentas pendientes</title>

    <style type="text/css">

    .colorFondo{
        background-color: #e0e0e0;
        text-align: center;
    }

    .derecha{
        text-align: right;
    }

    .centro{
        text-align: center;
    }

    .dd{
        font-weight: bold;
    }

    </style>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<h3 style="text-align: center">Pendientes de <strong>${ingreso[0].persona.nombre} ${ingreso[0].persona.apellido}</strong></h3>
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="${createLink(controller: "vivienda", action: "index")}" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    <g:if test="${data[0].prsnsldo > data[0].alctvlor}">
        <div class="btn-group">
            <a href="${createLink(controller: "reportes", action: "solicitud", id: persona.id)}" class="btn btn-info">
                <i class="fa fa-print"></i> Solicitud de Pago
            </a>
        </div>
    </g:if>
    <div class="btn-group">
        <a href="#" class="btn btn-warning" id="listarSaldo">
            <i class="fa fa-search"></i> Listar con saldo por pagar
        </a>
    </div>
    <div class="btn-group">
        <a href="#" class="btn btn-success hidden" id="listarTodos">
            <i class="fa fa-search"></i> Listar todos
        </a>
    </div>
</div>


<table class="table table-condensed table-bordered table-striped">

    <thead>
    <tr style="width: 100%">
        <th>Pendientes</th>
        <th>Pagos</th>
    </tr>
    </thead>

    <tbody>

    <tr style="width: 100%">
        <td id="tdObligaciones" style="width: 40%">

        </td>
        <td id="tdPagos" style="width: 60%">

        </td>
    </tr>

    </tbody>
</table>


<script type="text/javascript">

    $("#listarTodos").click(function () {
        cargarObligaciones(null);
        $("#listarSaldo").removeClass('hidden');
        $("#listarTodos").addClass('hidden')
    });

    $("#listarSaldo").click(function () {
        cargarObligaciones(true);
        $("#listarTodos").removeClass('hidden');
        $("#listarSaldo").addClass('hidden')
    });

    cargarObligaciones(null);

    function cargarObligaciones (band) {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'ingreso', action: 'obligaciones_ajax')}',
            data:{
                persona: '${persona?.id}',
                band: band
            },
            success: function (msg){
                $("#tdObligaciones").html(msg)
            }
        });
    }

    $(".btnAdd").click(function () {
        var idIngreso = $(this).data("ing");
        createEditRow(idIngreso,null)
    });

    $(".btnEditar").click(function () {
        var idPago = $(this).data("id");
        var idIngreso = $(this).data("ing");
        createEditRow(idIngreso, idPago)
    });

    $(".btnEliminar").click(function () {
        var pago = $(this).data("id");
        bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea eliminar el pago seleccionado?", function (res) {
            if (res) {
                openLoader("Borrando Pago...");
                $.ajax({
                    type    : "POST",
                    url : "${createLink(controller:'ingreso', action:'borrarPago_ajax')}",
                    data    : {
                        id: pago
                    },
                    success : function (msg) {
                        if(msg == 'ok'){
                            closeLoader();
                            log("Pago borrado correctamente","success");
                            setTimeout(function() {
                                location.reload(true);
                            }, 1000);
                        }else{
                            closeLoader();
                            log("Error al borrar el pago","error")
                        }
                    }
                });
            }
        });
    });


    var id = null;
    function submitFormIngreso(ingreso) {
        var $form = $("#frmIngreso");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Pago");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    if(msg == 'ok'){
                        log("Pago guardado correctamente!" , "success");
                        closeLoader();
                        setTimeout(function() {
//                            location.reload(true);
                            cargarPagos(ingreso);
                        }, 1000);
                    }else{
                        if(msg == 'di'){
                            closeLoader();
                            bootbox.alert("<i class='fa fa-warning fa-3x pull-left text-warning text-shadow'></i> El abono ingresado supera el valor del saldo")
                        }
                        else{
                            log("Error al guardar el pago","error");
                            closeLoader();
                        }
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
            "¿Está seguro que desea eliminar el Ingreso seleccionado? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Ingreso");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'ingreso', action:'delete_ajax')}',
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

    //    function createEditRow(id, obsr) {
    function createEditRow(id, pago, obsr) {
        var title = "Registrar el pago de: ${ingreso[0].persona.nombre} ${ingreso[0].persona.apellido}" +
            "<br/>";
//        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            %{--url     : "${createLink(controller:'ingreso', action:'form_ajax')}",--}%
            url     : "${createLink(controller:'ingreso', action:'pago_ajax')}",
            data    : {
                id: id,
                pago: pago
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title,
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
                                return submitFormIngreso(id);
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

    });
</script>

</body>
</html>
