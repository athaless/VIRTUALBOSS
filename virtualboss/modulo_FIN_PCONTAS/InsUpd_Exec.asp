<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, objRSCT, objConn
	Dim strCOD_DADO, strOPERACAO, strRETORNO
	Dim strCOD_PLANO_CONTA_PAI, strNOME, strDESCRICAO
	Dim strORDEM, strDT_INATIVO, strDRE, strNIVEL, strCOD_REDUZIDO, strMSG
	Dim strLOCATION, strJSCRIPT_ACTION
	
	strOPERACAO = GetParam("var_oper")
	strCOD_DADO = GetParam("var_chavereg")
	strRETORNO = GetParam("var_retorno")
	strCOD_PLANO_CONTA_PAI = GetParam("var_cod_plano_conta_pai")
	strNOME = GetParam("var_nome")
	strDESCRICAO = GetParam("var_descricao")
	strORDEM = GetParam("var_ordem")
	strDT_INATIVO = GetParam("var_dt_inativo")
	strDRE = GetParam("var_dre")
	strCOD_REDUZIDO = GetParam("var_cod_reduzido")
	strLOCATION = GetParam("DEFAULT_LOCATION")
	strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
	
	strMSG = ""
	If strNOME = "" Then strMSG = strMSG & "Favor informar nome do Plano de Conta.<br>"
	
	If strMSG <> "" Then
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	If strORDEM = "" Or Not IsNumeric(strORDEM) Then strORDEM = "NULL"
	If strCOD_PLANO_CONTA_PAI = "" Or Not IsNumeric(strCOD_PLANO_CONTA_PAI) Then strCOD_PLANO_CONTA_PAI = "NULL"
	If strDT_INATIVO = "" Or Not IsDate(strDT_INATIVO) Then 
		strDT_INATIVO = "NULL" 
	Else 
		strDT_INATIVO = "'" & PrepDataBrToUni(strDT_INATIVO, False) & "'"
	End If
	
	If strOPERACAO = "INS" Then 
		'-----------------------------
		' Insere plano de conta
		'-----------------------------
		strSQL =          " INSERT INTO FIN_PLANO_CONTA (COD_PLANO_CONTA_PAI, NOME, DESCRICAO, ORDEM, DT_INATIVO, DRE, COD_REDUZIDO) "
		strSQL = strSQL & " VALUES (" & strCOD_PLANO_CONTA_PAI & ", '" & strNOME & "', '" & strDESCRICAO & "', " & strORDEM & ", " & strDT_INATIVO & ", " & strDRE & ", '" & strCOD_REDUZIDO & "') "
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_PCONTAS.InsUpd_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
		
		strSQL =          " SELECT MAX(COD_PLANO_CONTA) AS CODIGO " 
		strSQL = strSQL & " FROM FIN_PLANO_CONTA " 
		strSQL = strSQL & " WHERE COD_REDUZIDO = '" & strCOD_REDUZIDO & "'"
		strSQL = strSQL & " AND NOME LIKE '" & strNOME & "' "
		If strCOD_PLANO_CONTA_PAI <> "NULL" Then
			strSQL = strSQL & " AND COD_PLANO_CONTA_PAI = " & strCOD_PLANO_CONTA_PAI
		End If
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then strCOD_DADO = GetValue(objRS, "CODIGO") 
		
		FechaRecordSet(objRS)
	Else
		'-----------------------------
		' Atualiza plano de conta
		'-----------------------------
		strSQL =          " UPDATE FIN_PLANO_CONTA " 
		strSQL = strSQL & " SET COD_PLANO_CONTA_PAI = " & strCOD_PLANO_CONTA_PAI 
		strSQL = strSQL & "   , NOME = '" & strNOME & "' " 
		strSQL = strSQL & "   , DESCRICAO = '" & strDESCRICAO & "' " 
		strSQL = strSQL & "   , ORDEM = " & strORDEM
		strSQL = strSQL & "   , DT_INATIVO = " & strDT_INATIVO
		strSQL = strSQL & "   , DRE = " & strDRE
		strSQL = strSQL & "   , COD_REDUZIDO = '" & strCOD_REDUZIDO & "'" 
		strSQL = strSQL & " WHERE COD_PLANO_CONTA = " & strCOD_DADO
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)		
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_PCONTAS.InsUpd_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
	End If 
	
	'-----------------------------
	' Busca dados do pai
	'-----------------------------
	If strCOD_PLANO_CONTA_PAI = "NULL" Then 
		strNIVEL = "1" 
	Else
		strSQL =          " SELECT NIVEL " 
		strSQL = strSQL & " FROM FIN_PLANO_CONTA " 
		strSQL = strSQL & " WHERE COD_PLANO_CONTA = " & strCOD_PLANO_CONTA_PAI 
		
		Set objRS = objConn.Execute(strSQL)
		
		strNIVEL = "NULL"
		If Not objRS.Eof Then strNIVEL = GetValue(objRS, "NIVEL") + 1
		
		FechaRecordSet(objRS)
	End If 
	
	'--------------------------------------------
	' Atualiza outros dados do plano de conta
	'--------------------------------------------
	strSQL =          " UPDATE FIN_PLANO_CONTA " 
	strSQL = strSQL & " SET NIVEL = " & strNIVEL 
	strSQL = strSQL & " WHERE COD_PLANO_CONTA = " & strCOD_DADO
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)		
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_PCONTAS.InsUpd_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	FechaDBConn ObjConn
	
response.write "<script>" & vbCrlf 
if strJSCRIPT_ACTION <> "" then response.write strJSCRIPT_ACTION & vbCrlf end if
if strLOCATION <> "" then response.write "location.href='" & strLOCATION & "'" & vbCrlf
response.write "</script>"
%>