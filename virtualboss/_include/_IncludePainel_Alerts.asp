<%
strDIA_SEL1 = GetParam("var_dia_agenda_selected")

strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
strGRUPO_USUARIO = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))

if (strDIA_SEL1="") then strDIA_SEL1 = date

strSQL =          "SELECT AG_AGENDA.COD_AGENDA, AG_AGENDA.PREV_DT_INI, AG_AGENDA.PREV_HORAS, AG_AGENDA.TITULO, AG_AGENDA.PRIORIDADE, AG_AGENDA.ID_CITADOS, AG_CATEGORIA.NOME, AG_AGENDA.ID_RESPONSAVEL"
strSQL = strSQL & "  FROM AG_AGENDA INNER JOIN AG_CATEGORIA ON (AG_AGENDA.COD_CATEGORIA = AG_CATEGORIA.COD_CATEGORIA)"
strSQL = strSQL & " WHERE AG_AGENDA.SITUACAO <> 'FECHADO'"

if (strGRUPO_USUARIO<>"MANAGER") then 
	 strSQL = strSQL & " AND (AG_AGENDA.ID_CITADOS LIKE '%;" & strUSER_ID & ";%'"
	 strSQL = strSQL & " OR   AG_AGENDA.ID_RESPONSAVEL = '"  & strUSER_ID & "')"
else 
	if (strUSER_ID<>"") then
		strSQL = strSQL & " AND (AG_AGENDA.ID_CITADOS LIKE '%;" & strUSER_ID & ";%'"
		strSQL = strSQL & " OR   AG_AGENDA.ID_RESPONSAVEL = '" & strUSER_ID & "')"
	end if
end if 

strSQL = strSQL & "   AND (AG_AGENDA.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strDIA_SEL1, False) & "' AND '" & PrepDataBrToUni(DateAdd("D", 3, strDIA_SEL1), False) & "') "
strSQL = strSQL & "   AND Month(AG_AGENDA.PREV_DT_INI) = " & Month(strDIA_SEL1) 
strSQL = strSQL & "   AND Year(AG_AGENDA.PREV_DT_INI) = " & Year(strDIA_SEL1) 

strSQL = strSQL & " ORDER BY AG_AGENDA.PREV_DT_INI"
set objRS = objConn.Execute(strSQL) 
%>
<table width="170" cellpadding="0" cellspacing="0" border="0" align="center" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td align="left"><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_AGENDA/default.htm" target="vbNucleo">Agenda</a></b></div></td>
					<td align="right" style="text-align:right">
						<div style="padding-right:3px;"><%'=strUSER_ID%>
							<%=MontaLinkGrade("modulo_AGENDA","Insert.asp","","IconAction_DETAILadd.gif","INSERIR")%>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top" align="left" bgcolor="#FFFFFF">
			<div align="left" style="padding-left:5px;">
				<iframe name="vboss_fragendacalendar" src="../modulo_PAINEL/Box_CalendarAG.asp?var_dia_selected=<%=strDIA_SEL1%>&var_exec=<%=strUSER_ID%>" width="160" height="150" frameborder="0"></iframe>
			</div>
			<div align="left" style="padding-left:10px; padding-bottom:5px; padding-right:12px;" class="texto_ajuda"> 
				<%	
					while not objRS.eof 
						strDT_INI = PrepData(GetValue(objRS,"PREV_DT_INI"),true,true)
						strDT_INI = mid(strDT_INI,1,InStrRev(strDT_INI,":00")-1)
						strHORAS = "0:00"
						if GetValue(objRS,"PREV_HORAS")<>"" and GetValue(objRS,"PREV_HORAS")<>"0" then strHORAS = FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))
				%>
						<a href="../modulo_AGENDA/DetailHistorico.asp?var_chavereg=<%=GetValue(objRS,"COD_AGENDA")%>&var_resposta=true" title="<%=Mid(LCase(GetValue(objRS,"ID_CITADOS")),2)%>">
							<img src='../img/IconPrio_<%=GetValue(objRS,"PRIORIDADE")%>.gif' title='PRIORIDADE: <%=GetValue(objRS,"PRIORIDADE")%>' border="0">
							<span>&nbsp;<%=UCase(WeekDayName(WeekDay(GetValue(objRS,"PREV_DT_INI")),1))%> - <%=strDT_INI%></span><br>
							<%=GetValue(objRS,"TITULO")%><br>
							<span class="texto_ajuda"><%=GetValue(objRS,"ID_RESPONSAVEL")%>&nbsp;(<%=strHORAS%>&nbsp;-&nbsp;<%=LCase(GetValue(objRS,"NOME"))%>)</span>
						</a>
						<br><br>
				<%
						strWeekDay=strWeekDay+1
						objRS.MoveNext
					wend
				%>
			</div>
		</td>
	</tr>
</table>
<%
 FechaRecordSet objRS
%>
 