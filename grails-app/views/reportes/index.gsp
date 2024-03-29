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

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


<div class="row">
    <div class="col-md-12 col-xs-5">
        <p>
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#detalleIngresos" title="Detalle de ingresos">
                <i class="fa fa-sign-in fa-5x"></i><br/>
                Detalle de Ingresos
            </a>
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#detalleEgresos">
                <i class="fa fa-sign-out fa-5x"></i><br/>
                Detalle de Egresos
            </a>
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#balance">
                <i class="fa fa-book fa-5x"></i><br/>
                Balance de resultados
            </a>
            <a href="#" class="link btn btn-primary btn-primary-outlined btn-ajax" data-toggle="modal" data-target="#informe"
               title="Informe de Resultados del Período">
                <i class="fa fa-tasks fa-5x"></i><br/>
                Informe de Resultados
            </a>
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#pagosPendientes"
               title="Detalle de pagos pendientes">
                <i class="fa fa-sign-out fa-5x"></i><br/>
                Detalle de pagos pendientes
            </a>

        </p>
    </div>
</div>

<div class="row">
    <div class="col-md-12 col-xs-5">
        <p>
            <a href="#" class="link btn btn-warning btn-ajax" data-toggle="modal" data-target="#cajaChica"
               title="Detalle Caja Chica">
                <i class="fa fa-archive fa-5x"></i><br/>
                Caja Chica
            </a>
            <a href="#" class="link btn btn-warning btn-ajax" data-toggle="modal" data-target="#egresosProveedores">
                <i class="fa fa-book fa-5x"></i><br/>
                Egresos Proveedores
            </a>
            <a href="#" class="link btn btn-warning btn-ajax" data-toggle="modal" data-target="#tipoEgreso"
               title="Detalle egresos clasificados por tipo">
                <i class="fa fa-sign-out fa-5x"></i><br/>
                Egresos por tipo de Gasto
            </a>
            <a href="#" class="link btn btn-warning btn-ajax" data-toggle="modal" data-target="#mantenimientoMejoras"
               title="Mantenimiento y mejoras">
                <i class="fa fa-wrench fa-5x"></i><br/>
                Gastos por mantenimiento y mejoras
            </a>
            <a href="#" class="link btn btn-warning btn-ajax" data-toggle="modal" data-target="#listaObras">
                <i class="fa fa-home fa-5x"></i><br/>
                Detalle de Obras
            </a>

        </p>
    </div>
</div>

<div class="row">
    <div class="col-md-12 col-xs-5">
        <p>
            <a href="#" class="link btn btn-success btn-ajax" data-toggle="modal" data-target="#modalCondominos">
                <i class="fa fa-building-o fa-5x"></i><br/>
                Listado de Condóminos
            </a>

            <a href="#" class="link btn btn-success btn-ajax" data-toggle="modal" data-target="#modalDeudas"
               title="Estado de cuenta de los condóminos">
                <i class="fa fa-file-text-o fa-5x"></i><br/>
                Deudas Pendientes
            </a>
            <a href="#" class="link btn btn-success btn-ajax" data-toggle="modal" data-target="#modalDeudasTotales"
               title="Estado de cuenta de los condóminos con totales">
                <i class="fa fa-file-text-o fa-5x"></i><br/>
                Deudas Totales
            </a>
            <a href="#" class="link btn btn-danger btn-ajax" data-toggle="modal" data-target="#solicitud">
                <i class="fa fa-money fa-5x"></i><br/>
                Solicitudes de Pago
            </a>
            <a href="#" class="link btn btn-danger btn-ajax" data-toggle="modal" data-target="#monitorio">
                <i class="fa fa-gavel fa-5x"></i><br/>
                Juicio Monitorio
            </a>

        </p>
    </div>
</div>

<div class="row">
    <div class="col-md-12 col-xs-5">
        <p>
            <a href="${createLink(controller: 'documento', action: 'listDocu')}" class="link btn btn-primary btn-ajax">
                <i class="fa fa-book fa-5x"></i><br/>
                Biblioteca del<br/>Condominio
            </a>
            <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#nuevaAlicuota"
               title="Cálculo de la Nueva Alícuota">
                <i class="fa fa-cog fa-5x"></i><br/>
                Cálculo Nueva Alícuota
            </a>
            %{--<a href="#" class="link btn btn-warning btn-ajax" data-toggle="modal" data-target="#ingresosEgresos2"--}%
            %{--title="Ingresos y egresos">--}%
            %{--<i class="fa fa-line-chart fa-5x"></i><br/>--}%
            %{--Ingresos y egresos mesuales--}%
            %{--</a>--}%
            <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#ingresosEgresos3"
               title="Ingresos y egresos">
                <i class="fa fa-line-chart fa-5x"></i><br/>
                Ingresos y egresos mensuales
            </a>
            <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#ingresosEgresos">
                <i class="fa fa-line-chart fa-5x"></i><br/>
                Ingresos y Egresos
            </a>
            <a href="#" class="link btn btn-info btn-ajax" id="btnAceptarGestor">
                <i class="fa fa-line-chart fa-5x"></i><br/>
                Aportes y Gastos
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
                <button type="button" class="btn btnAceptarIngresosExcel btn-info" data-dismiss="modal"><i class="fa fa-print"></i> Excel
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
                <button type="button" class="btn btnAceptarEgresosExcel btn-info" data-dismiss="modal"><i class="fa fa-print"></i> Excel
                </button>
            </div>
        </div>
    </div>
