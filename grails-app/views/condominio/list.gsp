
<%@ page import="condominio.Condominio" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Condominios</title>
</head>
<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <g:if test="${session.perfil.codigo == 'ADM'}">
        <div class="btn-group">
            <a href="${createLink(controller: "inicio", action: "parametros")}" class="btn btn-primary">
                <i class="fa fa-arrow-left"></i> Regresar
            </a>
        </div>
        <div class="btn-group">
            <a href="#" class="btn btn-primary btnCrear">
                <i class="fa fa-file-o"></i> Nuevo
            </a>
        </div>
        <div class="btn-group pull-right col-md-3">
            <div class="input-group">
                <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
                <span class="input-group-btn">
                    <g:link controller="condominio" action="list" class="btn btn-default btn-search">
                        <i class="fa fa-search"></i>&nbsp;
                    </g:link>
                </span>
            </div><!-- /input-group -->
        </div>
    </g:if>
</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>

        <th>Tipo Condominio</th>

        <g:sortableColumn property="nombre" title="Nombre" />

        <g:sortableColumn property="ruc" title="Ruc" />

        <th>Canton</th>

        <g:sortableColumn property="direccion" title="Direccion" />

        <g:sortableColumn property="telefono" title="Telefono" />

        <th># Viviendas</th>

    </tr>
    </thead>
    <tbody>
    <g:if test="${condominioInstanceCount > 0}">
        <g:each in="${condominioInstanceList}" status="i" var="condominioInstance">
            <tr data-id="${condominioInstance.id}" data-tal="${condominioInstance?.comprobante}">

                <td>${condominioInstance.tipoCondominio.descripcion}</td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${condominioInstance}" field="nombre"/></elm:textoBusqueda></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${condominioInstance}" field="ruc"/></elm:textoBusqueda></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${condominioInstance}" field="canton.nombre"/></elm:textoBusqueda></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${condominioInstance}" field="direccion"/></elm:textoBusqueda></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${condominioInstance}" field="telefono"/></elm:textoBusqueda></td>

                <td style="text-align: center">${condominioInstance?.numeroViviendas}</td>

            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="11">
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

<elm:pagination total="${condominioInstanceCount}" params="${params}"/>

