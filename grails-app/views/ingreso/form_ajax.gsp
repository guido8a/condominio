<%@ page import="condominio.Ingreso" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!ingresoInstance}">
    <elm:notFound elem="Ingreso" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmIngreso" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${ingresoInstance?.id}" />

            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <span class="col-md-12 control-label" style="text-align: center">
                        Valor a pagar: ${ingresoInstance.valor} ${ingresoInstance.observaciones}
                    </span>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <label for="abono" class="col-md-2 control-label">
                        Abono
                    </label>
                    <div class="col-md-4">
                        <g:textField name="abono" value="${ingresoInstance?.abono}" class="number form-control required"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'fechaPago', 'error')} required">
                <span class="grupo">
                    <label for="fechaPago" class="col-md-2 control-label">
                        Fecha Pago
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaPago"  class="datepicker form-control required" value="${ingresoInstance?.fechaPago}"  />
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'documento', 'error')} ">
                <span class="grupo">
                    <label for="documento" class="col-md-2 control-label">
                        Documento
                    </label>
                    <div class="col-md-6">
                        <g:textField name="documento" class="allCaps form-control" value="${ingresoInstance?.documento}"/>
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

</g:else>