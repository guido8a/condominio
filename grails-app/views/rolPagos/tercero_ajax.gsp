<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 11/01/21
  Time: 14:32
--%>

<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmTercero" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${tercero?.id}" />
        <g:hiddenField name="empleado" value="${empleado?.id}" />
        <g:hiddenField name="tipo" value="tercero" />

        <div class="form-group keeptogether required">
            <span class="grupo">
                <label for="condominio" class="col-md-2 control-label">
                    Condominio
                </label>
                <div class="col-md-8">
                    <g:select id="condominio" name="condominio.id" from="${condominio}" optionKey="id" optionValue="nombre" required="" value="${condominio?.id}" class="many-to-one form-control"/>
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether required">
            <span class="grupo">
                <label for="salario" class="col-md-2 control-label">
                    Salario
                </label>
                <div class="col-md-8">
                    <g:select id="salario" name="salario.id" from="${salarios}" optionKey="id" optionValue="descripcion" required="" value="${mensual?.salario?.id}" class="many-to-one form-control"/>
                </div>
                *
            </span>
        </div>
    </g:form>
</div>

<script type="text/javascript">
    var validator = $("#frmTercero").validate({
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
</script>