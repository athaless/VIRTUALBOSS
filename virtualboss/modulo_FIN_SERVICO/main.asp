<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_SERVICO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL
 Dim strAviso
 Dim strSITUACAO, strPALAVRA_CHAVE
 Dim strCOD_CATEGORIA, strCOLOR

 strAviso = "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."

 strCOD_CATEGORIA	= GetParam("var_cod_categoria")
 strPALAVRA_CHAVE	= GetParam("var_palavra_chave")
 strSITUACAO		= GetParam("var_situacao")

 if strSITUACAO<>"" then
	AbreDBConn objConn, CFG_DB
	
	if strSITUACAO="INATIVO" then
		strSITUACAO = "NOT"
	else
		strSITUACAO = ""
	end if
	
	strSQL = "SELECT"						&_
			"	 T1.COD_SERVICO"			&_
			"	,T1.DESCRICAO"				&_
			"	,T2.NOME AS CATEGORIA"		&_
			"	,T1.TITULO"					&_
			"	,T1.OBS"					&_
			"	,T1.DT_INATIVO"				&_
			"	,T1.VALOR "					&_
			"	,T1.ALIQ_ISSQN "			&_
			"FROM"							&_
			"	SV_SERVICO T1 "				&_
			"INNER JOIN"					&_
			"	SV_CATEGORIA T2 ON (T1.COD_CATEGORIA=T2.COD_CATEGORIA) " &_
			"WHERE"							&_
			"	T1.DT_INATIVO IS " & strSITUACAO & " NULL " 
	
	if strPALAVRA_CHAVE<>"" then strSQL = strSQL & " AND (T1.DESCRICAO LIKE '%" & strPALAVRA_CHAVE & "%' OR T1.TITULO LIKE '%" & strPALAVRA_CHAVE & "%' OR T1.OBS LIKE '%" & strPALAVRA_CHAVE & "%') " 
	if strCOD_CATEGORIA <> "" then strSQL = strSQL & " AND T1.COD_CATEGORIA=" & strCOD_CATEGORIA
	
	strSQL = strSQL & "ORDER BY T1.TITULO "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
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
		<th width="1%" height="16px"></th>
		<th width="1%"></th>
		<th width="4%" class="sortable-numeric">Cod</th>
		<th width="32%" class="sortable">T&iacute;tulo</th>
		<th width="32%" class="sortable">Descri&ccedil;&atilde;o</th>
		<th width="8%" class="sortable">Categoria</th>
		<th width="8%" class="sortable-currency">Valor</th>
		<th width="8%" class="sortable-currency">ISSQN</th>
		<th width="6%" class="sortable-date-dmy" nowrap>Data Inativo</th>
	</tr>
   </thead>
 <tbody style="text-align:left;">
<%	
		While Not objRs.Eof
			strCOLOR = swapString(strCOLOR, "#F5FAFA", "#FFFFFF")
	%>
	<tr bgcolor="<%=strColor%>">
		<td><%=MontaLinkGrade("modulo_FIN_SERVICO","Delete.asp",GetValue(objRS,"COD_SERVICO"),"IconAction_DEL.gif","REMOVER")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_SERVICO","Update.asp",GetValue(objRS,"COD_SERVICO"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td nowrap><%=GetValue(objRS,"COD_SERVICO")%></td>
		<td><%=GetValue(objRS,"TITULO")%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>
		<td nowrap><%=GetValue(objRS,"CATEGORIA")%></td>
		<td align="right"><%=FormataDecimal(GetValue(objRS,"VALOR"),2)%></td>
		<td align="right"><%=FormataDecimal(GetValue(objRS,"ALIQ_ISSQN"),2)%></td>
		<td align="right"><%=PrepData(GetValue(objRS,"DT_INATIVO"), True, False)%></td>
	</tr>
	<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend
	%>
  </tbody>
</table>
</body>
</html>
<%
	FechaRecordSet objRS
	else
		Mensagem strAviso, "", "", true
	end if
else
	Mensagem strAviso, "", "", true
	FechaDBConn objConn
end if
%>