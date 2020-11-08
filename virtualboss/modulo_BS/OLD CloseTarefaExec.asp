<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Dim strSQL, objRS, ObjConn, objRSUser, objRSToDo
Dim objRSResp, objRSEnvia, auxTpMsg, strBodyMsg
Dim auxSTR, objRS1, objRS2
Dim strCODIGO, strPRIORIDADE, strEXECUTOR_TO
Dim strEXECUTOR_FROM, strSITUACAO, strRESPOSTA, strHORAS
Dim strMINUTOS, strHORASeMINUTOS, strMensagem, strDT_ALTERACAO
Dim strDT_REALIZADO, strREALIZADO, strTITULO, strRESPONSAVEL, strDESCRICAO, strSIGILOSO, strFULLCATEGORIA 
Dim strEMAILS_MANAGER, strEMAIL_RESPONSAVEL, strEMAIL_EXECUTOR
Dim strJSCRIPT_ACTION, strLOCATION

strCODIGO        = GetParam("var_chavereg")
strEXECUTOR_TO   = LCase(GetParam("var_to"))
strEXECUTOR_FROM = LCase(GetParam("var_from"))
strSITUACAO      = GetParam("var_situacao")
strPRIORIDADE    = GetParam("var_prioridade")
strRESPOSTA      = Replace(GetParam("var_resposta"),"'","<ASLW_APOSTROFE>") 
'strSIGILOSO      = Replace(GetParam("var_sigiloso"),"'","<ASLW_APOSTROFE>")
'strHORAS         = GetParam("var_horas")
'strMINUTOS       = GetParam("var_minutos")
strDT_REALIZADO  = GetParam("var_dt_realizado")
strREALIZADO     = GetParam("var_dt_realizado") 'Usado para email
strTITULO        = GetParam("var_titulo")
strRESPONSAVEL   = LCase(GetParam("var_id_responsavel"))
strDESCRICAO     = GetParam("var_descricao")
strFULLCATEGORIA = GetParam("var_cod_e_desc_categoria")

If strCODIGO = "" Or strEXECUTOR_TO = "" Or strEXECUTOR_FROM = "" Or (strDT_REALIZADO <> "" And not IsDate(strDT_REALIZADO)) Then
	Response.write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
End If

'If strHORAS<>"" then
'	If not isNumeric(strHORAS) then
'		Response.write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
'		Response.End()
'	Else
'		strHORASeMINUTOS = strHoras & "." & strMinutos
'	End If
'Else
'	if (CInt(strMinutos)>0) then 
'		strHORASeMINUTOS = "0." & Cstr(strMinutos)
'	Else
'		strHORASeMINUTOS ="NULL" 
'	End If
'End If
'strHORASeMINUTOS = Replace(strHORASeMINUTOS , ",", ".")

AbreDBConn objConn, CFG_DB 

strDT_ALTERACAO = "'" & PrepDataBrToUni(now(),true) & "'"
if not isDate(strDT_REALIZADO) then
	strDT_REALIZADO = "Null" 
else
	strDT_REALIZADO = "'" & PrepDataBrToUni(strDT_REALIZADO,true) & "'" 
end if

if strRESPOSTA = "" then strRESPOSTA = "Null" else strRESPOSTA = "'" & strRESPOSTA & "'" end if	
'if strSIGILOSO = "" then strSIGILOSO = "Null" else strSIGILOSO = "'" & strSIGILOSO & "'" end if	

'Insere resposta ---------------------------------------------------------------------------------------------------------------
strSQL =          " INSERT INTO TL_RESPOSTA (COD_TODOLIST, ID_TO, ID_FROM, RESPOSTA, DTT_RESPOSTA, SYS_ID_USUARIO_INS) " 
strSQL = strSQL & " VALUES ( " & strCODIGO & ", '" & strEXECUTOR_TO & "', '" & strEXECUTOR_FROM & "', " & strRESPOSTA 
strSQL = strSQL & "        , " & strDT_ALTERACAO & ", '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "') " 
objConn.Execute(strSQL) 
'-------------------------------------------------------------------------------------------------------------------------------	

'Atualiza a tarefa em si -------------------------------------------------------------------------------------------------------
strSQL =          " UPDATE TL_TODOLIST " 
strSQL = strSQL & " SET SITUACAO = 'FECHADO' " 
strSQL = strSQL & "   , ID_ULT_EXECUTOR = '" & strEXECUTOR_TO & "' " 
strSQL = strSQL & "   , SYS_DTT_ALT = "      & strDT_ALTERACAO 
strSQL = strSQL & "   , DT_REALIZADO = "     & strDT_REALIZADO 
strSQL = strSQL & " WHERE COD_TODOLIST = "   & strCODIGO 
objConn.Execute(strSQL) 
'-------------------------------------------------------------------------------------------------------------------------------	

'Atualiza o chamado vinculado a tarefa -----------------------------------------------------------------------------------------
'strSQL = " SELECT COD_CHAMADO FROM CH_CHAMADO WHERE COD_TODOLIST = " & strCODIGO

'Set objRS = objConn.Execute(strSQL)
'If Not objRS.Eof Then
'	strSQL = " UPDATE CH_CHAMADO SET SITUACAO = 'FECHADO' WHERE COD_CHAMADO = " & GetValue(objRS, "COD_CHAMADO") 
'	objConn.Execute(strSQL)
'End If
'FechaRecordSet objRS
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
auxSTR = "Inserção de Resposta"

if strSITUACAO="FECHADO" then 
	auxTpMsg = 4 
	auxSTR="Fechamento de Tarefa"
end if

if strEXECUTOR_TO <> strEXECUTOR_FROM then
	strEMAIL_RESPONSAVEL = BuscaUserEMAIL(ObjConn, Replace(strRESPONSAVEL,"'",""))
	strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, Replace(strEXECUTOR_TO,"'",""))
	strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_RESPONSAVEL & "|" & strEMAIL_EXECUTOR & "|")
	
	MontaBodyFull strBodyMsg 	_
						,auxTpMsg 	_
						,auxSTR		_
						,strCODIGO 	_
						,strTITULO 	_
						,strSITUACAO _
						,strFULLCATEGORIA _
						,strPRIORIDADE 	_
						,strRESPONSAVEL 	_
						,strEXECUTOR_TO 	_
						,"" _
						,strREALIZADO _
						,strDESCRICAO
	
	AthEnviaMail strEMAIL_RESPONSAVEL,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ")",strBodyMsg,1, 0, 0,""
	if strSITUACAO<>"FECHADO" then 
		AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ")",strBodyMsg,1, 0, 0,""
	end if
end if
'FIM: Envio de EMAIL -----------------------------------------------------------------------------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>