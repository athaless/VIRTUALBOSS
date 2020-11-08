<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046 

Dim strSQL, objRS, ObjConn, strBodyMsg, strBodyBoletim, objRSCT, strAuxSQL, objRSAux
Dim strTITULO, strPRIORIDADE, strRESPONSAVEL, strEXECUTOR, strSITUACAO, strDESCRICAO, strPREV_DT_INI, strPREV_HR_INI
Dim strDT_REALIZADO, strCODCATEGORIA, strDESCCATEGORIA, strARQUIVO_ANEXO, strHORAS, strMINUTOS, strHORASeMINUTOS
Dim strEMAILS_MANAGER, strEMAIL_EXECUTOR, strDT_AGORA, strCOD_TODOLIST, strCOD_BOLETIM, strDADOS_BOLETIM, strVINCULO_CHAMADO
Dim strJSCRIPT_ACTION, strLOCATION

strTITULO         = GetParam("var_titulo")
strRESPONSAVEL    = LCase(GetParam("var_id_responsavel"))
strEXECUTOR       = LCase(GetParam("var_id_ult_executor"))
strSITUACAO       = GetParam("var_situacao")
strPRIORIDADE     = GetParam("var_prioridade")
strDESCRICAO      = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strPREV_DT_INI    = GetParam("var_prev_dt_ini")
strPREV_HR_INI    = GetParam("var_prev_hr_ini_hora") & ":" & GetParam("var_prev_hr_ini_min")
strDT_REALIZADO   = GetParam("var_dt_realizado")
strCODCATEGORIA   = GetParam("var_cod_e_desc_categoria")
strDESCCATEGORIA  = GetParam("var_cod_e_desc_categoria") 'Apenas para o e-mail
strARQUIVO_ANEXO  = GetParam("var_arquivo_anexo")
strHORAS          = GetParam("var_prev_horas")
strMINUTOS        = GetParam("var_prev_minutos")
strCOD_BOLETIM    = GetParam("var_cod_boletim")
strJSCRIPT_ACTION = GetParam("var_jscript_action")
strLOCATION       = GetParam("var_location")

If strRESPONSAVEL = "" or strTITULO = "" Or strCODCATEGORIA = "" Or strSITUACAO = "" Or strPRIORIDADE = "" OR strDESCRICAO = "" Then
	Response.write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
End If
strCODCATEGORIA = Mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1) 'Extrai aopenas o Código da cateroria da String
If strHORAS<>"" then
	if not isNumeric(strHORAS) then
	  Response.write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	  Response.End()
	else
	  strHORASeMINUTOS = strHoras & "." & strMinutos
	end if
Else
	if (CInt(strMinutos)>0) then  
		strHORASeMINUTOS = "0." & Cstr(strMinutos) 
	else 
		strHORASeMINUTOS ="NULL" 
	end if
End If

AbreDBConn objConn, CFG_DB 

if strDT_REALIZADO = "" then strDT_REALIZADO = "NULL" else strDT_REALIZADO = "'" & PrepDataBrToUni(strDT_REALIZADO, true) & "'" end if
if strPREV_DT_INI = "" then strPREV_DT_INI = "NULL" else strPREV_DT_INI = "'" & PrepDataBrToUni(strPREV_DT_INI, true) & "'" end if
If strPREV_HR_INI = ":" Then 
	strPREV_HR_INI = ""
Else
	If InStr(strPREV_HR_INI, ":") = 1                   Then strPREV_HR_INI = "00" & strPREV_HR_INI
	If InStr(strPREV_HR_INI, ":") = Len(strPREV_HR_INI) Then strPREV_HR_INI = strPREV_HR_INI & "00"
End If

'Consistencia no COD_BOLETIM
if strCOD_BOLETIM = "" then strCOD_BOLETIM = "NULL" 

strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"

