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
    <div class="col-lg-12">
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
            <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#libroMayor">
                <i class="fa fa-home fa-5x"></i><br/>
                Detalle de Obras
            </a>
        </p>
    </div>
</div>

<div class="row">
    <div class="col-lg-12">
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

            %{--
                        <a href="#" class="link btn btn-primary btn-ajax" data-toggle="modal" data-target="#modalDeudas"
                           title="Estado de cuenta de los condóminos">
                            <i class="fa fa-file-text-o fa-5x"></i><br/>
                            Deudas
                        </a>
                        <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#solicitud">
                            <i class="fa fa-money fa-5x"></i><br/>
                            Solicitudes de pago
                        </a>
                        <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#planCuentas" title="Plan de cuentas o catálogo de cuentas de la contabilidad">
                            <i class="fa fa-sign-in fa-5x"></i><br/>
                            Detalle Ingresos
                        </a>
                        <a href="#" class="link btn btn-success btn-ajax" data-toggle="modal" data-target="#libroDiario">
                            <i class="fa fa-sign-out fa-5x"></i><br/>
                            Detalle egresos
                        </a>
                        <a href="#" class="link btn btn-info btn-ajax" data-toggle="modal" data-target="#libroMayor">
                            <i class="fa fa-home fa-5x"></i><br/>
                            Detalle de Obras
                        </a>
            --}%
        </p>
    </div>
</div>

<!-------------------------------------------- MODALES ----------------------------------------------------->
%{--//dialog de contabilidad--}%
<div class="modal fade" id="detalleIngresos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">Ingresos</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1">
                    </div>
                    <div class="col-md-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaDesdeIng_name" id="fechaDesdeIng" class="datepicker form-control" value="${new Date() - 30}"/>
                    </div>
                    <div class="col-md-1">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1">
                    </div>
                    <div class="col-md-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaHastaIng_name" id="fechaHastaIng" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1">
                    </div>

                </div>
            </div>


            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarIngresos btn-success"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>



<div class="modal fade" id="detalleEgresos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabelEgr">Egresos</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1">
                    </div>
                    <div class="col-md-2">
                        <label>Desde</label>
                    </div>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaDesdeEgr_name" id="fechaDesdeEgr" class="datepicker form-control" value="${new Date() - 30}"/>
                    </div>
                    <div class="col-md-1">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1">
                    </div>
                    <div class="col-md-2">
                        <label>Hasta</label>
                    </div>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaHastaEgr_name" id="fechaHastaEgr" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1">
                    </div>

                </div>
            </div>


            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnAceptarEgresos btn-success"><i class="fa fa-print"></i> Aceptar
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

                    %{--
                                        <g:select name="contComp" id="contComp"
                                                  from="${cratos.Contabilidad.findAllByInstitucion(session.empresa, [sort: 'fechaInicio'])}"
                                                  optionKey="id" optionValue="descripcion"
                                                  class="form-control dos"/>
                    --}%
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
                    %{--
                                        <g:select name="contP11" id="contP11"
                                                  from="${cratos.Contabilidad.findAllByInstitucion(session.empresa, [sort: 'fechaInicio'])}"
                                                  optionKey="id" optionValue="descripcion" noSelection="['-1': 'Seleccione la contabilidad']"
                                                  class="form-control dos"/>
                    --}%
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
<div class="modal fade" id="modalDeudas" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Valores por cobrar</h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-1">
                    </div>
                    <div class="col-md-6">
                        <label>Fecha de corte de los valores adeudados:</label>
                    </div>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaGenera_name" id="fechaImprime" class="datepicker form-control" value="${new Date()}"/>
                    </div>
                    <div class="col-md-1">
                    </div>

                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnDeudas btn-success"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>

%{--dialog situación--}%
<div class="modal fade" id="solicitud" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalsolicitud">Generar cartas solicitando pagos</h4>
            </div>

            <div class="modal-body" id="bodysolicitud">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1">
                        </div>
                        <div class="col-md-3">
                            <label>Generar para deudas con </label>
                        </div>
                        <div class="col-md-7">
                            <g:select from="${['1':'Valores superiores a 1 alícuota',
                                               '2':'Valores superiores a 2 alícuotas',
                                               '3':'Valores superiores a 3 alícuotas']}"
                                      optionValue="value" optionKey="key" name="mesesHasta_name"
                                      id="valorHasta" class="form-control"/>
                        </div>
                        <div class="col-md-1">
                        </div>

                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Cancelar
                </button>
                <button type="button" class="btn btnSolicitud btn-success"><i class="fa fa-print"></i> Aceptar
                </button>
            </div>
        </div>
    </div>
</div>



<!-------------------------------------------- MODALES ----------------------------------------------------->

