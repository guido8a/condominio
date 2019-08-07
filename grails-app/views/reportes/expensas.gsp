<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 05/06/18
  Time: 11:55
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Certificado de Expensas</title>

    <script src="${resource(dir: 'js/plugins/ckeditor', file: 'ckeditor.js')}"></script>
</head>

<body>

<div style="text-align: center; margin-top: -30px;">
    <h3>Certificado de Expensas para ${(persona?.nombre ?: '') + ' ' + (persona?.apellido ?: '') + " ( CI: " + (persona?.ruc ?: '') + " )" }</h3>
</div>

<div style="text-align: center; margin-top: 10px;">
    <h4>Torre: ${(persona?.edificio?.descripcion  ?: '')}  - Departamento: ${(persona?.departamento ?: '')}</h4>
</div>


<div class="card">
    <textarea name='editor1' id="certificado" class="editor" rows="100" cols="80">${persona?.expensa}</textarea>
</div>

%{--<div class="col-md-6">--}%
    <div class="btn-group col-md-6" style="margin-left: -10px; margin-top: 20px;">
        <g:link controller="vivienda" action="index" class="btn btn-primary" title="Regresar a Lista de propietarios">
            <i class="fa fa-arrow-left"></i> Regresar
        </g:link>

        <a href="#" name="imprimir" class="btn btn-success" id="btnImprimir"
           title="Imprimir certificado de expensas">
            <i class="fa fa-print"></i> Imprimir</a>
    </div>
%{--</div>--}%


<script type="text/javascript">


    $("#btnImprimir").click(function () {
        var texto = CKEDITOR.instances['certificado'].getData();

        $.ajax({
           type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'guardarTexto_ajax')}',
            data:{
                editor: texto,
                persona: '${persona?.id}'
            },
            success: function (msg){
                if(msg == 'ok'){
                    location.href='${createLink(controller: 'reportes', action: 'expensas_pdf')}?id=' + '${persona?.id}'
                }else{
                    log("Ha ocurrido un error", "error")
                }
            }
        });

    });


    //    CKEDITOR.replace( 'editor1' );

    CKEDITOR.replace( 'editor1', {
        height                  : 500,
        width                   : 1100,
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