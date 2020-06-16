<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 16/06/20
  Time: 13:04
--%>
<div class="" style="width: 100%;height: 600px; overflow-y: auto;float: left; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="100%">
        <g:each in="${ingresos}" var="ingreso" status="z">
            <tr>
                <td width="30%">
                    ${dato?.egrsdscr}
                </td>

                <td width="28%" class="text-info">
                    ${dato?.prvenmbr}
                </td>

                <td width="12%" style="color:#186063">
                    ${dato?.egrsfcha}
                </td>
                <td width="10%" style="text-align: right">
                    ${dato.egrsvlor}
                </td>
                <td width="10%" class="text-info" style="text-align: right">
                    ${dato?.egrssldo}
                </td>
            </tr>
        </g:each>
    </table>
</div>