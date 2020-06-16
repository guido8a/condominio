<%@ page import="condominio.Egreso; condominio.PagoEgreso" %>
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

.deuda {
    background-color: #ffefef;
    color: #444;
}
.reg {
    color: #286e9f;
}
.seleccionado {
    border-color: #df960b;
    border-style: solid;
    border-width: medium;
    background-color: #e0e8ff;
}

.noReg {
    font-weight: bold;
    color: #aa6;
}
</style>

<g:set var="clase" value="${'deuda'}"/>

<div class="" style="width: 100%;height: ${msg == '' ? 600 : 575}px; overflow-y: auto;float: left; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="100%">
        <g:each in="${data}" var="dato" status="z">
            <tr id="${dato.ingr__id}" data-id="${dato.ingr__id}">
                <td width="30%">
                    ${dato?.ingrdscr}
                </td>

                <td width="28%" class="text-info">
                    ${dato?.ingrprsn}
                </td>

                <td width="12%" style="color:#186063">
                    ${dato?.ingrfcha}
                </td>
                <td width="10%" style="text-align: right">
                    ${dato.ingrvlor}
                </td>
                <td width="10%" class="text-info" style="text-align: right">
                    ${dato?.ingrsldo}
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

    cargarPagosE(${data[0]?.ingr__id});

    function cargarPagosE (egreso) {
//        console.log('carga pagos')
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
        var egreso = $(this).attr("id");
        $(".trEgreso").removeClass("seleccionado")
        $(this).addClass("seleccionado")
        cargarPagosE(egreso)
    });
</script>
