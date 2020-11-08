<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, objRSUser, objRSToDo
Dim objRSResp, objRSEnvia, auxTpMsg, strBodyMsg
Dim auxSTR, objRS1, objRS2
Dim strCODIGO, strPRIORIDADE, strEXECUTOR_TO
Dim strEXECUTOR_FROM, strSITUACAO, strRESPOSTA, strHORAS
Dim strMINUTOS, strHORASeMINUTOS, strMensagem, strDT_ALTERACAO
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strSIGILOSO, strFULLCATEGORIA 
Dim strEMAILS_MANAGER, strEMAIL_RESPONSAVEL, strEMAIL_EXECUTOR
Dim strJSCRIPT_ACTION, strLOCATION
Dim strCOD_CHAMADO, strSOLICITANTE, strVINCULO_CHAMADO
Dim strARQUIVO_ANEXO

strCODIGO         = GetParam("var_chavereg")
strEXECUTOR_TO    = LCase(GetParam("var_to"))
strEXECUTOR_FROM  = LCase(GetParam("var_from"))
strSITUACAO       = GetParam("var_situacao")
strPRIORIDADE     = GetParam("var_prioridade")
strRESPOSTA       = Replace(GetParam("var_resposta"),"'","<ASLW_APOSTROFE>") 
strSIGILOSO       = Replace(GetParam("var_sigiloso"),"'","<ASLW_APOSTROFE>")
strHORAS          = GetParam("var_horas")
strMINUTOS        = GetParam("var_minutos")
strTITULO         = GetParam("var_titulo")
strRESPONSAVEL    = LCase(GetParam("var_id_responsavel"))
strDESCRICAO      = GetParam("var_descricao")
strFULLCATEGORIA  = GetParam("var_cod_e_desc_categoria")
strARQUIVO_ANEXO  = GetParam("var_arquivo_anexo")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")

If strCODIGO = "" Or strEXECUTOR_TO = "" Or strEXECUTOR_FROM = "" Or strSITUACAO = "" Or strPRIORIDADE = "" Then
	Response.write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
End If

If strHORAS<>"" then
	If not isNumeric(strHORAS) then
		Response.write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
		Response.End()
	Else
		strHORASeMINUTOS = strHoras & "." & strMinutos
	End If
Else
	if (CInt(strMinutos)>0) then 
		strHORASeMINUTOS = "0." & Cstr(strMinutos)
	Else
		strHORASeMINUTOS ="NULL" 
	End If
End If
strHORASeMINUTOS = Replace(strHORASeMINUTOS , ",", ".")

AbreDBConn objConn, CFG_DB 

strDT_ALTERACAO = "'" & PrepDataBrToUni(now,true) & "'"

if strRESPOSTA = "" then strRESPOSTA = "NULL" else strRESPOSTA = "'" & strRESPOSTA & "'" end if	
if strSIGILOSO = "" then strSIGILOSO = "NULL" else strSIGILOSO = "'" & strSIGILOSO & "'" end if	

'Verifica se ToDo está relacionado a um chamado, se tiver deve afetar o conteúdo do email de aviso
strVINCULO_CHAMADO = "T" 'VerificaVinculoChamado(objConn, strCODIGO)

'Insere resposta ---------------------------------------------------------------------------------------------------------------
strSQL =          " INSERT INTO TL_RESPOSTA (COD_TODOLIST, ID_TO, ID_FROM, RESPOSTA, SIGILOSO, HORAS, DTT_RESPOSTA, ARQUIVO_ANEXO, SYS_ID_USUARIO_INS) " 
strSQL = strSQL & " VALUES ( " & strCODIGO & ", '" & strEXECUTOR_TO & "', '" & strEXECUTOR_FROM & "', " & strRESPOSTA & ", " & strSIGILOSO
strSQL = strSQL & "        , " & strHORASeMINUTOS & ", " & strDT_ALTERACAO & ", '" & strARQUIVO_ANEXO & "', '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' ) " 
'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_CHAMADO.InsertRespostaExec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If
'-------------------------------------------------------------------------------------------------------------------------------

'Atualiza a tarefa em si -------------------------------------------------------------------------------------------------------
strSQL =          " UPDATE TL_TODOLIST " 
strSQL = strSQL & " SET ID_ULT_EXECUTOR = '" & strEXECUTOR_TO & "' " 
strSQL = strSQL & "   , SITUACAO = '"        & strSITUACAO & "' " 
strSQL = strSQL & "   , PRIORIDADE = '"      & strPRIORIDADE & "' " 
strSQL = strSQL & "   , SYS_DTT_ALT = "      & strDT_ALTERACAO 
strSQL = strSQL & " WHERE COD_TODOLIST = "   & strCODIGO 
'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_CHAMADO.InsertRespostaExec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If
'-------------------------------------------------------------------------------------------------------------------------------

'Atualiza a situação do chamado vinculado a tarefa -----------------------------------------------------------------------------
strSQL = " SELECT COD_CHAMADO FROM CH_CHAMADO WHERE COD_TODOLIST = " & strCODIGO
Set objRS = objConn.Execute(strSQL)
If Not objRS.Eof Then
	strSQL =          " UPDATE CH_CHAMADO "
	strSQL = strSQL & " SET SITUACAO = '" & strSITUACAO & "' "
	strSQL = strSQL & " WHERE COD_CHAMADO = " & GetValue(objRS, "COD_CHAMADO") 
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_CHAMADO.InsertRespostaExec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
End If
FechaRecordSet objRS

'-------------------------------------------------------------------------------------------------------------------------------

'INIC: Envio de EMAIL ----------------------------------------------------------------------------------------------------------
'
'Manda mensagem:
' Para o próximo executor se for diferente do anterior "com todas as respostas junto"
' Para o responsável apenas essa última resposta para que o responsável fique sabendo que ouve um repasse
' ** por enquanto o responsável também recebe todo o histórico quando houver repasse
' Se fecha a tarefa então manda apenas para o responsável "com todas as respostas junto"
' Envia aos managers se cliente pediu tal configuração

auxTpMsg = 3
auxSTR = "Inserção de Resposta para Atendimento"

if strEXECUTOR_TO <> strEXECUTOR_FROM then
	strEMAIL_RESPONSAVEL = BuscaUserEMAIL(ObjConn, Replace(strRESPONSAVEL,"'",""))
	strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, Replace(strEXECUTOR_TO,"'",""))
	strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_RESPONSAVEL & "|" & strEMAIL_EXECUTOR & "|")
	
	MontaBodyFull strBodyMsg _
				 ,auxTpMsg _
				 ,auxSTR _
				 ,strCODIGO	_
				 ,strTITULO	_
				 ,strSITUACAO _
				 ,strFULLCATEGORIA _
				 ,strPRIORIDADE	_
				 ,strRESPONSAVEL _
				 ,strEXECUTOR_TO _
				 ,"" _
				 ,"" _
				 ,strDESCRICAO _
				 ,"" _
				 ,"TODOLIST" _
				 ,strVINCULO_CHAMADO
	
	'athDebug strBodyMsg, True
	
	'AthEnviaMail strEMAIL_RESPONSAVEL,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ")",strBodyMsg,1, 0, 0,""
	'AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ")",strBodyMsg,1, 0, 0,""
	AthEnviaMail strEMAIL_RESPONSAVEL,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList",strBodyMsg,1, 0, 0,""
	AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList",strBodyMsg,1, 0, 0,""
end if
'FIM: Envio de EMAIL -----------------------------------------------------------------------------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>