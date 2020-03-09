<html>


<head>
    <meta name="layout" content="main"/>


    <title>Reportes</title>

    <style type="text/css">

    .tab-content, .left, .right {
        height : 600px;
    }

    .tab-content {
        /*background  : #EFE4D1;*/
        background  : #EEEEEE;
        border      : solid 1px #DDDDDD;
        padding-top : 10px;
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
        width : 710px;
        /*background : red;*/
    }

    .right {
        width       : 300px;
        margin-left : 40px;
        /*background  : blue;*/
    }

    .fa-ul li {
        margin-bottom : 10px;
    }

    .uno {

        float      : left;
        width      : 150px;
        margin-top : 10px;
    }

    .dos {

        float      : left;
        width      : 250px;
        margin-top : 10px;
    }

    .fila {
        height : 40px;
    }

    .textoUno {
        float : left;
        width : 250px;

    }

    .textoDos {
        float : left;

    }


    .btn-sq-lg {
        width: 150px !important;
        height: 150px !important;
    }

    .btn-sq {
        width: 100px !important;
        height: 100px !important;
        font-size: 10px;
    }

    .btn-sq-sm {
        width: 50px !important;
        height: 50px !important;
        font-size: 10px;
    }

    .btn-sq-xs {
        width: 25px !important;
        height: 25px !important;
        padding:2px;
    }

    </style>

</head>

<body>




<div class="row">
    <div class="col-md-12 col-xs-5">
        <p>
            <a href="#" class="link btn btn-success btn-ajax" id="btnCondominos" data-toggle="modal" data-target="#gestorContable">
                <i class="fa fa-building-o fa-5x"></i><br/>
                Listado de Condóminos
            </a>
            <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#detalleIngresos" title="Detalle de ingresos">
                <i class="fa fa-sign-in fa-5x"></i><br/>
                Detalle de Ingresos
            </a>
            <a href="#" class="link btn btn-warning btn-ajax" data-toggle="modal" data-target="#detalleEgresos">
                <i class="fa fa-sign-out fa-5x"></i><br/>
                Detalle de Egresos
            </a>
            <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#listaObras">
                <i class="fa fa-home fa-5x"></i><br/>
                Detalle de Obras
            </a>
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#balance">
                <i class="fa fa-book fa-5x"></i><br/>
                Balance
            </a>
        </p>
    </div>
</div>

<div class="row">
    <div class="col-md-12 col-xs-5">
        <p>
            <a href="#" class="link btn btn-primary btn-ajax" id="btnAceptarGestor">
                <i class="fa fa-line-chart fa-5x"></i><br/>
                Aportes y Gastos
            </a>
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#modalDeudas"
               title="Estado de cuenta de los condóminos">
                <i class="fa fa-file-text-o fa-5x"></i><br/>
                Deudas Pendientes
            </a>
            <a href="#" class="link btn btn-danger btn-ajax" data-toggle="modal" data-target="#solicitud">
                <i class="fa fa-money fa-5x"></i><br/>
                Solicitudes de Pago
            </a>
            <a href="#" class="link btn btn-success btn-ajax" data-toggle="modal" data-target="#ingresosEgresos">
                <i class="fa fa-line-chart fa-5x"></i><br/>
                Ingresos y Egresos
            </a>
            <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#egresosProveedores">
                <i class="fa fa-book fa-5x"></i><br/>
                Egresos Proveedores
            </a>
            <a href="#" class="link btn btn-danger btn-ajax" data-toggle="modal" data-target="#monitorio">
                <i class="fa fa-money fa-5x"></i><br/>
                Monitorio
            </a>

        </p>
    </div>
</div>

