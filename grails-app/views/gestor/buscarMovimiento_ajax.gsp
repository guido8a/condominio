<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/05/17
  Time: 12:40
--%>

<div class="row" style="margin-bottom: 10px">
    <div class="col-xs-3 negrilla">
        C&oacute;digo:
        <input type="text" class=" form-control label-shared" style="width: 150px" name="codigo" id="codigoBus"/>
    </div>
    <div class="col-xs-3 negrilla">
        Nombre:
        <input type="text" class=" form-control label-shared" style="width: 150px" name="nombreBus" id="nombreBus"/>
    </div>
    <div class="col-xs-2 negrilla">
        <input type="hidden" name="movimientos" value="1"/>
        <a href="#" class="btn btn-azul btnBuscar"  id="buscarM">
            <i class="fa fa-search"></i>
            Buscar
        </a>
    </div>
</div>


<table class="table table-bordered table-hover table-condensed">
    <thead>
    <tr>
        <th style="width: 30px">C&oacute;digo</th>
        <th style="width: 230px">Nombre</th>
        <th style="width: 10px">Nivel</th>
        <th style="width: 30px">Acciones</th>
    </tr>
    </thead>
</table>

<div class="row-fluid"  style="width: 99.7%;height: 250px;overflow-y: auto;float: right;">
    <div class="span12">
        <div id="divTablaMovimientos" style="width: 1030px; height: 250px;"></div>
    </div>
</div>

<script type="text/javascript">

    $("#buscarM").click(function (){
        var cod = $("#codigoBus").val();
        var nom = $("#nombreBus").val();
        buscarCuenta(cod, nom);

    });

    function buscarCuenta (cod, nom) {
        openLoader("Buscando");
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'gestorContable', action: 'tablaBuscar_ajax')}",
            data:{
                empresa: '${empresa?.id}',
                codigo: cod,
                nombre: nom,
                gestor: '${gestor?.id}',
                tipo: '${tipo?.id}'
            },
            success: function (msg){
                closeLoader();
                $("#divTablaMovimientos").html(msg)
            }
        });
    }

    $("input").keydown(function (ev) {
        if (ev.keyCode == 13) {
            var cod = $("#codigoBus").val();
            var nom = $("#nombreBus").val();
            buscarCuenta(cod, nom);
            return false;
        }
        return true;
    });

</script>