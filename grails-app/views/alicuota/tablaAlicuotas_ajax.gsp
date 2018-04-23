<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 23/04/18
  Time: 9:55
--%>


<style type="text/css">
    .centrado {
        text-align: center;
    }
</style>

<div style="float: right; margin-bottom: 10px"><a href="#" class="btn btn-info btn-sm" id="btnNuevaAlicuota" data-prsn="${persona?.id}"><i class="fa fa-money"></i> Nueva Alícuota</a></div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr style="width: 100%">
        <th class="centrado" style="width: 20%">Valor</th>
        <th class="centrado" style="width: 20%">Estado</th>
        <th class="centrado" style="width: 35%">Vigente desde</th>
        <th class="centrado" style="width: 25%"><i class="fa fa-pencil"></i></th>
    </tr>
    </thead>
    <tbody>
        <g:each in="${alicuotas}" status="i" var="alicuota">
            <tr>
                <td style="text-align: right">${alicuota?.valor ?: 0}</td>
                <td class="centrado" style="color: ${alicuota?.fechaHasta ? '#701b19' : '#53cf6d'} ">${alicuota?.fechaHasta ? 'No vigente' : 'Vigente'}</td>
                <td >${alicuota?.fechaDesde?.format("dd-MM-yyyy") +  " hasta " +  (alicuota?.fechaHasta?.format("dd-MM-yyyy") ?: '...')}</td>
                <td class="centrado">
                    <g:if test="${!alicuota?.fechaHasta}">
                        <a href="#" class="btn btn-success btn-sm" id="btnEditarAlicuota" data-id="${alicuota.id}">Editar</a>
                    </g:if>
                </td>
            </tr>
        </g:each>
    </tbody>
</table>

<script type="text/javascript">

    $("#btnEditarAlicuota").click(function () {
        var id = $(this).data("id");
        alicuotaEdit(id, null);
    });

    $("#btnNuevaAlicuota").click(function () {
        var persona = $(this).data("prsn");
        alicuotaEdit(null, persona);
    });


    function submitFormAlicuota() {
        var $form = $("#frmAlicuota");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Alicuota");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        if (parts[0] == "SUCCESS") {
                            spinner.replaceWith($btn);
                            closeLoader();
                            bootbox.hideAll();
                            cargarBusqueda();
                            return false;

//                            location.reload(true);
                        } else {
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 100);
                }
            });
        } else {
            return false;
        } //else
    }


    function alicuotaEdit (id, persona) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'alicuota', action:'form_ajax')}",
            data    : {
                id: id,
                persona: persona
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgALicu",
                    title   : "Alícuota",
//                    class   : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "<i class='fa fa-times'></i> Cerrar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormAlicuota();
                            } //callback
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 100);
            } //success
        }); //ajax
    }



</script>