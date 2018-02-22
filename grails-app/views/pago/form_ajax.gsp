<%@ page import="condominio.Pago" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!pagoInstance}">
    <elm:notFound elem="Pago" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPago" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${pagoInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: pagoInstance, field: 'documento', 'error')} ">
                <span class="grupo">
                    <label for="documento" class="col-md-2 control-label">
                        Documento
                    </label>
                    <div class="col-md-6">
                        <g:textField name="documento" class="allCaps form-control" value="${pagoInstance?.documento}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: pagoInstance, field: 'observaciones', 'error')} ">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-6">
                        <g:textField name="observaciones" class="allCaps form-control" value="${pagoInstance?.observaciones}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: pagoInstance, field: 'fechaPago', 'error')} required">
                <span class="grupo">
                    <label for="fechaPago" class="col-md-2 control-label">
                        Fecha Pago
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaPago"  class="datepicker form-control required" value="${pagoInstance?.fechaPago}"  />
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: pagoInstance, field: 'ingreso', 'error')} required">
                <span class="grupo">
                    <label for="ingreso" class="col-md-2 control-label">
                        Ingreso
                    </label>
                    <div class="col-md-6">
                        <g:select id="ingreso" name="ingreso.id" from="${condominio.Ingreso.list()}" optionKey="id" required="" value="${pagoInstance?.ingreso?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: pagoInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <label for="valor" class="col-md-2 control-label">
                        Valor
                    </label>
                    <div class="col-md-2">
                        <g:field name="valor" type="number" value="${fieldValue(bean: pagoInstance, field: 'valor')}" class="number form-control  required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmPago").validate({
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
                submitFormPago();
                return false;
            }
            return true;
        });
    </script>

</g:else>