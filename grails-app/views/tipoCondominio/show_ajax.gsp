
<%@ page import="condominio.TipoCondominio" %>

<g:if test="${!tipoCondominioInstance}">
    <elm:notFound elem="TipoCondominio" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${tipoCondominioInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoCondominioInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>