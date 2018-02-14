<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 14/02/18
  Time: 13:02
--%>

<g:if test="${perfiles}">
    <div class="col-md-12">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <table id="tblPerfiles" class="table table-hover table-bordered table-condensed">
                <g:each in="${perfiles}" var="perfil">
                    <tr class="perfiles" data-id="${perfil.perfil?.id}">
                        <td>
                            ${perfil?.perfil?.nombre}
                        </td>
                        <td width="35">
                            <a href="#" class="btn btn-danger btn-xs btn-deletePerfil" data-id="${perfil?.id}">
                                <i class="fa fa-trash-o"></i>
                            </a>
                        </td>
                    </tr>
                </g:each>
            </table>
        </div>
    </div>
</g:if>
<g:else>
    <div class="alert alert-info">El usuario no tiene ningún perfil asignado</div>
</g:else>

<script type="text/javascript">

    $(".btn-deletePerfil").click(function () {
        var id = $(this).data('id');
        $.ajax({
           type:'POST',
            url:'${createLink(controller: 'persona', action: 'borrarPerfil_ajax')}',
            data:{
                id: id
            },
            success: function (msg){
                if(msg == 'ok'){
                    log("Perfil borrado correctamente","success");
                    cargarPerfiles();
                }else{
                    log("Error al borrar el perfil","error")
                }
            }
        });
    });

</script>


