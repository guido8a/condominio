<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 23/11/18
  Time: 10:35
--%>


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
</div>

