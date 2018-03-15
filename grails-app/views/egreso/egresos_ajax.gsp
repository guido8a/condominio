<%@ page import="condominio.PagoEgreso" %>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 15/03/18
  Time: 15:04
--%>

<style type="text/css">

.derecha{
    text-align: right;
}

.azul{
    color: #353acb;
}

.verde{
    color: #53cf6d;
}

</style>


<div class="" style="width: 100%;height: 300px; overflow-y: auto;">
    <table class="table-bordered table-condensed table-hover" width="100%">
        <g:each in="${egresos}" status="i" var="egreso">
            <g:set var="saldo" value="${egreso?.valor?.toDouble() - (condominio.PagoEgreso.findAllByEgreso(egreso).valor?.sum()?.toDouble() ?: 0)}"/>
            <tr class="trEgreso" egr="${egreso?.id}">
                <td>${egreso?.descripcion}</td>
                <td class="derecha">${egreso?.proveedor?.nombre + " " + (egreso?.proveedor?.apellido ?: '')}</td>
                <td class="derecha"><g:formatNumber number="${egreso?.valor}" format="##,##0" locale="en" maxFractionDigits="2" minFractionDigits="2"/></td>
                <td class="derecha ${saldo > 0 ? 'azul' : 'verde'}"><g:formatNumber number="${saldo}" format="##,##0" locale="en" maxFractionDigits="2" minFractionDigits="2"/></td>
            </tr>
        </g:each>
    </table>
</div>


<script type="text/javascript">

    cargarPagosE(${egresos[0]?.id});

    function cargarPagosE (egreso) {
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
        var egreso = $(this).attr("egr");
        cargarPagosE(egreso)
    });

</script>