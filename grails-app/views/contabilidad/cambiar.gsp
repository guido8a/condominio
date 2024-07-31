<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Cambiar Contabilidad</title>
    </head>

    <body>
    <div class="panel panel-info">
        <div class="panel-heading">
            <h3 class="panel-title">Cambiar la Contabilidad de Trabajo</h3>
        </div>
        <div class="panel-body">
            <g:form action="cambiarContabilidad" name="frmContabilidad">
                <div class="row">
                    <div class="col-md-2">
                        <b>Usuario:</b>
                    </div>

                    <div class="col-md-6">
                        ${yo.nombre} ${yo.apellido} (${yo.login})
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-2">
                        <b>Contabilidad actual:</b>
                    </div>

                    <div class="col-md-6">
                        ${cont}
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-2">
                        <b>Cambiar a contabilidad:</b>
                    </div>

                    <div class="col-md-8 text-info">
                        <g:select name="contabilidad" from="${contabilidades}" class="form-control text-info" optionKey="id"/>
                    </div>
                </div>
            </g:form>

        </div>
    </div>
        <div class="row">
            <div class="col-md-5 text-center">
                <a href="#" class="btn btn-success" id="btnSave">
                    <i class="fa fa-save"></i> Guardar y Retornar a Proceso Contable
                </a>
            </div>
            <div class="col-md-2 text-center">
                <a href="#" class="btn btn-default" id="btnCancelar">
                    <i class="fa fa-arrow-left"></i> Retornar a Proceso Contable
                </a>
            </div>
        </div>

        <script type="text/javascript">
            $("#btnSave").click(function () {
                $("#frmContabilidad").submit();
            });
            $("#btnCancelar").click(function () {
                window.location.href = "${createLink(controller: 'proceso', action: 'lsta')}";
            });
        </script>

    </body>
</html>