<%@ page import="condominio.Empleado" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!empleadoInstance}">
    <elm:notFound elem="Empleado" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmEmpleado" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${empleadoInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'condominio', 'error')} required">
                <span class="grupo">
                    <label for="condominio" class="col-md-2 control-label">
                        Condominio
                    </label>
                    <div class="col-md-7">
                        <g:select id="condominio" name="condominio.id" from="${condominio.Condominio.list()}" optionKey="id" required="" value="${empleadoInstance?.condominio?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>
                    <div class="col-md-7">
                        <g:textField name="nombre" maxlength="31" required="" class="allCaps form-control required" value="${empleadoInstance?.nombre}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'apellido', 'error')} required">
                <span class="grupo">
                    <label for="apellido" class="col-md-2 control-label">
                        Apellido
                    </label>
                    <div class="col-md-7">
                        <g:textField name="apellido" maxlength="31" required="" class="allCaps form-control required" value="${empleadoInstance?.apellido}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'cedula', 'error')} ">
                <span class="grupo">
                    <label for="cedula" class="col-md-2 control-label">
                        Cedula
                    </label>
                    <div class="col-md-7">
                        <g:textField name="cedula" class="allCaps form-control" value="${empleadoInstance?.cedula}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'sexo', 'error')} required">
                <span class="grupo">
                    <label for="sexo" class="col-md-2 control-label">
                        Sexo
                    </label>
                    <div class="col-md-7">
                        <g:select name="sexo" from="${empleadoInstance.constraints.sexo.inList}" required="" class="form-control required" value="${empleadoInstance?.sexo}" valueMessagePrefix="empleado.sexo"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'direccion', 'error')} ">
                <span class="grupo">
                    <label for="direccion" class="col-md-2 control-label">
                        Direccion
                    </label>
                    <div class="col-md-7">
                        <g:textArea name="direccion" cols="40" rows="5" maxlength="255" class="allCaps form-control" value="${empleadoInstance?.direccion}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'telefono', 'error')} ">
                <span class="grupo">
                    <label for="telefono" class="col-md-2 control-label">
                        Telefono
                    </label>
                    <div class="col-md-7">
                        <g:textField name="telefono" maxlength="63" class="allCaps form-control" value="${empleadoInstance?.telefono}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'mail', 'error')} ">
                <span class="grupo">
                    <label for="mail" class="col-md-2 control-label">
                        Mail
                    </label>
                    <div class="col-md-7">
                        <g:textField name="mail" maxlength="63" class="allCaps form-control" value="${empleadoInstance?.mail}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'activo', 'error')} required">
                <span class="grupo">
                    <label for="activo" class="col-md-2 control-label">
                        Activo
                    </label>
                    <div class="col-md-3">
                        <g:field name="activo" type="number" value="${empleadoInstance.activo}" class="digits form-control required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'fechaRegistro', 'error')} ">
                <span class="grupo">
                    <label for="fechaRegistro" class="col-md-2 control-label">
                        Fecha Registro
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaRegistro"  class="datepicker form-control" value="${empleadoInstance?.fechaRegistro}" default="none" noSelection="['': '']" />
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'fechaNacimiento', 'error')} ">
                <span class="grupo">
                    <label for="fechaNacimiento" class="col-md-2 control-label">
                        Fecha Nacimiento
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaNacimiento"  class="datepicker form-control" value="${empleadoInstance?.fechaNacimiento}" default="none" noSelection="['': '']" />
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'cargo', 'error')} required">
                <span class="grupo">
                    <label for="cargo" class="col-md-2 control-label">
                        Cargo
                    </label>
                    <div class="col-md-7">
                        <g:textField name="cargo" maxlength="127" required="" class="allCaps form-control required" value="${empleadoInstance?.cargo}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'fechaInicio', 'error')} ">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-2 control-label">
                        Fecha Inicio
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaInicio"  class="datepicker form-control" value="${empleadoInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'fechaFin', 'error')} ">
                <span class="grupo">
                    <label for="fechaFin" class="col-md-2 control-label">
                        Fecha Fin
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaFin"  class="datepicker form-control" value="${empleadoInstance?.fechaFin}" default="none" noSelection="['': '']" />
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: empleadoInstance, field: 'observaciones', 'error')} required">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-7">
                        <g:textArea name="observaciones" cols="40" rows="5" maxlength="255" required="" class="allCaps form-control required" value="${empleadoInstance?.observaciones}"/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmEmpleado").validate({
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
            
            , rules          : {
        
        mail: {
            remote: {
                url: "${createLink(action: 'validar_unique_mail_ajax')}",
                    type: "post",
                    data: {
                    id: "${empleadoInstance?.id}"
                }
            }
        }
        
        },
        messages : {
            
            mail: {
                remote: "Ya existe Mail"
            }
            
        }
        
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormEmpleado();
                return false;
            }
            return true;
        });
    </script>

</g:else>