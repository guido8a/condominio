<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/02/18
  Time: 10:26
--%>

<style type="text/css">

.letra{
    font-size: 11px;
    font-weight: bold;
}

</style>



<div class="fila">

    %{--<div class="col-md-1">--}%
    %{--<label class="letra">Grupo: </label>--}%
    %{--</div>--}%
    %{--<div class="col-md-3">--}%
    %{--<g:select name="grupo_name" id="grupo2"--}%
    %{--from="${cratos.inventario.Grupo.list([sort: 'codigo'])}"--}%
    %{--optionKey="id" optionValue="descripcion" noSelection="['-1': 'Seleccione el grupo']"--}%
    %{--class="form-control"/>--}%
    %{--</div>--}%

</div>



<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-2">
        <label>Desde: </label>
    </div>
    <div class="col-md-4">
        <elm:datepicker name="fechaDesde" title="Fecha desde" id="fechaDK2" class="datepicker form-control fechaDeK2"
                        maxDate="new Date()"/>
    </div>
</div>

<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-2">
        <label>Hasta: </label>
    </div>
    <div class="col-md-4">
        <elm:datepicker name="fechaHasta" title="Fecha hasta" id="fechaHK2" class="datepicker form-control fechaHaK2"
                        maxDate="new Date()"/>
    </div>
</div>

<div class="row">
    <div class="col-md-4"></div>
    <div class="col-md-2">
        <a href="#" class="btn btn-success" id="btnImpPagos">
            <i class="fa fa-print"></i> Imprimir
        </a>
    </div>
</div>


<script type="text/javascript">

    $("#btnImpPagos").click(function () {
        var fechaDesde = $(".fechaDeK2").val();
        var fechaHasta = $(".fechaHaK2").val();

        if(fechaDesde == '' || fechaHasta == ''){
            bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i>  Seleccione las fechas!")
        }else{
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportes', action: 'revisarFecha_ajax')}',
                data:{
                    desde: fechaDesde,
                    hasta: fechaHasta
                },
                success: function (msg){
                    if(msg == 'ok'){
                        url = "${g.createLink(controller:'reportes', action: 'pagosPendientes')}?desde=" + fechaDesde + 'Whasta=' + fechaHasta;
                        location.href = "${g.createLink(action: 'pdfLink',controller: 'pdf')}?url=" + url + '&filename=pagosPendientes.pdf';
                    }else{
                        bootbox.alert("<i class='fa fa-exclamation-circle fa-3x pull-left text-warning text-shadow'></i> La fecha ingresada en 'Hasta' es menor a la fecha ingresada en 'Desde' ");
                        return false;
                    }
                }
            });
        }
    });

</script>

