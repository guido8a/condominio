<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/06/20
  Time: 11:12
--%>

<g:select id="nuevoRevisor" name="revisor_name" from="${listaRevisor}"
          optionKey="id" optionValue="${{it.nombre + " " + it.apellido + " - Departamento: " + "(" + it.departamento + ")"}}" required=""
          value="${adminInstance?.revisor?.id}"
          class="many-to-one form-control"/>

<script type="text/javascript">

//    cargarComboAdmin($("#nuevoRevisor option:selected").val());

//    $("#nuevoRevisor").click(function () {
//        var seleccionado = $("#nuevoRevisor option:selected").val();
//        cargarComboAdmin(seleccionado);
//    });

</script>