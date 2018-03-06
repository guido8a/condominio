<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 01/03/18
  Time: 11:08
--%>


<style type="text/css">
.flotarderecha{
    float: right;
}
</style>


<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-5 alert alert-warning">
        <div class="col-md-8">
            <label>Saldo Inicial: </label>
            <p>select * from saldos('1-feb-2018', '28-feb-2018'); --> sldoinic</p>
        </div>
        <div class="col-md-4 flotarderecha">
            <g:textField name="saldo_name" value="${0.00}" class="form-control" readonly=""/>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-5 alert alert-success">
        <div class="col-md-12">
            <label>Ingresos</label>
            <p>select * from aportes('1-feb-2018', '28-feb-2018');</p>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-5 alert alert-info">
        <div class="col-md-12">
            <label>Egresos</label>
            <p>select * from egresos('1-feb-2018', '28-feb-2018');</p>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-5 alert alert-warning">
        <div class="col-md-8">
            <label>Saldo a la fecha: </label>
            <p>select * from saldos('1-feb-2018', '28-feb-2018'); --> sldofnal</p>
        </div>
        <div class="col-md-4 flotarderecha">
            <g:textField name="saldo_name" value="${0.00}" class="form-control" readonly=""/>
        </div>
    </div>
</div>


<div class="row">
    %{--<div class="col-md-2"></div>--}%
    <div class="col-md-10 alert alert-warning">
        <div class="col-md-3">
            <label>Aportes y otras deudas por cobrar:</label>
            <p>select * from saldos('1-feb-2018', '28-feb-2018'); --> ingrsldo</p>
        </div>
        <div class="col-md-2">
            <g:textField name="saldoE_name" value="${0.00}" class="form-control" readonly=""/>
        </div>

        <div class="col-md-3">
            <label>Pagos pendientes:</label>
            <p>select * from saldos('1-feb-2018', '28-feb-2018'); --> egrssldo</p>
        </div>
        <div class="col-md-2">
            <g:textField name="saldoE_name" value="${0.00}" class="form-control" readonly=""/>
        </div>
        <div class="col-md-1">
            <label>Resultado final:</label>
        </div>
        <div class="col-md-1">
            <g:textField name="saldoE_name" value="${0.00}" class="form-control" readonly=""/>
        </div>
    </div>
</div>