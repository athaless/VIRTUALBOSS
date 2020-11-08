<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, strBodyMsg
Dim strSOLICITANTE, strTITULO, strPRIORIDADE, strDESCRICAO, strSIGILOSO, strEXTRA
Dim strCOD_CHAMADO, strCOD_CATEGORIA, strCOD_CLI, strARQUIVO_ANEXO, strDT_AGORA, strTIPO_CHAMADO, strSITUACAO, strRESP
Dim strAUX_COD_CLI
Dim strJSCRIPT_ACTION, strLOCATION

Dim i, strQTDEINPUTS  
Dim arrAnexo(), arrAnexoDesc()

strSOLICITANTE    = GetParam("var_solicitante")
strCOD_CLI        = GetParam("var_cod_cli")
strTITULO         = GetParam("var_titulo")
strCOD_CATEGORIA  = GetParam("var_cod_categoria")
strPRIORIDADE     = GetParam("var_prioridade")
strARQUIVO_ANEXO  = GetParam("var_arquivo_anexo")
strTIPO_CHAMADO   = GetParam("var_tipo_chamado")
strDESCRICAO      = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strSIGILOSO       = Replace(GetParam("var_sigiloso"),"'","<ASLW_APOSTROFE>")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")
strEXTRA		  = GetParam("var_extra")
strRESP           = GetParam("var_id_resp")

'O SYS_USER_INS do chamado pode ser definido no caso no usuário de inserção do chamado não for cliente. 
'Para os casos do atendimento necessitar abrir chamados pelo usuário. By Lumertz 14/02/2013.
If (strRESP <> "") Then
	strSOLICITANTE = strRESP
	AbreDBConn objConn, CFG_DB 
	strSQL = "SELECT CODIGO FROM USUARIO WHERE ID_USUARIO = '" & strSOLICITANTE & "'"
  	AbreRecordSet ObjRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	strAUX_COD_CLI = GetValue(objRS,"CODIGO")
	FechaRecordSet objRS
	FechaDBConn objConn		
   'Verifica se o Solicitante é um cliente e se pertence empresa cliente do chamado.
	If (strAUX_COD_CLI <> CInt(strCOD_CLI)) Then 
		Mensagem "O Solicitante deve pertencer ao Cliente do Chamado.", "Javascript:history.back()", "Voltar", True
		Response.End()  		
	End If
End If 

'INI: ANEXOS ------------------------------------------------------------------
' Busca imagens/descrições anexas colocando-as em respectivos arrays 
' obs. o que determina se vai ser gravado ou não é o campo referente ao arquivo
i = 1
strQTDEINPUTS = GetParam("QTDE_INPUTS")
redim arrAnexo(strQTDEINPUTS)
redim arrAnexoDesc(strQTDEINPUTS)
While (i<=Cint(strQTDEINPUTS))
  arrAnexo(i)	  = GetParam("var_anexo_" & i)
  arrAnexoDesc(i) = GetParam("var_anexodesc_" & i)
  i = i + 1
WEnd
'DEBUG
'for i=1 to Cint(strQTDEINPUTS) response.write ("posicao "& i &" : "&arrAnexo(i)&" -- "&arrAnexoDesc(i)&"<br>")  next
'response.end
'FIM: ANEXOS ------------------------------------------------------------------


If strSOLICITANTE = "" Or strCOD_CLI = "" Or strTITULO = "" Or strCOD_CATEGORIA = "" Or strPRIORIDADE = "" Or strDESCRICAO = "" Then
	Mensagem "Você tem que preencher todos os campos obrigatórios.", "Javascript:history.back()", "Voltar", True
	Response.End()
End If

AbreDBConn objConn, CFG_DB 

strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"

strSITUACAO = "ABERTO"
If strTIPO_CHAMADO = "LIVRE"     Then strSITUACAO = "ABERTO"
If strTIPO_CHAMADO = "BLOQUEADO" Then strSITUACAO = "BLOQUEADO"

strSQL =          " INSERT INTO CH_CHAMADO (COD_CLI, TITULO, COD_CATEGORIA, COD_TODOLIST, SITUACAO, PRIORIDADE, DESCRICAO, SIGILOSO, ARQUIVO_ANEXO, EXTRA, SYS_ID_USUARIO_INS, SYS_DTT_INS) " 
strSQL = strSQL & " VALUES ( " & strCOD_CLI & ", '" & strTITULO & "', " & strCOD_CATEGORIA & ", NULL, '" & strSITUACAO & "', '" & strPRIORIDADE & "' " 
strSQL = strSQL & "        , '" & strDESCRICAO & "', '" & strSIGILOSO & "', '" & strARQUIVO_ANEXO & "', '" & strEXTRA & "', '" & strSOLICITANTE & "', " & strDT_AGORA & ")" 

'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_CHAMADO.InsertExec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CHAMADO", strSQL	
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
	athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT CHAMADO", strSQL		
End If


strSQL =          " SELECT MAX(COD_CHAMADO) AS CODIGO FROM CH_CHAMADO "
strSQL = strSQL & "  WHERE TITULO LIKE '" & strTITULO & "' "
strSQL = strSQL & "    AND SYS_ID_USUARIO_INS LIKE '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' "
strSQL = strSQL & "    AND SYS_DTT_INS = " & strDT_AGORA

Set objRS = objConn.Execute(strSQL)

strCOD_CHAMADO = ""
If Not objRS.Eof Then
	strCOD_CHAMADO = GetValue(objRS, "CODIGO")
End If
FechaRecordSet objRS


If (strCOD_CHAMADO<>"") Then
	'INI: Insere anexos --------------------------------------
	for i=1 to Cint(strQTDEINPUTS)
	  if arrAnexo(i)<>"" then
		strSQL = " INSERT INTO CH_ANEXO (COD_CHAMADO, ARQUIVO, DESCRICAO, SYS_DTT_INS, SYS_ID_USUARIO_INS) "
		strSQL = strSQL & " VALUES (" & strCOD_CHAMADO & ",'" & arrAnexo(i) & "','" & arrAnexoDesc(i) & "'," & strDT_AGORA & ",'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' )"
		'response.write strSQL
		'response.end

		set objRS  = objConn.Execute("start transaction")
		set objRS  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL) 
		If Err.Number <> 0 Then
		  set objRS = objConn.Execute("rollback")
		  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CH_ANEXO", strSQL
		  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		else
		  set objRS = objConn.Execute("commit")
		  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT CH_ANEXO", strSQL
		End If
	  end if 
	next
	'FIM: Insere anexos --------------------------------------
end if


FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>