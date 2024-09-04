<style type="text/css">
.colorAtras {
    background-color: #dfa58f;
    color: #0b0b0b;
    text-align: center;
    font-weight: bold;
}

/*.colorAsiento {*/
    /*color: #0b0b0b;*/
    /*background-color: #7ac6ff;*/
/*}*/

.derecha {
    text-align: right;
}

.izquierda {
    text-align: left;
}

.dato {
    font-weight: normal;
    background-color: #ffd5af;
}
.total {
    /*font-weight: bold;*/
    background-color: #dddddd;
    /*color: #fdcfa0;*/
}

.rojo{
    background-color: #702213;
}

</style>

<g:if test="${comprobante?.registrado != 'S'}">
    <div class="btn-group" style="float: left;">
        <a href="#" class="btn btn-success btnAgregarAsiento" data-id="${comprobante?.id}" title="Agregar asiento contable">
            <i class="fa fa-plus"> Agregar Cuenta</i>
        </a>
        <g:if test="${asientos?.size() > 0}">
            <a href="#" class="btn btn-info btnRegistrarComprobante" data-id="${comprobante?.id}" title="Registrar comprobante">
                <i class="fa fa-lock"> Mayorizar</i>
            </a>
            <a href="#" class="btn btn-danger btnBorrarAsientos" title="Borrar los asientos con valores en 0 al debe y al haber">
                <i class="fa fa-minus"> Borrar Cuentas con 0</i>
            </a>
        </g:if>
    </div>
</g:if>

<table class="table table-bordered table-hover table-condensed" width="1000px">
    <thead>
    <tr>
        <th width="100px">Asiento</th>
        <th width="527px">Nombre</th>
        <th width="100px">Debe</th>
        <th width="100px">Haber</th>
        <th width="133px">Acciones</th>
    </tr>
    </thead>
</table>

<div class="row-fluid" style="width: 100%; height: 500px; overflow-y: auto;float: right; margin-top: -20px">
    <div class="span12">
    <table class="table table-bordered table-condensed" width="980px">
    <tbody>
        <g:set var="sumadebe" value="${0.0}"/>
        <g:set var="sumahber" value="${0.0}"/>
        <g:if test="${asientos.size() > 0}">
            <g:each in="${asientos}" var="asiento">
                <g:set var="sumadebe" value="${sumadebe + asiento.debe}"/>
                <g:set var="sumahber" value="${sumahber + asiento.haber}"/>
                <tr class="colorAsiento">
                    <td width="100px">${asiento?.cuenta?.numero}</td>
                    <td width="520px">${asiento?.cuenta?.descripcion}</td>
                    <td width="100px"
                        class="derecha">${asiento.debe ? g.formatNumber(number: asiento.debe, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2) : 0.00}</td>
                    <td width="100px"
                        class="derecha">${asiento.haber ? g.formatNumber(number: asiento.haber, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2) : 0.00}</td>
                    <td width="130px" style="text-align: center">
                        <div class="btn-group">
                            <g:if test="${asiento?.comprobante?.registrado != 'R'}">
                                <a href="#" class="btn btn-success btn-sm btnEditarAsiento" data-id="${asiento?.id}"
                                   title="Editar asiento">
                                    <i class="fa fa-pencil"></i>
                                </a>
                                <a href="#" class="btn btn-danger btn-sm btnEliminarAsiento" data-id="${asiento?.id}"
                                   title="Eliminar asiento">
                                    <i class="fa fa-trash-o"></i>
                                </a>
                            </g:if>
                        </div>
                    </td>
                </tr>
            </g:each>
            <tr>
                <td colspan="2" class="total derecha">Totales del asiento</td>
                <td class="total derecha"><g:formatNumber number="${Math.round(sumadebe*100)/100}" format="##,##0" maxFractionDigits="2" minFractionDigits="2"/> </td>
                <td class="total derecha"><g:formatNumber number="${Math.round(sumahber*100)/100}" format="##,##0" maxFractionDigits="2" minFractionDigits="2"/> </td>
                <td class="total derecha" ${Math.round((sumadebe - sumahber)*100)/100 != 0 ? 'rojo' : ''}>Dif: ${Math.round((sumadebe - sumahber)*100)/100}</td>
            </tr>
            </tbody>
        </table>
        </g:if>
        <g:else>
            <div class="alert alert-warning" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i><strong style="font-size: 14px">No existen registros</strong></div>
        </g:else>
    </div>
