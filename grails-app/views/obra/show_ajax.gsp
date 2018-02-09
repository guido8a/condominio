
<%@ page import="condominio.Obra" %>

<g:if test="${!obraInstance}">
    <elm:notFound elem="Obra" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${obraInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${obraInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Observaciones
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${obraInstance}" field="observaciones"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.fecha}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${obraInstance?.fecha}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.fechaFin}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Fin
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${obraInstance?.fechaFin}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.fechaInicio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Inicio
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${obraInstance?.fechaInicio}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.persona}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Persona
                </div>
                
                <div class="col-md-4">
                    ${obraInstance?.persona?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.plazo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Plazo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${obraInstance}" field="plazo"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.presupuesto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Presupuesto
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${obraInstance}" field="presupuesto"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.proveedor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Proveedor
                </div>
                
                <div class="col-md-4">
                    ${obraInstance?.proveedor?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${obraInstance?.tipoObra}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tipo Obra
                </div>
                
                <div class="col-md-4">
                    ${obraInstance?.tipoObra?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>