<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, objRSCT, objConn
	Dim strCOD_DADO, strOPERACAO, strRETORNO
	Dim strCOD_CENTRO_CUSTO_PAI, strNOME, strDESCRICAO
	Dim strORDEM, strDT_INATIVO, strNIVEL, strCOD_REDUZIDO, strMSG
	Dim strLOCATION, strJSCRIPT_ACTION
	
	strOPERACAO		= GetParam("var_oper")
	strCOD_DADO		= GetParam("var_chavereg")
	strRETORNO		= GetParam("var_retorno")
	strCOD_CENTRO_CUSTO_PAI = GetParam("var_cod_centro_custo_pai")
	strNOME			= GetParam("var_nome")
	strDESCRICAO	= GetParam("var_descricao")
	strORDEM		= GetParam("var_ordem")
	strDT_INATIVO	= GetParam("var_dt_inativo")
	strCOD_REDUZIDO	= GetParam("var_cod_reduzido")
	strLOCATION		= GetParam("DEFAULT_LOCATION")
	strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
	
	strMSG = ""
	If strNOME = "" Then strMSG = strMSG & "Favor informar nome do Centro de Custo.<br>"
	
	If strMSG <> "" Then
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	If strORDEM = "" Or Not IsNumeric(strORDEM) Then strORDEM = "NULL"
	If strCOD_CENTRO_CUSTO_PAI = "" Or Not IsNumeric(strCOD_CENTRO_CUSTO_PAI) Then strCOD_CENTRO_CUSTO_PAI = "NULL"
	If strDT_INATIVO = "" Or Not IsDate(strDT_INATIVO) Then 
		strDT_INATIVO = "NULL" 
	Else 
		strDT_INATIVO = "'" & PrepDataBrToUni(strDT_INATIVO, False) & "'"
	End If
	
	If strOPERACAO = "INS" Then 
		'-----------------------------
		' Insere centro de custo
		'-----------------------------
		strSQL =          " INSERT INTO FIN_CENTRO_CUSTO (COD_CENTRO_CUSTO_PAI, NOME, DESCRICAO, ORDEM, DT_INATIVO, COD_REDUZIDO) "
		strSQL = strsQL & " VALUES (" & strCOD_CENTRO_CUSTO_PAI & ", '" & strNOME & "', '" & strDESCRICAO & "', " & strORDEM & ", " & strDT_INATIVO & ", '" & strCOD_REDUZIDO & "') "
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_CCUSTOS.InsUpd_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
		
		strSQL =          " SELECT MAX(COD_CENTRO_CUSTO) AS CODIGO " 
		strSQL = strSQL & " FROM FIN_CENTRO_CUSTO " 
		strSQL = strSQL & " WHERE COD_REDUZIDO = '" & strCOD_REDUZIDO & "'"
		strSQL = strSQL & " AND NOME LIKE '" & strNOME & "' "
		If strCOD_CENTRO_CUSTO_PAI <> "NULL" Then
			strSQL = strSQL & " AND COD_CENTRO_CUSTO_PAI = " & strCOD_CENTRO_CUSTO_PAI
		End If
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then strCOD_DADO = GetValue(objRS, "CODIGO") 
		
		FechaRecordSet(objRS)
	Else
		'-----------------------------
		' Atualiza centro de custo
		'-----------------------------
		strSQL =          " UPDATE FIN_CENTRO_CUSTO " 
		strSQL = strSQL & " SET COD_CENTRO_CUSTO_PAI = " & strCOD_CENTRO_CUSTO_PAI 
		strSQL = strSQL & "   , NOME = '" & strNOME & "' " 
		strSQL = strSQL & "   , DESCRICAO = '" & strDESCRICAO & "' " 
		strSQL = strSQL & "   , ORDEM = " & strORDEM
		strSQL = strSQL & "   , DT_INATIVO = " & strDT_INATIVO
		strSQL = strSQL & "   , COD_REDUZIDO = '" & strCOD_REDUZIDO & "'" 
		strSQL = strSQL & " WHERE COD_CENTRO_CUSTO = " & strCOD_DADO
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)		
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_CCUSTOS.InsUpd_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
	End If 
	
	'-----------------------------
	' Busca dados do pai
	'-----------------------------
	If strCOD_CENTRO_CUSTO_PAI = "NULL" Then 
		strNIVEL = "1" 
	Else
		strSQL =          " SELECT NIVEL " 
		strSQL = strSQL & " FROM FIN_CENTRO_CUSTO " 
		strSQL = strSQL & " WHERE COD_CENTRO_CUSTO = " & strCOD_CENTRO_CUSTO_PAI 
		
		Set objRS = objConn.Execute(strSQL)
		
		strNIVEL = "NULL"
		If Not objRS.Eof Then strNIVEL = GetValue(objRS, "NIVEL") + 1
		
		FechaRecordSet(objRS)
	End If 
	
	'--------------------------------------------
	' Atualiza outros dados do centro de custo
	'--------------------------------------------
	strSQL =          " UPDATE FIN_CENTRO_CUSTO " 
	strSQL = strSQL & " SET NIVEL = " & strNIVEL 
	strSQL = strSQL & " WHERE COD_CENTRO_CUSTO = " & strCOD_DADO
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)		
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_CCUSTOS.InsUpd_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	FechaDBConn ObjConn

response.write "<script>"  & vbCrlf 
if strJSCRIPT_ACTION <> "" then response.write strJSCRIPT_ACTION & vbCrlf end if
if strLOCATION <> "" then response.write "location.href='" & strLOCATION & "'" & vbCrlf
response.write "</script>"
%>