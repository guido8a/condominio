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
            <tr id="${dato.ingr__id}" data-id="${dato.ingr__id}" data-saldo="${dato.ingrsldo}" data-valor="${dato.ingrvlor}" class=" trIngreso ${z == 0 ? 'seleccionado' : ''}">
            %{--<tr id="${dato.egrs__id}" data-id="${dato.egrs__id}" data-tam="${condominio.PagoEgreso.findAllByEgreso(condominio.Egreso.get(dato.egrs__id)).size()}" --}%
                %{--class="${dato.egrssldo > 0 ? clase : ''} trEgreso ${z == 0 ? 'seleccionado' : ''} ${PagoEgreso.findByEgreso(Egreso.get(dato.egrs__id)).estado == 'R' ? 'revisado' : ''} ${dato.egrssldo > 0 ? 'saldo' : ''}">--}%

                <td width="30%">
                    ${dato?.ingrdscr}
                </td>

                <td width="28%" class="text-info">
                    ${dato?.ingrprsn}
                </td>

                <td width="12%" style="color:#186063">
                    ${dato?.ingrfcha}
                </td>
                <td width="10%" style="text-align: right">
                    ${dato.ingrvlor}
                </td>
                <td width="10%" class="text-info" style="text-align: right">
                    ${dato?.ingrsldo}
                </td>
            </tr>
        </g:each>
    </table>
</div>


<script type="text/javascript">

    cargarPagosE(${data[0]?.ingr__id}, ${data[0]?.ingrsldo}, ${data[0]?.ingrvlor});

    function cargarPagosE (ingreso, saldo, valor) {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'ingreso', action: 'infoIngreso_ajax')}',
            data:{
                ingreso: ingreso,
                saldo: saldo,
                valor: valor
            },
            success: function (msg){
                $("#tdPagosEgresos").html(msg)
            }
        });
    }

    $(".trIngreso").click(function () {
        var ingreso = $(this).attr("id");
        var valor = $(this).data("valor");
        var saldo = $(this).data("saldo");
        $(".trIngreso").removeClass("seleccionado");
        $(this).addClass("seleccionado");
        cargarPagosE(ingreso, saldo, valor)
    });
</script>
