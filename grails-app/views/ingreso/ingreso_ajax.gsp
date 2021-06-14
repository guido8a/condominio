<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 14/06/21
  Time: 13:37
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmIngresoValor" role="form" action="saveValor_ajax" method="POST">
        <g:hiddenField name="id" value="${ingreso?.id}" />

        <div class="form-group keeptogether ${hasErrors(bean: ingreso, field: 'valor', 'error')} required">
            <span class="grupo">
                <label for="valor" class="col-md-2 control-label">
                    Valor:
                </label>
                <div class="col-md-6">
                    <g:textField name="valor" class="number form-control" value="${ingreso.valor}" />
                </div>
            </span>
        </div>
    </g:form>
</div>
