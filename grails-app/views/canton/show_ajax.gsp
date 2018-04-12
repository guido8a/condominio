
<%@ page import="condominio.Canton" %>

<g:if test="${!cantonInstance}">
    <elm:notFound elem="Canton" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${cantonInstance?.nombre}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Nombre
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${cantonInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${cantonInstance?.provincia}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Provincia
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${cantonInstance}" field="provincia"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>