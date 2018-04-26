<%@ page import="condominio.Obligacion" contentType="text/html;charset=UTF-8" %>
<html>

    <head>

        <meta name="layout" content="main">
        <title>Generación de Ingresos</title>

        <script type="text/javascript" src="${resource(dir: 'js', file: 'tableHandlerBody.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'tableHandler.js')}"></script>
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'tableHandler.css')}">

    </head>

    <body>

        <fieldset class="borde">
            <div class="row" style="margin-bottom: 20px;">
                <div class="col-sm-1" align="center" style="margin-top: 20px">
                <a href="${createLink(controller: "vivienda", action: "index")}" class="btn btn-primary" style="width: 100px;">
                    <i class="fa fa-arrow-left"></i> Regresar
                </a>
                </div>

                <div class="col-sm-2" style="margin-left: 17px">
                Tipo de Aporte
                    <g:select from="${condominio.TipoAporte.list()}" optionValue="descripcion" optionKey="id"
                              name="tp" id="tipoAporte" class="form-control"/>
                </div>

                <div class="col-sm-3" style="margin-left: -20px">
                    Obligaciones
                    <a href="#" id="btn-nuevo" style="margin-top: 17px; margin-left: 20px;"><i class="fa fa-file"></i> Crear nueva</a>
                    <a href="#" id="btn-nuevo" style="margin-top: 17px; margin-left: 20px;"><i class="fa fa-pencil"></i> Editar</a>
                    <div id="divObligaciones">

                    </div>

                </div>

                <div class="btn-group col-sm-2" style="width: 160px; margin-left: -20px">

                    Fecha
                        <elm:datepicker name="fecha" id="fechaOb" class="datepicker form-control required"
                                        value="${params.fecha?: new Date()}"/>
                </div>


                <div class="btn-group col-sm-1" style="margin-top: 17px">

                    <a href="#" class="btn btn-azul" id="btn-consultar"><i class="fa fa-search"></i></a>
                </div>
                <div class="btn-group col-sm-3" style="margin-top: 17px; margin-left: -40px; width: 280px;">
                    <a href="#" class="btn btn-success btn-actualizar"><i class="fa fa-save"></i> Guardar</a>
                    <a href="#" class="btn btn-warning btn-generar" style="margin-left: 10px"><i class="fa fa-users"></i> Aliícuotas</a>
                </div>

%{--
                <div class="btn-group col-md-1">

                </div>
--}%

            </div>

        </fieldset>


        <fieldset class="borde" %{--style="width: 1170px"--}%>

            <div id="divTabla" style="height: 760px; overflow-y:auto; overflow-x: hidden;">

            </div>


            <fieldset class="borde hide" style="width: 1170px; height: 58px" id="error">

                <div class="alert alert-error">

                    <h4 style="margin-left: 450px">No existen datos!!</h4>

                    <div style="margin-left: 420px">
                        Ingrese los parámetros de búsqueda!

                    </div>
                </div>

            </fieldset>

        </fieldset>



        <script type="text/javascript">


            cargarObligaciones($("#tipoAporte").val());

            $("#tipoAporte").change(function () {
                var ta = $(this).val();
                cargarObligaciones(ta);
            });


            function cargarObligaciones (ta) {
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'vivienda', action: 'obligaciones_ajax')}',
                    data:{
                        tipoAporte: ta
                    },
                    success: function (msg){
                        $("#divObligaciones").html(msg)
                    }
                });
            }


            $(".btn-generar").click(function () {
                $.ajax({
                   type:'POST',
                    url:'${createLink(controller: 'vivienda', action: 'generar_ajax')}',
                    data:{
                    },
                    success: function (msg){
                        var b = bootbox.dialog({
                            id      : "dlgGenerar",
                            title   : "Generar alícuotas por mes",
                            message : msg,
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                }
                            } //buttons
                        }); //dialog
                    }
                });
            });

            function consultar() {
                var oblg = $("#obligaciones").val();

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'tabla')}",
                    data    : {
                        oblg  : oblg
                    },
                    success : function (msg) {
                        $("#divTabla").html(msg);
                    }
                });
            }

            $(function () {
//        $("#todos").click(function () {
//            var fecha2 = new Date().toString("dd-MM-yyyy");
////            ////console.log(fecha2);
//            if ($("#todos").attr("checked") == "checked") {
////
//                $("#fecha").attr("value", fecha2);
//            }
//            else {
////               )
//            }
//        });

                $("#btn-consultar").click(function () {
                    var lgar = $("#listaPrecio").val();
                    if (lgar != -1) {
                        $("#error").hide();
                        consultar();
                        $("#divTabla").show();
                    }
                    else {
                        $("#divTabla").html("").hide();
                        $("#error").show();
                    }
                });

                $(".btn-actualizar").click(function () {
//                    $("#dlgLoad").dialog("open");
                    var data = "";

                    var fcha = $("#fechaOb").val();
                    var oblg  = $("#obligaciones").val();

                    $(".editable").each(function () {
                        var id = $(this).attr("id");
                        var valor = $(this).data("valor");
                        var data1 = $(this).data("original");
                        var ingr  = $(this).data("ingr");
                        var obsrog = $(this).data("obsrog");

                        var chk = $(this).siblings(".chk").children("input").is(":checked");
//                        console.log(chk);
                        var obsr = $(this).siblings(".observaciones").children("input").val();

                        if(chk && (obsr != obsrog) && (ingr)){
//                            console.log('obsr:', obsr, 'obsrog:', obsrog);
                            if(data != '') {
                                data += "&"
                            }
                            data += "&obsr=" + id + "_id" + ingr + "_ob" + obsr
//                            console.log('obsr:', obsr, 'data:', data);
                        }
//                        console.log('data:', data)
                        if (chk && (parseFloat(valor) > 0 && parseFloat(data1) != parseFloat(valor))) {
                            if (data != "") {
                                data += "&";
                            }
                            var val = valor ? valor : data1;
                            if(obsr != obsrog) {
                                data += "&item=" + id + "_" + val + "_id" + ingr + "_ob" + obsr;// + "_" + chk;
                            } else {
                                data += "&item=" + id + "_" + val + "_id" + ingr;// + "_" + chk;
                            }

                        }
                    });
//                    console.log('data -->', data);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action: 'actualizar')}",
                        data    : data + "&fecha=" + fcha + "&oblg=" + oblg,
                        success : function (msg) {
//                            $("#dlgLoad").dialog("close");
                            var parts = msg.split("_");
                            var ok = parts[0];
                            var no = parts[1];

                            $(ok).each(function () {
                                var fec = $(this).siblings(".fecha");
                                fec.text($("#fecha").val());
                                var $tdChk = $(this).siblings(".chk");
                                var chk = $tdChk.children("input").is(":checked");
                                if (chk) {
                                    $tdChk.html('<i class="icon-ok"></i>');
                                }
                            });

                            doHighlight({elem : $(ok), clase : "ok"});
                            doHighlight({elem : $(no), clase : "no"});
                            $(ok).removeClass('gris');

                        }
                    });
                });
            });
        </script>
    </body>
</html>