<div class="row">
    <div class="col-md-2">
        <label>Código:</label>
    </div>
    <div class="col-md-4">
        <input type="text" class="form-control" name="codigoAsiento_name" id="codigoAsiento" value="${asiento?.cuenta?.numero}" ${asiento ? 'readonly' : ''} style="width: 150px"/>
    </div>
    <div class="col-md-2">
        <a href="#" class="btn btn-info" id="btnBuscarCuenta"><i class="fa fa-search"></i> Buscar cuenta</a>
    </div>
</div>
<div class="row">
    <div class="col-md-2">
        <label>Nombre:</label>
    </div>
    <div class="col-md-7">
        <input type="text" class="form-control" name="nombreAsiento_name" id="nombreAsiento" value="${asiento?.cuenta?.descripcion}" ${asiento ? 'readonly' : ''} style="width: 400px"/>
    </div>
</div>
<div class="row">
    <div class="col-md-2">
        <label>Valor:</label>
    </div>
    <div class="col-md-10">
        <div class="col-md-2">DEBE</div>
        <div class="col-md-3">
            <g:textField type="number" name="valorAsientoDebe_name" id="valorAsientoDebe" class="validacionNumero form-control valorD" style="width: 90px;" value="${asiento?.debe ?: 0}" />
        </div>
        <div class="col-md-2">HABER</div>
        <div class="col-md-3">
            <g:textField type="number" name="valorAsientoHaber_name" id="valorAsientoHaber" class="validacionNumero form-control valorH" style="width: 90px;" value="${asiento?.haber ?: 0}" />
        </div>
    </div>
</div>
<g:hiddenField name="idCuenta_name" id="idCuentaNueva" value="${asiento?.cuenta?.id}"/>


<script type="text/javascript">

    var bc;

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
            ev.keyCode == 37 || ev.keyCode == 39 ||
            ev.keyCode == 110 || ev.keyCode == 190);
    }

    $(".validacionNumero").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {

    });

    $(".valorD").keydown(function (ev) {
        // $(".valorH").val(0).prop('readonly', true)
    }).keyup(function () {
        $(".valorH").val(0)
    });

    $(".valorH").keydown(function (ev) {
        // $(".valorD").val(0).prop('readonly', true)
    }).keyup(function () {
        $(".valorD").val(0)
    });

    $("#btnBuscarCuenta").click(function () {
        $.ajax({
            type   : "POST",
            url    : "${createLink(controller: 'asiento', action:'buscarCuenta_ajax')}",
            data   : {

            },
            success: function (msg) {
                bc = bootbox.dialog({
                    id   : "dlgBuscarCuenta",
                    title: "Buscar cuenta",
                    class   : "long",
                    message: msg,
                    buttons: {
                        cancelar: {
                            label    : "<i class='fa fa-times'></i> Cancelar",
                            className: "btn-primary",
                            callback : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    function cerrarBuscarCuenta(){
        bc.modal("hide");
    }


</script>

