<%
Dim objRSI, objRSII
strUSER_ID = LCase(GetParam("var_usuario"))
strDIA_SEL = GetParam("var_dia_selected")
strVIEW    = GetParam("var_view")

if (strDIA_SEL="") then strDIA_SEL = date
if (strUSER_ID="") then strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

strSQL = "SELECT DISTINCT" 													&_
			"	CL.NOME_FANTASIA,"												&_
			"	TL.COD_BOLETIM," 													&_
			"	BS.TITULO," 														&_
			"	BS.COD_CLIENTE,"													&_
			"	BS.ID_RESPONSAVEL,"												&_											
			"	BS.SITUACAO "														&_			
			"FROM (("																&_
			"	TL_TODOLIST TL " 													&_
			"LEFT OUTER JOIN" 													&_
			"	BS_BOLETIM BS ON (TL.COD_BOLETIM=BS.COD_BOLETIM)) "	&_ 
			"LEFT OUTER JOIN" 													&_
			"	ENT_CLIENTE CL ON (CL.COD_CLIENTE=BS.COD_CLIENTE)) "	&_
			"WHERE " 																

if strVIEW="" then 
	strSQL = strSQL & "	TL.ID_ULT_EXECUTOR='" & strUSER_ID & "' AND"
else 
	strSQL = strSQL & "	TL.ID_RESPONSAVEL='" & strUSER_ID & "' AND" 
end if

strSQL = strSQL  &_			
			"	TL.SITUACAO<>'FECHADO' AND BS.MODELO<>TRUE AND " 		&_
			"	TL.PREV_DT_INI <= #" & PrepData(strDIA_SEL,false,false) & "#"
AbreRecordSet objRS, strSQL, objConn, adOpenDynamic

