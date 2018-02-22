
<%@ page import="condominio.Pago" %>

<g:if test="${!pagoInstance}">
    <elm:notFound elem="Pago" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${pagoInstance?.documento}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Documento
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${pagoInstance}" field="documento"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${pagoInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Observaciones
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${pagoInstance}" field="observaciones"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${pagoInstance?.fechaPago}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Pago
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${pagoInstance?.fechaPago}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${pagoInstance?.ingreso}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Ingreso
                </div>
                
                <div class="col-md-4">
                    ${pagoInstance?.ingreso?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${pagoInstance?.valor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Valor
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${pagoInstance}" field="valor"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>