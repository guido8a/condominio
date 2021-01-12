
<%@ page import="condominio.Empleado" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Nómina</title>
    <style type="text/css">

    .alinear {
        text-align: center !important;
    }

    .derecha {
        text-align: right !important;
    }
    </style>

</head>
<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-primary btnRegresar">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    <div class="btn-group">
        <a href="#" class="btn btn-warning btnMensual"> <i class="fa fa-plus-square"></i> Sueldo mensual
        </a>
        <a href="#" class="btn btn-info btnTercero"> <i class="fa fa-plus-circle"></i> Décimo tercero
        </a>
        <a href="#" class="btn btn-primary btnCuarto"> <i class="fa fa-plus-circle"></i> Décimo cuarto
        </a>
        <a href="#" class="btn btn-success btnVacaciones"> <i class="fa fa-plane "></i> Vacaciones
        </a>
    </div>
</div>

<div style="text-align: center; margin-top: 20px;margin-bottom:20px">
    <h3>Nómina del empleado: ${empleado?.nombre + " " + empleado?.apellido}</h3>
</div>

<div style="margin-top: 30px; min-height: 350px" class="vertical-container">
    <p class="css-vertical-text">Nómina</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 100%">
        <tr>
            <th class="alinear" style="width: 21%">Tipo</th>
            <th class="alinear" style="width: 11%">Sueldo</th>
            <th class="alinear" style="width: 11%">Fondo de reserva</th>
            <th class="alinear" style="width: 11%">Iess</th>
            <th class="alinear" style="width: 11%">Descuento valor</th>
            <th class="alinear" style="width: 11%">Bono Valor</th>
            <th class="alinear" style="width: 8%">Fecha Inicio</th>
            <th class="alinear" style="width: 8%">Fecha Fin</th>
            <th class="alinear" style="width: 8%">Total</th>

        </tr>
    </table>

    <div class="" style="width: 100%;height: 350px; overflow-y: auto;float: right; margin-top: -15px" >
        <table class="table-bordered table-condensed table-hover" width="100%">
            <g:each in="${roles}" var="rol">
                <tr data-id="${rol?.id}">
                    <td style="width: 21%">${rol?.salario?.descripcion}</td>
                    <td class="derecha" style="width: 11%">${g.formatNumber(number: rol?.sueldo?.valor ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}</td>
                    <td class="derecha" style="width: 11%">${g.formatNumber(number: rol?.fondoReserva ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}</td>
                    <td class="derecha" style="width: 11%">${g.formatNumber(number: rol?.iess ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}</td>
                    <td class="derecha" style="width: 11%">${g.formatNumber(number: rol?.descuentoValor ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}</td>
                    <td class="derecha" style="width: 11%">${g.formatNumber(number: rol?.bonoValor ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}</td>
                    <td style="width: 8%">${rol?.fechaDesde?.format("dd-MM-yyyy")}</td>
                    <td style="width: 8%">${rol?.fechaHasta?.format("dd-MM-yyyy")}</td>
                    <td class="derecha" style="width: 8%">${g.formatNumber(number: rol?.valor ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}</td>

                </tr>
            </g:each>
        </table>
    </div>
</div>

<script type="text/javascript">

    $(".btnRegresar").click(function () {
        location.href="${createLink(controller: 'empleado', action: 'list')}?id=" + '${empleado?.id}'
    })

    $(".btnMensual").click(function (){
        mensual();
    });

    $(".btnTercero").click(function (){
        tercero();
    });

    $(".btnCuarto").click(function (){
        cuarto();
    });

    $(".btnVacaciones").click(function (){
        vacaciones();
    });


    function mensual(id) {
        var title = id ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'rolPagos', action:'mensual_ajax')}",
            data    : {
                id : id ? id : '',
                condominio: '${condominio?.id}',
                empleado: '${empleado?.id}'
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgMensual",
                    title   : title + " Sueldo mensual",
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
                                return submitFormMensual(1);
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

    function tercero(id) {
        var title = id ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'rolPagos', action:'tercero_ajax')}",
            data    : {
                id : id ? id : '',
                condominio: '${condominio?.id}',
                empleado: '${empleado?.id}'
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgTercero",
                    title   : title + " Décimo tercero",
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
                                return submitFormMensual(2);
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

    function cuarto(id) {
        var title = id ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'rolPagos', action:'cuarto_ajax')}",
            data    : {
                id : id ? id : '',
                condominio: '${condominio?.id}',
                empleado: '${empleado?.id}'
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCuarto",
                    title   : title + " Décimo cuarto",
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
                                return submitFormMensual(3);
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

    function vacaciones(id) {
        var title = id ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'rolPagos', action:'vacaciones_ajax')}",
            data    : {
                id : id ? id : '',
                condominio: '${condominio?.id}',
                empleado: '${empleado?.id}'
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgVacaciones",
                    title   : title + " Vacaciones",
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
                                return submitFormMensual(4);
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

    function submitFormMensual(tipo) {

        var $form
        var $btn

        switch (tipo){
            case 1:
                $form =  $("#frmMensual");
                $btn = $("#dlgMensual").find("#btnSave");
                break;
            case 2:
                $form =  $("#frmTercero");
                $btn = $("#dlgTercero").find("#btnSave");
                break;
            case 3:
                $form =  $("#frmCuarto");
                $btn = $("#dlgCuarto").find("#btnSave");
                break;
            case 4:
                $form =  $("#frmVacaciones");
                $btn = $("#dlgVacaciones").find("#btnSave");
                break;
        }

        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    closeLoader();
                    if(msg == 'ok'){
                        log("Guardado correctamente","success");
                        setTimeout(function() {
                            location.reload(true)
                        }, 1000);
                    }else{
                        log("Error al guardar","error")
                    }
                }
            });
        } else {
            return false;
        } //else
    }

//    function createContextMenu(node) {
//        var $tr = $(node);
//        var items = {
//            header: {
//                label: "Acciones",
//                header: true
//            }
//        };
//
//        var id = $tr.data("id");
//
//        var editar = {
//            label: " Editar",
//            icon: "fa fa-edit",
//            action : function ($element) {
//                mensual(id);
//            }
//        };
//
//        var sueldo = {
//            label: "Sueldo",
//            icon: "fa fa-money",
//            action : function ($element) {
//                sueldoEmpleado(id)
//            }
//        };
//
//        items.editar = editar;
////        items.sueldo = sueldo;
//
//        return items
//    }
//
//    $(function () {
//        $("tr").contextMenu({
//            items  : createContextMenu,
//            onShow : function ($element) {
//                $element.addClass("trHighlight");
//            },
//            onHide : function ($element) {
//                $(".trHighlight").removeClass("trHighlight");
//            }
//        });
//    });


</script>

</body>
</html>
