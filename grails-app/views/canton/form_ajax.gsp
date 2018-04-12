<%@ page import="condominio.Canton" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!cantonInstance}">
    <elm:notFound elem="Canton" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmCanton" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${cantonInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: cantonInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>
                    <div class="col-md-6">
                        <g:textField name="nombre" required="" class="allCaps form-control required" value="${cantonInstance?.nombre}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: cantonInstance, field: 'provincia', 'error')} required">
                <span class="grupo">
                    <label for="provincia" class="col-md-2 control-label">
                        Provincia
                    </label>
                    <div class="col-md-6">
                        <g:textField name="provincia" class="allCaps form-control required" value="${cantonInstance?.provincia}"/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmCanton").validate({
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
                submitFormCanton();
                return false;
            }
            return true;
        });
    </script>

</g:else>