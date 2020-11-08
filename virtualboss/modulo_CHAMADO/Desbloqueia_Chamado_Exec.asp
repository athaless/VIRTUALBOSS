<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, strBodyMsg
Dim strDT_AGORA, strCODIGO, strEXECUTOR, strCOMENTARIO1, strCOMENTARIO2, strEMAILS_EXECUTOR, strCOD_CATEGORIA
Dim strHORAS, strMINUTOS, strVALOR, strHORASeMINUTOS
Dim strJSCRIPT_ACTION, strLOCATION

strCODIGO   = GetParam("var_chavereg")
strEXECUTOR = GetParam("var_executor")
strHORAS    = GetParam("var_horas")
strMINUTOS  = GetParam("var_minutos")
strVALOR    = GetParam("var_valor")
strCOD_CATEGORIA = GetParam("var_cod_categoria")

strCOMENTARIO1 = Replace(GetParam("var_comentario1"),"'","<ASLW_APOSTROFE>")
strCOMENTARIO2 = Replace(GetParam("var_comentario2"),"'","<ASLW_APOSTROFE>")

strJSCRIPT_ACTION   = GetParam("JSCRIPT_ACTION")
strLOCATION         = GetParam("DEFAULT_LOCATION")

AbreDBConn objConn, CFG_DB

If strCODIGO <> "" And strEXECUTOR <> "" Then
	'--------------------------------------------------------------
	' Prepara variáveis
	'--------------------------------------------------------------
	strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"
	If strCOMENTARIO1 = "" Then strCOMENTARIO1 = "NULL" Else strCOMENTARIO1 = "'" & strCOMENTARIO1 & "'" End If
	If strCOMENTARIO2 = "" Then strCOMENTARIO2 = "NULL" Else strCOMENTARIO2 = "'" & strCOMENTARIO2 & "'" End If
	
	strHORASeMINUTOS = "NULL"
	If strHORAS<>"" then
		if isNumeric(strHORAS) then strHORASeMINUTOS = strHORAS & "." & strMINUTOS
	Else
		if (CInt(strMINUTOS)>0) then strHORASeMINUTOS = "0." & Cstr(strMINUTOS) 
	End If
	
	If Not IsNumeric(strVALOR) Then strVALOR = ""
	If strVALOR <> 0 Then
		strVALOR = FormatNumber(strVALOR, 2) 
		strVALOR = Replace(strVALOR,".","")
		strVALOR = Replace(strVALOR,",",".")
	Else
		strVALOR = "NULL"
	End If
	
	'-----------------------------------------------------------------------------
	' Desbloqueia chamado
	'-----------------------------------------------------------------------------
	strSQL =          " UPDATE CH_CHAMADO "
	strSQL = strSQL & " SET SITUACAO = 'ABERTO' "
	strSQL = strSQL & "   , DESBLOQUEIO = " & strCOMENTARIO1
	strSQL = strSQL & "   , DESBLOQUEIO_SIGI = " & strCOMENTARIO2
	strSQL = strSQL & "   , HORAS = " & strHORASeMINUTOS
	strSQL = strSQL & "   , VALOR = " & strVALOR
	strSQL = strSQL & "   , COD_CATEGORIA = " & strCOD_CATEGORIA
	strSQL = strSQL & "   , SYS_DTT_DESBLOQUEIO = " & strDT_AGORA
	strSQL = strSQL & "   , SYS_ID_USUARIO_DESBLOQUEIO = '" & strEXECUTOR & "' "
	strSQL = strSQL & " WHERE COD_CHAMADO = " & strCODIGO
	
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL) 
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_CHAMADO.desbloqueia_chamado_exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
End If

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>