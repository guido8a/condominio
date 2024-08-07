<%@ page contentType="text/html;charset=UTF-8" %>

<%
    def buscadorServ = grailsApplication.classLoader.loadClass('utilitarios.BuscadorService').newInstance()
%>

<html>
<head>
    <meta name="layout" content="main">
    <title>Propietarios del Condominio</title>

    <style type="text/css">

    .alinear {
        text-align: center !important;
    }
    </style>

</head>

<body>

<div style="text-align: center; margin-top: -30px;margin-bottom:20px">
    <h3>Condóminos y Departamentos</h3>
</div>

<elm:flashMessage tipo="${flash.tipo}" icon="${flash.icon}"
                  clase="${flash.clase}">${flash.message}</elm:flashMessage>

<div style="margin-top: -15px;" class="vertical-container">
    <p class="css-icono" style="margin-bottom: -15px"><i class="fa fa-folder-open-o"></i></p>

    <div class="linea45"></div>



    <div class="row" style="margin-bottom: 10px;">

        <div class="row-fluid">
            <div style="margin-left: 20px;">
                <div class="col-xs-8 col-md-8">
                    <div class="col-xs-3 col-md-2">
                        <b>Buscar por: </b>
                        <elm:select name="buscador" from = "${buscadorServ.parmProcesos()}" value="${params.buscador}"
                                    optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con"
                                    style="width: 110px" class="form-control"/>
                    </div>
                    <div class="col-xs-3 col-md-2">
                        <strong style="margin-left: 20px;">Operación:</strong>
                        <span id="selOpt"></span>
                    </div>
                    <div class="col-xs-2 col-md-3">
                        <b style="margin-left: 20px">Criterio: </b>
                        <g:textField name="criterio" style="margin-left: 10px; width: 100%; border-color: #53a7ff"
                                     value="${params.criterio}" id="criterio_con" class="form-control"/>
                    </div>
                    <div class="col-xs-3 col-md-3">
                        <b>Ordenado por: </b>
                        <elm:select name="buscador" from = "${buscadorServ.parmProcesos()}" value="${params.ordenar}"
                                    optionKey="campo" optionValue="nombre" optionClass="operador" id="ordenar_por"
                                    style="width: 160px" class="form-control"/>
                    </div>

                    <g:if test="${session.perfil.codigo == 'ADM'}">
                        <div class="col-xs-6 col-md-6">
                            <b>Condominio: </b>
                            <g:select from="${condominio.Condominio.list()}" name="condominio_name" class="form-control" id="condominioId" optionKey="id" optionValue="nombre"/>
                        </div>
                    </g:if>
                </div>

                <div class="col-xs-3 col-md-4">
                    <div class="btn-group col-xs-1" style="margin-left: -40px; margin-top: 0px;">
                        <b>Torre:</b>
                        <elm:select name="torres" from = "${torres}"
                                    optionKey="descripcion" optionValue="descripcion" value="${actual}"
                                    style="width: 100px" class="form-control"/>
                    </div>


                    <div class="btn-group col-xs-6 col-md-4" style="margin-left: 70px; margin-top: 20px;">

                        <a href="#" name="busqueda" class="btn btn-info" id="btnBusqueda" title="Buscar"
                           style="height: 34px; padding: 9px; width: 46px">
                            <i class="fa fa-search"></i></a>

                        <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                           title="Borrar criterios" style="height: 34px; padding: 9px; width: 34px">
                            <i class="fa fa-eraser"></i></a>
                    </div>
                    %{--<div class="btn-group col-xs-3 col-md-3" style="margin-left: -10px; margin-top: 20px;">--}%
                    %{--<a href="#" name="busqueda" class="btn btn-success" id="nuevo" title="Crear Persona"--}%
                    %{--style="height: 34px; padding: 9px; width: 46px">--}%
                    %{--<i class="fa fa-user-circle"></i></a>--}%
                    %{--</div>--}%
                    <div class="btn-group col-xs-1" style="margin-left: -10px; margin-top: 20px;">
                        <a href="#" name="busqueda" class="btn btn-success" id="nuevo" title="Crear Persona"
                           style="height: 34px; padding: 9px; width: 46px">
                            <i class="fa fa-user-circle"></i></a>

                    </div>
                    <div class="btn-group col-xs-1" style="margin-left: 20px; margin-top: 20px;">
                        <g:link action="creaIngresos" class="btn btn-info" title="Registro de aportes" style="height: 34px; padding: 9px; width: 46px">
                            <i class="fa fa-money"></i>
                        </g:link>
                    </div>
