<%@ page import="condominio.Condominio; condominio.Obra" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!obraInstance}">
    <elm:notFound elem="Obra" genero="o" />
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmObra" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${obraInstance?.id}" />

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'tipoObra', 'error')} required">
                <span class="grupo">
                    <label for="tipoObra" class="col-md-2 control-label">
                        Tipo Obra
                    </label>
                    <div class="col-md-7">
                        <g:select id="tipoObra" name="tipoObra.id" from="${condominio.TipoObra.list().sort{it.descripcion}}" optionKey="id" optionValue="descripcion" required="" value="${obraInstance?.tipoObra?.id}" class="many-to-one form-control"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>
                    <div class="col-md-7">
                        <g:textArea name="descripcion" required="" class="form-control required" value="${obraInstance?.descripcion}" style="resize: none"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'proveedor', 'error')}">
                <span class="grupo">
                    <label for="proveedor" class="col-md-2 control-label">
                        Proveedor
                    </label>
                    <div class="col-md-7">
                        <g:select id="proveedor" name="proveedor.id"
                                  from="${condominio.Proveedor.findAllByCondominio(session.usuario.condominio, [sort: 'nombre'])}"
                                  optionKey="id" optionValue=""
                                  value="${obraInstance?.proveedor?.id}" class="many-to-one form-control"
                                  noSelection="['0':'Seleccione...']"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'persona', 'error')} required">
                <span class="grupo">
                    <label for="persona" class="col-md-2 control-label">
                        Solicitante
                    </label>
                    <div class="col-md-7">
                        <g:select id="persona" name="persona.id"
                                  from="${seguridad.Persona.findAllByCondominio(session.condominio, [sort: 'departamento'])}"
                                  optionKey="id" required="" value="${obraInstance?.persona?.id}"
                                  class="many-to-one form-control"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'fecha', 'error')} required">
                <span class="grupo">
                    <label for="fecha" class="col-md-3 control-label">
                        Fecha de Registro
                    </label>
                    <div class="col-md-3">
                        <elm:datepicker name="fecha"  class="datepicker form-control required" value="${obraInstance?.fecha}"  />
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'fechaInicio', 'error')}">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-3 control-label">
                        Fecha Inicio Obra
                    </label>
                    <div class="col-md-3">
                        <elm:datepicker name="fechaInicio"  class="datepicker form-control" value="${obraInstance?.fechaInicio}"  />
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'fechaFin', 'error')}">
                <span class="grupo">
                    <label for="fechaFin" class="col-md-3 control-label">
                        Fecha Fin Obra
                    </label>
                    <div class="col-md-3">
                        <elm:datepicker name="fechaFin"  class="datepicker form-control" value="${obraInstance?.fechaFin}"  />
                    </div>
                </span>
            </div>


            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'plazo', 'error')} required">
                <span class="grupo">
                    <label for="plazo" class="col-md-3 control-label">
                        Plazo de ejecución
                    </label>
                    <div class="col-md-3">
                        <g:textField name="plazo" value="${obraInstance?.plazo}" class="digits form-control required" required=""/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'presupuesto', 'error')} required">
                <span class="grupo">
                    <label for="presupuesto" class="col-md-3 control-label">
                        Presupuesto tentativo
                    </label>
                    <div class="col-md-3">
                        %{--<g:textField name="presupuesto" value="${g.formatNumber(number: obraInstance?.presupuesto, format: '##,##0', locale: 'en_US', maxFractionDigits: 2, minFractionDigits: 2)}" class="number form-control required" required=""/>--}%
                        <g:textField name="presupuesto" value="${obraInstance?.presupuesto}" class="number form-control required" required=""/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: obraInstance, field: 'observaciones', 'error')} ">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-7">
                        <g:textArea name="observaciones" class="form-control" value="${obraInstance?.observaciones}" style="resize: none"/>

                    </div>
                </span>
            </div>
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmObra").validate({
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
                submitFormObra();
                return false;
            }
            return true;
        });
    </script>

</g:else>