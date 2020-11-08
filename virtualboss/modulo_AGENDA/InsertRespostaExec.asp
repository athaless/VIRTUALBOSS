<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Dim strSQL, objRS, objRSCT, objConn, auxTpMsg, strBodyMsg, auxSTR 
Dim strCODIGO, strPRIORIDADE, strCITADOS_TO, strEXECUTOR_FROM, strSITUACAO, strRESPOSTA
Dim strHORAS, strMINUTOS, strHORASeMINUTOS, strMensagem, strDT_ALTERACAO, strDT_REALIZADO  
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strFULLCATEGORIA , strDestMail, strPREV_DT_INI
Dim strJSCRIPT_ACTION, strLOCATION

strCODIGO        = Replace(GetParam("var_chavereg"),"'","''")
strCITADOS_TO    = Replace(GetParam("var_id_citados")," ","")
strEXECUTOR_FROM = GetParam("var_FROM")
strSITUACAO      = GetParam("var_situacao")
strPRIORIDADE    = GetParam("var_prioridade")
strRESPOSTA      = Replace(GetParam("var_resposta"),"'","<ASLW_APOSTROFE>") 
strHORAS         = GetParam("var_horas")
strMINUTOS       = GetParam("var_minutos")
strDT_REALIZADO  = GetParam("var_dt_realizado")
strPREV_DT_INI   = PrepData(GetParam("var_PREV_DT_INI"),true,false)
strTITULO        = GetParam("var_titulo")
strRESPONSAVEL   = GetParam("var_id_responsavel")
strDESCRICAO     = GetParam("var_DESCRICAO")
strFULLCATEGORIA = GetParam("var_cod_e_desc_categoria")
strJSCRIPT_ACTION = GetParam("var_jscript_action")
strLOCATION       = GetParam("var_location")

if strCODIGO="" Or strCITADOS_TO="" Or strEXECUTOR_FROM="" Or strSITUACAO="" Or strPRIORIDADE="" Or (strDT_REALIZADO<>"" And not IsDate(strDT_REALIZADO)) Then
	Response.write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
end If

if strHORAS<>"" then
	if not IsNumeric(strHORAS) then
		Response.write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
		Response.End()
	else
		strHORASeMINUTOS = strHoras & "." & strMinutos
	End if
else
	if (CInt(strMinutos)>0) then 
		strHORASeMINUTOS = "0." & Cstr(strMinutos)
	else
		strHORASeMINUTOS ="NULL" 
	end If
end If
strHORASeMINUTOS = Replace(strHORASeMINUTOS , ",", ".")

if mid(strCITADOS_TO,1,1)<>";" then strCITADOS_TO = ";" & strCITADOS_TO 
if mid(strCITADOS_TO,Len(strCITADOS_TO))<>";" then strCITADOS_TO = strCITADOS_TO & ";"

AbreDBConn objConn, CFG_DB 

strDT_ALTERACAO = "'" & PrepDataBrToUni(now,true) & "'"
if not IsDate(strDT_REALIZADO) then strDT_REALIZADO = "Null" else strDT_REALIZADO = "'" & PrepDataBrToUni(strDT_REALIZADO,true) & "'"
 
if strRESPOSTA = "" then
	strRESPOSTA = "NULL" 
else
	strRESPOSTA = "'" & strRESPOSTA & "'"
end if	
 
 'Insere resposta --------------------------------------------------------------------------------------------------------
 strSQL =          " INSERT INTO AG_RESPOSTA (COD_AGENDA, ID_TO, ID_FROM, RESPOSTA, DTT_RESPOSTA, HORAS,SYS_ID_USUARIO_INS) " 
 strSQL = strSQL & " VALUES (" & strCODIGO & ", '" & strCITADOS_TO & "', '" & strEXECUTOR_FROM & "', " & strRESPOSTA
 strSQL = strSQL & ", " & strDT_ALTERACAO & ", " & strHORASeMINUTOS & ", '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' ) " 
 'Response.Write(strSQL)
 'Response.End
 objConn.Execute(strSQL) 
 '-------------------------------------------------------------------------------------------------------------------------	

 'Atualiza a tarefa em si -------------------------------------------------------------------------------------------------
 strSQL =          " UPDATE AG_AGENDA " 
 strSQL = strSQL & " SET ID_CITADOS = '"		 & strCITADOS_TO & "' " 
 strSQL = strSQL & "   , ID_ULT_EXECUTOR = '" & strEXECUTOR_FROM & "' " 
 strSQL = strSQL & "   , SITUACAO = '"        & strSITUACAO & "' " 
 strSQL = strSQL & "   , PRIORIDADE = '"      & strPRIORIDADE & "' " 
 strSQL = strSQL & "   , SYS_DTT_ALT = "      & strDT_ALTERACAO 
 strSQL = strSQL & "   , DT_REALIZADO = "     & strDT_REALIZADO 
 strSQL = strSQL & " WHERE COD_AGENDA = "   & strCODIGO 

 'AQUI: NEW TRANSACTION
 set objRSCT = objConn.Execute("start transaction")
 set objRSCT = objConn.Execute("set autocommit = 0")
 objConn.Execute(strSQL) 
 If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_AGENDA.InsertRespostaExec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
 else
	set objRSCT = objConn.Execute("commit")
 End If

 '-------------------------------------------------------------------------------------------------------------------------	


if mid(strCITADOS_TO,1,1)=";" then strCITADOS_TO = mid(strCITADOS_TO,2)	


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

if strCITADOS_TO<>strEXECUTOR_FROM then
	MontaBodyFull strBodyMsg _
					 ,auxTpMsg _
					 ,auxSTR _
					 ,strCODIGO _
					 ,strTITULO _
					 ,strSITUACAO _
					 ,strFULLCATEGORIA _
					 ,strPRIORIDADE _
					 ,strRESPONSAVEL _
					 ,strCITADOS_TO _
					 ,strPREV_DT_INI _
					 ,GetParam("var_dt_realizado") _
					 ,strDESCRICAO _
					 ,"" _
					 ,"AGENDA" _
					 ,""
 'athDebug strBodyMsg, True
 
	'-- Busca o email dos citados -------------------------------
 	strDestMail = Replace(strCITADOS_TO," ","")
	strDestMail = "'" & Replace(strDestMail,";","','") & "'"
	
	strSQL = 			"SELECT 	EMAIL "
	strSQL = strSQL & "FROM		USUARIO "
	strSQL = strSQL & "WHERE	ID_USUARIO IN (" & strDestMail & ")"	
	Set objRS = objConn.Execute(strSQL)
	
	strDestMail = ""	
	while not objRS.Eof
		strDestMail = strDestMail & objRS("EMAIL") & ";"
		objRS.MoveNext
	wend
	'------------------------------------------------------------------
 
	AthEnviaMail BuscaUserEMAIL(objConn, Replace(strRESPONSAVEL,"'","")),"virtualboss@virtualboss.com.br","","ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: Agenda",strBodyMsg,1, 0, 0,""
	if strSITUACAO<>"FECHADO" then 
		AthEnviaMail strDestMail,"virtualboss@virtualboss.com.br","","ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: Agenda",strBodyMsg,1, 0, 0,""
	end if
end if 
'FIM: Envio de EMAIL ------------------------------------------------------------------------------------------------------------------------

FechaDBConn objConn	
'Response.Redirect("InsertResposta.asp?var_chavereg=" & strCODIGO)


'response.write "<script>"
'If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
'If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
'response.write "</script>"
%>
<script language="JavaScript">parent.location ='<%="DetailHistorico.asp?var_chavereg=" & strCODIGO & "&var_resposta=true"%>';</script>