'Insere todolist
strSQL =          " INSERT INTO TL_TODOLIST (COD_BOLETIM, TITULO, SITUACAO, COD_CATEGORIA, PRIORIDADE, ID_RESPONSAVEL, ID_ULT_EXECUTOR,"
strSQL = strSQL & " PREV_DT_INI, PREV_HR_INI, PREV_HORAS, DT_REALIZADO, DESCRICAO, ARQUIVO_ANEXO, SYS_ID_USUARIO_INS, SYS_DTT_INS) " 
strSQL = strSQL & " VALUES (" & strCOD_BOLETIM & ", '" & strTITULO & "', '" & strSITUACAO & "', " & strCODCATEGORIA & ", '" & strPRIORIDADE & "', "  
strSQL = strSQL & "'" & strRESPONSAVEL & "','" & strEXECUTOR & "'," & strPREV_DT_INI & ", '" & strPREV_HR_INI & "', " & strHORASeMINUTOS & ", " & strDT_REALIZADO & ", "
strSQL = strSQL & "'" & strDESCRICAO & "','" & strARQUIVO_ANEXO & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "', " & strDT_AGORA & ")" 
strAuxSQL = strSQL
'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_TODOLIST.Copia_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If

strSQL =          " SELECT MAX(COD_TODOLIST) AS CODIGO FROM TL_TODOLIST "
strSQL = strSQL & " WHERE TITULO LIKE '" & strTITULO & "' "
strSQL = strSQL & " AND SYS_ID_USUARIO_INS LIKE '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' "
strSQL = strSQL & " AND SYS_DTT_INS = " & strDT_AGORA
strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL
Set objRS = objConn.Execute(strSQL)

athSaveLog "COPY", Request.Cookies("VBOSS")("ID_USUARIO"), "TL_TODOLIST", strAuxSQL

strCOD_TODOLIST = ""
If Not objRS.Eof Then
	If GetValue(objRS, "CODIGO") <> "" Then strCOD_TODOLIST = GetValue(objRS, "CODIGO")
End If
FechaRecordSet objRS

'INIC: Envio de EMAIL ---------------------------------------------------
if strEXECUTOR<>"" and strSITUACAO<>"OCULTO" then
	strBodyBoletim = ""
	strDADOS_BOLETIM = ""
	
	if strCOD_BOLETIM <> "NULL" and strCOD_BOLETIM <> "" then
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
	end if
	
	strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, strEXECUTOR)
	strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_EXECUTOR & "|")
	
	'Verifica se ToDo está relacionado a um chamado, se tiver deve afetar o conteúdo do email de aviso
	strVINCULO_CHAMADO = VerificaVinculoChamado(objConn, strCOD_TODOLIST)
	
	MontaBody strBodyMsg _
				,0 _
				,"Inclusão da Tarefa" _
				,strCOD_TODOLIST _
				,strTITULO _
				,strSITUACAO _
				,strDESCCATEGORIA _
				,strPRIORIDADE _
				,strRESPONSAVEL _
				,strEXECUTOR _
				,GetParam("var_prev_dt_ini") & " " & strPREV_HR_INI _
				,GetParam("var_dt_realizado") _
				,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'") _
				,strBodyBoletim _
				,"TODOLIST" _
				,strVINCULO_CHAMADO
	
	If strVINCULO_CHAMADO = "T" Then
		If strDADOS_BOLETIM <> "" Then
			AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList Atividade (" & strDADOS_BOLETIM & ")",strBodyMsg,1,0,0,""
		Else
			AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList",strBodyMsg,1,0,0,""
		End If
	Else
		If strDADOS_BOLETIM <> "" Then
			AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR & ") Atividade (" & strDADOS_BOLETIM & ")",strBodyMsg,1,0,0,""
		Else
			AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR & ")",strBodyMsg,1,0,0,""
		End If
	End If
end if
'FIM: Envio de EMAIL ---------------------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'") & ";"
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "';"
response.write "</script>"
%>