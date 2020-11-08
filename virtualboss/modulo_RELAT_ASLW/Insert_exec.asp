<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Dim objConn, objRS, strSQL, objRSCT
	Dim strDT_CRIACAO, strSYS_CRIA, strCOD_CATEGORIA, strNOME, strDESCRICAO, strEXECUTOR, strPARAMETRO, strDT_INATIVO, strCOD_RELATORIO
	Dim strJSCRIPT_ACTION, strDEFAULT_LOCATION
	
	AbreDBConn objConn, CFG_DB
	
	strCOD_CATEGORIA  = GetParam("var_cod_categoria")
	strNOME           = GetParam("var_nome")
	strDESCRICAO      = GetParam("var_descricao")
	strEXECUTOR       = GetParam("var_executor")
	strPARAMETRO      = Replace(GetParam("var_parametro"),"''","'")
	strDT_INATIVO     = GetParam("var_dt_inativo")
	strJSCRIPT_ACTION   = GetParam("JSCRIPT_ACTION")
	strDEFAULT_LOCATION = GetParam("DEFAULT_LOCATION")
	
	strDT_CRIACAO = "'" & PrepDataBrToUni(Date, false) & "'"
	strSYS_CRIA = Request.Cookies("VBOSS")("ID_USUARIO")
	
	if strCOD_CATEGORIA = "" then strCOD_CATEGORIA = "Null"
	if IsDate(strDT_INATIVO) then strDT_INATIVO = "'" & PrepDataBrToUni(strDT_INATIVO,false) & "'" else strDT_INATIVO = "Null"
	if strDESCRICAO    <> "" then strDESCRICAO = "'" & strDESCRICAO & "'" else strDESCRICAO = "Null"
	if strNOME         <> "" then strNOME = "'" & strNOME & "'" else strNOME = "Null"
	
	strPARAMETRO = InsertTagSQL(strPARAMETRO)' Formatação do parametro SQL, retirando os caracteres que poderão causar problemas 
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	strSQL =          " INSERT INTO ASLW_RELATORIO (DT_CRIACAO, SYS_CRIA, COD_CATEGORIA, NOME, DESCRICAO, EXECUTOR, PARAMETRO, DT_INATIVO) "
	strSQL = strSQL & " VALUES (" & strDT_CRIACAO & ",'" & strSYS_CRIA & "'," & strCOD_CATEGORIA & "," & strNOME
	strSQL = strSQL & " ," & strDESCRICAO & ",'" & strEXECUTOR & "','" & strPARAMETRO & "'," & strDT_INATIVO & ")"
	
	objConn.execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
        athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK ASLW_RELATORIO", strSQL
		Mensagem "modulo_RELAT_ASLW.Insert_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
        athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT ASLW_RELATORIO", strSQL	
	End If
	
	FechaDBConn objConn
	
	response.write "<script>" & vbCrlf 
	if (strJSCRIPT_ACTION <> "")   then response.write strJSCRIPT_ACTION & vbCrlf end if
	if (strDEFAULT_LOCATION <> "") then response.write "location.href='" & strDEFAULT_LOCATION & "'" & vbCrlf
	response.write "</script>"
%>