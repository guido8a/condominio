<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 04/01/21
  Time: 15:29
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Gráfico de Ingresos y Egresos x mes</title>
    <meta name="layout" content="main">

    <script src="${resource(dir: 'js', file: 'Chart.js')}"></script>


    <style type="text/css">

    .grafico{
        border-style: solid;
        border-color: #606060;
        border-width: 1px;
        width: 100%;
        /*float: left;*/
        text-align: center;
        height: 650px;
        border-radius: 8px;
        margin: 10px;
    }

    </style>


</head>

<body>


<div class="chart-container grafico" id="chart-area" style="height: 650px">
    <h3 id="titulo"></h3>
    <div id="graf" align="center">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

</div>

<script type="text/javascript">

    var canvas = $("#clases");
    var canvas2 = $("#clases2");
    var myChart;
    var myChart2;


    graficar();

    function graficar() {

//    $(".graficar").click(function () {
        var id = this.id;

            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportes', action: 'ingresoEgresoData_ajax')}',
                data: {
                    desde: '${desde}',
                    hasta: '${hasta}'
                },
                success: function (mnsj) {

                    var json = $.parseJSON(mnsj);

                    $("#titulo").html("Ingresos - Egresos");

                    canvas = $("#clases");

                    var colores = ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9"];
                    var datos = [];
                    var facultades = "<ul>";
                    var facultades2 = "<ul>";
                    var leyendaG = [];
                    var leyendaE = [];
                    var leyenda = [];
                    var leyenda2 = [];
                    var vlor;
                    var indice = 0;
                    var ingresos = [];
                    var egresos = [];
                    var cobrar = [];
                    var totales = []
                    var ddEE = [];
                    var ddEP = [];
                    var parts;
                    var valores;
                    var ges = 0;
                    var es = 0;
                    var valoresE1 = [];
                    var valoresE2 = [];
                    var valoresG1 = [];
                    var valoresG2 = [];
                    $.each(json, function (key, val) {
                    console.log("key:", key, "val:", val);
                        parts = key.split("_");
                        valores = val.split("_");

                            ingresos.push(valores[0]);
                            egresos.push(valores[1]);
                            cobrar.push(valores[2]);
                            totales.push(valores[3]);
                            leyenda.push(parts[0]);
                            ges ++;

                        indice++
                    });

                    myChart = new Chart(canvas, {
                        type: 'line',
                        data: {
                            labels: leyenda,
                            datasets: [
                                {
                                    label: ["Ingresos"],
                                    backgroundColor: "rgba(55, 160, 235, 0.7)",
                                    borderWidth: 2,
//                                    stack: 'Stack 0',
                                    data: ingresos
                                },
                                {
                                    label: ["Egresos"],
                                    backgroundColor: "rgba(120, 200, 215, 0.7)",
                                    borderWidth: 2,
//                                    stack: 'Stack 0',
                                    data: egresos
                                },
                                {
                                    label: ["Por Cobrar"],
                                    backgroundColor: "rgba(225, 58, 55, 0.7)",
                                    borderWidth:  2,
//                                    stack: 'Stack 0',
                                    data: cobrar
                                },
                                {
                                    label: ["Total"],
                                    backgroundColor: "rgba(225, 150, 10, 0.7)",
                                    borderWidth:  2,
//                                    stack: 'Stack 0',
                                    data: totales
                                }
                            ]
                        },
                        options: {
                            legend: { display: true,
                                labels: {
                                    fontColor: 'rgb(20, 80, 100)',
                                    fontSize: 11
                                }
                            },
                            scales: {
                                xAxes: [{
                                    ticks: {
                                        beginAtZero: true
                                    },
                                    stacked: false
                                }],
                                yAxes: [{
                                    ticks: {
                                        beginAtZero: true
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Valores',
                                        fontColor: '#000000'
                                    }
//                                    ,
//                                    stacked: true
                                }]
                            }

                        }
                    });


                }
            });
    }

</script>

</body>
</html>