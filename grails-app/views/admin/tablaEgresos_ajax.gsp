<style type="text/css">
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

<g:if test="${session.perfil.codigo != 'RVS'}">
label {
    pointer-events: none;
    cursor: default;
}
</g:if>

</style>

<div class="row">
    <div class="col-xs-12 alert alert-info">
        <div class="col-xs-12" style="height: 620px">
            <label>Egresos</label>

            <table class="table-bordered table-condensed" style="width: 100%">
                <tr style="width:100%;">
                    <th style="width: 24%">Proveedor</th>
                    <th style="width: 24%">Descripción</th>
                    <th style="width: 10%">Fecha</th>
                    <th style="width: 9%">Valor</th>
                    <g:if test="${session.perfil.codigo == 'ADC'}">
                        <th style="width: 6%">Revi.</th>
                    </g:if>
                    <th style="width: 19%">Opciones</th>
                    <th style="width: 6%" title="Comentario">Comen.</th>
                    <th style="width: 1%"></th>
                </tr>
            </table>

            <g:if test="${egresos.size() > 0}">
                <div class="" style="width: 100%;height: 560px; overflow-y: auto;float: right;" >
                    <table class="table-bordered table-condensed table-hover" width="98%">
                        <g:each in="${egresos}" var="egreso">
                            <tr style="width: 100%">
                                <td style="width: 25%">${egreso.prve}</td>
                                <td style="width: 25%">${egreso.egrsdscr}</td>
                                <td style="width: 10%">${egreso.egrsfcha}</td>
                                <td class="derecha" style="width: 10%">${egreso.egrsvlor}</td>

                                <g:if test="${session.perfil.codigo == 'ADC'}">
                                    <td style="width: 5%">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input revisarEgresos" type="checkbox" value="option1" data-id="${egreso.pgeg__id}" ${egreso.egrsedad == 'S' ? 'checked' : ''}>
                                        </div>
                                    </td>
                                </g:if>

                                <td style="text-align: center; width: 21%; font-size: 14px">
                                    <div class="btn-group btn-group-toggle" data-toggle="buttons">
                                        <label class="marco button btn btn-sm ${egreso.egrsetdo == 'R' ? 'active' : 'inactive'} seleccionEgresos" role="button" data-twbs-toggle-buttons-class-active="btn-success">
                                            <input  type="radio" name="${egreso.pgeg__id}" value="R">Revisado
                                        </label>
                                        <label class="marco button2 btn btn-sm ${egreso.egrsetdo == 'C' ? 'active' : 'inactive'} seleccionEgresos" role="button" data-twbs-toggle-buttons-class-active="btn-warning">
                                            <input type="radio" name="${egreso.pgeg__id}" value="C">Corregir
                                        </label>
                                        <label class="marco button3 btn btn-sm ${egreso.egrsetdo == 'B' ? 'active' : 'inactive'} seleccionEgresos" role="button" data-twbs-toggle-buttons-class-active="btn-danger">
                                            <input  type="radio" name="${egreso.pgeg__id}" value="B">Borrar
                                        </label>
                                    </div>
                                </td>

                                <td style="width: ${egresos.size() <= 21 ? 5 : 4}%">
                                    <a href="#" name="${egreso.pgeg__id}" class="btn btn-info btnComentariosEgresos"
                                       data-prov="${egreso.prve}" data-desc="${egreso.egrsdscr}" data-valor="${egreso.egrsvlor}" data-est="${egreso.egrsetdo}" data-com="${egreso.egrsrevs}"><i class="fa fa-pencil"></i>
                                    </a>
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
<div>
    Total documentos: ${egresos.size()}
</div>

<script type="text/javascript">

    $(".revisarEgresos").click(function () {
        openLoader("Guardando...");

        var es = $(this).is(":checked");
        var id = $(this).data("id");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'admin', action: 'guardarRevision_ajax')}',
            data:{
                estado:es,
                id:id,
                tipo: 2
            },
            success:function(msg){
                closeLoader();
                if(msg == 'ok'){
                    cargarEgresos($("#fechaDesde").val(), $("#fechaHasta").val());
                }else{
                    log("Error al cambiar el estado")
                }
            }
        })
    });

    $.switcher('input[type=checkbox]');

    $(".btn-group-toggle").twbsToggleButtons({
        twbsBtnSelector: "[role='button']"
    });

    <g:if test="${session.perfil.codigo == 'RVS'}">
    $(".seleccionEgresos").click(function () {
        var id = $(this).children().attr('name');
        var estado = $(this).children().attr('value');
        guardarEstadoEgreso(id, estado, null)
    });
    </g:if>

    function guardarEstadoEgreso(id, estado, comentario){
        openLoader("Guardando...");
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'admin', action: 'guardarEstadoIngreso_ajax')}',
            data:{
                id:id,
                estado:estado,
                comentario: comentario,
                tipo: 2
            },
            success: function (msg) {
                closeLoader();
                if(msg == 'OK'){
                    cargarEgresos($("#fechaDesde").val(), $("#fechaHasta").val());
                }else{
                    log("Error al guardar el estado","error")
                }
            }
        });
    }

    $(".btnComentariosEgresos").click(function () {
        var id = $(this).attr('name');
        var proveedor = $(this).data('prov');
        var descripcion = $(this).data('desc');
        var valor = $(this).data("valor");
        var estadoActual = $(this).data("est");
        var comentario = $(this).data("com");

        <g:if test="${session.perfil.codigo == 'RVS'}">
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'admin', action: 'comentario_ajax')}',
            data:{
                id:id,
                proveedor: proveedor,
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
                                return guardarEstadoEgreso(id, null, $("#comentarioIngreso").val());
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        });
        </g:if>
        <g:else>
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'admin', action: 'showComentario_ajax')}',
            data:{
                id:id,
                proveedor: proveedor,
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
                        }
                    } //buttons
                }); //dialog
            }
        });
        </g:else>
    });
</script>
