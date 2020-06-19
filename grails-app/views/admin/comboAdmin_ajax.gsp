<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/06/20
  Time: 11:09
--%>

<g:select id="nuevoAdministrador" name="administrador_name" from="${listaAdmin}"
          optionKey="id" optionValue="${{it.nombre + " " + it.apellido + " - Departamento: " + "(" + it.departamento + ")"}}" required="" value="${adminInstance?.administrador?.id}"
          class="many-to-one form-control"/>

<script type="text/javascript">

    cargarComboRevisor($("#nuevoAdministrador option:selected").val());

    $("#nuevoAdministrador").click(function () {
       var seleccionado = $("#nuevoAdministrador option:selected").val();
       cargarComboRevisor(seleccionado);
    });

</script>