
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

    .seleccionado {
        border-color: #df960b;
        border-style: solid;
        border-width: medium;
        background-color: #e0e8ff;
    }
    </style>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<h3 style="text-align: center">Pendientes de <strong>${ingreso[0].persona?.nombre} ${ingreso[0]?.persona?.apellido} &nbsp; </strong>
    dep. <strong>(${ingreso[0].persona.departamento})</strong></h3>
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="${createLink(controller: 'vivienda', action: 'index')}/?edif=${actual}" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    <g:if test="${data[0].prsnsldo > data[0].alctvlor}">
        <div class="btn-group">
            %{--<a href="${createLink(controller: "reportes", action: "solicitud", id: persona.id)}" class="btn btn-info">--}%
                %{--<i class="fa fa-print"></i> Solicitud de Pago--}%
            %{--</a>--}%

            <a href="#" class="btn btn-info" data-toggle="modal" data-target="#solicitud">
                <i class="fa fa-print"></i> Solicitud de Pago

            </a>

        </div>
    </g:if>
    <div class="btn-group">
        <a href="#" class="btn btn-warning  hidden" id="listarSaldo">
            <i class="fa fa-search"></i> Listar con saldo por pagar
        </a>
    </div>
    <div class="btn-group">
        <a href="#" class="btn btn-success" id="listarTodos">
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

<div class="modal fade col-md-12 col-xs-5" id="solicitud" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalsolicitud">Generar cartas solicitando pagos</h4>
            </div>

            <div class="modal-body" id="bodysolicitud">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1 col-xs-1">
                        </div>
                        <div class="col-md-3 col-xs-3">
                            <label>Generar para deudas con </label>
                        </div>
                        <div class="col-md-7 col-xs-6">
                            <g:select from="${['1':'Valores superiores a 1 alícuota',
                                               '2':'Valores superiores a 2 alícuotas',
                                               '3':'Valores superiores a 3 alícuotas']}"
                                      optionValue="value" optionKey="key" name="mesesHasta_name"
                                      id="valorHasta" class="form-control"/>
                        </div>
                        <div class="col-md-1 col-xs-1">
                        </div>

                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnSolicitud btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(".btnSolicitud").click(function () {
        var vlor = $("#valorHasta").val();
        location.href = "${g.createLink(controller: 'reportes', action: 'solicitud')}?vlor=" + vlor + "&id=" + ${persona?.id};
    });


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

    cargarObligaciones(true);

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
