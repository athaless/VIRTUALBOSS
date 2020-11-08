<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, ObjConn
Dim strCOD_CONTA

strCOD_CONTA = GetParam("var_chavereg")

if strCOD_CONTA<>"" then
	AbreDBConn objConn, CFG_DB

	strSQL = "DELETE FROM FIN_SALDO_AC WHERE COD_CONTA = " & strCOD_CONTA
	objConn.Execute(strSQL)
	
	FechaDBConn objConn
end if
%>
<script>
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>