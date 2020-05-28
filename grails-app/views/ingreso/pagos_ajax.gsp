<%@ page import="condominio.Pago" %>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 15/03/18
  Time: 10:13
--%>

<style type="text/css">
.derecha{
    text-align: right;
}

.centro{
    text-align: center;
}
</style>


<div class="alert alert-warning col-md-12">

    %{--<div class="col-md-1">--}%
        %{--<label>Valor: </label>--}%
    %{--</div>--}%

    <div class="col-md-3">
        %{--<g:textField name="saldo_name" class="form-control derecha" readonly=""--}%
                     %{--value="${g.formatNumber(number: ingreso?.valor ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>--}%
        <label>Valor: $</label>
        ${g.formatNumber(number: ingreso?.valor ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}
    </div>
    %{--<div class="col-md-1">--}%
        %{--<label style="color: #1b8e36">Pagado:</label>--}%
    %{--</div>--}%
    <div class="col-md-3">
        %{--<g:textField name="saldo_name" class="form-control derecha" readonly=""--}%
                     %{--value="${g.formatNumber(number: condominio.Pago.findAllByIngreso(ingreso).valor?.sum()?.toDouble() ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>--}%
        <label style="color: #1b8e36">Pagado: $</label>
        ${g.formatNumber(number: condominio.Pago.findAllByIngreso(ingreso).valor?.sum()?.toDouble() ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}
    </div>
    %{--<div class="col-md-1">--}%
        %{--<label style="color: #701b19">Saldo:</label>--}%
    %{--</div>--}%
    <div class="col-md-3">
        %{--<g:textField name="saldo_name" class="form-control derecha" readonly=""--}%
                     %{--value="${g.formatNumber(number: saldo ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>--}%
        <label style="color: #701b19">Saldo:</label>
        ${g.formatNumber(number: saldo ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}
    </div>

    <div class="col-md-2">
        <a href="#" class="btn btn-success btn-sm btnAdd ${(saldo ?: 0) > 0 ? '' : 'disabled'}" data-ing="${ingreso?.id}" title="Ingresar Pago">
            <i class="fa fa-plus"></i> Pagar
        </a>
    </div>

</div>
<g:if test="${pagos?.size() > 0}">

    <div style="text-align: center"><h3>Detalle de pagos</h3></div>

    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <tr style="width: 100%">
            <th style="width: 37%">Pago realizado por:</th>
            <th style="width: 20%">Documento</th>
            <th style="width: 15%">Fecha Pago</th>
            <th style="width: 13%">Pago</th>
            <th class="centro" style="width: 15%"><i class="fa fa-pencil"></i></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${pagos}" var="pagoUsuario">
            <tr data-id="${pagoUsuario.id}" style="background-color: #efffef !important; width: 100%">
                <td style="width: 37%">${pagoUsuario?.observaciones}</td>
                <td style="width: 20%">${pagoUsuario?.documento}</td>
                <td style="width: 15%"><g:formatDate date="${pagoUsuario?.fechaPago}" format="dd-MM-yyyy"/></td>
                <td class="derecha" style="width: 13%"><g:formatNumber number="${pagoUsuario?.valor}" format="##,##0" locale="en_US" maxFractionDigits="2" minFractionDigits="2"/></td>
                <td class="centro" style="width: 15%">
                    <g:if test="${pagoUsuario?.estado != 'R'}">
                        <a href="#" class="btn btn-info btn-sm btnEditar" data-id="${pagoUsuario?.id}" data-ing="${ingreso?.id}" title="Editar Pago">
                            <i class="fa fa-pencil"></i>
                        </a>
                        <a href="#" class="btn btn-danger btn-sm btnEliminar" data-id="${pagoUsuario?.id}" title="Borrar Pago">
                            <i class="fa fa-trash-o"></i>
                        </a>
                    </g:if>
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


    function submitFormIngreso() {
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

    function createEditRow(id, pago, obsr) {
        var title = "Registrar el pago";
        $.ajax({
            type    : "POST",
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
                                return submitFormIngreso();
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



</script>