</div>

%{--dialog lista condóminos--}%
<div class="modal fade col-md-12 col-xs-12" id="modalCondominos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Lista de condóminos</h4>
            </div>
            <div class="modal-body">
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
                <button type="button" class="btn btnCondominos btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
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
                        <g:select name="torre_name" id="torreDeudas" from="${edificios}" optionKey="id" optionValue="descripcion" class="form-control"/>
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

%{--dialog Deudas con totales--}%
<div class="modal fade col-md-12 col-xs-12" id="modalDeudasTotales" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
                        <elm:datepicker name="fechaGeneraTot_name" id="fechaImprimeTot" class="datepicker form-control" value="${new Date()}"/>
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
                        <g:select name="torre2_name" id="torre2" from="${edificios}" optionKey="id" optionValue="descripcion" class="form-control"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnDeudasTotales btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
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
                <h4 class="modal-title" id="myModalLabelEP">Egresos por Proveedor</h4>
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
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Valor mínimo</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <g:select from="${[0, 10, 20, 30, 40, 50, 100]}" name="valor" id="valor" class="form-control"/>
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
                <h4 class="modal-title" id="myModalLabelB">Balance General</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-5 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker id="fechaDesdeB" class="datepicker form-control" value="${new Date() - 30}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-5 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker id="fechaHastaB" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-5 col-xs-4">
                        <label>Depósitos no registrados a la fecha de cierre del reporte</label>
                    </div>
                    <div class="col-md-3 col-xs-7">
                        <g:textField name="depos" class="form-control"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-1 col-xs-1"></div>
                    <div class="col-md-5 col-xs-4">
                        <label>Balance con detalle de valores por mes</label>
                    </div>
                    <div class="col-md-1 col-xs-1">
                        <g:checkBox name="detalleMes"/>
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

<div class="modal fade col-md-12 col-xs-12" id="informe" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Informe de Resultados</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker id="fechaDesdeInf" class="datepicker form-control" value="${inicioAnio}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-1 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker id="fechaHastaInf" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-5 col-xs-4">
                        <label>Depósitos no registrados a la fecha de cierre del reporte</label>
                    </div>
                    <div class="col-md-3 col-xs-7">
                        <g:textField name="depositos" class="form-control"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-1 col-xs-1"></div>
                    <div class="col-md-5 col-xs-4">
                        <label>Balance con detalle de valores por mes</label>
                    </div>
                    <div class="col-md-1 col-xs-1">
                        <g:checkBox name="detalleMesInf"/>
                    </div>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnImprimirInf btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-md-12 col-xs-12" id="nuevaAlicuota" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Cálculo de la Nueva Alícuota</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6 col-xs-6">
                        <label>Valor base para recaudación mensual</label>
                    </div>
                    <div class="col-md-3 col-xs-3">
                        %{--<g:select from="${[2400]}" name="valorAli_name" id="valorAli" class="form-control"/>--}%
                        <g:textField name="valorAli_name" id="valorAli" class="form-control" maxlength="6"/>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnNuevasAlicuotas btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>


<div class="modal fade col-md-12 col-xs-12" id="ingresosEgresos2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalIngresoEgreso2">Ingresos y Egresos x mes</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker id="fechaDesdeIG" class="datepicker form-control" value="${inicioAnio}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-1 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker id="fechaHastaIG" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnIngresosEgresos2 btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-md-12 col-xs-12" id="ingresosEgresos3" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalIngresoEgreso3">Ingresos y Egresos x mes 2</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker id="fechaDesdeIG3" class="datepicker form-control" value="${inicioAnio}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-1 col-xs-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker id="fechaHastaIG3" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnIngresosEgresos3 btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>


