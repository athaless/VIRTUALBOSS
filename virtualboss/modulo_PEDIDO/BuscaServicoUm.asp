<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objConn, objRS, strSQL  
Dim strFORM, strTIPO, strINPUT1, strINPUT2, strINPUT3, strINPUT4
Dim strCOD_SERVICO, strTITULO, strVALOR, strALIQ_ISSQN

strCOD_SERVICO = GetParam("var_chavereg")
strINPUT1 = GetParam("var_input1")
strINPUT2 = GetParam("var_input2")
strINPUT3 = GetParam("var_input3")
strINPUT4 = GetParam("var_input4")
strFORM = GetParam("var_form")

AbreDBConn objConn, CFG_DB 

If strCOD_SERVICO <> "" Then
	strSQL =          " SELECT COD_SERVICO, TITULO, DESCRICAO, VALOR, ALIQ_ISSQN, DT_INATIVO "
	strSQL = strSQL & " FROM SV_SERVICO WHERE DT_INATIVO IS NULL "
	strSQL = strSQL & " AND COD_SERVICO = " & strCOD_SERVICO
	
	Set objRS = objConn.Execute(strSql) 
	
	strCOD_SERVICO = ""
	strTITULO = ""
	strVALOR = ""
	if not objRS.Eof then
		strCOD_SERVICO = GetValue(objRS,"COD_SERVICO")
		strTITULO = GetValue(objRS,"TITULO")
		strVALOR = FormataDecimal(GetValue(objRS,"VALOR"), 2)
		strALIQ_ISSQN = FormataDecimal(GetValue(objRS,"ALIQ_ISSQN"), 2)
	end if
	
	FechaRecordSet objRS
End If

FechaDBConn objConn
%>
<script>
	window.opener.document.<%=strFORM%>.<%=strINPUT1%>.value = '<%=strCOD_SERVICO%>';
	window.opener.document.<%=strFORM%>.<%=strINPUT2%>.value = '<%=strTITULO%>';
	window.opener.document.<%=strFORM%>.<%=strINPUT3%>.value = '<%=strVALOR%>';
	window.opener.document.<%=strFORM%>.<%=strINPUT4%>.value = '<%=strALIQ_ISSQN%>';
	
	window.close();
</script>