<%
strUSER_ID = LCase(GetParam("var_usuario"))
strDIA_SEL = GetParam("var_dia_selected")
strVIEW = GetParam("var_view")

if (strDIA_SEL="") then strDIA_SEL = date
if (strUSER_ID="") then strUSER_ID = LCase(request.Cookies("VBOSS")("ID_USUARIO"))


strSQL =	"SELECT" 																			&_
			"	T1.COD_TODOLIST," 																&_
			"	T1.COD_BOLETIM," 																&_
			"	T1.ARQUIVO_ANEXO," 																&_
			"	T1.ID_RESPONSAVEL," 															&_
			"	T4.ID_RESPONSAVEL AS BS_RESPONSAVEL," 											&_
			"	T4.TITULO AS BS_TITULO," 														&_
			"	T5.NOME_FANTASIA," 																&_
			"	T5.COD_CLIENTE," 																&_
			"	T1.ID_ULT_EXECUTOR," 															&_ 
			"	T1.SYS_DTT_ALT," 																&_
			"	T1.TITULO," 																	&_
			"	T1.SITUACAO," 																	&_
			"	T1.PREV_DT_INI," 																&_
			"	T1.PREV_HR_INI," 																&_
			"	T1.PREV_HORAS," 																&_
			"	T1.PRIORIDADE," 																&_
			"	T2.NOME," 																		&_
			"	COUNT(T3.COD_TL_RESPOSTA) AS TOTAL " 											&_
			"FROM ((((" 																		&_
			"	TL_TODOLIST T1 " 																&_
			"LEFT OUTER JOIN TL_CATEGORIA	T2 ON (T1.COD_CATEGORIA	= T2.COD_CATEGORIA)) "	&_
			"LEFT OUTER JOIN TL_RESPOSTA 	T3 ON (T1.COD_TODOLIST	= T3.COD_TODOLIST)) " 	&_
			"LEFT OUTER JOIN BS_BOLETIM 	T4 ON (T1.COD_BOLETIM	= T4.COD_BOLETIM)) " 	&_
			"LEFT OUTER JOIN ENT_CLIENTE 	T5 ON (T4.COD_CLIENTE	= T5.COD_CLIENTE)) " 	&_
			"WHERE" 																		&_
			"	((T1.SITUACAO <> 'FECHADO') AND (T1.SITUACAO <> 'CANCELADO')) AND "      	&_
			"	(T4.MODELO<>TRUE OR T4.MODELO IS NULL) AND " 								&_
			"	((T1.PREV_DT_INI IS NOT NULL) AND " 										&_
			"	(T1.PREV_DT_INI <= #" & PrepData(strDIA_SEL,false,false) & "# )) AND "

if strVIEW="" then 
	strSQL = strSQL & " (T1.ID_ULT_EXECUTOR='" & strUSER_ID & "') "
else 
	strSQL = strSQL & " (T1.ID_RESPONSAVEL ='" & strUSER_ID & "') "
end if

strSQL = strSQL  &_
			"GROUP BY" 													&_
			"	T1.COD_TODOLIST," 										&_
			"	T1.COD_BOLETIM," 										&_
			"	T1.ID_RESPONSAVEL," 									&_
			"	T1.ID_ULT_EXECUTOR," 									&_
			"	T1.SYS_DTT_ALT," 										&_
			"	T1.TITULO," 											&_
			"	T1.ARQUIVO_ANEXO," 										&_
			"	T1.SITUACAO," 											&_
			"	T1.PREV_DT_INI," 										&_
			"	T1.PREV_HR_INI," 										&_
			"	T1.PREV_HORAS," 										&_
			"	T1.PRIORIDADE," 										&_
			"	T2.NOME," 												&_
			"	T4.ID_RESPONSAVEL," 									&_
			"	T4.TITULO," 											&_
			"	T5.COD_CLIENTE," 										&_
			"	T5.NOME_FANTASIA " 										&_
			"ORDER BY" 													&_
			"	T1.PREV_DT_INI," 										&_
			"	T1.PREV_HR_INI,"										&_
			"	T1.TITULO"
AbreRecordSet objRS, strSQL, objConn, adOpenDynamic
 
Sub Grade(prTipo)
dim lcont,lmaxr, auxBgColor
dim lauxStr1, lauxStr2, lauxStr3
dim strCOD_BS, strCOD_TODOLIST
dim strBS_TITULO, strPREV_HS
	lcont = 0
	lmaxr = 10000
   
	if prTipo="short" then
		if Not objRS.EOF then 
			objRS.MoveFirst
		else
			response.write("<tr><td colspan='12' height='1' align='center'><b>Não há tarefas para este período</b></td></tr>")
			Exit sub
		End if 
		lmaxr=5 
	end if
	'auxBgColor=strBGCOLOR5
	
   lauxStr1 = "align='center' valign='middle' class='arial11'"
