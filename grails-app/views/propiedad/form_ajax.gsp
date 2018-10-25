<%@ page import="condominio.Propiedad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!propiedadInstance}">
    <elm:notFound elem="Propiedad" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPropiedad" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${propiedadInstance?.id}" />


            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'tipoPropiedad', 'error')} required">
                <span class="grupo">
                    <label for="tipoPropiedad" class="col-md-3 control-label">
                        Tipo Propiedad
                    </label>
                    <div class="col-md-8">
                        <g:select id="tipoPropiedad" name="tipoPropiedad.id" from="${condominio.TipoPropiedad.list()}" optionValue="descripcion" optionKey="id" required="" value="${propiedadInstance?.tipoPropiedad?.id}" class="many-to-one form-control"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'persona', 'error')} required">
                <span class="grupo">
                    <label for="persona" class="col-md-3 control-label">
                        Persona
                    </label>
                    <div class="col-md-8">
                        %{--<g:select id="persona" name="persona.id" from="${seguridad.Persona.list().sort{it.apellido}}" optionKey="id" required=""--}%
                                  %{--value="${propiedadInstance?.persona?.id}" class="many-to-one form-control" optionValue="${{it.apellido + " " + it.nombre + " - Departamento: " + it.departamento }}"/>--}%

                        <g:select id="persona" name="persona.id" from="${persona}" optionKey="id" required=""
                                  value="${propiedadInstance?.persona?.id}" class="many-to-one form-control" optionValue="${{it.apellido + " " + it.nombre + " - Departamento: " + it.departamento }}"/>

                    </div>
                </span>
            </div>


            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'numero', 'error')} required">
                <span class="grupo">
                    <label for="numero" class="col-md-3 control-label">
                        Número
                    </label>
                    <div class="col-md-8">
                        <g:textField name="numero" class="form-control required" value="${propiedadInstance?.numero}" required=""/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'area', 'error')} required">
                <span class="grupo">
                    <label for="area" class="col-md-3 control-label">
                        Área
                    </label>
                    <div class="col-md-3">
                        <g:textField name="area" type="number" value="${propiedadInstance?.area}" class="number form-control  required" required=""/>
                    </div>
                </span>
            </div>


            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <label for="valor" class="col-md-3 control-label">
                        Valor
                    </label>
                    <div class="col-md-3">
                        <g:textField name="valor" type="number" value="${propiedadInstance?.valor}" class="number form-control  required" required=""/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'alicuota', 'error')} required">
                <span class="grupo">
                    <label for="alicuota" class="col-md-3 control-label" style="margin-left: 15px">
                        Alícuota
                    </label>
                    <div class="col-md-3 input-group">
                        <g:textField name="alicuota" type="number" value="${propiedadInstance?.alicuota}" class="number form-control required" required=""/>
                        <span class="input-group-addon">%</span>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'fechaDesde', 'error')} required">
                <span class="grupo">
                    <label for="fechaDesde" class="col-md-3 control-label">
                        Fecha Desde
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaDesde"  class="datepicker form-control required" value="${propiedadInstance?.fechaDesde}"  />
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'fechaHasta', 'error')}">
                <span class="grupo">
                    <label for="fechaHasta" class="col-md-3 control-label">
                        Fecha Hasta
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaHasta"  class="datepicker form-control" value="${propiedadInstance?.fechaHasta}"  />
                    </div>
                </span>
            </div>
            

            <div class="form-group keeptogether ${hasErrors(bean: propiedadInstance, field: 'observaciones', 'error')}">
                <span class="grupo">
                    <label for="observaciones" class="col-md-3 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-6">
                        <g:textArea name="observaciones" class="form-control" value="${propiedadInstance?.observaciones}" style="width: 340px; height: 90px; resize: none"/>
                    </div>
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