<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!contabilidadInstance}">
    <elm:notFound elem="Contabilidad" genero="o"/>
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmContabilidad" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${contabilidadInstance?.id}"/>

        <g:if test="${!contabilidadInstance?.id}">
            <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'fechaInicio', 'error')} required">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-2 control-label text-info">
                        Fecha Inicio
                    </label>

                    <div class="col-md-4">
                        <elm:datepicker name="fechaInicio" title="Fecha de inicio del periodo comtable" class="datepicker form-control required" value="${contabilidadInstance?.fechaInicio}"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'fechaCierre', 'error')} ">
                <span class="grupo">
                    <label for="fechaCierre" class="col-md-2 control-label text-info">
                        Fecha Cierre
                    </label>

                    <div class="col-md-4">
                        <elm:datepicker name="fechaCierre" title="Fecha de cierre del periodo comtable" class="datepicker form-control required" value="${contabilidadInstance?.fechaCierre}"/>
                    </div>
                    *
                </span>
            </div>
        </g:if>

        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'prefijo', 'error')} ">
            <span class="grupo">
                <label for="prefijo" class="col-md-2 control-label text-info">
                    Prefijo
                </label>

                <div class="col-md-6">
                    <g:textField name="prefijo" maxlength="8" class="allCaps form-control" value="${contabilidadInstance?.prefijo}"/>
                </div>

            </span>
        </div>

        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>

                <div class="col-md-8">
                    <g:textField name="descripcion" maxlength="63" required="" class="form-control required" value="${contabilidadInstance?.descripcion}"/>
                </div>
                *
            </span>
        </div>

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'descripcion', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="descripcion" class="col-md-4 control-label text-info">--}%
%{--                    Cuenta de resultados--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="cuenta" from="${cuentas}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id" class="form-control" value="${contabilidadInstance?.cuenta?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'creditoTributarioIva', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="descripcion" class="col-md-4 control-label text-info">--}%
%{--                    Crédito Tributario IVA--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="creditoIva" from="${cntacr}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id" class="form-control" value="${contabilidadInstance?.creditoTributarioIva?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'creditoTributarioRenta', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="descripcion" class="col-md-4 control-label text-info">--}%
%{--                    Crédito Tributario RENTA--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="creditoRenta" from="${cntacr}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id" class="form-control" value="${contabilidadInstance?.creditoTributarioRenta?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'retencionCompraIva', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="descripcion" class="col-md-4 control-label text-info">--}%
%{--                    Retención en Compras IVA--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="retencionIva" from="${cntart}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id" class="form-control" value="${contabilidadInstance?.retencionCompraIva?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'retencionCompraRenta', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="descripcion" class="col-md-4 control-label text-info">--}%
%{--                    Retención en Compras RENTA--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="retencionRenta" from="${cntart}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id" class="form-control" value="${contabilidadInstance?.retencionCompraRenta?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'costos', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="costos" class="col-md-4 control-label text-info">--}%
%{--                    Costo de ventas--}%
%{--                </label>--}%

%{--                <span class="col-md-6">--}%
%{--                    <g:select name="costos" from="${cntacsto}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id" class="form-control"--}%
%{--                              value="${contabilidadInstance?.costos?.id}"/>--}%
%{--                </span>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'inventario', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="inventario" class="col-md-4 control-label text-info">--}%
%{--                    Inventarios--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="inventario" from="${cntainvt}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id"--}%
%{--                              class="form-control" value="${contabilidadInstance?.inventario?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

    %{--Conciliación Bancaria--}%

%{--        <div class="row">--}%
%{--            <span class="grupo">--}%
%{--                <div class="col-md-4" style="margin-left: 400px">--}%
%{--                   <label>Conciliación Bancaria</label>--}%
%{--                </div>--}%
%{--            </span>--}%
%{--        </div>--}%


%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'bancos', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="banco" class="col-md-4 control-label text-info">--}%
%{--                    Cuenta de Bancos--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="banco" from="${banco}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id"--}%
%{--                              class="form-control" value="${contabilidadInstance?.bancos?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'porPagar', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="porPagar" class="col-md-4 control-label text-info">--}%
%{--                    Cuentas por Pagar--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="porPagar" from="${pagar}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id"--}%
%{--                              class="form-control" value="${contabilidadInstance?.porPagar?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="form-group ${hasErrors(bean: contabilidadInstance, field: 'porCobrar', 'error')} required">--}%
%{--            <span class="grupo">--}%
%{--                <label for="porCobrar" class="col-md-4 control-label text-info">--}%
%{--                   Cuentas por Cobrar--}%
%{--                </label>--}%

%{--                <div class="col-md-6">--}%
%{--                    <g:select name="porCobrar" from="${cobrar}" optionValue="${{it.numero + " - " + it.descripcion}}" optionKey="id"--}%
%{--                              class="form-control" value="${contabilidadInstance?.porCobrar?.id}"/>--}%
%{--                </div>--}%
%{--                *--}%
%{--            </span>--}%
%{--        </div>--}%


    </g:form>

    <script type="text/javascript">
        var validator = $("#frmContabilidad").validate({
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
            if (ev.keyCode === 13) {
                submitForm();
                return false;
            }
            return true;
        });
    </script>

</g:else>