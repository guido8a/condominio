<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Gráfico de Ingresos y Egresos x mes</title>
    <meta name="layout" content="main">

    <script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250', file: 'jquery.jqplot.min.js')}"></script>
    <script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.pieRenderer.min.js')}"></script>
    <script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.barRenderer.min.js')}"></script>
    <script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.categoryAxisRenderer.min.js')}"></script>
    <script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.highlighter.min.js')}"></script>
    <script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.pointLabels.min.js')}"></script>
    <script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.canvasAxisLabelRenderer.min.js')}"></script>
    <script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.canvasTextRenderer.min.js')}"></script>
    <link href="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250', file: 'jquery.jqplot.min.css')}" rel="stylesheet">

    <style type="text/css">

    .chartContainer {
        height : 300px;
        width: 1400px;
    }

    .divChart2 {
        height       : 500px;
        width        : 1000px;
        float        : left;
        margin-right : 10px;
    }

    </style>


</head>

<body>

<div class="row">
    <div class="btn-group col-md-5">
        <a href="${createLink(controller: "reportes", action: "index")}" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
        <a href="#" class="btn btn-info btnImprimir">
            <i class="fa fa-print"></i> Imprimir
        </a>
    </div>
</div>


<div style="text-align: center; margin-top: -20px"><h3>Ingresos y Egresos desde ${desde} hasta ${hasta}</h3></div>


<div class="chartContainer hidden" style="margin-left: 10px; margin-top: 40px">
    <div id="chart2_lineas" class="divChart2 hidden"></div>
</div>



<script type="text/javascript">

    %{--$(".btnImprimir").click(function () {--}%
        %{--location.href="${createLink(controller: 'reportes', action: 'imprimirGraficoIng')}?anio=" + '${anio}'--}%
    %{--});--}%

    lineas("lineas");

    function lineas (tipo) {
        var $chart = $("#chart2_" + tipo);
//        var ticks = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre", "Octubre", "Noviembre", "Diciembre"];

        <g:applyCodec encodeAs="none">
        var ticks = ${meses};
        </g:applyCodec>

        %{--var data = [${ingresoEgreso[0].ingrvlor},${ingresoEgreso[1].ingrvlor},${ingresoEgreso[2].ingrvlor},${ingresoEgreso[3].ingrvlor},${ingresoEgreso[4].ingrvlor},${ingresoEgreso[5].ingrvlor},${ingresoEgreso[6].ingrvlor},${ingresoEgreso[7].ingrvlor},${ingresoEgreso[8].ingrvlor}, ${ingresoEgreso[9].ingrvlor}, ${ingresoEgreso[10].ingrvlor}, ${ingresoEgreso[11].ingrvlor}];--}%
        %{--var data2 = [${ingresoEgreso[0].egrsvlor},${ingresoEgreso[1].egrsvlor},${ingresoEgreso[2].egrsvlor},${ingresoEgreso[3].egrsvlor},${ingresoEgreso[4].egrsvlor},${ingresoEgreso[5].egrsvlor},${ingresoEgreso[6].egrsvlor},${ingresoEgreso[7].egrsvlor},${ingresoEgreso[8].egrsvlor}, ${ingresoEgreso[9].egrsvlor}, ${ingresoEgreso[10].egrsvlor}, ${ingresoEgreso[11].egrsvlor}];--}%

        var data =${ingresos.vlor};
        var data2 = ${egresos.vlor}
        var data3 = ${cobrar.por_cobrar}
        var data4 = ${cobrar.total}

        $(".chartContainer").removeClass("hidden");
        $chart.removeClass("hidden");
        $.jqplot ('chart2_' + tipo, [data,data2,data3,data4] , {
            title: 'Ingresos - Egresos',
            axesDefaults: {
                labelRenderer: $.jqplot.CanvasAxisLabelRenderer
            },
            seriesDefaults: {
                rendererOptions: {
                    smooth: true
                }
            },
            series:[
                {label:'Ingresos'},
                {label:'Egresos'},
                {label: 'Por Cobrar'},
                {label: 'Total'}
            ],
            legend         : {
                show     : true,
                location : 's',
                placement: 'outsideGrid'

            },
            axes: {
                xaxis: {
                    renderer: $.jqplot.CategoryAxisRenderer,
                    label: "Meses",
                    ticks: ticks,
                    pad: 0
                },
                yaxis: {
                    label: "Valores"
                }
            }
        });
    }

</script>


</body>
</html>