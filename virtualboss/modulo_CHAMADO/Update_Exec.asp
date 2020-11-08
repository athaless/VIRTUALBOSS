<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn, strBodyMsg
Dim strCODIGO, strTITULO, strPRIORIDADE, strDESCRICAO, strSIGILOSO
Dim strARQUIVO_ANEXO, strDT_AGORA, strCOD_CATEGORIA, arrAnexo(), arrAnexoDesc(), i, strQTDEINPUTSANEXOS
Dim strJSCRIPT_ACTION, strLOCATION

strCODIGO         = GetParam("var_chavereg")
strTITULO         = GetParam("var_titulo")
strCOD_CATEGORIA  = GetParam("var_cod_categoria")
strPRIORIDADE     = GetParam("var_prioridade")
strARQUIVO_ANEXO  = GetParam("var_arquivo_anexo")
strDESCRICAO      = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strSIGILOSO       = Replace(GetParam("var_sigiloso"),"'","<ASLW_APOSTROFE>")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("strLOCATION")
strQTDEINPUTSANEXOS = GetParam("QTDE_INPUTS_ANEXO")

If strTITULO = "" Or strCOD_CATEGORIA = "" Or strPRIORIDADE = "" Or strDESCRICAO = "" Then
	Mensagem "Você tem que preencher todos os campos obrigatórios.", "Javascript:history.back()", "Voltar", True
	Response.End()
End If

i = 1
redim arrAnexo(strQTDEINPUTSANEXOS)
redim arrAnexoDesc(strQTDEINPUTSANEXOS)
While (i<=Cint(strQTDEINPUTSANEXOS))  
  arrAnexo(i)	  = GetParam("var_anexo_" & i)
  arrAnexoDesc(i) = GetParam("var_anexodesc_" & i)
  i = i + 1
WEnd

'athDebug "", true

AbreDBConn objConn, CFG_DB 

strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"

strSQL =          " UPDATE CH_CHAMADO "
strSQL = strSQL & " SET TITULO = '" & strTITULO & "' "
strSQL = strSQL & "   , COD_CATEGORIA = " & strCOD_CATEGORIA
strSQL = strSQL & "   , PRIORIDADE = '" & strPRIORIDADE & "' "
strSQL = strSQL & "   , DESCRICAO = '" & strDESCRICAO & "' "
strSQL = strSQL & "   , ARQUIVO_ANEXO = '" & strARQUIVO_ANEXO & "' "
strSQL = strSQL & "   , SYS_DTT_UPD = " & strDT_AGORA
strSQL = strSQL & "   , SYS_ID_USUARIO_UPD = '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' "
If strSIGILOSO <> "" Then
	strSQL = strSQL & "   , SIGILOSO = '" & strSIGILOSO & "' "
End If
strSQL = strSQL & " WHERE COD_CHAMADO = " & strCODIGO

'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL)
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_CHAMADO.update_exec: " & Err.Number & " - "& Err.Description , strLOCATION, 1, True
	athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CHAMADO", strSQL		
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
	athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CHAMADO", strSQL		
End If

'INI: Deleta Todas Anexos --------------------------------
strSQL = " DELETE FROM CH_ANEXO WHERE COD_CHAMADO = " & strCODIGO
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
'athdebug strSQL, false
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CH_ANEXO", strSQL		
	Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True
else
	set objRSCT = objConn.Execute("commit")
	athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT CH_ANEXO", strSQL		  
End If
'athdebug strSQL, true	
'FIM: Deleta Todas Anexos --------------------------------

'INI: Insere Anexos ----------------------------------------

for i=1 to Cint(strQTDEINPUTSANEXOS) 
  
  if (arrAnexo(i)<>"") then	  
	strSQL = " INSERT INTO CH_ANEXO(COD_CHAMADO,ARQUIVO,DESCRICAO,SYS_DTT_INS,SYS_ID_USUARIO_INS)  "
	strSQL = strSQL & " VALUES (" & strCODIGO & ",'" & arrAnexo(i) & "','" & arrAnexoDesc(i) & "'," & strDT_AGORA & ",'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' )"
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	'athDebug strSQL, false
	objConn.Execute(strSQL) 
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CH_ANEXO", strSQL		
		Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True
	else
		set objRSCT = objConn.Execute("commit")
		athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT CH_ANEXO", strSQL		
	End If
  end if
next
'FIM: Insere Anexos ----------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>