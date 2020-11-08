<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Dim objConn, objRS, strSQL, objRSCT
	Dim strDT_ALTERACAO, strSYS_ALTERA, strCOD_CATEGORIA, strNOME, strDESCRICAO
	Dim strEXECUTOR, strPARAMETRO, strDT_INATIVO, strCODIGO
	Dim strJSCRIPT_ACTION, strDEFAULT_LOCATION
	
	AbreDBConn objConn, CFG_DB
	
	strCODIGO         = GetParam("var_chavereg")
	strCOD_CATEGORIA  = GetParam("var_cod_categoria")
	strNOME           = GetParam("var_nome")
	strDESCRICAO      = GetParam("var_descricao")
	strEXECUTOR       = GetParam("var_executor")
	strPARAMETRO      = Replace(GetParam("var_parametro"),"''","'")
	strDT_INATIVO     = GetParam("var_dt_inativo")
	strJSCRIPT_ACTION   = GetParam("JSCRIPT_ACTION")
	strDEFAULT_LOCATION = GetParam("DEFAULT_LOCATION")
	
	strDT_ALTERACAO = "'" & PrepDataBrToUni(Date, false) & "'"
	strSYS_ALTERA = Request.Cookies("VBOSS")("ID_USUARIO")
	strPARAMETRO = InsertTagSQL(strPARAMETRO)' Formatação do parametro SQL, retirando os caracteres que poderão causar problemas 
	
	if strCOD_CATEGORIA = "" then strCOD_CATEGORIA = "Null"
	if IsDate(strDT_INATIVO) then strDT_INATIVO = "'" & PrepDataBrToUni(strDT_INATIVO,false) & "'" else strDT_INATIVO = "Null"
	if strDESCRICAO    <> "" then strDESCRICAO = "'" & strDESCRICAO & "'" else strDESCRICAO = "Null"
	if strNOME         <> "" then strNOME = "'" & strNOME & "'" else strNOME = "Null"
	
	strSQL =          " UPDATE ASLW_RELATORIO SET DT_ALTERACAO = " & strDT_ALTERACAO & ", SYS_ALTERA = '" & strSYS_ALTERA & "' "
	strSQL = strSQL & " , COD_CATEGORIA = " & strCOD_CATEGORIA & ", NOME = " & strNOME & ", DESCRICAO = " & strDESCRICAO 
	strSQL = strSQL & " , EXECUTOR = '" & strEXECUTOR & "', PARAMETRO = '" & strPARAMETRO & "', DT_INATIVO = " & strDT_INATIVO & " "
	strSQL = strSQL & " WHERE COD_RELATORIO = " & strCODIGO
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
        athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK ASLW_RELATORIO - " & strCODIGO, strSQL
		Mensagem "modulo_RELAT_ASLW.Update_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
        athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT ASLW_RELATORIO - " & strCODIGO, strSQL	
	End If
	
	FechaDBConn objConn
	
	response.write "<script>" & vbCrlf 
	if (strJSCRIPT_ACTION <> "")   then response.write strJSCRIPT_ACTION & vbCrlf end if
	if (strDEFAULT_LOCATION <> "") then response.write "location.href='" & strDEFAULT_LOCATION & "'" & vbCrlf
	response.write "</script>"
%>