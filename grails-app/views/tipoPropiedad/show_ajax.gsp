
<%@ page import="condominio.TipoPropiedad" %>

<g:if test="${!tipoPropiedadInstance}">
    <elm:notFound elem="TipoPropiedad" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${tipoPropiedadInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripción
                </div>
                
                <div class="col-md-6">
                    <g:fieldValue bean="${tipoPropiedadInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>