<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 25/02/22
  Time: 10:27
--%>

<%@ page import="condominio.Condominio" %>


<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmDocumento" role="form" action="guardarInfoDocumento_ajax" method="POST">
        <g:hiddenField name="id" value="${documento?.id}" />


        <div class="row" style="margin-bottom: 5px">
            <span class="grupo">
                <label class="col-md-3 control-label">
                    Documento
                </label>
                <label class="col-md-4" style="margin-top: 10px">
                    ${documento?.ruta}
                </label>
                <label class="col-md-1 control-label">
                    Fecha
                </label>
                <label class="col-md-3" style="margin-top: 10px">
                    ${documento?.fecha?.format("dd-MM-yyyy")}
                </label>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: documento, field: 'tipoDocumento', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-3 control-label">
                    Tipo de Documento
                </label>
                <div class="col-md-7">
                    <g:select name="tipoDocumento" from="${condominio.TipoDocumento.list()}" optionValue="descripcion" optionKey="id" class="form-control" value="${documento?.tipoDocumento?.id}"/>
                </div>
            </span>
        </div>


        <div class="form-group keeptogether ${hasErrors(bean: documento, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-3 control-label">
                    Descripción
                </label>
                <div class="col-md-7">
                    <g:textArea name="descripcion" maxlength="63" class="form-control required" value="${documento?.descripcion}" style="resize: none; "/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: documento, field: 'resumen', 'error')} required">
            <span class="grupo">
                <label for="resumen" class="col-md-3 control-label">
                    Resumen
                </label>
                <div class="col-md-7">
                    <g:textArea name="resumen" maxlength="1024" class="form-control required" value="${documento?.resumen}"  style="resize: none; height: 100px"/>
                </div>
            </span>
        </div>


    </g:form>
</div>

<script type="text/javascript">
    var validator = $("#frmDocumento").validate({
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
    });
    $(".form-control").keydown(function (ev) {
        if (ev.keyCode == 13) {
            submitFormDocumento();
            return false;
        }
        return true;
    });
</script>
