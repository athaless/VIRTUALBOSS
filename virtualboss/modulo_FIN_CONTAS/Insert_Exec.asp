<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn
	Dim strNOME, strTIPO, strVLR_SALDO_INI, strDT_CADASTRO, strDESCRICAO, strORDEM
	Dim strCOD_BANCO, strAGENCIA, strCONTA, strMES, strANO, strCOD_CONTA
	Dim strJSCRIPT_ACTION, strLOCATION
	
	strNOME = GetParam("var_nome")
	strTIPO = GetParam("var_tipo")
	strVLR_SALDO_INI = GetParam("var_vlr_saldo_ini")
	strDT_CADASTRO = GetParam("var_dt_cadastro")
	strDESCRICAO = GetParam("var_descricao")
	strORDEM = GetParam("var_ordem")
	strCOD_BANCO = GetParam("var_cod_banco")
	strAGENCIA = GetParam("var_agencia")
	strCONTA = GetParam("var_conta")
	strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
	strLOCATION = GetParam("DEFAULT_LOCATION")
	
	If strVLR_SALDO_INI <> "" Then
		strVLR_SALDO_INI = FormataDecimal(strVLR_SALDO_INI, 2)
		strVLR_SALDO_INI = FormataDouble(strVLR_SALDO_INI)
	Else
		strVLR_SALDO_INI = "0"
	End If
	
	If strORDEM = "" Then strORDEM = "NULL"
	
	AbreDBConn objConn, CFG_DB 
	
	strSQL =          " INSERT INTO FIN_CONTA ( NOME, DESCRICAO, TIPO, VLR_SALDO, VLR_SALDO_INI "
	strSQL = strSQL & "                       , DT_CADASTRO, COD_BANCO, AGENCIA, CONTA, ORDEM) "
	strSQL = strSQL & " VALUES ( '" & strNOME & "', '" & strDESCRICAO & "', '" & strTIPO & "', " & strVLR_SALDO_INI & ", " & strVLR_SALDO_INI
	strSQL = strSQL & "        , '" & PrepDataBrToUni(strDT_CADASTRO, False) & "', " & strCOD_BANCO & ", '" & strAGENCIA & "', '" & strCONTA & "', " & strORDEM & " ) "
	
	objConn.Execute(strSQL)
	
	strSQL =          " SELECT COD_CONTA FROM FIN_CONTA "
	strSQL = strSQL & " WHERE DT_CADASTRO = '" & PrepDataBrToUni(strDT_CADASTRO, False) & "' "
	strSQL = strSQL & " AND NOME = '" & strNOME & "' "
	
	strCOD_CONTA = ""
	Set objRS = objConn.Execute(strSQL)
	If Not objRS.EOF Then strCOD_CONTA = GetValue(objRS, "COD_CONTA")
	FechaRecordSet objRS
	
	If strCOD_CONTA <> "" Then
		strMES = DatePart("M", strDT_CADASTRO)
		strANO = DatePart("YYYY", strDT_CADASTRO)
		
		strSQL = " INSERT INTO FIN_SALDO_AC (COD_CONTA, VALOR, MES, ANO, SYS_COD_USER_ULT_LCTO) " &_ 
				 " VALUES (" & strCOD_CONTA & ", " & strVLR_SALDO_INI & ", " & strMES & ", " & strANO & ", NULL)"
		objConn.Execute(strSQL)
	Else
		Mensagem "Não foi possível encontrar a conta", "", "", True 
		Response.End()
	End If
	
	FechaDBConn objConn
	
response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>