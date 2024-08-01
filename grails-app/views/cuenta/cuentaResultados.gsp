<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Cuentas de resultados</title>
    </head>

    <body>

        <elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="list" class="btn btn-primary">
                    <i class="fa fa-chevron-left"></i> Cuentas
                </g:link>
                <a href="#" class="btn btn-success" id="btnSave"><i class="fa fa-save"></i> Guardar</a>
            </div>
        </div>


    <div class="vertical-container vertical-container-list">
        <p class="css-vertical-text">Cuentas de resultados</p>

        <div class="linea"></div>

        <p style="font-size: medium">
           * Por favor seleccione las cuentas para el cálculo de resultado del ejercicio
        </p>
        <g:form class="form-horizontal" action="grabarCuentaResultado" name="res_form" method="POST">
            <div class="form-group">
                <label for="super" class="col-md-2 control-label">Cuenta de Superávit</label>

                <div class="col-md-7">
                    <g:select name="super" class="form-control" from="${cuentas}" optionKey="id" value="${cuentaS?.id}"/>
                </div>

                <div class="form-group">
                </div>
                <label for="deficit" class="col-md-2 control-label">Cuenta de Déficit</label>

                <div class="col-md-7">
                    <g:select name="deficit" class="form-control" from="${cuentas}" optionKey="id" value="${cuentaD?.id}"/>
                </div>

                <div class="form-group">
                </div>
                <label for="deficit" class="col-md-2 control-label">Cuenta de Activos Fijos</label>

                <div class="col-md-7">
                    <g:select name="activo" class="form-control" from="${cuentas1}" optionKey="id" value="${cuentaA?.id}"/>
                </div>

                <div class="form-group">
                </div>
                <label for="deficit" class="col-md-2 control-label">Cuenta de Depreciación</label>

                <div class="col-md-7">
                    <g:select name="depreciacion" class="form-control" from="${cuentas2}" optionKey="id" value="${cuentaP?.id}"/>
                </div>

                <div class="form-group">
                </div>
                <label for="gasto" class="col-md-2 control-label">Cuenta de Gasto</label>

                <div class="col-md-7">
                    <g:select name="gasto" class="form-control" from="${cuentas5}" optionKey="id" value="${cuentaG?.id}"/>
                </div>
            </div>
        </g:form>

    </div>





        <script type="text/javascript">
            $(function () {
                $("#btnSave").click(function () {
                    $("#res_form").submit();
                });
            });
        </script>
    </body>
</html>