<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/md5.asp"--> 
<%
	Dim objConn, objRS, objRSCT, strSQL
	Dim strCOD_USUARIO, strNOME, strEMAIL, strFOTO
	
	AbreDBConn objConn, CFG_DB
	
	strCOD_USUARIO = GetParam("var_chavereg")
	strNOME        = GetParam("var_nome")
	strFOTO        = GetParam("var_foto")
	strEMAIL       = GetParam("var_email")
	strEMAIL       = Replace(Replace(strEMAIL," ",""),",",";")
	
	strSQL =          " UPDATE USUARIO "
	strSQL = strSQL & " SET NOME = '" & strNOME & "' "
	strSQL = strSQL & "  ,EMAIL = '" & strEMAIL & "' "
	strSQL = strSQL & "  ,FOTO = '" & strFOTO & "' "
	strSQL = strSQL & "  ,SYS_DT_ALT = '" & PrepDataBrToUni(Now(),true) & "' "
	strSQL = strSQL & "  ,SYS_USR_ALT = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "	
	strSQL = strSQL & " WHERE COD_USUARIO = " & strCOD_USUARIO
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
	    athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK USUARIO " & strCOD_USUARIO , strSQL
		Mensagem "modulo_USUARIO.Update_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
		athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT USUARIO " & strCOD_USUARIO, strSQL
	End If
	
	FechaDBConn(objConn)
	
	'Response.Redirect(strRETORNO)
	response.write "<script>"  & vbCrlf 
	if (GetParam("JSCRIPT_ACTION") <> "")   then response.write  GetParam("JSCRIPT_ACTION") & vbCrlf end if
	if (GetParam("DEFAULT_LOCATION") <> "") then response.write "location.href='" & GetParam("DEFAULT_LOCATION") & "'" & vbCrlf
	response.write "</script>"
%>