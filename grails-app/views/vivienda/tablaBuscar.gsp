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

.noActivo {
    background-color: #efefef;
    color: #444;
}
.reg {
    color: #286e9f;
}
.noReg {
    font-weight: bold;
    color: #aa6;
}
</style>

<g:set var="clase" value="${'noActivo'}"/>

<div class="" style="width: 99.7%;height: ${msg == '' ? 600 : 575}px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1060px">
        <g:each in="${data}" var="dato" status="z">

            <tr id="${dato.prsn__id}" data-id="${dato.prsn__id}" class="${dato.prsnactv == 0 ? clase : ''}">
                <td width="6%">
                    ${dato?.edifdscr}
                </td>

                <td width="20%" style="color:#186063">
                    ${dato?.prsnnmbr}
                </td>

                %{--<td width="40px" class="${dato.prsnetdo == 'R-S' ? 'registrado' : dato.prsnetdo == 'R' ? 'reg' : 'noReg'}">--}%
                <td width="20%">
                    ${dato.prsnapll}
                </td>

                <td width="7%" class="text-info">
                    ${dato?.prsndpto}
                </td>

                <td width="4%" class="text-info">
                    ${dato?.tpoccdgo}
                </td>

                <td width="10%" class="text-info">
                    ${dato.prsntelf}
                </td>

                <td width="15%" class="text-info">
                    ${dato.prsnmail}
                </td>

                <td width="8%" class="text-info" style="text-align: right">
                    ${dato.alctvlor}
                </td>
                <td width="10%" class="text-info" style="text-align: right">
                    ${dato?.prsncrgo}
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
</script>
