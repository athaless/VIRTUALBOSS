<%
strUSER_ID       = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) 
strGRUPO_USUARIO = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))

strVIEW		= GetParam("var_view")
strDIA_SEL1	= GetParam("var_dia_selected")
strULTIMAS  = GetParam("var_ultimas")

If strVIEW="" Then strVIEW = "exec"
'If strVIEW="" Then strVIEW = "equipe"
If strDIA_SEL1="" Then strDIA_SEL1 = date

If strULTIMAS="" Then
	If CFG_DB = "vboss_girardi" Then
		strULTIMAS = "7D"
	Else
		strULTIMAS = "3M"
	End If
End If

strDIA_SEL2 = DateAdd("D", 5, strDIA_SEL1)

auxSTR			= BuscaDireitosFromDB("modulo_TODOLIST", strUSER_ID)
bUpdTODO		= VerificaDireito("|UPD|", auxSTR, false)
bInsRespTODO	= VerificaDireito("|INS_RESP|", auxSTR, false)
bCloseTODO		= VerificaDireito("|CLOSE|", auxSTR, false)

 Function ExibePROJETO(prCODIGO, prTITULO, prFASE_ATUAL)
	Dim strSAIDA
	
	strSAIDA =            "<table width='99%' height='20' bgcolor='#E9E9E9' cellpadding='2' cellspacing='0'>" & vbNewLine
	strSAIDA = strSAIDA & "	  <tr>" & vbNewLine
	strSAIDA = strSAIDA & "		<td width='16' align='center'><a href=""Javascript: ShowArea('prj_" & prCODIGO & "', 'icon_prj_" & prCODIGO & "');""><img src='../img/BulletMenos.gif' border='0' align='absmiddle' name='icon_prj_" & prCODIGO & "' id='icon_prj_" & prCODIGO & "'></a></td>" & vbNewLine
	If prCODIGO <> "" And prTITULO <> "" Then
		strSAIDA = strSAIDA & "<td>" & prTITULO & " - " & prFASE_ATUAL & "</td>" & vbNewLine
	Else
		strSAIDA = strSAIDA & "<td>PROJETO GERAL</td>" & vbNewLine
	End If
	strSAIDA = strSAIDA & "	  </tr>" & vbNewLine
	strSAIDA = strSAIDA & "</table>" & vbNewLine
	strSAIDA = strSAIDA & "<div id='prj_" & prCODIGO & "' style='padding:0px;'>" & vbNewLine
	
	ExibePROJETO = strSAIDA
 End Function

 Function ExibeBS(prCODIGO, prTITULO, prCOD_CLIENTE, prCLIENTE, prRESPONSAVEL, prSITUACAO, prDT_INI, prDT_FIM, prPREV_HORAS, prHORAS, prNA_EQUIPE)
	Dim strSAIDA, auxBgColor, strCOLOR, Ct
	
	auxBgColor = "#F2F2F2"
	If IsDate(prDT_FIM) Then
		if (prDT_FIM<Date) then auxBgColor = "#F9E9E9" 'vermelho
	End If

	If IsDate(prDT_INI) And IsDate(prDT_FIM) Then
		'if ((prDT_INI-Date)<2) and ((prDT_FIM-Date)>0) then auxBgColor = "#FEFFD3" 'amarelo
		if (prDT_INI=Date) then auxBgColor = "#FEFFD3" 'amarelo
	End If
	
	strSAIDA =            "<table width='99%' height='20' bgcolor='#F9F9F9' cellpadding='2' cellspacing='0' border='0'>" & vbNewLine
	strSAIDA = strSAIDA & "<tr bgcolor='" & auxBgColor & "'>" & vbNewLine
	strSAIDA = strSAIDA & " <td width='16' bgcolor='#FFFFFF'></td>"
	strSAIDA = strSAIDA & " <td width='16' align='center'><a href=""Javascript: ShowArea('ativ_" & prCODIGO & "', 'icon_ativ_" & prCODIGO & "');""><img src='../img/BulletMenos.gif' border='0' align='absmiddle' name='icon_ativ_" & prCODIGO & "' id='icon_ativ_" & prCODIGO & "'></a></td>" & vbNewLine
	
	If prCODIGO <> "" And prTITULO <> "" Then
		strSAIDA = strSAIDA & " <td width='16' valign='top' class='arial11'>"
		if strUSER_ID=LCase(prRESPONSAVEL) then
			strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_BS/Update.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_EDIT.gif' border='0' alt='ALTERAR' title='ALTERAR'></a>"
		elseif prNA_EQUIPE <> "" or (InStr("MANAGER",strGRUPO_USUARIO)>0) then
			strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_BS/DetailHistorico.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_DETAIL.gif' border='0' alt='HISTÓRICO APENAS' title='HISTÓRICO APENAS'></a>"
		end if
		strSAIDA = strSAIDA & " </td>" & vbNewLine
		
		strSAIDA = strSAIDA & " <td width='16' align='center' valign='top' class='arial11'>"
		if prNA_EQUIPE <> "" then
			strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_BS/DetailHistorico.asp?var_chavereg=" & prCODIGO & "&var_resposta=true'><img src='../img/IconAction_DETAILadd.gif' border='0' alt='HISTÓRICO COM INSERÇÃO' title='HISTÓRICO COM INSERÇÃO'></a>"
		end if
		strSAIDA = strSAIDA & " </td>" & vbNewLine
		
		strSAIDA = strSAIDA & " <td width='20' valign='top' class='arial11'>" & prCODIGO & "</td>" & vbNewLine
		strSAIDA = strSAIDA & " <td align='left' valign='top' class='arial11'>" & prTITULO & "</td>" & vbNewLine
		strSAIDA = strSAIDA & " <td width='160' style='text-align:right;' valign='top' class='arial11'>de " & prDT_INI & " a " & prDT_FIM & "</td>" & vbNewLine
		
		Ct = 1
		strCOLOR = "#DAEEFA"
		
		If IsDate(prDT_INI) Then
			if (CDate(prDT_INI)<Now) then
				strCOLOR = "#FFF0F0" '"#FFDDDD" 'vermelho
			end if
		End If
		
		Dim strPREV, strTOTAL, pCent
		Dim AUX1, AUX2
		Dim tbW, BgCor
		
		AUX1 = prHORAS
		AUX2 = prPREV_HORAS
		
		'Retorna o tempo gasto de horas para cada tarefa
		if prHORAS<>"" then prHORAS = FormataHoraNumToHHMM(prHORAS)
		'Retorna total de horas previstas para cada tarefa
		if prPREV_HORAS<>"" then prPREV_HORAS = FormataHoraNumToHHMM(prPREV_HORAS)
		
		strPREV = 0
		strTOTAL= 0
		pCent = 0 
		
		if AUX2<>"" and not IsNull(AUX2) then strPREV = AUX2*60
		if AUX1<>"" and not IsNull(AUX1) then strTOTAL = AUX1*60
		if strPREV>0 and strTOTAL>=0 then pCent = strTOTAL*100/strPREV
		if pCent=0 then strHORAS = "0:00"
		
		tbW = pCent
		BgCor = "#93A2B9"
		
		if (tbW>100) then
			tbW = 100
			BgCor = "#7D8B9F"					
			if prSITUACAO<>"FECHADO" then BgCor = "#C00000"					
		end if				
		
		strSAIDA = strSAIDA & " <td width='60' align='left' valign='middle' class='arial11'>" & vbNewLine
		strSAIDA = strSAIDA & "	<div style='padding-left:3px; padding-right:3px;'>" & vbNewLine
		strSAIDA = strSAIDA & "		<table width='50' height='12' cellpadding='0' cellspacing='0' bordercolor='" & BgCor & "' style='border:1px solid;'>" & vbNewLine
		strSAIDA = strSAIDA & "			<tr>" & vbNewLine
		If tbW = 100 Then
			strSAIDA = strSAIDA & "<td width='100%' bgcolor='" & BgCor & "' title='"& Round(pCent,2) &"% - "& prHORAS &"Hs'></td>" & vbNewLine
		ElseIf tbW = 0 Then
			strSAIDA = strSAIDA & "<td width='100%' bgcolor='#FFFFFF' title='"& Round(pCent,2) &"% - "& prHORAS &"Hs'></td>" & vbNewLine
		Else
			strSAIDA = strSAIDA & "<td width='" & tbW & "%' bgcolor='" & BgCor & "' title='"& Round(pCent,2) &"% - "& prHORAS &"Hs'></td>" & vbNewLine
			strSAIDA = strSAIDA & "<td width='"& (100-tbW) &"%' bgcolor='#FFFFFF' title='"& Round(pCent,2) &"% - "& prHORAS &"Hs'></td>" & vbNewLine
		End If
		strSAIDA = strSAIDA & "			</tr>" & vbNewLine
		strSAIDA = strSAIDA & "		</table>" & vbNewLine
		strSAIDA = strSAIDA & "	</div>" & vbNewLine
		strSAIDA = strSAIDA & " </td>" & vbNewLine
		strSAIDA = strSAIDA & " <td width='40' style='text-align:right' valign='top' class='arial11' title='Total de horas previstas'>"& prPREV_HORAS &"</td>" & vbNewLine
		strSAIDA = strSAIDA & " <td width='16' valign='top' class='arial11'><a href='../modulo_CLIENTE/Detail.asp?var_chavereg="& prCOD_CLIENTE &"'><img src='../img/IconStatus_Client.gif' border='0' title='CLIENTE: " & prCLIENTE &"'></a></td>" & vbNewLine
	Else
		strSAIDA = strSAIDA & "<td>ATIVIDADE GERAL</td>" & vbNewLine
	End If
	strSAIDA = strSAIDA & "</tr>" & vbNewLine
	strSAIDA = strSAIDA & "</table>" & vbNewLine
	strSAIDA = strSAIDA & "<div id='ativ_" & prCODIGO & "' style='padding:0px;'>" & vbNewLine
	
	ExibeBS = strSAIDA
 End Function

 Function ExibeTODOLIST(prCODIGO, prTITULO, prRESPONSAVEL, prEXECUTOR, prCATEGORIA, prDT_INI, prHR_INI, prHORAS, prSITUACAO, prPRIORIDADE, prCOD_BS, prCABECALHO)
	Dim strSAIDA, auxBgColor
	
	if prHORAS<>"" then prHORAS = FormataHoraNumToHHMM(prHORAS) else prHORAS = "&nbsp;" end if
	auxBgColor="#FFFFF0"
	if IsDate(prDT_INI) then
		if (prSITUACAO<>"FECHADO") then
			if (prDT_INI<Now) then auxBgColor = "#FFF0F0"
			if (prDT_INI=Date) then auxBgColor = "#FFFFF0"
		end if
	else
		auxBgColor = "#FFFFFF"
	end if
	
	If prCABECALHO Then
		strSAIDA =            "<table width='99%' height='20' bgcolor='#FFFFFF' cellpadding='2' cellspacing='1' border='0'>" & vbNewLine
		strSAIDA = strSAIDA & "<tr bgcolor='#EFEDED' class='arial11' valign='middle'>" & vbNewLine
		strSAIDA = strSAIDA & "	<td colspan='2' width='32' bgcolor='#FFFFFF'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='60' nowrap>Data</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='15' nowrap></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='40' align='right'>Cod</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='70'>Categoria</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td>Título</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='60'>Resp</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='60'>Exec</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='40' align='right'>Prev Hs</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "</tr>" & vbNewLine
		
		'Linha fina e escura
		strSAIDA = strSAIDA & "<tr>" & vbNewLine
		strSAIDA = strSAIDA & " <td colspan='2'></td>" & vbNewLine
		strSAIDA = strSAIDA & " <td colspan='13' height='1' bgcolor='#C9C9C9'></td>" & vbNewLine
		strSAIDA = strSAIDA & "</tr>" & vbNewLine
	End If
	
	strSAIDA = strSAIDA & "<tr bgcolor='" & auxBgColor & "' class='arial11' valign='middle'>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' bgcolor='#FFFFFF'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' bgcolor='#FFFFFF'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If (bUpdTODO And (LCase(prRESPONSAVEL) = strUSER_ID And (prHORAS = "0" Or prHORAS = ""))) Then
		strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_TODOLIST/Update.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_EDIT.gif' border='0' title='ALTERAR'></a>"
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If (bInsRespTODO And (LCase(prRESPONSAVEL) = strUSER_ID Or LCase(prEXECUTOR) = strUSER_ID)) Then
		strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_TODOLIST/DetailHistorico.asp?var_chavereg=" & prCODIGO & "&var_resposta=true'><img src='../img/IconAction_DETAILadd.gif' border='0' title='INSERIR ANDAMENTO'></a>"
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If (bCloseTODO And (LCase(prRESPONSAVEL) = strUSER_ID Or LCase(prEXECUTOR) = strUSER_ID)) Then
		strSAIDA = strSAIDA & MontaLinkGrade("modulo_TODOLIST","Close.asp",prCODIGO & "&var_ultexec=" & strUSER_ID,"IconAction_QUICK_CLOSE.gif","FECHAR")
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td width='65' valign='top'>" & PrepData(prDT_INI,true,false) & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='15' valign='top'>" & prHR_INI & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='40' align='right' valign='top'>" & prCODIGO & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & prCATEGORIA & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & prTITULO & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='60' valign='top'>" & LCase(prRESPONSAVEL) & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='60' valign='top'>" & LCase(prEXECUTOR) & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='40' style='text-align:right' valign='top'>" & prHORAS & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'><img src='../img/IconStatus_" & prSITUACAO & ".gif'  title='SITUAÇÃO: " & prSITUACAO & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'><img src='../img/IconPrio_" & prPRIORIDADE & ".gif' title='PRIORIDADE: " & prPRIORIDADE & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "</tr>" & vbNewLine
	
	'Final da tabela é por fora, quando se troca de BS/Projeto
	'strSAIDA = strSAIDA & "</table>" & vbNewLine
	
	ExibeTODOLIST = strSAIDA
 End Function

 ' -----------------------------------------------------------------------------------------------
 ' INI: MontaSQLBuscaPAT -------------------------------------------------------------------------
 '      Monta o SQL para busta do PAT ([P]rojetos, [A]tividades e [T]arefas do usuário), conforme
 ' a procedure sp_busca_pat faria, mas  no  MySQL 4.1.18  não temos procedure, então por enquanto
 ' temos de fazer via sql mesmo, tentei deixar com estrutura o mais próxima da procedure possível.
 ' -----------------------------------------------------------------------------------------------
 Function MontaSQLBuscaPAT (prIN_DATA, prIN_ID_USUARIO, prIN_VIEW, prLIMIT, prULTIMAS)
    Dim auxSQL, auxDATA
	
	auxDATA = ""
	If prULTIMAS = "7D"  Then auxDATA = DateAdd("D",  -7, prIN_DATA)
	If prULTIMAS = "14D" Then auxDATA = DateAdd("D", -14, prIN_DATA)
	If prULTIMAS = "1M"  Then auxDATA = DateAdd("M",  -1, prIN_DATA)
	If prULTIMAS = "3M"  Then auxDATA = DateAdd("M",  -3, prIN_DATA)
	If prULTIMAS = "6M"  Then auxDATA = DateAdd("M",  -6, prIN_DATA)
	If prULTIMAS = "12M" Then auxDATA = DateAdd("M", -12, prIN_DATA)
	If prULTIMAS = "24M" Then auxDATA = DateAdd("M", -24, prIN_DATA)
	If IsDate(auxDATA) Then auxDATA = DatePart("YYYY", auxDATA) & "-" & DatePart("M", auxDATA) & "-" & DatePart("D", auxDATA)
	
	IF (lcase(prIN_VIEW) = "exec") THEN
		auxSQL =          "SELECT CL.COD_CLIENTE, CL.NOME_FANTASIA AS CLIENTE , PRJ.COD_PROJETO, PRJ.TITULO AS PRJ_TITULO, PRJ.ID_RESPONSAVEL AS PRJ_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", PRJ.FASE_ATUAL AS PRJ_FASE_ATUAL, PRJ.PREV_TOT_HORAS AS PRJ_PREV_TOT_HORAS, PRJ.DT_INICIO AS PRJ_DT_INICIO "
		auxSQL = auxSQL & ", PRJ.DT_DEADLINE AS PRJ_DT_DEADLINE, BS.COD_BOLETIM, BS.TITULO AS BS_TITULO, BS.ID_RESPONSAVEL AS BS_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", BS.SITUACAO AS BS_SITUACAO, BS.PRIORIDADE AS BS_PRIORIDADE "
  		
		'auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
		'auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "
		'auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS "
		auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
		auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "
		auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS "
		auxSQL = auxSQL & ", (SELECT SUM(T2.HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_HORAS "
		auxSQL = auxSQL & ", (SELECT DISTINCT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = TL.COD_BOLETIM AND ID_USUARIO = '" & prIN_ID_USUARIO & "' AND DT_INATIVO IS NULL) AS BS_NA_EQUIPE "
		
		auxSQL = auxSQL & ", TL.COD_TODOLIST, TL.TITULO AS TL_TITULO, TL.ID_RESPONSAVEL AS TL_ID_RESPONSAVEL, TL.ID_ULT_EXECUTOR AS TL_ID_ULT_EXECUTOR"
		auxSQL = auxSQL & ", TL.SITUACAO AS TL_SITUACAO, TL.PRIORIDADE AS TL_PRIORIDADE, TL.PREV_HORAS AS TL_PREV_HORAS, TL.PREV_DT_INI AS TL_PREV_DT_INI"
		auxSQL = auxSQL & ", TL.PREV_DT_FIM AS TL_PREV_DT_FIM, TL.PREV_HR_INI AS TL_PREV_HR_INI, TL.ARQUIVO_ANEXO AS TL_ARQUIVO_ANEXO, TLCAT.NOME AS TL_CATEGORIA "
		
		auxSQL = auxSQL & " FROM TL_TODOLIST TL "
		auxSQL = auxSQL & " LEFT OUTER JOIN BS_BOLETIM BS ON (TL.COD_BOLETIM = BS.COD_BOLETIM) "
		auxSQL = auxSQL & " LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = BS.COD_CLIENTE) "
		auxSQL = auxSQL & " LEFT OUTER JOIN PRJ_PROJETO PRJ ON (BS.COD_PROJETO = PRJ.COD_PROJETO) "
		auxSQL = auxSQL & " LEFT OUTER JOIN TL_CATEGORIA TLCAT ON (TL.COD_CATEGORIA = TLCAT.COD_CATEGORIA) "
  		
		auxSQL = auxSQL & " WHERE TL.SITUACAO <> 'FECHADO' "
		If prULTIMAS <> "" And auxDATA <> "" Then
			auxSQL = auxSQL & " AND TL.PREV_DT_INI BETWEEN '" & auxDATA & "' AND '" & prIN_DATA & "' " 
		Else
			auxSQL = auxSQL & " AND TL.PREV_DT_INI <= '" & prIN_DATA & "' " 
		End If
		auxSQL = auxSQL & " AND TL.ID_ULT_EXECUTOR = '" & prIN_ID_USUARIO & "' "
		auxSQL = auxSQL & " AND (BS.TIPO = 'NORMAL' OR BS.TIPO IS NULL) "
		
		auxSQL = auxSQL & " ORDER BY PRJ.TITULO, PRJ.COD_PROJETO, BS.TITULO, BS.COD_BOLETIM, TL.TITULO, TL.COD_TODOLIST "
		auxSQL = auxSQL & " LIMIT " & prLIMIT 
    END IF

	IF (lcase(prIN_VIEW) = "resp") THEN
		auxSQL =          "SELECT CL.COD_CLIENTE, CL.NOME_FANTASIA AS CLIENTE , PRJ.COD_PROJETO, PRJ.TITULO AS PRJ_TITULO, PRJ.ID_RESPONSAVEL AS PRJ_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", PRJ.FASE_ATUAL AS PRJ_FASE_ATUAL, PRJ.PREV_TOT_HORAS AS PRJ_PREV_TOT_HORAS, PRJ.DT_INICIO AS PRJ_DT_INICIO "
		auxSQL = auxSQL & ", PRJ.DT_DEADLINE AS PRJ_DT_DEADLINE, BS.COD_BOLETIM, BS.TITULO AS BS_TITULO, BS.ID_RESPONSAVEL AS BS_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", BS.SITUACAO AS BS_SITUACAO, BS.PRIORIDADE AS BS_PRIORIDADE "
  		
		auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
		auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "
		auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS "
		auxSQL = auxSQL & ", (SELECT SUM(T2.HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_HORAS " 
		auxSQL = auxSQL & ", (SELECT DISTINCT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = TL.COD_BOLETIM AND ID_USUARIO = '" & prIN_ID_USUARIO & "' AND DT_INATIVO IS NULL) AS BS_NA_EQUIPE "
		
		auxSQL = auxSQL & ", TL.COD_TODOLIST, TL.TITULO AS TL_TITULO, TL.ID_RESPONSAVEL AS TL_ID_RESPONSAVEL, TL.ID_ULT_EXECUTOR AS TL_ID_ULT_EXECUTOR "
		auxSQL = auxSQL & ", TL.SITUACAO AS TL_SITUACAO, TL.PRIORIDADE AS TL_PRIORIDADE, TL.PREV_HORAS AS TL_PREV_HORAS, TL.PREV_DT_INI AS TL_PREV_DT_INI "
		auxSQL = auxSQL & ", TL.PREV_DT_FIM AS TL_PREV_DT_FIM, TL.PREV_HR_INI AS TL_PREV_HR_INI, TL.ARQUIVO_ANEXO AS TL_ARQUIVO_ANEXO, TLCAT.NOME AS TL_CATEGORIA "
		
		auxSQL = auxSQL & " FROM TL_TODOLIST TL "
		auxSQL = auxSQL & " LEFT OUTER JOIN BS_BOLETIM BS ON (TL.COD_BOLETIM = BS.COD_BOLETIM) "
		auxSQL = auxSQL & " LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = BS.COD_CLIENTE) "
		auxSQL = auxSQL & " LEFT OUTER JOIN PRJ_PROJETO PRJ ON (BS.COD_PROJETO = PRJ.COD_PROJETO) "
		auxSQL = auxSQL & " LEFT OUTER JOIN TL_CATEGORIA TLCAT ON (TL.COD_CATEGORIA = TLCAT.COD_CATEGORIA) "
  		
		auxSQL = auxSQL & " WHERE TL.SITUACAO <> 'FECHADO' "
		If prULTIMAS <> "" And auxDATA <> "" Then
			auxSQL = auxSQL & " AND TL.PREV_DT_INI BETWEEN '" & auxDATA & "' AND '" & prIN_DATA & "' " 
		Else
			auxSQL = auxSQL & " AND TL.PREV_DT_INI <= '" & prIN_DATA & "' " 
		End If
		auxSQL = auxSQL & " AND TL.ID_RESPONSAVEL = '" & prIN_ID_USUARIO & "' " 
		auxSQL = auxSQL & " AND (BS.TIPO = 'NORMAL' OR BS.TIPO IS NULL) "
		
		auxSQL = auxSQL & " ORDER BY PRJ.TITULO, PRJ.COD_PROJETO, BS.TITULO, BS.COD_BOLETIM, TL.TITULO, TL.COD_TODOLIST "
		auxSQL = auxSQL & " LIMIT " & prLIMIT    
	END IF

	IF (lcase(prIN_VIEW) = "all") THEN
		auxSQL =          "SELECT CL.COD_CLIENTE, CL.NOME_FANTASIA AS CLIENTE , PRJ.COD_PROJETO, PRJ.TITULO AS PRJ_TITULO, PRJ.ID_RESPONSAVEL AS PRJ_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", PRJ.FASE_ATUAL AS PRJ_FASE_ATUAL, PRJ.PREV_TOT_HORAS AS PRJ_PREV_TOT_HORAS, PRJ.DT_INICIO AS PRJ_DT_INICIO "
		auxSQL = auxSQL & ", PRJ.DT_DEADLINE AS PRJ_DT_DEADLINE, BS.COD_BOLETIM, BS.TITULO AS BS_TITULO, BS.ID_RESPONSAVEL AS BS_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", BS.SITUACAO AS BS_SITUACAO, BS.PRIORIDADE AS BS_PRIORIDADE "
  		
		auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
		auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "
		auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS "
		auxSQL = auxSQL & ", (SELECT SUM(T2.HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_HORAS "
		auxSQL = auxSQL & ", (SELECT DISTINCT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = TL.COD_BOLETIM AND ID_USUARIO = '" & prIN_ID_USUARIO & "' AND DT_INATIVO IS NULL) AS BS_NA_EQUIPE "
		
		auxSQL = auxSQL & ", TL.COD_TODOLIST, TL.TITULO AS TL_TITULO, TL.ID_RESPONSAVEL AS TL_ID_RESPONSAVEL, TL.ID_ULT_EXECUTOR AS TL_ID_ULT_EXECUTOR "
		auxSQL = auxSQL & ", TL.SITUACAO AS TL_SITUACAO, TL.PRIORIDADE AS TL_PRIORIDADE, TL.PREV_HORAS AS TL_PREV_HORAS, TL.PREV_DT_INI AS TL_PREV_DT_INI "
		auxSQL = auxSQL & ", TL.PREV_DT_FIM AS TL_PREV_DT_FIM, TL.PREV_HR_INI AS TL_PREV_HR_INI, TL.ARQUIVO_ANEXO AS TL_ARQUIVO_ANEXO, TLCAT.NOME AS TL_CATEGORIA "
		
		auxSQL = auxSQL & " FROM TL_TODOLIST TL "
		auxSQL = auxSQL & " LEFT OUTER JOIN BS_BOLETIM BS ON (TL.COD_BOLETIM = BS.COD_BOLETIM) " 
		auxSQL = auxSQL & " LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = BS.COD_CLIENTE) " 
		auxSQL = auxSQL & " LEFT OUTER JOIN PRJ_PROJETO PRJ ON (BS.COD_PROJETO = PRJ.COD_PROJETO) " 
		auxSQL = auxSQL & " LEFT OUTER JOIN TL_CATEGORIA TLCAT ON (TL.COD_CATEGORIA = TLCAT.COD_CATEGORIA) "
        
		auxSQL = auxSQL & " WHERE TL.SITUACAO <> 'FECHADO' "
		If prULTIMAS <> "" And auxDATA <> "" Then
			auxSQL = auxSQL & " AND TL.PREV_DT_INI BETWEEN '" & auxDATA & "' AND '" & prIN_DATA & "' " 
		Else
			auxSQL = auxSQL & " AND TL.PREV_DT_INI <= '" & prIN_DATA & "' " 
		End If
		auxSQL = auxSQL & " AND (BS.TIPO = 'NORMAL' OR BS.TIPO IS NULL) "
		
		auxSQL = auxSQL & " ORDER BY PRJ.TITULO, PRJ.COD_PROJETO, BS.TITULO, BS.COD_BOLETIM, TL.TITULO, TL.COD_TODOLIST "
		auxSQL = auxSQL & " LIMIT " & prLIMIT
    END IF
	
	IF (prIN_VIEW = "equipe") THEN
		auxSQL =          "SELECT CL.COD_CLIENTE, CL.NOME_FANTASIA AS CLIENTE , PRJ.COD_PROJETO, PRJ.TITULO AS PRJ_TITULO, PRJ.ID_RESPONSAVEL AS PRJ_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", PRJ.FASE_ATUAL AS PRJ_FASE_ATUAL, PRJ.PREV_TOT_HORAS AS PRJ_PREV_TOT_HORAS, PRJ.DT_INICIO AS PRJ_DT_INICIO "
		auxSQL = auxSQL & ", PRJ.DT_DEADLINE AS PRJ_DT_DEADLINE, BS.COD_BOLETIM, BS.TITULO AS BS_TITULO, BS.ID_RESPONSAVEL AS BS_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", BS.SITUACAO AS BS_SITUACAO, BS.PRIORIDADE AS BS_PRIORIDADE "
  		
		auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
		auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "  
		auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS " 
		auxSQL = auxSQL & ", (SELECT SUM(T2.HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_HORAS " 
		auxSQL = auxSQL & ", (SELECT DISTINCT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = TL.COD_BOLETIM AND ID_USUARIO = '" & prIN_ID_USUARIO & "' AND DT_INATIVO IS NULL) AS BS_NA_EQUIPE "
		
		auxSQL = auxSQL & ", TL.COD_TODOLIST, TL.TITULO AS TL_TITULO, TL.ID_RESPONSAVEL AS TL_ID_RESPONSAVEL, TL.ID_ULT_EXECUTOR AS TL_ID_ULT_EXECUTOR "
		auxSQL = auxSQL & ", TL.SITUACAO AS TL_SITUACAO, TL.PRIORIDADE AS TL_PRIORIDADE, TL.PREV_HORAS AS TL_PREV_HORAS, TL.PREV_DT_INI AS TL_PREV_DT_INI "
		auxSQL = auxSQL & ", TL.PREV_DT_FIM AS TL_PREV_DT_FIM, TL.PREV_HR_INI AS TL_PREV_HR_INI, TL.ARQUIVO_ANEXO AS TL_ARQUIVO_ANEXO, TLCAT.NOME AS TL_CATEGORIA "
		
		auxSQL = auxSQL & " FROM TL_TODOLIST TL "
		auxSQL = auxSQL & " INNER JOIN BS_BOLETIM BS ON (TL.COD_BOLETIM = BS.COD_BOLETIM) "
		auxSQL = auxSQL & " LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = BS.COD_CLIENTE) "
		auxSQL = auxSQL & " LEFT OUTER JOIN PRJ_PROJETO PRJ ON (BS.COD_PROJETO = PRJ.COD_PROJETO) "
		auxSQL = auxSQL & " LEFT OUTER JOIN TL_CATEGORIA TLCAT ON (TL.COD_CATEGORIA = TLCAT.COD_CATEGORIA) "
        
		auxSQL = auxSQL & " WHERE TL.SITUACAO <> 'FECHADO' "
		If prULTIMAS <> "" And auxDATA <> "" Then
			auxSQL = auxSQL & " AND TL.PREV_DT_INI BETWEEN '" & auxDATA & "' AND '" & prIN_DATA & "' " 
		Else
			auxSQL = auxSQL & " AND TL.PREV_DT_INI <= '" & prIN_DATA & "' " 
		End If
		auxSQL = auxSQL & " AND BS.TIPO = 'NORMAL' "
		auxSQL = auxSQL & " AND BS.COD_BOLETIM IN (SELECT DISTINCT COD_BOLETIM FROM BS_EQUIPE WHERE ID_USUARIO = '" & prIN_ID_USUARIO & "' ) "
		
		auxSQL = auxSQL & " ORDER BY PRJ.TITULO, PRJ.COD_PROJETO, BS.TITULO, BS.COD_BOLETIM, TL.TITULO, TL.COD_TODOLIST "
		auxSQL = auxSQL & " LIMIT " & prLIMIT
    END IF	
	
    MontaSQLBuscaPAT = auxSQL
 End Function
 ' ---------------------------------------------------------------------------------------------
 ' FIM: MontaSQLBuscaPAT -------------------------------------------------------------------------
 ' ---------------------------------------------------------------------------------------------
 
 const PRJ_COD  = 0
 const PRJ_TIT  = 1
 const PRJ_FASE = 2
 
 const ATIV_COD        = 3
 const ATIV_TIT        = 4
 const ATIV_COD_CLI    = 5
 const ATIV_CLI        = 6
 const ATIV_RESP       = 7
 const ATIV_SIT        = 8
 const ATIV_DT_INI     = 9
 const ATIV_DT_FIM     = 10
 const ATIV_PREV_HORAS = 11
 const ATIV_HORAS      = 12
 const ATIV_NA_EQUIPE  = 13
 
 const TASK_COD    = 14
 const TASK_TIT    = 15
 const TASK_RESP   = 16
 const TASK_EXEC   = 17
 const TASK_CATEG  = 18
 const TASK_DT_INI = 19
 const TASK_HR_INI = 20
 const TASK_HORAS  = 21
 const TASK_SIT    = 22
 const TASK_PRIO   = 23
 
 dim matRS()
 dim intTAMlin, intTAMcol
 dim i,strUSUARIO
 
 If CFG_DB = "vboss_girardi" Then
	intTAMlin = 15
 Else
 	intTAMlin = 250
 End If
 intTAMcol = 23
 redim matRS(intTAMcol,intTAMlin)

 strSQL = MontaSQLBuscaPAT(PrepDataBrToUni(strDIA_SEL2, False), strUSER_ID, strVIEW, intTAMlin, strULTIMAS)
 'strSQL = " CALL sp_busca_pat('" & PrepDataBrToUni(strDIA_SEL2, False) & "', '" & strUSER_ID & "', '" & strVIEW & "') "
 
 'athDebug strSQL, false
 
 Set objRS = objConn.Execute(strSQL)
 
 i = 0
 Do While Not objRS.Eof
	while (Not objRS.Eof) And (GetValue(objRS,"TL_SITUACAO")="OCULTO" and strGRUPO_USUARIO<>"MANAGER" and LCase(GetValue(objRS,"BS_ID_RESPONSAVEL"))<>strUSER_ID and LCase(GetValue(objRS,"TL_ID_RESPONSAVEL"))<>strUSER_ID)
	  athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	wend
	
  	matRS(PRJ_COD ,i) = GetValue(objRS, "COD_PROJETO")
  	matRS(PRJ_TIT ,i) = GetValue(objRS, "PRJ_TITULO")
  	matRS(PRJ_FASE,i) = GetValue(objRS, "PRJ_FASE_ATUAL")
	
  	matRS(ATIV_COD       ,i) = GetValue(objRS, "COD_BOLETIM")
  	matRS(ATIV_TIT       ,i) = GetValue(objRS, "BS_TITULO")
  	matRS(ATIV_COD_CLI   ,i) = GetValue(objRS, "COD_CLIENTE")
	matRS(ATIV_CLI       ,i) = GetValue(objRS, "CLIENTE")
  	matRS(ATIV_RESP      ,i) = GetValue(objRS, "BS_ID_RESPONSAVEL")
  	matRS(ATIV_SIT       ,i) = GetValue(objRS, "BS_SITUACAO")
  	matRS(ATIV_DT_INI    ,i) = GetValue(objRS, "BS_DT_INI") 
	matRS(ATIV_DT_FIM    ,i) = GetValue(objRS, "BS_DT_FIM") 
	matRS(ATIV_PREV_HORAS,i) = GetValue(objRS, "BS_TOT_PREV_HORAS")
	matRS(ATIV_HORAS     ,i) = GetValue(objRS, "BS_TOT_HORAS")
	matRS(ATIV_NA_EQUIPE ,I) = GetValue(objRS, "BS_NA_EQUIPE")
	
  	matRS(TASK_COD   ,i) = GetValue(objRS, "COD_TODOLIST")
  	matRS(TASK_TIT   ,i) = GetValue(objRS, "TL_TITULO")
  	matRS(TASK_RESP  ,i) = GetValue(objRS, "TL_ID_RESPONSAVEL")
  	matRS(TASK_EXEC  ,i) = GetValue(objRS, "TL_ID_ULT_EXECUTOR")
	matRS(TASK_CATEG ,i) = GetValue(objRS, "TL_CATEGORIA")
  	matRS(TASK_DT_INI,i) = GetValue(objRS, "TL_PREV_DT_INI")
  	matRS(TASK_HR_INI,i) = GetValue(objRS, "TL_PREV_HR_INI")
  	matRS(TASK_HORAS ,i) = GetValue(objRS, "TL_PREV_HORAS")
  	matRS(TASK_SIT   ,i) = GetValue(objRS, "TL_SITUACAO")
  	matRS(TASK_PRIO  ,i) = GetValue(objRS, "TL_PRIORIDADE")
	
  	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	
	i = i + 1
  Loop
  
  intTamNew = i-1
  redim preserve matRS(intTAMcol,intTamNew) 
  
  FechaRecordSet objRS

