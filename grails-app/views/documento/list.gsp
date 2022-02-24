
<%@ page import="condominio.Documento" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Documentos</title>


    <style type="text/css">
    .file {
        width    : 100%;
        height   : 40px;
        margin   : 0;
        position : absolute;
        top      : 0;
        left     : 0;
        opacity  : 0;
    }

    .fileContainer {
        width         : 100%;
        /*height: 290px;*/
        border        : 2px solid #327BBA;
        padding       : 15px;
        margin-top    : 10px;
        margin-bottom : 10px;
    }

    .etiqueta {
        font-weight : bold;
    }

    .titulo-archivo {
        font-weight : bold;
        font-size   : 18px;
    }

    .progress-bar-svt {
        border     : 1px solid #e5e5e5;
        width      : 100%;
        height     : 25px;
        background : #F5F5F5;
        padding    : 0;
        margin-top : 10px;
    }

    .progress-svt {
        width            : 0;
        height           : 23px;
        padding-top      : 5px;
        padding-bottom   : 2px;
        background-color : #428BCA;
        text-align       : center;
        line-height      : 100%;
        font-size        : 14px;
        font-weight      : bold;
    }

    .background-image {
        background-image  : -webkit-linear-gradient(45deg, rgba(255, 255, 255, .15) 10%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
        background-image  : linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
        -webkit-animation : progress-bar-stripes-svt 2s linear infinite;
        background-size   : 60px 60px; /*importante, el tamanio tiene que respetarse en la animacion */
        animation         : progress-bar-stripes-svt 2s linear infinite;
    }

    @-webkit-keyframes progress-bar-stripes-svt {
        /*el x del from tiene que ser multiplo del x del background size...... mientas mas grande mas rapida es la animacion*/
        from {
            background-position : 120px 0;
        }
        to {
            background-position : 0 0;
        }
    }

    @keyframes progress-bar-stripes-svt {
        from {
            background-position : 120px 0;
        }
        to {
            background-position : 0 0;
        }
    }

    </style>


</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    %{--<div class="btn-group">--}%
    %{--<i class="glyphicon glyphicon-plus"></i>--}%
    %{--<span>Subir documento</span>--}%
    %{--<input type="file" name="file" id="file" class="file" multiple accept=".doc, .docx, .pdf, .odt, .xls, .xlsx, .jpeg, .jpg, .png">--}%
    %{--</div>--}%


    <span class="btn btn-success fileinput-button" style="position: relative;height: 35px;margin-top: 10px">
        <i class="glyphicon glyphicon-plus"></i>
        <span>Subir documento</span>
        <input type="file" name="file" id="file" class="file" multiple accept=".doc, .docx, .pdf, .odt, .xls, .xlsx, .jpeg, .jpg, .png">
    </span>

    %{--<g:uploadForm action="uploadFile" method="post" name="frmUpload" id="${condominio?.id}">--}%
    %{--<div id="list-grupo" class="span12" role="main" style="margin: 10px 0 0 0;">--}%
    %{--<div class="row-fluid" style="margin: 0 0 20px 0;">--}%
    %{--<div class="span9">--}%

    %{--</div>--}%
    %{--</div>--}%

    %{--<div class="row-fluid" style="margin-left: 0px">--}%
    %{--<div class="span12">--}%
    %{--<div class="span2"><b>Archivo:</b></div>--}%
    %{--<input type="file" class="required" id="file" name="file"/>--}%

    %{--</div>--}%
    %{--<div class="span4">--}%
    %{--<a href="#" class="btn btn-success" id="btnSubmit"><i class="fa fa-upload"></i> Subir Archivo</a>--}%
    %{--</div>--}%
    %{--</div>--}%
    %{--</div>--}%
    %{--</g:uploadForm>--}%


</div>



<div style="margin-top:15px;margin-bottom: 20px" class="vertical-container" id="files">
    %{--<p class="css-vertical-text" id="titulo-arch" style="display: none">Archivos</p>--}%

    <div class="linea" id="linea-arch" style="display: none"></div>
</div>
<div id="anexos">

</div>


<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th style="width: 15%">Condominio</th>
        <th style="width: 15%">Tipo Documento</th>
        <th style="width: 20%">Descripción</th>
        <th style="width: 50%">Resumen</th>
    </tr>
    </thead>
    <tbody>
    <g:if test="${documentos.size() > 0}">
        <g:each in="${documentos}" status="i" var="documentoInstance">
            <tr data-id="${documentoInstance.id}">
                <td  style="width: 20%">${documentoInstance.condominio}</td>
                <td  style="width: 20%">${documentoInstance.tipoDocumento?.descripcion}</td>
                <td  style="width: 20%">${documentoInstance.descripcion}</td>
                <td  style="width: 50%">${documentoInstance.resumen}</td>
            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="6">
                <g:if test="${params.search && params.search!= ''}">
                    No se encontraron resultados para su búsqueda
                </g:if>
                <g:else>
                    No se encontraron registros que mostrar
                </g:else>
            </td>
        </tr>
    </g:else>
    </tbody>
</table>


<script type="text/javascript">

    var okContents = {
        'image/png'  : "png",
        'image/jpeg' : "jpeg",
        'image/jpg'  : "jpg",

        'application/pdf'        : 'pdf',
        'application/download'   : 'pdf',
        'application/vnd.ms-pdf' : 'pdf',

        'application/excel'                                                 : 'xls',
        'application/vnd.ms-excel'                                          : 'xls',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' : 'xlsx',

        'application/mspowerpoint'                                                  : 'pps',
        'application/vnd.ms-powerpoint'                                             : 'pps',
        'application/powerpoint'                                                    : 'ppt',
        'application/x-mspowerpoint'                                                : 'ppt',
        'application/vnd.openxmlformats-officedocument.presentationml.slideshow'    : 'ppsx',
        'application/vnd.openxmlformats-officedocument.presentationml.presentation' : 'pptx',

        'application/msword'                                                      : 'doc',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document' : 'docx',

        'application/vnd.oasis.opendocument.text'         : 'odt',
        'application/vnd.oasis.opendocument.presentation' : 'odp',
        'application/vnd.oasis.opendocument.spreadsheet'  : 'ods'
    };


    function reset() {
        $("#files").find(".fileContainer").remove()
    }
    function createContainer() {

        var file = document.getElementById("file");

        var next = $("#files").find(".fileContainer").size();
        if (isNaN(next))
            next = 1;
        else
            next++;
        var ar = file.files[next - 1];
        var div = $('<div class="fileContainer ui-corner-all d-' + next + '">');
        var row1 = $("<div class='row tipoDocumento'>");
        var row2 = $("<div class='row resumen'>");
        var row3 = $("<div class='row botones'  style='text-align: right'>");
        var row4 = $("<div class='row'>");
        row1.append("<div class='col-md-1 etiqueta'>Tipo de Documento</div>");
        row1.append("<div class='col-md-4'><select class='form-control " + next + "' name='tipoDocumento'><option value='1' selected>Normativa</option><option value='2' >Actas y resoluciones</option><option value='3'>Avisos y Anuncios</option></select></div>");
        row2.append("<div class='col-md-1 etiqueta'>Descripción</div>");
        row2.append("<div class='col-md-4'><textarea maxlength='63' style='resize: none' class='form-control " + next + "' required id='descripcion' name='descripcion' cols='5' rows='5'></textarea></div>");
        row2.append(" <div class='col-md-1 etiqueta'>Resumen</div>");
        row2.append("<div class='col-md-6'><textarea maxlength='1024' style='resize: none;' class='form-control  " + next + "' required id='resumen' name='resumen' cols='5' rows='5'></textarea> </div>");
        row3.append(" <a href='#' class='btn btn-azul subir' style='margin-right: 15px' clase='" + next + "'><i class='fa fa-upload'></i> Subir Archivo</a>");
        row3.append(" <a href='#' class='btn btn-warning cerrar' style='margin-right: 15px' clase='" + next + "'><i class='fa fa-times'></i> Cerrar</a>");
        div.append("<div class='row' style='margin-top: 0px'><div class='titulo-archivo col-md-10'><span style='color: #327BBA'>Archivo:</span> " + ar.name + "</div></div>");
        div.append("<div class='row' style='margin-top: 0px'><div class='col-md-5'></div></div>");
        div.append(row1);
        div.append(row2);
        div.append(row3);
        $("#files").append(div);
        if ($("#files").height() * 1 > 120) {
            $("#titulo-arch").show();
            $("#linea-arch").show();
        } else {
            $("#titulo-arch").hide();
            $("#linea-arch").hide();
        }
    }
    function boundBotones() {
        $(".subir").unbind("click");
        $(".cerrar").unbind("click");
        $(".subir").bind("click", function () {
            error = false;
            $("." + $(this).attr("clase")).each(function () {
                if ($(this).val().trim() == "") {
                    error = true;
                }
            });
            if (error) {
                bootbox.alert("llene todos los campos")
            } else {
                /*Aqui subir*/
                upload($(this).attr("clase") * 1 - 1);
            }
        });
        $(".cerrar").bind("click", function () {
            reset();
        });
    }
    var request = [];
    var tam = 0;
    function upload(indice) {
        var tramite = "${condominio?.id}";
        var file = document.getElementById("file");
        /* Create a FormData instance */
        var formData = new FormData();
        tam = file.files[indice];
        var type = tam.type;
        if (okContents[type]) {
            tam = tam["size"];
            var kb = tam / 1000;
            var mb = kb / 1000;
            if (mb <= 5) {
                formData.append("file", file.files[indice]);
                formData.append("id", tramite);
                $("." + (indice + 1)).each(function () {
                    formData.append($(this).attr("name"), $(this).val());
                });
                var rs = request.length;
                $(".d-" + (indice + 1)).addClass("subiendo").addClass("rs-" + rs);
                $(".rs-" + rs).find(".resumen").remove();
                $(".rs-" + rs).find(".botones").remove();
                $(".rs-" + rs).find(".tipoDocumento").remove();
                $(".rs-" + rs).append('<div class="progress-bar-svt ui-corner-all" id="p-b"><div class="progress-svt background-image" id="p-' + rs + '"></div></div>').css({
                    height     : 100,
                    fontWeight : "bold"
                });
                request[rs] = new XMLHttpRequest();
                request[rs].open("POST", "${g.createLink(controller: 'documento',action: 'subirArchivo_ajax')}");

                request[rs].upload.onprogress = function (ev) {
                    var loaded = ev.loaded;
                    var width = (loaded * 100 / tam);
                    if (width > 100)
                        width = 100;
                    $("#p-" + rs).css({width : parseInt(width) + "%"});
                    if ($("#p-" + rs).width() > 50) {
                        $("#p-" + rs).html("" + parseInt(width) + "%");
                    }
                };
                request[rs].send(formData);
                request[rs].onreadystatechange = function () {
                    if (request[rs].readyState == 4 && request[rs].status == 200) {
                        if ($("#files").height() * 1 > 120) {
                            $("#titulo-arch").show();
                            $("#linea-arch").show();
                        } else {
                            $("#titulo-arch").hide();
                            $("#linea-arch").hide();
                        }
                        $(".rs-" + rs).html("<i class='fa fa-check' style='color:#327BBA;margin-right: 10px'></i> " + $(".rs-" + rs).find(".titulo-archivo").html() + " subido exitosamente").css({
                            height     : 50,
                            fontWeight : "bold"
                        }).removeClass("subiendo");
                        cargaLista();
                    }
                };
            } else {
                var $div = $(".fileContainer.d-" + (indice + 1));
                $div.addClass("bg-danger").addClass("text-danger");
                var $p = $("<div>").addClass("alert divError").html("No puede subir archivos de más de 5 megabytes");
                $div.prepend($p);
                return false;
            }
        } else {
            var $div = $(".fileContainer.d-" + (indice + 1));
            $div.addClass("bg-danger").addClass("text-danger");
            var $p = $("<div>").addClass("alert divError").html("No puede subir archivos de tipo <b>" + type + "</b>");
            $div.prepend($p);
            return false;
        }
    }

    $("#file").change(function () {
        reset();
        archivos = $(this)[0].files;
        var length = archivos.length;
        for (i = 0; i < length; i++) {
            createContainer();
        }
        boundBotones();
    });

    function cargaLista(){
        setTimeout(function() {
            location.href="${createLink(controller: 'documento', action: 'list', id: condominio?.id)}"
        }, 1000);
    }

    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
            "¿Está seguro que desea eliminar el Documento seleccionado? Esta acción no se puede deshacer.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash-o'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        openLoader("Eliminando Documento");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'documento', action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] == "SUCCESS") {
                                    setTimeout(function() {
                                        location.reload(true);
                                    }, 1000);
                                } else {
                                    closeLoader();
                                }
                            }
                        });
                    }
                }
            }
        });
    }

    $(function () {

        $(".btnCrear").click(function() {
            createEditRow();
            return false;
        });

        $("tbody>tr").contextMenu({
            items  : {
                header   : {
                    label  : "Acciones",
                    header : true
                },
                ver      : {
                    label  : "Descargar",
                    icon   : "fa fa-download",
                    action : function ($element) {
                        var id = $element.data("id");
                        location.href="${createLink(controller: 'documento', action: 'descargar')}/" + id
                        %{--$.ajax({--}%
                            %{--type    : "POST",--}%
                            %{--url     : "${createLink(controller:'documento', action:'descargar')}",--}%
                            %{--data    : {--}%
                                %{--id : id--}%
                            %{--},--}%
                            %{--success : function (msg) {--}%

                            %{--}--}%
                        %{--});--}%
                    }
                },
                eliminar : {
                    label            : "Eliminar",
                    icon             : "fa fa-trash-o",
                    separator_before : true,
                    action           : function ($element) {
                        var id = $element.data("id");
                        deleteRow(id);
                    }
                }
            },
            onShow : function ($element) {
                $element.addClass("success");
            },
            onHide : function ($element) {
                $(".success").removeClass("success");
            }
        });
    });
</script>

</body>
</html>
