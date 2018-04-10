<%@ page import="condominio.Condominio" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!condominioInstance}">
    <elm:notFound elem="Condominio" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmCondominio" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${condominioInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'tipoCondominio', 'error')} required">
                <span class="grupo">
                    <label for="tipoCondominio" class="col-md-2 control-label">
                        Tipo Condominio
                    </label>
                    <div class="col-md-7">
                        <g:select id="tipoCondominio" name="tipoCondominio.id" from="${condominio.TipoCondominio.list()}" optionKey="id" required="" value="${condominioInstance?.tipoCondominio?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'canton', 'error')} required">
                <span class="grupo">
                    <label for="canton" class="col-md-2 control-label">
                        Canton
                    </label>
                    <div class="col-md-7">
                        <g:select id="canton" name="canton.id" from="${condominio.Canton.list()}" optionKey="id" required="" value="${condominioInstance?.canton?.id}" class="many-to-one form-control"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>
                    <div class="col-md-7">
                        <g:textField name="nombre" maxlength="63" required="" class="allCaps form-control required" value="${condominioInstance?.nombre}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'ruc', 'error')} ">
                <span class="grupo">
                    <label for="ruc" class="col-md-2 control-label">
                        Ruc
                    </label>
                    <div class="col-md-7">
                        <g:textField name="ruc" maxlength="13" class="allCaps form-control" value="${condominioInstance?.ruc}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'direccion', 'error')} ">
                <span class="grupo">
                    <label for="direccion" class="col-md-2 control-label">
                        Direccion
                    </label>
                    <div class="col-md-7">
                        <g:textField name="direccion" maxlength="127" class="allCaps form-control" value="${condominioInstance?.direccion}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'telefono', 'error')} ">
                <span class="grupo">
                    <label for="telefono" class="col-md-2 control-label">
                        Telefono
                    </label>
                    <div class="col-md-7">
                        <g:textField name="telefono" maxlength="63" class="allCaps form-control" value="${condominioInstance?.telefono}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'fechaInicio', 'error')} required">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-2 control-label">
                        Fecha Inicio
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaInicio" title="Fecha de inicio"  class="datepicker form-control required" value="${condominioInstance?.fechaInicio}"  />
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'fechaFin', 'error')} ">
                <span class="grupo">
                    <label for="fechaFin" class="col-md-2 control-label">
                        Fecha Fin
                    </label>
                    <div class="col-md-5">
                        <elm:datepicker name="fechaFin" title="Fecha de fin"  class="datepicker form-control" value="${condominioInstance?.fechaFin}" default="none" noSelection="['': '']" />
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'email', 'error')} ">
                <span class="grupo">
                    <label for="email" class="col-md-2 control-label">
                        Email
                    </label>
                    <div class="col-md-7">
                        <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="email" maxlength="63" class="allCaps form-control" value="${condominioInstance?.email}"/></div>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'sigla', 'error')} ">
                <span class="grupo">
                    <label for="sigla" class="col-md-2 control-label">
                        Sigla
                    </label>
                    <div class="col-md-7">
                        <g:textField name="sigla" class="allCaps form-control" value="${condominioInstance?.sigla}"/>
                    </div>
                    
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: condominioInstance, field: 'numeroViviendas', 'error')} required">
                <span class="grupo">
                    <label for="numeroViviendas" class="col-md-2 control-label">
                        Numero Viviendas
                    </label>
                    <div class="col-md-3">
                        <g:field name="numeroViviendas" type="number" value="${condominioInstance.numeroViviendas}" class="digits form-control required" required=""/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmCondominio").validate({
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
        
        email: {
            remote: {
                url: "${createLink(action: 'validar_unique_email_ajax')}",
                    type: "post",
                    data: {
                    id: "${condominioInstance?.id}"
                }
            }
        }
        
        },
        messages : {
            
            email: {
                remote: "Ya existe Email"
            }
            
        }
        
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormCondominio();
                return false;
            }
            return true;
        });
    </script>

</g:else>