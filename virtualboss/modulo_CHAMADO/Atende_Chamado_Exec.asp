<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, strBodyMsg, strAux
Dim strCODIGO, strTITULO, strRESPONSAVEL, strEXECUTOR, strDESCRICAO, strSIGILOSO, strPREV_DT_INI_Orig, strPREV_DT_INI, strPREV_HR_INI
Dim strPREV_HORAS, strCOD_CATEGORIA, strCATEGORIA, strCOD_CATEGORIA_CH, strPRIORIDADE, strRESPOSTA, strRESPOSTA_SECRETA, strARQUIVO_ANEXO, strDT_AGORA, strID_USUARIO, strCOD_CLI
Dim strJSCRIPT_ACTION, strLOCATION
Dim strEMAIL_RESPONSAVECOD_CLIL, strEMAIL_EXECUTOR, strEMAILS_MANAGER
Dim strTODO_RESPONSAVEL, strTODO_EXECUTOR
Dim strDESCRICAO_email, strRESPOSTA_email
Dim strHORAS_REAL, strMINUTOS_REAL, strHORASeMINUTOS_REAL, strEMAIL_RESPONSAVEL

strCODIGO           = GetParam("var_chavereg")
strTITULO           = GetParam("var_titulo")
strRESPONSAVEL      = GetParam("var_from")
strEXECUTOR         = GetParam("var_to")
strPREV_DT_INI      = GetParam("var_prev_dt_ini")
strPREV_HR_INI      = GetParam("var_prev_hr_ini_hora") & ":" & GetParam("var_prev_hr_ini_min")
strPREV_HORAS       = GetParam("var_prev_horas") & "." & GetParam("var_prev_minutos")
strHORAS_REAL       = GetParam("var_horas_real")
strMINUTOS_REAL     = GetParam("var_minutos_real")
strCOD_CATEGORIA    = GetParam("var_cod_categoria")
strCATEGORIA        = GetParam("var_categoria")
strCOD_CATEGORIA_CH = GetParam("var_cod_nova_categoria")
strPRIORIDADE       = GetParam("var_prioridade")
strARQUIVO_ANEXO    = GetParam("var_arquivo_anexo")
strDESCRICAO        = GetParam("var_descricao")
strSIGILOSO         = GetParam("var_sigiloso")
strCOD_CLI			= GetParam("var_cod_cli")
strRESPOSTA         = Replace(GetParam("var_resposta"),"'","<ASLW_APOSTROFE>")
strRESPOSTA_SECRETA = Replace(GetParam("var_resposta_secreta"),"'","<ASLW_APOSTROFE>")
strJSCRIPT_ACTION   = GetParam("JSCRIPT_ACTION")
strLOCATION         = GetParam("DEFAULT_LOCATION")

strDESCRICAO_email  = GetParam("var_descricao")
strRESPOSTA_email   = GetParam("var_resposta")

strDESCRICAO_email  = Replace(strDESCRICAO_email,"<ASLW_APOSTROFE>","'")
strRESPOSTA_email   = Replace(strRESPOSTA_email,"<ASLW_APOSTROFE>","'")

strDESCRICAO_email  = Replace(strDESCRICAO_email, "''", "'")
strRESPOSTA_email   = Replace(strRESPOSTA_email, "''", "'")

AbreDBConn objConn, CFG_DB

