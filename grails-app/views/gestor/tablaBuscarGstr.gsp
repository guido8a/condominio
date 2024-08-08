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
</style>

<g:set var="clase" value="${'principal'}"/>

<div class="" style="width: 99.7%;height: ${msg == '' ? 590 : 565}px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1060px">
        <g:each in="${data}" var="dato" status="z">

            <tr id="${dato.gstr__id}" data-id="${dato.gstr__id}" data-ed="${dato.gstretdo}" class="${clase}">
                <td width="130px">
                    ${dato?.tppsdscr}
                </td>

                <td width="700px" style="color:#186063">
                    ${dato?.gstrnmbr}
                </td>

                <td width="120px">
                    ${dato.gstretdo == 'R' ? 'Registrado' : 'No registrado'}
                </td>

                <td width="120px" class="text-info">
                    ${dato.tipo}
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
