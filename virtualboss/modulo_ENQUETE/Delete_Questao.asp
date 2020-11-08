<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, strSQL
Dim strCODIGO

strCODIGO = GetParam("var_chavereg")

if strCODIGO<>"" then 
	AbreDBConn ObjConn, CFG_DB
	
	strSQL = "DELETE FROM EN_QUESTAO WHERE COD_QUESTAO = " & strCODIGO
	objConn.Execute(strSQL)
	
	FechaDBConn ObjConn
end if
%>
<script language="JavaScript">
	window.opener.location.reload();
	window.close();
</script>