%>
<script language="javascript"> 
function ShowArea(prCodigo1, prCodigo2)
{
	if (document.getElementById(prCodigo1).style.display == 'none') {
		document.getElementById(prCodigo1).style.display = 'block';
		document.getElementById(prCodigo2).src = '../img/BulletMenos.gif';
	}
	else { 
		document.getElementById(prCodigo1).style.display = 'none';
		document.getElementById(prCodigo2).src = '../img/BulletMais.gif';
	}
}
</script>
					<table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:10px;">
					<tr>
						<td width="100%" height="30%">
							<!-- Moldura C INIC -->
							<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>">
							<tr>
								<td colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
								  <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
								    <tr>
									  <td width="315" style="border-bottom:1px solid <%=strBGCOLOR1%>"><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_TODOLIST/default.htm" target="vbNucleo">Tarefas</a></b></div></td>
										 <!--<td width="610" nowrap="nowrap" align="right" style="text-align:right; border-bottom:1px solid <%'=strBGCOLOR1%>">últimas <%'=intTAMlin%> não fechadas até o dia <%'=strDIA_SEL2%>, onde sou</td>-->
										 <td width="610" nowrap="nowrap" align="right" style="text-align:right; border-bottom:1px solid <%=strBGCOLOR1%>">últimas <%=intTAMlin%> não fechadas em <select name="var_ultimas" id="var_ultimas" style="width:80px;" 
