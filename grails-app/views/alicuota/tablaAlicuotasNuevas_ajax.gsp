<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 29/03/19
  Time: 10:54
--%>

<div class="" style="width: 100%;height: 400px; overflow-y: auto;float: right;" >
    <table class="table-bordered table-condensed table-hover" width="98%">
        <g:each in="${datos}" var="dato">
            <tr style="width: 100%">
                <td style="width: 17%">${dato.prsndpto}</td>
                <td style="width: 20%">${dato.prsnnmbr}</td>
                <td style="width: 20%">${dato.prsnapll}</td>
                <td style="width: 15%; text-align: right">${dato.alctvlor}</td>
                <td style="width: 15%; text-align: right; background-color: #ff983b">${dato.prsnalct}</td>
                <td style="width: 10%; text-align: right">${Math.abs(dato.diff)}</td>
            </tr>
        </g:each>
    </table>
</div>