<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 28/02/18
  Time: 11:35
--%>


<div class="row">
    <div class="col-md-2">
        <label>Fecha:</label>
    </div>
    <div class="col-md-5">
        <elm:datepicker name="fechaGenera_name" id="fechaImprime" class="datepicker form-control" value="${new Date()}"/>
    </div>
    <div class="col-md-2">
        <a href="#" class="btn btn-success btnImprime" ><i class="fa fa-print"></i> Imprimir</a>
    </div>
</div>

<script type="text/javascript">

    $(".btnImprime").click(function () {
       var fechaI = $("#fechaImprime").val();
        location.href = "${g.createLink(controller:'reportes', action: 'pagosPendientes3')}?fecha=" + fechaI
     });

</script>