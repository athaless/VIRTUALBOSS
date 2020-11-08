<%
strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) 

auxSTR = BuscaDireitosFromDB("modulo_TODOLIST", strUSER_ID)
bViewTODO    = VerificaDireito("|VIEW|", auxSTR, false)
bInsRespTODO = VerificaDireito("|INS_RESP|", auxSTR, false)

 intTAMlin = 50
 intTAMcol = 16
 redim matOutrCh(intTAMcol,intTAMlin)
 
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
 strSQL = strSQL & "      , T1.SYS_ID_USUARIO_UPD "
 strSQL = strSQL & "      , T2.COD_CATEGORIA "
 strSQL = strSQL & "      , T2.NOME AS CATEGORIA "
 strSQL = strSQL & "      , T3.PREV_DT_INI "
 strSQL = strSQL & "      , T3.PREV_HORAS "
 strSQL = strSQL & "      , T3.SITUACAO AS TODO_SITUACAO "
 strSQL = strSQL & "      , T3.ID_RESPONSAVEL "
 strSQL = strSQL & "      , T3.ID_ULT_EXECUTOR "
 strSQL = strSQL & "      , T4.APELIDO AS APELIDO_RESPONSAVEL "
 strSQL = strSQL & "      , T5.APELIDO AS APELIDO_ULT_EXECUTOR "
 strSQL = strSQL & " FROM CH_CHAMADO T1 "
 strSQL = strSQL & " INNER JOIN CH_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) "
 strSQL = strSQL & " LEFT OUTER JOIN TL_TODOLIST T3 ON (T1.COD_TODOLIST = T3.COD_TODOLIST) "
 strSQL = strSQL & " LEFT OUTER JOIN USUARIO T4 ON (T3.ID_RESPONSAVEL = T4.ID_USUARIO) "
 strSQL = strSQL & " LEFT OUTER JOIN USUARIO T5 ON (T3.ID_ULT_EXECUTOR = T5.ID_USUARIO) "
 strSQL = strSQL & " WHERE T1.SITUACAO = 'EXECUTANDO' "
 strSQL = strSQL & " AND T1.COD_CLI = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
 strSQL = strSQL & " AND T1.SYS_ID_USUARIO_INS <> '" & strUSER_ID & "' "
 strSQL = strSQL & " ORDER BY T2.NOME, T1.TITULO "
 
 'athDebug strSQL, false
  
 Set objRS = objConn.Execute(strSQL)
  
 i = 0
 Do While (Not objRS.Eof)
	'athDebug "<br>" & i & "-" & GetValue(objRS, "COD_CHAMADO"), false
	
  	matOutrCh(CH_COD    ,i) = GetValue(objRS, "COD_CHAMADO")
  	matOutrCh(CH_TIT    ,i) = GetValue(objRS, "TITULO")
  	matOutrCh(CH_PRIO   ,i) = GetValue(objRS, "PRIORIDADE")
	matOutrCh(CH_SIT    ,i) = GetValue(objRS, "SITUACAO")
	matOutrCh(CH_ARQ    ,i) = GetValue(objRS, "ARQUIVO_ANEXO")
	matOutrCh(CH_DTT_INS,i) = PrepData(GetValue(objRS, "SYS_DTT_INS"), True, False)
	matOutrCh(CH_USR_INS,i) = GetValue(objRS, "SYS_ID_USUARIO_INS")
	matOutrCh(CH_DTT_UPD,i) = "" 'PrepData(GetValue(objRS, "SYS_DTT_UPD"), True, False)
	matOutrCh(CH_USR_UPD,i) = "" 'GetValue(objRS, "SYS_ID_USUARIO_UPD")
	
	matOutrCh(CAT_COD ,i) = GetValue(objRS, "COD_CATEGORIA")
	matOutrCh(CAT_NOME,i) = GetValue(objRS, "CATEGORIA")
	
	matOutrCh(TASK_COD   ,i) = GetValue(objRS, "COD_TODOLIST")
	matOutrCh(TASK_DT_INI,i) = PrepData(GetValue(objRS, "PREV_DT_INI"), True, False)
	matOutrCh(TASK_PREV  ,i) = GetValue(objRS, "PREV_HORAS")
  	matOutrCh(TASK_RESP  ,i) = GetValue(objRS, "APELIDO_RESPONSAVEL")
  	matOutrCh(TASK_EXEC  ,i) = GetValue(objRS, "APELIDO_ULT_EXECUTOR")
  	matOutrCh(TASK_SIT   ,i) = GetValue(objRS, "TODO_SITUACAO")
	
  	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	
	i = i + 1
	If (i > intTAMlin) Then redim preserve matOutrCh(intTAMcol,i) 
  Loop
  
  intTamNew = i-1
  If (i < intTAMlin) Then redim preserve matOutrCh(intTAMcol,intTamNew) 
  
  FechaRecordSet objRS
