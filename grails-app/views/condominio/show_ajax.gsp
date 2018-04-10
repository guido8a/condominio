
<%@ page import="condominio.Condominio" %>

<g:if test="${!condominioInstance}">
    <elm:notFound elem="Condominio" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${condominioInstance?.tipoCondominio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tipo Condominio
                </div>
                
                <div class="col-md-4">
                    ${condominioInstance?.tipoCondominio?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.canton}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Canton
                </div>
                
                <div class="col-md-4">
                    ${condominioInstance?.canton?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.nombre}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Nombre
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${condominioInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.ruc}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Ruc
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${condominioInstance}" field="ruc"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.direccion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Direccion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${condominioInstance}" field="direccion"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.telefono}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Telefono
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${condominioInstance}" field="telefono"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.fechaInicio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Inicio
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${condominioInstance?.fechaInicio}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.fechaFin}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Fin
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${condominioInstance?.fechaFin}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.email}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Email
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${condominioInstance}" field="email"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.sigla}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Sigla
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${condominioInstance}" field="sigla"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${condominioInstance?.numeroViviendas}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Numero Viviendas
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${condominioInstance}" field="numeroViviendas"/>
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>