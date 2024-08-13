<util:renderHTML html="${msg}"/>

<style type="text/css">
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

<g:set var="clase" value="${'principal'}"/>

<div class="" style="width: 99.7%;height: ${msg == '' ? 500 : 465}px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1060px">
        <g:each in="${data}" var="dato" status="z">
            <tr id="${dato.gstr__id}" data-id="${dato.gstr__id}" data-ed="${dato.gstretdo}" class="${clase}">
                <td style="width: 40%">
                    ${dato?.gstrnmbr}
                </td>
                <td  style="width: 15%">
                    ${dato.gstretdo == 'R' ? 'Registrado' : 'No registrado'}
                </td>
                <td style="width: 30%">
                    ${dato.tipo}
                </td>
                <td style="width: 15%">
                    <a href="#" data-id="${dato.gstr__id}" class="btn btn-success btn-sm btn-edit btn-ajax" title="Editar gestor">
                        <i class="fa fa-pencil"></i> Editar
                    </a>
                    <g:if test="${dato?.gstretdo != 'R'}">
                        <a href="#" data-id="${dato.gstr__id}" class="btn btn-info btn-sm btn-copiar btn-ajax" title="Copiar gestor">
                            <i class="fa fa-file"></i> Copiar
                        </a>
                    </g:if>
                </td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">

    $(".btn-edit").click(function () {
        var id = $(this).data("id");
        location.href = '${createLink(action: "formGestor")}?id=' + id;
    });

    $(".btn-copiar").click(function () {
        var id = $(this).data("id");
        var b = bootbox.dialog({
            id: "dlgCopiarGestor",
            title: "Copiar Gestor",
            message:  "<label>Nombre</label> </br> <input name='copiName' id='copiado' style='height: 40px;' class='form-control'/>",
            buttons: {
                cancelar: {
                    label: "<i class='fa fa-times'></i> Cancelar",
                    className: "btn-primary",
                    callback: function () {
                    }
                },
                aceptar: {
                    label: "<i class='fa fa-times'></i> Aceptar",
                    className: "btn-success",
                    callback: function () {
                        var cp = $("#copiado").val();
                        $.ajax({
                            type: 'POST',
                            url: '${createLink(controller: 'gestor', action: 'copiarGestor_ajax')}',
                            data:{
                                id: id,
                                nombre:  cp
                            },
                            success: function(msg){
                                if(msg === 'ok'){
                                    bootbox.hideAll();
                                    log("Gestor copiado correctamente","success");
                                    setTimeout(function () {
                                        location.reload();
                                    }, 1000);
                                }else{
                                    log("Error al copiar el gestor ","error")
                                }

                            }
                        })
                    }
                }
            } //buttons
        }); //dialog
    });

    // $(function () {
    //     $("tr").contextMenu({
    //         items  : createContextMenu,
    //         onShow : function ($element) {
    //             $element.addClass("trHighlight");
    //         },
    //         onHide : function ($element) {
    //             $(".trHighlight").removeClass("trHighlight");
    //         }
    //     });
    // });
</script>
