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
<script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.pointLabels.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.canvasAxisLabelRenderer.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250/plugins', file: 'jqplot.canvasTextRenderer.min.js')}"></script>
<link href="${resource(dir: 'js/plugins/jquery.jqplot.1.0.8r1250', file: 'jquery.jqplot.min.css')}" rel="stylesheet">

<style type="text/css">

.divChart {
    height       : 300px;
    width        : 380px;
    float        : left;
    margin-right : 10px;
}

.chartContainer {
    height : 300px;
    width: 1400px;
}

.divChart2 {
    height       : 300px;
    width        : 600px;
    float        : left;
    margin-right : 10px;
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

%{--<div class="chartContainer hidden" style="margin-left: 10px; margin-top: 40px">--}%
    %{--<div id="chart2_lineas" class="divChart2 hidden"></div>--}%
%{--</div>--}%


<script type="text/javascript">

    var jsonGraph = ${raw(jsonGraph)};

    makeChart("actual", "Pagos Mes Actual", ${pagados}, ${noPagados}, "Pagados", "No Pagados");
    makeChart("anterior", "Pagos Mes Anterior", ${pagadosAnterior}, ${noPagadosAnterior}, "Pagados Mes Anterior",
            "No Pagados Mes Anterior");
    makeChart("vencidos", "Pagos Valores Vencidos", ${vencidos}, ${noVencidos}, "Pagos Vencidos", "Pagos no vencidos");

    %{--makeChartBars("ingresos", "Ingresos", ${ingresosAnt}, ${ingresosAct}, "Anterior", "Actual");--}%
    makeChartBars6("ingresos", "Ingresos", ${ingresosAnt},${ingresoTotalAnt} ,${ingresosAct},${ingresoTotalAct}, "Anterior", "Por recaudar","Actual" , "Por recaudar ");
    makeChartBars("egresos", "Egresos", ${egresosAnt}, ${egresosAct}, "Anterior", "Actual");
    makeChartBars2("porCobrar", "Valores Por Cobrar", ${saldoInicial}, ${ingresoSaldo}, ${egresoSaldo}, ${saldoFinal},
            "Saldo Inicial", "Por Cobrar", "Por Pagar", "Resultado Final");

//    lineas("lineas");

    function makeChart(tipo, titulo, v1, v2, tit1, tit2) {
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
                        location : 's',
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
                    }
//                    ,
//
//                    legend         : {
//                        show     : true,
//                        location : 's',
//                        placement: 'outsideGrid'
//                    }
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
//        var data = [v1,v2,v3,v4];
        var data = [[tit1,v1],[tit2,v2],[tit3,v3],[tit4,v4]];
        var ticks = [tit1, tit2, tit3, tit4];
        if (data.length > 0) {
            var $chart = $("#chart2_" + tipo);
            $(".chartContainer").removeClass("hidden");
            $chart.removeClass("hidden");
            $.jqplot('chart2_' + tipo, [data],
                {
                    title          : titulo,
//                    seriesColors:['#85802b', '#00749F', '#73C774', '#C7754C'],
                    seriesDefaults : {
                        renderer   : $.jqplot.BarRenderer,
                        showMarker:false,
                        pointLabels: { show:true },
                        rendererOptions: {
                            varyBarColor: true
                        }
                    }
                    ,
                    series:[
                        {label:tit1},
                        {label:tit2},
                        {label:tit3},
                        {label:tit4}
                    ],
                    axes: {
                        xaxis: {
                            renderer: $.jqplot.CategoryAxisRenderer
//                            ,
//                            ticks: ticks
                        }
                    }
//                    ,
//
//                    legend         : {
//                        show     : true,
//                        location : 's',
//                        placement: 'outsideGrid'
//                    }
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

    function makeChartBars6(tipo,titulo, v1, v2, v3, v4, tit1, tit2, tit3, tit4) {
//        var data = [v1,v2,v3,v4];
        var data = [[tit1,v1],[tit2,v2],[tit3,v3],[tit4,v4]];
        var ticks = [tit1, tit2, tit3, tit4];
        if (data.length > 0) {
            var $chart = $("#chart2_" + tipo);
            $(".chartContainer").removeClass("hidden");
            $chart.removeClass("hidden");
            $.jqplot('chart2_' + tipo, [data],
                {
                    title          : titulo,
                    seriesColors:['#73C774', '#85802b', '#73C774', '#85802b'],
                    seriesDefaults : {
                        renderer   : $.jqplot.BarRenderer,
                        showMarker:false,
                        pointLabels: { show:true },
                        rendererOptions: {
                            varyBarColor: true
                        }
                    }
                    ,
                    series:[
                        {label:tit1},
                        {label:tit2},
                        {label:tit3},
                        {label:tit4}
                    ],
                    axes: {
                        xaxis: {
                            renderer: $.jqplot.CategoryAxisRenderer
                        }
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

    %{--function lineas (tipo) {--}%
        %{--var $chart = $("#chart2_" + tipo);--}%
        %{--var ticks = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre", "Octubre", "Noviembre", "Diciembre"];--}%

        %{--var data = [${ingresoEgreso[0].ingrvlor},${ingresoEgreso[1].ingrvlor},${ingresoEgreso[2].ingrvlor},${ingresoEgreso[3].ingrvlor},${ingresoEgreso[4].ingrvlor},${ingresoEgreso[5].ingrvlor},${ingresoEgreso[6].ingrvlor},${ingresoEgreso[7].ingrvlor},${ingresoEgreso[8].ingrvlor}, ${ingresoEgreso[9].ingrvlor}, ${ingresoEgreso[10].ingrvlor}, ${ingresoEgreso[11].ingrvlor}];--}%
        %{--var data = [[${ingresoEgreso[0].messnmro},${ingresoEgreso[0].ingrvlor}], [${ingresoEgreso[1].messnmro},${ingresoEgreso[1].ingrvlor}],[ ${ingresoEgreso[2].messnmro},${ingresoEgreso[2].ingrvlor}], [${ingresoEgreso[3].messnmro},${ingresoEgreso[3].ingrvlor}], [${ingresoEgreso[4].messnmro},${ingresoEgreso[4].ingrvlor}], [${ingresoEgreso[5].messnmro},${ingresoEgreso[5].ingrvlor}], [${ingresoEgreso[6].messnmro}, ${ingresoEgreso[6].ingrvlor}], [${ingresoEgreso[7].messnmro}, ${ingresoEgreso[7].ingrvlor}], [${ingresoEgreso[8].messnmro}, ${ingresoEgreso[8].ingrvlor}], [${ingresoEgreso[9].messnmro}, ${ingresoEgreso[9].ingrvlor}], [${ingresoEgreso[10].messnmro} ,${ingresoEgreso[10].ingrvlor}], [${ingresoEgreso[11].messnmro}, ${ingresoEgreso[11].ingrvlor}]];--}%
        %{--var data2 = [[${ingresoEgreso[0].egrsvlor}, ticks[0]],[${ingresoEgreso[1].egrsvlor}, ticks[1]]];--}%
        %{--var data2 = [${ingresoEgreso[0].egrsvlor},${ingresoEgreso[1].egrsvlor},${ingresoEgreso[2].egrsvlor},${ingresoEgreso[3].egrsvlor},${ingresoEgreso[4].egrsvlor},${ingresoEgreso[5].egrsvlor},${ingresoEgreso[6].egrsvlor},${ingresoEgreso[7].egrsvlor},${ingresoEgreso[8].egrsvlor}, ${ingresoEgreso[9].egrsvlor}, ${ingresoEgreso[10].egrsvlor}, ${ingresoEgreso[11].egrsvlor}];--}%

        %{--$(".chartContainer").removeClass("hidden");--}%
        %{--$chart.removeClass("hidden");--}%
        %{--$.jqplot ('chart2_' + tipo, [data, data2] , {--}%
            %{--title: 'Ingresos - Egresos',--}%
            %{--axesDefaults: {--}%
                %{--labelRenderer: $.jqplot.CanvasAxisLabelRenderer--}%
            %{--},--}%
            %{--seriesDefaults: {--}%
                %{--rendererOptions: {--}%
                    %{--smooth: true--}%
                %{--}--}%
            %{--},--}%
            %{--axes: {--}%
                %{--xaxis: {--}%
                    %{--renderer: $.jqplot.CategoryAxisRenderer,--}%
                    %{--label: "Meses",--}%
                    %{--ticks: ticks,--}%
                    %{--pad: 0--}%
                %{--},--}%
                %{--yaxis: {--}%
                    %{--label: "Valores"--}%
                %{--}--}%
            %{--}--}%
        %{--});--}%

%{--//        $chart.bind('jqplotDataHighlight', function (ev, seriesIndex, pointIndex, data) {--}%
%{--//            var $this = $(this);--}%
%{--//            $this.qtip({--}%
%{--//                show     : {--}%
%{--//                    ready : true--}%
%{--//                },--}%
%{--//                position : {--}%
%{--//                    my     : 'bottom center',  // Position my top left...--}%
%{--//                    at     : 'top center', // at the bottom right of...--}%
%{--//                    target : "mouse",--}%
%{--//                    adjust : {--}%
%{--//                        mouse : false--}%
%{--//                    }--}%
%{--//                },--}%
%{--//                content  : " " + data[1]--}%
%{--//            });--}%
%{--//        })--}%



    %{--}--}%



</script>