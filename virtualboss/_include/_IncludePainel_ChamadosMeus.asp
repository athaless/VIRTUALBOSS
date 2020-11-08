<% 
 strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) 

 auxSTR       = BuscaDireitosFromDB("modulo_TODOLIST", strUSER_ID)
 bViewTODO    = VerificaDireito("|VIEW|", auxSTR, false)
 bInsRespTODO = VerificaDireito("|INS_RESP|", auxSTR, false)
 
 intTAMlin = 10
 intTAMcol = 19
 redim matMeusCh(intTAMcol,intTAMlin)
 
 strSQL =          " SELECT T1.COD_CHAMADO "
 strSQL = strSQL & "      , T1.TITULO "
 strSQL = strSQL & "      , T1.PRIORIDADE "
 strSQL = strSQL & "      , T1.SITUACAO "
 strSQL = strSQL & "      , T1.ARQUIVO_ANEXO "
 strSQL = strSQL & "      , T1.COD_TODOLIST "
 strSQL = strSQL & "      , T1.SYS_DTT_INS "
 strSQL = strSQL & "      , T1.SYS_ID_USUARIO_INS "
 strSQL = strSQL & "      , T1.SYS_DTT_UPD "
 strSQL = strSQL & "      , T1.SYS_ID_USUARIO_UPD "
 strSQL = strSQL & "      , T2.COD_CATEGORIA "
 strSQL = strSQL & "      , T2.NOME AS CATEGORIA "
 strSQL = strSQL & "      , T3.PREV_DT_INI "
 strSQL = strSQL & "      , T3.PREV_HR_INI "
 strSQL = strSQL & "      , T3.PREV_HORAS "
 strSQL = strSQL & "      , T3.SITUACAO AS TODO_SITUACAO "
 strSQL = strSQL & "      , T3.ID_RESPONSAVEL "
 strSQL = strSQL & "      , T3.ID_ULT_EXECUTOR "
 strSQL = strSQL & "      , T5.APELIDO AS APELIDO_RESPONSAVEL "
 strSQL = strSQL & "      , T6.APELIDO AS APELIDO_ULT_EXECUTOR "
 strSQL = strSQL & "      , MAX(T4.COD_TL_RESPOSTA) AS ULT_COD_RESPOSTA "
 strSQL = strSQL & " FROM CH_CHAMADO T1 "
 strSQL = strSQL & " INNER JOIN CH_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) "
 strSQL = strSQL & " LEFT OUTER JOIN TL_TODOLIST T3 ON (T1.COD_TODOLIST = T3.COD_TODOLIST) "
 strSQL = strSQL & " LEFT OUTER JOIN TL_RESPOSTA T4 ON (T1.COD_TODOLIST = T4.COD_TODOLIST) "
 strSQL = strSQL & " LEFT OUTER JOIN USUARIO T5 ON (T3.ID_RESPONSAVEL = T5.ID_USUARIO) "
 strSQL = strSQL & " LEFT OUTER JOIN USUARIO T6 ON (T3.ID_ULT_EXECUTOR = T6.ID_USUARIO) "
 'strSQL = strSQL & " WHERE ((T3.SITUACAO = 'EXECUTANDO') OR (T3.SITUACAO = 'FECHADO' AND '" & PrepDataBrToUni(Now, False) & "' >= DATE_SUB(T3.SYS_DTT_ALT, INTERVAL " & strNUM_DIAS & " DAY))) "
 'strSQL = strSQL & " WHERE ((T3.SITUACAO LIKE 'EXECUTANDO') OR (T3.SITUACAO LIKE 'FECHADO' AND T3.SYS_DTT_ALT >= DATE_SUB('" & PrepDataBrToUni(Now, False) & "', INTERVAL " & strNUM_DIAS & " DAY))) "
 strSQL = strSQL & " WHERE ((T3.SITUACAO LIKE 'EXECUTANDO') OR (T3.SITUACAO LIKE 'ESPERA') OR (T3.SITUACAO LIKE 'FECHADO' AND T3.SYS_DTT_ALT >= DATE_SUB('" & PrepDataBrToUni(Now, False) & "', INTERVAL " & strNUM_DIAS & " DAY))) "
 strSQL = strSQL & " AND T1.COD_CLI = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
 strSQL = strSQL & " AND T1.SYS_ID_USUARIO_INS = '" & strUSER_ID & "' "
 strSQL = strSQL & " GROUP BY T1.COD_CHAMADO, T1.TITULO, T1.PRIORIDADE, T1.SITUACAO, T1.ARQUIVO_ANEXO, T1.COD_TODOLIST "
 strSQL = strSQL & "        , T1.SYS_DTT_INS, T1.SYS_ID_USUARIO_INS, T1.SYS_DTT_UPD, T1.SYS_ID_USUARIO_UPD "
 strSQL = strSQL & "        , T2.COD_CATEGORIA, T2.NOME, T3.PREV_DT_INI, T3.PREV_HORAS, T3.ID_RESPONSAVEL "
 strSQL = strSQL & "        , T3.ID_ULT_EXECUTOR, T3.SITUACAO "
 strSQL = strSQL & " ORDER BY  T3.SITUACAO, T2.NOME, T3.PREV_DT_INI "
 
 'athDebug strSQL, false
 
 Set objRS = objConn.Execute(strSQL)
 
 i = 0
 Do While Not objRS.Eof and Not objRS.Bof
  	matMeusCh(CH_COD    ,i) = GetValue(objRS, "COD_CHAMADO")
  	matMeusCh(CH_TIT    ,i) = GetValue(objRS, "TITULO")
  	matMeusCh(CH_PRIO   ,i) = GetValue(objRS, "PRIORIDADE")
	matMeusCh(CH_SIT    ,i) = GetValue(objRS, "SITUACAO")
	matMeusCh(CH_ARQ    ,i) = GetValue(objRS, "ARQUIVO_ANEXO")
	matMeusCh(CH_DTT_INS,i) = PrepData(GetValue(objRS, "SYS_DTT_INS"), True, False)
	matMeusCh(CH_USR_INS,i) = GetValue(objRS, "SYS_ID_USUARIO_INS")
	matMeusCh(CH_DTT_UPD,i) = PrepData(GetValue(objRS, "SYS_DTT_UPD"), True, False)
	matMeusCh(CH_USR_UPD,i) = PrepData(GetValue(objRS, "SYS_ID_USUARIO_UPD"), True, True)
	
	matMeusCh(CAT_COD ,i) = GetValue(objRS, "COD_CATEGORIA")
	matMeusCh(CAT_NOME,i) = GetValue(objRS, "CATEGORIA")
	
	matMeusCh(TASK_COD   ,i) = GetValue(objRS, "COD_TODOLIST")
	matMeusCh(TASK_DT_INI,i) = PrepData(GetValue(objRS, "PREV_DT_INI"), True, False) '& " " & GetValue(objRS, "PREV_HR_INI")
	matMeusCh(TASK_PREV  ,i) = GetValue(objRS, "PREV_HORAS")
  	matMeusCh(TASK_RESP  ,i) = GetValue(objRS, "APELIDO_RESPONSAVEL")
  	matMeusCh(TASK_EXEC  ,i) = GetValue(objRS, "APELIDO_ULT_EXECUTOR")
  	matMeusCh(TASK_SIT   ,i) = GetValue(objRS, "TODO_SITUACAO")
	
	strSQL =          " SELECT T1.ID_FROM, T1.ID_TO, T1.DTT_RESPOSTA, T2.APELIDO AS APELIDO_FROM, T3.APELIDO AS APELIDO_TO "
	strSQL = strSQL & "   FROM TL_RESPOSTA T1, USUARIO T2, USUARIO T3 "
	strSQL = strSQL & "  WHERE T1.COD_TL_RESPOSTA = " & GetValue(objRS, "ULT_COD_RESPOSTA")
	strSQL = strSQL & "    AND T1.ID_FROM = T2.ID_USUARIO "
	strSQL = strSQL & "    AND T1.ID_TO = T3.ID_USUARIO "
	
	'athDebug  "<br><br>" & strSQL & "<br><br>", false
	
	Set objRSAux = objConn.Execute(strSQL)
	
	If Not objRSAux.Eof Then
	  	matMeusCh(RESP_FROM   ,i) = GetValue(objRSAux, "APELIDO_FROM")
  		matMeusCh(RESP_TO     ,i) = GetValue(objRSAux, "APELIDO_TO")
		matMeusCh(RESP_DTT_INS,i) = PrepData(GetValue(objRSAux, "DTT_RESPOSTA"), True, True)
	End If
	FechaRecordSet objRSAux
	
  	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	
	i = i + 1

    intTamNew = i
    redim preserve matMeusCh(intTAMcol,intTamNew) 
  Loop

  FechaRecordSet objRS
