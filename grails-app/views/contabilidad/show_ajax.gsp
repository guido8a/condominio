<%@ page import="cratos.Contabilidad" %>

<g:if test="${!contabilidadInstance}">
    <elm:notFound elem="Contabilidad" genero="o"/>
</g:if>
<g:else>

    <g:if test="${contabilidadInstance?.fechaInicio}">
        <div class="row">
            <div class="col-md-3 text-info">
                Fecha Inicio
            </div>

            <div class="col-md-3">
                <g:formatDate date="${contabilidadInstance?.fechaInicio}" format="dd-MM-yyyy"/>
            </div>

        </div>
    </g:if>

    <g:if test="${contabilidadInstance?.fechaCierre}">
        <div class="row">
            <div class="col-md-3 text-info">
                Fecha Cierre
            </div>

            <div class="col-md-3">
                <g:formatDate date="${contabilidadInstance?.fechaCierre}" format="dd-MM-yyyy"/>
            </div>

        </div>
    </g:if>

    <g:if test="${contabilidadInstance?.prefijo}">
        <div class="row">
            <div class="col-md-3 text-info">
                Prefijo
            </div>

            <div class="col-md-5">
                <g:fieldValue bean="${contabilidadInstance}" field="prefijo"/>
            </div>

        </div>
    </g:if>

    <g:if test="${contabilidadInstance?.descripcion}">
        <div class="row">
            <div class="col-md-3 text-info">
                Descripción
            </div>

            <div class="col-md-5">
                <g:fieldValue bean="${contabilidadInstance}" field="descripcion"/>
            </div>

        </div>
    </g:if>

    <g:if test="${contabilidadInstance?.cuenta}">
        <div class="row">
            <div class="col-md-3 text-info">
                Cuenta
            </div>

            <div class="col-md-9">
                ${contabilidadInstance?.cuenta?.descripcion}
            </div>

        </div>
    </g:if>


%{--<g:if test="${contabilidadInstance?.presupuesto}">--}%
%{--<div class="row">--}%
%{--<div class="col-md-3 text-info">--}%
%{--Presupuesto--}%
%{--</div>--}%
%{----}%
%{--<div class="col-md-3">--}%
%{--<g:formatDate date="${contabilidadInstance?.presupuesto}" format="dd-MM-yyyy" />--}%
%{--</div>--}%
%{----}%
%{--</div>--}%
%{--</g:if>--}%

</g:else>