<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, ObjConn, objRSTs
Dim strDT_INI, strDT_FIM
Dim strDESCRICAO, strMSG
Dim strCOD_PREV_ORCA
if not GetParam("var_confirm") then
	AbreDBConn objConn, CFG_DB 

	strDT_INI = GetParam("var_dt_inicio")
	strDT_FIM = GetParam("var_dt_fim")
	strDESCRICAO = Replace(GetParam("var_descricao"),"'","")

	if strDT_INI="" or strDT_FIM="" then strMSG = "Informar datas da previsão"	
	if strDT_INI=strDT_FIM then strMSG = "Datas informadas devem ser diferentes"
	if strDT_INI>strDT_FIM then strMSG = "Período de datas inválido"
	
	if strMSG<>"" then
		Mensagem strMSG, "Javascript:history.go(-1);", "Voltar", 1
		Response.End()
	end if

	strSQL = "INSERT INTO FIN_PREV_ORCA"	&_
				"	(	DESCRICAO,"		&_
				"		DT_PREV_INI,"	&_
				"		DT_PREV_FIM,"	&_				
				"		SYS_DTT_INS,"	&_
				"		SYS_ID_USUARIO_INS"	&_
				"	) "	&_
				"VALUES" &_
				"	('" &	strDESCRICAO & "'," &_
				"	'"  &	PrepDataBrToUni(strDT_INI,false) & "'," &_ 
				"	'"  &	PrepDataBrToUni(strDT_FIM,false) & "'," &_ 
				"	'"  &	PrepDataBrToUni(Now,true) & "','" & Request.Cookies("VBOSS")("ID_USUARIO") & "')"

	'AQUI: NEW TRANSACTION
	set objRSTs  = objConn.Execute("start transaction")
	set objRSTs  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)  
	If Err.Number <> 0 Then
	  set objRSTs = objConn.Execute("rollback")
	  Mensagem "modulo_PREV_ORCA.Insert_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else
	  set objRSTs = objConn.Execute("commit")
	End If

	strSQL = "SELECT LAST(COD_PREV_ORCA) AS COD_PREV FROM FIN_PREV_ORCA" 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	strCOD_PREV_ORCA = GetValue(objRS,"COD_PREV")
	FechaRecordSet objRS


	strSQL = "SELECT COD_PLANO_CONTA, COD_REDUZIDO FROM FIN_PLANO_CONTA WHERE DT_INATIVO IS NULL"
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1


	'AQUI: NEW TRANSACTION
	set objRSTs  = objConn.Execute("start transaction")
	set objRSTs  = objConn.Execute("set autocommit = 0")
	while not objRS.eof
		strSQL = "INSERT INTO FIN_PLANO_PREV_ORCA"	&_
					"	(	COD_PREV_ORCA,"	&_
					"		COD_PLANO_CONTA,"	&_
					"		COD_REDUZIDO,"		&_				
					"		SYS_DTT_ALT,"		&_
					"		SYS_ID_USUARIO_ALT"	&_
					"	) "	&_
					"VALUES" &_
					"	(" & strCOD_PREV_ORCA & "," &_
							  GetValue(objRS,"COD_PLANO_CONTA") & ",'" &_
							  GetValue(objRS,"COD_REDUZIDO") 	& "'," &_										
					"	'"	& Now() & "','" & Request.Cookies("VBOSS")("ID_USUARIO") & "')"
		objConn.Execute(strSQL)
		objRS.MoveNext
	wend
	If Err.Number <> 0 Then
	  set objRSTs = objConn.Execute("rollback")
	  Mensagem "modulo_PREV_ORCA.Insert_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else
	  set objRSTs = objConn.Execute("commit")
	End If

	FechaRecordSet objRS
	FechaDBConn objConn	
else
'Apenas confirma a operação
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<% athBeginDialog 400, "Contas - Inserção" %>
<table width="350" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr><td align="left" height="20">&nbsp;</td></tr>
	<tr><td align="left"><strong>Mensagem:</strong>&nbsp; Previsão inserida com sucesso.</td></tr>
	<tr><td align="left">&nbsp;</td></tr>
	<tr><td align="left">&nbsp;Clique no botão FECHAR para sair ou simplesmente feche essa janela.</td></tr>
	<tr><td align="left" height="20">&nbsp;</td></tr>	
</table>
<% athEndDialog 400, "../img/Bt_fecha.gif", "window.close();", "", "", "", "" %>
</body>
</html>
<%
end if
%>
<script>	
if (false=='<%=GetParam("var_confirm")%>') {
	location.href='../modulo_FIN_PREV_ORCA/Insert_Exec.asp?var_confirm=true'; 
	self.opener.document.form_principal.submit();
}	
</script>