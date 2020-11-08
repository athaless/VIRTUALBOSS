<%
 strUSER_ID = GetParam("var_user_id")
 strSEMANA  = GetParam("var_semana") 'Recebe o número de semanas a adicionar
 
 If strUSER_ID = "" Then strUSER_ID = Request.Cookies("VBOSS")("ID_USUARIO")
 If strSEMANA = "" Or Not IsNumeric(strSEMANA) Then strSEMANA = 0
 
 'Para exibir tabela de ocupação/alocação em até 12hs
 strESCALA_FATOR = 2
 strESCALA_REGUA = "../img/regua_ocupacao12h.gif"
 
 'Para exibir tabela de ocupação/alocação em até 24hs
 'strESCALA_FATOR = 1
 'strESCALA_REGUA = "../img/regua_ocupacao24h.gif"
 
   Function DiaSemana(prDiaSemana)
	select case prDiaSemana
		case "1" DiaSemana = "dom"
		case "2" DiaSemana = "seg"
		case "3" DiaSemana = "ter"
		case "4" DiaSemana = "qua"
		case "5" DiaSemana = "qui"
		case "6" DiaSemana = "sex"
		case "7" DiaSemana = "sab"
		case else DiaSemana = ""
	end select
   End function

   Sub BuscaDadosPrevistos(prID_USUARIO, prDIA_SEMANA, byRef prTOTAL, byRef prEMPRESA)
  	Dim objRSPrev
	
	prTOTAL = ""
	prEMPRESA = ""
	
	If prID_USUARIO <> "" Then
	  	Set objRSPrev = objConn.Execute("SELECT TOTAL FROM USUARIO_HORARIO WHERE ID_USUARIO = '" & prID_USUARIO & "' AND DIA_SEMANA = '" & UCase(prDIA_SEMANA) & "'")
		If Not objRSPrev.Eof Then prTOTAL = GetValue(objRSPrev, "TOTAL")
		FechaRecordSet objRSPrev
		
	  	Set objRSPrev = objConn.Execute("SELECT DISTINCT T2.COD_CLIENTE, T2.NOME_COMERCIAL FROM USUARIO_HORARIO T1, ENT_CLIENTE T2 WHERE T1.ID_USUARIO = '" & prID_USUARIO & "' AND T1.DIA_SEMANA = '" & UCase(prDIA_SEMANA) & "' AND T1.COD_EMPRESA = T2.SIGLA_PONTO ")
		Do While Not objRSPrev.Eof
			If Not objRSPrev.Eof Then prEMPRESA = prEMPRESA & GetValue(objRSPrev, "NOME_COMERCIAL") & ", "
			objRSPrev.MoveNext
		Loop
		FechaRecordSet objRSPrev
		If prEMPRESA <> "" Then prEMPRESA = Mid(prEMPRESA, 1, Len(prEMPRESA)-2)
	End If
  End Sub

 Sub ExibeINFO_USUARIO(prID_USUARIO)
	Response.Write "<table width='99%' height='20' bgcolor='#E9E9E9' cellpadding='2' cellspacing='0'>" & vbNewLine
	Response.Write "<tr>" & vbNewLine
	Response.Write "<td width='16' align='center'><a href=""Javascript: ShowArea('usr_" & prID_USUARIO & "', 'icon_usr_" & prID_USUARIO & "');"">"
	Response.Write "<img src='../img/BulletMenos.gif' border='0' align='absmiddle' name='icon_usr_" & prID_USUARIO & "' id='icon_usr_" & prID_USUARIO & "'></a></td>" & vbNewLine
	Response.Write "<td><b>" & prID_USUARIO & "</b></td>" & vbNewLine
	Response.Write "</tr>" & vbNewLine
	Response.Write "</table>" & vbNewLine
	Response.Write "<div id='usr_" & prID_USUARIO & "' style='padding:0px;'>" & vbNewLine
 End Sub
 
 Sub ExibeOCUPACAO(prDIA_SEMANA, prOCUPACAOexp, prOCUPACAOprev, prDIA, prEXPEDIENTE, prPREVISTO, prLIVRE, prEMPRESA, prESCALA, prFOTO, prCABECALHO)
	Dim Cont, Delta
	Dim strLARGURAexp, strLARGURAprev
	Dim strCorPrev
	
	strLARGURAexp = 0
	strLARGURAprev = 0
	
	If prOCUPACAOexp > 0 Then strLARGURAexp = Round(((prOCUPACAOexp * 60) / 5) * prESCALA)
	If prOCUPACAOprev > 0 Then strLARGURAprev = Round(((prOCUPACAOprev * 60) / 5) * prESCALA)
	
	If prCABECALHO Then
		Response.Write "<table width='99%' height='20' bgcolor='#FFFFFF' cellpadding='1' cellspacing='1' border='0'>" & vbNewLine
		Response.Write "<tr bgcolor='#EFEDED' class='arial11' valign='middle'>" & vbNewLine
		Response.Write "  <td width='16' bgcolor='#FFFFFF' valign='top'></td>" & vbNewLine
		Response.Write "  <td width='20' nowrap></td>" & vbNewLine
		Response.Write "  <td width='40'></td>" & vbNewLine
		Response.Write "  <td width='288' nowrap>Gráfico de ocupação prevista</td>" & vbNewLine
		Response.Write "  <td style='text-align:right' width='40'>Livre</td>" & vbNewLine
		Response.Write "  <td style='text-align:right' width='40'>Alocado</td>" & vbNewLine
		Response.Write "  <td style='text-align:right' width='40'>Expediente</td>" & vbNewLine

		Response.Write "  <td align='right' style='text-align:right'>"
		If prFOTO <> "" Then 
		  Response.Write "<div style='width:50%px; height:16px; position:relative; overflow:visible; border:0px solid #FFC9E1;'><br /><br />"
		  Response.Write "<img src='" & prFOTO & "' height='140' />"
		  Response.Write "</div>"
		End If  
		Response.Write "  </td>" & vbNewLine
		
		Response.Write "</tr>" & vbNewLine
		'Linha fina e escura
		Response.Write "<tr>" & vbNewLine
		Response.Write "  <td></td>" & vbNewLine
		Response.Write "  <td colspan='8' height='1' bgcolor='#C9C9C9'></td>" & vbNewLine
		Response.Write "</tr>" & vbNewLine
	End If
	
	Response.Write "<tr class='arial11' valign='middle'>" & vbNewLine
	Response.Write "  <td width='16' bgcolor='#FFFFFF'></td>" & vbNewLine
	Response.Write "  <td width='20' style='text-align:left' valign='top'>" & prDIA_SEMANA & "</td>" & vbNewLine
	Response.Write "  <td width='40' style='text-align:left' valign='top'>" & prDIA & "</td>" & vbNewLine
	Response.Write "  <td width='288' height='16' style='text-align:left' valign='top'>"
	
	Delta = strLARGURAexp - strLARGURAprev
    strCorPrev = "#DBE8EE" ' Azulado (azulado)
	If Delta <= 0 Then
		If (strLARGURAprev >= strLARGURAexp) Then
		  strCorPrev = "#FEC1C0" ' Vermelho (rosa)
		End If

		If strLARGURAprev > 288 Then  strLARGURAprev = 288	End If
		Response.Write "<div style='width:" & strLARGURAprev & "px; height:16px; display:inline-block; float:left; background-color:" & strCorPrev & ";'></div>"
	Else
		If (strLARGURAprev + Delta) <= 288 Then
			If (strLARGURAprev >= (strLARGURAexp * 0.75)) Then
	        	strCorPrev = "#F7DE8A" ' Amarelo (alaranjado)
			End If
			Response.Write "<div style='width:" & strLARGURAprev & "px; height:16px; display:inline-block; float:left; background-color:" & strCorPrev & ";'></div>"
			Response.Write "<div style='width:" & Delta & "px; height:16px; display:inline-block; float:left; background-color:#EEFDEA;'></div>"
		Else
			Response.Write "<div style='width:288px; height:16px; display:inline-block; float:left; background-color:#FFFFFF; text-align:center;'>Expediente > 24hs</div>"
		End If
	End If
	
	Response.Write "</td>" & vbNewLine
	Response.Write "  <td width='40' style='text-align:right' valign='top'>&nbsp;" & prLIVRE & "&nbsp;</td>" & vbNewLine
	Response.Write "  <td width='40' style='text-align:right' valign='top'>&nbsp;" & prPREVISTO & "&nbsp;</td>" & vbNewLine
	Response.Write "  <td width='40' style='text-align:right' valign='top'>&nbsp;" & prEXPEDIENTE & "&nbsp;</td>" & vbNewLine
	Response.Write "  <td style='text-align:left' valign='top'>&nbsp;" & prEMPRESA & "</td>" & vbNewLine
	Response.Write "</tr>" & vbNewLine
	
	'Fechamento pot fora
	'Response.Write "</table>" & vbNewLine
 End Sub
 
 Function ConvHorasEmSeg(prVALOR)
 	Dim strHORA, strMIN, strSEG
	
	If prVALOR <> "" Then
		strHORA = Mid(prVALOR, 1, 2)
		strMIN = Mid(prVALOR, 4, 2)
		strSEG = Mid(prVALOR, 7, 2)
		
		ConvHorasEmSeg = strHORA + (strMIN / 60) + (strSEG / 3600)
	Else
		ConvHorasEmSeg = ""
	End If
 End Function

