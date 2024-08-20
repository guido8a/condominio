<div class="row-fluid"  style="width: 99.7%;height: 250px;overflow-y: auto;float: right; margin-top: -20px">
    <table class="table table-bordered table-hover table-condensed">
        <tbody>
        <g:each in="${cuentas}" var="cuenta">
            <tr>
                <td style="width: 20%">${cuenta.numero}</td>
                <td style="width: 60%">${cuenta.descripcion}</td>
                <td style="width: 10%">${cuenta.nivel.descripcion}</td>
                <td style="width: 10%; text-align: center">
                    <a href="#" class="btn btn-success seleccionarCuenta" data-id="${cuenta.id}" data-codigo="${cuenta?.numero}" data-nombre="${cuenta?.descripcion}" title="Agregar cuenta">
                        <i class="fa fa-check"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".seleccionarCuenta").click(function () {
        var cuenta = $(this).data('id');
        var codigo = $(this).data('codigo');
        var nombre = $(this).data('nombre');

        $("#idCuentaNueva").val(cuenta);
        $("#codigoAsiento").val(codigo);
        $("#nombreAsiento").val(nombre);

        cerrarBuscarCuenta();
    });

</script>