<%@ page import="condominio.Obligacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!obligacionInstance}">
    <elm:notFound elem="Obligacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmObligacion" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${obligacionInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: obligacionInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>
                    <div class="col-md-9">
                        <g:textField name="descripcion" required="" class="form-control required" value="${obligacionInstance?.descripcion}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: obligacionInstance, field: 'fecha', 'error')} required">
                <span class="grupo">
                    <label for="fecha" class="col-md-2 control-label">
                        Fecha
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fecha"  class="datepicker form-control required" value="${obligacionInstance?.fecha}"  />
                    </div>
                     *
                </span>
            </div>

            
            <div class="form-group keeptogether ${hasErrors(bean: obligacionInstance, field: 'valor', 'error')} required">
                <span class="grupo">
                    <label for="valor" class="col-md-2 control-label">
                        Valor
                    </label>
                    <div class="col-md-3">
                        <g:textField name="valor" value="${obligacionInstance?.valor}" class="number form-control required"/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmObligacion").validate({
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
                submitFormObligacion();
                return false;
            }
            return true;
        });
    </script>

</g:else>