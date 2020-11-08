<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="athEnviaAlert.asp"--> 
<%
Session.LCID = 1046 

Dim strSQL, objRS, objConn, strBodyMsg, auxTpMsg, strBodyBoletim, auxSTR, objRSCT   
Dim strCOD, strTITULO, strPRIORIDADE, strRESPONSAVEL, strEXECUTOR
Dim strSITUACAO, strDESCRICAO, strPREV_DT_INI, strPREV_HR_INI
Dim strDT_REALIZADO, strCOD_BOLETIM, strBS_TIPO
Dim strCODCATEGORIA, strDESCCATEGORIA, strARQUIVO_ANEXO 'strArquivoAnexo, strRetArquivo, strArquivo
Dim strHORAS, strMINUTOS, strHORASeMINUTOS
Dim strDT_INI, strDT_FIM, strDtAnt_INI, strDtAnt_FIM
Dim objFSO	
Dim strEMAILS_MANAGER, strEMAIL_EXECUTOR
Dim strJSCRIPT_ACTION, strLOCATION

strCOD_BOLETIM	 = GetParam("VAR_BOLETIM")
strCOD           = GetParam("var_cod_todolist")
strTITULO        = GetParam("var_titulo")
strRESPONSAVEL   = LCase(GetParam("var_ID_RESPONSAVEL"))
strEXECUTOR      = LCase(GetParam("var_ID_ULT_EXECUTOR"))
strSITUACAO      = GetParam("var_situacao")
strPRIORIDADE    = GetParam("var_prioridade")
strDESCRICAO     = Replace(GetParam("var_DESCRICAO"),"'","<ASLW_APOSTROFE>")
strPREV_DT_INI   = GetParam("VAR_PREV_DT_INI")
strPREV_HR_INI   = GetParam("var_prev_hr_ini_hora") & ":" & GetParam("var_prev_hr_ini_min")
strDT_REALIZADO  = GetParam("VAR_DT_REALIZADO")
strCODCATEGORIA  = GetParam("var_cod_e_desc_categoria")
strDESCCATEGORIA = GetParam("var_cod_e_desc_categoria") 'Apenas para o e-mail
strDtAnt_INI     = GetParam("var_data_ini_ant")
strDtAnt_FIM     = GetParam("var_data_fim_ant")
strARQUIVO_ANEXO = GetParam("var_arquivo_anexo")
'strRetArquivo	 = GetParam("req_arquivo_anexo")
strHORAS         = GetParam("var_prev_horas")
strMINUTOS       = GetParam("var_prev_minutos")
strBS_TIPO		 = GetParam("var_tipo")
strJSCRIPT_ACTION = GetParam("var_jscript_action")
strLOCATION       = GetParam("var_location")

strDT_INI = strPREV_DT_INI

if strCOD="" or strRESPONSAVEL="" or strTITULO="" or strCODCATEGORIA="" or strPRIORIDADE=""  then
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
end if 

strCODCATEGORIA = Mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1) 'Extrai aopenas o Código da cateroria da String

if not IsDate(strPREV_DT_INI)  then strPREV_DT_INI ="Null" else strPREV_DT_INI ="'" & PrepDataBrToUni(strPREV_DT_INI,true)  & "'" End If
if not IsDate(strDT_REALIZADO) then strDT_REALIZADO="Null" else strDT_REALIZADO="'" & PrepDataBrToUni(strDT_REALIZADO,true) & "'" End If

If strPREV_HR_INI = ":" Then 
	strPREV_HR_INI = ""
Else
	If InStr(strPREV_HR_INI, ":") = 1                   Then strPREV_HR_INI = "00" & strPREV_HR_INI
	If InStr(strPREV_HR_INI, ":") = Len(strPREV_HR_INI) Then strPREV_HR_INI = strPREV_HR_INI & "00"
End If

if strHORAS<>"" then
	if not IsNumeric(strHORAS) then
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


AbreDBConn objConn, CFG_DB

strSQL = "UPDATE TL_TODOLIST SET " &_ 
			"  ID_RESPONSAVEL = '"   & strRESPONSAVEL  & "'" & " ,ID_ULT_EXECUTOR= '" & strEXECUTOR     & "',ARQUIVO_ANEXO = '" & strARQUIVO_ANEXO & "'"& _
			" ,TITULO = '"           & strTITULO       & "'" & " ,DESCRICAO = '"      & strDESCRICAO    & "'" & _
			" ,PRIORIDADE = '"       & strPRIORIDADE   & "'" & _
			" ,COD_CATEGORIA = "     & strCODCATEGORIA &_ 
			" ,PREV_DT_INI = "       & strPREV_DT_INI  & "       ,PREV_HR_INI = '"    & strPREV_HR_INI & "' ,PREV_HORAS = "     & strHORASeMINUTOS &_ 
			" ,DT_REALIZADO = "      & strDT_REALIZADO & _
			" WHERE COD_TODOLIST = " & strCOD
'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
 	set objRS = objConn.Execute("rollback")
    Mensagem "modulo_BS.OLD Update_ToDoExec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
    response.End()
