<%@ page import="utilitarios.Anio" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!anioInstance}">
    <elm:notFound elem="Anio" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmAnio" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${anioInstance?.id}" />

            <div class="form-group keeptogether ${hasErrors(bean: anioInstance, field: 'numero', 'error')} required">
                <span class="grupo">
                    <label for="numero" class="col-md-4 control-label">
                        Año
                    </label>
                    <div class="col-md-6">
                        <g:textField name="numero" maxlength="4" required="" class="digits form-control required" value="${anioInstance?.numero}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: anioInstance, field: 'sueldoBasico', 'error')} required">
                <span class="grupo">
                    <label for="sueldoBasico" class="col-md-4 control-label">
                        Sueldo Básico
                    </label>
                    <div class="col-md-6">
                        <g:textField name="sueldoBasico" value="${anioInstance?.sueldoBasico ?: 0}" class="number form-control  required" required=""/>
                    </div>
                     *
                </span>
            </div>
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmAnio").validate({
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
                submitFormAnio();
                return false;
            }
            return true;
        });
    </script>

</g:else>