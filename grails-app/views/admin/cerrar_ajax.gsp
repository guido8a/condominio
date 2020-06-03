<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/06/20
  Time: 15:27
--%>

<div class="modal-contenido">
    <g:hiddenField name="id" value="${adminInstance?.id}" />
    <g:form class="form-horizontal panel alert alert-info" name="anti" role="form" action="" method="POST">
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
    <g:form class="form-horizontal" name="nuevoAdmin" role="form" action="guardarAdministracion_ajax" method="POST">
        <g:hiddenField name="id" value="${adminInstance?.id}" />

        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'administrador', 'error')} required">
            <span class="grupo">
                <label for="nuevoAdministrador" class="col-md-4 control-label">
                   Nuevo administrador
                </label>
                <div class="col-md-8">
                    <g:select id="nuevoAdministrador" name="administrador_name" from="${seguridad.Persona.list([sort: 'nombre'])}"
                              optionKey="id" required="" value="${adminInstance?.administrador?.id}"
                              class="many-to-one form-control"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'revisor', 'error')} required">
            <span class="grupo">
                <label for="nuevoRevisor" class="col-md-4 control-label">
                    Nuevo revisor
                </label>
                <div class="col-md-8">
                    <g:select id="nuevoRevisor" name="revisor_name" from="${seguridad.Persona.list([sort: 'nombre'])}"
                              optionKey="id" required="" value="${adminInstance?.revisor?.id}" class="many-to-one form-control"/>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'fechaInicio', 'error')} required">
            <span class="grupo">
                <label for="nuevaFechaInicio" class="col-md-4 control-label">
                    Fecha de Inicio
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="nuevaFechaInicio" class="datepicker form-control required" value="${adminInstance?.fechaInicio}"  />
                </div>
            </span>
        </div>
        <div class="form-group keeptogether ${hasErrors(bean: adminInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="nuevasObservaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-10">
                    <g:textField name="nuevasObservaciones" class="allCaps form-control" value="${adminInstance?.observaciones}"/>
                </div>
            </span>
        </div>
    </g:form>
</div>
