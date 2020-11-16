<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 16/11/20
  Time: 13:13
--%>

<g:if test="${talonarios?.size() > 0}">
    <div class="" style="width: 100%;height:300px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-condensed table-hover" width="100%">
            <g:each in="${talonarios}" var="talonario">
                <tr data-id="${talonario?.id}" style="text-align: center">
                    <td style="width: 25%">${talonario?.numeroInicio}</td>
                    <td style="width: 25%">${talonario?.numeroFin == 0 ? ' - no usado - ' : talonario?.numeroFin}</td>
                    <td style="width: 15%">${talonario?.fechaInicio?.format("dd-MM-yyyy")}</td>
                    <td style="width: 15%">${talonario?.fechaFin?.format("dd-MM-yyyy")}</td>
                    <td style="width: 10%; color: #f8fffd; background-color: ${talonario?.estado == 'V' ? '#47954B' : '#891523'}">${talonario?.estado == 'V' ? 'VIGENTE' : 'INACTIVO'}</td>
                    <td style="width: 10%">
                        <g:if test="${talonario?.estado == 'V'}">
                            <g:if test="${talonario?.numeroFin == 0}">
                                <a href="#" class="btn btn-sm btn-success btnEditar" data-id="${talonario?.id}" title="Editar talonario"><i class="fa fa-edit"></i> </a>
                            </g:if>
                            <a href="#" class="btn btn-sm btn-danger btnBorrar" data-id="${talonario?.id}" title="Cerrar talonario"><i class="fa fa-arrow-circle-down"></i> </a>
                        </g:if>
                    </td>
                </tr>
            </g:each>
        </table>
    </div>
</g:if>
<g:else>
    <div class="alert alert-danger"  style="text-align: center">
        <i class='fa fa-exclamation-circle fa-2x text-danger text-shadow'></i> No existen resultados!
    </div>
</g:else>

<script type="text/javascript">

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'talonario', action: 'comprobarEdicion_ajax')}',
            data:{
                id: id
            },
            success:function (msg) {
                if(msg == 'ok'){
                    createEditRow(id);
                    return false;
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No se puede editar el talonario, ya se encuentra en uso" + '</strong>');
                    return false;
                }
            }
        });
    });

    $(".btnBorrar").click(function () {
        var id = $(this).data("id");

        bootbox.confirm("<i class='fa fa-warning fa-3x pull-left text-danger text-shadow'></i> Está seguro que desea cerrar el talonario digital seleccionado?", function (res) {
            if (res) {
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'talonario', action: 'borrar_ajax')}',
                    data:{
                        id: id
                    },
                    success:function (msg) {
                        if(msg == 'ok'){
                            log("Talonario cerrado correctamente","success");
                            cargarTablaTalonarios();
                        }else{
                            log("Error al cerrar el talonario","error")
                        }
                    }
                });
            }
        });


    });

    //    $(function () {
//        $("tr").contextMenu({
//            items  : createContextMenu,
//            onShow : function ($element) {
//                $element.addClass("trHighlight");
//            },
//            onHide : function ($element) {
//                $(".trHighlight").removeClass("trHighlight");
//            }
//        });
//    });
</script>