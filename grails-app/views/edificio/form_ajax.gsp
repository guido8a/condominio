<%@ page import="condominio.Edificio" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!edificioInstance}">
    <elm:notFound elem="Edificio" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmEdificio" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${edificioInstance?.id}"/>
        <div class="form-group keeptogether ${hasErrors(bean: edificioInstance, field: 'descripcion', 'error')} required">
            <label for="condominio" class="control-label col-xs-3 col-md-3">
                Condominio
            </label>

            <div class="col-xs-9 col-md-9">
                <g:select name="condominio" from="${condominio.Condominio.list().sort { it.nombre }}"
                          class="form-control" optionKey="id" optionValue="nombre"
                          value="${edificioInstance?.condominio?.id}"/>
            </div>

            <div class="col-xs-12 col-md-12">
                <div class="row">
                    <span class="grupo">
                        <label for="descripcion" class="col-md-3 control-label">
                            Descripcion
                        </label>

                        <div class="col-md-6">
                            <g:textField name="descripcion" required="" class="form-control required"
                                         value="${edificioInstance?.descripcion}"/>
                        </div>
                        *
                    </span>
                </div>
            </div>

        </div>

    </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmEdificio").validate({
            errorClass: "help-block",
            errorPlacement: function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success: function (label) {
                label.parents(".grupo").removeClass('has-error');
            }

        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormEdificio();
                return false;
            }
            return true;
        });
    </script>

</g:else>