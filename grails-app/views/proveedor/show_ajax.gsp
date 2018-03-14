
<%@ page import="condominio.Proveedor" %>

<g:if test="${!proveedorInstance}">
    <elm:notFound elem="Proveedor" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${proveedorInstance?.ruc}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Ruc
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${proveedorInstance}" field="ruc"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${proveedorInstance?.nombre}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Nombre
                </div>
                
                <div class="col-md-8">
                    <g:fieldValue bean="${proveedorInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${proveedorInstance?.apellido}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Apellido
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${proveedorInstance}" field="apellido"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${proveedorInstance?.direccion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Dirección
                </div>
                
                <div class="col-md-8">
                    <g:fieldValue bean="${proveedorInstance}" field="direccion"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${proveedorInstance?.telefono}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Teléfono
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${proveedorInstance}" field="telefono"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${proveedorInstance?.mail}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Mail
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${proveedorInstance}" field="mail"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${proveedorInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Observaciones
                </div>
                
                <div class="col-md-8">
                    <g:fieldValue bean="${proveedorInstance}" field="observaciones"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${proveedorInstance?.activo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Estado
                </div>
                
                <div class="col-md-4">
                    %{--<g:fieldValue bean="${proveedorInstance}" field="activo"/>--}%
                    ${proveedorInstance?.activo == 'S' ? "Activo" : 'Inactivo'}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${proveedorInstance?.fecha}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${proveedorInstance?.fecha}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>