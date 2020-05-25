
<%@ page import="condominio.Admin" %>

<g:if test="${!adminInstance}">
    <elm:notFound elem="Admin" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${adminInstance?.fechaFin}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Fin
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${adminInstance?.fechaFin}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${adminInstance?.saldoFinal}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Saldo Final
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${adminInstance}" field="saldoFinal"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${adminInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Observaciones
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${adminInstance}" field="observaciones"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${adminInstance?.administrador}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Administrador
                </div>
                
                <div class="col-md-4">
                    ${adminInstance?.administrador?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${adminInstance?.fechaInicio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Inicio
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${adminInstance?.fechaInicio}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${adminInstance?.revisor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Revisor
                </div>
                
                <div class="col-md-4">
                    ${adminInstance?.revisor?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${adminInstance?.saldoInicial}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Saldo Inicial
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${adminInstance}" field="saldoInicial"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>