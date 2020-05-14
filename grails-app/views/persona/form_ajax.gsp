<%@ page import="condominio.Condominio; seguridad.Prfl; seguridad.Persona" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script src="${resource(dir: 'js/plugins/Toggle-Button-Checkbox/js', file: 'bootstrap-checkbox.js')}"></script>

<g:if test="${!personaInstance}">
    <elm:notFound elem="Persona" genero="o" />
</g:if>
<g:else>
    <div class="container-fluid">
        <g:form class="form-horizontal" name="frmPersona" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${personaInstance?.id}" />

            <div class="row">
                <div class="col-xs-12 col-md-12">
                    <div class="row">
                        <label for="nombrePropietario" class="control-label col-xs-3 col-md-3">
                            Condominio
                        </label>
                        <g:if test="${session.perfil.codigo == 'ADM'}">
                            <div class="col-xs-7 col-md-6">
                                <g:select name="condominio" from="${condominio.Condominio.list().sort{it.nombre}}" class="form-control" optionKey="id" optionValue="nombre" value="${personaInstance?.condominio?.id}"/>
                            </div>
                        </g:if>
                        <g:else>
                            <div class="col-xs-7 col-md-6">
                                <g:select name="condominio" from="${condominio.Condominio.get(session.usuario.condominio.id)}" class="form-control" optionKey="id" optionValue="nombre" value="${personaInstance?.condominio?.id}"/>
                            </div>
                        </g:else>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <label for="nombre" class="control-label col-xs-4 col-md-4">
                            Ocupante Nombre (listado)
                        </label>
                        <div class="col-xs-7 col-md-7">
                            <g:textField name="nombre" maxlength="30" required="" class="form-control required"
                                         value="${personaInstance?.nombre}"/>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <label for="apellido" class="control-label col-xs-3 col-md-4">
                            Ocupante Apellido (listado)
                        </label>
                        <div class="col-xs-7 col-md-7">
                            <g:textField name="apellido" maxlength="30" required="" class="form-control required"
                                         value="${personaInstance?.apellido}"/>
                        </div>
                    </div>
                </div>
            </div>



            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <label for="nombrePropietario" class="control-label col-xs-3 col-md-3">
                            Propietario Nombre
                        </label>
                        <div class="col-xs-9 col-md-8">
                            <g:textField name="nombrePropietario" maxlength="30" required="" class="form-control required"
                                         value="${personaInstance?.nombrePropietario}"/>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <label for="apellidoPropietario" class="control-label col-xs-3 col-md-3">
                            Propietario Apellido
                        </label>
                        <div class="col-xs-9 col-md-8">
                            <g:textField name="apellidoPropietario" maxlength="30" required="" class="form-control required"
                                         value="${personaInstance?.apellidoPropietario}"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12 col-md-3">
                    <div class="row">
                        <span class="grupo">
                            <label for="ruc" class="col-xs-3 col-md-3 control-label">
                                CI/Ruc
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <g:textField name="ruc" required="" class="allCaps digits form-control required" value="${personaInstance?.ruc}"/>
                            </div>
                            *
                        </span>
                    </div>
                </div>
                <div class="col-xs-12 col-md-3">
                    <div class="row">
                        <label for="edificio" class="col-xs-4 col-md-4 control-label">
                            Edificio
                        </label>
                        <div class="col-xs-8 col-md-7">
                            <g:select id="edificio" name="edificio.id" from="${edificio}"
                                      optionKey="id" optionValue="descripcion"
                                      value="${personaInstance?.edificio?.id}" class="many-to-one form-control"/>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-md-2">
                    <div class="row">
                        <label for="departamento" class="col-xs-5 col-md-5 control-label">
                            Número
                        </label>
                        <div class="col-xs-7 col-md-7">
                            <g:textField name="departamento" class="allCaps form-control required" required="" value="${personaInstance?.departamento}"/>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-md-4">
                    <div class="row">
                        <label for="tipoOcupacion" class="col-xs-5 col-md-5 control-label">
                            Ocupado por
                        </label>
                        <div class="col-xs-7 col-md-6">
                            <g:select id="tipoOcupacion" name="tipoOcupacion.id" from="${condominio.TipoOcupacion.list()}"
                                      optionKey="id" value="${personaInstance?.tipoOcupacion?.id}"
                                      class="many-to-one form-control"/>
                        </div>
                    </div>
                </div>

            </div>

            <div class="row">
            </div>

            <div class="row">
                <div class="col-xs-12 col-md-9">
                    <div class="row">
                        <span class="grupo">
                            <label for="direccion" class="col-xs-2 col-md-2 control-label">
                                Dirección
                            </label>
                            <div class="col-xs-10 col-md-9">
                                <g:textField name="direccion" class="form-control" value="${personaInstance?.direccion}" style="resize: none"/>
                                %{--<g:textArea name="direccion" class="form-control" value="${personaInstance?.direccion}" style="resize: none"/>--}%
                            </div>
                        </span>
                    </div>
                </div>
                <div class="col-xs-12 col-md-3">
                    <div class="row">
                        <span class="grupo">
                            <label for="alicuota" class="col-xs-3 col-md-3 control-label">
                                Alicuota
                            </label>
                            <div class="col-xs-9 col-md-8">
                                <g:textField name="alicuota" value="${personaInstance?.alicuota}" class="number form-control"/>
                            </div>
                        </span>
                    </div>
                </div>

            </div>

            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="telefono" class="col-xs-3 col-md-3 control-label">
                                Teléfono
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <g:textField name="telefono" required="" class="digits form-control required" value="${personaInstance?.telefono}"/>
                            </div>
                            *
                        </span>
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="sexo" class="col-xs-3 col-md-3 control-label">
                                Sexo
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <g:select name="sexo" from="${["Masculino", "Femenino"]}" class="form-control " value="${personaInstance?.sexo == 'F' ? 'Femenino' : 'Masculino'}" valueMessagePrefix="persona.sexo"/>
                            </div>
                        </span>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="mail" class="col-xs-3 col-md-3 control-label">
                                Mail
                            </label>
                            <div class="col-xs-9 col-md-8">
                                <g:textField name="mail" maxlength="63" class="form-control" value="${personaInstance?.mail}"/>
                            </div>
                        </span>
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="login" class="col-xs-3 col-md-3 control-label">
                                Login
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <g:textField name="login" maxlength="14" required="" class="form-control required" value="${personaInstance?.login}"/>
                            </div>
                            *
                        </span>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="fechaNacimiento" class="col-xs-3 col-md-3 control-label">
                                Fecha Nacimiento
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <elm:datepicker name="fechaNacimiento"  class="datepicker form-control" value="${personaInstance?.fechaNacimiento}" />
                            </div>
                        </span>
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="password" class="col-xs-3 col-md-3 control-label">
                                Password
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <g:passwordField name="password" required="" class="form-control required" value="${personaInstance?.password}"/>
                            </div>
                            *
                        </span>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="cargo" class="col-xs-3 col-md-3 control-label">
                                Cargo
                            </label>
                            <div class="col-xs-9 col-md-8">
                                %{--<g:textField name="cargo" class="form-control" value="${personaInstance?.cargo}"/>--}%
                                <g:select name="cargo" class="form-control" from="${["Condomino", "Administrador", "Presidente", "Representante"]}" value="${personaInstance?.cargo}"/>
                            </div>
                        </span>
                    </div>
                </div>

                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="perfiles" class="col-xs-3 col-md-3 control-label">
                                Perfil
                            </label>
                            <g:if test="${session.perfil.codigo == 'ADM'}">
                                <div class="col-xs-9 col-md-8">
                                    <g:select id="perfiles" name="perfiles" from="${prflAdm}"
                                              optionKey="id" optionValue="descripcion" value="${personaInstance?.perfil}" class="many-to-one form-control"/>
                                </div>
                            </g:if>
                            <g:else>
                                <div class="col-xs-9 col-md-8">
                                    <g:select id="perfiles" name="perfiles" from="${perfiles}"
                                              optionKey="id" optionValue="descripcion" value="${personaInstance?.perfil}" class="many-to-one form-control"/>
                                </div>
                            </g:else>
                        </span>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="fechaInicio" class="col-xs-3 col-md-3 control-label">
                                Fecha Inicio
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <elm:datepicker name="fechaInicio" title="Fecha de inicio"  class="datepicker form-control" value="${personaInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                            </div>
                        </span>
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="fechaFin" class="col-xs-3 col-md-3 control-label">
                                Fecha Fin
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <elm:datepicker name="fechaFin" title="Fecha de finalización"  class="datepicker form-control" value="${personaInstance?.fechaFin}" default="none" noSelection="['': '']" />
                            </div>
                        </span>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="activo" class="col-xs-3 col-md-3 control-label">
                                Activo
                            </label>
                            <div class="col-xs-3 col-md-3">
                                <g:checkBox name="activo" class="form-control activ" data-on-Label="Si"
                                            value="${personaInstance?.activo == 1}"  />
                            </div>
                        </span>

                        <g:if test="${session.perfil.codigo == 'ADM'}">
                            <span class="grupo">
                                <label for="activo" class="col-xs-3 col-md-3 control-label">
                                    Administrador externo
                                </label>
                                <div class="col-xs-3 col-md-3">
                                    <g:checkBox name="externo" class="form-control activ" data-on-Label="Si"
                                                value="${personaInstance?.externo == 1}"  />
                                </div>
                            </span>
                        </g:if>
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="row">
                        <span class="grupo">
                            <label for="observaciones" class="col-xs-3 col-md-3 control-label">
                                Observaciones
                            </label>
                            <div class="col-xs-8 col-md-8">
                                <g:textArea name="observaciones" class="form-control" value="${personaInstance?.observaciones}" style="resize: none"/>
                            </div>
                        </span>
                    </div>
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

        //        $("#btn-addPerfil").click(function () {
        //            var $perfil = $("#perfil");
        //            var idPerfilAdd = $perfil.val();
        //            $(".perfiles").each(function () {
        //                if ($(this).data("id") == idPerfilAdd) {
        //                    $(this).remove();
        //                }
        //            });
        //            var $tabla = $("#tblPerfiles");
        //
        //            var $tr = $("<tr>");
        //            $tr.addClass("perfiles");
        //            $tr.data("id", idPerfilAdd);
        //            var $tdNombre = $("<td>");
        //            $tdNombre.text($perfil.find("option:selected").text());
        //            var $tdBtn = $("<td>");
        //            $tdBtn.attr("width", "35");
        //            var $btnDelete = $("<a>");
        //            $btnDelete.addClass("btn btn-danger btn-xs");
        //            $btnDelete.html("<i class='fa fa-trash-o'></i> ");
        //            $tdBtn.append($btnDelete);
        //
        //            $btnDelete.click(function () {
        //                $tr.remove();
        //                return false;
        //            });
        //
        //            $tr.append($tdNombre).append($tdBtn);
        //
        //            $tabla.prepend($tr);
        //            $tr.effect("highlight");
        //
        //            return false;
        //        });
        //        $(".btn-deletePerfil").click(function () {
        //            $(this).parents("tr").remove();
        //            return false;
        //        });


    </script>

</g:else>