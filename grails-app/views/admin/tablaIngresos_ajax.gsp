<style>
.flotarderecha{
    float: right;

}

.derecha{
    text-align: right;
}

.marco{
    background-color: white;
    color: black;
    border: 2px solid #bcbec7; /* Green */
}

.button, .button2, .button3 {
    transition-duration: 0.4s;
}

.button:hover {
    background-color: #47954b; /* Green */
    color: white;
}

.button2:hover {
    background-color: #d37937; /* Green */
    color: white;
}

.button3:hover {
    background-color: #891523; /* Green */
    color: white;
}

table {
    table-layout: fixed;
    overflow-x: scroll;
}
th, td {
    overflow: hidden;
    text-overflow: ellipsis;
    word-wrap: break-word;
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
                    %{--<th style="width: 4%; text-align: center" title="Revisado (Correcto)"><i class="fa fa-check-square"></i></th>--}%
                    %{--<th style="width: 4%; text-align: center" title="Corregir valor"><i class="fa fa-edit"></i></th>--}%
                    %{--<th style="width: 4%; text-align: center" title="Borrar"><i class="fa fa-trash"></i></th>--}%
                    <th style="width: 19%">Opciones</th>
                    <th style="width: 8%" title="Comentario">Comentario</th>
                    <th style="width: 1%"></th>
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

                                <td style="text-align: center; width: 21%; font-size: 14px">
                                    <div class="btn-group btn-group-toggle" data-toggle="buttons">
                                        <label class="marco button btn btn-sm ${ingreso.pagoetdo == 'R' ? 'active' : 'inactive'} seleccion" role="button" data-twbs-toggle-buttons-class-active="btn-success">
                                            <input  type="radio" name="${ingreso.pago__id}" value="R">Revisado
                                        </label>
                                        <label class="marco button2 btn btn-sm ${ingreso.pagoetdo == 'C' ? 'active' : 'inactive'} seleccion" role="button" data-twbs-toggle-buttons-class-active="btn-warning">
                                            <input type="radio" name="${ingreso.pago__id}" value="C">Corregir
                                        </label>
                                        <label class="marco button3 btn btn-sm ${ingreso.pagoetdo == 'B' ? 'active' : 'inactive'} seleccion" role="button" data-twbs-toggle-buttons-class-active="btn-danger">
                                            <input  type="radio" name="${ingreso.pago__id}" value="B">Borrar
                                        </label>
                                    </div>
                                </td>

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
                            %{--<td style="text-align: center; width: 4%" class="chk">--}%
                            %{--<g:if test="${ingreso?.prsn == 'R'}">--}%
                            %{--<i class="icon-ok"></i>--}%
                            %{--</g:if>--}%
                            %{--<g:else>--}%
                            %{--<input type="radio" name="rd${ingreso.pago__id}"/>--}%
                            %{--</g:else>--}%
                            %{--</td>--}%



                            %{--<td style="text-align: center; width: 12%; font-size: 14px">--}%
                            %{--<g:radioGroup  name="${ingreso.pago__id}"--}%
                            %{--values="['R','C', 'B']"--}%
                            %{--labels="['', '', '']"--}%
                            %{--value="${ingreso.pagoetdo}" style="margin-right: 17px;--}%
                            %{--margin-left: 5px" class="seleccion"--}%
                            %{--data-dpto="${ingreso.prsndpto}" data-desc="${ingreso.pagodscr}" data-valor="${ingreso.pagovlor}" data-est="${ingreso.pagoetdo}">--}%
                            %{--${it.radio}--}%
                            %{--</g:radioGroup>--}%
                            %{--</td>--}%
                                <g:if test="${ingresos.size() <= 13}">
                                    <td style="width: 5%">
                                        <a href="#" name="${ingreso.pago__id}" class="btn btn-info btnComentarios"
                                           data-dpto="${ingreso.prsndpto}" data-desc="${ingreso.pagodscr}" data-valor="${ingreso.pagovlor}"
                                           data-est="${ingreso.pagoetdo}" data-com="${ingreso.pagorevs}"><i class="fa fa-pencil"></i></a>
                                    </td>
                                </g:if>
                                <g:else>
                                    <td style="width: 4%">
                                        <a href="#" name="${ingreso.pago__id}" class="btn btn-info btnComentarios"
                                           data-dpto="${ingreso.prsndpto}" data-desc="${ingreso.pagodscr}" data-valor="${ingreso.pagovlor}"
                                           data-est="${ingreso.pagoetdo}" data-com="${ingreso.pagorevs}"><i class="fa fa-pencil"></i></a>
                                    </td>
                                </g:else>
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

    $(".btn-group-toggle").twbsToggleButtons({
        twbsBtnSelector: "[role='button']"
    });

    $(".seleccion").click(function () {
        var id = $(this).children().attr('name');
        var estado = $(this).children().attr('value');
        guardarEstado(id, estado, null)
    });

    $(".btnComentarios").click(function () {
        var id = $(this).attr('name');
        var departamento = $(this).data('dpto');
        var descripcion = $(this).data('desc');
        var valor = $(this).data("valor");
        var estadoActual = $(this).data("est");
        var comentario = $(this).data("com");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'admin', action: 'comentario_ajax')}',
            data:{
                id:id,
                departamento: departamento,
                descripcion: descripcion,
                valor: valor,
                estadoActual: estadoActual,
                comentario: comentario
            },
            success: function (msg){
                var b = bootbox.dialog({
                    id      : "dlgComentario",
                    title   : "Comentario",
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
                                return guardarEstado(id, null, $("#comentarioIngreso").val());
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        })
    });


    %{--$(".seleccion").click(function () {--}%
        %{--var id = $(this).attr('name');--}%
        %{--var estado = $(this).attr('value');--}%
        %{--var departamento = $(this).data('dpto');--}%
        %{--var descripcion = $(this).data('desc');--}%
        %{--var valor = $(this).data("valor");--}%
        %{--var estadoActual = $(this).data("est");--}%

        %{--$.ajax({--}%
            %{--type: 'POST',--}%
            %{--url: '${createLink(controller: 'admin', action: 'comentario_ajax')}',--}%
            %{--data:{--}%
                %{--id:id,--}%
                %{--estado: estado,--}%
                %{--departamento: departamento,--}%
                %{--descripcion: descripcion,--}%
                %{--valor: valor,--}%
                %{--estadoActual: estadoActual--}%
            %{--},--}%
            %{--success: function (msg){--}%
                %{--var b = bootbox.dialog({--}%
                    %{--id      : "dlgEstado",--}%
                    %{--title   : "Estado del ingreso",--}%
                    %{--message : msg,--}%
                    %{--buttons : {--}%
                        %{--cancelar : {--}%
                            %{--label     : "Cancelar",--}%
                            %{--className : "btn-primary",--}%
                            %{--callback  : function () {--}%
                            %{--}--}%
                        %{--},--}%
                        %{--guardar  : {--}%
                            %{--id        : "btnSave",--}%
                            %{--label     : "<i class='fa fa-save'></i> Guardar",--}%
                            %{--className : "btn-success",--}%
                            %{--callback  : function () {--}%
                                %{--return guardarEstado(id, estado, $("#comentarioIngreso").val());--}%
                            %{--} //callback--}%
                        %{--} //guardar--}%
                    %{--} //buttons--}%
                %{--}); //dialog--}%
            %{--}--}%
        %{--})--}%
    %{--});--}%

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
//                    log("Estado guardado correctamente","success");
                    cargarIngresos($("#fechaDesde").val(), $("#fechaHasta").val());
                }else{
                    log("Error al guardar el estado","error")
                }
            }
        });
    }

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
