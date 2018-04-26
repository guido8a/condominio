<html>

    <head>

        <style type="text/css">
        .alineacion {
            text-align : right !important
        }
        .gris {
            background-color: #efefef;
            color: #a0a0a0;
        }

        </style>

    </head>

    <body>

        <div id="tabla">

            %{--<table class="table table-bordered table-striped table-hover table-condensed" id="tablaPrecios">--}%
            <table class="table table-bordered table-hover table-condensed">
                %{--<thead style="background-color:#0074cc;">--}%
                <thead>
                    <tr align="center">
                        <th>Edificio</th>
                        <th>Depto.</th>
                        <th>Nombres</th>
                        <th>Apellidos</th>
                        <th>Propietario</th>
                        <th>Valor</th>
                        <th>Aplicar <input type="checkbox" id="todosCk"/></th>
                        <th>Observaciones</th>
                    </tr>
                </thead>
                <tbody>

                    <g:each in="${personas}" var="prsn" status="i">
                        <tr align="right">
                            <td align="center" width="10%">
                                ${prsn?.edifdscr}
                            </td>
                            <td align="center" width="6%">
                                ${prsn?.prsndpto}
                            </td>
                            <td align="left" width="12%">
                                ${prsn?.prsnnmbr}
                            </td>
                            <td align="left" width="12%">
                                ${prsn?.prsnapll}
                            </td>
                            <td align="left" width="10%">
                                ${prsn?.tpocdscr}
                            </td>
                            <td class="editable alineacion ${prsn?.ingrvlor? '':'gris'}" id="${prsn?.prsn__id}"
                                data-original="${prsn?.ingrvlor}" data-valor="${prsn?.ingrvlor?:oblg.valor}"  data-ingr="${prsn?.ingr__id}"
                                data-obsrog="${prsn?.ingrobsr}"
                                style="width:12%">
                                <g:formatNumber number="${prsn?.ingrvlor?:oblg.valor}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/>
                            </td>
                            <td style="text-align: center;" class="chk">
                                <input type="checkbox"/>
                            </td>
                            <td class="observaciones">
                                <g:textField name="obsr" class="ingrobsr form-control-sm" value="${prsn?.ingrobsr}" style="width: 100%"/>
                            </td>

                        </tr>
                    </g:each>
                </tbody>
            </table>

            Total de registros visualizados: ${params.totalRows}<br/>

            <script type="text/javascript" src="${resource(dir: 'js', file: 'tableHandler.js')}"></script>

            <script type="text/javascript">

                function enviar(pag) {

                    var reg = "RN";
//                    if ($("#reg").hasClass("active")) {
//                        reg += "R";
//                    }
//                    if ($("#nreg").hasClass("active")) {
//                        reg += "N";
//                    }
//
//                    if (reg == "") {
//                        $("#reg").addClass("active");
//                        $("#nreg").addClass("active");
//                        reg = "RN";
//                    }

                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'tabla')}",
                        data    : {
                            oblg  : "${params.oblg}",
                            tipo  : "${params.tipo}"
                        },
                        success : function (msg) {
                            $("#divTabla").html(msg);
//                            $("#dlgLoad").dialog("close");
                        }
                    });

                }

                $(function () {

                    $(".editable").first().addClass("selected");

                    $(".num").click(function () {
//                        $("#dlgLoad").dialog("open");

                        var num = $(this).attr("href");
                        enviar(num);
                        return false;
                    });

//                    $("#dlgLoad").dialog("close");
                });




            </script>

    </body>

</html>