<%
Dim strMES, strANO
Dim strDESPESA_Prevista, strRECEITA_Prevista
Dim strDESPESA_Realizada, strRECEITA_Realizada
Dim strSALDO, strTOTAL, pCent, tbW
Dim LarguraRP, LarguraDP, LarguraRR, LarguraDR
Dim Debugging

	strMES = DatePart("M",Date)
	strANO = DatePart("YYYY",Date)
	
	'----------------------------
	' Busca totais das CONTAS
	'----------------------------
	strSQL =  " SELECT SUM(VLR_SALDO) AS TOTAL FROM FIN_CONTA WHERE DT_INATIVO IS NULL "
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	strSALDO = 0
	if not objRS.eof then
		if GetValue(objRS,"TOTAL")<>"" then	strSALDO = CDbl(GetValue(objRS,"TOTAL"))
	end if
	FechaRecordSet objRS
	
	'-----------------------------------------------------------------------------------------------------------
	' Busca totais de ENTRADA e SAIDA nas Contas a Pagar e Receber cadastradas no mês corrente
	'-----------------------------------------------------------------------------------------------------------
	strSQL =  " SELECT " &_
			"	 SUM(T1.VLR_CONTA) AS ENTRADA " &_
			"	,(SELECT SUM(T1.VLR_CONTA) FROM FIN_CONTA_PAGAR_RECEBER T1, FIN_CONTA T2 WHERE T1.PAGAR_RECEBER <> 0 " &_
			"     AND Month(T1.DT_VCTO) = " & strMES & " AND Year(T1.DT_VCTO) = " & strANO &_
			"     AND T1.SITUACAO <> 'CANCELADA' AND T1.COD_CONTA = T2.COD_CONTA) AS SAIDA " &_
			" FROM " &_
			"	FIN_CONTA_PAGAR_RECEBER T1, FIN_CONTA T2 " &_
			" WHERE T1.PAGAR_RECEBER = 0 " &_
			" AND T1.SITUACAO <> 'CANCELADA' " &_
			" AND Month(T1.DT_VCTO) = " & strMES & " AND Year(T1.DT_VCTO) = " & strANO &_
			" AND T1.COD_CONTA = T2.COD_CONTA " 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	strRECEITA_Prevista = 0
	strDESPESA_Prevista = 0		
	while not objRS.eof 
		if GetValue(objRS,"ENTRADA")<>"" then strRECEITA_Prevista = strRECEITA_Prevista + CDbl(GetValue(objRS,"ENTRADA"))
		if GetValue(objRS,"SAIDA")<>""   then strDESPESA_Prevista = strDESPESA_Prevista + CDbl(GetValue(objRS,"SAIDA"))
		
		objRS.MoveNext
	wend
	FechaRecordSet objRS
	
	'----------------------------------------------------------------------------------------------------------------------------
	' Busca totais de ENTRADA e SAIDA nos Lctos realizados no mês corrente em Contas a Pagar e Receber do mês corrente também
	'----------------------------------------------------------------------------------------------------------------------------
	strSQL =  " SELECT "	&_
			"	 SUM(ORD.VLR_LCTO) AS ENTRADA1 "   	&_
			"	,SUM(ORD.VLR_DESC) AS ENTRADA2 "  	&_
			"	,SUM(ORD.VLR_MULTA) AS ENTRADA3 "  	&_
			"	,SUM(ORD.VLR_JUROS) AS ENTRADA4"  	&_
			"	,(SELECT SUM(ORD.VLR_LCTO) FROM FIN_LCTO_ORDINARIO ORD, FIN_CONTA_PAGAR_RECEBER PR, FIN_CONTA CT WHERE ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER AND PR.PAGAR_RECEBER <> 0 AND Month(PR.DT_VCTO) = " & strMES & " AND Year(PR.DT_VCTO) = " & strANO & " AND Month(ORD.DT_LCTO) = " & strMES & " AND Year(ORD.DT_LCTO) = " & strANO & " AND PR.COD_CONTA = CT.COD_CONTA) AS SAIDA1 " &_
			"	,(SELECT SUM(ORD.VLR_DESC) FROM FIN_LCTO_ORDINARIO ORD, FIN_CONTA_PAGAR_RECEBER PR, FIN_CONTA CT WHERE ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER AND PR.PAGAR_RECEBER <> 0 AND Month(PR.DT_VCTO) = " & strMES & " AND Year(PR.DT_VCTO) = " & strANO & " AND Month(ORD.DT_LCTO) = " & strMES & " AND Year(ORD.DT_LCTO) = " & strANO & " AND PR.COD_CONTA = CT.COD_CONTA) AS SAIDA2 " &_
			"	,(SELECT SUM(ORD.VLR_MULTA) FROM FIN_LCTO_ORDINARIO ORD, FIN_CONTA_PAGAR_RECEBER PR, FIN_CONTA CT WHERE ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER AND PR.PAGAR_RECEBER <> 0 AND Month(PR.DT_VCTO) = " & strMES & " AND Year(PR.DT_VCTO) = " & strANO & " AND Month(ORD.DT_LCTO) = " & strMES & " AND Year(ORD.DT_LCTO) = " & strANO & " AND PR.COD_CONTA = CT.COD_CONTA) AS SAIDA3 " &_
			"	,(SELECT SUM(ORD.VLR_JUROS) FROM FIN_LCTO_ORDINARIO ORD, FIN_CONTA_PAGAR_RECEBER PR, FIN_CONTA CT WHERE ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER AND PR.PAGAR_RECEBER <> 0 AND Month(PR.DT_VCTO) = " & strMES & " AND Year(PR.DT_VCTO) = " & strANO & " AND Month(ORD.DT_LCTO) = " & strMES & " AND Year(ORD.DT_LCTO) = " & strANO & " AND PR.COD_CONTA = CT.COD_CONTA) AS SAIDA4 " &_
			" FROM " 	&_
			"	FIN_LCTO_ORDINARIO ORD " &_
			" , FIN_CONTA_PAGAR_RECEBER PR " &_
			" , FIN_CONTA CT " &_
			" WHERE ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER AND PR.PAGAR_RECEBER = 0 " &_
			" AND Month(PR.DT_VCTO) = " & strMES & " AND Year(PR.DT_VCTO) = " & strANO &_ 
			" AND Month(ORD.DT_LCTO) = " & strMES & " AND Year(ORD.DT_LCTO) = " & strANO &_
			" AND PR.COD_CONTA = CT.COD_CONTA " 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	strRECEITA_Realizada = 0
	strDESPESA_Realizada = 0		
	while not objRS.eof 
		if GetValue(objRS,"ENTRADA1")<>"" then strRECEITA_Realizada = strRECEITA_Realizada + CDbl(GetValue(objRS,"ENTRADA1"))
		if GetValue(objRS,"ENTRADA2")<>"" then strRECEITA_Realizada = strRECEITA_Realizada + CDbl(GetValue(objRS,"ENTRADA2"))
		if GetValue(objRS,"ENTRADA3")<>"" then strRECEITA_Realizada = strRECEITA_Realizada + CDbl(GetValue(objRS,"ENTRADA3"))
		if GetValue(objRS,"ENTRADA4")<>"" then strRECEITA_Realizada = strRECEITA_Realizada + CDbl(GetValue(objRS,"ENTRADA4"))
		
		if GetValue(objRS,"SAIDA1")<>""	  then strDESPESA_Realizada = strDESPESA_Realizada + CDbl(GetValue(objRS,"SAIDA1"))
		if GetValue(objRS,"SAIDA2")<>""   then strDESPESA_Realizada = strDESPESA_Realizada + CDbl(GetValue(objRS,"SAIDA2"))
		if GetValue(objRS,"SAIDA3")<>""   then strDESPESA_Realizada = strDESPESA_Realizada + CDbl(GetValue(objRS,"SAIDA3"))
		if GetValue(objRS,"SAIDA4")<>""   then strDESPESA_Realizada = strDESPESA_Realizada + CDbl(GetValue(objRS,"SAIDA4"))
		
		objRS.MoveNext
	wend
	FechaRecordSet objRS
	
	'------------------------------
	' Definição das larguras
	'------------------------------
	LarguraRP = 0
	LarguraDP = 0
	LarguraRR = 0
	LarguraDR = 0
	
	Debugging = 0
	
	If Debugging = 1 Then
		Response.Write "<br>RP " & strRECEITA_Prevista
		Response.Write "<br>DP " & strDESPESA_Prevista
		Response.Write "<br>RR " & strRECEITA_Realizada
		Response.Write "<br>DR " & strDESPESA_Realizada
		Response.Write "<br>"
	End If
	
	If strRECEITA_Prevista > 0 Or strDESPESA_Prevista > 0 Then
		If strRECEITA_Prevista > strDESPESA_Prevista Then
			If Debugging = 1 Then
				Response.Write "<br>100"
				Response.Write "<br>(" & strDESPESA_Prevista & " * 100) / " & strRECEITA_Prevista & " = " & Round((strDESPESA_Prevista * 100) / strRECEITA_Prevista, 2)
				Response.Write "<br>(" & strRECEITA_Realizada & " * 100) / " & strRECEITA_Prevista & " = " & Round((strRECEITA_Realizada * 100) / strRECEITA_Prevista, 2)
				Response.Write "<br>(" & strDESPESA_Realizada & " * 100) / " & strRECEITA_Prevista & " = " & Round((strDESPESA_Realizada * 100) / strRECEITA_Prevista, 2)
			End If
			
			LarguraRP = 100
			LarguraDP = Round((strDESPESA_Prevista * 100) / strRECEITA_Prevista, 2)
			LarguraRR = Round((strRECEITA_Realizada * 100) / strRECEITA_Prevista, 2)
			LarguraDR = Round((strDESPESA_Realizada * 100) / strRECEITA_Prevista, 2)
		Else
			If Debugging = 1 Then
				Response.Write "<br>(" & strRECEITA_Prevista & " * 100) / " & strDESPESA_Prevista & " = " & Round((strRECEITA_Prevista * 100) / strDESPESA_Prevista, 2)
				Response.Write "<br>100"
				Response.Write "<br>(" & strRECEITA_Realizada & " * 100) / " & strDESPESA_Prevista & " = " & Round((strRECEITA_Realizada * 100) / strDESPESA_Prevista, 2)
				Response.Write "<br>(" & strDESPESA_Realizada & " * 100) / " & strDESPESA_Prevista & " = " & Round((strDESPESA_Realizada * 100) / strDESPESA_Prevista, 2)
			End If
			
			LarguraRP = Round((strRECEITA_Prevista * 100) / strDESPESA_Prevista, 2)
			LarguraDP = 100
			LarguraRR = Round((strRECEITA_Realizada * 100) / strDESPESA_Prevista, 2)
			LarguraDR = Round((strDESPESA_Realizada * 100) / strDESPESA_Prevista, 2)
		End If
	End If
	
	If Debugging = 1 Then
		Response.Write "<br>"
		'Response.End
	End If
