<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Gestores Contables</title>

    <style type="text/css">

    .alinear {
        text-align: center !important;
    }

    #buscar {
        width: 240px;
        border-color: #0c6cc2;
    }

    #limpiaBuscar {
        position: absolute;
        right: 5px;
        top: 0;
        bottom: 0;
        height: 14px;
        margin: auto;
        font-size: 14px;
        cursor: pointer;
        color: #ccc;
    }
    </style>

</head>

<body>
<div style="margin-top: 0px; min-height: 50px" class="vertical-container">
    <p class="css-icono" style="margin-bottom: -15px"><i class="fa fa-folder-open-o"></i></p>

    <div class="linea45"></div>

    <div>
        <div class="col-md-2">
            <g:link class="btn btn-primary" action="formGestor">
                <i class="fa fa-file-o"></i> Nuevo Gestor
            </g:link>
        </div>

        <div class="col-md-6" style="margin-left: 20px;">
            Buscar por:
            <div class="btn-group">
                <input id="buscar" type="search" class="form-control" value="${session.buscar}">
                <span id="limpiaBuscar" class="glyphicon glyphicon-remove-circle"
                      title="Limpiar texto de búsqueda"></span>
            </div>
            <a href="#" name="busqueda" class="btn btn-azul btnBusqueda btn-ajax"><i
                    class="fa fa-check-square-o"></i> Buscar</a>
        </div>

        <g:if test="${!gestorIniciales}">
            <div class="col-md-3">
                <a href="#" class="btn btn-info" id="btnInicial">
                    <i class="fa fa-check"></i> Crear gestor de saldos iniciales
                </a>
            </div>
        </g:if>
    </div>
</div>

<div style="margin-top: 30px; min-height: 550px" class="vertical-container">
    <p class="css-vertical-text">Gestores</p>

    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 1070px">
        <thead>
        <tr>
            <th class="alinear" style="width: 40%">Nombre</th>
            <th class="alinear" style="width: 15%">Estado</th>
            <th class="alinear" style="width: 30%">Tipo</th>
            <th class="alinear" style="width: 15%">Acciones</th>
        </tr>
        </thead>
    </table>

    <div id="bandeja">
    </div>
</div>

<div>
    <strong>Nota</strong>: Se retorna como máximo 20 registros <span style="margin-left: 40px; color: #0b2c89">Se ordena por nombre del gestor</span>
</div>

<div class="modal fade " id="dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                Problema y Solución..
            </div>

            <div class="modal-body" id="dialog-body" style="padding: 15px">

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>

<script type="text/javascript">

    $("#limpiaBuscar").click(function () {
        $("#buscar").val('');
        cargarBusqueda();
    });

    $("#btnInicial").click(function () {

        bootbox.confirm({
            message: "<i class='fa fa-3x fa-exclamation-triangle text-info'></i> " +
                "<strong style='font-size: 14px'> Está seguro de crear un gestor de saldos iniciales? </strong>",
            buttons: {
                confirm: {
                    label: '<i class="fa fa-save"></i> Aceptar',
                    className: 'btn-success'
                },
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result){
                    openLoader("Creando...");
                    $.ajax({
                        type: 'POST',
                        url:'${createLink(controller: 'gestor', action: 'crearGestorSaldoInicial_ajax')}',
                        data:{
                        },
                        success: function (msg){
                            closeLoader();
                            if(msg === 'OK'){
                                log("Gestor de Saldos Iniciales creado correctamente", "success");
                                setTimeout(function () {
                                    location.reload();
                                }, 1000);
                            }else{
                                log("Error al crear el gestor de saldos iniciales", "error");
                            }
                        }
                    });
                }
            }
        });
    });

    cargarBusqueda();

    function cargarBusqueda() {
        var buscar = $("#buscar").val();
        var datos = "buscar=" + buscar;

        $.ajax({
            type: "POST",
            url: "${g.createLink(action: 'tablaBuscarGstr')}",
            data: datos,
            success: function (msg) {
                $("#bandeja").html(msg);
            },
            error: function (msg) {
                $("#bandeja").html("Ha ocurrido un error");
            }
        });
    }

    $(".btnBusqueda").click(function () {
        cargarBusqueda();
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode === 13) {
            $(".btnBusqueda").click();
        }
    });

    %{--function createContextMenu(node) {--}%
    %{--    var $tr = $(node);--}%

    %{--    var items = {--}%
    %{--        header: {--}%
    %{--            label: "Acciones",--}%
    %{--            header: true--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var etdo = $tr.data("ed");--}%
    %{--    var id = $tr.data("id");--}%

    %{--    var editar = {--}%
    %{--        label: " Editar",--}%
    %{--        icon: "fa fa-file-text-o",--}%
    %{--        action: function () {--}%
    %{--            location.href = '${createLink(action: "formGestor")}?id=' + id;--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var ver = {--}%
    %{--        label: " Ver gestor",--}%
    %{--        icon: "fa fa-search-plus",--}%
    %{--        action: function () {--}%
    %{--            location.href = '${createLink(action: "formGestor")}?id=' + id;--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var copiar = {--}%
    %{--        label: " Copiar gestor",--}%
    %{--        icon: "fa fa-copy",--}%
    %{--        action: function () {--}%
    %{--            var b = bootbox.dialog({--}%
    %{--                id: "dlgCopiarGestor",--}%
    %{--                title: "Copiar Gestor",--}%
    %{--                message:  "<label>Nombre</label> </br> <input name='copiName' id='copiado' style='height: 40px;' class='form-control'/>",--}%
    %{--                buttons: {--}%
    %{--                    cancelar: {--}%
    %{--                        label: "<i class='fa fa-times'></i> Cancelar",--}%
    %{--                        className: "btn-primary",--}%
    %{--                        callback: function () {--}%
    %{--                        }--}%
    %{--                    },--}%
    %{--                    aceptar: {--}%
    %{--                        label: "<i class='fa fa-times'></i> Aceptar",--}%
    %{--                        className: "btn-success",--}%
    %{--                        callback: function () {--}%
    %{--                            var cp = $("#copiado").val();--}%
    %{--                            $.ajax({--}%
    %{--                                type: 'POST',--}%
    %{--                                url: '${createLink(controller: 'gestorContable', action: 'copiarGestor_ajax')}',--}%
    %{--                                data:{--}%
    %{--                                    id: id,--}%
    %{--                                    nombre:  cp--}%
    %{--                                },--}%
    %{--                                success: function(msg){--}%
    %{--                                    if(msg === 'ok'){--}%
    %{--                                        bootbox.hideAll();--}%
    %{--                                        log("Gestor copiado correctamente","success");--}%
    %{--                                        setTimeout(function () {--}%
    %{--                                            location.reload();--}%
    %{--                                        }, 1500);--}%
    %{--                                    }else{--}%
    %{--                                        log("Error al copiar el gestor ","error")--}%
    %{--                                    }--}%

    %{--                                }--}%
    %{--                            })--}%
    %{--                        }--}%
    %{--                    }--}%
    %{--                } //buttons--}%
    %{--            }); //dialog--}%
    %{--        }--}%
    %{--    };--}%

    %{--    if(etdo !== 'R') {--}%
    %{--        items.editar = editar;--}%
    %{--    }--}%
    %{--    items.ver = ver;--}%
    %{--    items.copiar = copiar;--}%

    %{--    return items--}%
    %{--}--}%

</script>
</body>
</html>