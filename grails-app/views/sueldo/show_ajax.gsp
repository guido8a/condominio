
<%@ page import="condominio.Sueldo" %>

<g:if test="${!sueldoInstance}">
    <elm:notFound elem="Sueldo" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${sueldoInstance?.anio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Anio
                </div>
                
                <div class="col-md-4">
                    ${sueldoInstance?.anio?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${sueldoInstance?.empleado}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Empleado
                </div>
                
                <div class="col-md-4">
                    ${sueldoInstance?.empleado?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${sueldoInstance?.valor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Valor
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${sueldoInstance}" field="valor"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>