onchange="ReloadPage();" class="edtext_combo">
	<option value="7D"  <% If strULTIMAS = "7D"  Then Response.Write(" selected='selected'") %>>7 dias</option>
	<option value="14D" <% If strULTIMAS = "14D" Then Response.Write(" selected='selected'") %>>14 dias</option>
	<option value="1M"  <% If strULTIMAS = "1M"  Then Response.Write(" selected='selected'") %>>1 mês</option>
	<option value="3M"  <% If strULTIMAS = "3M"  Then Response.Write(" selected='selected'") %>>3 meses</option>
	<option value="6M"  <% If strULTIMAS = "6M"  Then Response.Write(" selected='selected'") %>>6 meses</option>
	<option value="12M" <% If strULTIMAS = "12M" Then Response.Write(" selected='selected'") %>>1 ano</option>
	<option value="24M" <% If strULTIMAS = "24M" Then Response.Write(" selected='selected'") %>>2 anos</option>
</select> até o dia <%=strDIA_SEL2%>, onde sou</td>
										 <td width="114" align="right" style=" border-bottom:1px solid <%=strBGCOLOR1%>">
										 	<div style="align:right; padding-right:3px; padding-left:6px;">
												<select name="var_view" class="edtext_combo" style="width:120px;" onchange="ReloadPage();">
													<option value="resp"   <% if strVIEW = "resp"   then Response.Write(" selected") %>>Responsável</option>
													<option value="exec"   <% if strVIEW = "exec"   then Response.Write(" selected") %>>Executor</option>
													<option value="equipe" <% if strVIEW = "equipe" then Response.Write(" selected") %>>Equipe</option>
													<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER" Then %>
														<option value="all" <% if strVIEW = "all" then Response.Write(" selected") %>></option>
													<% End If %>
												</select>
											</div>
									  </td>
									</tr>
								  </table>								
								</td>
							</tr>
							<tr>
								<td align="center" bgcolor="<%=strBGCOLOR2%>">
								<div style="padding-top:4px; padding-bottom:4px;">
