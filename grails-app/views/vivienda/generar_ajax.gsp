<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/02/18
  Time: 14:32
--%>
<div class="row">
    %{--<div class="col-md-1"></div>--}%
    <div class="col-md-4">
       <label>Fecha:</label>
    </div>
    <div class="col-md-5">
        <elm:datepicker name="fechaGenera_name" id="fechaGenera" class="datepicker form-control btnG"
                        value="${new Date()}"/>
    </div>
    <div class="col-md-2">
        <a href="#" class="btn btn-success btnCrea" ><i class="fa fa-plus-circle"></i> Generar</a>
    </div>
</div>
<div class="row">
    %{--<div class="col-md-1"></div>--}%
    <div class="col-md-4">
        <label>Alícuota para el Mes de:</label>
    </div>
    <div class="col-md-5" id="divMes">

    </div>
</div>


<script type="text/javascript">

    mes($("#fechaGenera").val());

    function mes (fecha) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'vivienda', action: 'comboMes_ajax')}',
            data:{
                fecha: fecha
            },
            success: function (msg) {
                $("#divMes").html(msg)
            }
        })
    }

    $("#fechaGenera").change(function () {
      var fechaSel = $(this).val();
        mes(fechaSel);
    });

    $(".btnCrea").click(function () {
       $.ajax({
           type: 'POST',
           url: '${createLink(controller: 'vivienda', action: 'genera')}',
           data:{
                fecha: $("#fechaGenera").val()
           },
           success: function (msg){
                if(msg == 'ok'){
                    bootbox.alert("Alícuotas creadas correctamente")
                }else{
                    bootbox.alert("<i class='fa fa-warning fa-3x pull-left text-warning text-shadow'></i> Las Alícuotas ya se encuentran creadas para el mes seleccionado")
                }
           }
       }) ;
    });

</script>
