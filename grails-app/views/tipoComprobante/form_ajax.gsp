<g:form class="form-horizontal" name="frmTipoComprobante" role="form" action="save_ajax" method="POST">
    <g:hiddenField name="id" value="${tipoComprobanteInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: tipoComprobanteInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>

            <span class="col-md-2">
                <g:textField name="codigo" maxlength="1" class="allCaps form-control required"
                             value="${tipoComprobanteInstance?.codigo}"/>
            </span>

        </span>
    </div>

    <div class="form-group ${hasErrors(bean: tipoComprobanteInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>

            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="31" class="allCaps form-control required"
                             value="${tipoComprobanteInstance?.descripcion}"/>
            </span>

        </span>
    </div>
</g:form>

<script type="text/javascript">
    var validator = $("#frmTipoComprobante").validate({
        errorClass: "help-block",
        errorPlacement: function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success: function (label) {
            label.parents(".grupo").removeClass('has-error');
        }
    });
    $(".form-control").keydown(function (ev) {
        if (ev.keyCode === 13) {
            submitForm();
            return false;
        }
        return true;
    });
</script>
