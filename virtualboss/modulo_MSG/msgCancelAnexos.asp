<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="ConfigMSG.asp"--> 
<%
	Dim objRS, objConn, strSQL, strCOD_SESSION 
	
	AbreDBConn objConn, CFG_DB

	strCOD_SESSION = Session.SessionID
	
	strSQL = " DELETE FROM MSG_TEMP_ANEXO WHERE [SESSION] = '" & strCOD_SESSION & "'" 	
	objConn.Execute(strSQL)		
%>
<script>
	parent.window.close();		
</script>