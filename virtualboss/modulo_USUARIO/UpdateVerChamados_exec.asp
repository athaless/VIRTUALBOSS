<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<%
	Dim objConn, objRS, objRSCT, strSQL
	Dim strCOD_USUARIO, strCLIENTEREF
	
	AbreDBConn objConn, CFG_DB
	
	strCOD_USUARIO = GetParam("var_chavereg")
    strCLIENTEREF  = GetParam("var_cod_cli_chamado_filtro")	
	
	strSQL = " UPDATE USUARIO SET ENT_CLIENTE_REF = '" & strCLIENTEREF & "' WHERE COD_USUARIO = " & strCOD_USUARIO
	'athdebug strSQL, true
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
	    athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK USUARIO " & strCOD_USUARIO , strSQL

		Mensagem "modulo_USUARIO.UpdateVerChamados_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
		athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT USUARIO " & strCOD_USUARIO, strSQL
	End If
	
	FechaDBConn(objConn)
	
	response.write "<script>"  & vbCrlf 
	if (GetParam("JSCRIPT_ACTION") <> "")   then response.write  GetParam("JSCRIPT_ACTION") & vbCrlf end if
	if (GetParam("DEFAULT_LOCATION") <> "") then response.write "location.href='" & GetParam("DEFAULT_LOCATION") & "'" & vbCrlf
	response.write "</script>"
%>