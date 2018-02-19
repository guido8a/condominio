
<%@ page import="condominio.Ingreso" %>

<g:if test="${!ingresoInstance}">
    <elm:notFound elem="Ingreso" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${ingresoInstance?.obligacion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Pago por:
                </div>

                <div class="col-md-9">
                    ${ingresoInstance?.obligacion?.descripcion}
                </div>

            </div>
        </g:if>

        <g:if test="${ingresoInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Concepto:
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${ingresoInstance}" field="observaciones"/>
                </div>

            </div>
        </g:if>

        <g:if test="${ingresoInstance?.valor}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Valor
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${ingresoInstance}" field="valor"/>
                </div>

            </div>
        </g:if>

        <g:if test="${ingresoInstance?.fecha}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha
                </div>

                <div class="col-md-4">
                    <g:formatDate date="${ingresoInstance?.fecha}" format="dd-MM-yyyy" />
                </div>

            </div>
        </g:if>

        <g:if test="${ingresoInstance?.fechaPago}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Pago
                </div>

                <div class="col-md-4">
                    <g:formatDate date="${ingresoInstance?.fechaPago}" format="dd-MM-yyyy" />
                </div>

            </div>
        </g:if>

        <g:if test="${ingresoInstance?.abono}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Abono
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${ingresoInstance}" field="abono"/>
                </div>

            </div>
        </g:if>

        <g:if test="${ingresoInstance?.abono}">
            <div class="row">
                <div class="col-md-3 show-label text-info">
                    Saldo
                </div>

                <div class="col-md-4 text-info">
                    ${ingresoInstance.valor - ingresoInstance.abono}
                </div>

            </div>
        </g:if>

        <g:if test="${ingresoInstance?.documento}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Documento
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${ingresoInstance}" field="documento"/>
                </div>
                
            </div>
        </g:if>
        
        <g:if test="${ingresoInstance?.estado}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Estado
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${ingresoInstance}" field="estado"/>
                </div>

            </div>
        </g:if>

    </div>
</g:else>