<script type="text/javascript">
    var id = null;
    function submitFormCondominio() {
        var $form = $("#frmCondominio");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Condominio");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        if (parts[0] == "SUCCESS") {
                            location.reload(true);
                        } else {
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 1000);
                }
            });
        } else {
            return false;
        } //else
    }
    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
            "¿Está seguro que desea eliminar el Condominio seleccionado? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Condominio");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'condominio', action:'delete_ajax')}',
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
    function createEditRow(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'condominio', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Condominio",
                    class   : "modal-lg",
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
                                return submitFormCondominio();
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

    function guardarValor(id, valor){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'condominio', action:'guardarValor_ajax')}",
            data    : {
                id : id,
                valor: valor
            },
            success : function (msg) {
                if(msg == 'ok'){
                    log("Valor guardado correctamente","success")
                }else{
                    log("Error al guardar el valor", "error")
                }
            }
        });
    }

    $(function () {

        $(".btnCrear").click(function() {
            createEditRow();
            return false;
        });

        %{--$("tbody>tr").contextMenu({--}%
        %{--items  : {--}%
        %{--header   : {--}%
        %{--label  : "Acciones",--}%
        %{--header : true--}%
        %{--},--}%
        %{--ver      : {--}%
        %{--label  : "Ver",--}%
        %{--icon   : "fa fa-search",--}%
        %{--action : function ($element) {--}%
        %{--var id = $element.data("id");--}%
        %{--$.ajax({--}%
        %{--type    : "POST",--}%
        %{--url     : "${createLink(controller:'condominio', action:'show_ajax')}",--}%
        %{--data    : {--}%
        %{--id : id--}%
        %{--},--}%
        %{--success : function (msg) {--}%
        %{--bootbox.dialog({--}%
        %{--title   : "Ver Condominio",--}%
        %{--message : msg,--}%
        %{--buttons : {--}%
        %{--ok : {--}%
        %{--label     : "Aceptar",--}%
        %{--className : "btn-primary",--}%
        %{--callback  : function () {--}%
        %{--}--}%
        %{--}--}%
        %{--}--}%
        %{--});--}%
        %{--}--}%
        %{--});--}%
        %{--}--}%
        %{--},--}%
        %{--editar   : {--}%
        %{--label  : "Editar",--}%
        %{--icon   : "fa fa-pencil",--}%
        %{--action : function ($element) {--}%
        %{--var id = $element.data("id");--}%
        %{--createEditRow(id);--}%
        %{--}--}%
        %{--},--}%
        %{--pago   : {--}%
        %{--label  : "Solicitud de Pago",--}%
        %{--icon   : "fa fa-dollar",--}%
        %{--action : function ($element) {--}%
        %{--var id = $element.data("id");--}%
        %{--location.href="${createLink(controller: 'reportes', action: 'solicitudPago')}?id=" + id--}%
        %{--}--}%
        %{--},--}%
        %{--monitorio   : {--}%
        %{--label  : "Solicitud de Monitorio",--}%
        %{--icon   : "fa fa-clipboard",--}%
        %{--action : function ($element) {--}%
        %{--var id = $element.data("id");--}%
        %{--location.href="${createLink(controller: 'reportes', action: 'solicitudMonitorio')}?id=" + id--}%
        %{--}--}%
        %{--},--}%
        %{--cobro   : {--}%
        %{--label  : "Gestión de cobro",--}%
        %{--icon   : "fa fa-gavel",--}%
        %{--action : function ($element) {--}%
        %{--var id = $element.data("id");--}%

        %{--$.ajax({--}%
        %{--type    : "POST",--}%
        %{--url     : "${createLink(controller:'condominio', action:'cobro_ajax')}",--}%
        %{--data    : {--}%
        %{--id : id--}%
        %{--},--}%
        %{--success : function (msg) {--}%
        %{--bootbox.dialog({--}%
        %{--title   : "Gestión de cobro",--}%
        %{--message : msg,--}%
        %{--buttons : {--}%
        %{--cancelar : {--}%
        %{--label     : "Cancelar",--}%
        %{--className : "btn-primary",--}%
        %{--callback  : function () {--}%
        %{--}--}%
        %{--},--}%
        %{--aceptar : {--}%
        %{--label     : "Guardar",--}%
        %{--className : "btn-success",--}%
        %{--callback  : function () {--}%
        %{--var v = $("#gestion").val();--}%
        %{--guardarValor(id, v);--}%
        %{--}--}%
        %{--}--}%
        %{--}--}%
        %{--});--}%
        %{--}--}%
        %{--});--}%

        %{--}--}%
        %{--},--}%
        %{--talonario   : {--}%
        %{--label  : "Comprobantes digitales",--}%
        %{--icon   : "fa fa-paste",--}%
        %{--action : function ($element) {--}%
        %{--var id = $element.data("id");--}%
        %{--location.href="${createLink(controller: 'talonario', action: 'talonario')}?id=" + id--}%
        %{--}--}%
        %{--},--}%
        %{--eliminar : {--}%
        %{--label            : "Eliminar",--}%
        %{--icon             : "fa fa-trash-o",--}%
        %{--separator_before : true,--}%
        %{--action           : function ($element) {--}%
        %{--var id = $element.data("id");--}%
        %{--deleteRow(id);--}%
        %{--}--}%
        %{--}--}%
        %{--},--}%
        %{--onShow : function ($element) {--}%
        %{--$element.addClass("success");--}%
        %{--},--}%
        %{--onHide : function ($element) {--}%
        %{--$(".success").removeClass("success");--}%
        %{--}--}%
        %{--});--}%
    });

    $(function () {
        $("tr").contextMenu({
            items  : createContextMenu,
            onShow : function ($element) {
                $element.addClass("trHighlight");
            },
            onHide : function ($element) {
                $(".trHighlight").removeClass("trHighlight");
            }
        });
    });


    function createContextMenu(node) {
        var $tr = $(node);
        var items = {
            header: {
                label: "Acciones",
                header: true
            }
        };

        var id = $tr.data("id");
        var com = $tr.data("tal");

        var editar = {

            label  : "Editar",
            icon   : "fa fa-pencil",
            action : function ($element) {
                var id = $element.data("id");
                createEditRow(id);
            }
        };

        var ver = {

            label  : "Ver",
            icon   : "fa fa-search",
            action : function ($element) {
                var id = $element.data("id");
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'condominio', action:'show_ajax')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        bootbox.dialog({
                            title   : "Ver Condominio",
                            message : msg,
                            buttons : {
                                ok : {
                                    label     : "Aceptar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                }
                            }
                        });
                    }
                });
            }
        };

        var pago = {
            label  : "Solicitud de Pago",
            icon   : "fa fa-dollar",
            action : function ($element) {
                var id = $element.data("id");
                location.href="${createLink(controller: 'reportes', action: 'solicitudPago')}?id=" + id
            }
        };

        var monitorio = {
            label  : "Solicitud de Monitorio",
            icon   : "fa fa-clipboard",
            action : function ($element) {
                var id = $element.data("id");
                location.href="${createLink(controller: 'reportes', action: 'solicitudMonitorio')}?id=" + id
            }
        };

        var cobro = {
            label  : "Gestión de cobro",
            icon   : "fa fa-gavel",
            action : function ($element) {
                var id = $element.data("id");

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'condominio', action:'cobro_ajax')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        bootbox.dialog({
                            title   : "Gestión de cobro",
                            message : msg,
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                },
                                aceptar : {
                                    label     : "Guardar",
                                    className : "btn-success",
                                    callback  : function () {
                                        var v = $("#gestion").val();
                                        guardarValor(id, v);
                                    }
                                }
                            }
                        });
                    }
                });

            }
        };

        var talonario = {
            label  : "Comprobantes digitales",
            icon   : "fa fa-clipboard",
            action : function ($element) {
                var id = $element.data("id");
                location.href="${createLink(controller: 'talonario', action: 'talonario')}?id=" + id
            }
        };

        var eliminar = {
            label            : "Eliminar",
            icon             : "fa fa-trash-o",
            separator_before : true,
            action           : function ($element) {
                var id = $element.data("id");
                deleteRow(id);
            }
        };




        %{--if('${session.perfil.codigo}' == 'ADC'){--}%
        %{--items.ver = ver;--}%
        %{--items.editar = editar;--}%
        %{--items.eliminar = eliminar;--}%
        %{--} else {--}%
        %{--items.ver = ver;--}%
        %{--}--}%


        items.ver = ver;
        items.editar = editar;
        items.pago = pago;
        items.monitorio = monitorio;
        items.cobro = cobro;
//        if(verificarTalonario(id)){
//            items.talonario = talonario;
//        }
        if(com == 'S'){
            items.talonario = talonario;
        }
        items.eliminar = eliminar;


        return items
    }

    %{--function verificarTalonario(id){--}%
        %{--$.ajax({--}%
            %{--type: 'POST'--}%
            %{--url:'${}'--}%
        %{--})--}%

    %{--}--}%




</script>

</body>
</html>
