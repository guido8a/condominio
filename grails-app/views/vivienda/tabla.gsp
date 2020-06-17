<%@ page import="condominio.Ingreso; condominio.Pago" %>


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
            <th>Estado</th>
            <th>Aplicar <g:checkBox name="ck_name" style="margin-left: 10px" class="todosCk" /></th>
            <th>Observaciones</th>
            <th>Borrar</th>
        </tr>
        </thead>
        <tbody>

        <g:each in="${personas}" var="prsn" status="i">
            <tr align="right">
                <td align="center" width="9%">
                    ${prsn?.edifdscr}
                </td>
                <td align="center" width="5%">
                    ${prsn?.prsndpto}
                </td>
                <td align="left" width="11%">
                    ${prsn?.prsnnmbr}
                </td>
                <td align="left" width="11%">
                    ${prsn?.prsnapll}
                </td>
                <td align="left" width="10%">
                    ${prsn?.tpocdscr}
                </td>
                <td class="${!Pago.findAllByIngreso(condominio.Ingreso.get(prsn?.ingr__id))?.estadoAdministrador?.contains("S") ? 'editable' : ''} alineacion ${prsn?.ingrvlor? '':'gris'}" id="${prsn?.prsn__id}"
                    data-original="${prsn?.ingrvlor}" data-valor="${prsn?.ingrvlor?:oblg.valor}"  data-ingr="${prsn?.ingr__id}"
                    data-obsrog="${prsn?.ingrobsr}"
                    style="width:12%" title="Ingrese el valor y presione Enter para aceptarlo">
                    <g:formatNumber number="${prsn?.ingrvlor?:oblg.valor}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/>
                </td>
                <td style="width: 4%; text-align: center">
                    ${prsn.ingretdo ?: ''}
                </td>
                <td style="text-align: center;" class="chk">
                    <g:if test="${!Pago.findAllByIngreso(condominio.Ingreso.get(prsn?.ingr__id))?.estadoAdministrador?.contains("S")}">
                        <g:checkBox name="ckl" class="seleccion"/>
                    </g:if>
                </td>
                <td class="observaciones">
                    <g:if test="${!Pago.findAllByIngreso(condominio.Ingreso.get(prsn?.ingr__id))?.estadoAdministrador?.contains("S")}">
                        <g:textField name="obsr" class="ingrobsr form-control-sm" value="${prsn?.ingrobsr}" style="width: 100%"/>
                    </g:if>
                    <g:else>
                        <g:textField name="obsr" class="ingrobsr form-control-sm" value="${prsn?.ingrobsr}" style="width: 100%" readonly=""/>
                    </g:else>
                </td>
                <td style="text-align: center">
                    <g:if test="${prsn?.ingrvlor}">
                        <g:if test="${!Pago.findAllByIngreso(condominio.Ingreso.get(prsn?.ingr__id))?.estadoAdministrador?.contains("S")}">
                            <a href="#" class="btn btn-danger btn-xs btnBorrarRegistro" data-id="${prsn?.prsn__id}" data-obl="${oblg.id}" title="Eliminar registro"><i class="fa fa-trash"></i> </a>
                            <a href="#" class="btn btn-success btn-xs btnCambiarEstado" data-id="${prsn?.prsn__id}" data-obl="${oblg.id}" title="Cambiar estado"><i class="fa fa-check"></i> </a>
                        </g:if>
                    </g:if>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

    Total de registros visualizados: ${params.totalRows}<br/>

    <script type="text/javascript" src="${resource(dir: 'js', file: 'tableHandler.js')}"></script>

    <script type="text/javascript">


        $(".btnBorrarRegistro").click(function () {
            var persona = $(this).data("id");
            var obligacion = $(this).data("obl");
            bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea poner en cero este registro?", function (res) {
                if (res) {
                    openLoader("Guardando Registro...");
                    $.ajax({
                        type    : "POST",
                        url : "${createLink(controller:'vivienda', action:'borrarRegistro_ajax')}",
                        data    : {
                            persona: persona,
                            obligacion: obligacion
                        },
                        success : function (msg) {
                            if(msg == 'ok'){
                                closeLoader();
                                log("Registro modificado correctamente","success");
                                setTimeout(function() {
                                    location.reload(true);
                                }, 1000);
                            }else{
                                closeLoader();
                                log("No se puede modificar este registro","error")
                            }
                        }
                    });
                }
            });
        });


        $(".todosCk").click(function () {
            var cc = $(".todosCk:checked").val();
            if(cc == 'on'){
                $(".seleccion").prop('checked',true);
            }else{
                $(".seleccion").prop('checked',false)
            }
        });


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
                }
            });

        }

        $(function () {
            $(".editable").first().addClass("selected");

            $(".num").click(function () {
                var num = $(this).attr("href");
                enviar(num);
                return false;
            });

        });


    </script>
</body>
</html>