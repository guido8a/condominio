
<%@ page import="condominio.Alicuota" %>

<g:if test="${!alicuotaInstance}">
    <elm:notFound elem="Alicuota" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${alicuotaInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Observaciones
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${alicuotaInstance}" field="observaciones"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${alicuotaInstance?.fechaDesde}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Desde
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${alicuotaInstance?.fechaDesde}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${alicuotaInstance?.fechaHasta}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Hasta
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${alicuotaInstance?.fechaHasta}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${alicuotaInstance?.persona}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Persona
                </div>
                
                <div class="col-md-4">
                    ${alicuotaInstance?.persona?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${alicuotaInstance?.valor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Valor
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${alicuotaInstance}" field="valor"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>