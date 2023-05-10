<%
    def buscadorServ = grailsApplication.classLoader.loadClass('utilitarios.BuscadorService').newInstance()
%>

<%@ page import="seguridad.Persona" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Cambio Administración</title>

    <style type="text/css">

    .alinear {
        text-align: center !important;
    }
    .titulo {
        text-align: center;
        /*margin-right: 10px;*/
        width: 100%;
        color: #1e75b1;
        font-size: 14px;
    }
    </style>
</head>

<body>

<div style="text-align: center; margin-top: -30px; margin-bottom: 10px">
    <h3>Cambio Administración o Período de Administración</h3>
</div>


    <div class="row" style="margin-bottom: 10px; margin-top: 40px">
        <div class="col-md-12">
            <div class="col-md-4">
                <b style="margin-left: 0px">Nombre del Condominio: </b>
            </div>
            <div class="col-md-2">
                Fecha de inicio de la nueva administración:
            </div>
            <div class="col-md-2">
                <b>Seleccione el nuevo Administrador del Condominio: </b>
            </div>
            <div class="col-md-2">
                <b>Nombre de usuario: </b>
            </div>
            <div class="col-md-2">
                <b style="margin-left: 0px">Contraseña para el administrador: </b>
            </div>
        </div>
            <div class="col-md-4">
                <g:textField name="criterio" style="border-color: #53a7ff"
                         value="${condominio.nombre}" readonly=""
                         id="val_condominio" class="form-control"/>
            </div>
            <div class="col-md-2">
                <elm:datepicker name="fecha_name" title="Fecha de inicio de la nueva adminsitración" id="fcha" class="datepicker form-control"
                                maxDate="new Date()" value="${new Date()}"/>
            </div>
            <div class="col-md-2">
                <elm:select name="buscador" from="${seguridad.Persona.findAllByCondominio(condominio, [sort: 'apellido'])}" value=""
                            optionKey="id" optionValue="${{it.apellido + ' ' + it.nombre}}" id="administrador"
                            class="form-control"/>
            </div>
            <div class="col-md-2">
                <g:textField name="nombre" value="" id="nombre" class="form-control"/>
            </div>
            <div class="col-md-2">
                <input name="password" type="password" style="margin-right: 10px;" value=""
                             id="password" class="form-control required" placeholder="Contraseña"/>
            </div>

            <div class="col-md-12" style="text-align: center">
                <hr/>
                <div  style="margin-left: -10px; margin-top: 60px;">

                    <a href="#" name="busqueda" class="btn btn-info" id="btnProcesar" title="Procesar nueva Administración"
                       style=" padding: 10px;">
                        Cerrar la Administración anterior &nbsp;&nbsp;&nbsp;<i class="fa fa-check"></i></a>

                </div>

            </div>


    </div>


<script type="text/javascript">

    function procesar () {
        bootbox.dialog({
            title   : "Cierre de periodo de Adminsitración",
            message : "<i class='fa fa-check-square-o fa-5x pull-left text-danger text-shadow'></i>" +
                "<p style='font-size: 16px'>" +
                "¿Está seguro que desea procesar el cierre de periodo de la administración?<br> " +
                "Esta acción no se puede deshacer.</p>" +
                "El nuevo perdiodo se creará como condominio:<p class='titulo'><strong>" +
                $("#val_condominio").val() + "</strong></p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                aceptar : {
                    label     : "<i class='fa fa-check-square-o'></i> Procesar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Procesando...");
                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(controller: 'condominio', action: 'procesaCambio')}",
                            data: {
                                condominio: $("#val_condominio").val(),
                                fecha: $("#fcha").val(),
                                admin: $("#administrador").val(),
                                login: $("#nombre").val(),
                                pass: $("#password").val()
                            },
                            success: function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "ok" ? "success" : "error"); // log(msg, type, title, hide)

                                if (parts[0] == "ok") {
                                    setTimeout(function() {
                                        location.reload(true);
                                    }, 1000);
                                } else {
                                    closeLoader();
                                }
                            }
                        });

                    }
                }
            }
        });
    }

    $("#btnProcesar").click(function () {
        procesar();
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            $("#btnProcesar").click();
        }
    });


</script>

</body>
</html>