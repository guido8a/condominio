<%@ page import="condominio.TipoOcupacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoOcupacionInstance}">
    <elm:notFound elem="TipoOcupacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmTipoOcupacion" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${tipoOcupacionInstance?.id}" />

            
            <div class="form-group keeptogether ${hasErrors(bean: tipoOcupacionInstance, field: 'codigo', 'error')} required">
                <span class="grupo">
                    <label for="codigo" class="col-md-2 control-label">
                        Codigo
                    </label>
                    <div class="col-md-6">
                        <g:textField name="codigo" required="" class="allCaps form-control required" value="${tipoOcupacionInstance?.codigo}"/>
                    </div>
                     *
                </span>
            </div>
            
            <div class="form-group keeptogether ${hasErrors(bean: tipoOcupacionInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripcion
                    </label>
                    <div class="col-md-6">
                        <g:textField name="descripcion" required="" class="allCaps form-control required" value="${tipoOcupacionInstance?.descripcion}"/>
                    </div>
                     *
                </span>
            </div>
            
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmTipoOcupacion").validate({
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
        
        codigo: {
            remote: {
                url: "${createLink(action: 'validar_unique_codigo_ajax')}",
                    type: "post",
                    data: {
                    id: "${tipoOcupacionInstance?.id}"
                }
            }
        }
        
        },
        messages : {
            
            codigo: {
                remote: "Ya existe Codigo"
            }
            
        }
        
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormTipoOcupacion();
                return false;
            }
            return true;
        });
    </script>

</g:else>