<div class="modal fade col-md-12 col-xs-12" id="mantenimientoMejoras" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelMM">Mantenimiento y mejoras</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesdeMM_name" id="fechaDesdeMM" class="datepicker form-control" value="${new Date() - 30}"/>
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
                        <elm:datepicker name="fechaHastaMM_name" id="fechaHastaMM" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnMantenimientoMejoras btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-md-12 col-xs-12" id="pagosPendientes" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelDP">Pagos pendientes</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesde_DP_name" id="fechaDesde_DP" class="datepicker form-control" value="${new Date() - 30}"/>
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
                        <elm:datepicker name="fechaHasta_DP_name" id="fechaHasta_DP" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarDP btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-md-12 col-xs-12" id="cajaChica" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelCC">Caja Chica</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesde_CC_name" id="fechaDesde_CC" class="datepicker form-control" value="${new Date() - 30}"/>
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
                        <elm:datepicker name="fechaHasta_CC_name" id="fechaHasta_CC" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarCC btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>


<div class="modal fade col-md-12 col-xs-12" id="tipoEgreso" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelTG">Gastos clasificados por tipo de egreso</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesde_DP_name" id="fechaDesde_TG" class="datepicker form-control" value="${new Date() - 30}"/>
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
                        <elm:datepicker name="fechaHasta_DP_name" id="fechaHasta_TG" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnTipoEgreso btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>


<!-------------------------------------------- MODALES ----------------------------------------------------->

<script type="text/javascript">

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
        (ev.keyCode >= 96 && ev.keyCode <= 105) ||
