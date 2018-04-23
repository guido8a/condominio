<%@ page import="condominio.Alicuota" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!alicuotaInstance}">
    <elm:notFound elem="Alicuota" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmAlicuota" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${alicuotaInstance?.id}" />


            <div class="form-group keeptogether ${hasErrors(bean: alicuotaInstance, field: 'persona', 'error')} required">
                <span class="grupo">
                    <label for="persona" class="col-md-2 control-label">
                        Persona
                    </label>
                    <div class="col-md-10">
                        <g:select id="persona" name="persona.id" from="${seguridad.Persona.list()}" optionKey="id" required=""
                                  value="${alicuotaInstance?.persona?.id ?: persona?.id}" class="many-to-one form-control"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: alicuotaInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <label for="valor" class="col-xs-9 col-md-4 control-label">
                        Valor a pagar mensual:
                    </label>
                    <div class="col-xs-10 col-md-3">
                        <g:textField name="valor" value="${alicuotaInstance?.valor}" class="number form-control"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: alicuotaInstance, field: 'fechaDesde', 'error')} required">
                <span class="grupo">
                    <label for="fechaDesde" class="col-xs-9 col-md-2 control-label">
                        Desde
                    </label>
                    <div class="col-xs-10 col-md-4">
                        <elm:datepicker name="fechaDesde"  class="datepicker form-control required"
                                        value="${alicuotaInstance?.fechaDesde?:new Date()}"  />
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: alicuotaInstance, field: 'fechaHasta', 'error')} required">
                <span class="grupo">
                    <label for="fechaHasta" class="col-xs-9 col-md-2 control-label">
                        Hasta
                    </label>
                    <div class="col-xs-10 col-md-4">
                        <elm:datepicker name="fechaHasta"  class="datepicker form-control" value="${alicuotaInstance?.fechaHasta}"  />
                    </div>
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: alicuotaInstance, field: 'observaciones', 'error')} ">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-10">
                        <g:textField name="observaciones" class="form-control" value="${alicuotaInstance?.observaciones}"/>
                    </div>

                </span>
            </div>



        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmAlicuota").validate({
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
/*
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormAlicuota();
                return false;
            }
            return true;
        });
*/
    </script>

</g:else>