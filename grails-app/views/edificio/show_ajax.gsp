
<%@ page import="condominio.Edificio" %>

<g:if test="${!edificioInstance}">
    <elm:notFound elem="Edificio" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${edificioInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${edificioInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>