<!-------------------------------------------- MODALES ----------------------------------------------------->
%{--//dialog de contabilidad--}%
<div class="modal fade col-md-12 col-xs-12" id="detalleIngresos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">Ingresos</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesdeIng_name" id="fechaDesdeIng" class="datepicker form-control" value="${new Date() - 30}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaHastaIng_name" id="fechaHastaIng" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarIngresos btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>



<div class="modal fade col-md-12 col-xs-12" id="detalleEgresos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelEgr">Egresos</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesdeEgr_name" id="fechaDesdeEgr" class="datepicker form-control" value="${new Date() - 30}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaHastaEgr_name" id="fechaHastaEgr" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarEgresos btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>



%{--dialog comprobante--}%
<div class="modal fade" id="comprobante" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalComprobante">Comprobante</h4>
            </div>

            <div class="modal-body">
                <div class="fila" style="margin-bottom: 10px">
                    <label class="uno">Contabilidad:</label>

                </div>

                <div class="fila" style="margin-bottom: 15px">
                    <label class="uno">Tipo:</label>
                    %{--<g:select class="form-control dos" name="compTipo" from="${cratos.TipoComprobante.list()}"  optionKey="id" optionValue="descripcion"/>--}%
                </div>

                <div class="fila">
                    <label class="uno">Número:</label>
                    <div class="col-md-2" id="divNumComp" style="margin-left: -10px"></div>
                    <g:textField type="text" class="form-control dos number" name="compNum" maxlength="25" style="width: 200px; margin-top: -1px"/>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarComprobante btn-success"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

%{--dialog libro diario--}%
<div class="modal fade" id="libroDiario" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalLibroDiario">Libro Diario</h4>
            </div>

            <div class="modal-body" id="bodyLibro">
                <div class="fila" style="margin-bottom: 15px">
                    <label class="uno">Contabilidad:</label>

                </div>

                <div id="divPeriodo11" class="fila">
                    <label class="uno">Período:</label>

                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarLibro btn-success"><i class="fa fa-print"></i> Imprimir
                </button>
            </div>
        </div>
    </div>
</div>

%{--dialog Deudas--}%
<div class="modal fade col-md-12 col-xs-12" id="modalDeudas" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Valores por cobrar</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-6 col-xs-4">
                        <label>Fecha de corte de los valores adeudados:</label>
                    </div>
                    <div class="col-md-4 col-xs-6">
                        <elm:datepicker name="fechaGenera_name" id="fechaImprime" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-6 col-xs-4">
                        <label>Torre:</label>
                    </div>
                    <div class="col-md-4 col-xs-6">
                        <g:select name="torre_name" id="torre" from="${edificios}" optionKey="id" optionValue="descripcion" class="form-control"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnDeudas btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

%{--dialog situación--}%
<div class="modal fade col-md-12 col-xs-12" id="solicitud" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalsolicitud">Generar cartas solicitando pagos</h4>
            </div>

            <div class="modal-body" id="bodysolicitud">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1 col-xs-1">
                        </div>
                        <div class="col-md-3 col-xs-3">
                            <label>Generar para deudas con </label>
                        </div>
                        <div class="col-md-7 col-xs-7">
                            <g:select from="${['1':'Valores superiores a 1 alícuota',
                                               '2':'Valores superiores a 2 alícuotas',
                                               '3':'Valores superiores a 3 alícuotas']}"
                                      optionValue="value" optionKey="key" name="mesesHasta_name"
                                      id="valorHasta" class="form-control"/>
                        </div>
                        <div class="col-md-1 col-xs-1">
                        </div>

                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnSolicitud btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-md-12 col-xs-12" id="monitorio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalmonitorio">Generar cartas solicitando pagos</h4>
            </div>

            <div class="modal-body" id="bodymonitorio">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1 col-xs-1">
                        </div>
                        <div class="col-md-3 col-xs-3">
                            <label>Generar para deudas con </label>
                        </div>
                        <div class="col-md-7 col-xs-7">
                            <g:select from="${['1':'Valores superiores a 1 alícuota',
                                               '2':'Valores superiores a 2 alícuotas',
                                               '3':'Valores superiores a 3 alícuotas']}"
                                      optionValue="value" optionKey="key" name="mesesHasta_name"
                                      id="valorHastaMn" class="form-control"/>
                        </div>
                        <div class="col-md-1 col-xs-1">
                        </div>

                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnMonitorio btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-md-12 col-xs-12" id="ingresosEgresos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalIngresoEgreso">Ingresos y Egresos</h4>
            </div>

            <div class="modal-body" id="bodysingresosEgresos">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1 col-xs-1">
                        </div>
                        <div class="col-md-3 col-xs-3">
                            <label>Año </label>
                        </div>
                        <div class="col-md-5 col-xs-7">
                            <g:select from="${anios}" name="anio_name" id="anio" class="form-control"/>
                        </div>
                        <div class="col-md-1 col-xs-1">
                        </div>

                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnIngresosEgresos btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-md-12 col-xs-12" id="listaObras" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelOb">Lista de Obras</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesdeEgr_name" id="fechaDesdeObr" class="datepicker form-control" value="${new Date() - 30}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaHastaEgr_name" id="fechaHastaObr" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarObras btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-md-12 col-xs-12" id="egresosProveedores" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelEP">Egresos Proveedor</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesdeProveedor_name" id="fechaDesdeProveedor" class="datepicker form-control" value="${new Date() - 30}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaHastaProveedor_name" id="fechaHastaProveedor" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnImprimirEgProveedores btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>


