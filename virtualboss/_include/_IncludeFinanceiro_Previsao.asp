<table width="100%" height="100%" border="1" bordercolor="#C9C9C9" cellpadding="0" cellspacing="2">
<tr valign="top">
	<td width="100%">
		<!-- corpo INIC -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr> 
			<td height="22" background="../img/BgBoxTit.gif" style="color:#3C6BC0;">
			    <div style="padding-left:10px"><b>Previsão para os próximos 90 dias</b></div>
			</td>
		</tr>
		<tr> 
			<td valign="top">
				<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
				<tr valign="top"> 
					<td height="1%" width="100%">

		<table border="0" width="100%" height="100%" cellpadding="2" cellspacing="2">
	<%
	'-------------------------------------------------
	' Consulta as contas em aberto que já venceram
	'-------------------------------------------------
	strSQL =          " SELECT T1.COD_CONTA_PAGAR_RECEBER AS CODIGO, T1.TIPO, T1.CODIGO AS CODIGO_ENTIDADE "
	strSQL = strSQL & "      , T1.HISTORICO, T1.DT_VCTO, T1.VLR_CONTA " 
	strSQL = strSQL & "      , DATEDIFF(CURDATE(),T1.DT_VCTO) AS NUM_DIAS "
	strSQL = strSQL & "      , T1.PAGAR_RECEBER, T2.NOME AS CONTA "
	strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER AS T1, FIN_CONTA AS T2 "
	strSQL = strSQL & " WHERE T1.COD_CONTA = T2.COD_CONTA "
	strSQL = strSQL & " AND T1.DT_VCTO < CURDATE() "
	strSQL = strSQL & " AND (T1.SITUACAO LIKE 'ABERTA' OR T1.SITUACAO LIKE 'LCTO_PARCIAL') "
	strSQL = strSQL & " ORDER BY T1.DT_VCTO "
	
	'athdebug strSQL,true
	
	Set objRS1 = objConn.Execute(strSQL) 
	
	If Not objRS1.Eof Then 
		%>
			<tr bgcolor="<%=strGRADE_CORHEADER2%>">
				<td colspan="8" align="left">&nbsp;<strong>JÁ VENCIDAS</strong></div></td>
			</tr>
			<tr bgcolor="<%=strGRADE_CORLINHA1%>">
				<td align="left"><strong>Dt Vcto</strong></td>
				<td align="left"><strong>Conta</strong></td>
				<td align="left"><strong>Entidade</strong></td>
				<td align="left"><strong>Cód.</strong></td>
				<td align="left"><strong>Nome</strong></td>
				<td style="text-align: right;"><strong>Valor</strong></td>
				<td style="text-align: right;" nowrap><strong>Atraso de</strong></td>
				<td align="center"><strong>Tipo</strong></td>
			</tr>
		<%
		acPAGAR   = 0
		acRECEBER = 0
		strBGCOLOR = strGRADE_CORLINHA2
		Do While Not objRS1.Eof 
			strSQL = ""
			if GetValue(objRS1, "TIPO")="ENT_CLIENTE"	  and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE	WHERE COD_CLIENTE = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			if GetValue(objRS1, "TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			if GetValue(objRS1, "TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME FROM ENT_COLABORADOR WHERE COD_COLABORADOR = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			
			strENTIDADE = ""
			If strSQL <> "" Then 
				Set objRS2 = objConn.Execute(strSQL)
				If Not objRS2.Eof Then strENTIDADE = mid(GetValue(objRS2, "NOME"),1,25)				
			End If 
			
			If GetValue(objRS1, "PAGAR_RECEBER") = "0" Then 
				strICONE = "<img src='../img/icon_FinContaReceber.gif' alt='Conta a Receber'>"
			Else
				strICONE = "<img src='../img/icon_FinContaPagar.gif' alt='Conta a Pagar'>"
			End If

			If GetValue(objRS1, "PAGAR_RECEBER") = "1" Then 
				acPAGAR   = acPAGAR + GetValue(objRS1,"VLR_CONTA")
			Else
				acRECEBER = acRECEBER + GetValue(objRS1,"VLR_CONTA")
			End If
			
			%>
			<tr bgcolor="<%=strBGCOLOR%>">
				<td width="9%"  align="left" nowrap><div style="padding-left:10px; padding-right:4px;"><%=PrepData(GetValue(objRS1,"DT_VCTO"),True,False)%></div></td>
				<td width="25%" align="left" nowrap><div style="padding-left:4px; padding-right:4px;"><%=mid(GetValue(objRS1,"CONTA"),1,15)%></div></td>
				<td width="5%"  align="left" nowrap><%=Replace(GetValue(objRS1,"TIPO"),"ENT_","")%></td>
				<td width="5%"  align="left" nowrap><%=GetValue(objRS1,"CODIGO_ENTIDADE")%></td>
				<td width="25%" align="left" title="<%=GetValue(objRS2,"NOME")%>" nowrap><div style="cursor:default; padding-left:4px; padding-right:4px;"><%=strENTIDADE%></div></td>
				<td width="15%" style="text-align: right;"><div style="padding-left:4px; padding-right:4px;"><%=FormataDecimal(GetValue(objRS1,"VLR_CONTA"),2)%></div></td>
				<td width="15%" style="text-align: right;" nowrap><div style="padding-left:4px; padding-right:4px;"><%=Response.Write(GetValue(objRS1,"NUM_DIAS") & " dia(s)")%></div></td>
				<td width="1%"  align="center"><div style="padding-left:4px; padding-right:4px;"><%=strICONE%></div></td>
			</tr>
			<%
			FechaRecordSet objRS2			
			objRS1.MoveNext
			
			If strBGCOLOR = strGRADE_CORLINHA2 Then
				strBGCOLOR = strGRADE_CORLINHA1
			Else
				strBGCOLOR = strGRADE_CORLINHA2
			End If
		Loop
		%>
			<tr><td colspan="8" height="20"></td></tr>
			<tr style="border-bottom:1px solid #333;">
				<td colspan="5"></td>
				<td style="text-align:right; background-color:#CCCCCC">PAGAR</td>
				<td style="text-align:right; background-color:#CCCCCC">RECEBER</td>
				<td></td>
			</tr>
			<tr>
				<td colspan="5" align="right" nowrap></td>
				<td style="text-align:right; background-color:#CCCCCC"><%=FormataDecimal(acPAGAR,2)%></td>
				<td style="text-align:right; background-color:#CCCCCC"><%=FormataDecimal(acRECEBER,2)%></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="5" style="text-align:right;"></td>
				<td colspan="2" style="text-align:right; border-top:1px solid #000;  background-color:#CCCCCC">SALDO:&nbsp;<strong><%=FormataDecimal(acRECEBER-acPAGAR,2)%></strong></td>
				<td></td>
			</tr>

			<tr><td colspan="8" height="20"></td></tr>
		<%
	End If 
	
	FechaRecordSet objRS1
	
	'------------------------------------------------
	' Consulta as contas em aberto que vencem hoje
	'------------------------------------------------
	strSQL =          " SELECT T1.COD_CONTA_PAGAR_RECEBER AS CODIGO, T1.TIPO, T1.CODIGO AS CODIGO_ENTIDADE "
	strSQL = strSQL & "      , T1.HISTORICO, T1.DT_VCTO, T1.VLR_CONTA "
	strSQL = strSQL & "      , T1.PAGAR_RECEBER, T2.NOME AS CONTA "
	strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER AS T1, FIN_CONTA AS T2 "
	strSQL = strSQL & " WHERE T1.COD_CONTA = T2.COD_CONTA "
	strSQL = strSQL & " AND T1.DT_VCTO = CURDATE() "
	strSQL = strSQL & " AND (T1.SITUACAO LIKE 'ABERTA' OR T1.SITUACAO LIKE 'LCTO_PARCIAL') "
	strSQL = strSQL & " ORDER BY T1.DT_VCTO "
	
	Set objRS1 = objConn.Execute(strSQL) 
	
	If Not objRS1.Eof Then 
		%>
			<tr bgcolor="<%=strGRADE_CORHEADER2%>">
				<td colspan="8" align="left">&nbsp;VENCEM <strong>HOJE</strong></td>
			</tr>
			<tr bgcolor="<%=strGRADE_CORLINHA1%>">
				<td align="left"><strong>Dt Vcto</strong></div></td>
				<td align="left"><strong>Conta</strong></td>
				<td align="left"><strong>Entidade</strong></td>
				<td align="left"><strong>Cód.</strong></td>
				<td align="left"><strong>Nome</strong></td>
				<td style="text-align: right;"><strong>Valor</strong></td>
				<td align="left" nowrap><strong></strong></td>
				<td align="center"><strong>Tipo</strong></td>
			</tr>
		<%
		acPAGAR   = 0
		acRECEBER = 0
		strBGCOLOR = strGRADE_CORLINHA2
		Do While Not objRS1.Eof 
			strSQL = ""
			if GetValue(objRS1, "TIPO")="ENT_CLIENTE"	  and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE		WHERE COD_CLIENTE = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			if GetValue(objRS1, "TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			if GetValue(objRS1, "TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME FROM ENT_COLABORADOR WHERE COD_COLABORADOR = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			
			strENTIDADE = ""
			If strSQL <> "" Then 
				Set objRS2 = objConn.Execute(strSQL)
				If Not objRS2.Eof Then strENTIDADE = mid(GetValue(objRS2,"NOME"),1,25)
			End If 
			
			If GetValue(objRS1, "PAGAR_RECEBER") = "0" Then 
				strICONE = "<img src='../img/icon_FinContaReceber.gif' alt='Conta a Receber'>"
			Else
				strICONE = "<img src='../img/icon_FinContaPagar.gif' alt='Conta a Pagar'>"
			End If

			If GetValue(objRS1, "PAGAR_RECEBER") = "1" Then 
				acPAGAR   = acPAGAR + GetValue(objRS1,"VLR_CONTA")
			Else
				acRECEBER = acRECEBER + GetValue(objRS1,"VLR_CONTA")
			End If
			%>
			<tr bgcolor="<%=strBGCOLOR%>">
				<td width="9%" align="left" nowrap><%=PrepData(GetValue(objRS1, "DT_VCTO"), True, False)%></td>
				<td width="25%" align="left" nowrap><%=mid(GetValue(objRS1,"CONTA"),1,15)%></td>
				<td width="5%"  align="left" nowrap><%=Replace(GetValue(objRS1,"TIPO"),"ENT_","")%></td>
				<td width="5%"  align="left" nowrap><%=GetValue(objRS1,"CODIGO_ENTIDADE")%></td>
				<td width="25%" align="left" title="<%=GetValue(objRS2,"NOME")%>" nowrap><%=strENTIDADE%></td>
				<td width="15%" style="text-align: right;"><%=FormataDecimal(GetValue(objRS1, "VLR_CONTA"), 2)%></td>
				<td width="15%" style="text-align: right;" nowrap></td>
				<td width="1%" align="center"><%=strICONE%></td>
			</tr>
			<%				
			FechaRecordSet objRS2			
			objRS1.MoveNext
			
			If strBGCOLOR = strGRADE_CORLINHA2 Then
				strBGCOLOR = strGRADE_CORLINHA1
			Else
				strBGCOLOR = strGRADE_CORLINHA2
			End If
		Loop
		%>
			<tr><td colspan="8" height="5"></td></tr>
			<tr style="border-bottom:1px solid #333;">
				<td colspan="5"></td>
				<td style="text-align:right; background-color:#CCCCCC">PAGAR</td>
				<td style="text-align:right; background-color:#CCCCCC">RECEBER</td>
				<td></td>
			</tr>
			<tr>
				<td colspan="5" align="right" nowrap></td>
				<td style="text-align:right; background-color:#CCCCCC"><%=FormataDecimal(acPAGAR,2)%></td>
				<td style="text-align:right; background-color:#CCCCCC"><%=FormataDecimal(acRECEBER,2)%></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="5" style="text-align:right;"></td>
				<td colspan="2" style="text-align:right; border:1px solid #000;  background-color:#CCCCCC">SALDO:&nbsp;<strong><%=FormataDecimal(acRECEBER-acPAGAR,2)%></strong></td>
				<td></td>
			</tr>

			<tr><td colspan="8" height="20"></td></tr>
		<%
	End If 
	
	FechaRecordSet objRS1
	
	'--------------------------------------------------------------
	' Consulta as contas em aberto que vencem a partir de amanhã
	'--------------------------------------------------------------
	strSQL =          " SELECT T1.COD_CONTA_PAGAR_RECEBER AS CODIGO, T1.TIPO, T1.CODIGO AS CODIGO_ENTIDADE "
	strSQL = strSQL & "      , T1.HISTORICO, T1.DT_VCTO, T1.VLR_CONTA" 
	strSQL = strSQL & "      , DATEDIFF(CURDATE(),T1.DT_VCTO) AS NUM_DIAS "
	strSQL = strSQL & "      , T1.PAGAR_RECEBER, T2.NOME AS CONTA "
	strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER AS T1, FIN_CONTA AS T2 "
	strSQL = strSQL & " WHERE T1.COD_CONTA = T2.COD_CONTA "
	strSQL = strSQL & " AND T1.DT_VCTO BETWEEN '" & PrepDataBrToUni(DateAdd("D", 1, Date), False) & "' AND '" & PrepDataBrToUni(DateAdd("D", 90, Date), False) & "' "
	strSQL = strSQL & " AND (T1.SITUACAO LIKE 'ABERTA' OR T1.SITUACAO LIKE 'LCTO_PARCIAL') "
	strSQL = strSQL & " ORDER BY T1.DT_VCTO "
	
	Set objRS1 = objConn.Execute(strSQL) 
	
	If Not objRS1.Eof Then 
		%>
			<tr bgcolor="<%=strGRADE_CORHEADER2%>">
				<td colspan="8" align="left">&nbsp;<strong>VENCEM NOS PRÓXIMOS DIAS</strong></td>
			</tr>
			<tr bgcolor="<%=strGRADE_CORLINHA1%>">
				<td align="left"><strong>Dt Vcto</strong></td>
				<td align="left"><strong>Conta</strong></td>
				<td align="left"><strong>Entidade</strong></td>
				<td align="left"><strong>Cód.</strong></td>
				<td align="left"><strong>Nome</strong></td>
				<td style="text-align: right;"><strong>Valor</strong></td>
				<td align="left" nowrap><strong>Vence em</strong></td>
				<td align="center"><strong>Tipo</strong></td>
			</tr>
		<%
		acPAGAR   = 0
		acRECEBER = 0
		strBGCOLOR = strGRADE_CORLINHA2
		Do While Not objRS1.Eof 
			strSQL = ""
			if GetValue(objRS1, "TIPO")="ENT_CLIENTE"	  and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE		WHERE COD_CLIENTE = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			if GetValue(objRS1, "TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			if GetValue(objRS1, "TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS1,"CODIGO")) then strSQL = "SELECT NOME FROM ENT_COLABORADOR WHERE COD_COLABORADOR = " & GetValue(objRS1,"CODIGO_ENTIDADE")
			
			strENTIDADE = ""
			If strSQL <> "" Then 
				Set objRS2 = objConn.Execute(strSQL)				
				If Not objRS2.Eof Then strENTIDADE = mid(GetValue(objRS2, "NOME"),1,25)			
			End If 
			
			If GetValue(objRS1, "PAGAR_RECEBER") = "0" Then 
				strICONE = "<img src='../img/icon_FinContaReceber.gif' alt='Conta a Receber'>"
			Else
				strICONE = "<img src='../img/icon_FinContaPagar.gif' alt='Conta a Pagar'>"
			End If

			If GetValue(objRS1, "PAGAR_RECEBER") = "1" Then 
				acPAGAR   = acPAGAR + GetValue(objRS1,"VLR_CONTA")
			Else
				acRECEBER = acRECEBER + GetValue(objRS1,"VLR_CONTA")
			End If
			%>
			<tr bgcolor="<%=strBGCOLOR%>">
				<td width="9%" align="left" nowrap><div style="padding-left:10px; padding-right:4px;"><%=PrepData(GetValue(objRS1, "DT_VCTO"), True, False)%></div></td>
				<td width="25%" align="left" nowrap><div style="padding-left:4px; padding-right:4px;"><%=mid(GetValue(objRS1,"CONTA"),1,15)%></div></td>
				<td width="5%"  align="left" nowrap><%=Replace(GetValue(objRS1,"TIPO"),"ENT_","")%></td>
				<td width="5%"  align="left" nowrap><%=GetValue(objRS1,"CODIGO_ENTIDADE")%></td>
				<td width="25%" align="left" title="<%=GetValue(objRS2,"NOME")%>" nowrap><div style="cursor:default; padding-left:4px; padding-right:4px;"><%=strENTIDADE%></div></td>				
				<td width="15%" style="text-align: right;"><div style="padding-left:4px; padding-right:4px;"><%=FormataDecimal(GetValue(objRS1, "VLR_CONTA"), 2)%></div></td>
				<td width="15%" style="text-align: right;" nowrap><div style="padding-left:4px; padding-right:4px;"><%=Response.Write(GetValue(objRS1, "NUM_DIAS") & " dia(s)")%></div></td>
				<td width="1%" align="center"><div style="padding-left:4px; padding-right:4px;"><%=strICONE%></div></td>
			</tr>
			<%
			FechaRecordSet objRS2
			objRS1.MoveNext
			
			If strBGCOLOR = strGRADE_CORLINHA2 Then
				strBGCOLOR = strGRADE_CORLINHA1
			Else
				strBGCOLOR = strGRADE_CORLINHA2
			End If
		Loop
		%>
			<tr><td colspan="8" height="5"></td></tr>
			<tr style="border-bottom:1px solid #333;">
				<td colspan="5"></td>
				<td style="text-align:right; background-color:#CCCCCC">PAGAR</td>
				<td style="text-align:right; background-color:#CCCCCC">RECEBER</td>
				<td></td>
			</tr>
			<tr>
				<td colspan="5" align="right" nowrap></td>
				<td style="text-align:right; background-color:#CCCCCC"><%=FormataDecimal(acPAGAR,2)%></td>
				<td style="text-align:right; background-color:#CCCCCC"><%=FormataDecimal(acRECEBER,2)%></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="5" style="text-align:right;"></td>
				<td colspan="2" style="text-align:right; border:1px solid #000;  background-color:#CCCCCC">SALDO:&nbsp;<strong><%=FormataDecimal(acRECEBER-acPAGAR,2)%></strong></td>
				<td></td>
			</tr>

			<tr><td colspan="8" height="20"></td></tr>
		<%
	End If 
	
	FechaRecordSet objRS1
	%>
		</table>
					</td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
		<!-- corpo FIM -->
	</td>
</tr>
</table>