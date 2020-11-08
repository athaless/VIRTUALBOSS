<%
strUSER_ID       = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) 
strGRUPO_USUARIO = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))

auxSTR			= BuscaDireitosFromDB("modulo_TODOLIST", strUSER_ID)
bUpdTODO		= VerificaDireito("|UPD|", auxSTR, false)
bInsRespTODO	= VerificaDireito("|INS_RESP|", auxSTR, false)
bCloseTODO		= VerificaDireito("|CLOSE|", auxSTR, false)

strVIEW = GetParam("var_view2")
strDIA_SEL1 = GetParam("var_dia_selected")

If strVIEW="" Then strVIEW = "equipe"
If strDIA_SEL1="" Then strDIA_SEL1 = date

strDIA_SEL2 = DateAdd("D", 5, strDIA_SEL1)

intTAMcol = 24
redim matRS(intTAMcol,1)

strSQL = MontaSQLBuscaPAT(PrepDataBrToUni(strDIA_SEL2, False), strUSER_ID, strVIEW, "")
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
	matRS(ATIV_NA_EQUIPE ,i) = GetValue(objRS, "BS_NA_EQUIPE")
	matRS(ATIV_TIPO      ,i) = GetValue(objRS, "BS_TIPO")
	
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
	redim preserve matRS(intTAMcol,i)
Loop

intTamNew = i-1
redim preserve matRS(intTAMcol,intTamNew) 

FechaRecordSet objRS
%>
<table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:10px;">
<tr>
	<td width="100%" height="30%">
		<!-- Moldura C INIC -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>">
		<tr>
			<td colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
			  <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
				  <td width="315" style="border-bottom:1px solid <%=strBGCOLOR1%>"><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_TODOLIST/default.htm" target="vbNucleo">Tarefas da Equipe</a></b></div></td>
					 <!--<td width="610" nowrap="nowrap" align="right" style="text-align:right; border-bottom:1px solid <%'=strBGCOLOR1%>">últimas <%'=intTAMlin%> não fechadas até o dia <%'=strDIA_SEL2%>, onde sou</td>-->
					 <td width="724" nowrap="nowrap" align="right" style="text-align:right; border-bottom:1px solid <%=strBGCOLOR1%>">
					 <div style="align:right; padding-right:3px; padding-left:6px;">
					 últimas <%=intTAMlin%> não fechadas em 
					 <select name="var_ultimas" id="var_ultimas" style="width:80px;" 
						onchange="ReloadPage();" class="edtext_combo">
						<option value="7D"  <% If strULTIMAS = "7D"  Then Response.Write(" selected='selected'") %>>7 dias</option>
						<option value="14D" <% If strULTIMAS = "14D" Then Response.Write(" selected='selected'") %>>14 dias</option>
						<option value="1M"  <% If strULTIMAS = "1M"  Then Response.Write(" selected='selected'") %>>1 mês</option>
						<option value="3M"  <% If strULTIMAS = "3M"  Then Response.Write(" selected='selected'") %>>3 meses</option>
						<option value="6M"  <% If strULTIMAS = "6M"  Then Response.Write(" selected='selected'") %>>6 meses</option>
						<option value="12M" <% If strULTIMAS = "12M" Then Response.Write(" selected='selected'") %>>1 ano</option>
						<option value="24M" <% If strULTIMAS = "24M" Then Response.Write(" selected='selected'") %>>2 anos</option>
					 </select> até o dia <%=strDIA_SEL2%>
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
			
			Response.Write(ExibePROJETO(strCOD_PROJETO, matRS(PRJ_TIT,i), matRS(PRJ_FASE,i), "equipe"))
			Response.Write(ExibeBS(strCOD_BS, matRS(ATIV_TIT,i), matRS(ATIV_COD_CLI,i), matRS(ATIV_CLI,i), matRS(ATIV_RESP,i), matRS(ATIV_SIT,i), matRS(ATIV_DT_INI,i), matRS(ATIV_DT_FIM,i), matRS(ATIV_PREV_HORAS,i), matRS(ATIV_HORAS,i), matRS(ATIV_NA_EQUIPE,i), "equipe"))
			Response.Write(ExibeTODOLIST(strCOD_TODOLIST, matRS(TASK_TIT,i), matRS(TASK_RESP,i), matRS(TASK_EXEC,i), matRS(TASK_CATEG,i), matRS(TASK_DT_INI,i), matRS(TASK_HR_INI,i), matRS(TASK_HORAS,i), matRS(TASK_SIT,i), matRS(TASK_PRIO,i), strCOD_BS, matRS(ATIV_TIPO,i), True, True, "equipe"))
			
			strCOD_PROJETO_Old = strCOD_PROJETO
			strCOD_BS_Old = strCOD_BS
		Else
			If (strCOD_BS <> strCOD_BS_Old) Then
				If strCOD_BS_Old <> "-1" Then Response.Write("</table><!--ativ_" & strCOD_BS_Old & "--></div>" & vbNewLine)
				
				Response.Write(ExibeBS(strCOD_BS, matRS(ATIV_TIT,i), matRS(ATIV_COD_CLI,i), matRS(ATIV_CLI,i), matRS(ATIV_RESP,i), matRS(ATIV_SIT,i), matRS(ATIV_DT_INI,i), matRS(ATIV_DT_FIM,i), matRS(ATIV_PREV_HORAS,i), matRS(ATIV_HORAS,i), matRS(ATIV_NA_EQUIPE,i), "equipe"))
				Response.Write(ExibeTODOLIST(strCOD_TODOLIST, matRS(TASK_TIT,i), matRS(TASK_RESP,i), matRS(TASK_EXEC,i), matRS(TASK_CATEG,i), matRS(TASK_DT_INI,i), matRS(TASK_HR_INI,i), matRS(TASK_HORAS,i), matRS(TASK_SIT,i), matRS(TASK_PRIO,i), strCOD_BS, matRS(ATIV_TIPO,i), True, True, "equipe"))
				
				strCOD_BS_Old = strCOD_BS
			Else
				Response.Write(ExibeTODOLIST(strCOD_TODOLIST, matRS(TASK_TIT,i), matRS(TASK_RESP,i), matRS(TASK_EXEC,i), matRS(TASK_CATEG,i), matRS(TASK_DT_INI,i), matRS(TASK_HR_INI,i), matRS(TASK_HORAS,i), matRS(TASK_SIT,i), matRS(TASK_PRIO,i), strCOD_BS, matRS(ATIV_TIPO,i), False, True, "equipe"))
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