</div>

<script type="text/javascript">

    var mbc;

    $(".btnRegistrarComprobante").click(function () {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><strong style='font-size: 14px'>¿Está seguro que desea registrar el comprobante? <br> Una vez registrado NO podrá ser modificado.</strong>",
            buttons : {
                cancelar : {
                    label     : "<i class='fa fa-times'></i> Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                registrar : {
                    label     : "<i class='fa fa-lock'></i> Registrar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Guardando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'comprobanteCont', action:'registrarComprobante_ajax')}',
                            data    : {
                                id: '${comprobante?.id}'
                            },
                            success : function (msg) {
                                closeLoader();
                                var parts = msg.split("_");
                                if (parts[0] === 'ok') {
                                    log(parts[1], "success");
                                    location.reload()
                                } else {
                                    log(parts[1], "error");
                                }
                            }
                        });
                    }
                }
            }
        });
    });

    function deleteAsiento(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><strong style='font-size: 14px'>¿Está seguro que desea eliminar el asiento contable.</strong>",
            buttons : {
                cancelar : {
                    label     : "<i class='fa fa-times'></i> Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Borrando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'asiento', action:'borrarAsiento_ajax')}',
                            data    : {
                                id : itemId,
                                comprobante: '${comprobante?.id}'
                            },
                            success : function (msg) {
                                closeLoader();
                                var parts = msg.split("_");
                                if (parts[0] === 'ok') {
                                    log(parts[1], "success");
                                    cargarAsientos('${comprobante?.id}');
                                } else {
                                    log(parts[1], "error");
                                }
                            }
                        });
                    }
                }
            }
        });
    }

    $(".btnBorrarAsientos").click(function (){
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p>¿Está seguro de borrar todos los asientos con valor 0.00.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Borrando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'asiento', action:'borrarCeros_ajax')}',
                            data    : {
                                comprobante: '${comprobante?.id}'
                            },
                            success : function (msg) {
                                closeLoader();
                                var parts = msg.split("_");
                                if (parts[0] === 'ok') {
                                    log(parts[1], "success");
                                    cargarAsientos('${comprobante?.id}');
                                } else {
                                    if(parts[0] === 'err'){
                                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                    }else{
                                        log(parts[1], "error");
                                    }

                                }
                            }
                        });
                    }
                }
            }
        });
    });

    $(".btnAgregarAsiento").click(function () {
        agregar(null)
    });

    $(".btnEditarAsiento").click(function () {
        var idAsiento = $(this).data('id');
        agregar(idAsiento)
    });

    $(".btnEliminarAsiento").click(function () {
        var idAsiento = $(this).data('id');
        deleteAsiento(idAsiento);
    });

    function agregar(idAsiento) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'asiento',action: 'form_ajax')}',
            data: {
                id: idAsiento
            },
            success: function (msg) {
                mbc = bootbox.dialog({
                    title: idAsiento ? "Editar Asiento" : "Nuevo Asiento",
                    message: msg,
                    buttons: {
                        cancelar: {
                            label: "<i class='fa fa-times'></i> Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        },
                        eliminar: {
                            label: "<i class='fa fa-save'></i> Guardar",
                            className: "btn-success",
                            callback: function () {
                                openLoader("Guardando...");
                                $.ajax({
                                    type: 'POST',
                                    url: '${createLink(controller: 'asiento', action: 'guardarAsiento_ajax')}',
                                    data: {
                                        asiento: idAsiento,
                                        cuenta: $("#idCuentaNueva").val(),
                                        debe: $("#valorAsientoDebe").val(),
                                        haber: $("#valorAsientoHaber").val(),
                                        comprobante: '${comprobante?.id}'
                                    },
                                    success: function (msg) {
                                        closeLoader();
                                        var parts = msg.split("_");
                                        if (parts[0] === 'ok') {
                                            log(parts[1], "success");
                                            cargarAsientos('${comprobante?.id}');
                                            cerrarBC();
                                        } else {
                                            if(parts[0] === 'err'){
                                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                            }else{
                                                log(parts[1], "error");
                                            }

                                        }
                                    }
                                });
                                return  false
                            }
                        }
                    }
                });
            }
        });
    }

    function cerrarBC (){
        mbc.modal("hide")
    }

</script>