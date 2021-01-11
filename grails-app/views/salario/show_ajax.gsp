
<%@ page import="condominio.Salario" %>

<g:if test="${!salarioInstance}">
    <elm:notFound elem="Salario" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${salarioInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripción
                </div>
                <div class="col-md-4">
                    <g:fieldValue bean="${salarioInstance}" field="descripcion"/>
                </div>
            </div>
        </g:if>
    </div>
</g:else>