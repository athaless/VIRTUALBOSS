<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%
Dim strSQL, objRS, objConn
Dim strCOD_BOLETIM
Dim strDT_INI, strDT_FIM, strDATA, strCHANGE
Dim strJSCRIPT_ACTION, strLOCATION

strCOD_BOLETIM    = GetParam("var_cod_boletim")
strDT_INI         = GetParam("var_dt_ini")
strDT_FIM         = GetParam("var_dt_fim")
strDATA           = GetParam("var_date")
strCHANGE         = GetParam("var_change")
strJSCRIPT_ACTION = GetParam("var_jscript_action")
strLOCATION       = GetParam("var_location")

if strCOD_BOLETIM = "" then
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
else
	if not strCHANGE then 
		Response.Redirect("InsertCopia_Exec.asp?var_cod_boletim=" & strCOD_BOLETIM & "&var_jscript_action=" & strJSCRIPT_ACTION & "&var_location=" & strLOCATION)
	elseif strDATA = "" then
		Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
		Response.End()
	else
		Response.Redirect("InsertCopia_Exec.asp?var_cod_boletim=" & strCOD_BOLETIM & "&var_date=" & strDATA & "&var_jscript_action=" & strJSCRIPT_ACTION & "&var_location=" & strLOCATION)
	end if				
end if
%>