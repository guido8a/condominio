<style type="text/css">
.flotarderecha{
    float: right;

}

.derecha{
    text-align: right;
}
</style>


<div class="row">
    <div class="col-xs-12 alert alert-success">
        <div class="col-xs-12" style="height: 600px">
            <label>Ingresos</label>

            <table class="table-bordered table-condensed" style="width: 100%">
                <tr style="width:100%;">
                    <th style="width: 5%">Dpto.</th>
                    <th style="width: 15%">Persona</th>
                    <th style="width: 12%">Ocupante</th>
                    <th style="width: 15%">Descripción de Ingreso</th>
                    <th style="width: 9%">Fecha</th>
                    <th style="width: 9%">Valor</th>
                    <th style="width: 7%">Doc.</th>
                    <th style="width: 4%; text-align: center" title="Revisado (Correcto)"><i class="fa fa-check-square"></i></th>
                    <th style="width: 4%; text-align: center" title="Corregir valor"><i class="fa fa-edit"></i></th>
                    <th style="width: 4%; text-align: center" title="Borrar"><i class="fa fa-trash"></i></th>
                    <th style="width: 13%" title="Comentario">Comentario</th>
                    <th style="width: 3%"></th>
                </tr>
            </table>

            <g:if test="${ingresos.size() > 0}">
                <div class="" style="width: 100%;height: 560px; overflow-y: auto;float: right;" >
                    <table class="table-bordered table-condensed table-hover" width="98%">
                        <g:each in="${ingresos}" var="ingreso">
                            <tr style="width: 100%">
                                <td style="width: 5%">${ingreso.prsndpto}</td>
                                <td style="width: 15%">${ingreso.prsn}</td>
                                <td style="width: 12%">${ingreso.tpocdscr}</td>
                                <td style="width: 15%">${ingreso.pagodscr}</td>
                                <td style="width: 9%">${ingreso.pagofcha}</td>
                                <td class="derecha" style="width: 9%">${ingreso.pagovlor}</td>
                                <td class="derecha" style="width: 7%">${ingreso.pagodcmt}</td>
                                %{--<td style="text-align: center; width: 4%" class="chk">--}%
                                %{--<g:if test="${ingreso?.prsn == 'R'}">--}%
                                %{--<i class="icon-ok"></i>--}%
                                %{--</g:if>--}%
                                %{--<g:else>--}%
                                %{--<input type="radio" name="rd${ingreso.pago__id}"/>--}%
                                %{--</g:else>--}%
                                %{--</td> --}%
                                %{--<td style="text-align: center; width: 4%" class="chk">--}%
                                %{--<g:if test="${ingreso?.prsn == 'R'}">--}%
                                %{--<i class="icon-ok"></i>--}%
                                %{--</g:if>--}%
                                %{--<g:else>--}%
                                %{--<input type="radio" name="rd${ingreso.pago__id}"/>--}%
                                %{--</g:else>--}%
                                %{--</td>--}%
                                %{--<td style="text-align: center; width: 4%" class="chk">--}%
                                %{--<g:if test="${ingreso?.prsn == 'R'}">--}%
                                %{--<i class="icon-ok"></i>--}%
                                %{--</g:if>--}%
                                %{--<g:else>--}%
                                %{--<input type="radio" name="rd${ingreso.pago__id}"/>--}%
                                %{--</g:else>--}%
                                %{--</td>--}%
                                <td style="text-align: center; width: 12%; font-size: 14px">
                                    <g:radioGroup  name="${ingreso.pago__id}"
                                                   values="['R','C', 'B']"
                                                   labels="['', '', '']"
                                                   value="${ingreso.pagoetdo}" style="margin-right: 17px;
                                                   margin-left: 5px" class="seleccion"
                                                   data-dpto="${ingreso.prsndpto}" data-desc="${ingreso.pagodscr}" data-valor="${ingreso.pagovlor}" data-est="${ingreso.pagoetdo}">
                                        ${it.radio}
                                    </g:radioGroup>
                                </td>

                                <td style="width: 14%">
                                    ${ingreso.pagorevs ?: ''}
                                </td>
                            </tr>
                        </g:each>
                    </table>
                </div>
            </g:if>
            <g:else>
                <div class="alert alert-danger" style="text-align: center; margin-top: 15px">
                    No existen datos!
                </div>
            </g:else>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(".seleccion").click(function () {
        var id = $(this).attr('name');
        var estado = $(this).attr('value');
        var departamento = $(this).data('dpto');
        var descripcion = $(this).data('desc');
        var valor = $(this).data("valor");
        var estadoActual = $(this).data("est");

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'admin', action: 'comentario_ajax')}',
            data:{
                id:id,
                estado: estado,
                departamento: departamento,
                descripcion: descripcion,
                valor: valor,
                estadoActual: estadoActual
            },
            success: function (msg){
                var b = bootbox.dialog({
                    id      : "dlgEstado",
                    title   : "Estado del ingreso",
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
                                return guardarEstado(id, estado, $("#comentarioIngreso").val());
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        })
    });

    function guardarEstado(id, estado, comentario){
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'admin', action: 'guardarEstadoIngreso_ajax')}',
            data:{
                id:id,
                estado:estado,
                comentario: comentario
            },
            success: function (msg) {
                if(msg == 'OK'){
                    log("Estado guardado correctamente","success");
                    cargarIngresos($("#fechaDesde").val(), $("#fechaHasta").val());
                }else{
                    log("Error al guardar el estado","error")
                }
            }
        });
    }

    %{--cargarIngresos('${desde}', '${hasta}');--}%
    %{--cargarEgresos('${desde}', '${hasta}');--}%

    /*
     function cargarIngresos (desde, hasta){
     $.ajax({
     type: 'POST',
     async: true,
     data:{
     desde: desde,
     hasta: hasta
     },
     success: function (msg){
     $("#tablaIngresos").html(msg)
     }
     })
     }
     */

    function cargarEgresos (desde, hasta){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'egreso', action: 'tablaEgresos_ajax')}',
            async: true,
            data:{
                desde: desde,
                hasta: hasta
            },
            success: function (msg){
                $("#tablaEgresos").html(msg)
            }
        })
    }




</script>
