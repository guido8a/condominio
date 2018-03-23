<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/02/18
  Time: 11:06
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 23/02/18
  Time: 10:30
--%>

<%@ page import="condominio.Ingreso" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmEgresoPago" role="form" action="guardarPagoEgreso_ajax" method="POST">
        <g:hiddenField name="id" value="${pago?.id}" />
        <g:hiddenField name="egreso" value="${egreso?.id}"/>


        <span class="grupo">
            <span class="col-md-12 control-label alert-info" style="text-align: center">
                <strong style="font-size: 14px !important;">${egreso?.tipoGasto?.descripcion + " : "} ${egreso?.descripcion}</strong>
            </span>
        </span>


        <span class="grupo">
            <span class="col-md-12 control-label ${saldo == 0 ? 'alert-success':'alert-info'}" style="text-align: center">
                <strong style="font-size: 14px !important;">Saldo a pagar: <g:formatNumber number="${saldo}" format="##,##0" locale="en_US" maxFractionDigits="2" minFractionDigits="2"/> </strong>
            </span>
        </span>

        <div class="form-group keeptogether ${hasErrors(bean: pago, field: 'valor', 'error')} required" style="margin-top: 10px !important;">
            <span class="grupo">
                <label for="abono" class="col-md-3 control-label">
                    Valor del pago
                </label>
                <div class="col-md-3">
                    <g:textField name="abono" value="${pago?.valor}" class="number form-control required"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: pago, field: 'fechaPago', 'error')} required">
            <span class="grupo">
                <label for="fechaPago" class="col-md-3 control-label">
                    Fecha Pago
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaPago"  class="datepicker form-control required" value="${pago?.fechaPago}"  />
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: pago, field: 'documento', 'error')} ">
            <span class="grupo">
                <label for="documento" class="col-md-3 control-label">
                    Documento
                </label>
                <div class="col-md-5">
                    <g:textField name="documento" class="allCaps form-control" value="${pago?.documento}"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: pago, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-3 control-label">
                    Observaciones
                </label>
                <div class="col-md-9">
                    <g:textField name="observaciones" class="form-control" value="${pago?.observaciones}"/>
                </div>
            </span>
        </div>

    </g:form>
</div>

<script type="text/javascript">
    var validator = $("#frmEgresoPago").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
        }

    });
//    $(".form-control").keydown(function (ev) {
//        if (ev.keyCode == 13) {
//            submitFormIngreso();
//            return false;
//        }
//        return true;
//    });
</script>

%{--</g:else>--}%