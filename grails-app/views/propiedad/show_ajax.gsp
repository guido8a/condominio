
<%@ page import="condominio.Propiedad" %>

<g:if test="${!propiedadInstance}">
    <elm:notFound elem="Propiedad" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${propiedadInstance?.persona}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Persona
                </div>

                <div class="col-md-8">
                    ${propiedadInstance?.persona?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${propiedadInstance?.tipoPropiedad}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tipo de Propiedad
                </div>

                <div class="col-md-8">
                    ${propiedadInstance?.tipoPropiedad?.descripcion?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${propiedadInstance?.numero}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Número
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${propiedadInstance}" field="numero"/>
                </div>

            </div>
        </g:if>

        <g:if test="${propiedadInstance?.area}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Área
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${propiedadInstance}" field="area"/>
                </div>

            </div>
        </g:if>

        <g:if test="${propiedadInstance?.valor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Valor
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${propiedadInstance}" field="valor"/>
                </div>

            </div>
        </g:if>


        <g:if test="${propiedadInstance?.alicuota}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Alícuota
                </div>
                
                <div class="col-md-4">
                   ${propiedadInstance?.alicuota} %
                </div>
                
            </div>
        </g:if>
        

        
        <g:if test="${propiedadInstance?.fechaDesde}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Desde
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${propiedadInstance?.fechaDesde}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${propiedadInstance?.fechaHasta}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Hasta
                </div>
                
                <div class="col-md-4">
                    <g:formatDate date="${propiedadInstance?.fechaHasta}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
        

        
        <g:if test="${propiedadInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Observaciones
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${propiedadInstance}" field="observaciones"/>
                </div>
                
            </div>
        </g:if>
        

        

        
    </div>
</g:else>