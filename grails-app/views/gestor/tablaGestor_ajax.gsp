<style type="text/css">

.rojo{
    color: #a00;
}
.total{
    font-size: 14px;
    background-color: #acb6c0;
}
.derecha{
    text-align: right;
}
</style>

<table class="table table-bordered table-hover table-condensed" width="1050">
    <tbody style="font-size: 12px">
    <g:set var="pcnt" value="${0}" />
    <g:set var="pcim" value="${0}" />
    <g:set var="ice" value="${0}" />
    <g:set var="pcbz" value="${0}" />
    <g:set var="flte" value="${0}" />
    <g:set var="vlor" value="${0}" />

    <g:if test="${movimientos}">
        <g:each in="${movimientos}" var="gnra" status="i">
            <tr style="background-color: ${(gnra?.debeHaber == 'D')?'#D4E6FC':'#FFCC99'} !important; "
                class="movimiento">
            <td width="420px">${gnra?.cuenta?.numero}<span style="font-size: 12px"> (${gnra?.cuenta?.descripcion})</span></td>

                <td class="largo"><g:textField type="number" name="porcentaje" id="por_${gnra?.id}"
                                               class="validacionNumero form-control" style="width: 85px;"
                                               value="${gnra.porcentaje ?: 0}" /></td>
                <td class="largo"><g:textField type="number" name="porcentaje" id="sin_${gnra?.id}"
                                               class="validacionNumero form-control" style="width: 85px;"
                                               value="${gnra.baseSinIva ?: 0}" /></td>
                <td class="largo"><g:textField type="number" name="impuestos" id="imp_${gnra?.id}"
                                               class="validacionNumero form-control" style="width: 85px;"
                                               value="${gnra.porcentajeImpuestos?:0}" /></td>
                <td class="largo"><g:textField type="number" name="ice" id="ice_${gnra?.id}"
                                               class="validacionNumero form-control" style="width: 85px;"
                                               value="${gnra.ice?:0}" /></td>
                <td class="largo"><g:textField type="number" name="flete" id="fl_${gnra?.id}"
                                               class="validacionNumero form-control" style="width: 85px;"
                                               value="${gnra?.flete?:0}" /></td>
                <td class="largo"><g:textField type="number" name="valor" id="val_${gnra?.id}"
                                               class="validacionNumero form-control" style="width: 85px;"
                                               value="${gnra?.valor?:0}" /></td>
                <td width="50px"><g:textField type="number" name="debeHaber" id="dh_${gnra?.id}"
                                               class="form-control mayusculas" style="width: 45px;"
                                               value="${gnra?.debeHaber}" /></td>
                <td style="width: 100px">
                    <g:if test="${gestor?.estado != 'R' && (gestor?.condominio == condominio)}">
                        <div class="btn-group">
                            <a href="#" class="btn btn-success btn-s btnGuardarMovi" cuenta="${gnra?.id}" iden="${i}"
                               title="Guardar cambios">
                                <i class="fa fa-save"></i>
                            </a>
                            <a href="#" class="btn btn-danger btn-s btnEliminarMovi" cuenta="${gnra?.id}"
                               title="Eliminar movimiento">
                                <i class="fa fa-times"></i>
                            </a>
                        </div>
                    </g:if>
                </td>
                </tr>
                <g:set var="sgno" value="${(gnra?.debeHaber == 'D')? 1 : -1}" />
                <g:set var="pcnt" value="${pcnt + gnra.porcentaje * sgno}" />
                <g:set var="pcim" value="${pcim + gnra.porcentajeImpuestos * sgno}" />
                <g:set var="ice" value="${ice + gnra.ice * sgno}" />
                <g:set var="pcbz" value="${pcbz + gnra.baseSinIva * sgno}" />
                <g:set var="flte" value="${flte + gnra.flete * sgno}" />
                <g:set var="vlor" value="${vlor + gnra.valor * sgno}" />
        </g:each>

        <tr class="colorAsiento">
            <td class="total derecha">Diferencia de Totales</td>
            <td class="total derecha ${Math.abs(pcnt) > 0.001 ? 'rojo' : ''}">${Math.round(pcnt*100)/100}</td>
            <td class="total derecha ${Math.abs(pcbz) > 0.001 ? 'rojo' : ''}">${Math.round(pcbz*100)/100}</td>
            <td class="total derecha ${Math.abs(pcim) > 0.001 ? 'rojo' : ''}">${Math.round((pcim)*100)/100}</td>
            <td class="total derecha ${Math.abs(ice) > 0.001 ? 'rojo' : ''}">${Math.round((ice)*100)/100}</td>
            <td class="total derecha ${Math.abs(flte) > 0.001 ? 'rojo' : ''}">${Math.round((flte)*100)/100}</td>
            <td class="total derecha ${Math.abs(vlor) > 0.001 ? 'rojo' : ''}">${Math.round((vlor)*100)/100}</td>
            <td colspan="2" class="total">Debe - Haber</td>
        </tr>

    </g:if>
    <g:else>
        <tr class="danger text-center">
            <td colspan="6">Sin movimientos contables.</td>
        </tr>
    </g:else>
    </tbody>
</table>

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
        ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
        ev.keyCode === 37 || ev.keyCode === 39 ||
        ev.keyCode === 110 || ev.keyCode === 190);
    }

    $(".validacionNumero").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {

    });

    $(".btnEliminarMovi").click(function () {
        var genera = $(this).attr('cuenta');
        var gestor = '${gestor?.id}';
        var tipo = '${tipo?.id}';
        var generaNombre = $(this).attr('nombreCuenta');
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar esta cuenta?. </p>" ,
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash-o'></i> Borrar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Eliminando");
                        $.ajax({
                            type: 'POST',
                            url:'${createLink(controller: 'gestor', action: 'borrarCuenta_ajax')}',
                            data:{
                                genera: genera
                            },
                            success: function (msg) {
                                if(msg === 'ok'){
                                    closeLoader();
                                    cargarMovimientos(gestor, tipo);
                                    cargarTotales(gestor, tipo);
                                    revisarAsientos();
                                    log("Cuenta borrada correctamente","success");
                                }else{
                                    closeLoader();
                                    cargarMovimientos(gestor, tipo);
                                    cargarTotales(gestor, tipo);
                                    log("Error al borrarla cuenta!.","error");
                                }
                            }
                        });
                    }
                }
            }
        });
    });

    $(".btnGuardarMovi").click(function () {
        var genera = $(this).attr('cuenta');
        var porcentaje = $("#por_"+ genera).val();
        var impuesto = $("#imp_"+ genera).val();
        var ice = $("#ice_"+ genera).val();
        var gestor = '${gestor?.id}';
        var tipo = '${tipo?.id}';
        var sinIva = $("#sin_" + genera).val();
        var flete = $("#fl_" + genera).val();
        var debeHaber = $("#dh_" + genera).val();
        var valor = $("#val_" + genera).val();

        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'gestor', action: 'guardarValores_ajax')}',
            data:{
                genera: genera,
                porcentaje: porcentaje,
                impuesto: impuesto,
                ice: ice,
                sinIva: sinIva,
                flete: flete,
                debeHaber: debeHaber,
                valor: valor
            },
            success: function (msg){
                if(msg === 'ok'){
                    log("Valores guardados correctamente","success");
                    cargarMovimientos(gestor, tipo);
                    cargarTotales(gestor, tipo);
                    revisarAsientos();
                }else{
                    log("Error al guardar los valores!","error");
                }
            }
        });

    });

    $(function() {
        $('.mayusculas').keyup(function() {
            this.value = this.value.toUpperCase();
        });
    });

</script>