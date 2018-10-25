<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 24/10/18
  Time: 14:31
--%>

<div class="" style="width: 100%;height: 450px; overflow-y: auto; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1120px">
        <tbody>
        <g:if test="${propiedades.size() > 0}">
            <g:each in="${propiedades}" status="i" var="propiedad">
                <tr data-id="${propiedad.id}">
                    <td style="width: 23%">${propiedad?.tipoPropiedad?.descripcion}</td>
                    <td style="width: 15%">${propiedad?.numero}</td>
                    <td class="centro" style="width: 10%">${propiedad?.area}</td>
                    <td class="derecha" style="width: 10%">${propiedad?.valor}</td>
                    <td class="derecha" style="width: 10%">${propiedad?.alicuota} %</td>
                    <td class="centro" style="width: 14%">${propiedad?.fechaDesde?.format("dd-MM-yyyy")}</td>
                    <td class="centro" style="width: 14%">${propiedad?.fechaHasta?.format("dd-MM-yyyy")}</td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr class="danger">
                <td class="text-center" colspan="9">
                    No se encontraron registros que mostrar
                </td>
            </tr>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">


    $("tbody>tr").contextMenu({
        items  : {
            header   : {
                label  : "Acciones",
                header : true
            },
            ver      : {
                label  : "Ver",
                icon   : "fa fa-search",
                action : function ($element) {
                    var id = $element.data("id");
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'propiedad', action:'show_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            bootbox.dialog({
                                title   : "Ver Propiedad",
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
            },
            editar   : {
                label  : "Editar",
                icon   : "fa fa-pencil",
                action : function ($element) {
                    var id = $element.data("id");
                    createEditRow(id);
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

</script>