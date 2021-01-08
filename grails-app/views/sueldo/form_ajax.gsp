<%@ page import="condominio.Sueldo" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!sueldoInstance}">
    <elm:notFound elem="Sueldo" genero="o" />
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmSueldo" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${sueldoInstance?.id}" />
            <g:hiddenField name="empleado" value="${empleado?.id}" />

            <div class="form-group keeptogether ${hasErrors(bean: sueldoInstance, field: 'anio', 'error')} ${hasErrors(bean: sueldoInstance, field: 'valor', 'error')}">
                <span class="grupo">
                    <label for="anio" class="col-md-2 control-label">
                        Año
                    </label>
                    <div class="col-md-4">
                        <g:select id="anio" name="anio.id" from="${utilitarios.Anio.list()}" optionKey="id" optionValue="numero" required="" value="${sueldoInstance?.anio?.id}" class="many-to-one form-control"/>
                    </div>
                </span>
                <span class="grupo">
                    <label for="valor" class="col-md-2 control-label">
                        Valor
                    </label>
                    <div class="col-md-3">
                        <g:textField name="valor" class="number form-control" value="${sueldoInstance?.valor ?: 0}"/>
                    </div>
                </span>
                <span>
                    <a href="#" class="btn btn-success btnAgregar" title="Agregar sueldo"><i class="fa fa-plus"></i> </a>
                </span>
            </div>
        </g:form>

        <div id="divTablaSueldos">

        </div>
    </div>

    <script type="text/javascript">

        $(".btnAgregar").click(function () {
            var anio = $("#anio").val();
            var valor = $("#valor").val();
            var id = $("#id").val();
            $.ajax({
                type: 'POST',
                url:'${createLink(controller: 'sueldo', action: 'saveSueldo_ajax')}',
                data:{
                    empleado: '${empleado?.id}',
                    anio: anio,
                    valor:valor,
                    id: id
                },
                success:function (msg) {
                    var parts = msg.split("_");
                    if(parts[0] == 'ok'){
                        log("Guardado correctamente","success");
                        cargarTablaSueldos();
                    }else{
                        if(parts[0] == 'er'){
                            bootbox.alert('<i class="fa fa-exclamation-triangle fa-2x text-danger"></i>' + parts[1])
                        }else{
                            log("Error al guardar el sueldo","error")
                        }
                    }
                }
            })
        });

        cargarTablaSueldos();

        function cargarTablaSueldos(){
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'sueldo', action: 'tablaSueldos_ajax')}',
                data:{
                    id: '${empleado?.id}'
                },
                success: function (msg) {
                    $("#divTablaSueldos").html(msg)
                }
            })
        }

        var validator = $("#frmSueldo").validate({
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
                submitFormSueldo();
                return false;
            }
            return true;
        });
    </script>

</g:else>