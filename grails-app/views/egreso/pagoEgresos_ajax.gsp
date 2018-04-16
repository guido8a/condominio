<%@ page import="condominio.PagoEgreso" %>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 15/03/18
  Time: 15:04
--%>

<style type="text/css">

    .centro{
        text-align: center;
    }

    .derecha{
        text-align: right;
    }

</style>

<div class="alert alert-warning col-md-12">


    <div class="col-md-5">
        <label style="color: #1b8e36">Pagado: $
        ${g.formatNumber(number: pagos?.valor?.sum() ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2,
                locale: 'en_US')}
        </label>
    </div>
    <div class="col-md-5">
        <label style="color: #701b19">Saldo: $
        ${g.formatNumber(number: saldo ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}
        </label>
    </div>

    <div class="col-md-2">
        <a href="#" class="btn btn-success btn-sm btnPago ${(saldo ?: 0) > 0 ? '' : 'disabled'}" data-ing="${egreso?.id}"
           title="Ingresar Pago" style="margin-left: -20px;">
            <i class="fa fa-plus"></i> Pagar
        </a>
    </div>
</div>

<g:if test="${pagos.size() > 0}">
    <div style="text-align: center"><h3>Detalle de pagos</h3></div>
    <table class="table table-bordered table-hover table-condensed">
        <thead>
        <tr>
            <th class="alinear" style="width: 18%">Fecha</th>
            <th class="alinear" style="width: 18%">Doc.</th>
            <th class="alinear" style="width: 15%">Valor</th>
            <th class="alinear" style="width: 29%">Obser.</th>
            <th class="centro" style="width: 20%"><i class="fa fa-pencil"></i></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${pagos}" var="pagoUsuario">
            <tr data-id="${pagoUsuario.id}" style="width: 100%">
                <td style="width: 15%"><g:formatDate date="${pagoUsuario?.fechaPago}" format="dd-MM-yyyy"/></td>
                <td style="width: 20%">${pagoUsuario?.documento}</td>
                <td class="derecha" style="width: 15%"><g:formatNumber number="${pagoUsuario?.valor}" format="##,##0" locale="en_US" maxFractionDigits="2" minFractionDigits="2"/></td>
                <td style="width: 20%">${pagoUsuario?.observaciones}</td>
                <td style="text-align: center; width: 15%">
                    <a href="#" class="btn btn-info btn-sm btnEditar" data-id="${pagoUsuario?.id}" data-ing="${egreso?.id}" title="Editar Pago">
                        <i class="fa fa-pencil"></i>
                    </a>
                    <a href="#" class="btn btn-danger btn-sm btnEliminar" data-id="${pagoUsuario?.id}" title="Borrar Pago">
                        <i class="fa fa-trash-o"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</g:if>
<g:else>
    <div class="alert alert-danger centro">
        No existen pagos
    </div>
</g:else>

<script type="text/javascript">

    $(".btnEditarEgg").click(function () {
        var egreso = $(this).data('ing');
        createEditRow(egreso);
    });


    var id = null;
    function submitFormEgreso() {
        var $form = $("#frmEgreso");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Egreso");
            console.log('ejecuta ---')
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        if (parts[0] == "SUCCESS") {
//                            location.reload(true);
                            closeLoader();
                            cargarBusqueda();
                        } else {
                            closeLoader();
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 1000);
                }
            });
        } else {
            return false;
        } //else
    }

    function createEditRow(id) {
        var title = id ? "Editar" : "Nuevo";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'egreso', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Egreso",

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
                                return submitFormEgreso();
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




    //pagos

    $(".btnEliminar").click(function () {
        var pago = $(this).data("id");
        bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea eliminar el pago seleccionado?", function (res) {
            if (res) {
                openLoader("Borrando Pago...");
                $.ajax({
                    type    : "POST",
                    url : "${createLink(controller:'egreso', action:'borrarPagoEgreso_ajax')}",
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
                            log("Error al borrar el pago","error")
                        }
                    }
                });
            }
        });
    });

    $(".btnPago").click(function () {
        var egreso = $(this).data('ing');
        createEditPago(egreso, null)
    });

    $(".btnEditar").click(function () {
        var egreso = $(this).data('ing');
        var pago = $(this).data('id');
        createEditPago(egreso, pago)
    });

    $(".btnBorrarEgg").click(function () {
        var egreso = $(this).data("ing");
        bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea eliminar el egreso seleccionado?", function (res) {
            if (res) {
                openLoader("Borrando Egreso...");
                $.ajax({
                    type    : "POST",
                    url : "${createLink(controller:'egreso', action:'borrarEgreso_ajax')}",
                    data    : {
                        id: egreso
                    },
                    success : function (msg) {
                        if(msg == 'ok'){
                            closeLoader();
                            log("Egreso borrado correctamente","success");
                            setTimeout(function() {
                                location.reload(true);
                            }, 1000);
                        }else{
                            if(msg == 'di'){
                                closeLoader();
                                log("No se puede borrar este egreso, contiene pagos","error")
                            }else{
                                closeLoader();
                                log("Error al borrar el egreso","error")
                            }
                        }
                    }
                });
            }
        });
    });

    function createEditPago(id, pago) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'egreso', action:'pagoEgreso_ajax')}",
            data    : {
                id: id,
                pago: pago
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : "Pago Egreso",
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
                                return submitFormPagoEgreso();
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

    function submitFormPagoEgreso() {
        var $form = $("#frmEgresoPago");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Pago...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    if(msg == 'ok'){
                        log("Pago guardado correctamente!" , "success");
                        closeLoader();
                        setTimeout(function() {
                            location.reload(true);
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


</script>

