<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 25/05/20
  Time: 15:36
--%>
<g:if test="${dpto}">
    <label>Departamento:</label> ${dpto}<label style="margin-left: 15px">Descripción:</label> ${desc} <label style="margin-left: 15px">Valor:</label> ${valor} <br/>
</g:if>
<g:if test="${proveedor}">
    <label>Proveedor:</label> ${proveedor} <br/>
    <label>Descripción:</label> ${desc} <label style="margin-left: 15px">Valor:</label> ${valor} <br/>
</g:if>


<label>Estado actual: </label> <span style="color: ${actual == 'R' ? '#58d05c' : (actual == 'C' ? '#ff983b' : actual == 'B' ? '#af1627' : '#9a53af')}">${actual == 'R' ? 'REVISADO' : (actual == 'C' ? 'CORREGIR VALOR' : actual == 'B' ? 'BORRAR' : ' -NINGUNO-')}</span>

<g:textArea name="comentario_name" id="comentarioIngreso" class="form-control" style="resize: none" maxlength="255" value="${comentario}"/>