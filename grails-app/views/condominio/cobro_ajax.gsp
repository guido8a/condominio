<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 09/11/20
  Time: 14:59
--%>

<div class="modal-contenido">
    <div class="row">
        <div class="col-md-4 show-label">
            Abogado - Gestión de cobro
        </div>
        <div class="col-md-5">
            <g:textField name="gestion" value="${condominio?.monitorio}" class="form-control number int"/>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(".int").bind({
        keydown : function (ev) {
            return validarNum(ev);
        } //keydown
    });

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
        ev.keyCode == 190 || ev.keyCode == 110 ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39 ||
        ev.keyCode == 173 || ev.keyCode == 109);
    }

</script>
