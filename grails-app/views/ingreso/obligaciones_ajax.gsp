<%@ page import="condominio.Pago" %>
<style type="text/css">

.derecha{
    text-align: right;
}

.azul{
    color: #701b19;
}

.saldo{
    color: #701b19;
    font-weight: bold;
}

.verde{
    color: #53cf6d;
}

</style>


<div class="" style="width: 100%;height: 500px; overflow-y: auto;">
    <table class="table-bordered table-condensed table-hover" width="100%">
        <g:each in="${ingreso}" status="i" var="ingr">
        %{--<g:set var="saldo" value="${ingr?.valor?.toDouble() - (Pago.findAllByIngreso(ingr).valor?.sum()?.toDouble() ?: 0)}"/>--}%
            <g:set var="saldo" value="${(ingr?.ingrsldo ?: 0)}"/>
            <g:if test="${band}">
            %{--<g:if test="${saldo > 0}">--}%
            %{--<tr class="trIngreso  ${i== 0 ? 'seleccionado' : ''}" ing="${ingr?.id}">--}%
                <tr class="trIngreso  ${i== 0 ? 'seleccionado' : ''}" ing="${ingr?.ingr__id}" data-ing="${ingr?.ingr__id}">
                    %{--<td>${ingr.obligacion.descripcion} ${ingr.observaciones? ': ' + ingr.observaciones :''}</td>--}%
                    %{--<td>${condominio.Ingreso.get(ingr?.ingr__id)?.obligacion?.descripcion} ${ingr.ingrobsr ? ': ' + ingr.ingrobsr :''}</td>--}%
                    <td>${condominio.Ingreso.get(ingr?.ingr__id)?.obligacion?.descripcion}</td>
                    <td class="derecha"><g:formatNumber number="${ingr?.ingrvlor}" format="##,##0" locale="en_US"
                         minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td class="derecha  ${ingr?.ingrvlor > saldo ? 'saldo' : ''} ${saldo > 0 ? 'azul' : 'verde'}"><g:formatNumber number="${saldo}"
                         format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>
                </tr>
            %{--</g:if>--}%
            </g:if>
            <g:else>
            %{--<tr class="trIngreso  ${i== 0 ? 'seleccionado' : ''}" ing="${ingr?.id}">--}%
                <tr class="trIngreso  ${i== 0 ? 'seleccionado' : ''}" ing="${ingr?.ingr__id}" data-ing="${ingr?.ingr__id}">
                    %{--<td>${ingr.obligacion.descripcion} ${ingr.observaciones? ': ' + ingr.observaciones :''}</td>--}%
                    <td>${condominio.Ingreso.get(ingr?.ingr__id)?.obligacion?.descripcion} ${ingr.ingrobsr ? ': ' + ingr.ingrobsr :''}</td>
                    %{--<td class="derecha"><g:formatNumber number="${ingr?.valor}" format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>--}%
                    <td class="derecha"><g:formatNumber number="${ingr?.ingrvlor}" format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td class="derecha ${saldo > 0 ? 'azul' : 'verde'}"><g:formatNumber number="${saldo}" format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>
                </tr>
            </g:else>

        </g:each>
    </table>
</div>


<script type="text/javascript">

    %{--cargarPagos(${ingreso[0]?.id});--}%
    cargarPagos(${ingreso[0]?.ingr__id});

    function cargarPagos (ingreso) {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'ingreso', action: 'pagos_ajax')}',
            data:{
                ingreso: ingreso
            },
            success: function (msg){
                $("#tdPagos").html(msg)
            }
        });
    }

    $(".trIngreso").click(function () {
        var ingreso = $(this).attr("ing");
        $(".trIngreso").removeClass("seleccionado");
        $(this).addClass("seleccionado");
        cargarPagos(ingreso)
    });


    $(function () {
        $("tr").contextMenu({
            items  : createContextMenu,
            onShow : function ($element) {
                $element.addClass("trHighlight");
            },
            onHide : function ($element) {
                $(".trHighlight").removeClass("trHighlight");
            }
        });
    });

    function createContextMenu(node) {
        var $tr = $(node);
        var items = {
            header: {
                label: "Acciones",
                header: true
            }
        };

        var id = $tr.data("ing");

        var editar = {

            label  : "Editar",
            icon   : "fa fa-pencil",
            action : function ($element) {
//                var id = $element.data("id");
                editarIngreso(id);
            }
        };

        items.editar = editar;

        return items
    }

    function editarIngreso(id) {
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'ingreso', action:'ingreso_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : "Editar Pendiente",
//                    class   : "modal-sm",
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
                               return submitIngresoValor();
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

    function submitIngresoValor() {
        var $form = $("#frmIngresoValor");
        if ($form.valid()) {
            openLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    closeLoader();
                    if(msg == 'ok'){
                        log("Valor guardado correctamente","success");
                        cargarObligaciones(true);
                    }else{
                        if(msg == 'er'){
                            bootbox.alert("<i class='fa fa-exclamation-triangle fa-2x text-warning'></i>&nbsp; No puede ingresar un valor menor a la suma de los pagos");
                        }else{
                            log("Error al guardar el valor","error");
                        }

                    }
                }
            });
        } else {
            return false;
        } //else
    }


</script>