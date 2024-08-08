<div id="divPlanCuentasAll" style="width: 100%; min-height: 150px; ">
    <div style="width: 1080px;min-height: 10px; margin-top: 2px;border:none;margin-bottom: 15px; ">
        <div id="agregarCuentas"></div>
    </div>
</div>

<g:if test="${!nuevo}">
    <script type="text/javascript">
        $(function () {

            function cargarCuentas() {
                openLoader()
                $.ajax({
                    type    : "POST",
                    url     : "${g.createLink(action: 'cargarCuentas',controller: 'gestorContable')}",
                    data    : " ",
                    success : function (msg) {
                        closeLoader()
                        $("#agregarCuentas").html(msg);
                    }
                });
            }

            cargarCuentas();
        });

    </script>
</g:if>