<%@ page import="cratos.Cuenta" %>

<g:if test="${!cuentaInstance}">
    <elm:notFound elem="Cuenta" genero="a"/>
</g:if>
<g:else>

    <g:if test="${cuentaInstance?.padre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Padre
            </div>

            <div class="col-md-7">
                ${cuentaInstance?.padre?.encodeAsHTML()}
            </div>

        </div>
    </g:if>

    <g:if test="${cuentaInstance?.nivel}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nivel
            </div>

            <div class="col-md-3">
                ${cuentaInstance?.nivelId}
            </div>

        </div>
    </g:if>

    <g:if test="${cuentaInstance?.numero}">
        <div class="row">
            <div class="col-md-2 text-info">
                Número
            </div>

            <div class="col-md-3">
                <g:fieldValue bean="${cuentaInstance}" field="numero"/>
            </div>

        </div>
    </g:if>

    <g:if test="${cuentaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripción
            </div>

            <div class="col-md-7">
                <g:fieldValue bean="${cuentaInstance}" field="descripcion"/>
            </div>

        </div>
    </g:if>

    <div class="row">
        <div class="col-md-2 text-info">
            Auxiliar
        </div>

        <div class="col-md-3">
            <g:message code="cuenta.auxiliar.${cuentaInstance.auxiliar}"/>
        </div>

    </div>

    <div class="row">
        <div class="col-md-2 text-info">
            Movimiento
        </div>

        <div class="col-md-3">
            <g:message code="cuenta.movimiento.${cuentaInstance.movimiento}"/>
        </div>

    </div>

    <g:if test="${cuentaInstance?.retencion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Genera Retención
            </div>

            <div class="col-md-3">
                <g:message code="cuenta.retencion.${cuentaInstance.retencion}"/>
            </div>

        </div>
    </g:if>

    <g:if test="${cuentaInstance?.cuentaBanco}">
        <div class="row">
            <div class="col-md-2 text-info">
                Cuenta Banco
            </div>

            <div class="col-md-3">
                ${cuentaInstance?.cuentaBanco?.encodeAsHTML()}
            </div>

        </div>
    </g:if>

    <g:if test="${cuentaInstance?.impuesto}">
        <div class="row">
            <div class="col-md-2 text-info">
                Impuesto
            </div>

            <div class="col-md-3">
                ${cuentaInstance?.impuesto?.encodeAsHTML()}
            </div>

        </div>
    </g:if>

</g:else>