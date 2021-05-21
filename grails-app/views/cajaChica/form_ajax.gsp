<%@ page import="condominio.CajaChica" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>


<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmCajaChica" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${cajaChicaInstance?.id}" />


        <div class="form-group keeptogether ${hasErrors(bean: cajaChicaInstance, field: 'condominio', 'error')} required">
            <span class="grupo">
                <label for="condominio" class="col-md-2 control-label">
                    Condominio
                </label>
                <div class="col-md-8">
                    <g:hiddenField name="condominio.id" id="condominio" value="${condominio?.id}"/>
                    <g:select id="condominio_id" name="condominio_name" from="${condominio.Condominio.list()}" disabled=""   optionKey="id" value="${condominio?.id}" class="many-to-one form-control"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: cajaChicaInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fecha"  class="datepicker form-control required" value="${cajaChicaInstance?.fecha}"  />
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: cajaChicaInstance, field: 'valor', 'error')} required">
            <span class="grupo">
                <label for="valor" class="col-md-2 control-label">
                    Valor
                </label>
                <div class="col-md-4">
                    <g:textField name="valor" value="${cajaChicaInstance?.valor}" class="number form-control  required" required=""/>
                </div>
                *
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: cajaChicaInstance, field: 'cheque', 'error')} ">
            <span class="grupo">
                <label for="cheque" class="col-md-2 control-label">
                    Cheque
                </label>
                <div class="col-md-8">
                    <g:textField name="cheque" class="allCaps form-control" value="${cajaChicaInstance?.cheque}"/>
                </div>

            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: cajaChicaInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-8">
                    <g:textArea name="observaciones" class="form-control" style="resize: none" value="${cajaChicaInstance?.observaciones}"/>
                </div>
            </span>
        </div>



    </g:form>
</div>

<script type="text/javascript">
    var validator = $("#frmCajaChica").validate({
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
            submitFormCajaChica();
            return false;
        }
        return true;
    });
</script>
