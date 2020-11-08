<%
If VerificaDireito("|VIEW|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), False) Then
	Dim strCOLOR, strFilePath, strDIAS, strDtFim, bRenova
	
	strDIAS = 10 'Buscar inclusive contratos vencidos até X dias atrás

	strSQL =          " SELECT T1.COD_CONTRATO, T1.CODIFICACAO, T1.TITULO, T1.DT_INI, T1.DT_FIM, T1.DT_ASSINATURA "
	strSQL = strSQL & "      , T1.SITUACAO, T1.DOC_CONTRATO, T1.DTT_PROX_REAJUSTE, T1.TP_RENOVACAO, T1.TIPO "
    strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLIENTE "
    strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNECEDOR "
    strSQL = strSQL & "      , T4.NOME AS COLABORADOR "
	strSQL = strSQL & " FROM CONTRATO T1 "
    strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE     T2 ON (T1.CODIGO      = T2.COD_CLIENTE    ) "
    strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR  T3 ON (T1.CODIGO      = T3.COD_FORNECEDOR ) "
    strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO      = T4.COD_COLABORADOR) "
    strSQL = strSQL & " WHERE T1.CODIGO = T1.CODIGO "
	strSQL = strSQL & " AND ( "
	strSQL = strSQL & "      (T1.SITUACAO = 'FATURADO' AND T1.DT_INATIVO IS NULL AND (T1.TP_RENOVACAO = 'RENOVAVEL' OR (T1.DTT_PROX_REAJUSTE IS NOT NULL AND CURRENT_DATE >=T1.DTT_PROX_REAJUSTE)) AND T1.DT_FIM <= DATE_ADD(CURDATE(), INTERVAL " & strDIAS & " DAY)) "
	strSQL = strSQL & "       OR "
	strSQL = strSQL & "      (T1.SITUACAO = 'ABERTO' AND T1.DT_INATIVO IS NULL) "
	strSQL = strSQL & "     ) "
	strSQL = strSQL & " ORDER BY T1.TITULO "
	
	'athDebug strSQL, false
	
	Set objRs = objConn.Execute(strSql) 
	If Not objRS.EOF Then
%><table width="100%" cellpadding="1" cellspacing="0" border="0" style="margin-bottom:10px;">
<tr>
	<td width="100%" height="30%">
	<!-- Moldura INIC -->
	<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>">
	<tr>
		<td style="border-bottom:1px solid <%=strBGCOLOR1%>" colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_CONTRATO/default.htm" target="vbNucleo">Contratos</a></b></div></td>
				<td align="right" width="99%" style="text-align:right">Contratos não faturados ou renovações pendentes até o dia <%=PrepData(DateAdd("D", strDIAS, Date), True, False)%>&nbsp;&nbsp;</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" bgcolor="<%=strBGCOLOR2%>">
		<div style="padding-top:4px; padding-bottom:4px;">
<!-- ----------------------------------- -->
<table width='100%' height='20' bgcolor='#FFFFFF' cellpadding='2' cellspacing='1' border='0'>
<tr bgcolor='#EFEDED' class='arial11' valign='middle'>
	<td width='16'></td>
	<td width='16'></td>
	<td width='16'></td>	
	<td width='16'></td>		
	<td width='16'>Cod</td>		
	<td width='310' style="text-align:left">Entidade</td>
	<td style="text-align:left">Título</td>
	<td width='124' style="text-align:left">Codificação</td>
	<td width='70' style="text-align:left">Dt Início</td>
	<td width='70' style="text-align:left">Dt Fim</td>
</tr>
<tr><td colspan='10' height='1' bgcolor='#C9C9C9'></td></tr>
<%
		While Not objRs.Eof
			strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
%>
<tr class='arial11' valign='middle' bgcolor='<%=strCOLOR%>'>
	<td title="VISUALIZAR" alt="VISUALIZAR"><%=MontaLinkPopup("modulo_CONTRATO","Detail.asp",GetValue(objRS,"COD_CONTRATO"),"IconAction_DETAIL.gif","VISUALIZAR", "1100", "600", "yes")%></td>	
    <!-- Renovação de contrato fica disponível 20 dias antes do término do contrato. By Lumertz 14/12/2012 //-->	
	<td title="RENOVAR" alt="RENOVAR"><%	bRenova = False
	       	strDtFim = GetValue(objRS, "DT_FIM")
	       	If StrDtFim <> "" Then  
		   		strDtFim = DateAdd("D",-20, strDtFim) 
				bRenova = (Now>=strDtFim)
	    	End If
			If (GetValue(objRS, "SITUACAO") = "FATURADO" Or GetValue(objRS, "SITUACAO") = "AVULSO") And (GetValue(objRS, "TP_RENOVACAO") = "RENOVAVEL") And (bRenova) Then Response.Write(MontaLinkGrade("modulo_CONTRATO","Pre_Renova.asp",GetValue(objRS, "COD_CONTRATO"),"IconAction_CONTRATO_RENOVA.gif","RENOVAR")) End If 
		%>
	</td> 
	
	<td title="PROCESSAR" alt="PROCESSAR"><% If GetValue(objRS,"SITUACAO") = "ABERTO" Then Response.Write(MontaLinkGrade("modulo_CONTRATO","Processa.asp",GetValue(objRS,"COD_CONTRATO"),"IconAction_CONTRATO_PROCESSA.gif","PROCESSAR")) End If %></td>
	<td title="REAJUSTAR" alt="REAJUSTAR"><% If ((GetValue(objRS,"SITUACAO") = "FATURADO") and (Now() >= GetValue(objRS,"DTT_PROX_REAJUSTE"))) Then Response.Write(MontaLinkGrade("modulo_CONTRATO","Reajusta.asp",GetValue(objRS,"COD_CONTRATO"),"IconAction_CONTRATO_REAJUSTA.gif","REAJUSTAR")) End If %></td>		
	<td valign='top' style="text-align:left"><%=GetValue(objRS,"COD_CONTRATO")%></td>
	<td valign='top' style="text-align:left" alt="<%=GetValue(objRS,"TIPO")%>" title="<%=GetValue(objRS,"TIPO")%>" >
	<%
		If GetValue(objRS,"TIPO") = "ENT_CLIENTE"     Then Response.Write(GetValue(objRS, "CLIENTE"))     
		If GetValue(objRS,"TIPO") = "ENT_FORNECEDOR"  Then Response.Write(GetValue(objRS, "FORNECEDOR"))
		If GetValue(objRS,"TIPO") = "ENT_COLABORADOR" Then Response.Write(GetValue(objRS, "COLABORADOR"))
	%></td>
	<td valign='top' style="text-align:left"><%=GetValue(objRS,"TITULO")%></td>
	<td valign='top' style="text-align:left"><%=GetValue(objRS,"CODIFICACAO")%></td>
	<td valign='top' style="text-align:left"><%=PrepData(GetValue(objRS, "DT_INI"), True, False)%></td>
	<td valign='top' style="text-align:left"><%=PrepData(GetValue(objRS, "DT_FIM"), True, False)%></td>
</tr>
<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		WEnd
%>
</table>
<!-- ----------------------------------- -->
		</div>
		</td>
	</tr>
	</table>
	</td>
</tr>
</table><%
	End If
	FechaRecordSet objRS
End If
%>