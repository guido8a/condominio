<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 07/01/21
  Time: 13:08
--%>

<table class="table table-bordered table-hover table-condensed" style="width: 100%">
    <thead>
    <tr>
        <th class="alinear" style="width: 40%">Año</th>
        <th class="alinear" style="width: 50%">Sueldo</th>
        <th class="alinear" style="width: 10%"><i class="fa fa-edit"></i> </th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${sueldos}" var="sueldo">
        <tr>
            <td>${sueldo?.anio?.numero}</td>
            <td>${g.formatNumber(number: sueldo?.valor ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}</td>
            <td><a href="#" class="btn btn-sm btn-info btnEditarSueldo" title="Editar sueldo" data-valor="${sueldo?.valor}" data-anio="${sueldo?.anio?.id}" data-id="${sueldo?.id}"><i class="fa fa-edit"></i> </a> </td>
        </tr>
    </g:each>
    </tbody>
</table>

<script type="text/javascript">

    $(".btnEditarSueldo").click(function () {
        var anio = $(this).data("anio");
        var valor = $(this).data("valor");
        var sueldo = $(this).data("id");
        $("#anio").val(anio);
        $("#valor").val(valor);
        $("#id").val(sueldo);
    });

</script>