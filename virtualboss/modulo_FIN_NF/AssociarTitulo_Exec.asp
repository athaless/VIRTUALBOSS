<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%
Dim objConn, objRS, objRSCT, strSQL
Dim strCOD_NF, strNUM_NF, strCOD_CONTA_RECEBER
Dim strJSCRIPT_ACTION, strLOCATION

AbreDBConn objConn, CFG_DB 

strCOD_NF = GetParam("var_cod_nf")
strNUM_NF = GetParam("var_num_nf")
strCOD_CONTA_RECEBER = GetParam("var_cod_conta_receber")
strJSCRIPT_ACTION = GetParam("var_jscript_action")
strLOCATION       = GetParam("var_location")

if strCOD_NF <> "" and strNUM_NF <> "" and strCOD_CONTA_RECEBER <> "" then
	strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER "
	strSQL = strSQL & "	SET COD_NF = " & strCOD_NF
	strSQL = strSQL & "   , NUM_NF = '" & strNUM_NF & "'"
	strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_RECEBER
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.AssociarTitulo_Exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
end if

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>