%>
<table width="180" height="100%" border="1" bordercolor="#C9C9C9" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td width="100%">
			<!-- corpo INIC -->
			<table align="center" width="90%" bordercolor="#C9C9C9" cellpadding="0" cellspacing="0" border="0">
				<tr><td height="22" background="../img/BgBoxTit.gif"><div style="color:#3C6BC0; padding-left:10px"><b>Resumo do mês atual</b></div></td></tr>
				<tr> 
					<td valign="top">
						<div style="padding-top:10px;"> 
							<table width="90%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
									<td align="center">
										<div style="padding-left:3px; padding-right:3px;">
						<% 'If LarguraRP > 0 Or LarguraRR > 0 Then %>
											<table width="150px" height="25px" cellpadding="0" cellspacing="0" style="border: 1px solid;">
												<tr>
													<td width="<%=LarguraRR%>%" bgcolor="#008100"></td>
													<td width="<%=(LarguraRP-LarguraRR)%>%" bgcolor="#004D00"></td>
													<td width="<%=(100-LarguraRP)%>%" bgcolor="#FFFFFF"></td>
												</tr>
											</table>
						<% 'End If %>
										</div>
									</td>
									<td align="left" class="texto_ajuda" style="padding-right:3px;"></td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr> 
					<td valign="top">
						<div style="padding-top:10px;"> 
							<table width="90%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
									<td align="center">
										<div style="padding-left:3px; padding-right:3px;">
						<% 'If LarguraDP > 0 Or LarguraDR > 0 Then %>
											<table width="150px" height="25px" cellpadding="0" cellspacing="0" style="border: 1px solid;">
												<tr>
													<td width="<%=LarguraDR%>%" bgcolor="#F5040D"></td>
													<td width="<%=(LarguraDP-LarguraDR)%>%" bgcolor="#CE0300"></td>
													<td width="<%=(100-LarguraDP)%>%" bgcolor="#FFFFFF"></td>
												</tr>
											</table>
						<% 'End If %>
										</div>
									</td>
									<td align="left" class="texto_ajuda" style="padding-right:3px;"></td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td align="left" class="texto_ajuda">
						<div style="padding:10px;">
							<%
							If strRECEITA_Prevista > 0 Or strDESPESA_Prevista > 0 Then 
								strTOTAL = strRECEITA_Prevista - strDESPESA_Prevista
								Response.Write(FormataDecimal(strRECEITA_Prevista, 2) & " - " & FormataDecimal(strDESPESA_Prevista, 2) & " = " & FormataDecimal(strTOTAL, 2))
							End If
							%>
						&nbsp;</div>
					</td>
				</tr>		
			</table>
			<!-- corpo FIM -->
		</td>
	</tr>
</table>