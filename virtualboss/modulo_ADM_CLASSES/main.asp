<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ADM_CLASSES", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<%
 Dim objConn, objRS, strSQL, strSQLClause
 Dim strSITUACAO
 Dim strAviso, strCOLOR

 strAviso 	= "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."

 AbreDBConn objConn, CFG_DB 
 
 strSITUACAO = GetParam("var_situacao")
 
 strSQL =          " SELECT COD_CLASSE, ID_CLASSE, DESCRICAO, PESO_MIN, PESO_MAX, PONTOS "
 strSQL = strSQL & " FROM adm_classe "
 strSQL = strSQL & " WHERE TRUE " 
 
 strSQLClause = ""
 if strSITUACAO = "INATIVO"  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"    then strSQLClause = strSQLClause & " AND DT_INATIVO IS NULL "
 
 if (strSQLClause <> "") then strSql = strSql & strSQLClause 
 
 strSql = strSql & " ORDER BY ID_CLASSE "
 
 'athDebug strSQL, false
 Set objRs = objConn.Execute(strSql) 
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
    <th width="01%"></td>
    <th width="01%"></td>
    <th width="01%"></td>
    <th width="12%" class="sortable-numeric">ID Classe</th>
    <th width="12%" class="sortable-numeric">Peso Min</th>
    <th width="12%" class="sortable-numeric">Peso Max</th>
	<th width="10%" class="sortable-numeric">Pontos</th>
	<th width="51%" class="sortable">Descrição</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<% 
	While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		%>
	<tr bgcolor="<%=strColor%>">
		<td><%=MontaLinkGrade("modulo_ADM_CLASSES","Delete.asp",GetValue(objRS,"COD_CLASSE"),"IconAction_DEL.gif","REMOVER")%></td>
		<td><%=MontaLinkGrade("modulo_ADM_CLASSES","Update.asp",GetValue(objRS,"COD_CLASSE"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td><%=MontaLinkGrade("modulo_ADM_CLASSES","Detail.asp",GetValue(objRS,"COD_CLASSE"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
		<td style="text-align:right"><%=GetValue(objRS,"ID_CLASSE")%></td>
		<td style="text-align:right"><%=GetValue(objRS,"PESO_MIN")%></td>
		<td style="text-align:right"><%=GetValue(objRS,"PESO_MAX")%></td>
		<td style="text-align:right"><%=GetValue(objRS,"PONTOS")%></td>
		<td style="text-align:left"><%=GetValue(objRS,"DESCRICAO")%></td>
	</tr>
		<%
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	WEnd
%>
 </tbody>
</table>
</body>
</html>
<%
 else
    Mensagem strAviso, "", "", true
 end if
 FechaRecordSet objRS
 FechaDBConn objConn
%>