//        ev.keyCode == 190 || ev.keyCode == 110 ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39 ||
        ev.keyCode == 173 || ev.keyCode == 109);
    }

    function validarNumPunto(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
        (ev.keyCode >= 96 && ev.keyCode <= 105) ||
        ev.keyCode == 190 || ev.keyCode == 110 ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39 ||
        ev.keyCode == 173 || ev.keyCode == 109);
    }

    $("#valorAli").keydown(function (ev) {
        return validarNum(ev)
    });

    $("#depos").keydown(function (ev) {
        return validarNumPunto(ev)
    });
    $(".btnNuevasAlicuotas").click(function () {
        var valor = $("#valorAli").val();
        if(valor == '' || valor == null || valor == 0){
            bootbox.alert("Ingrese un valor!")
        }else{
            openLoader("Cargando...");
            location.href="${createLink(controller: 'reportes', action: 'nuevaAlicuotaReporte')}?valor=" + valor
            closeLoader();
        }
    });

    $(".btnIngresosEgresos").click(function () {
        var anio = $("#anio").val();
        openLoader("Cargando...");
        location.href="${createLink(controller: 'reportes', action: 'ingresosImprimir')}?anio=" + anio
        closeLoader();
    });

    $(".btnIngresosEgresos2").click(function () {
        var desde = $("#fechaDesdeIG").val();
        var hasta = $("#fechaHastaIG").val();
        openLoader("Cargando...");
        location.href="${createLink(controller: 'reportes', action: 'ingresosEgresos')}?desde=" + desde + "&hasta=" + hasta
        closeLoader();
    });

    $(".btnIngresosEgresos3").click(function () {
        var desde = $("#fechaDesdeIG3").val();
        var hasta = $("#fechaHastaIG3").val();
        openLoader("Cargando...");
        location.href="${createLink(controller: 'reportes', action: 'ingresosEgresosNuevo')}?desde=" + desde + "&hasta=" + hasta
        closeLoader();
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
            var torre = $("#torreDeudas").val();
            openLoader("Cargando...");
            location.href = "${g.createLink(controller:'reportes', action: 'pagosPendientes4')}?fecha=" + fechaI + "&torre=" + torre
            closeLoader();
        });

        $(".btnDeudasTotales").click(function () {
            var fechaI = $("#fechaImprimeTot").val();
            var torre = $("#torre2").val();
            openLoader("Cargando...");
            location.href = "${g.createLink(controller:'reportes', action: 'pagosPendientesTotales')}?fecha=" + fechaI + "&torre=" + torre
            closeLoader();
        });

        $(".btnSolicitud").click(function () {
            var vlor = $("#valorHasta").val();
            openLoader("Cargando....");
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportes', action: 'tablaSolicitudPago_ajax')}',
                data:{
                    id: '${condominio?.id}',
                    valor: vlor,
                    tipo: 1
                },
                success: function(msg){
                    closeLoader();
                    bootbox.dialog({
                        title   : "Personas con solicitud de pago",
                        message : msg,
                        class   : "modal-lg",
                        buttons : {
                              cancelar      : {
                                label     : "Salir",
                                className : "btn-default",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
        });

        $(".btnMonitorio").click(function () {
            openLoader("Cargando...");
            var vlor = $("#valorHastaMn").val();
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportes', action: 'tablaSolicitudMonitorio_ajax')}',
                data:{
                    id: '${condominio?.id}',
                    valor: vlor
                },
                success: function(msg){
                    closeLoader();
                    bootbox.dialog({
                        title   : "Personas con solicitud de monitorio",
                        message : msg,
                        class   : "modal-lg",
                        buttons : {
                            cancelar      : {
                                label     : "Salir",
                                className : "btn-default",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
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

        $(".btnCondominos").click(function () {
            var torre = $("#torre").val();
            openLoader("Cargando...");
            location.href = "${g.createLink(controller: 'reportes', action: 'listaCondominos')}?torre=" + torre;
            closeLoader();
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
                            openLoader("Cargando...");
                            location.href = "${g.createLink(controller:'reportes' , action: 'imprimirEgresos')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                            closeLoader();
                        }else{
                            bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                            return false;
                        }
                    }
                });
            }
        });

        $(".btnAceptarEgresosExcel").click(function () {
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
                            openLoader("Cargando...");
                            location.href = "${g.createLink(controller:'reportes' , action: 'imprimirEgresosExcel')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                            closeLoader();
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
                            openLoader("Cargando...");
                            location.href = "${g.createLink(controller:'reportes' , action: 'imprimirIngresos')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                            closeLoader();
                        }else{
                            bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                            return false;
                        }
                    }
                });
            }
        });

        $(".btnAceptarIngresosExcel").click(function () {
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
                            openLoader("Cargando...");
                            location.href = "${g.createLink(controller:'reportes' , action: 'imprimirIngresosExcel')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                            closeLoader();
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
                            openLoader("Cargando...");
                            location.href = "${g.createLink(controller:'reportes' , action: 'reporteObras')}?desde=" + fechaDesde + "&hasta=" + fechaHasta
                            closeLoader();
                        }else{
                            bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                            return false;
                        }
                    }
                });
            }
        });
    });

    $(".btnMantenimientoMejoras").click(function () {
        var fechaDesde = $("#fechaDesdeMM").val();
        var fechaHasta = $("#fechaHastaMM").val();

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
                        openLoader("Cargando...");
                        location.href = "${g.createLink(controller:'reportes' , action: 'mantenimientoMejoras')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                        closeLoader();
                    }else{
                        bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                        return false;
                    }
                }
            });
        }
    });


    $(".btnImprimirEgProveedores").click(function () {
        var fechaDesde = $("#fechaDesdeProveedor").val();
        var fechaHasta = $("#fechaHastaProveedor").val();
        var valor = $("#valor").val();
        openLoader("Cargando...");
        location.href = "${g.createLink(controller:'reportes' , action: 'reporteEgresosProveedor')}?desde=" +
            fechaDesde + "&hasta=" + fechaHasta + "&valor=" + valor;
        closeLoader();
    });

    $(".btnImprimirBalance").click(function () {
        var fechaDesde = $("#fechaDesdeB").val();
        var fechaHasta = $("#fechaHastaB").val();
        var depositos = $("#depos").val()
        var dtmeses = $("#detalleMes").is(':checked');
        openLoader("Cargando...");
        location.href = "${g.createLink(controller:'reportes' , action: 'rpBalance')}?desde=" + fechaDesde +
            "&hasta=" + fechaHasta + "&depositos=" + depositos + "&dtmeses=" + dtmeses;
        closeLoader();
    });

    $(".btnImprimirInf").click(function () {
        var fechaDesde = $("#fechaDesdeInf").val();
        var fechaHasta = $("#fechaHastaInf").val();
        var depositos = $("#depositos").val()
        var dtmeses = $("#detalleMesInf").is(':checked');
        openLoader("Cargando...");
        location.href = "${g.createLink(controller:'reportes' , action: 'rpInforme')}?desde=" + fechaDesde +
            "&hasta=" + fechaHasta + "&depositos=" + depositos + "&dtmeses=" + dtmeses;
        closeLoader();
    });


    $(".btnAceptarDP").click(function () {
        var fechaDesde = $("#fechaDesde_DP").val();
        var fechaHasta = $("#fechaHasta_DP").val();

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
                        openLoader("Cargando...");
                        location.href = "${g.createLink(controller:'reportes' , action: 'imprimirPagosPendientes')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                        closeLoader();
                    }else{
                        bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                        return false;
                    }
                }
            });
        }
    });

    $(".btnAceptarCC").click(function () {
        var fechaDesde = $("#fechaDesde_CC").val();
        var fechaHasta = $("#fechaHasta_CC").val();

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
                        openLoader("Cargando...");
                        location.href = "${g.createLink(controller:'reportes2' , action: 'imprimirCajaChica')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                        closeLoader();
                    }else{
                        bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                        return false;
                    }
                }
            });
        }
    });

    $(".btnTipoEgreso").click(function () {
        var fechaDesde = $("#fechaDesde_TG").val();
        var fechaHasta = $("#fechaHasta_TG").val();

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
                        openLoader("Cargando...");
                        location.href = "${g.createLink(controller:'reportes' , action: 'egresosPorTipo')}?desde=" + fechaDesde + "&hasta=" + fechaHasta;
                        closeLoader();
                    }else{
                        bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                        return false;
                    }
                }
            });
        }
    });

</script>

</body>
</html>