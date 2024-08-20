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
        <th style="width: 20%">C&oacute;digo</th>
        <th style="width: 60%">Nombre</th>
        <th style="width: 10%">Nivel</th>
        <th style="width: 10%">Acciones</th>
    </tr>
    </thead>
</table>

<div id="divTablaMovimientos"></div>

<script type="text/javascript">

    buscarCuenta();

    $("#buscarM").click(function (){
        buscarCuenta();
    });

    function buscarCuenta () {
        var cod = $("#codigoBus").val();
        var nom = $("#nombreBus").val();
        openLoader("Buscando...");
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'asiento', action: 'tablaCuentas_ajax')}",
            data:{
                codigo: cod,
                nombre: nom
            },
            success: function (msg){
                closeLoader();
                $("#divTablaMovimientos").html(msg)
            }
        });
    }

    $("input").keydown(function (ev) {
        if (ev.keyCode === 13) {
            buscarCuenta();
            return false;
        }
        return true;
    });

</script>