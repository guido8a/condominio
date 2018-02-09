
<%@ page import="condominio.TipoOcupacion" %>

<g:if test="${!tipoOcupacionInstance}">
    <elm:notFound elem="TipoOcupacion" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${tipoOcupacionInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoOcupacionInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${tipoOcupacionInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoOcupacionInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>