%{--
                    <div class="btn-group col-xs-1" style="margin-left: 20px; margin-top: 20px;">
                        <g:link action="admnAnterior" class="btn btn-warning" title="Actualizar pagos a la Administración Anterior"
                                style="height: 34px; padding: 9px; width: 46px">
                            <i class="fa fa-money"></i>
                        </g:link>
                    </div>
--}%
                    %{--<div class="btn-group col-xs-3 col-md-3" style="margin-left: -10px; margin-top: 20px;">--}%
                    %{--<g:link controller="reportes" action="imprimirSolicitudes" class="btn btn-warning" title="Imprimir solicitudes de pago" style="height: 34px; padding: 9px; width: 46px">--}%
                    %{--<i class="fa fa-print"></i>--}%
                    %{--</g:link>--}%
                    %{--</div>--}%

                </div>

            </div>

        </div>
    </div>
</div>

<div style="margin-top: 30px; min-height: 650px" class="vertical-container">
    <p class="css-vertical-text">Personas del Condominio</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 1070px">
        <thead>
        <tr>
            <th class="alinear" style="width: 6%">Edificio</th>
            <th class="alinear" style="width: 6%">Dept.</th>
            <th class="alinear" style="width: 15%">Nombre</th>
            <th class="alinear" style="width: 15%">Apellido</th>
            <th class="alinear" style="width: 4%">P/A</th>
            <th class="alinear" style="width: 10%">Teléfono</th>
            <th class="alinear" style="width: 26%">Correo electrónico</th>
            <th class="alinear" style="width: 9%">Alícuota</th>
            <th class="alinear" style="width: 9%">Deuda</th>
            %{--<th class="alinear" style="width: 10%">Cargo</th>--}%
        </tr>
        </thead>
    </table>


    <div class="alert alert-danger hidden" id="mensaje" style="text-align: center">
    </div>

    <div id="detalle">
    </div>
</div>

<div><strong>Nota</strong>: Si existen muchos registros que coinciden con el criterio de búsqueda, se retorna
como máximo 30
</div>

<div class="modal fade " id="dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                Problema y Solución..
            </div>

            <div class="modal-body" id="dialog-body" style="padding: 15px">

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>




%{--Dialogo solicitudes--}%
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



