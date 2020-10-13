<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="seguridad.Persona" %>

<html xmlns="http://www.w3.org/1999/html">
<head>
    <title>Condominio</title>
    <meta name="layout" content="main"/>
    <style type="text/css">
    @page {
        size: 8.5in 11in;  /* width height */
        margin: 0.25in;
    }

    .item {
        width: 320px;
        height: 220px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #eceeff;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }
    .item2 {
        width: 660px;
        height: 160px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #eceeff;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }

    .imagen {
        width: 200px;
        height: 160px;
        margin: auto;
        margin-top: 10px;
    }
    .imagen2 {
        width: 180px;
        height: 130px;
        margin: auto;
        margin-top: 10px;
        margin-right: 40px;
        float: right;
    }

    .texto {
        width: 90%;
        height: 50px;
        padding-top: 0px;
        margin: auto;
        margin: 8px;
        font-size: 16px;
        font-style: normal;
    }

    .fuera {
        margin-left: 15px;
        margin-top: 20px;
        /*background-color: #317fbf; */
        background-color: rgba(114, 131, 147, 0.9);
        border: none;
    }

    .titl {
        font-family: 'open sans condensed';
        font-weight: bold;
        text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
        color: #0070B0;
        margin-top: 20px;
    }
    </style>
</head>

<body>
<div class="dialog">
    <g:set var="inst" value="${utilitarios.Parametros.get(1)}"/>

    <div style="text-align: center;"><h2 class="titl">
            <p class="text-warning">${session.condominio.nombre}</p>
        </h2>
    </div>

    <div class="body ui-corner-all" style="width: 680px;position: relative;margin: auto;margin-top: 40px;height: 280px; ">


        <a href= "${createLink(controller:'vivienda', action: 'index')}" style="text-decoration: none">
        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'vivienda.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto">
                    <span class="text-success"><strong>Departamentos y Personas</strong></span></div>
            </div>
        </div>
        </a>

        <a href= "${createLink(controller:'egreso', action: 'egresos')}" style="text-decoration: none">
        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'agenda.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto">
                    <span class="text-success"><strong>Ingresos y Gastos</strong></span></div>
            </div>
        </div>
        </a>


        <a href= "${createLink(controller:'obra', action: 'listaObras')}" style="text-decoration: none">
            <div class="ui-corner-all item2 fuera">
                <div class="ui-corner-all item2">
                    <div class="imagen2">
                        <img src="${resource(dir: 'images', file: 'actividades.png')}" width="100%" height="100%"/>
                    </div>

                    <div style="margin-top: 50px; margin-left: 80px;">
                        <span class="text-success" style="font-size: large"><strong>Gestión de Obras del Condominio</strong></span>
                        <span class="text-success" style="margin-top: 20px; margin-left: 30px; width: 400px; display: block">
                            <strong>Daños y reparaciones o mejoras pendientes en el Condominio</strong></span></div>
                </div>
            </div>
        </a>



    </div>


</div>
    <script type="text/javascript">
        $(".fuera").hover(function () {
            var d = $(this).find(".imagen,.imagen2")
            d.width(d.width() + 10)
            d.height(d.height() + 10)

        }, function () {
            var d = $(this).find(".imagen, .imagen2")
            d.width(d.width() - 10)
            d.height(d.height() - 10)
        })


        $(function () {
            $(".openImagenDir").click(function () {
                openLoader();
            });

            $(".openImagen").click(function () {
                openLoader();
            });
        });



    </script>
</body>
</html>
