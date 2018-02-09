
<%@ page import="condominio.TipoGasto" %>

<g:if test="${!tipoGastoInstance}">
    <elm:notFound elem="TipoGasto" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${tipoGastoInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoGastoInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>