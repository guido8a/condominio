<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 01/06/20
  Time: 10:48
--%>

<div class="row">
    <div class="col-md-1 col-xs-1">
    </div>
    <div class="col-md-3 col-xs-3">
        <label>Generar para deudas con </label>
    </div>
    <div class="col-md-7 col-xs-7">
        <g:select from="${['1':'Valores superiores a 1 alícuota',
                           '2':'Valores superiores a 2 alícuotas',
                           '3':'Valores superiores a 3 alícuotas']}"
                  optionValue="value" optionKey="key" name="mesesHasta_name"
                  id="valorHasta" class="form-control"/>
    </div>
</div>