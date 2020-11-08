<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, strSQL
Dim strCOD_RESP

strCOD_RESP = GetParam("var_chavereg")

if strCOD_RESP<>"" then 
	AbreDBConn ObjConn, CFG_DB
	
	strSQL = "DELETE FROM TL_RESPOSTA WHERE COD_TL_RESPOSTA = " & strCOD_RESP
	objConn.Execute(strSQL)
	
	FechaDBConn ObjConn
end if
%>
<script language="JavaScript">
	window.opener.location.reload();
	window.close();
</script>