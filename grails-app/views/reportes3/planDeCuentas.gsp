<html>
<head>
  <title>Plan de cuentas</title>

    <rep:estilos orientacion="p" pagTitle="${"Plan de Cuentas"}"/>

    <style type="text/css">
        .even {background:#fff;}
        .odd  {background:#ddd}

        .table th {
            background     : #5d6263;
            text-align     : center;
            text-transform : uppercase;
        }
        .table {
            margin-top      : 0.5cm;
            width           : 100%;
            border-collapse : collapse;
        }

        .table, .table td, .table th {
            border : solid 1px #444;
        }

        .table td, .table th {
            padding : 3px;
        }

        /*h1.break {*/
            /*page-break-before : always;*/
        /*}*/

</style>

</head>
<body>

<rep:headerFooter title="${'Plan de Cuentas'}" subtitulo="${'Datos'}" empresa="${empresa}"/>

 <table class="table table-bordered table-hover table-condensed table-bordered">
     <thead>

     <th style="width: 100px" align="center">
         Numero
     </th>
      <th style="width: 100px" align="center">
         Padre
     </th>
     <th style="width:50px" align="center">
         Nivel
     </th>
     <th style="width: 100px" align="center">
         Descripcion
     </th>

       </thead>
     <tbody>
     <g:each in="${cuentas}" var="cuenta" status="i">
         <tr class="${i%2 == 0 ? 'even': 'odd'}">
             <td>
                 ${cuenta.numero}
             </td>
             <td>
                 ${cuenta.padre?.numero}
             </td>
             <td align="center">
                 ${cuenta.nivel.id}
             </td>
             <td>
                <util:clean str="${cuenta.descripcion}"></util:clean>
             </td>

         </tr>

     </g:each>

    


     </tbody>
 </table>

</body>
</html>