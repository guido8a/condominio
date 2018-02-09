<%@ page import="seguridad.Persona" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!personaInstance}">
    <elm:notFound elem="Persona" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPersona" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${personaInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>
                    <div class="col-md-7">
                        <g:textField name="nombre" maxlength="30" required="" class="allCaps form-control required" value="${personaInstance?.nombre}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'apellido', 'error')} required">
                <span class="grupo">
                    <label for="apellido" class="col-md-2 control-label">
                        Apellido
                    </label>
                    <div class="col-md-7">
                        <g:textField name="apellido" maxlength="30" required="" class="allCaps form-control required" value="${personaInstance?.apellido}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'ruc', 'error')} required">
                <span class="grupo">
                    <label for="ruc" class="col-md-2 control-label">
                        Ruc
                    </label>
                    <div class="col-md-7">
                        <g:textField name="ruc" required="" class="allCaps form-control required" value="${personaInstance?.ruc}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'sexo', 'error')} required">
                <span class="grupo">
                    <label for="sexo" class="col-md-2 control-label">
                        Sexo
                    </label>
                    <div class="col-md-7">
                        <g:select name="sexo" from="${personaInstance.constraints.sexo.inList}" required="" class="form-control required" value="${personaInstance?.sexo}" valueMessagePrefix="persona.sexo"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'mail', 'error')} required">
                <span class="grupo">
                    <label for="mail" class="col-md-2 control-label">
                        Mail
                    </label>
                    <div class="col-md-7">
                        <g:textField name="mail" maxlength="63" class="allCaps form-control" value="${personaInstance?.mail}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'login', 'error')} required">
                <span class="grupo">
                    <label for="login" class="col-md-2 control-label">
                        Login
                    </label>
                    <div class="col-md-7">
                        <g:textField name="login" maxlength="14" required="" class="allCaps form-control required" value="${personaInstance?.login}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'password', 'error')} required">
                <span class="grupo">
                    <label for="password" class="col-md-2 control-label">
                        Password
                    </label>
                    <div class="col-md-7">
                        <g:textField name="password" required="" class="allCaps form-control required" value="${personaInstance?.password}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'autorizacion', 'error')} ">
                <span class="grupo">
                    <label for="autorizacion" class="col-md-2 control-label">
                        Autorizacion
                    </label>
                    <div class="col-md-7">
                        <g:textField name="autorizacion" pattern="${personaInstance.constraints.autorizacion.matches}" class="allCaps form-control" value="${personaInstance?.autorizacion}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'activo', 'error')} required">
                <span class="grupo">
                    <label for="activo" class="col-md-2 control-label">
                        Activo
                    </label>
                    <div class="col-md-3">
                        <g:field name="activo" type="number" value="${personaInstance.activo}" class="digits form-control required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'telefono', 'error')} required">
                <span class="grupo">
                    <label for="telefono" class="col-md-2 control-label">
                        Telefono
                    </label>
                    <div class="col-md-7">
                        <g:textField name="telefono" required="" class="allCaps form-control required" value="${personaInstance?.telefono}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fechaInicio', 'error')} ">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-2 control-label">
                        Fecha Inicio
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaInicio" title="Fecha de inicio"  class="datepicker form-control" value="${personaInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fechaFin', 'error')} ">
                <span class="grupo">
                    <label for="fechaFin" class="col-md-2 control-label">
                        Fecha Fin
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaFin" title="Fecha de finalización"  class="datepicker form-control" value="${personaInstance?.fechaFin}" default="none" noSelection="['': '']" />
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cargo', 'error')} ">
                <span class="grupo">
                    <label for="cargo" class="col-md-2 control-label">
                        Cargo
                    </label>
                    <div class="col-md-7">
                        <g:textArea name="cargo" cols="40" rows="5" maxlength="255" class="allCaps form-control" value="${personaInstance?.cargo}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'direccion', 'error')} ">
                <span class="grupo">
                    <label for="direccion" class="col-md-2 control-label">
                        Direccion
                    </label>
                    <div class="col-md-7">
                        <g:textField name="direccion" class="allCaps form-control" value="${personaInstance?.direccion}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'observaciones', 'error')} ">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-7">
                        <g:textField name="observaciones" class="allCaps form-control" value="${personaInstance?.observaciones}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'alicuota', 'error')} required">
                <span class="grupo">
                    <label for="alicuota" class="col-md-2 control-label">
                        Alicuota
                    </label>
                    <div class="col-md-3">
                        <g:field name="alicuota" type="number" value="${fieldValue(bean: personaInstance, field: 'alicuota')}" class="number form-control  required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'departamento', 'error')} required">
                <span class="grupo">
                    <label for="departamento" class="col-md-2 control-label">
                        Departamento
                    </label>
                    <div class="col-md-7">
                        <g:textField name="departamento" class="allCaps form-control" value="${personaInstance?.departamento}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'edificio', 'error')} required">
                <span class="grupo">
                    <label for="edificio" class="col-md-2 control-label">
                        Edificio
                    </label>
                    <div class="col-md-7">
                        <g:select id="edificio" name="edificio.id" from="${condominio.Edificio.list()}" optionKey="id" required="" value="${personaInstance?.edificio?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fecha', 'error')} required">
                <span class="grupo">
                    <label for="fecha" class="col-md-2 control-label">
                        Fecha
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fecha"  class="datepicker form-control required" value="${personaInstance?.fecha}"  />
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fechaNacimiento', 'error')} required">
                <span class="grupo">
                    <label for="fechaNacimiento" class="col-md-2 control-label">
                        Fecha Nacimiento
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaNacimiento"  class="datepicker form-control required" value="${personaInstance?.fechaNacimiento}"  />
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'perfiles', 'error')} ">
                <span class="grupo">
                    <label for="perfiles" class="col-md-2 control-label">
                        Perfiles
                    </label>
                    <div class="col-md-7">
                        
<ul class="one-to-many">
<g:each in="${personaInstance?.perfiles?}" var="p">
    <li><g:link controller="sesn" action="show" id="${p.id}">${p?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="sesn" action="create" params="['persona.id': personaInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'sesn.label', default: 'Sesn')])}</g:link>
</li>
</ul>

                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'tipoOcupacion', 'error')} required">
                <span class="grupo">
                    <label for="tipoOcupacion" class="col-md-2 control-label">
                        Tipo Ocupacion
                    </label>
                    <div class="col-md-7">
                        <g:select id="tipoOcupacion" name="tipoOcupacion.id" from="${condominio.TipoOcupacion.list()}" optionKey="id" required="" value="${personaInstance?.tipoOcupacion?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmPersona").validate({
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
                    id: "${personaInstance?.id}"
                }
            }
        },
        
        login: {
            remote: {
                url: "${createLink(action: 'validar_unique_login_ajax')}",
                    type: "post",
                    data: {
                    id: "${personaInstance?.id}"
                }
            }
        }
        
        },
        messages : {
            
            mail: {
                remote: "Ya existe Mail"
            },
            
            login: {
                remote: "Ya existe Login"
            }
            
        }
        
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormPersona();
                return false;
            }
            return true;
        });
    </script>

</g:else>