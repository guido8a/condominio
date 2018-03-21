<%@ page import="condominio.Pago" %>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/03/18
  Time: 11:33
--%>

<style type="text/css">

.derecha{
    text-align: right;
}

</style>

<div class="row">
    <div class="alert alert-success">
        <div style="width: 100%; text-align: center; ">
            <label>Deudas</label>
            <table class=" col-md-12 table-bordered table-condensed">
                <tr style="width:100%;">
                    <th style="width: 37%">Concepto</th>
                    <th style="width: 20%">Valor</th>
                    <th style="width: 20%">Pagado</th>
                    <th style="width: 20%">Saldo</th>
                    <th style="width: 3%"></th>
                </tr>
            </table>

            <g:if test="${pendientes.size() > 0}">
                <div class="" style="width: 100%; height: 200px; overflow-y:auto;" >
                    <table class="table-bordered table-condensed table-hover" width="98%">
                        <g:each in="${pendientes}" var="pendiente">
                            <tr style="width: 100%">
                                <td style="width: 37%">${pendiente.oblg}</td>
                                <td class="derecha" style="width: 20%">${pendiente.ingrvlor}</td>
                                <td class="derecha" style="width: 20%">${pendiente.ingrabno}</td>
                                <td class="derecha" style="width: 20%">${pendiente.sldo}</td>
                            </tr>
                        </g:each>
                    </table>
                </div>
            </g:if>
            <g:else>
                <div class="alert alert-info" style="text-align: center; margin-top: 15px">
                    No tiene deudas a la fecha seleccionada
                </div>
            </g:else>
        </div>
    </div>
</div>