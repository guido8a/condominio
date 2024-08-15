<div class="row-fluid"  style="width: 99.7%;height: 250px;overflow-y: auto;float: right; margin-top: -20px">
    <table class="table table-bordered table-hover table-condensed">
        <tbody>
        <g:each in="${cuentas}" var="cuenta">
            <tr>
                <td style="width: 20%">${cuenta.numero}</td>
                <td style="width: 50%">${cuenta.descripcion}</td>
                <td style="width: 10%">${cuenta.nivel.descripcion}</td>
                <td style="width: 20%; text-align: center">
                    <a href="#" class="btn btn-success agregarDebe" cuenta="${cuenta.id}" title="Agregar cuenta como Debe">
                        <i class="fa fa-chevron-up"></i>
                        Debe
                    </a>
                    <a href="#" class="btn btn-info agregarHaber" cuenta="${cuenta.id}" title="Agregar cuenta como Haber">
                        <i class="fa fa-chevron-down"></i>
                        Haber
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".agregarDebe").click(function () {
        var gestor = '${gestor?.id}';
        var tipo = '${tipo?.id}';
        var cuenta = $(this).attr('cuenta');
        cargarDebeHaber(gestor, tipo, cuenta, 'D')
    });

    $(".agregarHaber").click(function () {
        var gestor = '${gestor?.id}';
        var tipo = '${tipo?.id}';
        var cuenta = $(this).attr('cuenta');
        cargarDebeHaber(gestor, tipo, cuenta, 'H')
    });

    function cargarDebeHaber(gestor, tipo, cuenta, dif) {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'gestor', action: 'agregarDebeHaber_ajax')}",
            data:{
                gestor: gestor,
                tipo: tipo,
                cuenta: cuenta,
                dif: dif
            },
            success:function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cargarMovimientos(gestor, tipo);
                    revisarAsientos();
                    setTimeout(function () {
                        bootbox.hideAll();
                    }, 1000);
                }else{
                    log(parts[1], "error")
                }
            }
        })
    }

</script>