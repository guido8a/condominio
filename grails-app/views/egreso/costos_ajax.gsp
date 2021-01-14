<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 14/01/21
  Time: 10:27
--%>

<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmBancarios" role="form" action="guardarCostosBancarios_ajax" method="POST">

        <div class="form-group keeptogether required">
            <span class="grupo">
                <label for="mes" class="col-md-4 control-label">
                   Mes
                </label>
                <div class="col-md-6">
                  <g:select name="mes" from="${meses}" optionValue="value" optionKey="key" class="form-control"/>
                </div>
                *
            </span>
        </div>
        <div class="form-group keeptogether required">
            <span class="grupo">
                <label for="anio" class="col-md-4 control-label">
                    Año
                </label>
                <div class="col-md-6">
                    <g:select name="anio" from="${utilitarios.Anio.list()}" optionValue="numero" optionKey="id" class="form-control"/>
                </div>
                *
            </span>
        </div>
    </g:form>
</div>

<script type="text/javascript">
    var validator = $("#frmBancarios").validate({
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