Sub GradeBS()
Dim lcont,lmaxr, auxBgColor
Dim lauxStr1, lauxStr2, lauxStr3
Dim Ct, strCOLOR, strArquivo 
Dim strPREV_HORAS, strHORAS
Dim pCent, strPREV, strTOTAL, tbW, BgCor
Dim strGRUPO_USUARIO, arrBS_EQUIPE

	lcont = 0
	lmaxr = 10000
	strGRUPO_USUARIO = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))
	
	if objRS.Eof then
		Response.Write "<tr><td colspan='12' height='1' align='center'><b>Não há atividades para este período</b></td></tr>"
		exit sub
		lmaxr=5
	else	
		lauxStr1 = "align='center' valign='middle' class='arial11'"
		lauxStr2 = "align='left'   valign='middle' class='arial11'"
		lauxStr3 = "align='right'  valign='middle' class='arial11'"
		do while not objRS.Eof and lcont < lmaxr

			strSQL = "SELECT"												&_
						"	MIN(PREV_DT_INI) AS DT_INI,"				&_
						"	MAX(PREV_DT_INI) AS DT_FIM,"				&_
						"	SUM(TL.PREV_HORAS) AS TOT_PREV_HORAS,"	&_
						"	SUM(R.HORAS) AS TOT_HORAS "				&_
						"FROM"												&_
						"	TL_TODOLIST TL "								&_
						"LEFT OUTER JOIN"									&_
						"	TL_RESPOSTA R ON (TL.COD_TODOLIST = R.COD_TODOLIST) "&_
						"WHERE"												&_
						"	TL.COD_BOLETIM=" & GetValue(objRS,"COD_BOLETIM")
			AbreRecordSet objRSI, strSQL, objConn, adOpenDynamic

		
			if (GetValue(objRSI,"DT_FIM")<Now) then	auxBgColor = "#FFF0F0"  '"#FFDDDD" 'vermelho	
			if ((GetValue(objRSI,"DT_INI")-Date)<2) and ((GetValue(objRSI,"DT_FIM")-Date)>0) then auxBgColor = "#FFFFF0"  '"#FFFFE6" 'amarelo
			
			strSQL = "SELECT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM=" & GetValue(objRS,"COD_BOLETIM") & "AND DT_INATIVO IS NULL"			 
			AbreRecordSet objRSII, strSQL, objConn, adOpenDynamic

					
			arrBS_EQUIPE = ""
			while not objRSII.Eof 
				arrBS_EQUIPE = arrBS_EQUIPE & LCase(GetValue(objRSII,"ID_USUARIO")) & "; "
				objRSII.MoveNext
			wend 
			
			with	Response
				.Write "<tr bgcolor=" & auxBgColor & ">"
				
				.Write "	<td " & lauxStr1 & " style='cursor:hand;' valign='top'>"
				'ICONE PARA GRÁFICO GANTT - MADISON PADILHA
			    .Write "<a href='../modulo_Painel/gantt.asp?var_chavereg=" & GetValue(objRS,"COD_BOLETIM") & "'><img src='../img/IconAction_GANTT.gif' border='0' alt='GRÁFICO GANTT'></a>"				
				.Write "	</td>"
				
				.Write "	<td " & lauxStr1 & " style='cursor:hand;' valign='top'>"
				if strUSER_ID=LCase(GetValue(objRS,"ID_RESPONSAVEL")) then
					Response.Write "<a href='../modulo_BS/Update.asp?var_chavereg=" & GetValue(objRS,"COD_BOLETIM") & "'><img src='../img/IconAction_EDIT.gif' border='0' alt='ALTERAR'></a>"					
				elseif (InStr(arrBS_EQUIPE,strUSER_ID)>0) or (InStr("MANAGER",strGRUPO_USUARIO)>0) then
					Response.Write "<a href='../modulo_BS/DetailHistorico.asp?var_chavereg=" & GetValue(objRS,"COD_BOLETIM") & "'><img src='../img/IconAction_DETAIL.gif' border='0' alt='HISTÓRICO APENAS'></a>"
				end if
				.Write "	</td>"
			
				.Write "	<td " & lauxStr1 & " style='cursor:hand;' valign='top'>"		
				if (InStr(arrBS_EQUIPE,strUSER_ID)>0) then
					Response.Write "<a href='../modulo_BS/DetailHistorico.asp?var_chavereg=" & GetValue(objRS,"COD_BOLETIM") & "&var_resposta=true'><img src='../img/IconAction_DETAILadd.gif' border='0' alt='HISTÓRICO COM INSERÇÃO'></a>"
				end if
				
				.Write "	</td>"
				.Write "	<td " & lauxStr2 & ">" & GetValue(objRS,"COD_BOLETIM") & "</td>"
				.Write "	<td " & lauxStr2 & ">" & GetValue(objRS,"TITULO") & "</td>"
				.Write "	<td " & lauxStr2 & ">" & PrepData(GetValue(objRSI,"DT_INI"),true,false) & "</td>"
				.Write "	<td " & lauxStr2 & ">" & PrepData(GetValue(objRSI,"DT_FIM"),true,false) & "</td>"
				Ct = 1
				strCOLOR   = "#DAEEFA"
				if (GetValue(objRSI,"DT_INI")<Now) then
					strCOLOR = "#FFF0F0"  '"#FFDDDD" 'vermelho
				end if
				
				'Retorna o tempo gasto de horas para cada tarefa
				strHORAS = GetValue(objRSI,"TOT_HORAS")
				if strHORAS<>"" then strHORAS = FormataHoraNumToHHMM(strHORAS)
				
				'Retorna total de horas previstas para cada tarefa
				strPREV_HORAS = GetValue(objRSI,"TOT_PREV_HORAS")
				if strPREV_HORAS<>"" then strPREV_HORAS = FormataHoraNumToHHMM(strPREV_HORAS)				
				
				strPREV = 0
				strTOTAL= 0
				pCent = 0 
				
				if GetValue(objRSI,"TOT_PREV_HORAS")<>"" and not IsNull(GetValue(objRSI,"TOT_PREV_HORAS")) then strPREV = GetValue(objRSI,"TOT_PREV_HORAS")*60
				if GetValue(objRSI,"TOT_HORAS")<>"" and not IsNull(GetValue(objRSI,"TOT_HORAS")) then strTOTAL = GetValue(objRSI,"TOT_HORAS")*60
				if strPREV>0 and strTOTAL>=0 then	pCent = strTOTAL*100/strPREV
				if pCent=0 then strHORAS = "0:00"
				
				tbW = pCent
				BgCor = "#93A2B9"

				if (tbW>100) then
					tbW = 100
					BgCor = "#7D8B9F"					
					if GetValue(objRS,"SITUACAO")<>"FECHADO" then BgCor = "#C00000"					
				end if				
										
				.Write "<td "& lauxStr2 &">"
				.Write "	<div style='padding-left:3px; padding-right:3px;'>"
				.Write "		<table width='50' height='12' cellpadding='0' cellspacing='0' bordercolor='" & BgCor & "' style='border:1px solid;'>"
				.Write "			<tr>"
				.Write "				<td width='" & tbW & "%' bgcolor='" & BgCor & "' title='"& Round(pCent,2) &"% - "& strHORAS &"Hs'></td>"
				.Write "				<td width='"& (100-tbW) &"%' bgcolor='#FFFFFF' title='"& Round(pCent,2) &"% - "& strHORAS &"Hs'></td>"
				.Write "			</tr>"
				.Write "		</table>"
				.Write "	</div>"
				.Write "</td>"
				.Write "<td "& lauxStr3 &">"& strPREV_HORAS &"</td>"
				.Write "<td "& lauxStr2 &"><a href='../modulo_CLIENTE/Detail.asp?var_chavereg="& GetValue(objRS,"COD_CLIENTE") &"'><img src='../img/IconStatus_Client.gif' border='0' title='CLIENTE: " & GetValue(objRS,"NOME_FANTASIA") &"'></a></td>"
			end with
			athMoveNext objRSI, ContFlush, CFG_FLUSH_LIMIT
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			lcont = lcont +1
		loop
		
	end if
	FechaRecordSet(objRSI)
    FechaRecordSet(objRS)
end sub

%>
<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" style="border:1px solid <%=strBGCOLOR1%>">
	<tr>
		<td bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
		<div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_BS/default.htm" target="vbNucleo">Atividades</a></b></div>
		</td>
	</tr>
	<tr>
		<td align="center" bgcolor="<%=strBGCOLOR2%>">
			<div style="padding-top:4px; padding-bottom:4px;">
				<table width="98%" cellpadding="2" cellspacing="2" border="0">
					<tr bgcolor="<%=strBGCOLOR5%>">
						<td width="1%" height="18">&nbsp;</td>
						<td width="1%" >&nbsp;</td>
						<td width="1%"></td>
						<td width="1%"  nowrap>Cod</td>
						<td width="83%" nowrap>Título</td>
						<td width="1%"	nowrap>Data Início</td>
						<td width="1%"  nowrap>Data Fim</td>
						<td width="10%" nowrap>Andamento</td>
						<td width="1%"  nowrap>Prev Hs</td>
						<td width="1%"></td>					
					</tr>
					<tr>
					  <td colspan="10" height="1" bgcolor="<%=strBGCOLOR6%>"></td>
					</tr>
					<% GradeBS() %>
					<tr><td colspan="10" height="15"></td></tr>
			</table>
			</div>
		</td>
	</tr>
</table>