<script type="text/javascript">

    $(".btnCostoVentas").click(function () {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'reportes2', action: 'modalCostoVentas_ajax')}',
            data:{

            },
            success: function (msg){
                var b = bootbox.dialog({
                    id      : "dlgKardex3",
                    title   : "Existencias",
                    class: "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
    });


    $(".btnKardex4").click(function () {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'reportes3', action: 'modalKardex4_ajax')}',
            data:{

            },
            success: function (msg){
                var b = bootbox.dialog({
                    id      : "dlgKardex4",
                    title   : "Existencias x Item",
                    class: "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
    });

    $(".btnKardex3").click(function () {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'reportes2', action: 'modalKardex3_ajax')}',
            data:{

            },
            success: function (msg){
                var b = bootbox.dialog({
                    id      : "dlgKardex3",
                    title   : "Existencias",
                    class: "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
    });

    $(".btnKardex2").click(function () {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'reportes2', action: 'modalKardex2_ajax')}',
            data:{

            },
            success: function (msg){
                var b = bootbox.dialog({
                    id      : "dlgKardex2",
                    title   : "Kardex x Item",
                    class: "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
    });

    $("#cntaLibro").dblclick(function () {
        buscarCuentas();
    });

    $("#buscarCuenta").click(function () {
        buscarCuentas();
    });

    function buscarCuentas () {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'cuenta', action: 'buscadorCuentas_ajax')}',
            data:{

            },
            success: function (msg){
                bootbox.dialog({
                    title: 'Buscar cuenta',
                    message: msg,
                    class: 'long',
                    buttons:{
                        cancelar: {
                            label: "<i class='fa fa-times'></i> Cancelar",
                            className: "btn-primary",
                            callback: function () {
//                                bootbox.hideAll();
                            }
                        }
                    }
                })
            }
        });
    }


    cargarSelComprobante($("#compTipo option:selected").val());

    $("#compTipo").change(function () {
        var tipo = $("#compTipo option:selected").val();
        cargarSelComprobante(tipo)
    });

    function cargarSelComprobante (sel) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'prefijo_ajax')}',
            data:{
                tipo: sel
            },
            success: function (msg){
                $("#divNumComp").html(msg)
            }
        });
    }


    function prepare() {
        $(".fa-ul li span").each(function () {
            var id = $(this).parents(".tab-pane").attr("id");
            var thisId = $(this).attr("id");
            $(this).siblings(".descripcion").addClass(thisId).addClass("ui-corner-all").appendTo($(".right." + id));
        });
    }

    var actionUrl = "";

    function updateCuenta() {
        var per = $("#periodo2").val();
        ////console.log(per);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'reportes2', action:'updateCuenta')}",
            data    : {
                per : per
            },
            success : function (msg) {
                $("#divCuenta").html(msg);
            }
        });
    }

    function updatePeriodo(cual) {
        var cont = $("#contP" + cual).val();

//                console.log("cont" + cont);

        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'updatePeriodo')}",
            data    : {
                cont : cont,
                cual : cual
            },
            success : function (msg) {
                $("#divPeriodo" + cual).html(msg);
            }
        });
    }

    function updatePeriodoSinTodo(cual) {
        var cont = $("#contP" + cual).val();
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'updatePeriodoSinTodo')}",
            data    : {
                cont : cont,
                cual : cual
            },
            success : function (msg) {
                $("#divPeriodo" + cual).html(msg);
            }
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

        $(".btnAceptarPlan").click(function () {
            var cont = $("#contCuentas").val()
            url = "${g.createLink(controller:'reportes' , action: 'planDeCuentas')}?cont=" + cont + "Wempresa=${session.empresa?.id}";
            location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=planDeCuentas.pdf"

        });

        $("#btnAceptarGestor").click(function () {
            openLoader("Imprimiendo...")
            var cont = $("#contContable").val()
            url = "${g.createLink(controller:'reportes' , action: 'detalle')}";
            location.href = url
            closeLoader()
        });

        $(".btnAceptarComprobante").click(function () {
            var cont = $("#contComp").val();
            var tipo = $("#compTipo").val();
            var url
            console.log("tipo " + tipo)
            var num = $("#compNum").val();
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'reportes3', action: 'reporteComprobante')}",
                data    : {
                    cont : cont,
                    tipo : tipo,
                    num  : num
                },
                success : function (msg) {
                    var parts = msg.split("_");
                    if (parts[0] != "NO") {
                        switch (tipo) {
                            case '1':
                                url = "${g.createLink(controller: 'reportes3', action: 'imprimirCompDiario')}?id=" + msg + "Wempresa=${session.empresa?.id}";
                                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=comprobanteIngreso.pdf";
                                break;
                            case '2':
                                url = "${g.createLink(controller: 'reportes3', action: 'imprimirCompDiario')}?id=" + msg + "Wempresa=${session.empresa?.id}";
                                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=comprobanteEgreso.pdf";
                                break;
                            case '3':
                                url = "${g.createLink(controller: 'reportes3', action: 'imprimirCompDiario')}?id=" + msg + "Wempresa=${session.empresa?.id}";
                                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=comprobanteDiario.pdf";
                                break;
                        }
                    } else {
                        bootbox.alert(parts[1])
                    }
                }
            });
        });


        %{--$("#excelPrueba").click(function () {--}%
        %{--location.href = "${g.createLink(controller: 'reportes3', action: 'reporteExcel')}"--}%
        %{--});--}%


        $(".btnAceptarBalance").click(function () {
            var cont = $("#contP").val();
            var per = $("#periodo").val();
            if (cont == '-1') {
                bootbox.alert("Debe elegir una contabilidad!")
            } else {
                url = "${g.createLink(controller:'reportes2' , action: 'balanceComprobacion')}?cont=" + cont + "Wemp=${session.empresa?.id}" + "Wperiodo=" + per;
                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=balanceComprobacion.pdf"

            }
        });

        $(".btnAceptarSituacion").click(function () {
            var cont = $("#contP8").val();
            var per = $("#periodo8").val();

            if (cont == '-1') {
                bootbox.alert("Debe elegir una contabilidad!")
            } else {
                url = "${g.createLink(controller:'reportes2' , action: 'situacionFinanciera')}?cont=" + cont + "Wempresa=${session.empresa?.id}" + "Wper=" + per;
                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=situacionFinanciera.pdf"
            }
        });

        $(".btnAceptarIntegral").click(function () {
            var cont = $("#contP9").val();
            var per = $("#periodo9").val();

            if (cont == '-1') {
                bootbox.alert("Debe elegir una contabilidad!")
            } else {
                url = "${g.createLink(controller:'reportes2' , action: 'estadoDeResultados')}?cont=" + cont + "Wempresa=${session.empresa?.id}" + "Wper=" + per;
                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=resultadoIntegral.pdf"
            }
        });

        $(".btnAceptarAuxiliar").click(function () {
            var cont = $("#contP3").val();
            var per = $("#periodo3").val();
            var cnta = $("#idCntaLibro").val();
            var fechaDesde = $(".fechaDe").val();
            var fechaHasta = $(".fechaHa").val();

            if (cont == '-1') {
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione una contabilidad!")
            } else {
                if(cnta == ''){
                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione una cuenta!")
                }else{
                    if(fechaDesde == '' || fechaHasta == ''){
                        bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
                    }else{
                        $.ajax({
                            type: 'POST',
                            url: '${createLink(controller: 'proceso', action: 'revisarFecha_ajax')}',
                            data:{
                                desde: fechaDesde,
                                hasta: fechaHasta
                            },
                            success: function (msg){
                                if(msg == 'ok'){
                                    %{--url = "${g.createLink(controller:'reportes2' , action: 'libroMayor')}?cont=" + cont + "Wemp=${session.empresa?.id}" + "Wper=" + per + "Wcnta=" + cnta + "Wdesde=" + fechaDesde + "Whasta=" + fechaHasta;--}%
                                    url = "${g.createLink(controller:'reportes2' , action: 'libroMayor')}?cont=" + cont + "Wemp=${session.empresa?.id}" + "Wcnta=" + cnta + "Wdesde=" + fechaDesde + "Whasta=" + fechaHasta;
                                    location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=libroMayor.pdf"
                                }else{
                                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                                    return false;
                                }
                            }
                        });

                    }
                }

            }
        });

        $(".btnAceptarRetenciones").click(function () {
            var cont = $("#contR").val();
            var fechaDesde = $(".fechaDeR").val();
            var fechaHasta = $(".fechaHaR").val();

            if (cont == '-1') {
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione una contabilidad!")
            } else {
                if(fechaDesde == '' || fechaHasta == ''){
                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
                }else{
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'proceso', action: 'revisarFecha_ajax')}',
                        data:{
                            desde: fechaDesde,
                            hasta: fechaHasta
                        },
                        success: function (msg){
                            if(msg == 'ok'){
                                url = "${g.createLink(controller:'reportes2' , action: 'retenciones')}?cont=" + cont + "Wemp=${session.empresa?.id}" + "Wdesde=" + fechaDesde + "Whasta=" + fechaHasta;
                                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=retenciones.pdf"
                            }else{
                                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                                return false;
                            }
                        }
                    });

                }
            }
        });

        $(".btnAceptarKardex").click(function () {
            var cont = $("#contK").val();
            var fechaDesde = $(".fechaDeK").val();
            var fechaHasta = $(".fechaHaK").val();
            var bodega = $("#bode").val();

            if (cont == '-1') {
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione una contabilidad!")
            } else {
                if(bode == '-1'){
                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione una bodega!")
                }else{
                    if(fechaDesde == '' || fechaHasta == ''){
                        bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
                    }else{
                        $.ajax({
                            type: 'POST',
                            url: '${createLink(controller: 'proceso', action: 'revisarFecha_ajax')}',
                            data:{
                                desde: fechaDesde,
                                hasta: fechaHasta
                            },
                            success: function (msg){
                                if(msg == 'ok'){
                                    url = "${g.createLink(controller:'reportes2' , action: 'kardexGeneral')}?cont=" + cont + "Wemp=${session.empresa?.id}" + "Wdesde=" + fechaDesde + "Whasta=" + fechaHasta + "Wbodega=" + bodega;
                                    location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=kardex.pdf"
                                }else{
                                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                                    return false;
                                }
                            }
                        });

                    }
                }
            }
        });

        $(".btnAceptarRetCod").click(function () {
            var cont = $("#contRC").val();
            var fechaDesde = $(".fechaDeRC").val();
            var fechaHasta = $(".fechaHaRC").val();

            if (cont == '-1') {
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione una contabilidad!")
            } else {
                if(fechaDesde == '' || fechaHasta == ''){
                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
                }else{
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'proceso', action: 'revisarFecha_ajax')}',
                        data:{
                            desde: fechaDesde,
                            hasta: fechaHasta
                        },
                        success: function (msg){
                            if(msg == 'ok'){
                                url = "${g.createLink(controller:'reportes2' , action: 'retencionesCodigo')}?cont=" + cont + "Wemp=${session.empresa?.id}" + "Wdesde=" + fechaDesde + "Whasta=" + fechaHasta;
                                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=retencionesCodigo.pdf"
                            }else{
                                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                                return false;
                            }
                        }
                    });

                }
            }
        });


        $(".btnAceptarCompras").click(function () {
            var cont = $("#contC").val();
            var fechaDesde = $(".fechaDeC").val();
            var fechaHasta = $(".fechaHaC").val();
            var tipo = $("#tipo").val();

            if (cont == '-1') {
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione una contabilidad!")
            } else {
                if(fechaDesde == '' || fechaHasta == ''){
                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
                }else{
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'proceso', action: 'revisarFecha_ajax')}',
                        data:{
                            desde: fechaDesde,
                            hasta: fechaHasta
                        },
                        success: function (msg){
                            if(msg == 'ok'){
                                url = "${g.createLink(controller:'reportes2' , action: 'compras')}?cont=" + cont + "Wemp=${session.empresa?.id}" + "Wdesde=" + fechaDesde + "Whasta=" + fechaHasta + "Wtipo=" + tipo;
                                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=compras.pdf"
                            }else{
                                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                                return false;
                            }
                        }
                    });

                }
            }
        });

        $(".btnAceptarVentas").click(function () {
            var cont = $("#contV").val();
            var fechaDesde = $(".fechaDeV").val();
            var fechaHasta = $(".fechaHaV").val();

            if (cont == '-1') {
                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione una contabilidad!")
            } else {
                if(fechaDesde == '' || fechaHasta == ''){
                    bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
                }else{
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'proceso', action: 'revisarFecha_ajax')}',
                        data:{
                            desde: fechaDesde,
                            hasta: fechaHasta
                        },
                        success: function (msg){
                            if(msg == 'ok'){
                                url = "${g.createLink(controller:'reportes2' , action: 'ventas')}?cont=" + cont + "Wemp=${session.empresa?.id}" + "Wdesde=" + fechaDesde + "Whasta=" + fechaHasta;
                                location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=compras.pdf"
                            }else{
                                bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                                return false;
                            }
                        }
                    });

                }
            }
        });





        $("#btnTodosPrv").button().click(function () {
            $("#hidVal").val("-1");
            $("#txtValor").val("Todos");
            return false;
        });

        $(".btnAceptarLibro").click(function () {
            var cont = $("#contP11").val();
            var per = $("#periodo11").val();
            var url = "${g.createLink(controller: 'reportes3', action: 'imprimirLibroDiario')}?cont=" + cont + "Wperiodo=" + per + "Wempresa=${session.empresa?.id}";
            location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=libroDiario.pdf";
        });

        $(".btnDeudas").click(function () {
//            var cont = $("#contP20").val();
//            var prms = $("#periodo20").val();
            var fechaI = $("#fechaImprime").val();
//            console.log('fecha', fechaI)
            location.href = "${g.createLink(controller:'reportes', action: 'pagosPendientes3')}?fecha=" + fechaI
        });

        $(".btnSolicitud").click(function () {
            var vlor = $("#valorHasta").val();
//            console.log('vlor', vlor)
            location.href = "${g.createLink(controller: 'reportes', action: 'imprimirSolicitudes')}?vlor=" + vlor;
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

    });
</script>

</body>
</html>