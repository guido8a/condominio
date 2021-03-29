<%@ page import="condominio.Ingreso" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmIngreso" role="form" action="guardarPago_ajax" method="POST">
        <g:hiddenField name="id" value="${pago?.id}" />
        <g:hiddenField name="ingreso" value="${ingreso?.id}"/>
        <g:hiddenField name="mess" value="${mess}"/>


        <span class="grupo">
            <span class="col-md-12 control-label alert-info" style="text-align: center">
                <strong style="font-size: 14px !important;">${ingreso?.obligacion?.descripcion} ${ingreso?.observaciones ? (": " + ingreso?.observaciones) : ''}</strong>
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
                    Monto del pago
                </label>
                <div class="col-md-3">
                    <g:textField name="abono" value="${pago?.valor}" class="number form-control required"/>
                </div>
            </span>
            <span class="grupo">
                <label for="abono" class="col-md-3 control-label">
                    Multas:
                </label>
                <div class="col-md-3">
                    <g:textField name="mora" value="${pago?.mora?:mora}" class="number form-control required"/>
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
            <span class="grupo">
                <label for="abono" class="col-md-2 control-label">
                    Descuento:
                </label>
                <div class="col-md-3">
                    <g:textField name="descuento" value="${pago?.descuento ?: 0}" class="number form-control required"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: pago, field: 'documento', 'error')} ">

            <g:if test="${!condominio}">
                <span class="grupo">
                    <label for="documento" class="col-md-3 control-label">
                        Documento
                    </label>
                    <div class="col-md-4">
                        <g:textField name="documento" class="form-control" value="${pago?.documento}"/>
                    </div>
                </span>

            </g:if>

        </div>
        <div class="form-group keeptogether ${hasErrors(bean: pago, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="transferencia" class="col-md-3 control-label">
                    Transferencia:
                </label>
                <div class="col-md-2">
                    <g:select name="transferencia" from="${["NO", "SI"]}" class="form-control "
                              value="${pago?.transferencia == 'S' ? 'SI' : 'NO'}" />
                </div>
            </span>
            <span class="grupo">
                <label for="banco" class="col-md-4 control-label">
                   Costo Bancario:
                </label>
                <div class="col-md-3">
                    <g:textField name="banco" value="${pago?.banco ?: 0}" class="number form-control"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: pago, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-3 control-label">
                    Pago realizado por:
                </label>
                <div class="col-md-9">
                    <g:textField name="observaciones" class="form-control"   value="${pago?.observaciones?:dscr}"/>
                </div>
            </span>
        </div>

    </g:form>
</div>

<script type="text/javascript">
    var validator = $("#frmIngreso").validate({
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
    $(".form-control").keydown(function (ev) {
        if (ev.keyCode == 13) {
            submitFormIngreso();
            return false;
        }
        return true;
    });
</script>

