<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/athFileTools.asp"--> 
<%	
	Dim strParams, strCAMINHO 
	
	strParams = GetParam("var_params")
	
	strCAMINHO = Server.MapPath(CFG_DIR & "\upload\") & "\"
	
	RemoveArquivos CFG_DB, "MSG_TEMP_ANEXO", "COD_MSG_TEMP_ANEXO", strParams, "ARQUIVO", strCAMINHO 
	DeletaDados    CFG_DB, "MSG_TEMP_ANEXO", "COD_MSG_TEMP_ANEXO", strParams, "[SESSION]", Session.SessionID, "msgShowAnexos.asp?var_session=" & Session.SessionID, 1  
%>
