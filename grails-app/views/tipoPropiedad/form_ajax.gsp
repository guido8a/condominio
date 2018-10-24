<%@ page import="condominio.TipoPropiedad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoPropiedadInstance}">
    <elm:notFound elem="TipoPropiedad" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmTipoPropiedad" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${tipoPropiedadInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: tipoPropiedadInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>
                    <div class="col-md-6">
                        <g:textField name="descripcion" maxlength="63" required="" class="form-control required" value="${tipoPropiedadInstance?.descripcion}"/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmTipoPropiedad").validate({
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
                submitFormTipoPropiedad();
                return false;
            }
            return true;
        });
    </script>

</g:else>