'  lauxStr2 = "align='left'   valign='middle' class='arial11'"
   lauxStr3 = "align='right'  valign='middle' class='arial11'"

	'OCULTO aparece SOMENTE para MANAGER, RESPONSAVEL pelo BS ou RESPONSAVEL pela TAREFA
	while (GetValue(objRS,"SITUACAO")="OCULTO" and Request.Cookies("VBOSS")("GRUPO_USUARIO")<>"MANAGER" and LCase(GetValue(objRS,"BS_RESPONSAVEL"))<>strUSER_ID and LCase(GetValue(objRS,"ID_RESPONSAVEL"))<>strUSER_ID)
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	wend
	
	if not objRS.eof then			 

		Do While Not objRS.Eof and lcont < lmaxr	
			
			strCOD_TODOLIST	= ""
			strBS_TITULO		= ""
			strCOD_BS			= ""
			strPREV_HS			= ""

			if GetValue(objRS,"PREV_HORAS")<>"" then strPREV_HS = FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))
			
			if GetValue(objRS,"COD_BOLETIM")<>"" and GetValue(objRS,"COD_BOLETIM")<>"0" then 
				strCOD_BS = GetValue(objRS,"COD_BOLETIM") & "."
				strBS_TITULO = "Atividade: " & GetValue(objRS,"BS_TITULO")
			end if
			if GetValue(objRS,"COD_TODOLIST")<>"" then strCOD_TODOLIST = GetValue(objRS,"COD_TODOLIST")
			
			auxBgColor="#FFFFF0"
			if IsDate(GetValue(objRS,"PREV_DT_INI")) then
				if (GetValue(objRS,"SITUACAO")<>"FECHADO") then
					if (GetValue(objRS,"PREV_DT_INI")<Now) then auxBgColor = "#FFF0F0"
					if (GetValue(objRS,"PREV_DT_INI")=Date) then auxBgColor = "#FFFFF0"
				end if
			else
				auxBgColor = "#FFFFFF"
			end if
			
			response.write "<tr bgcolor=" & auxBgColor & " class='arial11' valign='middle'>" 
			response.write "	<td align='center' style='cursor:hand;'>"
			
			if LCase(GetValue(objRS,"ID_RESPONSAVEL"))=strUSER_ID and CInt("0" & GetValue(objRS,"TOTAL"))<1 then
				response.write "<a href='../modulo_TODOLIST/Update.asp?var_chavereg=" & GetValue(objRS,"COD_TODOLIST") & "'><img src='../img/IconAction_EDIT.gif' border='0' title='ALTERAR'></a>"	  
			end if
			response.write "	</td>"
			response.write "	<td align='center' style='cursor:hand;'>"

			If LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))=strUSER_ID or LCase(GetValue(objRS,"ID_RESPONSAVEL"))=strUSER_ID then
				if GetValue(objRS,"COD_BOLETIM")<>"" and GetValue(objRS,"COD_BOLETIM")<>"0" then
				  response.write "<a href='../modulo_BS/DetailHistoricoToDo.asp?var_chavereg=" & GetValue(objRS,"COD_TODOLIST") & "&var_resposta=true&var_codigo=" & GetValue(objRS,"COD_BOLETIM") & "'><img src='../img/IconAction_DETAILadd.gif' border='0' title='HISTÓRICO COM INSERÇÃO'></a>"
				else
				  response.write "<a href='../modulo_TODOLIST/DetailHistorico.asp?var_chavereg=" & GetValue(objRS,"COD_TODOLIST") & "&var_resposta=true'><img src='../img/IconAction_DETAILadd.gif' border='0' title='HISTÓRICO COM INSERÇÃO'></a>"
				end if
			End if
			
			response.write "	</td>"
			response.write "	<td>" & PrepData(GetValue(objRS,"PREV_DT_INI"),true,false) & "</td>"
			response.write "	<td>" & GetValue(objRS,"PREV_HR_INI") & "</td>"	 
			response.write "	<td>" & UCase(GetValue(objRS,"NOME")) & "</td>"
			response.write "	<td align='right' title='" & strBS_TITULO & "' style='cursor:default;'>" & strCOD_BS & strCOD_TODOLIST & "</td>"
			response.write "	<td>" & GetValue(objRS,"TITULO") & "</td>"
			response.write "	<td>" & LCase(GetValue(objRS,"ID_RESPONSAVEL"))  & "</td>"
