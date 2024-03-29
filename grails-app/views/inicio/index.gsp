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
        height: 210px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #eceeff;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }
    .item2 {
        width: 1000px;
        height: 80px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        /*background-color: #eceeff;*/
        background-color: #dcdedf;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }

    .imagen {
        width: 200px;
        height: 150px;
        margin: auto;
        margin-top: 10px;
    }
    .imagen2 {
        width: 160px;
        height: 57px;
        margin-top: 6px;
        margin-left: 220px;
        margin-right: 40px;
        float: left;
    }

    .texto {
        width: 90%;
        height: 50px;
        padding-top: 0px;
        /*margin: auto;*/
        margin: 8px;
        font-size: 13px;
        font-style: normal;
    }

    .texto2 {
        width: 90%;
        height: 50px;
        padding-top: 15px;
        margin: 8px;
        font-size: 15px;
        font-style: normal;
    }

    .fuera {
        margin-left: 15px;
        margin-top: 15px;
        /*background-color: #317fbf; */
        background-color: rgba(114, 131, 147, 0.9);
        border: none;
    }

    .titl {
        font-family: 'open sans condensed';
        font-weight: bold;
        text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
        color: #0070B0;
        margin-top: 15px;
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

    <div class="body ui-corner-all" style="width: 1020px;position: relative;margin: auto;margin-top: 20px;height: 280px; ">


        <a href= "${createLink(controller:'vivienda', action: 'index')}" style="text-decoration: none">
            <div class="ui-corner-all item fuera">
                <div class="ui-corner-all item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'vivienda.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto">
                        <span class="text-success"><strong>Departamentos y Personas (Ingresos)</strong></span></div>
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
                        <span class="text-success"><strong>Registro de Gastos y Proveedores</strong></span></div>
                </div>
            </div>
        </a>


        <a href= "${createLink(controller:'obra', action: 'listaObras')}" style="text-decoration: none">
            <div class="ui-corner-all item fuera">
                <div class="ui-corner-all item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'actividades.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto">
                        <span class="text-success"><strong>Obras del Condominio y Sugerencias</strong></span>
                    </div>
                </div>
            </div>
        </a>

        <a href= "${createLink(controller:'documento', action: 'list', id: session.condominio.id)}" style="text-decoration: none">
            <div class="ui-corner-all item fuera">
                <div class="ui-corner-all item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'documentos.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto">
                        <span class="text-success"><strong>Documentos del condominio: Reglamento, actas, etc.</strong></span>
                    </div>

                </div>
            </div>
        </a>

        <a href= "${createLink(controller:'egreso', action: 'saldos', id: session.condominio.id)}" style="text-decoration: none">
            <div class="ui-corner-all item fuera">
                <div class="ui-corner-all item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'gastos.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto">
                        <span class="text-success"><strong>Consultar por fechas: Ingresos, Egresos y Saldos</strong></span>
                    </div>

                </div>
            </div>
        </a>

        <a href= "${createLink(controller:'empleado', action: 'list', id: session.condominio.id)}" style="text-decoration: none">
            <div class="ui-corner-all item fuera">
                <div class="ui-corner-all item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'mantenimiento.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto">
                        <span class="text-success"><strong>Nómina del Condominio - Empleados</strong></span>
                    </div>

                </div>
            </div>
        </a>
       %{--${session.perfil.codigo}--}%
        <g:if test="${session.perfil.codigo == 'ADC'}">
            <a href= "${createLink(controller:'condominio', action: 'cambioAdmn')}" style="text-decoration: none">
                <div class="ui-corner-all item2 fuera">
                    <div class="ui-corner-all item2">
                        <div class="imagen2">
                            <img src="${resource(dir: 'images', file: 'cambio.png')}" width="100%" height="100%"/>
                        </div>

                        <div class="texto2">
                            <span class="text-info">
                                <strong>Cambio de Administración o cambio de período de Administración</strong></span>
                        </div>

                    </div>
                </div>
            </a>
        </g:if>

    </div>
</div>

<div class="col-md-3" style="margin-top: 10px; float: right">
    <label>Desarrollado por: Tedein S.A.</label>
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
