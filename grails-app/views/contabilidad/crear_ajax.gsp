<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 27/10/17
  Time: 14:31
--%>

<div class="alert alert-danger" style="width: 555px;">
    <i class="fa fa-warning fa-4x pull-left"></i>
    <h3>Alerta</h3>
    <p>
        Su empresa no tiene un plan de cuentas configurado.
    </p>
    <p>
        Puede crear uno manualmente creando una cuenta ahora, o copiar el plan de cuentas por defecto.
    </p>
    <p style="text-align: center">
        <a href="#" id="btnCreate" class="btn btn-success"><i class="fa fa-file-o"></i> Crear cuenta</a>
        <g:link controller="cuenta" action="copiarCuentas" class="btn btn-primary btnCopiar">
            <i class="fa fa-copy"></i> Crear automáticamente un plan de cuentas</g:link>
    </p>
</div>

<script type="text/javascript">

    $(".btnCopiar").click(function () {
        bootbox.hideAll();
        openLoader("Copiando");
    });

    $("#btnCreate").click(function () {
        bootbox.hideAll();
        createEditRow(null, 0, "Crear");
    });

    function createEditRow(id, lvl, tipo) {
        var data = tipo == "Crear" ? { padre : id, lvl : lvl} : {id : id, lvl : lvl};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'cuenta', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
//                            class   : "long",
                    title   : tipo + " Cuenta",
                    message : msg,

                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitForm();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    var $input = b.find(".form-control").not(".datepicker").first();
                    var val = $input.val();
                    $input.focus();
                    $input.val("");
                    $input.val(val);
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitForm() {
        var $form = $("#frmCuenta");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Grabando");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("_");
                    log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
                    if (parts[0] == "OK") {
                        location.reload(true);
                    } else {
                        closeLoader();
                        spinner.replaceWith($btn);
                        return false;
                    }
                }
            });
        } else {
            return false;
        } //else
    }


</script>