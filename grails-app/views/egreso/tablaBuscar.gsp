<%@ page import="condominio.Egreso; condominio.PagoEgreso" %>
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

.deuda {
    background-color: #ffefef;
    color: #444;
}
.reg {
    color: #286e9f;
}
.seleccionado {
    border-color: #df960b;
    border-style: solid;
    border-width: medium;
    background-color: #e0e8ff;
}

.noReg {
    font-weight: bold;
    color: #aa6;
}
</style>

<g:set var="clase" value="${'deuda'}"/>

<div class="" style="width: 100%;height: ${msg == '' ? 600 : 575}px; overflow-y: auto;float: left; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="100%">
        <g:each in="${data}" var="dato" status="z">

            <tr id="${dato.egrs__id}" data-id="${dato.egrs__id}" data-tam="${condominio.PagoEgreso.findAllByEgreso(condominio.Egreso.get(dato.egrs__id)).size()}" class="${dato.egrssldo > 0 ? clase : ''} trEgreso ${z == 0 ? 'seleccionado' : ''}">
                <td width="32%">
                    ${dato?.egrsdscr}
                </td>

                <td width="30%" class="text-info">
                    ${dato?.prvenmbr}
                </td>

                <td width="12%" style="color:#186063">
                    ${dato?.egrsfcha}
                </td>

                %{--<td width="40px" class="${dato.prsnetdo == 'R-S' ? 'registrado' : dato.prsnetdo == 'R' ? 'reg' : 'noReg'}">--}%
                <td width="8%">
                    ${dato.egrsvlor}
                </td>

                <td width="8%" class="text-info">
                    ${dato?.egrssldo}
                </td>

            </tr>
        </g:each>
    </table>
</div>


<script type="text/javascript">
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

    cargarPagosE(${data[0]?.egrs__id});

    function cargarPagosE (egreso) {
//        console.log('carga pagos')
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'egreso', action: 'pagoEgresos_ajax')}',
            data:{
                egreso: egreso
            },
            success: function (msg){
                $("#tdPagosEgresos").html(msg)
            }
        });
    }

    $(".trEgreso").click(function () {
        var egreso = $(this).attr("id");
        $(".trEgreso").removeClass("seleccionado")
        $(this).addClass("seleccionado")
        cargarPagosE(egreso)
    });
</script>
