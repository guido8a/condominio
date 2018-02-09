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
                    <label for="ruc" class="col-md-2 control-label">
                        Ruc
                    </label>
                    <div class="col-md-6">
                        <g:textField name="ruc" required="" class="allCaps form-control required" value="${proveedorInstance?.ruc}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>
                    <div class="col-md-6">
                        <g:textField name="nombre" required="" class="allCaps form-control required" value="${proveedorInstance?.nombre}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'apellido', 'error')} ">
                <span class="grupo">
                    <label for="apellido" class="col-md-2 control-label">
                        Apellido
                    </label>
                    <div class="col-md-6">
                        <g:textField name="apellido" class="allCaps form-control" value="${proveedorInstance?.apellido}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'direccion', 'error')} ">
                <span class="grupo">
                    <label for="direccion" class="col-md-2 control-label">
                        Direccion
                    </label>
                    <div class="col-md-6">
                        <g:textField name="direccion" class="allCaps form-control" value="${proveedorInstance?.direccion}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'telefono', 'error')} required">
                <span class="grupo">
                    <label for="telefono" class="col-md-2 control-label">
                        Telefono
                    </label>
                    <div class="col-md-6">
                        <g:textField name="telefono" required="" class="allCaps form-control required" value="${proveedorInstance?.telefono}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'mail', 'error')} ">
                <span class="grupo">
                    <label for="mail" class="col-md-2 control-label">
                        Mail
                    </label>
                    <div class="col-md-6">
                        <g:textField name="mail" class="allCaps form-control" value="${proveedorInstance?.mail}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'observaciones', 'error')} ">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>
                    <div class="col-md-6">
                        <g:textField name="observaciones" class="allCaps form-control" value="${proveedorInstance?.observaciones}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'activo', 'error')} required">
                <span class="grupo">
                    <label for="activo" class="col-md-2 control-label">
                        Activo
                    </label>
                    <div class="col-md-6">
                        <g:textField name="activo" class="allCaps form-control" value="${proveedorInstance?.activo}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: proveedorInstance, field: 'fecha', 'error')} required">
                <span class="grupo">
                    <label for="fecha" class="col-md-2 control-label">
                        Fecha
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fecha"  class="datepicker form-control required" value="${proveedorInstance?.fecha}"  />
                    </div>
                     *
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