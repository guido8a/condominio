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

<div style="text-align: center; margin-top: -30px;">
    <h3>Registro de Aportes</h3>
</div>

<fieldset class="borde">
    <div class="row" style="margin-bottom: 20px;">
        <div class="col-sm-1" align="center" style="margin-top: 20px">
            <a href="${createLink(controller: "vivienda", action: "index")}" class="btn btn-primary">
                <i class="fa fa-arrow-left"></i>
            </a>
        </div>

        <div class="col-sm-2" style="margin-left: -30px">
            Tipo de Aporte
            <g:select from="${condominio.TipoAporte.findAllByIdGreaterThan(1, [sort: 'descripcion'])}" optionValue="descripcion" optionKey="id"
                      name="tp" id="tipoAporte" class="form-control" style="width: 180px;"/>
        </div>

        <div class="col-sm-3" style="margin-left: 0px; width: 320px">
            Concepto del Aporte
            %{--<a href="#" id="btnNuevaOb" style="margin-top: 17px; margin-left: 20px;" class="hidden"><i class="fa fa-file"></i> Nueva</a>--}%
            %{--<a href="#" id="btnEditarOb" style="margin-top: 17px; margin-left: 20px;" class="hidden"><i class="fa fa-pencil"></i> Editar</a>--}%
            <a href="#" id="btnNuevaOb" style="margin-top: 17px; margin-left: 20px;"><i class="fa fa-file"></i> Nueva</a>
            <a href="#" id="btnEditarOb" style="margin-top: 17px; margin-left: 20px;"><i class="fa fa-pencil"></i> Editar</a>
            <div id="divObligaciones">

            </div>
        </div>

        %{--
                <div class="btn-group col-sm-1" style="width: 40px; margin-left: -28px; margin-top: 20px">
                    <a href="${createLink(controller: "vivienda", action: "index")}" class="btn btn-primary">
                        <i class="fa fa-file-o"></i>
                    </a>
                </div>
        --}%

        <div class="btn-group col-sm-2 text-info" style="width: 160px; margin-left: -25px;">
            <strong>Fecha</strong>
            <elm:datepicker name="fechaOb_name" id="fechaOb" class="datepicker form-control required"
                            value="${params.fecha?: new Date()}"/>
        </div>


        <div class="btn-group col-sm-1" style="margin-top: 17px; margin-left: -20px; width: 150px">
            <a href="#" class="btn btn-azul" id="btn-consultar"><i class="fa fa-search"></i> Ingresar/Buscar</a>
        </div>
        <div class="btn-group col-sm-3" style="margin-top: 17px; margin-left: -0px; width: 300px;">
            <a href="#" class="btn btn-success btn-actualizar"><i class="fa fa-save"></i> Guardar</a>
            <a href="#" class="btn btn-warning btn-generar" style="margin-left: 5px"><i class="fa fa-users"></i> Generar Alíc.</a>
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

    $("#tipoAporte").change(function () {
        var tpp = $(this).val();
//        cargarBotones(tpp)
    });

    /*
     function cargarBotones (tipo) {
     if(tipo != '10'){
     $("#btnNuevaOb").removeClass("hidden");
     $("#btnEditarOb").removeClass("hidden")
     }else{
     $("#btnNuevaOb").addClass("hidden");
     $("#btnEditarOb").addClass("hidden")
     }
     }
     */

    $("#btnNuevaOb").click(function () {
        createEditRow();
    });

    $("#btnEditarOb").click(function () {
        var idOb = $("#obligaciones").val();
        createEditRow(idOb);
    });


    function submitFormObligacion() {
        var $form = $("#frmObligacion");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {

            if(verificarDescripcion()){
//                $btn.replaceWith(spinner);
//                openLoader("Guardando Obligación");
//                $.ajax({
//                    type    : "POST",
//                    url     : $form.attr("action"),
//                    data    : $form.serialize(),
//                    success : function (msg) {
//                        var parts = msg.split("*");
//                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
//                        setTimeout(function() {
//                            if (parts[0] == "SUCCESS") {
//                                location.reload(true);
//                            } else {
//                                spinner.replaceWith($btn);
//                                return false;
//                            }
//                        }, 1000);
//                    }
//                });
            }else{
                bootbox.alert("<i class='fa fa-triangle-exclamation fa-2x text-warning'></i> Esta descripción ya fue ingresada!");
                return false;
            }
        } else {
            return false;
        } //else
    }

    function verificarDescripcion(){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'vivienda', action: 'verificarDescripcion_ajax')}",
            data    : {
                texto : $("#descripcionObligacion").val()
            },
            success : function (msg) {
                if(msg == 'ok'){
                    return true
                }else{
                    return false
                }
            }
        });
    }

    function createEditRow(id) {
        var title = id ? "Editar" : "Nueva";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'obligacion', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Obligación",
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
                                return submitFormObligacion();
//                                return verificarDescripcion();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

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
            var oblg = $("#obligaciones").val();
            console.log("oblg " + oblg)
            if (lgar != -1) {
                $("#error").hide();

                if(oblg != '' && oblg != null){
                    consultar();
                    $("#divTabla").show();
                }else{
                    $("#divTabla").html("").hide();
                    bootbox.alert("Seleccione un concepto del aporte")
                }
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
                    console.log('obsr:', obsr, 'obsrog:', obsrog);
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