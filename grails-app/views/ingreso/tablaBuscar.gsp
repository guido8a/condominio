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
<g:set var="totalValor" value="${0}"/>
<g:set var="totalSaldo" value="${0}"/>

<g:if test="${data.size() > 0}">
    <div class="" style="width: 100%;height: 410px; overflow-y: auto;float: left; margin-top: -20px">
        <table class="table-bordered table-condensed table-hover" width="100%">
            <g:each in="${data}" var="dato" status="z">
                <tr id="${dato.ingr__id}" data-id="${dato.ingr__id}" data-saldo="${dato.ingrsldo}" data-valor="${dato.ingrvlor}" class=" trIngreso ${z == 0 ? 'seleccionado' : ''}">
                    <td width="16%">
                        ${dato?.tpapdscr.size()>12? dato?.tpapdscr[0..12] + '..' : dato?.tpapdscr}
                    </td>
                    <td width="24%">
                        ${dato?.ingrdscr}
                    </td>
                    <td width="18%" class="text-info">
                        ${dato?.ingrprsn}
                    </td>

                    <td width="12%" style="color:#186063">
                        ${dato?.ingrfcha}
                    </td>
                    <td width="10%" style="text-align: right">
                        ${dato.ingrvlor}
                    </td>
                    <g:set var="totalValor" value="${totalValor += dato.ingrvlor}"/>
                    <td width="10%" class="text-info" style="text-align: right">
                        ${dato?.ingrsldo}
                    </td>
                    <g:set var="totalSaldo" value="${totalSaldo += dato.ingrsldo}"/>
                </tr>
            </g:each>
        </table>
    </div>
    <div>
        <table class="table table-bordered table-hover table-condensed">
            <thead>
            <tr>
                <th style="width: 44%; text-align: left !important;">* Número de registros: ${data.size()}</th>
                <th style="width: 32%; text-align: right !important;">Totales  </th>
                <th class="alinear" style="width: 11%">${totalValor}</th>
                <th class="alinear" style="width: 11%">${totalSaldo}</th>
                <th class="alinear" style="width: 2%"></th>
            </tr>
            </thead>
        </table>
    </div>
</g:if>
<g:else>
    <div class="alert alert-danger centro">
        No existen registros!
    </div>
</g:else>

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