else
 	set objRS = objConn.Execute("commit")
End If

'Altera a situação do BS, se estiver "FECHADO", se alguma tarefa for alterada
'strSQL = "SELECT SITUACAO FROM BS_BOLETIM WHERE COD_BOLETIM =" & strCOD_BOLETIM
'AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
'if GetValue(objRS,"SITUACAO")="FECHADO" and strSITUACAO<>"FECHADO" then 	
'	strSQL = "UPDATE BS_BOLETIM SET SITUACAO='"& strSITUACAO &"' WHERE COD_BOLETIM=" & strCOD_BOLETIM	
'	objConn.Execute(strSQL)
'end if
 
'Se trocou a Data de Agendamento então grava uma resposta (de sistema) para "log" desta operação --------------------------------------------
if (strDtAnt_INI<>strDT_INI) then
	strSQL = " INSERT INTO TL_RESPOSTA (COD_TODOLIST, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA) VALUES ( " &_
				"'" & strCOD & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'," &_
				" '" & "MENSAGEM DO SISTEMA - Data de início alterada de " & strDtAnt_INI & " para " & strDT_INI & "', '" & PrepDataBrToUni(Now,true) & "')"
	objConn.Execute(strSQL)
end if
'--------------------------------------------------------------------------------------------------------------------------------------------



'--------------------------------------------------------------------------------------------------------------------------------------------
' Informações do boletim no email
'--------------------------------------------------------------------------------------------------------------------------------------------
strBodyBoletim = ""
strSQL = "SELECT"																	&_
			"	T1.TITULO, T1.ID_RESPONSAVEL," 										&_
			"	T2.COD_CATEGORIA,	T2.NOME AS CATEGORIA," 							&_
			"	T3.NOME_COMERCIAL AS CLIENTE "										&_
			"FROM "																	&_
			"	BS_BOLETIM T1 " 													&_
			"LEFT OUTER JOIN"														&_
			"	BS_CATEGORIA T2 ON (T1.COD_CATEGORIA=T2.COD_CATEGORIA) "			&_
			"LEFT OUTER JOIN" 														&_
			"	ENT_CLIENTE T3 ON (T1.COD_CLIENTE=T3.COD_CLIENTE) " 				&_
			"WHERE" 																&_
			"	COD_BOLETIM =" & strCOD_BOLETIM

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
if not objRS.Eof then
	strBodyBoletim = strBodyBoletim &_

	"<tr><td align='right' valign='top' width='10%' nowrap>Boletim:&nbsp;</td><td width='90%'>"		& strCOD_BOLETIM  & "&nbsp;-&nbsp;" & GetValue(objRS,"TITULO") &	"</td></tr>" & VbCrlf &_
	"<tr><td align='right' valign='top' width='10%' nowrap>Categoria:&nbsp;</td><td width='90%'>"	& AthFormataTamLeft(GetValue(objRS,"COD_CATEGORIA"),Len(strCOD_BOLETIM),"0") 	& "&nbsp;-&nbsp;" & GetValue(objRS,"CATEGORIA") & "</td></tr>" & VbCrlf &_
	"<tr><td align='right' valign='top' width='10%' nowrap>Cliente:&nbsp;</td><td width='90%'>"		& GetValue(objRS,"CLIENTE") 			& "</td></tr>" & VbCrlf &_
	"<tr><td align='right' valign='top' width='10%' nowrap>Responsável:&nbsp;</td><td width='90%'>"	& GetValue(objRS,"ID_RESPONSAVEL")	& "</td></tr>" & VbCrlf &_
	"<tr><td height='16px'></td></tr>" & VbCrlf &_
	"<tr><td colspan='2'><table width='90%' align='center' cellspacing='0' cellpadding='1' border='0'><tr><td height='1' bgcolor='#C9C9C9'></td></tr></table></tr>" & VbCrlf &_
	"<tr><td height='16px'></td></tr>" & VbCrlf

	FechaRecordSet objRS
end if



'INIC: Envio de EMAIL -----------------------------------------------------------------------------------------------------------------------
if strEXECUTOR<>"" and strBS_TIPO<>"MODELO" then
	auxTpMsg = 1
	auxSTR = "Alteração da Tarefa"
	'if strSITUACAO="FECHADO" then 
	'	auxTpMsg = 4 
	'	auxSTR = "Fechamento de Tarefa"
	'end if
	
	strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, Replace(strEXECUTOR,"'",""))
	strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_EXECUTOR & "|")
	
	MontaBody strBodyMsg _
				,auxTpMsg,auxSTR,"" 			_
				,strTITULO,strSITUACAO 		_
				,strDESCCATEGORIA _
				,strPRIORIDADE 	_
				,strRESPONSAVEL 	_
				,strEXECUTOR 		_
				,GetParam("var_PREV_DT_INI") & " " & strPREV_HR_INI _
				,GetParam("var_dt_realizado") _
				,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'"), strBodyBoletim
	AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR & ")",strBodyMsg,1, 0, 0,""
end if
'FIM: Envio de EMAIL ------------------------------------------------------------------------------------------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>