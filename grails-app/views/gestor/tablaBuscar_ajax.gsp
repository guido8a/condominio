<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/05/17
  Time: 13:11
--%>
<table class="table table-bordered table-hover table-condensed">
    <tbody>
        <g:each in="${cuentas}" var="cuenta">
            <tr>
                <td style="width: 30px">${cuenta.numero}</td>
                <td style="width: 310px">${cuenta.descripcion}</td>
                <td style="width: 20px">${cuenta.nivel.descripcion}</td>
                <td style="width: 90px">
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

<script type="text/javascript">

    $(".agregarDebe").click(function () {
            var gestor = '${gestor?.id}';
            var tipo = '${tipo?.id}';
            var cuenta = $(this).attr('cuenta');

            $.ajax({
                type: 'POST',
                url: "${createLink(controller: 'gestorContable', action: 'agregarDebeHaber_ajax')}",
                data:{
                    gestor: gestor,
                    tipo: tipo,
                    cuenta: cuenta,
                    dif: 'D'
                },
                success:function (msg) {
                    if(msg == 'ok'){
                        bootbox.hideAll();
                        cargarMovimientos(gestor, tipo);
                        revisarAsientos();
                    }else{

                    }
                }
            })
    });

    $(".agregarHaber").click(function () {
        var gestor = '${gestor?.id}';
        var tipo = '${tipo?.id}';
        var cuenta = $(this).attr('cuenta');

        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'gestorContable', action: 'agregarDebeHaber_ajax')}",
            data:{
                gestor: gestor,
                tipo: tipo,
                cuenta: cuenta,
                dif: 'H'
            },
            success:function (msg) {
                if(msg == 'ok'){
                    bootbox.hideAll();
                    cargarMovimientos(gestor, tipo);
                    revisarAsientos();
                }else{

                }
            }
        })
    });


</script>