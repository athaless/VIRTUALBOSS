<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, strBodyMsg
Dim strCODIGO, strEVALUATE, strOBS, strOBS_ORIG
Dim strLOCATION, strJSCRIPT_ACTION

strCODIGO   = GetParam("var_chavereg") 'Cód TAREFA gerada pelo chamado. Isso facilita, já que os campos de EVALUETE estão na TAREFA
strEVALUATE = GetParam("p11")
strOBS_ORIG = Replace(GetParam("var_obs_orig"),"'","<ASLW_APOSTROFE>")
strOBS		= Replace(GetParam("var_obs"),"'","<ASLW_APOSTROFE>")

strLOCATION       = GetParam("DEFAULT_LOCATION")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")

if strEVALUATE = "" then  
  strEVALUATE = 0
end if

'Como histórico, no campo [sys_evaluate_obs], armazenamos o LOG - data/hora, user, nota e observação anterior). 
'Na Dialog [Evaluate.asp] ela trata a observação mostrando somente a última inserida
strOBS = strOBS & "\n<!--LOG_EVALUATE [" & now & "][" & Request.Cookies("VBOSS")("ID_USUARIO") & "][" & strEVALUATE & "] //-->\n" & strOBS_ORIG


AbreDBConn objConn, CFG_DB 

strSQL =          " UPDATE TL_TODOLIST "
strSQL = strSQL & " SET sys_evaluate = " & strEVALUATE 
strSQL = strSQL & "   , sys_evaluate_obs = '" & strOBS & "' "
strSQL = strSQL & "   , sys_evaluate_id_usuario = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
strSQL = strSQL & " WHERE cod_todolist = " & strCODIGO

'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL)
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_CHAMADO.evaluate_exec: " & Err.Number & " - "& Err.Description , strLOCATION, 1, True
	athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CHAMADO", strSQL		
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
	athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CHAMADO", strSQL		
End If

FechaDBConn objConn

response.write "<script language='javascript' type='text/javascript'>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>