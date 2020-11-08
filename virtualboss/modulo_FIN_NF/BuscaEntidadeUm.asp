<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objConn, objRS, strSQL  
Dim strFORM, strTIPO, strINPUT1, strINPUT2
Dim strCOD_CLIENTE, strNOME_FANTASIA

strCOD_CLIENTE = GetParam("var_chavereg")
strINPUT1 = GetParam("var_input1")
strINPUT2 = GetParam("var_input2")
strFORM = GetParam("var_form")

AbreDBConn objConn, CFG_DB 

If strCOD_CLIENTE <> "" Then
	strSQL =          " SELECT COD_CLIENTE, NOME_FANTASIA "
	strSQL = strSQL & " FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL "
	strSQL = strSQL & " AND COD_CLIENTE = " & strCOD_CLIENTE
	
	Set objRS = objConn.Execute(strSql) 
	
	strCOD_CLIENTE = ""
	strNOME_FANTASIA = ""
	if not objRS.Eof then
		strCOD_CLIENTE = GetValue(objRS,"COD_CLIENTE")
		strNOME_FANTASIA = GetValue(objRS,"NOME_FANTASIA")
	end if
	
	FechaRecordSet objRS
End If

FechaDBConn objConn
%>
<script>
	window.opener.document.<%=strFORM%>.<%=strINPUT1%>.value = '<%=strCOD_CLIENTE%>';
	window.opener.document.<%=strFORM%>.<%=strINPUT2%>.value = '<%=strNOME_FANTASIA%>';
	
	window.close();
</script>