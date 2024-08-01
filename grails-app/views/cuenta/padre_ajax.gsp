<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/09/17
  Time: 14:44
--%>

<g:select name="padre_name" id="nuevoPadre" from="${padres}" optionKey="abuelo" optionValue="${{it.ablonmro + " - " + it.ablodscr}}" class="form-control"/>