<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
<tr>
	<td align="left" bgcolor="<%=strBGCOLOR2%>">
<%
  Dim strCOD_PROJETO, strCOD_PROJETO_Old
  Dim strCOD_BS, strCOD_BS_Old
  Dim strCOD_TODOLIST
  
  strCOD_PROJETO = ""
  strCOD_PROJETO_Old = "-1"
  strCOD_BS = ""
  strCOD_BS_Old = "-1"
  
  for i=0 to intTamNew
  	strCOD_PROJETO  = matRS(PRJ_COD,i)
	strCOD_BS       = matRS(ATIV_COD,i)
	strCOD_TODOLIST = matRS(TASK_COD,i)
	
	If (strCOD_TODOLIST <> "") Then
		If (strCOD_PROJETO <> strCOD_PROJETO_Old) Then 
			If strCOD_BS_Old <> "-1" Then Response.Write("</table><!--ativ_" & strCOD_BS_Old & "--></div>" & vbNewLine)
			If strCOD_PROJETO_Old <> "-1" Then Response.Write("<!--prj_" & strCOD_PROJETO_Old & "--></div>" & vbNewLine)
			
			Response.Write(ExibePROJETO(strCOD_PROJETO, matRS(PRJ_TIT,i), matRS(PRJ_FASE,i)))
			Response.Write(ExibeBS(strCOD_BS, matRS(ATIV_TIT,i), matRS(ATIV_COD_CLI,i), matRS(ATIV_CLI,i), matRS(ATIV_RESP,i), matRS(ATIV_SIT,i), matRS(ATIV_DT_INI,i), matRS(ATIV_DT_FIM,i), matRS(ATIV_PREV_HORAS,i), matRS(ATIV_HORAS,i), matRS(ATIV_NA_EQUIPE,i)))
			Response.Write(ExibeTODOLIST(strCOD_TODOLIST, matRS(TASK_TIT,i), matRS(TASK_RESP,i), matRS(TASK_EXEC,i), matRS(TASK_CATEG,i), matRS(TASK_DT_INI,i), matRS(TASK_HR_INI,i), matRS(TASK_HORAS,i), matRS(TASK_SIT,i), matRS(TASK_PRIO,i), strCOD_BS, True))
			
			strCOD_PROJETO_Old = strCOD_PROJETO
			strCOD_BS_Old = strCOD_BS
		Else
			If (strCOD_BS <> strCOD_BS_Old) Then
				If strCOD_BS_Old <> "-1" Then Response.Write("</table><!--ativ_" & strCOD_BS_Old & "--></div>" & vbNewLine)
				
				Response.Write(ExibeBS(strCOD_BS, matRS(ATIV_TIT,i), matRS(ATIV_COD_CLI,i), matRS(ATIV_CLI,i), matRS(ATIV_RESP,i), matRS(ATIV_SIT,i), matRS(ATIV_DT_INI,i), matRS(ATIV_DT_FIM,i), matRS(ATIV_PREV_HORAS,i), matRS(ATIV_HORAS,i), matRS(ATIV_NA_EQUIPE,i)))
				Response.Write(ExibeTODOLIST(strCOD_TODOLIST, matRS(TASK_TIT,i), matRS(TASK_RESP,i), matRS(TASK_EXEC,i), matRS(TASK_CATEG,i), matRS(TASK_DT_INI,i), matRS(TASK_HR_INI,i), matRS(TASK_HORAS,i), matRS(TASK_SIT,i), matRS(TASK_PRIO,i), strCOD_BS, True))
				
				strCOD_BS_Old = strCOD_BS
			Else
				Response.Write(ExibeTODOLIST(strCOD_TODOLIST, matRS(TASK_TIT,i), matRS(TASK_RESP,i), matRS(TASK_EXEC,i), matRS(TASK_CATEG,i), matRS(TASK_DT_INI,i), matRS(TASK_HR_INI,i), matRS(TASK_HORAS,i), matRS(TASK_SIT,i), matRS(TASK_PRIO,i), strCOD_BS, False))
			End If
		End If
	Else
		Exit For
	End If
  next
  If strCOD_BS_Old <> "-1" Then Response.Write("</table><!--ativ_" & strCOD_BS_Old & "--></div>" & vbNewLine)
  If strCOD_PROJETO_Old <> "-1" Then Response.Write("<!--prj_" & strCOD_PROJETO_Old & "--></div>" & vbNewLine)
%>
	</td>
</tr>
</table>
								</div>
								</td>
							</tr>
							</table>
							<!-- Moldura C FIM -->						
						</td>
					</tr>
					</table>