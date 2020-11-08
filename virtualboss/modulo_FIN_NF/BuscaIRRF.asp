<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim intCOD_NF, intCOD_CLI, strMES, strANO, strCOD_NFS
Dim dblAliqIRRF, dblTotalIRRF, dblAcumIRRF
Dim strCor

AbreDBConn objConn, CFG_DB 

intCOD_NF = GetParam("var_chavereg")
intCOD_CLI = GetParam("var_cod_cli")
strMES = GetParam("var_mes")
strANO = GetParam("var_ano")

if (intCOD_NF <> "") And (intCOD_CLI <> "") and (strMES <> "") and (strANO <> "") then
	dblAliqIRRF = 0
	
	strSQL = "SELECT ALIQ_IRRF FROM CFG_NF WHERE DT_INATIVO IS NULL "
	
	Set objRS = objConn.Execute(strSQL)
	if not objRS.eof then dblAliqIRRF = GetValue(objRS,"ALIQ_IRRF")
	FechaRecordSet objRS
	
	If (dblAliqIRRF = "") Or (Not IsNumeric(dblAliqIRRF)) Then 
		dblAliqIRRF = 0
	Else
		dblAliqIRRF = Replace(dblAliqIRRF, ".", "")
		dblAliqIRRF = Replace(dblAliqIRRF, ",", ".")
	End If
	
	
	strSQL =          " SELECT T1.COD_NF, T1.NUM_NF, T1.DT_EMISSAO, T1.SITUACAO "
	strSQL = strSQL & "      , SUM(T2.VALOR) AS TOT_SERVICO "
	strSQL = strSQL & "      , SUM((T2.VALOR * " & dblAliqIRRF & ")/100) AS TOT_IRRF "
	strSQL = strSQL & " FROM NF_NOTA T1 "
	strSQL = strSQL & " LEFT OUTER JOIN  NF_ITEM T2 ON (T1.COD_NF = T2.COD_NF) "
	strSQL = strSQL & " WHERE T1.COD_CLI = " & intCOD_CLI
	strSQL = strSQL & " AND Month(T1.DT_EMISSAO) = " & strMES
	strSQL = strSQL & " AND Year(T1.DT_EMISSAO) = " & strANO
	strSQL = strSQL & " AND ((T1.SITUACAO = 'EMITIDA') OR (T1.COD_NF = " & intCOD_NF & ")) "
	strSQL = strSQL & " AND T1.COD_NF_IRRF IS NULL "
	strSQL = strSQL & " GROUP BY T1.COD_NF, T1.NUM_NF, T1.DT_EMISSAO, T1.SITUACAO "
	
	'Response.Write(strSQL)
	'Response.End()
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.Eof then
%>
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<script>
function RetornaValor(prTotalIRRF, prAcumIRRF, prCodNFsIRRF) {
	window.opener.document.forms[0].var_vlr_IRRF.value = prTotalIRRF;
	window.opener.document.forms[0].var_vlr_IRRF_acum.value = prAcumIRRF;
	window.opener.document.forms[0].var_IRRF_acum.checked = true;
	window.opener.document.forms[0].var_cod_nfs_IRRF.value = prCodNFsIRRF;
	
	window.opener.Marcar();
	
	window.close();
}

