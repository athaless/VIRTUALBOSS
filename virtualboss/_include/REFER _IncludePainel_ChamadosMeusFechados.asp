<%
strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) 

auxSTR = BuscaDireitosFromDB("modulo_TODOLIST", strUSER_ID)
bViewTODO    = VerificaDireito("|VIEW|", auxSTR, false)
bInsRespTODO = VerificaDireito("|INS_RESP|", auxSTR, false)
bCloseTODO   = VerificaDireito("|CLOSE|", auxSTR, false)

 intTAMlin = 50
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
 strSQL = strSQL & "      , T3.ID_RESPONSAVEL "
 strSQL = strSQL & "      , T3.ID_ULT_EXECUTOR "
 strSQL = strSQL & "      , T3.SITUACAO AS TODO_SITUACAO "
 strSQL = strSQL & "      , MAX(T4.COD_TL_RESPOSTA) AS ULT_COD_RESPOSTA "
 strSQL = strSQL & " FROM CH_CHAMADO T1 "
 strSQL = strSQL & " INNER JOIN CH_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) "
 strSQL = strSQL & " LEFT OUTER JOIN TL_TODOLIST T3 ON (T1.COD_TODOLIST = T3.COD_TODOLIST) "
 strSQL = strSQL & " LEFT OUTER JOIN TL_RESPOSTA T4 ON (T1.COD_TODOLIST = T4.COD_TODOLIST) "
 strSQL = strSQL & " WHERE (T3.SITUACAO = 'FECHADO' AND '" & PrepDataBrToUni(Now, False) & "' >= DATE_SUB(T3.SYS_DTT_ALT, INTERVAL " & strNUM_DIAS & " DAY)) "
 strSQL = strSQL & " AND T1.COD_CLI = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
 strSQL = strSQL & " AND T1.SYS_ID_USUARIO_INS = '" & strUSER_ID & "' "
 strSQL = strSQL & " GROUP BY T1.COD_CHAMADO, T1.TITULO, T1.PRIORIDADE, T1.SITUACAO, T1.ARQUIVO_ANEXO, T1.COD_TODOLIST "
 strSQL = strSQL & "        , T1.SYS_DTT_INS, T1.SYS_ID_USUARIO_INS, T1.SYS_DTT_UPD, T1.SYS_ID_USUARIO_UPD "
 strSQL = strSQL & "        , T2.COD_CATEGORIA, T2.NOME, T3.PREV_DT_INI, T3.PREV_HORAS, T3.ID_RESPONSAVEL "
 strSQL = strSQL & "        , T3.ID_ULT_EXECUTOR, T3.SITUACAO "
 strSQL = strSQL & " ORDER BY T2.NOME, T1.TITULO "
 
 'athDebug strSQL, false
 
 Set objRS = objConn.Execute(strSQL)
 
 i = 0
 Do While Not objRS.Eof
  	matMeusCh(CH_COD    ,i) = GetValue(objRS, "COD_CHAMADO")
  	matMeusCh(CH_TIT    ,i) = GetValue(objRS, "TITULO")
  	matMeusCh(CH_PRIO   ,i) = GetValue(objRS, "PRIORIDADE")
	matMeusCh(CH_SIT    ,i) = GetValue(objRS, "SITUACAO")
	matMeusCh(CH_ARQ    ,i) = GetValue(objRS, "ARQUIVO_ANEXO")
	matMeusCh(CH_DTT_INS,i) = PrepData(GetValue(objRS, "SYS_DTT_INS"), True, False)
	matMeusCh(CH_USR_INS,i) = GetValue(objRS, "SYS_ID_USUARIO_INS")
	matMeusCh(CH_DTT_UPD,i) = GetValue(objRS, "SYS_DTT_UPD")
	matMeusCh(CH_USR_UPD,i) = PrepData(GetValue(objRS, "SYS_ID_USUARIO_UPD"), True, True)
	
	matMeusCh(CAT_COD ,i) = GetValue(objRS, "COD_CATEGORIA")
	matMeusCh(CAT_NOME,i) = GetValue(objRS, "CATEGORIA")
	
	matMeusCh(TASK_COD   ,i) = GetValue(objRS, "COD_TODOLIST")
	matMeusCh(TASK_DT_INI,i) = PrepData(GetValue(objRS, "PREV_DT_INI"), True, False) '& " " & GetValue(objRS, "PREV_HR_INI")
	matMeusCh(TASK_PREV  ,i) = GetValue(objRS, "PREV_HORAS")
  	matMeusCh(TASK_RESP  ,i) = GetValue(objRS, "ID_RESPONSAVEL")
  	matMeusCh(TASK_EXEC  ,i) = GetValue(objRS, "ID_ULT_EXECUTOR")
  	matMeusCh(TASK_SIT   ,i) = GetValue(objRS, "TODO_SITUACAO")
	
	strSQL = " SELECT ID_FROM, ID_TO, DTT_RESPOSTA FROM TL_RESPOSTA WHERE COD_TL_RESPOSTA = " & GetValue(objRS, "ULT_COD_RESPOSTA")
	Set objRSAux = objConn.Execute(strSQL)
	
	If Not objRSAux.Eof Then
	  	matMeusCh(RESP_FROM   ,i) = GetValue(objRSAux, "ID_FROM")
  		matMeusCh(RESP_TO     ,i) = GetValue(objRSAux, "ID_TO")
		matMeusCh(RESP_DTT_INS,i) = PrepData(GetValue(objRSAux, "DTT_RESPOSTA"), True, True)
	End If
	FechaRecordSet objRSAux
	
  	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	
	i = i + 1
  Loop
  
  intTamNew = i-1
  redim preserve matMeusCh(intTAMcol,intTamNew) 
  
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
							<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
							<tr>
								<td colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
								  <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
								    <tr>
									  <td width="539" style="border-bottom:1px solid <%=strBGCOLOR1%>"><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_CHAMADO/default.htm" target="vbNucleo">MEUS chamados recentemente fechados</a></b> (até <%=strNUM_DIAS%> dias atrás)</div></td>
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
  
  for i=0 to intTamNew
  	strCOD_CATEGORIA = matMeusCh(CAT_COD,i)
	strCOD_CHAMADO   = matMeusCh(CH_COD,i)
	
	If (strCOD_CHAMADO <> "") Then
		If (strCOD_CATEGORIA <> strCOD_CATEGORIA_Old) Then 
			If strCOD_CATEGORIA_Old <> "-1" Then Response.Write("</table><!--categ_" & strCOD_CATEGORIA_Old & "--></div>" & vbNewLine)
			
			Response.Write(ExibeCATEGORIA("meusfech_" & strCOD_CATEGORIA, matMeusCh(CAT_NOME,i)))
			Response.Write(ExibeMEUS_CHAMADOS("meusfech_" & matMeusCh(CH_COD,i), matMeusCh(CH_TIT,i), matMeusCh(CH_PRIO,i), matMeusCh(CH_SIT,i), matMeusCh(CH_ARQ,i), matMeusCh(CH_DTT_INS,i), matMeusCh(CH_USR_INS,i), matMeusCh(CH_DTT_UPD,i), matMeusCh(CH_USR_UPD,i), matMeusCh(TASK_COD,i), matMeusCh(TASK_DT_INI,i), matMeusCh(TASK_PREV,i), matMeusCh(TASK_RESP,i), matMeusCh(TASK_EXEC,i), matMeusCh(TASK_SIT,i), matMeusCh(RESP_FROM,i), matMeusCh(RESP_TO,i), matMeusCh(RESP_DTT_INS,i), True))
			
			strCOD_CATEGORIA_Old = strCOD_CATEGORIA
		Else
			Response.Write(ExibeMEUS_CHAMADOS("meusfech_" & matMeusCh(CH_COD,i), matMeusCh(CH_TIT,i), matMeusCh(CH_PRIO,i), matMeusCh(CH_SIT,i), matMeusCh(CH_ARQ,i), matMeusCh(CH_DTT_INS,i), matMeusCh(CH_USR_INS,i), matMeusCh(CH_DTT_UPD,i), matMeusCh(CH_USR_UPD,i), matMeusCh(TASK_COD,i), matMeusCh(TASK_DT_INI,i), matMeusCh(TASK_PREV,i), matMeusCh(TASK_RESP,i), matMeusCh(TASK_EXEC,i), matMeusCh(TASK_SIT,i), matMeusCh(RESP_FROM,i), matMeusCh(RESP_TO,i), matMeusCh(RESP_DTT_INS,i), False))
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