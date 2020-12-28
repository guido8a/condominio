<%
    def buscadorServ = grailsApplication.classLoader.loadClass('utilitarios.BuscadorService').newInstance()
%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Alicuotas </title>

    <style type="text/css">

    .alinear {
        text-align: center !important;
    }
    </style>
</head>

<body>

<div style="text-align: center; margin-top: -30px; margin-bottom: 10px">
    <h3>Cálculo del valor de Alícuotas</h3>
</div>

<div style="margin-top: -5px;" class="vertical-container">
    <p class="css-icono" style="margin-bottom: -15px"><i class="fa fa-folder-open-o"></i></p>

    <div class="linea45"></div>

    <div class="row" style="margin-bottom: 10px;">

        <div style="margin-left: 20px;">
            <div class="col-xs-8 col-md-8">
                <div class="col-xs-3 col-md-2">
                    <b>Buscar por: </b>
                    <elm:select name="buscador" from = "${buscadorServ.parmProcesos()}" value="${params.buscador}"
                                optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con"
                                style="width: 120px" class="form-control"/>
                </div>
                <div class="col-xs-3 col-md-3">
                    <strong style="margin-left: 20px;">Operación:</strong>
                    <span id="selOpt"></span>
                </div>
                <div class="col-xs-3 col-md-4">
                    <b style="margin-left: 20px">Criterio: </b>
                    <g:textField name="criterio" style="margin-right: 10px; width: 90%; border-color: #53a7ff" value="${params.criterio}"
                                 id="criterio_con" class="form-control"/>
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

            <div class="col-xs-4 col-md-4">

                <div class="col-xs-4 col-md-4">
                    <b style="margin-left: 0px">Valor Base: </b>
                    <g:textField name="base" style="margin-right: 10px; width: 90%; border-color: #53a7ff" value="${base}"
                                 id="valor_base" class="form-control"/>
                </div>

                <div class="btn-group col-xs-6 col-md-4" style="margin-left: -10px; margin-top: 20px;">

                    <a href="#" name="busqueda" class="btn btn-info" id="btnBusqueda" title="Buscar"
                       style="height: 34px; padding: 9px; width: 46px">
                        <i class="fa fa-search"></i></a>

                    <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                       title="Borrar criterios" style="height: 34px; padding: 9px; width: 34px">
                        <i class="fa fa-eraser"></i></a>
                </div>

                <div class="col-xs-4 col-md-4">
                    <b style="margin-left: 0px">No Aportan</b>
                    <g:textField name="base" style="margin-right: 10px; width: 90%; background-color: #ffefef; color: #800000"
                                 value="${no_aportan}" id="valor_base" class="form-control" readonly=""/>
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
            %{--<th class="alinear" style="width: 6%">Edificio</th>--}%
            <th class="alinear" style="width: 4%">Dp.</th>
            <th class="alinear" style="width: 10%">Nombre</th>
            <th class="alinear" style="width: 12%">Apellido</th>
            <th class="alinear" style="width: 50%">Propiedades y Alícuotas</th>
            <th class="alinear" style="width: 6%">Total</th>
            <th class="alinear" style="width: 6%">Actual</th>
            <th class="alinear" style="width: 6%">Cuota</th>
            <th class="alinear" style="width: 6%">Dif.</th>
        </tr>
        </thead>
    </table>


    <div class="alert alert-danger hidden" id="mensaje" style="text-align: center">
    </div>

    <div id="detalle">
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
                url: "${g.createLink(controller: 'condominio', action: 'tablaBuscar')}",
                data: {
                    buscador: $("#buscador_con").val(),
                    ordenar:  $("#ordenar_por").val(),
                    criterio: $("#criterio_con").val(),
                    base: $("#valor_base").val(),
                    operador: $("#oprd").val(),
                    condo: condo
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

        if('${session.perfil.codigo}' == 'ADC'){
            if(ingr>0){
                items.pagar = ingresos;
            }
            items.administrar = administrar;
            items.detalle = detalle;
            if(deuda <= 0 && codigo == 'P'){
                items.certificado = certificado;
            }
        } else {
            items.detalle = detalle;
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
                    title   : "Período para el detalle de Pagos",
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
                                location.href='${createLink(controller: 'reportes', action: 'reporteDetallePagos')}?id=' + id + "&desde=" + desde + "&hasta=" + hasta ;
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
        location.href = url + "/" + id;
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