%>
<style type="text/css">
<!--
#Layer1 {
	position:absolute;
	left:1146px;
	top:42px;
	width:95px;
	height:60px;
	z-index:1;
}
-->
</style>
<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
<tr>
	<td width="100%" height="30%">
		<!-- Moldura C INIC -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>">
		<tr>
			<td colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
				<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="315" style="border-bottom:1px solid <%=strBGCOLOR1%>"><div style="padding-left:3px; padding-right:3px;"><b>Ocupação</b></div></td>
					<td width="630" nowrap="nowrap" align="right" style="text-align:right; border-bottom:1px solid <%=strBGCOLOR1%>"></td>
					<td width="114" align="right" style=" border-bottom:1px solid <%=strBGCOLOR1%>">
					<div style="align:right; padding-right:3px; padding-left:6px;">
						<select name="var_user_id" class="edtext_combo" style="width:105px;" onchange="ReloadPage();">
						<% montaCombo "STR", " SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL AND TIPO = '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "' AND GRP_USER <> 'SU' ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", strUSER_ID %>
						</select>
					</div>
					</td>
					<td width="134" align="right" style=" border-bottom:1px solid <%=strBGCOLOR1%>">
					<div style="align:right; padding-right:3px; padding-left:3px;">
						<select name="var_semana" class="edtext_combo" style="width:125px" onchange="ReloadPage();">
							<option value="-1" <% if strSEMANA = "-1" then response.write("selected")%>>Semana anterior</option>
							<option value="0" <%  if strSEMANA = "0"  then response.write("selected")%>>Semana atual</option>
							<option value="1" <%  if strSEMANA = "1"  then response.write("selected")%>>Próxima semana</option>
							<option value="2" <%  if strSEMANA = "2"  then response.write("selected")%>>Daqui há 2 semanas</option>
							<option value="3" <%  if strSEMANA = "3"  then response.write("selected")%>>Daqui há 3 semanas</option>
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
<%
	'athDebug "Usuário: " & strUSER_ID & "<br>", False
	'athDebug "Semana: " & strSEMANA & "<br>", False
	
	'Montagem dos dias da semana
	if strSEMANA <> "" then
		ReDim arrDias(6)
		ReDim arrHoras(6)
		ReDim arrHorasPrev(6) 
		ReDim arrEmpresasPrev(6) 
		
		datePrinc = DateAdd("w", Cint(strSEMANA)*7, Date)
		intDiaSemana = Weekday(datePrinc)
		
		for i = 0 To 6
			intAux = i - intDiaSemana + 2 'aqui está 2 para tirar a diferença do índice e fazer a semana começar na segunda
			dateArray = DateAdd("d",intAux,datePrinc)
			arrDias(i) = dateArray
			BuscaDadosPrevistos strUSER_ID, DiaSemana(Weekday(dateArray)), totalHoraArray, strEMPRESA
			arrHoras(i) = totalHoraArray
			arrEmpresasPrev(i) = strEMPRESA
		next
		
		'for i = 0 To 6
		'	athDebug "[arrDias(" & i & ") " & arrDias(i) & "]&nbsp;&nbsp;[arrHoras(" & i & ") " & arrHoras(i) & "]<br>", False
		'next
		
		'BUSCA FOTO DO USUARIO
		strFOTO = ""
		
		strSQL = " SELECT FOTO FROM USUARIO WHERE ID_USUARIO = '" & strUSER_ID & "'"
		
		Set objRS = objConn.Execute(strSQL)
		If Not objRS.Eof Then
			If GetValue(objRS, "FOTO") <> "" Then strFOTO = "../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/" & GetValue(objRS, "FOTO")
		End If
		FechaRecordSet objRS
		
		'BUSCA O HORARIO TOTAL DE TAREFAS PARA AQUELA DATA
		strSQL =          " SELECT PREV_DT_INI "
		strSQL = strSQL & "       ,SUM(PREV_HORAS) AS PREV_HORAS "
		strSQL = strSQL & "   FROM TL_TODOLIST  "
		strSQL = strSQL & "  WHERE ID_ULT_EXECUTOR = '" & strUSER_ID & "'"
		strSQL = strSQL & "    AND PREV_DT_INI >= '" & PrepDataBrToUni(arrDias(0),false) & "' "
		strSQL = strSQL & "    AND PREV_DT_INI <= '" & PrepDataBrToUni(arrDias(6),false) & "' "
		strSQL = strSQL & "  GROUP BY 1 "
		strSQL = strSQL & "  ORDER BY 1 "
		
		'athDebug strSQL & "<br><br>", False
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		Set ObjRS = ObjConn.Execute(strSQL) 
		
		While (not ObjRS.BOF) AND (not ObjRS.EOF)
			'athDebug "[Dia " & CStr(GetValue(ObjRS, "PREV_DT_INI") & "") & "]&nbsp;&nbsp;[prev hs ", False
			'athDebug CStr(GetValue(ObjRS, "PREV_HORAS") & "") & "]<br>", False
			
			For i = 0 to 6
				'athDebug "seeking [" & CStr(arrDias(i) & "") & "][" & CStr(GetValue(ObjRS, "PREV_DT_INI") & "") & "]<br>", False
				
				If CStr(arrDias(i) & "") = CStr(GetValue(ObjRS, "PREV_DT_INI") & "") Then
					arrHorasPrev(i) = CStr(GetValue(ObjRS, "PREV_HORAS") & "")
				End If
			Next
			
			ObjRS.MoveNext
		WEnd
		FechaRecordSet objRS
		
		'For i = 0 to 6
		'	athDebug "[arrHorasPrev(" & i & ") " & arrHorasPrev(i) & "]<br>", False
		'Next
		
		ExibeINFO_USUARIO strUSER_ID
		For i = 0 to 6
			strVAL1 = CDbl("0" & ConvHorasEmSeg(arrHoras(i))) 'expediente
			strVAL2 = CDbl("0" & arrHorasPrev(i)) 'previsto
			strVAL3 = strVAL1 - strVAL2
			If strVAL3 < 0 Then strVAL3 = 0
			
			'athDebug "val1: " & strVAL1, False
			'athDebug "&nbsp;&nbsp;val2: " & strVAL2, False
			
			'prDIA_SEMANA, prOCUPACAOexp, prOCUPACAOprev, prDIA, prEXPEDIENTE, prPREVISTO, prLIVRE, prEMPRESA, prESCALA, prCABECALHO
			ExibeOCUPACAO UCase(DiaSemana(Weekday(arrDias(i)))) _
			            , strVAL1 _
						, strVAL2 _
						, arrDias(i) _
						, arrHoras(i) _
						, FormataHoraNumToHHMM(strVAL2) _
						, FormataHoraNumToHHMM(strVAL3) _
						, arrEmpresasPrev(i) _
						, strESCALA_FATOR _
						, strFOTO _
						, (i = 0)
		Next
		Response.Write "<tr>" & vbNewLine
		Response.Write "	<td colspan='3' bgcolor='#FFFFFF'></td>" & vbNewLine
		Response.Write "	<td colspan='5'><img src='" & strESCALA_REGUA & "'></td>" & vbNewLine
		Response.Write "</tr>" & vbNewLine
		Response.Write "</table>" & vbNewLine
	end if
%>
			</div>
			</td>
		</tr>
		</table>
		<!-- Moldura C FIM -->
	</td>
</tr>
</table>