If strCODIGO <> "" And strTITULO <> "" And strRESPONSAVEL <> "" And strEXECUTOR <> "" And strCOD_CATEGORIA <> "" And strPRIORIDADE <> "" And strRESPOSTA <> "" And strPREV_DT_INI <> "" Then
	'--------------------------------------------------------------
	' Prepara variáveis
	'--------------------------------------------------------------
	strPREV_DT_INI_Orig = strPREV_DT_INI
	strPREV_DT_INI = "'" & PrepDataBrToUni(strPREV_DT_INI, False) & "'"
	
	If strPREV_HORAS = "." Then 
		strPREV_HORAS = "NULL"
	Else
		If InStr(strPREV_HORAS, ".") = 1                  Then strPREV_HORAS = "00" & strPREV_HORAS
		If InStr(strPREV_HORAS, ".") = Len(strPREV_HORAS) Then strPREV_HORAS = strPREV_HORAS & "00"
	End If
	
	If strPREV_HR_INI = ":" Then 
		strPREV_HR_INI = ""
	Else
		If InStr(strPREV_HR_INI, ":") = 1                   Then strPREV_HR_INI = "00" & strPREV_HR_INI
		If InStr(strPREV_HR_INI, ":") = Len(strPREV_HR_INI) Then strPREV_HR_INI = strPREV_HR_INI & "00"
	End If
	
	If strHORAS_REAL<>"" then
		If not isNumeric(strHORAS_REAL) then
			Response.write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
			Response.End()
		Else
			strHORASeMINUTOS_REAL = strHoras_REAL & "." & strMinutos_REAL
		End If
	Else
		if (CInt(strMinutos_REAL)>0) then 
			strHORASeMINUTOS_REAL = "0." & Cstr(strMinutos_REAL)
		Else
			strHORASeMINUTOS_REAL ="NULL" 
		End If
	End If
	strHORASeMINUTOS_REAL = Replace(strHORASeMINUTOS_REAL, ",", ".")
	
	strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"
	strID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
	
	'-----------------------------------------------------------------------------
	' Insere tarefa
	' Convecionamos que o executor da tarefa sempre será quem atende a tarefa, 
	' mesmo quando o executor manda para o responsável, isso quando a tarefa 
	' vem de chamado 
	'-----------------------------------------------------------------------------
	strTODO_RESPONSAVEL = strRESPONSAVEL
	strTODO_EXECUTOR = strEXECUTOR

	strSQL =          " INSERT INTO TL_TODOLIST ( TITULO, SITUACAO, COD_CATEGORIA, PRIORIDADE, ID_RESPONSAVEL, ID_ULT_EXECUTOR " 
	strSQL = strSQL & "                         , PREV_DT_INI, PREV_HR_INI, PREV_HORAS, DESCRICAO, ARQUIVO_ANEXO, SYS_ID_USUARIO_INS, SYS_DTT_INS, COD_CLI) " 
	strSQL = strSQL & " VALUES ( '" & strTITULO & "', 'EXECUTANDO', " & strCOD_CATEGORIA & ", '" & strPRIORIDADE & "' " 
	strSQL = strSQL & "        , '" & strTODO_RESPONSAVEL & "', '" & strTODO_EXECUTOR & "', " & strPREV_DT_INI & ", '" & strPREV_HR_INI & "', " & strPREV_HORAS 
	strSQL = strSQL & "        , '" & strDESCRICAO & "', '" & strARQUIVO_ANEXO & "', '" & strID_USUARIO & "', " & strDT_AGORA & "," & strCOD_CLI & ")" 

	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL) 
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_CHAMADO.atende_chamado_exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If


	'--------------------------------------------------------------
	' Insere resposta(s), Anexos e atualiza chamdo
	'--------------------------------------------------------------
	strSQL =          " SELECT COD_TODOLIST FROM TL_TODOLIST "
	strSQL = strSQL & "  WHERE SYS_ID_USUARIO_INS LIKE '" & strID_USUARIO & "' "
	strSQL = strSQL & "    AND SYS_DTT_INS = " & strDT_AGORA
	Set objRS = objConn.Execute(strSQL)
	
	If Not objRS.Eof Then
		'--------------------------------------------------------------
		' Já insere resposta(s)
		'--------------------------------------------------------------
		If strSIGILOSO <> "" Then
			strSQL =          " INSERT INTO TL_RESPOSTA (COD_TODOLIST, RESPOSTA, SIGILOSO, ID_FROM, ID_TO, HORAS, SYS_ID_USUARIO_INS, DTT_RESPOSTA) "
			strSQL = strSQL & " VALUES (" & GetValue(objRS, "COD_TODOLIST") & ", 'Dados sigilosos passados pelo solicitante', '" & strSIGILOSO & "', '" & strRESPONSAVEL & "', '" & strEXECUTOR & "', " & strHORASeMINUTOS_REAL & ", '" & strID_USUARIO & "', " & strDT_AGORA & ") "
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "modulo_CHAMADO.atende_chamado_exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
		End If
		
		strSQL =          " INSERT INTO TL_RESPOSTA (COD_TODOLIST, RESPOSTA, SIGILOSO, ID_FROM, ID_TO, HORAS, SYS_ID_USUARIO_INS, DTT_RESPOSTA) "
		strSQL = strSQL & " VALUES (" & GetValue(objRS, "COD_TODOLIST") & ", '" & strRESPOSTA & "', '" & strRESPOSTA_SECRETA & "', '" & strEXECUTOR & "', '" & strRESPONSAVEL & "', " & strHORASeMINUTOS_REAL & ", '" & strID_USUARIO & "', " & strDT_AGORA & ") "
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_CHAMADO.atende_chamado_exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
		
		'--------------------------------------------------------------
		' Atualiza chamado indicando que está sendo atendido
		'--------------------------------------------------------------
		strSQL =          " UPDATE CH_CHAMADO "
		strSQL = strSQL & " SET COD_TODOLIST = " & GetValue(objRS, "COD_TODOLIST") 
		strSQL = strSQL & "   , SITUACAO = 'EXECUTANDO' "
		if (strCOD_CATEGORIA_CH<>"") Then strSQL = strSQL & "   , COD_CATEGORIA = " & strCOD_CATEGORIA_CH End IF
		strSQL = strSQL & " WHERE COD_CHAMADO = " & strCODIGO
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_CHAMADO.atende_chamado_exec D: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
		
		'-----------------------------------------------------------------------------
		' Insere na tabela de anexos da tarefa os anexos do chamado
		'-----------------------------------------------------------------------------
		strSQL =          " INSERT INTO TL_ANEXO (COD_TODOLIST, ARQUIVO, DESCRICAO, SYS_DTT_INS, SYS_ID_USUARIO_INS)"
		strSQL = strSQL & " SELECT " & GetValue(objRS, "COD_TODOLIST") & ", ARQUIVO, DESCRICAO, SYS_DTT_INS, SYS_ID_USUARIO_INS"
		strSQL = strSQL & "   FROM CH_ANEXO WHERE COD_CHAMADO = " & strCODIGO
		'AQUI: NEW TRANSACTION
		set objRSCT = objConn.Execute("start transaction")
		set objRSCT = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL) 
		if Err.Number<>0 then 
		  set objRSCT= objConn.Execute("rollback")
		  Mensagem "modulo_CHAMADO.atende_chamado_exec E: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		  Response.End()
		else	  
		  set objRSCT= objConn.Execute("commit")
		End If


		'--------------------------------------------------------------
		' Manda avisos de email
		'--------------------------------------------------------------
		strEMAIL_RESPONSAVEL = BuscaUserEMAIL(ObjConn, strRESPONSAVEL)
		strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, strEXECUTOR)
		strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_EXECUTOR & "|" & strEMAIL_RESPONSAVEL & "|")
		
		MontaBody strBodyMsg _
					,3 _
					,"Chamado em Atendimento" _
					,"" _
					,strTITULO _
					,"EXECUTANDO" _
					,strCOD_CATEGORIA & " " & strCATEGORIA _
					,strPRIORIDADE _
					,strRESPONSAVEL _
					,strEXECUTOR _
					,strPREV_DT_INI_Orig _
					,"" _
					,strDESCRICAO_email & "<br><br>1a resposta:&nbsp;" & strRESPOSTA_email _
					,"" _
					,"TODOLIST" _
					,"T"
		
		'athdebug strBodyMsg, true
		
		AthEnviaMail strEMAIL_RESPONSAVEL,"virtualboss@virtualboss.com.br",strEMAIL_EXECUTOR & ";" & strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList",strBodyMsg,1, 0, 0,""
	End If
End If

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>