<div class="modal fade col-md-12 col-xs-12" id="balance" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelB">Balance</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesdeBalance_name" id="fechaDesdeB" class="datepicker form-control" value="${new Date() - 30}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaHastaBalance_name" id="fechaHastaB" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnImprimirBalance btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>


<!-------------------------------------------- MODALES ----------------------------------------------------->

<script type="text/javascript">


    $(".btnIngresosEgresos").click(function () {
        var anio = $("#anio").val();
        location.href="${createLink(controller: 'reportes', action: 'ingresosImprimir')}?anio=" + anio
    });

    $("#btnAceptarGestor").click(function () {
        location.href="${createLink(controller: 'reportes', action: 'detalle')}"
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

        /* ******************************** DIALOGS ********************************************* */


        $("#contP").change(function () {
            updatePeriodoSinTodo("");
        });
        $("#contP2").change(function () {
            updatePeriodoSinTodo("2");
        });

        $("#contP5").change(function () {
            updatePeriodoSinTodo("5");
        });
        $("#contP6").change(function () {
            updatePeriodoSinTodo("6");
        });

        $("#contP7").change(function () {
            updatePeriodoSinTodo("7");
        });
        $("#contP8").change(function () {
            updatePeriodoSinTodo("8");
        });
        $("#contP9").change(function () {
            updatePeriodoSinTodo("9");
        });

        $("#contP0").change(function () {
            updatePeriodoSinTodo("0");
        });

        $("#contP3").change(function () {
            updatePeriodo("3");
        });
        $("#contP4").change(function () {
            updatePeriodo("4");
        });
        $("#contP11").change(function () {
            updatePeriodoSinTodo("11");
        });

        $("#contP15").change(function () {
            updatePeriodoSinTodo("15");
        });

        $("#contP20").change(function () {
            updatePeriodoSinTodo("20");
        });




        $("#btnTodosPrv").button().click(function () {
            $("#hidVal").val("-1");
            $("#txtValor").val("Todos");
            return false;
        });



        $(".btnDeudas").click(function () {
            var fechaI = $("#fechaImprime").val();
            var torre = $("#torre").val();
            location.href = "${g.createLink(controller:'reportes', action: 'pagosPendientes4')}?fecha=" + fechaI + "&torre=" + torre
        });

        $(".btnSolicitud").click(function () {
            var vlor = $("#valorHasta").val();
            location.href = "${g.createLink(controller: 'reportes', action: 'imprimirSolicitudes')}?vlor=" + vlor;
        });

        $(".btnMonitorio").click(function () {
            var vlor = $("#valorHastaMn").val();
            location.href = "${g.createLink(controller: 'reportes', action: 'imprimirMonitorio')}?vlor=" + vlor;
        });

        function crearXML(mes, anio, override) {
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'xml', action: 'createXml')}",
                data    : {
                    mes      : mes,
                    anio     : anio,
                    override : override
                },
                success : function (msg) {
                    var parts = msg.split("_");
                    if (parts[0] == "NO") {
                        if (parts[1] == "1") {
                            var msgs = "Ya existe un archivo XML para el periodo " + mes + "-" + anio + "." +
                                "<ul><li>Si desea <strong>sobreescribir el archivo existente</strong>, haga click en el botón <strong>'Sobreescribir'</strong></li>" +
                                "<li>Si desea <strong>descargar el archivo previamente generado</strong>, haga click en el botón <strong>'Descargar'</strong></li>" +
                                "<li>Si desea <strong>ver la lista de archivos generados</strong>, haga cilck en el botón <strong>'Archivos'</strong></li></ul>";
                            bootbox.dialog({
                                title   : "Alerta",
                                message : msgs,
                                buttons : {
                                    sobreescribir : {
                                        label     : "<i class='fa fa-pencil'></i> Sobreescribir",
                                        className : "btn-primary",
                                        callback  : function () {
                                            crearXML(mes, anio, 1);
                                        }
                                    },
                                    descargar     : {
                                        label     : "<i class='fa fa-download'></i> Descargar",
                                        className : "btn-success",
                                        callback  : function () {
                                            location.href = "${createLink(controller: 'xml', action:'downloadFile')}?mes=" + mes;
                                        }
                                    },
                                    archivos      : {
                                        label     : "<i class='fa fa-files-o'></i> Archivos",
                                        className : "btn-default",
                                        callback  : function () {
                                            location.href = "${createLink(controller: 'xml', action:'downloads')}";
                                        }
                                    },
                                    cancelar      : {
                                        label     : "Cancelar",
                                        className : "btn-default",
                                        callback  : function () {
                                        }
                                    }
                                }
                            });
                        }
                    } else if (parts[0] == "OK") {
                        bootbox.dialog({
                            title   : "Descargar archivo",
                            message : "Archivo generado exitosamente",
                            buttons : {
                                descargar : {
                                    label     : "<i class='fa fa-download'> Descargar",
                                    className : "btn-success",
                                    callback  : function () {
                                        location.href = "${createLink(controller: 'xml', action:'downloadFile')}?mes=" + mes;
                                    }
                                }
                            }
                        });
                    }
                }
            });
        }

        $("#btnCondominos").click(function () {
            location.href = "${g.createLink(controller: 'reportes', action: 'listaCondominos')}";
        });

        $(".btnAceptarEgresos").click(function () {
            var fechaDesde = $("#fechaDesdeEgr").val();
            var fechaHasta = $("#fechaHastaEgr").val();

            if(fechaDesde == '' || fechaHasta == ''){
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
            }else{
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'reportes', action: 'revisarFecha_ajax')}',
                    data:{
                        desde: fechaDesde,
                        hasta: fechaHasta
                    },
                    success: function (msg){
                        if(msg == 'ok'){
                            location.href = "${g.createLink(controller:'reportes' , action: 'imprimirEgresos')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                        }else{
                            bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                            return false;
                        }
                    }
                });
            }
        });


        $(".btnAceptarIngresos").click(function () {
            var fechaDesde = $("#fechaDesdeIng").val();
            var fechaHasta = $("#fechaHastaIng").val();

            if(fechaDesde == '' || fechaHasta == ''){
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
            }else{
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'reportes', action: 'revisarFecha_ajax')}',
                    data:{
                        desde: fechaDesde,
                        hasta: fechaHasta
                    },
                    success: function (msg){
                        if(msg == 'ok'){
                            location.href = "${g.createLink(controller:'reportes' , action: 'imprimirIngresos')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                        }else{
                            bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                            return false;
                        }
                    }
                });
            }
        });


        $(".btnAceptarObras").click(function () {
            var fechaDesde = $("#fechaDesdeObr").val();
            var fechaHasta = $("#fechaHastaObr").val();

            if(fechaDesde == '' || fechaHasta == ''){
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
            }else{
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'reportes', action: 'revisarFecha_ajax')}',
                    data:{
                        desde: fechaDesde,
                        hasta: fechaHasta
                    },
                    success: function (msg){
                        if(msg == 'ok'){
                            location.href = "${g.createLink(controller:'reportes' , action: 'reporteObras')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                        }else{
                            bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                            return false;
                        }
                    }
                });
            }
        });
    });


    $(".btnImprimirEgProveedores").click(function () {
        var fechaDesde = $("#fechaDesdeProveedor").val();
        var fechaHasta = $("#fechaHastaProveedor").val();
        location.href = "${g.createLink(controller:'reportes' , action: 'reporteEgresosProveedor')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
    });


    $(".btnImprimirBalance").click(function () {
        var fechaDesde = $("#fechaDesdeB").val();
        var fechaHasta = $("#fechaHastaB").val();
        location.href = "${g.createLink(controller:'reportes' , action: 'balance')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
    });

</script>

</body>
</html>