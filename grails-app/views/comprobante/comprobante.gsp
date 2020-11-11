<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 11/11/20
  Time: 9:23
--%>


<html>
<head>
    <meta name="layout" content="main">
    <title>Comprobante de pago</title>

    <script src="${resource(dir: 'js/plugins/ckeditor', file: 'ckeditor.js')}"></script>

    <style>
    .colo{
        color: #f8fffd;
    }
    </style>
</head>

<body>

<div style="text-align: center; margin-top: -30px;">
    <h3><strong>Comprobante de pago</strong> <br/> <strong>Condominio:</strong> ${condominio?.nombre}</h3>
</div>

<div class="btn-group col-md-6" style="margin-bottom: 10px;">
    <g:link controller="condominio" action="list" class="btn btn-primary" title="Regresar a lista de condominios">
        <i class="fa fa-arrow-left"></i> Regresar
    </g:link>
    <a href="#" class="btn btn-success" id="btnGuardar"><i class="fa fa-save"></i> Guardar</a>
</div>

<div class="accordion" id="accordionExample">
    <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse"
            data-target="#collapseUno" aria-expanded="false" aria-controls="collapseUno">
        <strong class="colo">Párrafo Uno</strong>
    </button>
    <div class="card-body" >
        <textarea name='editor1' id="parrafoUno" class="editor">${texto?.parrafoUno ?: parrafo1}</textarea>
    </div>

</div>


<script type="text/javascript">

    $("#btnGuardar").click(function () {
        var par1 = CKEDITOR.instances['parrafoUno'].getData();

        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'comprobante', action: 'guardarComprobante_ajax')}',
            data:{
                id: '${texto?.id}',
                parrafo1: par1,
                tipo: 2
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

    CKEDITOR.replace( 'editor1', {
        height                  : 300,
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