<script type="text/javascript">

    $(function () {
        $("#limpiaBuscar").click(function () {
            $("#buscar").val('');
        });
    });

    <g:if test="${condominio}">
    cargarBusqueda();
    </g:if>
    <g:else>
    $("#mensaje").removeClass('hidden').append("No existen registros de propietarios");
    </g:else>


    $("#condominioId").change(function () {
        cargarBusqueda();
    });


    function cargarBusqueda () {
        var vvnd = parseInt(${condominio?.viviendas});
        var condo = $("#condominioId option:selected").val()
//        console.log("cont", vvnd);
        if(vvnd > 0) {
            $("#detalle").html("").append($("<div style='width:100%; text-align: center;'/>").append(spinnerSquare64));
            var desde = $(".fechaD").val();
            var hasta = $(".fechaH").val();
            $.ajax({
                type: "POST",
                url: "${g.createLink(controller: 'vivienda', action: 'tablaBuscar')}",
                data: {
                    buscador: $("#buscador_con").val(),
                    ordenar:  $("#ordenar_por").val(),
                    criterio: $("#criterio_con").val(),
                    operador: $("#oprd").val(),
                    condo: condo,
                    edif: $("#torres").val()
                },
                success: function (msg) {
                    $("#detalle").html(msg);
                },
                error: function (msg) {
                    $("#detalle").html("Ha ocurrido un error");
                }
            });
        }
    }

    $("#btnBusqueda").click(function () {
        cargarBusqueda();
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            $("#btnBusqueda").click();
        }
    });

    function createContextMenu(node) {
        var $tr = $(node);
        var items = {
            header: {
                label: "Acciones",
                header: true
            }
        };

        var id = $tr.data("id");
        var deuda = $tr.data("deuda");
        var ingr = $tr.data("ingr");
        var codigo = $tr.data("p");

        var perfil = {
            label: " Asignar Perfil",
            icon: "fa fa-user-o",
            action : function ($element) {
                var id = $element.data("id");
                asignarPerfil(id);
            }
        };

        var editar = {
            label: " Editar Persona",
            icon: "fa fa-id-card-o",
            %{--action: function () {--}%
            %{--location.href = '${createLink(controller: "proceso", action: "nuevoProceso")}?id=' + id;--}%
            %{--}--}%
            action : function ($element) {
                var id = $element.data("id");
                createEditRow(id);
            }
        };

        var alicuota = {
            label: "Alícuota",
            icon: "fa fa-money",
            action : function ($element) {
                var id = $element.data("id");
//                alicuotaEdit(id);
                tablaAlicuotas(id)
            }
        };

        var ingresos = {
            label: "Registro de Pagos",
            icon: "fa fa-money",
//            separator_before : true,
            action : function ($element) {
                var id = $element.data("id");
                pagoAlicuota(id);
            }
        };

        var certificado = {
            label: "Certificado Expensas",
            icon: "fa fa-print",
//            separator_before : true,
            action : function ($element) {
                var id = $element.data("id");
//                imprimirExpensas(id);
                location.href='${createLink(controller: 'reportes', action: 'expensas')}?id=' + id;
            }
        };

        var propiedades = {
            label: "Propiedades",
            icon: "fa fa-home",
            separator_before : true,
            action : function ($element) {
                var id = $element.data("id");
//                imprimirExpensas(id);
                location.href='${createLink(controller: 'propiedad', action: 'list')}?id=' + id;
            }
        };

        var detalle = {
            label: "Detalle Pagos",
            icon: "fa fa-print",
            separator_before : true,
            action : function ($element) {
                var id = $element.data("id");
                cargarFechas(id);
            }
        };

        var detalleSldo = {
            label: "Detalle de Deudas",
            icon: "fa fa-print",
            action : function ($element) {
                var id = $element.data("id");
                cargarFechasSaldo(id);
            }
        };

        var detalleValores = {
            label: "Valores pagados",
            icon: "fa fa-print",
            action : function ($element) {
                var id = $element.data("id");
                cargarDesde(id);
            }
        };

        var solicitudPago = {
            label: "Solicitud de Pago",
            icon: "fa fa-print",
            separator_before : true,
            action : function ($element) {
                var id = $element.data("id");
                seleccionarAlicuotas(id);
            }
        };

        var solicitudMonitorio = {
            label: "Solicitud de Monitorio",
            icon: "fa fa-print",
            separator_before : true,
            action : function ($element) {
                var id = $element.data("id");
//                cargarFechas(id);
            }
        };

//        items.editar = editar;
//        items.perfil = perfil;
//        items.alicuota = alicuota;
//        items.propiedad = propiedades;

        var administrar = {
            label: "Administrar",
            icon: "fa fa-pencil",
            separator_before : true,
            submenu: {
                editar,
                perfil,
                alicuota,
                propiedades
            }
        };

//        items.solicitudes = {
//            label: "Solicitudes",
//            icon: "fa fa-clipboard",
//            separator_before : true,
//            submenu: {
//                solicitudPago,
//                solicitudMonitorio
//            }
//        };

        console.log('perfil', '${session.perfil.codigo}');

        if('${session.perfil.codigo}' === 'ADC'){
//            if(ingr>0){
//                items.pagar = ingresos;
//            }
            items.pagar = ingresos;
            items.administrar = administrar;
            items.detalle = detalle;
            items.detalleSldo = detalleSldo;
            items.detalleValores = detalleValores;
            if(deuda <= 0 && codigo === 'P'){
                items.certificado = certificado;
            }
        } else {
            items.detalle = detalle;
            items.detalleSldo = detalleSldo;
            items.detalleValores = detalleValores;
        }

        return items
    }

    $("#btnLimpiarBusqueda").click(function () {
        $(".fechaD, .fechaH, #criterio_con").val('');
    });

    $("#nuevo").click(function () {
        createEditRow(null);
    });

    $("#buscador_con").change(function(){
        var anterior = "${params.operador}";
        var opciones = $(this).find("option:selected").attr("class").split(",");

        poneOperadores(opciones);
        /* regresa a la opción seleccionada */
//        $("#oprd option[value=" + anterior + "]").prop('selected', true);
    });

    function cargarFechas (id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'reportes', action:'fechasDetalle_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgFechasDetalle",
                    title   : "Período para el detalle de Pagos - Fecha de la obligación",
//                    class   : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cerrar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var hasta = $("#fechaHastaDet").val();
                                var desde = $("#fechaDesdeDet").val();
                                var documento = $("#documento").val();
                                location.href='${createLink(controller: 'reportes', action: 'reporteDetallePagos')}?id=' + id + "&desde=" + desde + "&hasta=" + hasta + "&documento=" + documento;
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 100);
            } //success
        }); //ajax
    }

    function cargarFechasSaldo (id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'reportes', action:'fechaDetallesDeudas_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgFechasDetalle",
                    title   : "Período para el detalle de Pagos - Fecha de obligación",
//                    class   : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cerrar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var hasta = $("#fechaHastaDet").val();
                                var desde = $("#fechaDesdeDet").val();
                                location.href='${createLink(controller: 'reportes', action: 'reporteDetalleSaldos')}?id=' + id + "&desde=" + desde + "&hasta=" + hasta ;
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 100);
            } //success
        }); //ajax
    }

    function cargarDesde (id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'reportes2', action:'desde_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgValoresPagados",
                    title   : "Valores pagados -  Respecto a la fecha de pago",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cerrar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var desde = $("#fechaDesdeValores").val();
                                location.href='${createLink(controller: 'reportes2', action: 'reporteValoresPagados')}?id=' + id + "&desde=" + desde;
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 100);
            } //success
        }); //ajax
    }



    function poneOperadores (opcn) {
        var $sel = $("<select name='operador' id='oprd' style='width: 120px' class='form-control'>");
        for(var i=0; i<opcn.length; i++) {
            var opt = opcn[i].split(":");
            var $opt = $("<option value='"+opt[0]+"'>"+opt[1]+"</option>");
            $sel.append($opt);
        }
        $("#selOpt").html($sel);
    };

    /* inicializa el select de oprd con la primea opción de busacdor */
    $(document).ready(function() {
        $("#buscador_con").change();
    });

    function createEditRow(id) {
        var title = id ? "Editar" : "Nueva";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'persona', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Persona",
                    class   : "long",
//                    size   :  'large',
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormPersona();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitFormPersona() {
        var $form = $("#frmPersona");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Persona");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    if(msg == 'ok'){
                        log("Persona guardada correctamente","success");
                        setTimeout(function() {
                            spinner.replaceWith($btn);
                            closeLoader();
                            cargarBusqueda();
                        }, 100);
                    }else{
                        log("Error al guardar la información de persona","error")
                        closeLoader();
                    }
                }
            });
        } else {
            return false;
        } //else
    }

    function asignarPerfil (id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'persona', action:'perfil_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgAsignarPerfil",
                    title   : "Asignar Perfil",
//                    class   : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cerrar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 100);
            } //success
        }); //ajax
    }

    function alicuotaEdit (id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'alicuota', action:'form_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgAsignarPerfilxx",
                    title   : "Alícuota",
//                    class   : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cerrar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormAlicuota();
                            } //callback
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 100);
            } //success
        }); //ajax
    }

    function submitFormAlicuota() {
        var $form = $("#frmAlicuota");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Alicuota");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        if (parts[0] == "SUCCESS") {
                            spinner.replaceWith($btn);
                            closeLoader();
                            cargarBusqueda();
                            return false;

//                            location.reload(true);
                        } else {
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 100);
                }
            });
        } else {
            return false;
        } //else
    }

    %{--$("#").click(function(){--}%
    %{--url = "${g.createLink(controller:'reportes2' , action: 'retenciones')}?cont=" + cont + "Wemp=${session.empresa.id}" + "Wdesde=" + fechaDesde + "Whasta=" + fechaHasta;--}%
    %{--location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + "&filename=retenciones.pdf"--}%
    %{--});--}%

    function pagoAlicuota (id) {
        var url = "${createLink(controller:'ingreso', action:'pendiente')}";
        location.href = url + "/?id=" + id;
    }



    function tablaAlicuotas (id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'alicuota', action:'tablaAlicuotas_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgTablaAlicuotas",
                    title   : "Tabla de Alícuotas",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cerrar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 100);
            } //success
        }); //ajax
    }

    function imprimirExpensas (id) {
        location.href = "${g.createLink(controller:'reportes', action: 'certificadoExpensas')}?id=" + id
    }

    function seleccionarAlicuotas (id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'reportes', action:'alicuotas_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgSeleccionarAlicuotas",
                    title   : "Seleccionar Alícuotas",
//                    class   : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cerrar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                openLoader("Espere...");
                                var vlor = $("#valorHasta").val();
                                %{--location.href = "${g.createLink(controller: 'reportes', action: 'imprimirSolicitudes')}?vlor=" + vlor;--}%
                                location.href = "${g.createLink(controller: 'reportes', action: 'reporteSolicitudPago')}?vlor=" + vlor + "&id=" + id;
                                closeLoader();
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 100);
            } //success
        }); //ajax
    }




</script>

</body>
</html>