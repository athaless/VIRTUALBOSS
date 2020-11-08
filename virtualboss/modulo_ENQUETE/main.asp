<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ENQUETE", Request.Cookies("VBOSS")("ID_USUARIO")), true

 Dim objConn, objRS, strSQL, strSQLClause, auxStr
 Dim strTITULO
 Dim strUSER_ID, strCOLOR, auxCONTADOR

 AbreDBConn objConn, CFG_DB 

 strTITULO    = GetParam("var_titulo")
 auxCONTADOR  = 0

 strSql =          " SELECT  DISTINCT ENQUE.COD_ENQUETE, ENQUE.TITULO ,ENQUE.DT_INI, ENQUE.DT_FIM, EN_QUESTAO.COD_ENQUETE AS questao, "
 strSql = strSql & " (SELECT COUNT(*) FROM en_log WHERE COD_ENQUETE = ENQUE.COD_ENQUETE) AS VOTOS "
 strSql = strSql & " FROM EN_ENQUETE AS ENQUE "
 strSql = strSql & " LEFT JOIN EN_QUESTAO ON  ENQUE.COD_ENQUETE = EN_QUESTAO.COD_ENQUETE " 
 
 
 strSQLClause = ""
 if strTITULO <> ""            then strSQLClause = strSQLClause & " WHERE EN_ENQUETE.TITULO LIKE '%" & strTITULO & "%'"
' if strNUMDOC <> ""          then strSQLClause = strSQLClause & " AND (ENT_COLABORADOR.RG LIKE '%" & strNUMDOC & "%' or " & "ENT_COLABORADOR.CPF LIKE '%" & strNUMDOC & "%') "
' if strSITUACAO = "INATIVO"  then strSQLClause = strSQLClause & " AND ENT_COLABORADOR.DT_INATIVO IS NOT NULL " 
' if strSITUACAO = "ATIVO"    then strSQLClause = strSQLClause & " AND ENT_COLABORADOR.DT_INATIVO IS NULL "
 
 
 
 if (strSQLClause <> "") then strSql = strSql & strSQLClause 
 
 strSql = strSql & " ORDER BY DT_INI "
 'response.write(strSQL)	
 
 
 Set objRS = objConn.Execute(strSql) 
 If Not objRS.EOF Then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr> 
    <th width="1%"></th>
    <th width="1%"></th>
	<th width="1%"></th>
    <th width="1%"></th>
	<th width="1%"  class="sortable-numeric" nowrap>Cod</th>
    <th width="93%" class="sortable">Título</th>
	<th width="1%"  class="sortable-date-dmy">Inicio</th>
    <th width="1%"  class="sortable-date-dmy">Fim</th>	
    <th width="1%"  class="sortable-date-dmy">VT</th>	
    <th width="1%"></th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRS.Eof
	  	strCOLOR = swapString (strCOLOR, "#FFFFFF", "#F5FAFA")
	%>
  <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%">
			<% If (GetValue(objRS,"questao") = "") Then
			      MontaLinkGrade "modulo_ENQUETE","Delete.asp",GetValue(objRS,"COD_ENQUETE"),"IconAction_DEL.gif","REMOVER"
			   End If
			%>
    </td>
	<td width="1%"><%=MontaLinkGrade("modulo_ENQUETE","Update.asp",GetValue(objRS,"COD_ENQUETE"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_ENQUETE","DetailQuestao.asp",GetValue(objRS,"COD_ENQUETE"),"IconAction_DETAILadd.gif","VISUALIZAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_ENQUETE","InsertCopiaEnquete.asp",GetValue(objRS,"COD_ENQUETE"),"IconAction_COPY.gif","COPIAR")%></td>
	<td style="text-align:right" nowrap><%=getValue(objRS,"COD_ENQUETE")%></td>
	<td><%=GetValue(objRS,"TITULO")%></td>
    <td nowrap><%=GetValue(objRS,"DT_INI")%></td>
    <td nowrap><%=GetValue(objRS,"DT_FIM")%></td>
    <td nowrap><%=GetValue(objRS,"VOTOS")%></td>
    	<td width="1%"><%=MontaLinkPopup("modulo_ENQUETE","enquete_result.asp",GetValue(objRS,"COD_ENQUETE")&"&var_tpshow=TUDO","IconAction_QUICK_CLOSE.gif","VISUALIZAR RESULTADO", "500", "640", "yes")%></td>        
  </tr>
  <%
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
      Wend
%>
  </tbody>
</table>
</body>
</html>
<%
   FechaRecordSet objRS
 else
   Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 FechaDBConn objConn
%>