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
        <div class="col-md-3">
            <label>Saldo Inicial: </label>
        </div>
        <div class="col-md-4 flotarderecha">
            <g:textField name="saldo_name" value="${0.00}" class="form-control" readonly=""/>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-5 alert alert-success">
        <div class="col-md-3">
            <label>Ingresos</label>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-5 alert alert-info">
        <div class="col-md-3">
            <label>Egresos</label>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-5 alert alert-warning">
        <div class="col-md-3">
            <label>Saldo Libros: </label>
        </div>
        <div class="col-md-4 flotarderecha">
            <g:textField name="saldoE_name" value="${0.00}" class="form-control" readonly=""/>
        </div>
    </div>
</div>