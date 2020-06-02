<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/06/20
  Time: 9:59
--%>

<style>
    .alinear{
        text-align: center;
    }
</style>

<div style="margin-top: 15px; min-height: 400px" class="vertical-container">
    <div class="linea"></div>
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>
            <th class="alinear" style="width: 53%;">
                Nombre
            </th>
            <th class="alinear" style="width: 20%;">
                Edificio
            </th>
            <th class="alinear" style="width: 15%">
                Departamento
            </th>
            <th class="alinear" style="width: 11%">
                Imprimir
            </th>
            <th style="width: 1%">
            </th>
        </tr>
        </thead>
    </table>
    <div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
              <g:each in="${personas}" var="persona">
                  <tr>
                      <td style="width: 53%">${persona.prsnnmbr + " " + persona.prsnapll}</td>
                      <td style="width: 20%">${persona.edifdscr}</td>
                      <td style="width: 15%">${persona.prsndpto}</td>
                      <td class="alinear" style="width: 11%">
                          <a href="#" class="btn btn-info btnImprimirSolicitud" title="Imprimir solicitud de pago" data-id="${persona?.prsn__id}"><i class="fa fa-print"></i> </a>
                      </td>
                  </tr>
              </g:each>
        </table>
    </div>
</div>

<script type="text/javascript">
    $(".btnImprimirSolicitud").click(function () {
        openLoader("Cargando...");
        var vlor = '${alicuota}';
        var id = $(this).data("id");
        location.href = "${g.createLink(controller: 'reportes', action: 'reporteSolicitudPago')}?vlor=" + vlor + "&id=" + id;
        closeLoader();
    });
</script>