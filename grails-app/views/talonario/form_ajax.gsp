<%@ page import="condominio.Talonario" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!talonarioInstance}">
    <elm:notFound elem="Talonario" genero="o" />
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmTalonario" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${talonarioInstance?.id}" />
            <g:hiddenField name="condominio" value="${condominio?.id}" />


            <div class="form-group keeptogether ${hasErrors(bean: talonarioInstance, field: 'condominio', 'error')} required">
                <span class="grupo">
                    <label for="condominio" class="col-md-2 control-label">
                        Condominio
                    </label>
                    <div class="col-md-6">
                        ${condominio?.nombre}
                    </div>
                </span>
            </div>


        %{----}%
        %{--<div class="form-group keeptogether ${hasErrors(bean: talonarioInstance, field: 'fechaFin', 'error')} ">--}%
        %{--<span class="grupo">--}%
        %{--<label for="fechaFin" class="col-md-2 control-label">--}%
        %{--Fecha Fin--}%
        %{--</label>--}%
        %{--<div class="col-md-4">--}%
        %{--<elm:datepicker name="fechaFin"  class="datepicker form-control" value="${talonarioInstance?.fechaFin}" default="none" noSelection="['': '']" />--}%
        %{--</div>--}%
        %{----}%
        %{--</span>--}%
        %{--</div>--}%

            <div class="form-group keeptogether ${hasErrors(bean: talonarioInstance, field: 'numeroInicio', 'error')} required">
                <span class="grupo">
                    <label for="numeroInicio" class="col-md-2 control-label">
                        Numero Inicio
                    </label>
                    <div class="col-md-2">
                        <g:textField name="numeroInicio" value="${talonarioInstance.numeroInicio ?: ''}" class="digits form-control required" required=""/>
                    </div>
                    *
                </span>
            </div>

            %{--<div class="form-group keeptogether ${hasErrors(bean: talonarioInstance, field: 'numeroFin', 'error')} required">--}%
                %{--<span class="grupo">--}%
                    %{--<label for="numeroFin" class="col-md-2 control-label">--}%
                        %{--Numero Fin--}%
                    %{--</label>--}%
                    %{--<div class="col-md-2">--}%
                        %{--<g:field name="numeroFin" type="number" value="${talonarioInstance.numeroFin}" class="digits form-control required" required=""/>--}%
                    %{--</div>--}%
                %{--</span>--}%
            %{--</div>--}%

        %{--<div class="form-group keeptogether ${hasErrors(bean: talonarioInstance, field: 'fecha', 'error')} ">--}%
        %{--<span class="grupo">--}%
        %{--<label for="fecha" class="col-md-2 control-label">--}%
        %{--Fecha--}%
        %{--</label>--}%
        %{--<div class="col-md-4">--}%
        %{--<elm:datepicker name="fecha"  class="datepicker form-control" value="${talonarioInstance?.fecha}" default="none" noSelection="['': '']" />--}%
        %{--</div>--}%

        %{--</span>--}%
        %{--</div>--}%

            <div class="form-group keeptogether ${hasErrors(bean: talonarioInstance, field: 'fechaInicio', 'error')} ">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-2 control-label">
                        Fecha Inicio
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaInicio"  class="datepicker form-control required" value="${talonarioInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                    </div>

                </span>
            </div>

        %{--<div class="form-group keeptogether ${hasErrors(bean: talonarioInstance, field: 'estado', 'error')} ">--}%
        %{--<span class="grupo">--}%
        %{--<label for="estado" class="col-md-2 control-label">--}%
        %{--Estado--}%
        %{--</label>--}%
        %{--<div class="col-md-6">--}%
        %{--<g:textField name="estado" class="allCaps form-control" value="${talonarioInstance?.estado}"/>--}%
        %{--</div>--}%
        %{--</span>--}%
        %{--</div>--}%

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmTalonario").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
            }

        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormTalonario();
                return false;
            }
            return true;
        });
    </script>

</g:else>