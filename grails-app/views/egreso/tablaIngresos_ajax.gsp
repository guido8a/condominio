<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/03/18
  Time: 10:57
--%>


<style type="text/css">

    .derecha{
        text-align: right;
    }

</style>

<g:if test="${ingresos.size() > 0}">
<div class="" style="width: 100%;height: 260px; overflow-y: auto;float: right;" >
    <table class="table-bordered table-condensed table-hover" width="710px">
        <g:each in="${ingresos}" var="ingreso">
            <tr style="width: 100%">
                <td style="width: 10%">${ingreso.prsndpto}</td>
                <td style="width: 15%">${ingreso.tpocdscr}</td>
                <td style="width: 22%">${ingreso.prsn}</td>
                <td style="width: 23%">${ingreso.pagodscr}</td>
                <td style="width: 15%">${ingreso.pagofcha}</td>
                <td class="derecha" style="width: 15%">${ingreso.pagovlor}</td>
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