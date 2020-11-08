<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ENQUETE", Request.Cookies("VBOSS")("ID_USUARIO")), true

 Dim objConn, objRS, strSQL, strSQLClause, auxStr
 Dim strTITULO, strENQUETE
 Dim strUSER_ID, strCOLOR, auxCONTADOR

 AbreDBConn objConn, CFG_DB 

 strTITULO    = GetParam("var_titulo")
 STRenquete   = gETpARAM("var_enquete")
 auxCONTADOR  = 0

 strSql =          " SELECT DISTINCT EN_QUESTAO.COD_QUESTAO, EN_QUESTAO.QUESTAO, EN_ENQUETE.COD_ENQUETE as ENQUE "
 strSql = strSql & " FROM EN_QUESTAO  "
 strSql = strSql & " LEFT JOIN EN_ENQUETE ON  EN_ENQUETE.COD_ENQUETE = EN_QUESTAO.COD_ENQUETE "  
 strSql = strSql & " WHERE EN_QUESTAO.COD_QUESTAO >0 "  
 strSQLClause = ""
 if strENQUETE <> ""           then strSQLClause = strSQLClause & " AND EN_QUESTAO.COD_ENQUETE = " & strENQUETE & " " 
 if strTITULO <> ""            then strSQLClause = strSQLClause & " AND EN_QUESTAO.QUESTAO LIKE '%" & strTITULO & "%'"
' if strSITUACAO = "INATIVO"  then strSQLClause = strSQLClause & " AND ENT_COLABORADOR.DT_INATIVO IS NOT NULL " 
' if strSITUACAO = "ATIVO"    then strSQLClause = strSQLClause & " AND ENT_COLABORADOR.DT_INATIVO IS NULL "
 
 
 
 if (strSQLClause <> "") then strSql = strSql & strSQLClause 
 
 strSql = strSql & " ORDER BY EN_QUESTAO.ORDEM "
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
    <th width="97%" class="sortable">Questão</th>
	
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRS.Eof
	  	strCOLOR = swapString (strCOLOR, "#FFFFFF", "#F5FAFA")
	%>
  <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%">
			<% If (GetValue(objRS,"ENQUE") = "") Then
			      MontaLinkGrade "modulo_ENQUETE","Delete.asp",GetValue(objRS,"COD_QUESTAO"),"IconAction_DEL.gif","REMOVER"
			   End If
			%>
    </td>
	<td width="1%"><%=MontaLinkGrade("modulo_ENQUETE_QUESTAO","Update.asp",GetValue(objRS,"COD_QUESTAO"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_ENQUETE_QUESTAO","DetailQuestao.asp",GetValue(objRS,"COD_QUESTAO"),"IconAction_DETAILadd.gif","VISUALIZAR")%></td>
    <td style="text-align:left;" nowrap><%=MontaLinkGrade("modulo_ENQUETE_QUESTAO","InsertCopiaQuestao.asp",GetValue(objRS,"COD_QUESTAO"),"IconAction_COPY.gif","COPIA QUESTÃO")%></td>
    <!--td width="1%"><a style="cursor:pointer;" onClick="JavaScript: window.open('enquete_result.asp?var_chavereg=<%=GetValue(objRS,"COD_ENQUETE")%>','','popup,width=500,height=640'); return false;" title="Resultado"><img src='../img/Icon_BOLETO.gif' border='0'></a></td/-->
	<td style="text-align:right" nowrap><%=getValue(objRS,"COD_QUESTAO")%></td>
	<td><%=GetValue(objRS,"QUESTAO")%></td>
   
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