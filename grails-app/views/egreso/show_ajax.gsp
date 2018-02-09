
<%@ page import="condominio.Egreso" %>

<g:if test="${!egresoInstance}">
    <elm:notFound elem="Egreso" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${egresoInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${egresoInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${egresoInstance?.abono}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Abono
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${egresoInstance}" field="abono"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${egresoInstance?.estado}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Estado
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${egresoInstance}" field="estado"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${egresoInstance?.fecha}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${egresoInstance?.fecha}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${egresoInstance?.fechaPago}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Pago
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${egresoInstance?.fechaPago}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${egresoInstance?.proveedor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Proveedor
                </div>
                
                <div class="col-md-4">
                    ${egresoInstance?.proveedor?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${egresoInstance?.tipoGasto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tipo Gasto
                </div>
                
                <div class="col-md-4">
                    ${egresoInstance?.tipoGasto?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${egresoInstance?.valor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Valor
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${egresoInstance}" field="valor"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>