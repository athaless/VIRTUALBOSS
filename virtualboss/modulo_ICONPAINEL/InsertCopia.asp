<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_ICONPAINEL", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strCODIGO
Dim objConn, objRS, strSQL
AbreDBConn objConn, CFG_DB

strCODIGO = GetParam("var_chavereg")
strSQL = "SELECT ROTULO, DESCRICAO, IMG, LINK, LINK_PARAM, TARGET, ID_USUARIO, ORDEM FROM SYS_PAINEL WHERE COD_PAINEL = " & strCODIGO
Set objRS = objConn.execute(strSQL)
if not objRS.Eof then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body onLoad="document.formCopy.submit();">
<form name="formCopy" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    		value="SYS_PAINEL">
	<input type="hidden" name="DEFAULT_DB"       		value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     		value="DBVAR_">
	<input type="hidden" name="DEFAULT_LOCATION" 		value="../modulo_ICONPAINEL/Update.asp">
	<input type="hidden" name="RECORD_KEY_NAME"  		value="COD_PAINEL">
	<input type="hidden" name="RECORD_KEY_VALUE" 		value="<%=strCODIGO%>">
	<input type="hidden" name="DBVAR_STR_ROTULO" 		value="<%=GetValue(objRS,"ROTULO")%>">
	<input type="hidden" name="DBVAR_STR_DESCRICAO" 	value="<%=GetValue(objRS,"DESCRICAO")%>">
	<input type="hidden" name="DBVAR_STR_IMG" 			value="<%=GetValue(objRS,"IMG")%>">
	<!-- input type="hidden" name="DBVAR_STR_ID_USUARIO"  	value="<%'=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%>"-->
	<input type="hidden" name="DBVAR_STR_ID_USUARIO"  	value="<%=GetValue(objRS,"ID_USUARIO")%>">
	<input type="hidden" name="DBVAR_STR_LINK" 			value="<%=GetValue(objRS,"LINK")%>">
	<input type="hidden" name="DBVAR_STR_LINK_PARAM"	value="<%=GetValue(objRS,"LINK_PARAM")%>">
	<input type="hidden" name="DBVAR_STR_TARGET" 		value="<%=GetValue(objRS,"TARGET")%>">
	<input type="hidden" name="DBVAR_NUM_ORDEM" 		value="<%=GetValue(objRS,"ORDEM")%>">
	<input type="hidden" name="DBVAR_DATE_DT_INATIVO"   value="NULL">	
</form>
</body>
</html>
<%
	FechaRecordSet ObjRS
else
	Response.Write("<script>")
	Response.Write(" //ASSIM SÓ FUNCIONA NO IE - parent.vbTopFrame.form_principal.submit();")
	Response.Write(" //ASSIM FUNCIONA NO IE e no FIREFOX")
	Response.Write(" parent.frames[""vbTopFrame""].document.form_principal.submit();")
	Response.Write("</script>")	
end if
FechaDBConn objConn
%>