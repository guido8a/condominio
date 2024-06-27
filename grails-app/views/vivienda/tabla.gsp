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

    <table class="table table-bordered table-hover table-condensed">
        <thead>
        <tr align="center">
            <th>Edificio</th>
            <th>Depto.</th>
            <th>Nombres</th>
            <th>Apellidos</th>
            <th>Fecha</th>
            <th>Valor</th>
            <th>Estado</th>
            <th>Aplicar <g:checkBox name="ck_name" style="margin-left: 10px" class="todosCk" /></th>
            <th>Observaciones</th>
            <th>Borrar</th>
            <th>Editar</th>
        </tr>
        </thead>
        <tbody>

        <g:each in="${personas}" var="prsn" status="i">
            <tr align="right" style="${prsn.ingretdo == 'B' ? 'background-color: #bcbec7;' : ''}">
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
                    ${prsn?.ingrfcha?.format('dd-MMM-yyyy')}
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
                        <g:if test="${!Pago.findAllByIngreso(Ingreso.get(prsn.ingr__id))}">
                            <g:checkBox name="ckl" class="seleccion"/>
                        </g:if>
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
                            <g:if test="${!Pago.findAllByIngreso(Ingreso.get(prsn.ingr__id))}">
                                <a href="#" class="btn btn-danger btn-xs btnBorrarRegistro" data-id="${prsn?.prsn__id}" data-obl="${oblg.id}" title="Eliminar registro"><i class="fa fa-trash"></i> </a>
                            </g:if>
                            <g:if test="${prsn.ingretdo != 'B'}">
                                <g:if test="${band}">
                                    <a href="#" class="btn btn-success btn-xs btnCambiarEstado" data-id="${prsn?.ingr__id}" title="Cambiar estado"><i class="fa fa-check"></i> </a>
                                </g:if>
                            </g:if>
                        </g:if>
                    </g:if>
                </td>
                <td style="text-align: center">
                    <g:if test="${prsn?.ingrvlor}">
                        <g:if test="${!Pago.findAllByIngreso(condominio.Ingreso.get(prsn?.ingr__id))?.estadoAdministrador?.contains("S")}">
                            <g:if test="${!Pago.findAllByIngreso(Ingreso.get(prsn.ingr__id))}">
                                <a href="#" class="btn btn-info btn-xs btnEditarFecha" data-id="${prsn?.prsn__id}" data-obl="${oblg.id}" title="Editar fecha"><i class="fa fa-calendar"></i> </a>
                            </g:if>
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

        $(".btnEditarFecha").click(function () {
            var persona = $(this).data("id");
            var obligacion = $(this).data("obl");
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'vivienda', action:'fecha_ajax')}",
                data    : {
                    persona: persona,
                    obligacion: obligacion
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEditFecha",
                        title   : "Modificar Fecha",
                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            guardar  : {
                                id        : "btnSave",
                                label     : "<i class='fa fa-save'></i> Guardar",
                                className : "btn-success",
                                callback  : function () {
                                    var fecha = $("#fechaIngreso").val();
                                    openLoader("Guardando...");
                                    $.ajax({
                                        type    : "POST",
                                        url : "${createLink(controller:'vivienda', action:'guardarFecha_ajax')}",
                                        data    : {
                                            persona: persona,
                                            obligacion: obligacion,
                                            fecha: fecha
                                        },
                                        success : function (msg) {
                                            closeLoader();
                                            if(msg == 'ok'){
                                                log("Guardado correctamente","success");
                                                setTimeout(function() {
                                                    location.reload(true);
                                                }, 1000);
                                            }else{
                                                closeLoader();
                                                log("Error al guardar la fecha","error")
                                            }
                                        }
                                    });
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
        });

        $(".btnCambiarEstado").click(function () {
            var id = $(this).data("id");
            bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-warning'></i>" + "<strong>" +  "Está seguro que desea cambiar el estado?" + "</strong>", function (res) {
                if (res) {
                    openLoader("Guardando...");
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'vivienda', action: 'cambiarEstado_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg){
                            closeLoader();
                            if(msg == 'ok'){
                                log("Estado cambiado correctamente","success");
                                setTimeout(function() {
                                    location.reload(true);
                                }, 1000);
                            }else{
                                log("Error al cambiar el estado","error");
                            }
                        }
                    });
                }
            });
        });

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