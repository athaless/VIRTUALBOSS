<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PEDIDO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
 	Dim objConn, objRS, strSQL, strSQLClause
 	Dim strSITUACAO, intCODIGO, strTITULO, strLOCAL, strBANDA
 	Dim strAviso, strCOLOR
	
 	strAviso = "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
	
	strSITUACAO = GetParam("var_situacao")
	intCODIGO   = GetParam("var_codigo")
	strBANDA    = GetParam("var_banda")
	strTITULO   = GetParam("var_titulo")
	strLOCAL	= GetParam("var_local")
	
 	AbreDBConn objConn, CFG_DB 
	
 	strSQL =          " SELECT T1.COD_NF, T1.COD_CLI AS CODIGO, T1.TIPO, T1.SITUACAO, T1.TOT_SERVICO, T1.DT_EMISSAO "
	strSQL = strSQL & "      , T2.RAZAO_SOCIAL AS CLI_NOME "
	'strSQL = strSQL & "      , T3.RAZAO_SOCIAL AS FORNEC_NOME "
	'strSQL = strSQL & "      , T4.NOME AS COLAB_NOME "
	strSQL = strSQL & " FROM NF_NOTA T1 "
	strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T2 ON (T1.COD_CLI = T2.COD_CLIENTE AND T1.TIPO LIKE 'ENT_CLIENTE') " 
	'strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T3 ON (T1.CODIGO = T3.COD_FORNECEDOR AND T1.TIPO LIKE 'ENT_FORNECEDOR') " 
	'strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO = T4.COD_COLABORADOR AND T1.TIPO LIKE 'ENT_COLABORADOR') " 
	strSQL = strSQL & " WHERE T1.SYS_DTT_INATIVO IS NULL "
	
 	if strSITUACAO = "ABERTO"   then strSQL = strSQL & " AND T1.SITUACAO LIKE 'ABERTO' " 
 	if strSITUACAO = "FATURADO" then strSQL = strSQL & " AND T1.SITUACAO LIKE 'FATURADO' "
	
 	strSQL = strSQL & " ORDER BY T2.RAZAO_SOCIAL "
	
 	'athDebug strSQL, false
 	Set objRs = objConn.Execute(strSql) 
 	If Not objRS.EOF Then
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
<table align="center" cellpadding="0" cellspacing="1" class="tablesort">
	<!-- 
		Possibilidades de tipo de sort...
		class="sortable-date-dmy"
		class="sortable-currency"
		class="sortable-numeric"
		class="sortable"
	-->
	<thead>
  		<tr> 
    		<th width="01%"></td><!-- DEL -->
    		<th width="01%"></td><!-- UPD -->
    		<th width="01%"></td><!-- VIE -->
			<th width="01%"></td>
    		<th width="66%" class="sortable">Entidade</th>
			<th width="15%" class="sortable-date-dmy">Dt Emissão</th>
			<th width="15%" class="sortable-numeric">Total</th>
  		</tr>
  	</thead>
 	<tbody style="text-align:left;">
	<% 
	While Not objRs.Eof
		strCOLOR = swapString(strCOLOR,"#FFFFFF","#F5FAFA")
		%>
		<tr bgcolor="<%=strColor%>">
			<td><%
			If GetValue(objRS,"SITUACAO") = "ABERTO" Then
				Response.Write(MontaLinkGrade("modulo_PEDIDO","Delete.asp",GetValue(objRS,"COD_NF"),"IconAction_DEL.gif","REMOVER"))
			End If
			%></td>
			<td><%=MontaLinkGrade("modulo_PEDIDO","Update.asp",GetValue(objRS,"COD_NF"),"IconAction_EDIT.gif","ALTERAR")%></td>
			<td><%=MontaLinkGrade("modulo_PEDIDO","Detail.asp",GetValue(objRS,"COD_NF"),"IconAction_DETAILadd.gif","INSERIR ITEM")%></td>
			<td><%
			If GetValue(objRS,"SITUACAO") = "ABERTO" Then
				Response.Write(MontaLinkGrade("modulo_PEDIDO","Fatura.asp",GetValue(objRS,"COD_NF"),"IconAction_GERACP.gif","FATURAR"))
			End If
			%></td>
			<td style="text-align:left"><%
			'If GetValue(objRS,"TIPO") = "ENT_CLIENTE" Then 
			Response.Write(GetValue(objRS,"CLI_NOME"))
			'If GetValue(objRS,"TIPO") = "ENT_FORNECEDOR" Then Response.Write(GetValue(objRS,"FORNEC_NOME"))
			'If GetValue(objRS,"TIPO") = "ENT_COLABORADOR" Then Response.Write(GetValue(objRS,"COLAB_NOME"))
			%></td>
			<td style="text-align:right"><%=PrepData(GetValue(objRS,"DT_EMISSAO"), True, False)%></td>
			<td style="text-align:right"><%=FormataDecimal(GetValue(objRS,"TOT_SERVICO"),2)%></td>
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
