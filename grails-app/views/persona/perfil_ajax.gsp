<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 14/02/18
  Time: 12:42
--%>

<div class="row">
    <label for="perfil" class="col-md-2 control-label">
        Perfil
    </label>
    <div class="col-md-8">
        <div class="row">
            <div class="col-md-8">
                <g:select name="perfil" id="selPerfil" from="${seguridad.Prfl.list([sort: 'nombre'])}" class="form-control input-sm"
                          optionKey="id" optionValue="nombre"/>
            </div>

            <div class="col-md-2">
                <a href="#" class="btn btn-success btn-sm" id="btn-addPerfil" title="Agregar perfil">
                    <i class="fa fa-plus"></i> Agregar perfil
                </a>
            </div>
        </div>
    </div>
</div>

<div class="row" style="text-align: center; margin-top: 20px">

    <label><h4>Perfiles Asignados</h4></label>

    <div id="divPerfiles" style="text-align: center">

    </div>
</div>


<script type="text/javascript">

    cargarPerfiles();

    function cargarPerfiles () {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'persona', action: 'tablaPerfiles_ajax')}',
            data:{
                id: '${usuario?.id}'
            },
            success: function (msg){
                $("#divPerfiles").html(msg)
            }
        });
    }

    $("#btn-addPerfil").click(function () {
        var perfilSeleccionado = $("#selPerfil option:selected").val();
        $.ajax({
           type: 'POST',
            url: '${createLink(controller: 'persona', action: 'guardarPerfil_ajax')}',
            data:{
                perfil: perfilSeleccionado,
                id: '${usuario?.id}'
            },
            success: function (msg){
                var parts = msg.split("_");
                if(parts[0] == 'ok'){
                    log("Perfil agregado correctamente",'success')
                    cargarPerfiles();
                }else{
                    log(parts[1],'error')
                }
            }
        });


    });

</script>
