
<%@ page import="condominio.Admin" %>

<g:if test="${!adminInstance}">
    <elm:notFound elem="Admin" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        <g:hiddenField name="id" value="${adminInstance?.id}" />
        <g:form class="form-horizontal panel alert alert-success" name="anti" role="form" action="" method="POST">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3">
                        Administrador:
                    </label>
                    <div class="col-md-3">
                        ${adminInstance?.administrador?.nombre + " " + adminInstance?.administrador?.apellido}
                    </div>
                </span>
                <span class="grupo">
                    <label class="col-md-3">
                        Revisor:
                    </label>
                    <div class="col-md-3">
                        ${adminInstance?.revisor?.nombre + " " + adminInstance?.revisor?.apellido}
                    </div>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3">
                        Fecha de Inicio:
                    </label>
                    <div class="col-md-3">
                        ${adminInstance?.fechaInicio?.format("dd-MM-yyyy")}
                    </div>
                </span>
                <g:if test="${adminInstance?.fechaFin}">
                    <span class="grupo">
                        <label class="col-md-3">
                            Fecha fin:
                        </label>
                        <div class="col-md-3">
                            ${adminInstance?.fechaFin?.format("dd-MM-yyyy")}
                        </div>
                    </span>
                </g:if>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3">
                        Saldo Inicial:
                    </label>
                    <div class="col-md-3">
                        ${adminInstance?.saldoInicial ?: 0.00}
                    </div>
                </span>
                <span class="grupo">
                    <label class="col-md-3">
                        Saldo Final:
                    </label>
                    <div class="col-md-3">
                        ${adminInstance?.saldoFinal ?: 0.00}
                    </div>
                </span>
            </div>

            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3">
                        Observaciones:
                    </label>
                    <div class="col-md-9">
                        ${adminInstance?.observaciones}
                    </div>
                </span>
            </div>
        </g:form>
    </div>
</g:else>