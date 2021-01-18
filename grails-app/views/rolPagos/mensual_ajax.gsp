<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 11/01/21
  Time: 14:32
--%>

<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmMensual" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${mensual?.id}" />
        <g:hiddenField name="empleado" value="${empleado?.id}" />
        <g:hiddenField name="tipo" value="mensual" />

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

        <div class="form-group keeptogether required">
            <span class="grupo">
                <label for="anio" class="col-md-2 control-label">
                    Año
                </label>
                <div class="col-md-8">
                    <g:select id="anio" name="anio.id" from="${utilitarios.Anio.list()}" optionKey="id" optionValue="numero" required="" class="many-to-one form-control"/>
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="descuentoDescripcion" class="col-md-2 control-label">
                    Descuento descripción
                </label>
                <div class="col-md-8">
                    <g:textField name="descuentoDescripcion" maxlength="63" class="form-control" value="${mensual?.descuentoDescripcion}"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="descuentoValor" class="col-md-6 control-label">
                    Descuento Valor
                </label>
                <div class="col-md-4">
                    <g:textField name="descuentoValor" class="number form-control" value="${mensual?.descuentoValor ?: 0}"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="bono" class="col-md-2 control-label">
                    Bono Descripción
                </label>
                <div class="col-md-8">
                    <g:textField name="bono" maxlength="63" class="form-control" value="${mensual?.bono}"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="bonoValor" class="col-md-6 control-label">
                    Bono Valor
                </label>
                <div class="col-md-4">
                    <g:textField name="bonoValor" class="number form-control" value="${mensual?.bonoValor ?: 0}"/>
                </div>
            </span>
        </div>
    </g:form>
</div>

<script type="text/javascript">
    var validator = $("#frmMensual").validate({
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