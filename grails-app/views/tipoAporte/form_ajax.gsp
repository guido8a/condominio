<%@ page import="condominio.TipoAporte" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoAporteInstance}">
    <elm:notFound elem="TipoAporte" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmTipoAporte" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${tipoAporteInstance?.id}" />

            <div class="form-group keeptogether ${hasErrors(bean: tipoAporteInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>
                    <div class="col-md-6">
                        <g:textField name="descripcion" required="" class="form-control required" value="${tipoAporteInstance?.descripcion}"/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmTipoAporte").validate({
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
                submitFormTipoAporte();
                return false;
            }
            return true;
        });
    </script>

</g:else>