<%@ page import="condominio.Ingreso" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!ingresoInstance}">
    <elm:notFound elem="Ingreso" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmIngreso" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${ingresoInstance?.id}" />

            
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
            
            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'observaciones', 'error')} ">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-6">
                        <g:textField name="observaciones" class="allCaps form-control" value="${ingresoInstance?.observaciones}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'abono', 'error')} required">
                <span class="grupo">
                    <label for="abono" class="col-md-2 control-label">
                        Abono
                    </label>
                    <div class="col-md-2">
                        <g:field name="abono" type="number" value="${fieldValue(bean: ingresoInstance, field: 'abono')}" class="number form-control  required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'estado', 'error')} required">
                <span class="grupo">
                    <label for="estado" class="col-md-2 control-label">
                        Estado
                    </label>
                    <div class="col-md-6">
                        <g:textField name="estado" class="allCaps form-control" value="${ingresoInstance?.estado}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'fecha', 'error')} required">
                <span class="grupo">
                    <label for="fecha" class="col-md-2 control-label">
                        Fecha
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fecha"  class="datepicker form-control required" value="${ingresoInstance?.fecha}"  />
                    </div>
                     *
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
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'obligacion', 'error')} required">
                <span class="grupo">
                    <label for="obligacion" class="col-md-2 control-label">
                        Obligacion
                    </label>
                    <div class="col-md-6">
                        <g:select id="obligacion" name="obligacion.id" from="${condominio.Obligacion.list()}" optionKey="id" required="" value="${ingresoInstance?.obligacion?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'persona', 'error')} required">
                <span class="grupo">
                    <label for="persona" class="col-md-2 control-label">
                        Persona
                    </label>
                    <div class="col-md-6">
                        <g:select id="persona" name="persona.id" from="${seguridad.Persona.list()}" optionKey="id" required="" value="${ingresoInstance?.persona?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: ingresoInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <label for="valor" class="col-md-2 control-label">
                        Valor
                    </label>
                    <div class="col-md-2">
                        <g:field name="valor" type="number" value="${fieldValue(bean: ingresoInstance, field: 'valor')}" class="number form-control  required" required=""/>
                    </div>
                     *
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