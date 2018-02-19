<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/02/18
  Time: 11:18
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Pagos Pendientes</title>

    %{--<rep:estilos orientacion="l" pagTitle="${"Kardex 4"}"/>--}%

    <style type="text/css">

    html {
        font-family: Verdana, Arial, sans-serif;
        font-size: 15px;
    }

    h1, h2, h3 {
        text-align: center;
    }

    table {
        border-collapse: collapse;
        width: 100%;
    }

    th, td {
        vertical-align: middle;
    }

    th {
        background: #bbb;
    }

    .derecha{
        text-align: right;
    }
    .centro{
        text-align: center;
    }
    .izquierda{
        text-align: left;
    }

    </style>

</head>

<body>

%{--<rep:headerFooter title="${'Existencias por item'}" subtitulo="${'Datos'}" empresa="${empresa}"/>--}%

<h2 style="color: #0a6aa1">CONJUNTO HABITACIONAL "LOS VIÑEDOS"</h2>
<h2 style="color: #0a6aa1">
    %{--PAGOS PENDIENTES A LA FECHA <g:formatDate date="${hasta}" format="dd-MM-yyyy"/>--}%
    PAGOS PENDIENTES
</h2>

<div>
    <table border="1">
        <thead>
        <tr>
            <th colspan="1" class="centro">Dpto.</th>
            <th colspan="1" class="centro">Nombre</th>
            <th colspan="1" class="centro">Detalle</th>
            <th colspan="1" class="centro">Por pagar</th>
        </tr>
        </thead>

        <tbody>

        <g:set var="anterior" value="${''}"/>
        <g:set var="nuevo" value="${''}"/>
        <g:set var="total" value="${0}"/>
        <g:each in="${res}" var="fila" status="j">
            <g:set var="nuevo" value="${fila.depart}"/>
            <g:if test="${anterior == nuevo}">
                <g:if test="${nuevo == ultimo && (cont-1) == j}">
                    <tr style="width: 100%">
                        <td class="izquierda" style="width: 8%">${fila.depart}</td>
                        <td class="izquierda" style="width: 17%; font-size: 11px">${fila.nombre}</td>
                        <td class="izquierda" style="width: 60%; font-size: 11px">${fila.detalle}</td>
                        <td class="derecha" style="width: 15%;">${fila.por_pagar}</td>
                        <g:set var="total" value="${total += fila.por_pagar}"/>
                        <g:set var="anterior" value="${fila.depart}"/>
                    </tr>
                    <tr style="font-weight: bold; color: #0a6aa1"><td colspan="3" class="derecha">TOTAL:</td><td class="derecha">${total}</td></tr>
                </g:if>
                <g:else>
                    <tr style="width: 100%">
                        <td class="izquierda" style="width: 8%">${fila.depart}</td>
                        <td class="izquierda" style="width: 17%; font-size: 11px">${fila.nombre}</td>
                        <td class="izquierda" style="width: 60%; font-size: 11px">${fila.detalle}</td>
                        <td class="derecha" style="width: 15%;">${fila.por_pagar}</td>
                        <g:set var="total" value="${total += fila.por_pagar}"/>
                        <g:set var="anterior" value="${fila.depart}"/>
                    </tr>
                </g:else>
            </g:if>
            <g:else>
                <g:if test="${j == 0}">
                    <tr style="width: 100%">
                        <td class="izquierda" style="width: 8%">${fila.depart}</td>
                        <td class="izquierda" style="width: 17%; font-size: 11px">${fila.nombre}</td>
                        <td class="izquierda" style="width: 60%; font-size: 11px">${fila.detalle}</td>
                        <td class="derecha" style="width: 15%;">${fila.por_pagar}</td>
                        <g:set var="total" value="${total += fila.por_pagar}"/>
                        <g:set var="anterior" value="${fila.depart}"/>
                    </tr>
                </g:if>
                <g:else>
                    <tr style="font-weight: bold; color: #0a6aa1"><td colspan="3" class="derecha">TOTAL:</td><td class="derecha">${total}</td></tr>
                    <tr style="width: 100%">
                        <td class="izquierda" style="width: 8%">${fila.depart}</td>
                        <td class="izquierda" style="width: 17%; font-size: 11px">${fila.nombre}</td>
                        <td class="izquierda" style="width: 60%; font-size: 11px">${fila.detalle}</td>
                        <td class="derecha" style="width: 15%;">${fila.por_pagar}</td>
                        <g:set var="total" value="${fila.por_pagar}"/>
                        <g:set var="anterior" value="${fila.depart}"/>
                    </tr>
                </g:else>

            </g:else>
        </g:each>
        </tbody>
    </table>
</div>

</body>
</html>