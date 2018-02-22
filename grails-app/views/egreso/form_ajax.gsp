<%@ page import="condominio.Egreso" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!egresoInstance}">
    <elm:notFound elem="Egreso" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmEgreso" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${egresoInstance?.id}" />

            <div class="form-group keeptogether ${hasErrors(bean: egresoInstance, field: 'tipoGasto', 'error')} required">
                <span class="grupo">
                    <label for="tipoGasto" class="col-md-2 control-label">
                        Tipo Gasto
                    </label>
                    <div class="col-md-6">
                        <g:select id="tipoGasto" name="tipoGasto.id" from="${condominio.TipoGasto.list()}" optionKey="id"
                                  required="" value="${egresoInstance?.tipoGasto?.id}" class="many-to-one form-control"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: egresoInstance, field: 'proveedor', 'error')} required">
                <span class="grupo">
                    <label for="proveedor" class="col-md-2 control-label">
                        Proveedor
                    </label>
                    <div class="col-md-10">
                        <g:select id="proveedor" name="proveedor.id" from="${condominio.Proveedor.list()}" optionKey="id" required="" value="${egresoInstance?.proveedor?.id}" class="many-to-one form-control"/>
                    </div>
                </span>
            </div>


            <div class="form-group keeptogether ${hasErrors(bean: egresoInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Concepto
                    </label>
                    <div class="col-md-10">
                        <g:textField name="descripcion" class="form-control" value="${egresoInstance?.descripcion}"/>
                    </div>
                    
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: egresoInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <label for="valor" class="col-md-2 control-label">
                        Valor
                    </label>
                    <div class="col-md-3">
                        <g:textField name="valor" value="${egresoInstance?.valor}" class="number form-control required"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: egresoInstance, field: 'fecha', 'error')} required">
                <span class="grupo">
                    <label for="fecha" class="col-md-2 control-label">
                        Fecha
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fecha"  class="datepicker form-control required" value="${egresoInstance?.fecha}"  />
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: egresoInstance, field: 'fechaPago', 'error')} required">
                <span class="grupo">
                    <label for="fechaPago" class="col-md-2 control-label">
                        Fecha de Pago
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaPago"  class="datepicker form-control" value="${egresoInstance?.fechaPago}"  />
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: egresoInstance, field: 'abono', 'error')} required">
                <span class="grupo">
                    <label for="abono" class="col-md-2 control-label">
                        Pago
                    </label>
                    <div class="col-md-3">
                        <g:textField name="abono" value="${egresoInstance?.abono}" class="number form-control required"/>
                    </div>
                </span>
            </div>
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmEgreso").validate({
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
                submitFormEgreso();
                return false;
            }
            return true;
        });

    </script>

</g:else>