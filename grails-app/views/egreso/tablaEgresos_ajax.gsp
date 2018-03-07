<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/03/18
  Time: 11:27
--%>


<style type="text/css">

.derecha{
    text-align: right;
}

</style>

<g:if test="${egresos.size() > 0}">
    <div class="" style="width: 100%;height: 260px; overflow-y: auto;float: right;" >
        <table class="table-bordered table-condensed table-hover" width="710px">
            <g:each in="${egresos}" var="egreso">
                <tr style="width: 100%">
                    <td style="width: 33%">${egreso.prve}</td>
                    <td style="width: 35%">${egreso.egrsdscr}</td>
                    <td style="width: 15%">${egreso.egrsfcha}</td>
                    <td class="derecha" style="width: 15%">${egreso.egrsvlor}</td>
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



