<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS_RESP|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046 

Dim strSQL, objRS, objRSCT, ObjConn
Dim strCODIGO, strCH_CATEGORIA, strMOTIVO, strPREV_DT_INI, strOLD_PREV_DT_INI, strPREV_HR_INI, strJSCRIPT_ACTION, strLOCATION
Dim strPREV_HR_INI_HORA, strPREV_HR_INI_MIN, strPREV_HORAS, strPREV_MINUTOS, strHORASeMINUTOS, strADD_RESP_DEFAULT
Dim strCOD_CHAMADO, strMENSAGEM_RESPOSTA

strCODIGO           = GetParam("var_chavereg")
strCH_CATEGORIA     = GetParam("var_ch_categoria")
strPREV_DT_INI      = GetParam("var_prev_dt_ini")
strOLD_PREV_DT_INI  = GetParam("var_old_prev_dt_ini")
strPREV_HR_INI_HORA = GetParam("var_prev_hr_ini_hora")
strPREV_HR_INI_MIN  = GetParam("var_prev_hr_ini_min")
strPREV_HORAS       = GetParam("var_prev_horas")
strPREV_MINUTOS     = GetParam("var_prev_minutos")
strMOTIVO           = Replace(GetParam("var_motivo"),"'","<ASLW_APOSTROFE>")
strADD_RESP_DEFAULT = GetParam("var_add_resp_default")
strJSCRIPT_ACTION   = GetParam("JSCRIPT_ACTION")
strLOCATION         = GetParam("DEFAULT_LOCATION")

strPREV_HR_INI = strPREV_HR_INI_HORA & ":" & strPREV_HR_INI_MIN

if strADD_RESP_DEFAULT <> "T" then strADD_RESP_DEFAULT = "F"

strHORASeMINUTOS = ""

If strCODIGO = "" Then
	Response.write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
End If

If strPREV_HORAS<>"" then
	If not isNumeric(strPREV_HORAS) then
		Response.write("<p align='center'>O valor de horas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
		Response.End()
	Else
		strHORASeMINUTOS = strPREV_HORAS & "." & strPREV_MINUTOS
	End If
Else
	if (CInt(strPREV_MINUTOS)>0) then 
		strHORASeMINUTOS = "0." & Cstr(strMinutos)
	Else
		strHORASeMINUTOS ="NULL" 
	End If
End If
strHORASeMINUTOS = Replace(strHORASeMINUTOS, ",", ".")

if strPREV_DT_INI = "" then strPREV_DT_INI = "NULL" else strPREV_DT_INI = "'" & PrepDataBrToUni(strPREV_DT_INI, true) & "'" end if
If strPREV_HR_INI = ":" Then 
	strPREV_HR_INI = ""
Else
	If InStr(strPREV_HR_INI, ":") = 1                   Then strPREV_HR_INI = "00" & strPREV_HR_INI
	If InStr(strPREV_HR_INI, ":") = Len(strPREV_HR_INI) Then strPREV_HR_INI = strPREV_HR_INI & "00"
End If


AbreDBConn objConn, CFG_DB 

'Verifica se ToDo está relacionado a um chamado
strCOD_CHAMADO = ""
strSQL = " SELECT COD_CHAMADO FROM CH_CHAMADO WHERE COD_TODOLIST = " & strCODIGO
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
if not objRS.eof then 
	strCOD_CHAMADO = GetValue(objRS,"COD_CHAMADO")
	FechaRecordSet objRS
end if

'Iniciamos a transção aqui, pois todos os comandos devem estar dentro da mesma transação
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")

'Altera a data prevista d ---------------------------------------------------------------------------------------------------------------
strSQL = ""

strSQL =          " UPDATE TL_TODOLIST "
strSQL = strSQL & "   SET PREV_HORAS  = " & strHORASeMINUTOS
strSQL = strSQL & "      ,PREV_DT_INI = " & strPREV_DT_INI 
strSQL = strSQL & "      ,PREV_HR_INI = '" & strPREV_HR_INI & "'"
strSQL = strSQL & "      ,SYS_DTT_ALT = '" & PrepDataBrToUni(Now, true) & "'" 
strSQL = strSQL & " WHERE COD_TODOLIST = " & strCODIGO & ";"

objConn.Execute(strSQL) 

strSQL = ""

'Caso exista um chamado vinculado a tarefa E  a nova categoria n]ap esta vazia, então atualiza a categoria do chamado ------
if ( (strCOD_CHAMADO <> "") AND (strCH_CATEGORIA<>"") ) then
	strSQL = strSQL & " UPDATE CH_CHAMADO "
	strSQL = strSQL & " SET COD_CATEGORIA = " & strCH_CATEGORIA
	strSQL = strSQL & " WHERE COD_CHAMADO = " & strCOD_CHAMADO & ";"
	
	objConn.Execute(strSQL)
end if	

strSQL = ""

strMENSAGEM_RESPOSTA = ""

if(Trim(strMOTIVO) <> "") then 
	strMENSAGEM_RESPOSTA = strMENSAGEM_RESPOSTA & Trim(strMOTIVO)
end if	

if ((FormatDateTime(CDate(Replace(strPREV_DT_INI, "'", "")),2) <> strOLD_PREV_DT_INI) and (strADD_RESP_DEFAULT = "T")) then
	strMENSAGEM_RESPOSTA = "MENSAGEM DO SISTEMA - Data prevista alterada de " & strOLD_PREV_DT_INI & " para " &  FormatDateTime(CDate(Replace(strPREV_DT_INI, "'", "")),2) & ". " & vbnewline & vbnewline & strMENSAGEM_RESPOSTA
end if

'Se existe uma mensagem de resposta realiza o insert
if (strMENSAGEM_RESPOSTA <> "") then
	strSQL = strSQL & " INSERT INTO TL_RESPOSTA (COD_TODOLIST, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA) "
	strSQL = strSQL & " VALUES (" & strCODIGO & ", '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "', '"
 	strSQL = strSQL &           Server.HTMLEncode(strMENSAGEM_RESPOSTA) & "', '" & PrepDataBrToUni(Now, True) & "');"

	objConn.Execute(strSQL)
end if

'para debug
'Response.Write(strSQL)
'Response.End()

'AQUI: NEW TRANSACTION
'objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_TODOLIST.Update_DataPrevistaExec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If
'-------------------------------------------------------------------------------------------------------------------------------
athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "TL_TODOLIST e CH_CHAMADO, TL_RESPOSTA", strSQL
	
FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>