<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, objRSUser, objRSToDo, objRSResp, objRSEnvia, auxTpMsg, strBodyMsg, auxSTR 
Dim objRS1, objRS2
Dim strCODIGO, strCOD_BOLETIM, strPRIORIDADE, strEXECUTOR_TO, strEXECUTOR_FROM 
Dim strSITUACAO, strRESPOSTA, strHORAS, strMINUTOS, strHORASeMINUTOS
Dim strMensagem, strDT_ALTERACAO, strDT_REALIZADO  
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strFULLCATEGORIA 
Dim strEMAILS_MANAGER, strEMAIL_RESPONSAVEL, strEMAIL_EXECUTOR, strVINCULO_CHAMADO
Dim strJSCRIPT_ACTION, strLOCATION

strCODIGO         = Replace(GetParam("var_chavereg"),"'","''")
strCOD_BOLETIM    = Replace(GetParam("var_codigo"),"'","''") 'COD_BOLETIM (BS_BOLETIM)
strEXECUTOR_TO    = LCase(GetParam("var_TO"))
strEXECUTOR_FROM  = LCase(GetParam("var_FROM"))
strSITUACAO       = GetParam("var_situacao")
strPRIORIDADE     = GetParam("var_prioridade")
strRESPOSTA       = Replace(GetParam("var_resposta"),"'","<ASLW_APOSTROFE>") 
strHORAS          = GetParam("var_horas")
strMINUTOS        = GetParam("var_minutos")
strTITULO         = GetParam("var_titulo")
strRESPONSAVEL    = LCase(GetParam("var_id_responsavel"))
strDESCRICAO      = GetParam("var_descricao")
strFULLCATEGORIA  = GetParam("var_cod_e_desc_categoria")
strJSCRIPT_ACTION = GetParam("var_jscript_action")
strLOCATION       = GetParam("var_location")

if strCODIGO = "" or strEXECUTOR_TO = "" or strEXECUTOR_FROM = "" or strSITUACAO = "" or strPRIORIDADE = "" then
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
end if

if strHORAS<>"" then
	if not isNumeric(strHORAS) then
		Response.Write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
		Response.End()
	else
		strHORASeMINUTOS = strHoras & "." & strMinutos
	end if
else
	if (CInt(strMinutos)>0) then 
		strHORASeMINUTOS = "0." & Cstr(strMinutos)
	else
		strHORASeMINUTOS ="NULL" 
	end if
end if
strHORASeMINUTOS = Replace(strHORASeMINUTOS , ",", ".")

AbreDBConn objConn, CFG_DB 
	
strDT_ALTERACAO = "'" & PrepDataBrToUni(now,true) & "'"
strDT_REALIZADO = strDT_ALTERACAO

if strRESPOSTA = "" then
	strRESPOSTA = "Null" 
else
	strRESPOSTA = "'" & strRESPOSTA & "'"
end if	

'Verifica se ToDo está relacionado a um chamado, se tiver deve afetar o conteúdo do email de aviso
strVINCULO_CHAMADO = "" 'VerificaVinculoChamado(objConn, strCODIGO)

'Insere resposta --------------------------------------------------------------------------------------------------------
strSQL =          " INSERT INTO TL_RESPOSTA (COD_TODOLIST, ID_TO, ID_FROM, RESPOSTA, DTT_RESPOSTA, HORAS,SYS_ID_USUARIO_INS) " 
strSQL = strSQL & " VALUES (" & strCODIGO & ", '" & strEXECUTOR_TO & "', '" & strEXECUTOR_FROM & "', " & strRESPOSTA
strSQL = strSQL & ", " & strDT_ALTERACAO & ", " & strHORASeMINUTOS & ", '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' ) " 
'AQUI: NEW TRANSACTION
set objRSCT = objConn.Execute("start transaction")
set objRSCT = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_BS.InsertRespostaExec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If
'-------------------------------------------------------------------------------------------------------------------------	

'Atualiza a tarefa em si -------------------------------------------------------------------------------------------------
strSQL =          " UPDATE TL_TODOLIST " 
strSQL = strSQL & " SET ID_ULT_EXECUTOR = '" & strEXECUTOR_TO & "' " 
strSQL = strSQL & "   , SITUACAO = '"        & strSITUACAO & "' " 
strSQL = strSQL & "   , PRIORIDADE = '"      & strPRIORIDADE & "' " 
strSQL = strSQL & "   , SYS_DTT_ALT = "      & strDT_ALTERACAO 
If strSITUACAO = "FECHADO" Then
	strSQL = strSQL & "   , DT_REALIZADO = " & strDT_REALIZADO 
Else
	strSQL = strSQL & "   , DT_REALIZADO = NULL "
End If
strSQL = strSQL & " WHERE COD_TODOLIST = "   & strCODIGO

'AQUI: NEW TRANSACTION
set objRSCT = objConn.Execute("start transaction")
set objRSCT = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_BS.InsertRespostaExec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If
'-------------------------------------------------------------------------------------------------------------------------	

'Altera situação da atividade
If strCOD_BOLETIM <> "" Then MudaSituacaoBS objConn, strCOD_BOLETIM

'INIC: Envio de EMAIL -------------------------------------------------------
'Manda mensagem:
' Para o próximo executor se for diferente do anterior "com todas as respostas junto"
'   Para o responsável apenas essa última resposta para que o responsável fique sabendo que ouve um repasse
'      ** por enquanto o responsável também recebe todo o histórico quando houver repasse
' Se fecha a tarefa então manda apenas para o responsável "com todas as respostas junto"
auxTpMsg = 3
auxSTR = "Inserção de Resposta"
if strSITUACAO="FECHADO" then 
	auxTpMsg = 4 
	auxSTR="Fechamento de Tarefa"
end if

if strEXECUTOR_TO <> strEXECUTOR_FROM then
	strEMAIL_RESPONSAVEL = BuscaUserEMAIL(ObjConn, Replace(strRESPONSAVEL,"'",""))
	strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, Replace(strEXECUTOR_TO,"'",""))
	strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_RESPONSAVEL & "|" & strEMAIL_EXECUTOR & "|")
	
	MontaBodyFull strBodyMsg _
					 ,auxTpMsg _
					 ,auxSTR _
					 ,strCODIGO _
					 ,strTITULO _
					 ,strSITUACAO _
					 ,strFULLCATEGORIA _
					 ,strPRIORIDADE _
					 ,strRESPONSAVEL _
					 ,strEXECUTOR_TO _
					 ,"" _
					 ,"" _
					 ,strDESCRICAO _
					 ,"" _
					 ,"TODOLIST" _
					 ,strVINCULO_CHAMADO
	
	'athDebug strBodyMsg, True
	
	If strVINCULO_CHAMADO = "T" Then
		AthEnviaMail strEMAIL_RESPONSAVEL,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList",strBodyMsg,1, 0, 0,""
		if strSITUACAO<>"FECHADO" then 
			AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList",strBodyMsg,1, 0, 0,""
		end if
	Else
		AthEnviaMail strEMAIL_RESPONSAVEL,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR_TO & ")",strBodyMsg,1, 0, 0,""
		if strSITUACAO<>"FECHADO" then 
			AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ")",strBodyMsg,1, 0, 0,""
		end if
	End If
end if 
'FIM: Envio de EMAIL ------------------------------------------------------------------------------------------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>