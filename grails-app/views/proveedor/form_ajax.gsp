<%@ page import="condominio.Proveedor" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!proveedorInstance}">
    <elm:notFound elem="Proveedor" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmProveedor" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${proveedorInstance?.id}" />

            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'ruc', 'error')} required">
                <span class="grupo">
                    <label for="tipoPersona" class="col-xs-3 col-md-3 control-label">
                        Tipo de persona:
                    </label>
                    <div class="col-xs-4 col-md-4">
                        <g:select name="tipoPersona" from="${['N': 'Natural', 'J': 'Jurídica']}"
                                  optionKey="key" optionValue="value" class="form-control text-info"
                                  value="${proveedorInstance?.tipoPersona}" />
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-3 control-label">
                        Nombre
                    </label>
                    <div class="col-md-8">
                        <g:textField name="nombre" required="" maxlength="127" class=" form-control required" value="${proveedorInstance?.nombre}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'apellido', 'error')} ">
                <span class="grupo">
                    <label for="apellido" class="col-md-3 control-label">
                        Apellido
                    </label>
                    <div class="col-md-7">
                        <g:textField name="apellido" maxlength="31" class=" form-control" value="${proveedorInstance?.apellido}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'ruc', 'error')} required">
                <span class="grupo">
                    <label for="ruc" class="col-md-3 control-label">
                        Ruc
                    </label>
                    <div class="col-md-4">
                        <g:textField name="ruc" required="" maxlength="13" class="digits form-control required" value="${proveedorInstance?.ruc}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'direccion', 'error')} ">
                <span class="grupo">
                    <label for="direccion" class="col-md-3 control-label">
                        Dirección
                    </label>
                    <div class="col-md-9">
                        <g:textField name="direccion" class="form-control" maxlength="255" value="${proveedorInstance?.direccion}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'telefono', 'error')} required">
                <span class="grupo">
                    <label for="telefono" class="col-md-3 control-label">
                        Teléfono
                    </label>
                    <div class="col-md-5">
                        <g:textField name="telefono" required="" maxlength="63" class="form-control required" value="${proveedorInstance?.telefono}"/>
                    </div>
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'mail', 'error')} ">
                <span class="grupo">
                    <label for="mail" class="col-md-3 control-label">
                        Mail
                    </label>
                    <div class="col-md-7">
                        <g:textField name="mail" class=" form-control" maxlength="63" value="${proveedorInstance?.mail}"/>
                    </div>
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'observaciones', 'error')} ">
                <span class="grupo">
                    <label for="observaciones" class="col-md-3 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-9">
                        <g:textField name="observaciones" class=" form-control" maxlength="255" value="${proveedorInstance?.observaciones}"/>
                    </div>
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'activo', 'error')} required">
                <span class="grupo">
                    <label for="activo" class="col-md-3 control-label">
                        Activo
                    </label>
                    <div class="col-md-2">
                        <g:select name="activo" from="${['S': 'Si', 'N': 'No']}"
                                  optionKey="key" optionValue="value" class="form-control text-info"
                                  value="${proveedorInstance?.activo?:'S'}" />
                    </div>
                </span>
            </div>
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmProveedor").validate({
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
                    id: "${proveedorInstance?.id}"
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
                submitFormProveedor();
                return false;
            }
            return true;
        });
    </script>

</g:else>