<%@ page import="condominio.Propiedad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!propiedadInstance}">
    <elm:notFound elem="Propiedad" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPropiedad" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${propiedadInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'alicuota', 'error')} required">
                <span class="grupo">
                    <label for="alicuota" class="col-md-2 control-label">
                        Alicuota
                    </label>
                    <div class="col-md-2">
                        <g:field name="alicuota" type="number" value="${fieldValue(bean: propiedadInstance, field: 'alicuota')}" class="number form-control  required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'area', 'error')} required">
                <span class="grupo">
                    <label for="area" class="col-md-2 control-label">
                        Area
                    </label>
                    <div class="col-md-2">
                        <g:field name="area" type="number" value="${fieldValue(bean: propiedadInstance, field: 'area')}" class="number form-control  required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'fechaDesde', 'error')} required">
                <span class="grupo">
                    <label for="fechaDesde" class="col-md-2 control-label">
                        Fecha Desde
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaDesde"  class="datepicker form-control required" value="${propiedadInstance?.fechaDesde}"  />
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'fechaHasta', 'error')} required">
                <span class="grupo">
                    <label for="fechaHasta" class="col-md-2 control-label">
                        Fecha Hasta
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaHasta"  class="datepicker form-control required" value="${propiedadInstance?.fechaHasta}"  />
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'numero', 'error')} required">
                <span class="grupo">
                    <label for="numero" class="col-md-2 control-label">
                        Numero
                    </label>
                    <div class="col-md-6">
                        <g:textField name="numero" class="allCaps form-control" value="${propiedadInstance?.numero}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'observaciones', 'error')} required">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-6">
                        <g:textField name="observaciones" class="allCaps form-control" value="${propiedadInstance?.observaciones}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'persona', 'error')} required">
                <span class="grupo">
                    <label for="persona" class="col-md-2 control-label">
                        Persona
                    </label>
                    <div class="col-md-6">
                        <g:select id="persona" name="persona.id" from="${seguridad.Persona.list()}" optionKey="id" required="" value="${propiedadInstance?.persona?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'tipoPropiedad', 'error')} required">
                <span class="grupo">
                    <label for="tipoPropiedad" class="col-md-2 control-label">
                        Tipo Propiedad
                    </label>
                    <div class="col-md-6">
                        <g:select id="tipoPropiedad" name="tipoPropiedad.id" from="${condominio.TipoPropiedad.list()}" optionKey="id" required="" value="${propiedadInstance?.tipoPropiedad?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <label for="valor" class="col-md-2 control-label">
                        Valor
                    </label>
                    <div class="col-md-2">
                        <g:field name="valor" type="number" value="${fieldValue(bean: propiedadInstance, field: 'valor')}" class="number form-control  required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmPropiedad").validate({
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
                submitFormPropiedad();
                return false;
            }
            return true;
        });
    </script>

</g:else>