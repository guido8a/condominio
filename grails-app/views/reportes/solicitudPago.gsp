<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 29/05/20
  Time: 9:57
--%>

<html>
<head>
    <meta name="layout" content="main">
    <title>Solicitud de Pago</title>

    <script src="${resource(dir: 'js/plugins/ckeditor', file: 'ckeditor.js')}"></script>
</head>

<body>

<div style="text-align: center; margin-top: -30px;">
    <h3><strong>Solicitud de pago</strong> <br/> <strong>Condominio:</strong> ${condominio?.nombre}</h3>
</div>



%{--<div class="panel-group" id="accordion">--}%

%{--<g:set var="abierto" value="${false}"/>--}%
%{--<g:set var="abierto" value="${true}"/>--}%

%{--<div class="panel panel-default">--}%
%{--<div class="panel-heading">--}%
%{--<h4 class="panel-title">--}%
%{--<a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">--}%
%{--Párrafo Uno--}%
%{--</a>--}%
%{--</h4>--}%
%{--</div>--}%

%{--<div id="collapseOne" class="panel-collapse collapse">--}%
%{--<div class="panel-body">--}%

%{--</div>--}%
%{--</div>--}%
%{--</div>--}%
%{--<div class="panel panel-default">--}%
%{--<div class="panel-heading">--}%
%{--<h4 class="panel-title">--}%
%{--<a data-toggle="collapse" data-parent="#accordion" href="#collapseTabla">--}%
%{--Tabla--}%
%{--</a>--}%
%{--</h4>--}%
%{--</div>--}%

%{--<div id="collapseTabla" class="panel-collapse collapse">--}%
%{--<div class="panel-body">--}%

%{--</div>--}%
%{--</div>--}%
%{--</div>--}%
%{--<div class="panel panel-default">--}%
%{--<div class="panel-heading">--}%
%{--<h4 class="panel-title">--}%
%{--<a data-toggle="collapse" data-parent="#accordion" href="#collapseDos">--}%
%{--Párrafo Dos--}%
%{--</a>--}%
%{--</h4>--}%
%{--</div>--}%

%{--<div id="collapseDos" class="panel-collapse collapse">--}%
%{--<div class="panel-body">--}%

%{--</div>--}%
%{--</div>--}%
%{--</div>--}%
%{--</div>--}%
<div class="btn-group col-md-6" style="margin-bottom: 10px;">
    <g:link controller="condominio" action="list" class="btn btn-primary" title="Regresar a lista de condominios">
        <i class="fa fa-arrow-left"></i> Regresar
    </g:link>
    <a href="#" class="btn btn-success" id="btnGuardar"><i class="fa fa-save"></i> Guardar</a>
</div>

<div class="accordion" id="accordionExample">
    <div class="card">
        <div class="card-header" id="headingUno">
            <h2 class="mb-0">
                <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseUno" aria-expanded="false" aria-controls="collapseUno">
                    Párrafo Uno
                </button>
            </h2>
        </div>
        <div id="collapseUno" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
            <div class="card-body">
                <textarea name='editor1' id="parrafoUno" class="editor" rows="100" cols="80">${texto?.parrafoUno ?: parrafo1}</textarea>
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-header" id="headingTwo">
            <h2 class="mb-0">
                <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                    Tabla
                </button>
            </h2>
        </div>
        <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
            <div class="card-body">
                <strong>NOTA:</strong> La tabla que ocupa este espacio se generará por cada persona en la impresión del reporte
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-header" id="headingThree">
            <h2 class="mb-0">
                <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                    Párrafo Dos
                </button>
            </h2>
        </div>
        <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionExample">
            <div class="card-body">
                <textarea name='editor2' id="parrafoDos" class="editor" rows="100" cols="80">${texto?.parrafoDos ?: parrafo2}</textarea>
            </div>
        </div>
    </div>
</div>


%{--<div class="card">--}%
%{--</div>--}%


<script type="text/javascript">

    $("#btnGuardar").click(function () {
        var par1 = CKEDITOR.instances['parrafoUno'].getData();
        var par2 = CKEDITOR.instances['parrafoDos'].getData();
        $.ajax({
           type: 'POST',
            url:'${createLink(controller: 'reportes', action: 'guardarParrafosSolicitud_ajax')}',
            data:{
                id: '${texto?.id}',
                parrafo1: par1,
                parrafo2: par2
            },
            success: function (msg) {
                if(msg == 'ok'){
                    log("Texto guardado correctamente","success")
                }else{
                    log("Error al guardar el texto","error")
                }
            }
        });
    });

    %{--$("#btnImprimir").click(function () {--}%
    %{--var texto = CKEDITOR.instances['certificado'].getData();--}%

    %{--$.ajax({--}%
    %{--type: 'POST',--}%
    %{--url: '${createLink(controller: 'reportes', action: 'guardarTexto_ajax')}',--}%
    %{--data:{--}%
    %{--editor: texto,--}%
    %{--persona: '${persona?.id}'--}%
    %{--},--}%
    %{--success: function (msg){--}%
    %{--if(msg == 'ok'){--}%
    %{--location.href='${createLink(controller: 'reportes', action: 'expensas_pdf')}?id=' + '${persona?.id}'--}%
    %{--}else{--}%
    %{--log("Ha ocurrido un error", "error")--}%
    %{--}--}%
    %{--}--}%
    %{--});--}%

    %{--});--}%

    CKEDITOR.replace( 'editor1', {
        height                  : 150,
        width                   : 1140,
        resize_enabled          : false,
        language: 'es',
        uiColor: '#9AB8F3',
        extraPlugins: 'entities',
        toolbar                 : [
            ['Source', 'Font', 'FontSize', 'Scayt', '-', 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo'],
            ['Find', 'Replace', '-', 'SelectAll'],
            ['Table', 'HorizontalRule', 'PageBreak'],
            ['Bold', 'Italic', 'Underline','Subscript', 'Superscript'],
            ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-']
        ]
    });

    CKEDITOR.replace( 'editor2', {
        height                  : 200,
        width                   : 1140,
        resize_enabled          : false,
        language: 'es',
        uiColor: '#9AB8F3',
        extraPlugins: 'entities',
        toolbar                 : [
            ['Source', 'Font', 'FontSize', 'Scayt', '-', 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo'],
            ['Find', 'Replace', '-', 'SelectAll'],
            ['Table', 'HorizontalRule', 'PageBreak'],
            ['Bold', 'Italic', 'Underline','Subscript', 'Superscript'],
            ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-']
        ]
    });

</script>

</body>
</html>