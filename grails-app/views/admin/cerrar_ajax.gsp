<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/06/20
  Time: 15:27
--%>

<div class="modal-contenido">
    <g:hiddenField name="id" value="${adminInstance?.id}" />
    <g:form class="form-horizontal panel alert alert-info" name="frmAdmin" role="form" action="" method="POST">
        <div class="form-group">
            <span class="grupo">
                <label class="col-md-3">
                    Administrador actual:
                </label>
                <div class="col-md-3">
                    ${adminInstance?.administrador?.nombre + " " + adminInstance?.administrador?.apellido}
                </div>
            </span>
            <span class="grupo">
                <label class="col-md-3">
                    Revisor actual:
                </label>
                <div class="col-md-3">
                    ${adminInstance?.revisor?.nombre + " " + adminInstance?.revisor?.apellido}
                </div>
            </span>
        </div>

        <div class="form-group">
            <span class="grupo">
                <label class="col-md-3">
                    Fecha de Inicio:
                </label>
                <div class="col-md-2">
                    ${adminInstance?.fechaInicio?.format("dd-MM-yyyy")}
                </div>
            </span>
            <span class="grupo">
                <label class="col-md-2">
                    Saldo Inicial:
                </label>
                <div class="col-md-1">
                    ${0.00}
                </div>
            </span>
            <span class="grupo">
                <label class="col-md-2">
                    Saldo Final:
                </label>
                <div class="col-md-1">
                    ${0.00}
                </div>
            </span>
        </div>

        <div class="form-group">
            <span class="grupo">
                <label class="col-md-3">
                    Observaciones:
                </label>
                <div class="col-md-9">
                    ${adminInstance?.observaciones}
                </div>
            </span>
        </div>
    </g:form>
</div>

<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAdmin" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${adminInstance?.id}" />

        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'administrador', 'error')} required">
            <span class="grupo">
                <label for="administrador" class="col-md-3 control-label">
                    Administrador
                </label>
                <div class="col-md-8">
                    <g:select id="administrador" name="administrador.id" from="${seguridad.Persona.list([sort: 'nombre'])}"
                              optionKey="id" required="" value="${adminInstance?.administrador?.id}"
                              class="many-to-one form-control"/>
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'revisor', 'error')} required">
            <span class="grupo">
                <label for="revisor" class="col-md-3 control-label">
                    Revisor
                </label>
                <div class="col-md-8">
                    <g:select id="revisor" name="revisor.id" from="${seguridad.Persona.list([sort: 'nombre'])}"
                              optionKey="id" required="" value="${adminInstance?.revisor?.id}" class="many-to-one form-control"/>
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'fechaInicio', 'error')} required">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label">
                    Fecha de Inicio
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaInicio"  class="datepicker form-control required" value="${adminInstance?.fechaInicio}"  />
                </div>
            </span>

            %{--<span class="grupo">--}%
                %{--<label for="fechaFin" class="col-md-2 control-label">--}%
                    %{--Hasta--}%
                %{--</label>--}%
                %{--<div class="col-md-4">--}%
                    %{--<elm:datepicker name="fechaFin"  class="datepicker form-control" value="${adminInstance?.fechaFin}" default="none" noSelection="['': '']" />--}%
                %{--</div>--}%

            %{--</span>--}%
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'saldoInicial', 'error')} required">
            <span class="grupo">
                <label for="saldoInicial" class="col-md-2 control-label">
                    Saldo Inicial
                </label>
                <div class="col-md-4">
                    <g:textField name="saldoInicial" value="${fieldValue(bean: adminInstance, field: 'saldoInicial')}"
                                 class="number form-control  required" required=""/>
                </div>
            </span>

            <span class="grupo">
                <label for="saldoFinal" class="col-md-2 control-label">
                    Saldo Final
                </label>
                <div class="col-md-4">
                    <g:textField name="saldoFinal" value="${fieldValue(bean: adminInstance, field: 'saldoFinal')}"
                                 class="number form-control" />
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-10">
                    <g:textField name="observaciones" class="allCaps form-control" value="${adminInstance?.observaciones}"/>
                </div>
            </span>
        </div>
    </g:form>
</div>
