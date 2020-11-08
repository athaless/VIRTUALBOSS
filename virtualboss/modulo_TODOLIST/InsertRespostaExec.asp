<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, objRSUser, objRSToDo, strAuxSQL, objRSAux
Dim strTOTAL1, strTOTAL2, strTOTAL3
Dim objRSResp, objRSEnvia, auxTpMsg, strBodyMsg, strBodyBoletim
Dim auxSTR, objRS1, objRS2, objRS3
Dim strCODIGO, strPRIORIDADE, strEXECUTOR_TO
Dim strEXECUTOR_FROM, strSITUACAO, strRESPOSTA, strHORAS
Dim strMINUTOS, strHORASeMINUTOS, strMensagem, strDT_ALTERACAO, strDT_REALIZADO
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strSIGILOSO, strFULLCATEGORIA 
Dim strEMAILS_MANAGER, strEMAIL_RESPONSAVEL, strEMAIL_EXECUTOR
Dim strJSCRIPT_ACTION, strLOCATION
Dim strCOD_CHAMADO, strSOLICITANTE, strSITUACAO_BS, strCOD_BOLETIM, strDADOS_BOLETIM, strARQUIVO_ANEXO, strVINCULO_CHAMADO

strCODIGO         = GetParam("var_chavereg")
strCOD_BOLETIM    = GetParam("var_cod_boletim")
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
strHORASeMINUTOS = Replace(strHORASeMINUTOS, ",", ".")

AbreDBConn objConn, CFG_DB 

'Verifica se ToDo está relacionado a um chamado, se tiver deve afetar o conteúdo do email de aviso
strVINCULO_CHAMADO = VerificaVinculoChamado(objConn, strCODIGO)

strDT_ALTERACAO = "'" & PrepDataBrToUni(now,true) & "'"
strDT_REALIZADO = strDT_ALTERACAO

'Insere resposta ---------------------------------------------------------------------------------------------------------------
strSQL =          " INSERT INTO TL_RESPOSTA (COD_TODOLIST, ID_TO, ID_FROM, RESPOSTA, SIGILOSO, HORAS, DTT_RESPOSTA, ARQUIVO_ANEXO, SYS_ID_USUARIO_INS) " 
strSQL = strSQL & " VALUES ( " & strCODIGO & ", '" & strEXECUTOR_TO & "', '" & strEXECUTOR_FROM & "', '" & strRESPOSTA & "', '" & strSIGILOSO & "' "
strSQL = strSQL & "        , " & strHORASeMINUTOS & ", " & strDT_ALTERACAO & ", '" & strARQUIVO_ANEXO & "', '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' ) " 
strAuxSQL = strSQL

'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_TODOLIST.InsertRespostasExec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If
'-------------------------------------------------------------------------------------------------------------------------------

'Atualiza a situação do chamado vinculado a tarefa -----------------------------------------------------------------------------
strCOD_CHAMADO = ""
strSOLICITANTE = ""

strSQL = " SELECT COD_CHAMADO, SYS_ID_USUARIO_INS FROM CH_CHAMADO WHERE COD_TODOLIST = " & strCODIGO
Set objRS = objConn.Execute(strSQL)
If Not objRS.Eof Then
	strCOD_CHAMADO = GetValue(objRS, "COD_CHAMADO") 
	strSOLICITANTE = GetValue(objRS, "SYS_ID_USUARIO_INS")
	
	strSQL =          " UPDATE CH_CHAMADO "
	strSQL = strSQL & " SET SITUACAO = '" & strSITUACAO & "' "
	strSQL = strSQL & " WHERE COD_CHAMADO = " & strCOD_CHAMADO
	strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_TODOLIST.InsertRespostasExec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
End If
'-----------------------------------------------------------------------------------------
'Se o ToDo desta resposta é ligado ao Chamado então o último executor seja alguém  
'do atendimento e não o cliente (responsável do ToDo por ser solicitante do chamado)
'-----------------------------------------------------------------------------------------


'Atualiza a tarefa em si -------------------------------------------------------------------------------------------------------
strSQL =          " UPDATE TL_TODOLIST " 
strSQL = strSQL & " SET SITUACAO = '" & strSITUACAO & "' " 
strSQL = strSQL & "   , PRIORIDADE = '" & strPRIORIDADE & "' " 
strSQL = strSQL & "   , SYS_DTT_ALT = " & strDT_ALTERACAO 
If strCOD_CHAMADO <> "" Then
	If strSOLICITANTE = strEXECUTOR_TO Then
		strSQL = strSQL & ", ID_ULT_EXECUTOR = '" & strEXECUTOR_FROM & "' " 
	Else
		strSQL = strSQL & ", ID_ULT_EXECUTOR = '" & strEXECUTOR_TO & "' " 
	End If
Else
	strSQL = strSQL & ", ID_ULT_EXECUTOR = '" & strEXECUTOR_TO & "' " 
