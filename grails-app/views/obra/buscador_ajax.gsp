<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 11/04/18
  Time: 11:44
--%>

<g:if test="${tipo == '4'}">
    <g:textField name="criterio_name" style="margin-right: 10px; width: 150%; border-color: #53a7ff" value="${params.criterio}"
                 id="criterio" class="form-control"/>
</g:if>
<g:else>
    <g:select from="${lista}" name="combo_name" id="combo" class="form-control" optionValue="value" optionKey="key" style="margin-right: 10px; width: 150%;" noSelection="${[0: 'Seleccione...']}"/>
</g:else>
