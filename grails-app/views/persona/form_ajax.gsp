<%@ page import="seguridad.Prfl; seguridad.Persona" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script src="${resource(dir: 'js/plugins/Toggle-Button-Checkbox/js', file: 'bootstrap-checkbox.js')}"></script>

<g:if test="${!personaInstance}">
    <elm:notFound elem="Persona" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPersona" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${personaInstance?.id}" />


            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'nombre', 'error')} required">
                <div class="col-md-6">
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
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="tipoOcupacion" class="col-md-2 control-label">
                            Tipo
                        </label>
                        <div class="col-md-7">
                            <g:select id="tipoOcupacion" name="tipoOcupacion.id" from="${condominio.TipoOcupacion.list()}" optionKey="id" value="${personaInstance?.tipoOcupacion?.id}" class="many-to-one form-control"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'ruc', 'error')} required">
                <div class="col-md-6">
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
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="edificio" class="col-md-2 control-label">
                            Edificio
                        </label>
                        <div class="col-md-7">
                            <g:select id="edificio" name="edificio.id" from="${condominio.Edificio.list()}" optionKey="id" optionValue="descripcion" value="${personaInstance?.edificio?.id}" class="many-to-one form-control"/>
                        </div>
                    </span>
                </div>

            </div>


        %{--<div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'sexo', 'error')} required">--}%
        %{--</div>--}%

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'mail', 'error')} required">
                <div class="col-md-6">
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
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="departamento" class="col-md-2 control-label">
                            Departamento
                        </label>
                        <div class="col-md-7">
                            <g:textField name="departamento" class="allCaps form-control required" required="" value="${personaInstance?.departamento}"/>
                        </div>
                        *
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'password', 'error')} required">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="mail" class="col-md-2 control-label">
                            Mail
                        </label>
                        <div class="col-md-7">
                            <g:textField name="mail" maxlength="63" class="allCaps form-control" value="${personaInstance?.mail}"/>
                        </div>
                    </span>
                </div>
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="cargo" class="col-md-2 control-label">
                            Cargo
                        </label>
                        <div class="col-md-7">
                            <g:textField name="cargo" class="form-control" value="${personaInstance?.cargo}"/>
                        </div>

                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'activo', 'error')} required">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="telefono" class="col-md-2 control-label">
                            Teléfono
                        </label>
                        <div class="col-md-7">
                            <g:textField name="telefono" required="" class="allCaps form-control required" value="${personaInstance?.telefono}"/>
                        </div>
                        *
                    </span>
                </div>
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="alicuota" class="col-md-2 control-label">
                            Alicuota
                        </label>
                        <div class="col-md-7">
                            <g:textField name="alicuota" value="${personaInstance?.alicuota}" class="number form-control"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cargo', 'error')} ">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="autorizacion" class="col-md-2 control-label">
                            Autorizacion
                        </label>
                        <div class="col-md-7">
                            <g:textField name="autorizacion" pattern="${personaInstance.constraints.autorizacion.matches}" class="allCaps form-control" value="${personaInstance?.autorizacion}"/>
                        </div>
                    </span>
                </div>
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="sexo" class="col-md-2 control-label">
                            Sexo
                        </label>
                        <div class="col-md-7">
                            <g:select name="sexo" from="${["Masculino", "Femenino"]}" class="form-control " value="${personaInstance?.sexo}" valueMessagePrefix="persona.sexo"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'observaciones', 'error')} ">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="direccion" class="col-md-2 control-label">
                            Dirección
                        </label>
                        <div class="col-md-7">
                            %{--<g:textField name="direccion" class="allCaps form-control" value="${personaInstance?.direccion}"/>--}%
                            <g:textArea name="direccion" class="form-control" value="${personaInstance?.direccion}"/>
                        </div>
                    </span>
                </div>
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="observaciones" class="col-md-2 control-label">
                            Observaciones
                        </label>
                        <div class="col-md-7">
                            <g:textArea name="observaciones" class="form-control" value="${personaInstance?.observaciones}"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'departamento', 'error')} required">
                <div class="col-md-6">
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
                <div class="col-md-6">
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
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fechaInicio', 'error')} ">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaInicio" class="col-md-2 control-label">
                            Fecha Inicio
                        </label>
                        <div class="col-md-5">
                            <elm:datepicker name="fechaInicio" title="Fecha de inicio"  class="datepicker form-control" value="${personaInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                        </div>
                    </span>
                </div>
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaFin" class="col-md-2 control-label">
                            Fecha Fin
                        </label>
                        <div class="col-md-5">
                            <elm:datepicker name="fechaFin" title="Fecha de finalización"  class="datepicker form-control" value="${personaInstance?.fechaFin}" default="none" noSelection="['': '']" />
                        </div>
                    </span>
                </div>
            </div>


            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fecha', 'error')} required">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="activo" class="col-md-2 control-label">
                            Activo
                        </label>
                        <div class="col-md-3">
                            <g:checkBox name="activo" class="form-control activ" data-on-Label="Si" value="${personaInstance?.activo}"/>
                        </div>
                    </span>
                </div>
                 <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaNacimiento" class="col-md-2 control-label">
                            Fecha Nacimiento
                        </label>
                        <div class="col-md-5">
                            <elm:datepicker name="fechaNacimiento"  class="datepicker form-control" value="${personaInstance?.fechaNacimiento}" />
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'perfil', 'error')} ">
                <div class="col-md-12">
                    <span class="grupo">
                        <label for="perfil" class="col-md-2 control-label">
                            Perfiles
                        </label>
                        <div class="col-md-10">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="col-md-10">
                                        <g:select name="perfil" from="${seguridad.Prfl.list([sort: 'nombre'])}" class="form-control input-sm"
                                                  optionKey="id" optionValue="nombre"/>
                                    </div>

                                    <div class="col-md-2">
                                        <a href="#" class="btn btn-success btn-sm" id="btn-addPerfil" title="Agregar perfil">
                                            <i class="fa fa-plus"></i> Agregar perfil
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <table id="tblPerfiles" class="table table-hover table-bordered table-condensed">
                                        %{--<g:each in="${perfiles.perfil}" var="perfil">--}%
                                            %{--<tr class="perfiles" data-id="${perfil.id}">--}%
                                                %{--<td>--}%
                                                    %{--${perfil?.nombre}--}%
                                                %{--</td>--}%
                                                %{--<td width="35">--}%
                                                    %{--<a href="#" class="btn btn-danger btn-xs btn-deletePerfil">--}%
                                                        %{--<i class="fa fa-trash-o"></i>--}%
                                                    %{--</a>--}%
                                                %{--</td>--}%
                                            %{--</tr>--}%
                                        %{--</g:each>--}%
                                    </table>
                                </div>
                            </div>
                        </div>
                    </span>
                </div>
            </div>
        </g:form>
    </div>

    <script type="text/javascript">


        $(function() {
            $(".activ").checkboxpicker({
            });
        });


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