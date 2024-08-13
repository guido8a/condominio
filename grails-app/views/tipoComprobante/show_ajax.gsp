<%@ page import="cratos.TipoComprobante" %>

<g:if test="${!tipoComprobanteInstance}">
    <elm:notFound elem="TipoComprobante" genero="o"/>
</g:if>
<g:else>

    <g:if test="${tipoComprobanteInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Código
            </div>

            <div class="col-md-3">
                <g:fieldValue bean="${tipoComprobanteInstance}" field="codigo"/>
            </div>

        </div>
    </g:if>

    <g:if test="${tipoComprobanteInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripción
            </div>

            <div class="col-md-3">
                <g:fieldValue bean="${tipoComprobanteInstance}" field="descripcion"/>
            </div>

        </div>
    </g:if>

</g:else>