End If
If strSITUACAO = "FECHADO" Then
	strSQL = strSQL & "   , DT_REALIZADO = " & strDT_REALIZADO 
Else
	strSQL = strSQL & "   , DT_REALIZADO = NULL "
End If
strSQL = strSQL & " WHERE COD_TODOLIST = " & strCODIGO 

strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL
'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_TODOLIST.InsertRespostasExec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If
'-------------------------------------------------------------------------------------------------------------------------------

athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "TL_RESPOSTA, TL_TODOLIST e CH_CHAMADO", strAuxSQL

'Altera situação da atividade
If strCOD_BOLETIM <> "" Then MudaSituacaoBS objConn, strCOD_BOLETIM
	
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

if strEXECUTOR_TO <> strEXECUTOR_FROM then
	strBodyBoletim = ""
	strDADOS_BOLETIM = ""
	
	If strCOD_BOLETIM <> "" Then
		'Informações do boletim no email
		strSQL =          " SELECT T1.TITULO, T1.ID_RESPONSAVEL, T1.MODELO, T2.COD_CATEGORIA, T2.NOME AS CATEGORIA, T3.NOME_COMERCIAL AS CLIENTE "
		strSQL = strSQL & " FROM BS_BOLETIM T1 "
		strSQL = strSQL & " LEFT OUTER JOIN BS_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T3 ON (T1.COD_CLIENTE = T3.COD_CLIENTE) "
		strSQL = strSQL & " WHERE COD_BOLETIM = " & strCOD_BOLETIM
		
		AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
		
		if not objRSAux.Eof then
			if GetValue(objRSAux,"MODELO") <> "MODELO" then
				strDADOS_BOLETIM = GetValue(objRSAux,"CLIENTE") & " - " & GetValue(objRSAux,"TITULO")
				
				strBodyBoletim = strBodyBoletim &_
				"<tr><td align='right' valign='top' width='10%' nowrap>Boletim:&nbsp;</td><td width='90%'>"     & strCOD_BOLETIM & "&nbsp;-&nbsp;" & GetValue(objRSAux,"TITULO") & "</td></tr>" & VbCrlf &_
				"<tr><td align='right' valign='top' width='10%' nowrap>Categoria:&nbsp;</td><td width='90%'>"   & GetValue(objRSAux,"COD_CATEGORIA") & "&nbsp;-&nbsp;" & GetValue(objRSAux,"CATEGORIA") & "</td></tr>" & VbCrlf &_
				"<tr><td align='right' valign='top' width='10%' nowrap>Cliente:&nbsp;</td><td width='90%'>"     & GetValue(objRSAux,"CLIENTE") & "</td></tr>" & VbCrlf &_
				"<tr><td align='right' valign='top' width='10%' nowrap>Responsável:&nbsp;</td><td width='90%'>" & GetValue(objRSAux,"ID_RESPONSAVEL") & "</td></tr>" & VbCrlf &_
				"<tr><td height='16px'></td></tr>" & VbCrlf &_
				"<tr><td colspan='2'><table width='90%' align='center' cellspacing='0' cellpadding='1' border='0'><tr><td height='1' bgcolor='#C9C9C9'></td></tr></table></tr>" & VbCrlf &_
				"<tr><td height='16px'></td></tr>" & VbCrlf
			end if
		end if
		FechaRecordSet objRSAux
	End If
	
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
				 ,strBodyBoletim _
				 ,"TODOLIST" _
				 ,strVINCULO_CHAMADO
	
	'athDebug strBodyMsg, True
	
	If strVINCULO_CHAMADO = "T" Then
		AthEnviaMail strEMAIL_RESPONSAVEL,"noreply@proeventovista.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList",strBodyMsg,1, 0, 0,""
		AthEnviaMail strEMAIL_EXECUTOR,"noreply@proeventovista.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList",strBodyMsg,1, 0, 0,""
	Else
		If strDADOS_BOLETIM <> "" Then
			AthEnviaMail strEMAIL_RESPONSAVEL,"noreply@proeventovista.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ") Atividade (" & strDADOS_BOLETIM & ")",strBodyMsg,1,0,0,""
			AthEnviaMail strEMAIL_EXECUTOR,"noreply@proeventovista.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ") Atividade (" & strDADOS_BOLETIM & ")",strBodyMsg,1,0,0,""
		Else
			AthEnviaMail strEMAIL_RESPONSAVEL,"noreply@proeventovista.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ")",strBodyMsg,1,0,0,""
			AthEnviaMail strEMAIL_EXECUTOR,"noreply@proeventovista.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (de " & strEXECUTOR_FROM & " para " & strEXECUTOR_TO & ")",strBodyMsg,1,0,0,""
		End If
	End If
end if
'FIM: Envio de EMAIL -----------------------------------------------------------------------------------------------------------

FechaRecordSet objRS
FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>