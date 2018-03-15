<%@ page import="condominio.Pago" %>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 15/03/18
  Time: 10:13
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
        <g:each in="${ingreso}" status="i" var="ingr">
            <g:set var="saldo" value="${ingr?.valor?.toDouble() - (Pago.findAllByIngreso(ingr).valor?.sum()?.toDouble() ?: 0)}"/>
            <tr class="trIngreso" ing="${ingr?.id}">
                <td>${ingr.obligacion.descripcion} ${ingr.observaciones? ': ' + ingr.observaciones :''}</td>
                <td class="derecha"><g:formatNumber number="${ingr?.valor}" format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td class="derecha ${saldo > 0 ? 'azul' : 'verde'}"><g:formatNumber number="${saldo}" format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>
            </tr>
        </g:each>
    </table>
</div>


<script type="text/javascript">

    cargarPagos(${ingreso[0]?.id});

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
        cargarPagos(ingreso)
    });

</script>