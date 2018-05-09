<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 09/05/18
  Time: 10:47
--%>

<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 2/18/14
  Time: 12:39 PM
--%>

<html>
<head>
    <meta name="layout" content="main">
    <title>Configuración personal</title>
</head>

<body>
<div class="form-group">
    <div class="alert alert-info">
        Datos del usuario: <strong>${usuario.nombre} ${usuario.apellido}</strong>
    </div>
</div>


<div class="panel-group" id="accordion">

    <g:set var="abierto" value="${false}"/>

    <g:set var="abierto" value="${true}"/>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#collapsePass">
                    Cambiar contraseña
                </a>
            </h4>
        </div>

        <div id="collapsePass" class="panel-collapse collapse  ${params.tipo == 'foto' ? '' : 'in'}">
            <div class="panel-body">
                <g:form class="form-horizontal" name="frmPass" role="form" action="savePass_ajax" method="POST">
                    <div class="form-group required">
                        <span class="form-grup col-md-3">
                            <label for="password_actual" class="control-label text-info">
                                Contraseña actual
                            </label>
                            <div class="input-group">
                                <g:passwordField name="password_actual" class="form-control required"/>
                                <span class="input-group-addon"><i class="fa fa-unlock"></i></span>
                            </div>
                        </span>
                        <span class="form-grup col-md-3">
                            <label for="password" class="control-label text-info">
                                Nueva contraseña
                            </label>
                            <div class="input-group">
                                <g:passwordField name="password" class="form-control required"/>
                                <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                            </div>
                        </span>
                        <span class="form-grup col-md-3">
                            <label for="password_again" class="control-label text-info">
                                Confirme la contraseña
                            </label>

                            <div class="input-group">
                                <g:passwordField name="password_again" class="form-control required" equalTo="#password"/>
                                <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                            </div>
                        </span>
                        <div class="col-md-2" style="margin-top: 20px;">
                            <a href="#" class="btn btn-success" id="btnPass">
                                <i class="fa fa-save"></i> Guardar
                            </a>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(function () {

        var $btnPass = $("#btnPass");
        var $frmPass = $("#frmPass");

        $("#password_actual").val("");


        function submitPass() {
            var url = $frmPass.attr("action");
            var data = $frmPass.serialize();
            $btnPass.hide().after(spinner);
            $.ajax({
                type    : "POST",
                url     : url,
                data    : data,
                success : function (msg) {
                    var parts = msg.split("_");
                    log(parts[1], parts[0] == "OK" ? "success" : "error");
                    spinner.remove();
                    $btnPass.show();
                    $frmPass.find("input").val("");
                    validatorPass.resetForm();
                }
            });
        }


        $frmPass.find("input").keyup(function (ev) {
            if (ev.keyCode == 13) {
                submitPass();
            }
        });

        var validatorPass = $frmPass.validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            rules          : {
                password_actual : {
                    remote : {
                        url  : "${createLink(action:'validarPass_ajax')}",
                        type : "post"
                    }
                }
            },
            messages       : {
                password_actual : {
                    remote : "El password actual no coincide"
                }
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
            }
        });
        $btnPass.click(function () {
            submitPass();
        });
    });
</script>

</body>
</html>