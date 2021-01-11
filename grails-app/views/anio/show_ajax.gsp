
<%@ page import="utilitarios.Anio" %>

<g:if test="${!anioInstance}">
    <elm:notFound elem="Anio" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${anioInstance?.numero}">
            <div class="row">
                <div class="col-md-4 show-label">
                    Numero
                </div>
                
                <div class="col-md-6">
                    <g:fieldValue bean="${anioInstance}" field="numero"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${anioInstance?.sueldoBasico}">
            <div class="row">
                <div class="col-md-4 show-label">
                    Sueldo Básico
                </div>
                
                <div class="col-md-6">
                    <g:fieldValue bean="${anioInstance}" field="sueldoBasico"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${anioInstance?.estado}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Estado
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${anioInstance}" field="estado"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>