'			response.write "	<td>" & LCase(GetValue(objRS,"ID_ULT_EXECUTOR")) & "</td>"
			response.write "	<td align='right'>" & strPREV_HS & "</td>"
			response.write "	<td align='center' height='20'><img src='../img/IconStatus_" & GetValue(objRS,"SITUACAO") & ".gif'  title='SITUAÇÃO: " & GetValue(objRS,"SITUACAO") & "'></td>"
			response.write "	<td align='center'><img src='../img/IconPrio_" & GetValue(objRS,"PRIORIDADE") & ".gif' title='PRIORIDADE: " & GetValue(objRS,"PRIORIDADE") & "'></td>"

'			response.write "<td " & lauxStr1 & " height='20'>"
'			if GetValue(objRS,"COD_BOLETIM")>"0" then  
'				response.write "<img src='../img/IconStatus_BS.gif' alt='BS: " & GetValue(objRS,"COD_BOLETIM") & " - " & GetValue(objRS,"BS_TITULO") & "'>"  
'			end if		
'			response.write "	</td>"

			response.write "	<td align='center' height='20'>"			
			
			if GetValue(objRS,"COD_BOLETIM")>"0" then 
				response.write "	<a href='../modulo_CLIENTE/Detail.asp?var_chavereg="& GetValue(objRS,"COD_CLIENTE") &"'><img src='../img/IconStatus_Client.gif' border='0' title='CLIENTE: " & GetValue(objRS,"NOME_FANTASIA") & "'></a>"						
			end if
			
			response.write "	</td>"
			response.write "</tr>"
			
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			
			while (GetValue(objRS,"SITUACAO")="OCULTO" and Request.Cookies("VBOSS")("GRUPO_USUARIO")<>"MANAGER" and LCase(GetValue(objRS,"BS_RESPONSAVEL"))<>strUSER_ID and LCase(GetValue(objRS,"ID_RESPONSAVEL"))<>strUSER_ID)
			  athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			wend

			lcont = lcont + 1
		Loop
	end if
End Sub
%>
<table width="98%" cellpadding="0" cellspacing="0" border="0">
<tr>
  <td width="99%" height="100%" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td align="center" bgcolor="<%=strBGCOLOR2%>" valign="top">
				  <div style="padding-top:4px; padding-bottom:4px;">
					<table width="98%" cellpadding="2" cellspacing="2" border="0">
						<tr bgcolor="<%=strBGCOLOR5%>">
							<td width="1%" height="16"></td>
							<td width="1%"></td>
							<td width="1%" nowrap>DatA</td>
							<td width="1%" nowrap>Hr</td>							
							<td width="1%">Categoria</td>
							<td width="1%">Cod</td>							
							<td width="89%">Título</td>
							<td width="1%" nowrap>Resp</td>
							<%'td width="1%" nowrap>Exec</td%>
							<td width="1%" nowrap>Prev Hs</td>
							<td width="1%"></td>							
							<td width="1%"></td>				
							<td width="1%"></td>											
						</tr>
						<tr><td colspan="12" height="1" bgcolor="<%=strBGCOLOR6%>"></td></tr>
						<%Grade("short")%>
						<tr><td colspan="4" height="1"></td></tr>
					</table>
				  </div>
				</td>
			  <td width="160" height="100%" valign="top"><iframe name="vboss_frpainelcalendar" src="../modulo_PAINEL/Box_Calendar.asp?var_dia_selected=<%=strDIA_SEL%>&var_view=<%=strVIEW%>" width="160" frameborder="0"></iframe></td>
			</tr>
		</table>
	</td>
</tr>
<tr>
  <td colspan="2" height="100%" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td align="center" bgcolor="<%=strBGCOLOR2%>">
					<div style="padding-top:4px; padding-bottom:4px;">
						<table width="98%" cellpadding="2" cellspacing="2" border="0">
							<tr bgcolor="<%=strBGCOLOR2%>">
								<td width="1%" align="center" height="1"></td>
								<td width="1%"></td>
								<td width="1%" nowrap><%'Prev Ini%></td>
								<td width="1%" nowrap><%'Prev Fim%></td>								
								<td width="1%"><%'Categoria%></td>
								<td width="1%"><%'ToDo%></td>								
								<td width="90%"><%'Título%></td>
								<td width="1%" nowrap><%'Resp%></td>
								<%'td width="1%" nowrap><%'Exec></td%>
								<td width="1%"></td>
								<td width="1%"></td>
								<td width="1%"></td>												
								<td width="1%"></td>																				
							</tr>
							<tr><td colspan="12" height="1" bgcolor="<%=strBGCOLOR2%>"></td></tr>
							<%Grade("long")%>
							<tr><td colspan="4" height="15"></td></tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
  </td>
</tr>
</table>
<%
 FechaRecordSet objRS 
%>