%>
							<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
							<tr>
								<td colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
								  <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
								    <tr>
									  <td width="539" style="border-bottom:1px solid <%=strBGCOLOR1%>"><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_CHAMADO/default.htm" target="vbNucleo">MEUS chamados em atendimento</a></b></div></td>
									  <td width="500" nowrap="nowrap" align="right" style="text-align:right; border-bottom:1px solid <%=strBGCOLOR1%>"></td>
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
  strCOD_CATEGORIA = ""
  strCOD_CATEGORIA_Old = "-1"
  strSITUACAO = ""
  strSITUACAO_Old = "-1"
  
  For i=0 To intTamNew
  	strCOD_CATEGORIA = matMeusCh(CAT_COD,i)
	strCOD_CHAMADO   = matMeusCh(CH_COD,i)
	strSITUACAO      = matMeusCh(TASK_SIT,i)
	
	If (strCOD_CHAMADO <> "") Then
		If ( (strSITUACAO = "EXECUTANDO") OR (strSITUACAO = "ESPERA") )Then
			If (strCOD_CATEGORIA <> strCOD_CATEGORIA_Old) Then 
				If strCOD_CATEGORIA_Old <> "-1" Then Response.Write("</table><!--categ_" & strCOD_CATEGORIA_Old & "--></div>" & vbNewLine)
				
				Response.Write(ExibeCATEGORIA("meus_" & strCOD_CATEGORIA, matMeusCh(CAT_NOME,i)))
				Response.Write(ExibeMEUS_CHAMADOS("meus_" & matMeusCh(CH_COD,i), matMeusCh(CH_TIT,i), matMeusCh(CH_PRIO,i), matMeusCh(CH_SIT,i), matMeusCh(CH_ARQ,i), matMeusCh(CH_DTT_INS,i), matMeusCh(CH_USR_INS,i), matMeusCh(CH_DTT_UPD,i), matMeusCh(CH_USR_UPD,i), matMeusCh(TASK_COD,i), matMeusCh(TASK_DT_INI,i), matMeusCh(TASK_PREV,i), matMeusCh(TASK_RESP,i), matMeusCh(TASK_EXEC,i), matMeusCh(TASK_SIT,i), matMeusCh(RESP_FROM,i), matMeusCh(RESP_TO,i), matMeusCh(RESP_DTT_INS,i), True))
				
				strCOD_CATEGORIA_Old = strCOD_CATEGORIA
			Else
				Response.Write(ExibeMEUS_CHAMADOS("meus_" & matMeusCh(CH_COD,i), matMeusCh(CH_TIT,i), matMeusCh(CH_PRIO,i), matMeusCh(CH_SIT,i), matMeusCh(CH_ARQ,i), matMeusCh(CH_DTT_INS,i), matMeusCh(CH_USR_INS,i), matMeusCh(CH_DTT_UPD,i), matMeusCh(CH_USR_UPD,i), matMeusCh(TASK_COD,i), matMeusCh(TASK_DT_INI,i), matMeusCh(TASK_PREV,i), matMeusCh(TASK_RESP,i), matMeusCh(TASK_EXEC,i), matMeusCh(TASK_SIT,i), matMeusCh(RESP_FROM,i), matMeusCh(RESP_TO,i), matMeusCh(RESP_DTT_INS,i), False))
			End If
		Else
			If (strSITUACAO <> strSITUACAO_Old) Then 
				If strCOD_CATEGORIA_Old <> "-1" Then
					Response.Write("</table><!--categ_" & strCOD_CATEGORIA_Old & "--></div>" & vbNewLine)
					strCOD_CATEGORIA_Old = "-1"
				End If
				
				Response.Write(ExibeCATEGORIA("meusfech_" & strSITUACAO, "FECHADOS (até " & strNUM_DIAS & " dias atrás)"))
				Response.Write(ExibeMEUS_CHAMADOS("meusfech_" & matMeusCh(CH_COD,i), matMeusCh(CH_TIT,i), matMeusCh(CH_PRIO,i), matMeusCh(CH_SIT,i), matMeusCh(CH_ARQ,i), matMeusCh(CH_DTT_INS,i), matMeusCh(CH_USR_INS,i), matMeusCh(CH_DTT_UPD,i), matMeusCh(CH_USR_UPD,i), matMeusCh(TASK_COD,i), matMeusCh(TASK_DT_INI,i), matMeusCh(TASK_PREV,i), matMeusCh(TASK_RESP,i), matMeusCh(TASK_EXEC,i), matMeusCh(TASK_SIT,i), matMeusCh(RESP_FROM,i), matMeusCh(RESP_TO,i), matMeusCh(RESP_DTT_INS,i), True))
				
				strSITUACAO_Old = strSITUACAO
			Else
				Response.Write(ExibeMEUS_CHAMADOS("meusfech_" & matMeusCh(CH_COD,i), matMeusCh(CH_TIT,i), matMeusCh(CH_PRIO,i), matMeusCh(CH_SIT,i), matMeusCh(CH_ARQ,i), matMeusCh(CH_DTT_INS,i), matMeusCh(CH_USR_INS,i), matMeusCh(CH_DTT_UPD,i), matMeusCh(CH_USR_UPD,i), matMeusCh(TASK_COD,i), matMeusCh(TASK_DT_INI,i), matMeusCh(TASK_PREV,i), matMeusCh(TASK_RESP,i), matMeusCh(TASK_EXEC,i), matMeusCh(TASK_SIT,i), matMeusCh(RESP_FROM,i), matMeusCh(RESP_TO,i), matMeusCh(RESP_DTT_INS,i), False))
			End If
		End If
	Else
		Exit For
	End If
  Next
  If strCOD_CATEGORIA_Old <> "-1" Then Response.Write("</table><!--categ_" & strCOD_CATEGORIA_Old & "--></div>" & vbNewLine)
  If strSITUACAO_Old <> "-1" Then Response.Write("</table><!--categ_" & strSITUACAO_Old & "--></div>" & vbNewLine)
%>
	</td>
</tr>
</table>
								</div>
								</td>
							</tr>
							</table>