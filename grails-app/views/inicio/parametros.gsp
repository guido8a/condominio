<%@ page contentType="text/html" %>

<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Parámetros</title>

        <style type="text/css">

        .tab-content, .left, .right {
            height : 600px;
        }

        .tab-content {
            /*background  : #EFE4D1;*/
            background    : #EEEEEE;
            border-left   : solid 1px #DDDDDD;
            border-bottom : solid 1px #DDDDDD;
            border-right  : solid 1px #DDDDDD;
            padding-top   : 10px;
        }

        .descripcion {
            /*margin-left : 20px;*/
            font-size : 12px;
            border    : solid 2px cadetblue;
            padding   : 0 10px;
            margin    : 0 10px 0 0;
        }

        .info {
            font-style : italic;
            color      : navy;
        }

        .descripcion h4 {
            color      : cadetblue;
            text-align : center;
        }

        .left {
            width : 600px;
            text-align: justify;
            /*background : red;*/
        }

        .right {
            width       : 300px;
            margin-left : 20px;
            padding: 20px;
            /*background  : blue;*/
        }

        .fa-ul li {
            margin-bottom : 10px;
        }

        </style>

    </head>

    <body>

        <g:set var="iconGen" value="fa fa-cog"/>
        <g:set var="iconEmpr" value="fa fa-building-o"/>

        <!-- Nav tabs -->
        <ul class="nav nav-tabs">
            <li class="active"><a href="#generales" data-toggle="tab">Generales</a></li>
            <li><a href="#empresa" data-toggle="tab">Empresa</a></li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content ui-corner-bottom">
            <div class="tab-pane active" id="generales">
                <div class="left pull-left">
                    <ul class="fa-ul">
                        <li>
                            <i class="fa-li ${iconGen}"></i>
                            <span id="tpoc">
                                <g:link controller="tipoOcupacion" action="list">Tipo de Ocupación</g:link> de la vivienda puede
                                ser el propietario o un arrendatario.
                            </span>

                            <div class="descripcion hide">
                                <h4>Tipo de Ocupación</h4>

                                <p>Tipo de ocupación de la vivienda: puede ser el propietario o un arrendatario.</p>
                            </div>
                        </li>

                        <li>
                            <i class="fa-li ${iconGen}"></i>
                            <span id="edif">
                                <g:link controller="edificio" action="list">Edificio</g:link> o grupo de viviendas dentro del condominio.
                                Se usa para diferenciar la zona a la cual pertenece una determinada vivienda dentro del condominio.
                            </span>

                            <div class="descripcion hide">
                                <h4>Edificio</h4>

                                <p>Edificio, torre o grupo de viviendas dentro del condominio.
                                Se usa para diferenciar la zona a la cual pertenece una determinada vivienda dentro del condominio</p>
                            </div>
                        </li>

                        <li>
                            <i class="fa-li ${iconGen}"></i>
                            <span id="tpgs">
                                <g:link controller="tipoGasto" action="list">Tipo de gasto</g:link> en el que se incurre en la
                                administración del condominio
                            </span>

                            <div class="descripcion hide">
                                <h4>Tipo de Gasto</h4>

                                <p>Clasificación de los gastos del condominio para diferenciar los distintos egresos
                                que se hacen en la administración del condominio</p>

                            </div>
                        </li>

                        <li>
                            <i class="fa-li ${iconGen}"></i>
                            <span id="tpob">
                                <g:link controller="tipoObra" action="list">Tipo de Obra</g:link> para
                                el registro de las mejoras y reportes de daños o mal funcionamiento de los recursos del condominio.
                            </span>

                            <div class="descripcion hide">
                                <h4>Tipo de Obra o Acción</h4>

                                <p>Para el registro de las mejoras y reportes de daños o mal funcionamiento de los
                                recursos del condominio.</p>
                            </div>
                        </li>

                        <li>
                            <i class="fa-li ${iconGen}"></i>
                            <span id="prmt">
                                <g:link controller="tipoComprobante" action="list">Parámetros del sistema</g:link> para fijar
                                las variables de funcionamiento
                            </span>

                            <div class="descripcion hide">
                                <h4>Parámetros del Sistema</h4>

                                <p>Fija las variables de funcionamiento y pertenecia del sistema</p>

                            </div>
                        </li>

                    </ul>
                </div>

                <div class="generales right pull-right">
                </div>
            </div>

            <div class="tab-pane" id="empresa">
                <div class="left pull-left">
                    <ul class="fa-ul">
                        <li>
                            <i class="fa-li ${iconEmpr}"></i>
                            <span id="paramsEmp">
                                <g:link controller="empresa" action="list">Parámetros del Condominio</g:link> para definir la forma de
                                funcionamiento del sistema.
                            </span>

                            <div class="descripcion hide">
                                <h4>Parámetros del Condominio</h4>

                                <p>Parámetros de funcionamiento del sistema,</p>
                            </div>
                        </li>
                    </ul>
                </div>

                <div class="empresa right pull-right">
                </div>
            </div>

        </div>

        <script type="text/javascript">

            $("#btnCR").click(function () {
               location.href='${createLink(controller: 'conceptoRetencionImpuestoRenta', action: 'list')}?max=' + 10 + "&offset=" + 0
            });

            function prepare() {
                $(".fa-ul li span").each(function () {
                    var id = $(this).parents(".tab-pane").attr("id");
                    var thisId = $(this).attr("id");
                    $(this).siblings(".descripcion").addClass(thisId).addClass("ui-corner-all").appendTo($(".right." + id));
                });
            }

            $(function () {
                prepare();
                $(".fa-ul li span").hover(function () {
                    var thisId = $(this).attr("id");
                    $("." + thisId).removeClass("hide");
                }, function () {
                    var thisId = $(this).attr("id");
                    $("." + thisId).addClass("hide");
                });
            });
        </script>

    </body>
</html>