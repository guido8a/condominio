<html>
<head>
    <meta name="layout" content="movil">
    %{--<meta name="layout" content="main"/>--}%
    <title>Reportes</title>

    <style type="text/css">

    .descripcion h4 {
        color      : cadetblue;
        text-align : center;
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


    </style>

</head>

<body>


<div class="row">
    <div class="col-md-12 col-xs-12">
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#detallePagos">
                <i class="fa fa-list-ul fa-5x col-md-6"></i>
                <div class="col-md-6" style="margin-top: 20px">Detalle de mis<br/>pagos realizados</div>
            </a>
    </div>
</div>

<div class="row">
    <div class="col-md-12 col-xs-12">
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#detallePagos">
                <i class="fa fa-book fa-5x col-md-6"></i>
                <div class="col-md-6" style="margin-top: 20px">Biblioteca del<br/>Condominio</div>
            </a>
    </div>
</div>

<div class="row">
    <div class="col-md-12 col-xs-12">
        %{--<div class="col-md-4 col-xs-4">--}%
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#balance">
                <i class="fa fa-money fa-5x"></i><br/>
                Balance de<br/>Resultados
            </a>
        %{--</div>--}%
            %{--<div class="col-md-4 col-xs-4">--}%
            <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#detalleIngresos"
               title="Detalle de ingresos">
                <i class="fa fa-sign-in fa-5x"></i><br/>
                Detalle<br/>Ingresos
            </a>
            %{--</div>--}%
                %{--<div class="col-md-4 col-xs-4">--}%
        <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#detalleEgresos">
            <i class="fa fa-sign-out fa-5x"></i><br/>
            Detalle<br/>Egresos
        </a>
                %{--</div>--}%

    </div>
</div>

<div class="row">
    <div class="col-md-12 col-xs-12">
        <a href="#" class="link btn btn-success btn-ajax" data-toggle="modal" data-target="#mantenimientoMejoras"
           title="Mantenimiento y mejoras">
            <i class="fa fa-wrench fa-5x"></i><br/>
            Gastos por Mantenimiento<br/>y mejoras
        </a>
        <a href="#" class="link btn btn-success btn-ajax" data-toggle="modal" data-target="#listaObras">
            <i class="fa fa-home fa-5x"></i><br/>
            Detalle<br/>de Obras
        </a>
    </div>
</div>

<div class="row">
    <div class="col-md-12 col-xs-12">
    %{--<div class="col-md-6 col-xs-6">--}%
        <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#modalCondominos">
            <i class="fa fa-building-o fa-5x"></i><br/>
            Listado<br/>de Condóminos
        </a>
    %{--</div>--}%
    %{--<div class="col-md-6 col-xs-6">--}%
        <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#modalDeudas"
           title="Estado de cuenta de los condóminos">
            <i class="fa fa-file-text-o fa-5x"></i><br/>
            Deudas o pagos<br/> Pendientes
        </a>
    %{--</div>--}%

    </div>
</div>


<!-------------------------------------------- MODALES ----------------------------------------------------->

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

%{--//dialog de detalle--}%
<div class="modal fade col-md-12 col-xs-12" id="detallePagos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">Detalle de Pagos realizados</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1 col-xs-1">
                    </div>
                    <div class="col-md-2 col-xs-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4 col-xs-7">
                        <elm:datepicker name="fechaDesdeIng_name" id="fechaDesdeDet" class="datepicker form-control" value="${new Date() - 30}"/>
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
                        <elm:datepicker name="fechaHastaIng_name" id="fechaHastaDet" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1 col-xs-1">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnDetallePagos btn-success" data-dismiss="modal"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>


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

%{--dialog situación--}%
<div class="modal fade col-md-12 col-xs-5" id="solicitud" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
                        <div class="col-md-7 col-xs-6">
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



<!-------------------------------------------- MODALES ----------------------------------------------------->

<script type="text/javascript">

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

    $(".btnDeudas").click(function () {
        var fechaI = $("#fechaImprime").val();
        var torre = $("#torreDeudas").val();
        openLoader("Cargando...");
        location.href = "${g.createLink(controller:'reportes', action: 'pagosPendientes4')}?fecha=" + fechaI + "&torre=" + torre;
        closeLoader();
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


    $(".btnIngresosEgresos").click(function () {
        var anio = $("#anio").val();
        location.href="${createLink(controller: 'reportes', action: 'ingresosImprimir')}?anio=" + anio
    });

    $("#btnAceptarGestor").click(function () {
       location.href="${createLink(controller: 'reportes', action: 'detalle')}"
    });


    $(function () {

        /* ******************************** DIALOGS ********************************************* */

        $(".btnDetallePagos").click(function () {
            var hasta = $("#fechaHastaDet").val();
            var desde = $("#fechaDesdeDet").val();
            var id = "${session?.usuario?.id}"
            console.log('detalle pagos')
            location.href='${createLink(controller: 'reportes', action: 'reporteDetallePagos')}?id=' + id +
                "&desde=" + desde + "&hasta=" + hasta ;
        });

        $(".btnSolicitud").click(function () {
            var vlor = $("#valorHasta").val();
//            console.log('vlor', vlor)
            location.href = "${g.createLink(controller: 'reportes', action: 'imprimirSolicitudes')}?vlor=" + vlor;
        });

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



    });
</script>

</body>
</html>