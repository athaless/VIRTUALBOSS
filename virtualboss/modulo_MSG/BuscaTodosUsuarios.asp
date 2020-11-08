<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<%	
Dim objConn, objRS, strSQL  
Dim strEXEC, strDESTINO, strFORM, strCAMPO, strGRUPO, strPAGINA

strEXEC = GetParam("var_exec")
strGRUPO = GetParam("var_grupo")
strFORM = GetParam("var_form")
strCAMPO = GetParam("var_campo")
strPAGINA = GetParam("var_pagina")

If strEXEC = "T" Then
	AbreDBConn objConn, CFG_DB 
	
	strSQL = " SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL "
	If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" Then 
		strSQL = strSQL & " AND TIPO = '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "' "
		strSQL = strSQL & " AND CODIGO = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
	Else
		If strGRUPO = "ENT_COLABORADOR" Then
			strSQL = strSQL & " AND TIPO = 'ENT_COLABORADOR' "
		ElseIf strGRUPO <> "" Then
			strSQL = strSQL & " AND TIPO = 'ENT_CLIENTE' AND CODIGO = " & strGRUPO
		End If
	End If
	strSQL = strSQL & " ORDER BY ID_USUARIO "
	
	Set objRS = objConn.Execute(strSQL)
	
	while not objRS.Eof
		strDESTINO = strDESTINO & GetValue(objRS, "ID_USUARIO")
		objRS.MoveNext
		if not objRS.Eof then strDESTINO = strDESTINO & "; "
	wend
	
	FechaRecordSet objRS
	FechaDBConn objConn
	
	Response.Write("<script>")
	Response.Write("parent.document." & strFORM & "." & strCAMPO & ".value = '" & strDESTINO & "';")
	Response.Write("parent.document." & strFORM & ".action = '" & strPAGINA & "';")
	Response.Write("parent.document." & strFORM & ".target = '';")
	Response.Write("</script>")
End If
%>