</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table cellpadding="0" cellspacing="1" width="97%" align="center">
	<tr><td height="15" colspan="6"></td></tr>
	<tr bgcolor="#CCCCCC" bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC" class="arial11Bold">  
		<td width="10%"><div style="padding-left:3px; padding-right:3px;">Cod NF</div></td>
		<td width="10%"><div style="padding-left:3px; padding-right:3px;">Num NF</div></td>
		<td width="20%"><div style="padding-left:3px; padding-right:3px;">Dt Emissão</div></td>
		<td width="20%"><div style="padding-left:3px; padding-right:3px;">Situação</div></td>
		<td width="20%" align="right"><div style="padding-left:3px; padding-right:3px;">Total Serviços</div></td>
		<td width="20%" align="right"><div style="padding-left:3px; padding-right:3px;">Total IRRF</div></td>
	</tr>
	<%
		dblTotalIRRF = 0
		dblAcumIRRF = 0
		strCOD_NFS = ""
		
		do while not objRS.Eof
	%>
	<tr bgcolor="#DAEEFA" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';"> 
		<td valign="middle"nowrap><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"COD_NF")%>&nbsp;</div></td>
		<td valign="middle"nowrap><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"NUM_NF")%>&nbsp;</div></td>
		<td valign="middle"><div style="padding-left:3px; padding-right:3px;"><%=PrepData(GetValue(objRS,"DT_EMISSAO"), True, False)%>&nbsp;</div></td>
		<td valign="middle"><div style="padding-left:3px; padding-right:3px;">
		<%
		If GetValue(objRS,"SITUACAO") = "EM_EDICAO"   Then Response.Write("Em Edição")
		If GetValue(objRS,"SITUACAO") = "NAO_EMITIDA" Then Response.Write("Não Emitida")
		If GetValue(objRS,"SITUACAO") = "EMITIDA"     Then Response.Write("Emitida")
		If GetValue(objRS,"SITUACAO") = "CANCELADA"   Then Response.Write("Cancelada")
		%>&nbsp;</div></td>
		<td valign="middle" align="right"><div style="padding-left:3px; padding-right:3px;"><%=FormataDecimal(GetValue(objRS,"TOT_SERVICO"), 2)%>&nbsp;</div></td>
		<td valign="middle" align="right"><div style="padding-left:3px; padding-right:3px;"><%=FormataDecimal(GetValue(objRS,"TOT_IRRF"), 2)%>&nbsp;</div></td>
	</tr>
	<%
			If GetValue(objRS,"SITUACAO") <> "CANCELADA" Then
				If GetValue(objRS, "TOT_IRRF") <> "" Then
					dblTotalIRRF = dblTotalIRRF + CDbl("0" & GetValue(objRS, "TOT_IRRF"))
					If CStr(GetValue(objRS, "COD_NF")) <> CStr(intCOD_NF) Then dblAcumIRRF = dblAcumIRRF + CDbl("0" & GetValue(objRS, "TOT_IRRF"))
				End If
				strCOD_NFS = strCOD_NFS & "," & GetValue(objRS, "COD_NF")
			End If
			
			objRS.MoveNext
		loop
		
		if strCOD_NFS <> "" then strCOD_NFS = Mid(strCOD_NFS, 2)
		
		if dblAcumIRRF > 0 then
			%>
			<tr bgcolor="#E6E4E4" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';">
				<td align="center"></td>
				<td align="center"></td>
				<td align="center"></td>
				<td align="center"></td>
				<td align="right"><div style="padding-left:3px; padding-right:3px;">Total&nbsp;</div></td>
				<td align="right"><div style="padding-left:3px; padding-right:3px;"><%=FormataDecimal(dblTotalIRRF, 2)%>&nbsp;</div></td>
			</tr>
			<tr bgcolor="#FFFFFF" style="cursor:hand;"><td height="10" colspan="6"></td></tr>
			<tr bgcolor="#FFFFFF" style="cursor:hand;">
				<td align="right" colspan="6">Clique aqui para retornar TOTAL ao campo de IRRF da Nota Fiscal&nbsp;&nbsp;<a href="javascript:void(0);" onClick="javascript:RetornaValor('<%=FormataDecimal(dblTotalIRRF, 2)%>', '<%=FormataDecimal(dblAcumIRRF, 2)%>', '<%=strCOD_NFS%>');"><img src="../img/BtOk.gif" border="0" align="absmiddle" /></a>
				</td>
			</tr>
			<tr bgcolor="#FFFFFF" style="cursor:hand;"><td height="10" colspan="6"></td></tr>
			<%
		end if
%>
	<tr><td bgcolor="#CCCCCC" colspan="6" align="center" height="1"></td></tr>
</table>
<%
	else
		Mensagem "Não há outras notas emitidas para este mês.", "", "", True
	end if
	FechaRecordSet objRS
else
	Mensagem "Sem parâmetros para execução. Favor informar cliente e/ou data de emissão.", "", "", True
end if
%>
</body>
</html>
<% FechaDBConn objConn %>