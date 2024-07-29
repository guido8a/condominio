<div class="modal-body">
    <div class="row">
        <div class="col-md-1 col-xs-1">
        </div>
        <div class="col-md-2 col-xs-2">
            <label>Desde</label>
        </div>
        <div class="col-md-4 col-xs-7">
            <elm:datepicker name="fechaDesdeDet_name" id="fechaDesdeDet" class="datepicker form-control"
                            value="${new Date() - 180}"/>
        </div>
        <div class="col-md-1 col-xs-1">
        </div>
    </div>

    <div class="row">
        <div class="col-md-1 col-xs-1">
        </div>
        <div class="col-md-2 col-xs-2">
            <label>Hasta</label>
        </div>
        <div class="col-md-4 col-xs-7">
            <elm:datepicker name="fechaHastaDet_name" id="fechaHastaDet" class="datepicker form-control" value="${new Date()}"/>
        </div>
        <div class="col-md-1 col-xs-1">
        </div>
    </div>

    <div class="row">
        <div class="col-md-1 col-xs-1">
        </div>
        <div class="col-md-2 col-xs-2">
            <label>Documento</label>
        </div>
        <div class="col-md-4 col-xs-7" id="divDocumento">

        </div>
        <div class="col-md-1 col-xs-1">
        </div>
    </div>

</div>

<script type="text/javascript">

    documento($("#fechaDesdeDet").val(), $("#fechaHastaDet").val());

    function documento (desde, hasta) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'documento_ajax')}',
            data:{
                desde: desde,
                hasta: hasta
            },
            success: function (msg) {
                $("#divDocumento").html(msg)
            }
        })
    }

    $("#fechaDesdeDet").change(function () {
        var desde = $(this).val();
        documento(desde, $("#fechaHastaDet").val());
    });

    $("#fechaHastaDet").change(function () {
        var hasta = $(this).val();
        documento($("#fechaDesdeDet").val(), hasta);
    });


</script>

