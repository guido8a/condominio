<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 04/04/18
  Time: 10:07
--%>



<script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250', file: 'jquery.jqplot.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.pieRenderer.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.barRenderer.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.categoryAxisRenderer.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.highlighter.min.js')}"></script>
<link href="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250', file: 'jquery.jqplot.min.css')}" rel="stylesheet">

<style type="text/css">

.divChart {
    height       : 360px;
    width        : 420px;
    float        : left;
    margin-right : 10px;
}

.chartContainer {
    height : 360px;
    width: 1400px;
}


</style>

<div class="chartContainer hidden" style="margin-left: 10px; margin-top: 40px">
    <div id="chart_anterior" class="divChart hidden"></div>
    <div id="chart_actual" class="divChart hidden"></div>
    <div id="chart_vencidos" class="divChart hidden"></div>
</div>

<div class="chartContainer hidden" style="margin-left: 10px; margin-top: 40px">
    <div id="chart2_ingresos" class="divChart hidden"></div>
    <div id="chart2_egresos" class="divChart hidden"></div>
    <div id="chart2_porCobrar" class="divChart hidden"></div>
</div>

<script type="text/javascript">

    var jsonGraph = ${raw(jsonGraph)};

    makeChart("actual", "Pagos Mes Actual", ${pagados}, ${noPagados}, "Pagados", "No Pagados");
    makeChart("anterior", "Pagos Mes Anterior", ${pagadosAnterior}, ${noPagadosAnterior}, "Pagados Mes Anterior", "No Pagados Mes Anterior");
    makeChart("vencidos", "Pagos Valores Vencidos", ${vencidos}, ${noVencidos}, "Pagos Vencidos", "Pagos no vencidos");

    makeChartBars("ingresos", "Ingresos", ${ingresosAnt}, ${ingresosAct}, "Anterior", "Actual");
    makeChartBars("egresos", "Egresos", ${egresosAnt}, ${egresosAct}, "Anterior", "Actual");
    makeChartBars2("porCobrar", "Valores Por Cobrar", ${saldoInicial}, ${ingresoSaldo}, ${egresoSaldo}, ${saldoFinal}, "Saldo Inicial", "Por Cobrar", "Por Pagar", "Resultado Final");

    function makeChart(tipo,titulo, v1, v2, tit1, tit2) {
        var data = [[tit1 ,v1],[tit2 ,v2]];
        if (data.length > 0) {
            var $chart = $("#chart_" + tipo);
            $(".chartContainer").removeClass("hidden");
            $chart.removeClass("hidden");
            $.jqplot('chart_' + tipo, [data],
                {
//                    title          : data.title,
                    title          : titulo,
                    seriesDefaults : {
                        // Make this a pie chart.
                        renderer        : $.jqplot.PieRenderer,
//                        renderer        : $.jqplot.BarRenderer,
                        rendererOptions : {
                            // Put data labels on the pie slices.
                            // By default, labels show the percentage of the slice.
                            showDataLabels : true,
                            sliceMargin    : 5
                        },
                        highlighter     : {
                            show              : true,
                            formatString      : '%s',
                            tooltipLocation   : 'sw',
                            useAxesFormatters : false
                        }
                    },
                    legend         : {
                        show     : true,
                        location : 'e',
                        placement: 'outsideGrid'

                    }
                }
            );
            $chart.bind('jqplotDataHighlight', function (ev, seriesIndex, pointIndex, data) {
                var $this = $(this);
                $this.qtip({
                    show     : {
                        ready : true
                    },
                    position : {
                        my     : 'bottom center',  // Position my top left...
                        at     : 'top center', // at the bottom right of...
                        target : "mouse",
                        adjust : {
                            mouse : false
                        }
                    },
                    content  : data[0] + ": " + data[1]
                });
            });
        }
    }



    function makeChartBars(tipo,titulo, v1, v2, tit1, tit2) {
        var data = [v1,0];
        var data2 = [0,v2];
        var ticks = [tit1, tit2];
        if (data.length > 0) {
            var $chart = $("#chart2_" + tipo);
            $(".chartContainer").removeClass("hidden");
            $chart.removeClass("hidden");
            $.jqplot('chart2_' + tipo, [data, data2],
                {
                    title          : titulo,
                    seriesDefaults : {
                        renderer   : $.jqplot.BarRenderer,
                        pointLabels: { show: true }
//                        ,
//                        barMargin: 30,
//                        barWidth: 260,
//                        barPadding: 100
                    },
                    series:[
                        {label:'Anterior'},
                        {label:'Actual'}
                    ],
                    axes: {
                        xaxis: {
                            renderer: $.jqplot.CategoryAxisRenderer,
                            ticks: ticks
                        }
                    },

                    legend         : {
                        show     : true,
                        location : 'e',
                        placement: 'outsideGrid'
                    }
                }
            );
            $chart.bind('jqplotDataHighlight', function (ev, seriesIndex, pointIndex, data) {
                var $this = $(this);
                $this.qtip({
                    show     : {
                        ready : true
                    },
                    position : {
                        my     : 'bottom center',  // Position my top left...
                        at     : 'top center', // at the bottom right of...
                        target : "mouse",
                        adjust : {
                            mouse : false
                        }
                    },
                    content  : " " + data[1]
                });
            });


//            $chart.bind('jqplotDataClick',
//                function (ev, seriesIndex, pointIndex, data) {
//                    var $this = $(this);
//                    $this.qtip({
//                        show     : {
//                            ready : true
//                        },
//                        position : {
//                            my     : 'bottom center',  // Position my top left...
//                            at     : 'top center', // at the bottom right of...
//                            target : "mouse",
//                            adjust : {
//                                mouse : false
//                            }
//                        },
//                        content  : data[0] + ": " + data[1]
//                    });
//                }
//            );

        }
    }

    function makeChartBars2(tipo,titulo, v1, v2, v3, v4, tit1, tit2, tit3, tit4) {
        var data = [v1,0,0,0];
        var data2 = [0,v2,0,0];
        var data3 = [0,0,v3,0];
        var data4 = [0,0,0,v4];
        var ticks = [tit1, tit2, tit3, tit4];
        if (data.length > 0) {
            var $chart = $("#chart2_" + tipo);
            $(".chartContainer").removeClass("hidden");
            $chart.removeClass("hidden");
            $.jqplot('chart2_' + tipo, [data, data2, data3, data4],
                {
                    title          : titulo,
                    seriesDefaults : {
                        renderer   : $.jqplot.BarRenderer,
                        barMargin: 30,
                        barWidth: 60
//                        rendererOptions: {fillToZero: true}
                    },
                    series:[
                        {label:tit1},
                        {label:tit2},
                        {label:tit3},
                        {label:tit4}
                    ],
                    axes: {
                        xaxis: {
                            renderer: $.jqplot.CategoryAxisRenderer,
                            ticks: ticks
                        }
                    },

                    legend         : {
                        show     : true,
                        location : 'e',
                        placement: 'outsideGrid'
                    }
                }
            );
            $chart.bind('jqplotDataHighlight', function (ev, seriesIndex, pointIndex, data) {
                var $this = $(this);
                $this.qtip({
                    show     : {
                        ready : true
                    },
                    position : {
                        my     : 'bottom center',  // Position my top left...
                        at     : 'top center', // at the bottom right of...
                        target : "mouse",
                        adjust : {
                            mouse : false
                        }
                    },
                    content  : "" + data[1]
                });
            });
        }
    }



</script>