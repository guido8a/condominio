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
.noDeuda {
    background-color: #dedede;
    color: #444;
}
.externo {
    background-color: #ffdede;
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
<g:set var="clase2" value="${'noDeuda'}"/>

<div class="" style="width: 99.7%;height: ${msg == '' ? 600 : 575}px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1060px">
        <g:each in="${data}" var="dato" status="z">

            <tr id="${dato.prsn__id}" data-id="${dato.prsn__id}">
                <td width="4%" class="text-info">
                    ${dato?.prsndpto}
                </td>

                <td width="10%" style="color:#186063">
                    ${dato?.prsnnmbr}
                </td>
                <td width="12%">
                    ${dato.prsnapll}
                </td>

                <td width="50%" class="text-info">
                    ${dato?.propdtlle}
                </td>

                <td width="6%" class="text-info" style="text-align: right">
                    ${dato.proptotl}
                </td>

                <td width="6%" class="text-info">
                    ${dato.alctvlor}
                </td>

                <td width="6%" class="text-info">
                    ${dato.prsnalct}
                </td>

                <td width="6%" class="text-info" style="text-align: right">
                    ${dato.diff}
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
