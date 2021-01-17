<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    %{--<link href="${resource(dir: 'bootstrap-3.1.1/css', file: 'bootstrap-theme-spacelab.css')}" rel="stylesheet">--}%

    <meta name="layout" content="login">
    <title>Login</title>

    <style type="text/css">
    .archivo {
        width: 100%;
        float: left;
        margin-top: 30px;
        text-align: center;
    }
    </style>
</head>

<body>

%{--<div style="text-align: center; margin-top: 20px; height: ${(flash.message) ? '650' : '580'}px;" class="well">--}%
<div style="text-align: center;" class="well">

    <h1 class="titl" style="font-size: 24px; color: #06a">Sistema de Administración de Condominios</h1>
    <h2 class="titl" style="font-size: 24px; color: #06a">Ingreso al sistema</h2>
    <elm:flashMessage tipo="${flash.tipo}" icon="${flash.icon}"
                      clase="${flash.clase}">${flash.message}</elm:flashMessage>

    %{--<div class="dialog ui-corner-all" style="height: 295px;padding: 10px;width: 910px;margin: auto;margin-top: 5px">--}%
    <div class="dialog ui-corner-all" style="height: 70%;padding: 10px;width: 100%;margin: auto;margin-top: 5px">
        <div class="col-xs-12">
            %{--<img src="${resource(dir: 'images', file: 'condominio.png')}" style="padding: 40px;"/>--}%
            %{--<img src="${resource(dir: 'images', file: 'logo.png')}" style="padding: 10%; max-height: 500px; height: 40%"/>--}%
            <img src="${resource(dir: 'images', file: 'logo.png')}" style="width: inherit; max-width: 400px;" />
        </div>

        <div style="width: 100%;height: 20px;float: left;margin-top: 30px;text-align: center">
            <a href="#" id="ingresar" class="btn btn-primary" style="width: 120px; margin: auto">
                <i class="icon-off"></i>Ingresar</a>
        </div>

        <div class="archivo">
            Para mayor información puede consultar el
            <a href="${createLink(uri: '/descriptivo condominios.pdf')}" target="_blank"><img
                    src="${resource(dir: 'images', file: 'pdf_pq.png')}"/>descriptivo del sistema</a>
        </div>


        <p class="text-info pull-right" style="font-size: 10px; margin-top: 20px">
        &copy; Desarrollado por: TEDEIN S.A. Versión ${message(code: 'version', default: '1.1.0x')} - (2018 - 2021)
        </p>
    </div>
</div>


<div class="modal fade" id="modal-ingreso" tabindex="-1" role="dialog" aria-labelledby=""
     aria-hidden="true" style="position: absolute; top: 10px;">
    <div class="modal-dialog" id="modalBody" style="width: 80%px; max-width: 320px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Ingreso al sistema</h4>
            </div>

            <div class="modal-body" style="width: 100%; margin: auto">
                <g:form name="frmLogin" action="validar" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-md-5" for="login">Usuario</label>

                        <div class="controls col-md-7">
                            <input name="login" id="login" type="text" class="form-control required"
                                   placeholder="Usuario" required autofocus >
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-5" for="pass">Contraseña</label>

                        <div class="controls col-md-7">
                            <input name="pass" id="pass" type="password" class="form-control required"
                                   placeholder="Contraseña" required>
                        </div>
                    </div>

                    <div class="divBtn" >
                        <a href="#" class="btn btn-primary btn-lg btn-block" id="btn-login"
                           style="width: 60%; margin: auto">
                            <i class="fa fa-lock"></i> Ingresar
                        </a>
                    </div>

                </g:form>
            </div>
        </div>
    </div>
</div>

<div id="cargando" class="text-center hidden">
    <img src="${resource(dir: 'images', file: 'spinner32.gif')}" alt='Cargando...' width="32px" height="32px"/>
</div>

<script type="text/javascript">


    var $frm = $("#frmLogin");
    function doLogin() {
        if ($frm.valid()) {
            $("#cargando").removeClass('hidden');
            $(".btn-login").replaceWith($("#cargando"));
            $("#frmLogin").submit();
        }
    }

    function doPass() {
        if ($("#frmPass").valid()) {
            $("#btn-pass").replaceWith(spinner);
            $("#frmPass").submit();
        }
    }

    $(function () {

        $("#ingresar").click(function () {
            var initModalHeight = $('#modal-ingreso').outerHeight();
            //alto de la ventana de login: 270
            $("#modalBody").css({'margin-top': ($(document).height() / 2 - 135)}, {'margin-left': $(window).width() / 2});
            $("#modal-ingreso").modal('show');

            setTimeout(function () {
                $("#login").focus();
            }, 500);

        });

        $("#btnOlvidoPass").click(function () {
            $("#recuperarPass-dialog").modal("show");
            $("#modal-ingreso").modal("hide");
        });

        $frm.validate();
        $("#btn-login").click(function () {
            doLogin();
        });

        $("#btn-pass").click(function () {
            doPass();
        });

        $("input").keyup(function (ev) {
            if (ev.keyCode == 13) {
                doLogin();
            }
        })
    });


</script>

</body>
</html>