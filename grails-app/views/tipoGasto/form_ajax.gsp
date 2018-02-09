<%@ page import="condominio.TipoGasto" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoGastoInstance}">
    <elm:notFound elem="TipoGasto" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmTipoGasto" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${tipoGastoInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: tipoGastoInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripcion
                    </label>
                    <div class="col-md-6">
                        <g:textField name="descripcion" required="" class="allCaps form-control required" value="${tipoGastoInstance?.descripcion}"/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmTipoGasto").validate({
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
                submitFormTipoGasto();
                return false;
            }
            return true;
        });
    </script>

</g:else>