<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objConn, objRS, strSQL  
Dim strFORM, strTIPO, strINPUT1, strINPUT2
Dim strCODIGO, strTIPO, strNOME

strCODIGO = GetParam("var_chavereg")
strTIPO = GetParam("var_tipo")
strINPUT1 = GetParam("var_input1")
strINPUT2 = GetParam("var_input2")
strFORM = GetParam("var_form")

AbreDBConn objConn, CFG_DB 

strNOME = ""

If strCODIGO <> "" And strTIPO <> "" Then
	If strTIPO = "ENT_CLIENTE" Then
		strSQL = " SELECT COD_CLIENTE, NOME_FANTASIA FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL AND COD_CLIENTE = " & strCODIGO
		Set objRS = objConn.Execute(strSQL) 
		If Not objRS.Eof Then strNOME = GetValue(objRS, "NOME_FANTASIA")
		FechaRecordSet objRS
	End If
	
	If strTIPO = "ENT_FORNECEDOR" Then
		strSQL = " SELECT COD_FORNECEDOR, NOME_FANTASIA FROM ENT_FORNECEDOR WHERE DT_INATIVO IS NULL AND COD_FORNECEDOR = " & strCODIGO
		Set objRS = objConn.Execute(strSQL) 
		If Not objRS.Eof Then strNOME = GetValue(objRS, "NOME_FANTASIA")
		FechaRecordSet objRS
	End If
	
	If strTIPO = "ENT_COLABORADOR" Then
		strSQL = " SELECT COD_COLABORADOR, NOME FROM ENT_COLABORADOR WHERE DT_INATIVO IS NULL AND COD_COLABORADOR = " & strCODIGO
		Set objRS = objConn.Execute(strSQL) 
		If Not objRS.Eof Then strNOME = GetValue(objRS, "NOME")
		FechaRecordSet objRS
	End If
End If

If strNOME = "" Then strCODIGO = "" 

FechaDBConn objConn
%>
<script>
	window.opener.document.<%=strFORM%>.<%=strINPUT1%>.value = '<%=strCODIGO%>';
	window.opener.document.<%=strFORM%>.<%=strINPUT2%>.value = '<%=strNOME%>';
	
	window.close();
</script>