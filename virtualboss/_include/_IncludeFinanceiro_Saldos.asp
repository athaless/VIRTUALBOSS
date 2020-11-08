<table width="100%" height="100%" border="1" bordercolor="#C9C9C9" cellpadding="0" cellspacing="0">
<tr valign="top">
	<td width="100%">
		<!-- corpo INIC -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr> 
			<td height="22" background="../img/BgBoxTit.gif" style="color:#3C6BC0;">
			    <div style="padding-left:10px"><b>Saldos das Contas</b></div>
			</td>
		</tr>
		<tr> 
			<td valign="top">
				<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
				<tr> 
					<td width="100%">
	<%
	'-----------------------------
	' Consulta as contas
	'-----------------------------
	strSQL =          " SELECT NOME, VLR_SALDO, DT_INATIVO "
	strSQL = strSQL & " FROM FIN_CONTA " 
	strSQL = strSQL & " ORDER BY DT_INATIVO, ORDEM, NOME " 
	
	Set objRS = objConn.Execute(strSQL) 
	
	strVLR_SALDO_GERAL = 0
	If Not objRS.Eof Then 
		%>
		<table border="0" width="100%" height="100%" cellpadding="2" cellspacing="0">
		<%
		strBGCOLOR = strGRADE_CORLINHA1
		Do While Not objRS.Eof 
			strVLR_SALDO = GetValue(objRS, "VLR_SALDO")
			
			If strVLR_SALDO = "" Or Not IsNumeric(strVLR_SALDO) Then strVLR_SALDO = 0 
			strVLR_SALDO_GERAL = strVLR_SALDO_GERAL + strVLR_SALDO
			
			strVLR_SALDO = FormataDecimal(strVLR_SALDO, 2)
			strInativoCOLOR = ""
			If GetValue(objRS, "DT_INATIVO") = "" Then
				If strVLR_SALDO >= 0 Then 
					strInativoCOLOR = "color:#000099;"
				Else
					strInativoCOLOR = "color:#990000;"
				End If
			Else
				 strInativoCOLOR = "color:#666666;"
			End If
			
			%>
			<tr bgcolor="<%=strBGCOLOR%>">
				<td width="99%" align="left"><div style="padding-left:10px; padding-right:4px; <%=strInativoCOLOR%>"><%=GetValue(objRS, "NOME")%></div></td>
				<td width="1%" style="text-align:right;" nowrap><div style="padding-left:10px; padding-right:4px; <%=strInativoCOLOR%>"><%=strVLR_SALDO%></div></td>
			</tr>
			<%
			objRS.MoveNext
			
			If strBGCOLOR = strGRADE_CORLINHA2 Then
				strBGCOLOR = strGRADE_CORLINHA1
			Else
				strBGCOLOR = strGRADE_CORLINHA2
			End If
		Loop
		%>
			<tr>
				<td colspan="2" style="text-align: right;"><div style="padding-left:10px; padding-right:4px;">
				<strong>Total:&nbsp;<%=FormataDecimal(strVLR_SALDO_GERAL, 2)%></strong></div></td>
				<td></td>
			</tr>
			<tr><td colspan="2" height="10"></td></tr>
		</table>
		<%
	End If
	
	FechaRecordSet objRS
	%>
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