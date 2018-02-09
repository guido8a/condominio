
<%@ page import="seguridad.Persona" %>

<g:if test="${!personaInstance}">
    <elm:notFound elem="Persona" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        
        <g:if test="${personaInstance?.nombre}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Nombre
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.apellido}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Apellido
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="apellido"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.ruc}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Ruc
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="ruc"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.sexo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Sexo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="sexo"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.mail}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Mail
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="mail"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.login}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Login
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="login"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.autorizacion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Autorizacion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="autorizacion"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.activo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Activo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="activo"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.telefono}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Telefono
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="telefono"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.fechaInicio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Inicio
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${personaInstance?.fechaInicio}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.fechaFin}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Fin
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${personaInstance?.fechaFin}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.cargo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Cargo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="cargo"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.direccion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Direccion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="direccion"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Observaciones
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="observaciones"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.alicuota}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Alicuota
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="alicuota"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.departamento}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Departamento
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="departamento"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.edificio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Edificio
                </div>
                
                <div class="col-md-4">
                    ${personaInstance?.edificio?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.fecha}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${personaInstance?.fecha}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.fechaNacimiento}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Nacimiento
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${personaInstance?.fechaNacimiento}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.perfiles}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Perfiles
                </div>
                
                <div class="col-md-4">
                    <ul>
                        <g:each in="${personaInstance.perfiles}" var="p">
                            <li>${p?.encodeAsHTML()}</li>
                        </g:each>
                    </ul>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${personaInstance?.tipoOcupacion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tipo Ocupacion
                </div>
                
                <div class="col-md-4">
                    ${personaInstance?.tipoOcupacion?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
        
    </div>
</g:else>