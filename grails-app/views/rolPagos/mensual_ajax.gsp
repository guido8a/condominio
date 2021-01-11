<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 11/01/21
  Time: 14:32
--%>

<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmMensual" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${mensual?.id}" />

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'condominio', 'error')} required">
            <span class="grupo">
                <label for="condominio" class="col-md-2 control-label">
                    Condominio
                </label>
                <div class="col-md-8">
                    <g:select id="condominio" name="condominio.id" from="${condominio.Condominio.list()}" optionKey="id" required="" value="${empleadoInstance?.condominio?.id ?: condominio?.id}" class="many-to-one form-control"/>
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-8">
                    <g:textField name="nombre" maxlength="31" required="" class="form-control required" value="${empleadoInstance?.nombre}"/>
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'apellido', 'error')} required">
            <span class="grupo">
                <label for="apellido" class="col-md-2 control-label">
                    Apellido
                </label>
                <div class="col-md-8">
                    <g:textField name="apellido" maxlength="31" required="" class="form-control required" value="${empleadoInstance?.apellido}"/>
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'cedula', 'error')} ${hasErrors(bean: empleadoInstance, field: 'sexo', 'error')}">
            <span class="grupo">
                <label for="cedula" class="col-md-2 control-label">
                    Cédula
                </label>
                <div class="col-md-3">
                    <g:textField name="cedula" maxlength="10" class="allCaps form-control required" value="${empleadoInstance?.cedula}"/>
                </div>
                *
            </span>
            <span class="grupo">
                <label for="sexo" class="col-md-2 control-label">
                    Sexo
                </label>
                <div class="col-md-3">
                    <g:select name="sexo" from="${['F': 'Femenino', 'M' : 'Masculino']}" optionKey="key" optionValue="value" required="" class="form-control" value="${empleadoInstance?.sexo}" valueMessagePrefix="empleado.sexo"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'direccion', 'error')} ">
            <span class="grupo">
                <label for="direccion" class="col-md-2 control-label">
                    Dirección
                </label>
                <div class="col-md-7">
                    <g:textArea name="direccion" cols="40" rows="5" maxlength="255" class="form-control" value="${empleadoInstance?.direccion}" style="width: 345px; height: 75px; resize: none"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'mail', 'error')} ">
            <span class="grupo">
                <label for="mail" class="col-md-2 control-label">
                    Mail
                </label>
                <div class="col-md-8">
                    <g:textField name="mail" maxlength="63" class="email form-control" value="${empleadoInstance?.mail}"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'telefono', 'error')} ">
            <span class="grupo">
                <label for="telefono" class="col-md-2 control-label">
                    Teléfono
                </label>
                <div class="col-md-4">
                    <g:textField name="telefono" maxlength="63" class="digits allCaps form-control" value="${empleadoInstance?.telefono}"/>
                </div>
            </span>

            <span class="grupo">
                <label for="fechaNacimiento" class="col-md-2 control-label">
                    Fecha Nacimiento
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaNacimiento"  class="datepicker form-control" value="${empleadoInstance?.fechaNacimiento}" default="none" noSelection="['': '']" />
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'cargo', 'error')} ${hasErrors(bean: empleadoInstance, field: 'activo', 'error')}">
            <span class="grupo">
                <label for="cargo" class="col-md-2 control-label">
                    Cargo
                </label>
                <div class="col-md-5">
                    <g:textField name="cargo" maxlength="127" required="" class="form-control required" value="${empleadoInstance?.cargo}"/>
                </div>
            </span>

            <span class="grupo">
                <label for="activo" class="col-md-2 control-label">
                    Activo
                </label>
                <div class="col-md-3">
                    <g:select name="activo" from="${[1 : 'SI' , 0: 'NO']}" optionKey="key" optionValue="value" required="" class="form-control" value="${empleadoInstance.activo}" />
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'fechaInicio', 'error')} ${hasErrors(bean: empleadoInstance, field: 'fechaFin', 'error')}">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label">
                    Fecha Inicio
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaInicio"  class="datepicker form-control" value="${empleadoInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                </div>
            </span>
            <span class="grupo">
                <label for="fechaFin" class="col-md-2 control-label">
                    Fecha Fin
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaFin"  class="datepicker form-control" value="${empleadoInstance?.fechaFin}" default="none" noSelection="['': '']" />
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'observaciones', 'error')}">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textArea name="observaciones" cols="40" rows="5" maxlength="255" required="" class="form-control" value="${empleadoInstance?.observaciones}" style="width: 345px; height: 75px; resize: none"/>
                </div>
            </span>
        </div>

    </g:form>
</div>