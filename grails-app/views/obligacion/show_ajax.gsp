
<%@ page import="condominio.Obligacion" %>

<g:if test="${!obligacionInstance}">
    <elm:notFound elem="Obligacion" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${obligacionInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${obligacionInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obligacionInstance?.fecha}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${obligacionInstance?.fecha}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obligacionInstance?.tipo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tipo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${obligacionInstance}" field="tipo"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obligacionInstance?.valor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Valor
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${obligacionInstance}" field="valor"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>