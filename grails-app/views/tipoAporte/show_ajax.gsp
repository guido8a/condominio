
<%@ page import="condominio.TipoAporte" %>

<g:if test="${!tipoAporteInstance}">
    <elm:notFound elem="TipoAporte" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${tipoAporteInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripción
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoAporteInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>