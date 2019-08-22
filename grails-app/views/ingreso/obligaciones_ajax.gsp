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
        color: #953acb;
    }

    .verde{
        color: #53cf6d;
    }

    .seleccionado {
        border-color: #df960b;
        border-style: solid;
        border-width: 2px;
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
                    <tr class="trIngreso  ${i== 0 ? 'seleccionado' : ''}" ing="${ingr?.ingr__id}">
                        %{--<td>${ingr.obligacion.descripcion} ${ingr.observaciones? ': ' + ingr.observaciones :''}</td>--}%
                        <td>${condominio.Ingreso.get(ingr?.ingr__id)?.obligacion?.descripcion} ${ingr.ingrobsr ? ': ' + ingr.ingrobsr :''}</td>
                        %{--<td class="derecha"><g:formatNumber number="${ingr?.valor}" format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>--}%
                        <td class="derecha"><g:formatNumber number="${ingr?.ingrvlor}" format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>
                        <td class="derecha ${saldo > 0 ? 'azul' : 'verde'}"><g:formatNumber number="${saldo}" format="##,##0" locale="en_US" minFractionDigits="2" maxFractionDigits="2"/></td>
                    </tr>
                %{--</g:if>--}%
            </g:if>
            <g:else>
                %{--<tr class="trIngreso  ${i== 0 ? 'seleccionado' : ''}" ing="${ingr?.id}">--}%
                <tr class="trIngreso  ${i== 0 ? 'seleccionado' : ''}" ing="${ingr?.ingr__id}">
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

</script>