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
                <div class="col-md-1" align="center">
                <a href="${createLink(controller: "vivienda", action: "index")}" class="btn btn-primary">
                    <i class="fa fa-arrow-left"></i> Regresar
                </a>
                </div>

                <div class="col-md-1" align="center">Concepto de aportes</div>

                <div class="col-md-4" align="center">
                    <g:select class="form-control" name="obligaciones"
                              from="${condominio.Obligacion.list([sort: 'descripcion'])}" optionKey="id"
                              optionValue="${{ it.descripcion }}"
                              disabled="false" style="width: 380px;"/>
                </div>

                <div class="btn-group col-md-1">
                    <a href="#" class="btn btn-azul btn-consultar btn-sm"><i class="fa fa-search"></i> Consultar</a>
                </div>
                <div class="btn-group col-md-1">
                    <a href="#" class="btn btn-success btn-actualizar btn-sm"><i class="fa fa-save"></i> Guardar</a>
                </div>
                <div class="btn-group col-md-1">
                    <a href="#" class="btn btn-warning btn-generar btn-sm"><i class="fa fa-check"></i> Generar</a>
                </div>

                <div class="btn-group col-md-3">
                    <div class="col-md-2">Fecha</div>
                    <div class="col-md-8">
                    <elm:datepicker name="fecha" id="fechaOb" class="datepicker form-control required"
                                    value="${params.fecha?: new Date()}"/>
                    </div>
                </div>
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

                $(".btn-consultar").click(function () {
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