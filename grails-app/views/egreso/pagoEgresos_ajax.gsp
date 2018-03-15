<%@ page import="condominio.PagoEgreso" %>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 15/03/18
  Time: 15:04
--%>

<div class="alert alert-warning col-md-12">

    <div class="col-md-1">
        <label>Valor:</label>
    </div>

    <div class="col-md-2">
        <g:textField name="saldo_name" class="form-control derecha" readonly=""
                     value="${g.formatNumber(number: egreso?.valor ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
    </div>
    <div class="col-md-1">
        <label style="color: #1b8e36">Pagado:</label>
    </div>
    <div class="col-md-2">
        <g:textField name="saldo_name" class="form-control derecha" readonly=""
                     value="${g.formatNumber(number: pagos?.valor?.sum() ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
    </div>
    <div class="col-md-1">
        <label style="color: #701b19">Saldo:</label>
    </div>
    <div class="col-md-2">
        <g:textField name="saldo_name" class="form-control derecha" readonly=""
                     value="${g.formatNumber(number: saldo ?: 0, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'en_US')}"/>
    </div>

    <div class="col-md-3">
        <a href="#" class="btn btn-success btn-sm btnAdd ${(saldo ?: 0) > 0 ? '' : 'disabled'}" data-ing="${egreso?.id}" title="Ingresar Pago">
            <i class="fa fa-plus"></i> Pagar
        </a>
        <a href="#" class="btn btn-info btn-sm btnEd ${(saldo ?: 0) > 0 ? '' : 'disabled'}" data-ing="${egreso?.id}" title="Editar Egreso">
            <i class="fa fa-pencil"></i> Editar
        </a>
    </div>

</div>

<g:if test="${pagos.size() > 0}">
    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <tr>
            <th>Concepto del egreso</th>
            <th>Documento de Pago</th>
            <th>Fecha Pago</th>
            <th>Pago</th>
            <th><i class="fa fa-pencil"></i></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${pagos}" var="pagoUsuario">
            <tr data-id="${pagoUsuario.id}">
                <td >${pagoUsuario?.observaciones}</td>
                <td>${pagoUsuario?.documento}</td>
                <td><g:formatDate date="${pagoUsuario?.fechaPago}" format="dd-MM-yyyy"/></td>
                <td class="derecha"><g:formatNumber number="${pagoUsuario?.valor}" format="##,##0" locale="en_US" maxFractionDigits="2" minFractionDigits="2"/></td>
                <td style="text-align: center">
                    <a href="#" class="btn btn-info btn-sm btnEditar" data-id="${pagoUsuario?.id}" data-ing="${egreso?.id}" title="Editar Pago">
                        <i class="fa fa-pencil"></i>
                    </a>
                    <a href="#" class="btn btn-danger btn-sm btnEliminar" data-id="${pagoUsuario?.id}" title="Borrar Pago">
                        <i class="fa fa-trash-o"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</g:if>
<g:else>
    <div class="alert alert-danger centro">
        No existen pagos
    </div>
</g:else>

