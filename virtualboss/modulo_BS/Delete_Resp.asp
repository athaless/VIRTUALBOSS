<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim ObjConn, strCOD_RESP

strCOD_RESP = GetParam("var_chavereg")

if strCOD_RESP <> "" then 
 AbreDBConn ObjConn, CFG_DB
 
 ObjConn.Execute("DELETE FROM TL_RESPOSTA WHERE COD_TL_RESPOSTA = " & strCOD_RESP)
 
 FechaDBConn ObjConn
end if
%>
<script>
window.opener.location.reload();
window.close();
</script>