%>
							<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>">
							<tr>
								<td colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
								  <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
								    <tr>
									  <td width="315" style="border-bottom:1px solid <%=strBGCOLOR1%>"><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_CHAMADO/default.htm" target="vbNucleo">OUTROS chamados em atendimento</a></b></div></td>
									  <td width="724" nowrap="nowrap" align="right" style="text-align:right; border-bottom:1px solid <%=strBGCOLOR1%>"></td>
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
  
  for i=0 to intTamNew
  	strCOD_CATEGORIA = matOutrCh(CAT_COD,i)
	strCOD_CHAMADO   = matOutrCh(CH_COD,i)
	
	If (strCOD_CHAMADO <> "") Then
		If (strCOD_CATEGORIA <> strCOD_CATEGORIA_Old) Then 
			If strCOD_CATEGORIA_Old <> "-1" Then Response.Write("</table><!--categ_" & strCOD_CATEGORIA_Old & "--></div>" & vbNewLine)
			
			Response.Write(ExibeCATEGORIA("outros_" & strCOD_CATEGORIA, matOutrCh(CAT_NOME,i)))
			Response.Write(ExibeOUTROS_CHAMADOS("outros_" & strCOD_CHAMADO, matOutrCh(CH_TIT,i), matOutrCh(CH_PRIO,i), matOutrCh(CH_SIT,i), matOutrCh(CH_ARQ,i), matOutrCh(CH_DTT_INS,i), matOutrCh(CH_USR_INS,i), matOutrCh(CH_DTT_UPD,i), matOutrCh(CH_USR_UPD,i), matOutrCh(TASK_COD,i), matOutrCh(TASK_DT_INI,i), matOutrCh(TASK_PREV,i), matOutrCh(TASK_RESP,i), matOutrCh(TASK_EXEC,i), matOutrCh(TASK_SIT,i), True))
			
			strCOD_CATEGORIA_Old = strCOD_CATEGORIA
		Else
			Response.Write(ExibeOUTROS_CHAMADOS("outros_" & strCOD_CHAMADO, matOutrCh(CH_TIT,i), matOutrCh(CH_PRIO,i), matOutrCh(CH_SIT,i), matOutrCh(CH_ARQ,i), matOutrCh(CH_DTT_INS,i), matOutrCh(CH_USR_INS,i), matOutrCh(CH_DTT_UPD,i), matOutrCh(CH_USR_UPD,i), matOutrCh(TASK_COD,i), matOutrCh(TASK_DT_INI,i), matOutrCh(TASK_PREV,i), matOutrCh(TASK_RESP,i), matOutrCh(TASK_EXEC,i), matOutrCh(TASK_SIT,i), False))
		End If
	Else
		Exit For
	End If
  next
  If strCOD_CATEGORIA_Old <> "-1" Then Response.Write("</table><!--categ_" & strCOD_CATEGORIA_Old & "--></div>" & vbNewLine)
%>
	</td>
</tr>
</table>
								</div>
								</td>
							</tr>
							</table>

