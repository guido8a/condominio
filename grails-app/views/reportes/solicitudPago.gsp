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

    <style>
        .colo{
            color: #f8fffd;
        }
    </style>
</head>

<body>

<div style="text-align: center; margin-top: -30px;">
    <h3><strong>Solicitud de pago</strong> <br/> <strong>Condominio:</strong> ${condominio?.nombre}</h3>
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

    <div class="card">
        <div class="card-header" id="headingTwo">
            <h2 class="mb-0">
                <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                    <strong class="colo"> * La tabla que ocupa este espacio se generará por cada persona en la impresión del reporte </strong>
                </button>
            </h2>
        </div>
    </div>

    <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
        <strong class="colo">Párrafo Dos</strong>
    </button>
    <div class="card-body">
        <textarea name='editor2' id="parrafoDos" class="editor" rows="100" cols="80">${texto?.parrafoDos ?: parrafo2}</textarea>
    </div>

    <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
       <strong class="colo">Nota</strong>
    </button>
    <div class="card-body" style="margin-bottom: 20px">
        <textarea name='editor3' id="nota" class="editor" rows="100" cols="80">${texto?.nota ?: nota}</textarea>
    </div>

    <div class="col-md-4">
        <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
            <strong class="colo">Nombre</strong>
        </button>
        <g:textField name="nombre" class="form-control" maxlength="127" value="${texto?.nombre}"/>
    </div>

    <div class="col-md-4">
        <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
            <strong class="colo">Cargo</strong>
        </button>
        <g:textField name="cargo" class="form-control" maxlength="127" value="${texto?.cargo}"/>
    </div>

    <div class="col-md-4" style="margin-bottom: 50px">
        <button class="btn btn-primary btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
            <strong class="colo">Contacto</strong>
        </button>
        <g:textField name="contacto" class="form-control" maxlength="127" value="${texto?.contacto}"/>
    </div>
</div>

<script type="text/javascript">

    $("#btnGuardar").click(function () {
        var par1 = CKEDITOR.instances['parrafoUno'].getData();
        var par2 = CKEDITOR.instances['parrafoDos'].getData();
        var par3 = CKEDITOR.instances['nota'].getData();

        var nombre = $("#nombre").val();
        var cargo = $("#cargo").val();
        var contacto = $("#contacto").val();

        if(nombre == ''){
            bootbox.alert("<i class='fa fa-exclamation-triangle fa-2x text-warning'></i> Ingrese el nombre de la persona que genera la solicitud de pago")
        }else{
            if(cargo == ''){
                bootbox.alert("<i class='fa fa-exclamation-triangle fa-2x text-warning'></i> Ingrese el cargo de la persona que genera la solicitud de pago")
            }else{
                if(contacto ==''){
                    bootbox.alert("<i class='fa fa-exclamation-triangle fa-2x text-warning'></i> Ingrese el contacto de la persona que genera la solicitud de pago")
                }else{
                    $.ajax({
                        type: 'POST',
                        url:'${createLink(controller: 'reportes', action: 'guardarParrafosSolicitud_ajax')}',
                        data:{
                            id: '${texto?.id}',
                            parrafo1: par1,
                            parrafo2: par2,
                            nota: par3,
                            tipo: 1,
                            nombre: nombre,
                            cargo: cargo,
                            contacto: contacto
                        },
                        success: function (msg) {
                            if(msg == 'ok'){
                                log("Texto guardado correctamente","success")
                            }else{
                                log("Error al guardar el texto","error")
                            }
                        }
                    });
                }
            }

        }


    });

    CKEDITOR.replace( 'editor1', {
        height                  : 100,
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
        height                  : 120,
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

    CKEDITOR.replace( 'editor3', {
        height                  : 80,
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