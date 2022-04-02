<html>
<head>
<meta name="layout" content="main">
<title>Biblioteca Convenios</title>
</head>

<div class="panel panel-primary col-md-12">
    <h3>Biblioteca del Condominio</h3>
    <div class="panel-info" style="padding: 3px; margin-top: 2px">
    <div class="btn-toolbar toolbar">
        <div class="btn-group">
                <g:link controller="inicio" action="index" id="${condominio?.id}" class="btn btn-sm btn-default">
                    <i class="fa fa-arrow-left"></i> Regresar a Inicio
                </g:link>
        </div>

    <div class="btn-group">
        <a href="#" class="btn btn-sm btn-success" id="btnAddDoc">
            <i class="fa fa-plus"></i> Agregar documento a la Biblioteca
        </a>
    </div>

    <div class="btn-group col-md-3 pull-right">
        <div class="input-group input-group-sm">
            <input type="text" class="form-control input-sm " id="searchDoc" placeholder="Buscar"/>
            <span class="input-group-btn">
                <a href="#" class="btn btn-default" id="btnSearchDoc"><i class="fa fa-search"></i></a>
            </span>
        </div><!-- /input-group -->
    </div>
</div>
    </div>
<div id="tabla"></div>
</div>



<script type="text/javascript">

    function reloadTablaDocumento(search) {
        var data = {
            id : "${condominio?.id}"
        };
        if (search) {
            data.search = search;
        }
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'documento', action:'tablaDocu_ajax')}",
            data    : data,
            success : function (msg) {
                $("#tabla").html(msg);
            }
        });
    }

    function submitFormDocumento() {
        var $form = $("#frmDocumento");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Documento");
            var formData = new FormData($form[0]);
            $.ajax({
                url         : $form.attr("action"),
                type        : 'POST',
                data        : formData,
                async       : false,
                cache       : false,
                contentType : false,
                processData : false,
                success     : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    closeLoader();
                    if (parts[0] == "SUCCESS") {
                        reloadTablaDocumento();
                        $("#dlgCreateEdit").modal("hide");
                    } else {
                        spinner.replaceWith($btn);
                        return false;
                    }
                },
                error       : function () {

                }
            });
        } else {
            return false;
        } //else
    }
    function deleteDocumento(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-3x pull-left text-danger text-shadow'></i><p>" +
                    "¿Está seguro que desea eliminar el Documento " + itemId + " seleccionado? Esta acción no se puede deshacer.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash'></i> Eliminar",
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
                                closeLoader();
                                if (parts[0] == "SUCCESS") {
                                    reloadTablaDocumento();
                                }
                            }
                        });
                    }
                }
            }
        });
    }
    function createEditDocumento(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.condominio = "${condominio.id}";
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'documento', action:'formDocu_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Documento",
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
                                return submitFormDocumento();
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
    function downloadDocumento(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'documento', action:'existeDoc_ajax')}",
            data    : {
                id : id
            },
            success : function (msg) {
                if (msg == "OK") {
                    location.href = "${createLink(controller: 'documento', action: 'downloadDoc')}/" + id;
                } else {
                    log("El documento solicitado no se encontró en el servidor", "error"); // log(msg, type, title, hide)
                }
            }
        });
    }

    $(function () {
        reloadTablaDocumento();

        $("#btnSearchDoc").click(function () {
            reloadTablaDocumento($.trim($("#searchDoc").val()));
        });
        $("#searchDoc").keyup(function (ev) {
            if (ev.keyCode == 13) {
                reloadTablaDocumento($.trim($("#searchDoc").val()));
            }
        });
        $("#btnAddDoc").click(function () {
            createEditDocumento();
        });

    });
</script>
</html>