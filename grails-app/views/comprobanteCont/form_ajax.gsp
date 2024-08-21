<g:form class="form-horizontal" name="frmComprobante" role="form" action="saveComprobante_ajax" method="POST">
    <g:hiddenField name="id" value="${comprobante?.id}"/>
    <div class="form-group ${hasErrors(bean: comprobante, field: 'tipo', 'error')} required">
        <span class="grupo">
            <label for="tipo" class="col-md-2 control-label text-info">
                Tipo de comprobante
            </label>
            <span class="col-md-8">
               <g:select name="tipo" from="${contabilidad.TipoComprobante.list([sort: 'descripcion'])}" class="form-control required" optionKey="id" optionValue="descripcion" value="${comprobante?.tipo?.id}"/>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: comprobante, field: 'descripcion', 'error')} required">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="255" minlength="3" required="" class="form-control required" value="${comprobante?.descripcion}"/>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">

    var validator = $("#frmComprobante").validate({
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
            submitFormComprobante();
            return false;
        }
        return true;
    });
</script>