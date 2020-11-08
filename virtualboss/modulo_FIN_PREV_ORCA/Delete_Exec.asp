<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, ObjConn
Dim strCOD_PREV_ORCA

strCOD_PREV_ORCA = GetParam("var_chavereg")
if strCOD_PREV_ORCA <>"" then 
	AbreDBConn objConn, CFG_DB	
	
	strSQL = "DELETE FROM FIN_PREV_ORCA WHERE COD_PREV_ORCA=" & strCOD_PREV_ORCA
	objConn.Execute(strSQL)

	strSQL = "DELETE FROM FIN_PLANO_PREV_ORCA WHERE COD_PREV_ORCA=" & strCOD_PREV_ORCA
	objConn.Execute(strSQL)

end if

FechaDBConn objConn
%>
<script>
   //ASSIM SÓ FUNCIONA NO IE (só no IE): parent.vbTopFrame.form_principal.submit();
 
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>