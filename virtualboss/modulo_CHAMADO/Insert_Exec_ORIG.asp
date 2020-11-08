<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, strBodyMsg
Dim strSOLICITANTE, strTITULO, strPRIORIDADE, strDESCRICAO, strSIGILOSO, strEXTRA
Dim strCOD_CATEGORIA, strCOD_CLI, strARQUIVO_ANEXO, strDT_AGORA, strTIPO_CHAMADO, strSITUACAO
Dim strJSCRIPT_ACTION, strLOCATION

strSOLICITANTE    = GetParam("var_solicitante")
strCOD_CLI        = GetParam("var_cod_cli")
strTITULO         = GetParam("var_titulo")
strCOD_CATEGORIA  = GetParam("var_cod_categoria")
strPRIORIDADE     = GetParam("var_prioridade")
strARQUIVO_ANEXO  = GetParam("var_arquivo_anexo")
strTIPO_CHAMADO   = GetParam("var_tipo_chamado")
strDESCRICAO      = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strSIGILOSO       = Replace(GetParam("var_sigiloso"),"'","<ASLW_APOSTROFE>")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")
strEXTRA		  = GetParam("var_extra")

If strSOLICITANTE = "" Or strCOD_CLI = "" Or strTITULO = "" Or strCOD_CATEGORIA = "" Or strPRIORIDADE = "" Or strDESCRICAO = "" Then
	Mensagem "Você tem que preencher todos os campos obrigatórios.", "Javascript:history.back()", "Voltar", True
	Response.End()
End If

AbreDBConn objConn, CFG_DB 

strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"

strSITUACAO = "ABERTO"
If strTIPO_CHAMADO = "LIVRE"     Then strSITUACAO = "ABERTO"
If strTIPO_CHAMADO = "BLOQUEADO" Then strSITUACAO = "BLOQUEADO"

strSQL =          " INSERT INTO CH_CHAMADO (COD_CLI, TITULO, COD_CATEGORIA, COD_TODOLIST, SITUACAO, PRIORIDADE, DESCRICAO, SIGILOSO, ARQUIVO_ANEXO, EXTRA, SYS_ID_USUARIO_INS, SYS_DTT_INS) " 
strSQL = strSQL & " VALUES ( " & strCOD_CLI & ", '" & strTITULO & "', " & strCOD_CATEGORIA & ", NULL, '" & strSITUACAO & "', '" & strPRIORIDADE & "' " 
strSQL = strSQL & "        , '" & strDESCRICAO & "', '" & strSIGILOSO & "', '" & strARQUIVO_ANEXO & "', '" & strEXTRA & "', '" & strSOLICITANTE & "', " & strDT_AGORA & ")" 

'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_CHAMADO.InsertRespostaExec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>