<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn
Dim strCOD_LCTO_ORDINARIO
Dim strCOD_CONTA_PAGAR_RECEBER
Dim strDT_LCTO

	Dim strVLR_LCTO, strVLR_LCTO_Frmt, strVLR_ORIG, strVLR_TOTAL
	Dim strVLR_TOTAL_LCTO, strVLR_TOTAL_DESC, strVLR_TOTAL_MULTA, strVLR_TOTAL_JUROS
	Dim strSITUACAO, strDT_AGORA, strMSG, strCOD_CONTA, strPAGAR_RECEBER, strCOD_CONTA_PAI
	Dim strJSCRIPT_ACTION, strLOCATION

	strCOD_LCTO_ORDINARIO = GetParam("var_chavereg")
	strCOD_CONTA_PAGAR_RECEBER = GetParam("var_cod_conta")	
	strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
	strLOCATION = GetParam("DEFAULT_LOCATION")

  if strCOD_LCTO_ORDINARIO<>"" then 
	AbreDBConn objConn, CFG_DB
	
	strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
	
	strSQL =          " SELECT T1.PAGAR_RECEBER, T2.VLR_LCTO, T2.DT_LCTO, T2.COD_CONTA, T1.VLR_CONTA "
	strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER T1, FIN_LCTO_ORDINARIO T2 "
	strSQL = strSQL & " WHERE T1.COD_CONTA_PAGAR_RECEBER = T2.COD_CONTA_PAGAR_RECEBER "
	strSQL = strSQL & " AND T2.COD_LCTO_ORDINARIO=" & strCOD_LCTO_ORDINARIO
	
	Set objRS = objConn.Execute(strSQL)
	
	strCOD_CONTA = ""
	strVLR_LCTO = 0
	strVLR_ORIG = 0
	strDT_LCTO = ""
	strPAGAR_RECEBER = 0
	If Not objRS.Eof Then
		strCOD_CONTA	 = GetValue(objRS, "COD_CONTA")
		strVLR_LCTO		 = GetValue(objRS, "VLR_LCTO")
		strVLR_ORIG		 = GetValue(objRS, "VLR_CONTA")
		strDT_LCTO		 = GetValue(objRS, "DT_LCTO")
		strPAGAR_RECEBER = GetValue(objRS, "PAGAR_RECEBER")
	End If
	
	FechaRecordSet objRS
	
	'--------------------------------------------------------------------------
	'Deleta lançamento
	'
	'Em algum momento no passado não deletávamos os lctos ordinários, apenas os 
	'marcávamos como deletados com quem e quando. Isso mudou não sei quando.
	'--------------------------------------------------------------------------
	strSQL = "DELETE FROM FIN_LCTO_ORDINARIO WHERE COD_LCTO_ORDINARIO=" & strCOD_LCTO_ORDINARIO
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_TITULOS.DeleteLcto_exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If

	
	'----------------------------------------------------------------
	'Atualiza conta-caixa, debitando ou creditando o valor lançado
	'----------------------------------------------------------------
	strVLR_LCTO_Frmt = strVLR_LCTO
	if strVLR_LCTO_Frmt <> 0 then
		strVLR_LCTO_Frmt = FormatNumber(strVLR_LCTO_Frmt, 2) 
		strVLR_LCTO_Frmt = Replace(strVLR_LCTO_Frmt,".","")
		strVLR_LCTO_Frmt = Replace(strVLR_LCTO_Frmt,",",".")
	end if
	
	if cInt(strPAGAR_RECEBER) <> 0 then strSQL = "UPDATE FIN_CONTA SET VLR_SALDO = VLR_SALDO + " & strVLR_LCTO_Frmt & " WHERE COD_CONTA = " & strCOD_CONTA
	if Cint(strPAGAR_RECEBER) = 0  then strSQL = "UPDATE FIN_CONTA SET VLR_SALDO = VLR_SALDO - " & strVLR_LCTO_Frmt & " WHERE COD_CONTA = " & strCOD_CONTA

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_TITULOS.DeleteLcto_exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	'--------------------------------------------------------------
	'Busca os totais já lançados para avaliar situação da conta
	'--------------------------------------------------------------
	strSQL =          " SELECT SUM(VLR_LCTO)  AS VLR_TOTAL_LCTO "
	strSQL = strSQL & "      , SUM(VLR_DESC)  AS VLR_TOTAL_DESC "
	strSQL = strSQL & "      , SUM(VLR_MULTA) AS VLR_TOTAL_MULTA "
	strSQL = strSQL & "      , SUM(VLR_JUROS) AS VLR_TOTAL_JUROS "
	strSQL = strSQL & " FROM FIN_LCTO_ORDINARIO "
	strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_PAGAR_RECEBER
	strSQL = strSQL & " AND SYS_DT_CANCEL IS NULL "
	Set objRS = objConn.Execute(strSQL)
	
	strVLR_TOTAL_LCTO  = 0 
	strVLR_TOTAL_DESC  = 0 
	strVLR_TOTAL_MULTA = 0 
	strVLR_TOTAL_JUROS = 0 
	
	if Not objRS.Eof then
		strVLR_TOTAL_LCTO  = GetValue(objRS, "VLR_TOTAL_LCTO")
		strVLR_TOTAL_DESC  = GetValue(objRS, "VLR_TOTAL_DESC")
		strVLR_TOTAL_MULTA = GetValue(objRS, "VLR_TOTAL_MULTA")
		strVLR_TOTAL_JUROS = GetValue(objRS, "VLR_TOTAL_JUROS")
	end if 
	FechaRecordSet objRS
	
	if strVLR_TOTAL_LCTO  = "" or not IsNumeric(strVLR_TOTAL_LCTO)  then strVLR_TOTAL_LCTO  = 0
	if strVLR_TOTAL_DESC  = "" or not IsNumeric(strVLR_TOTAL_DESC)  then strVLR_TOTAL_DESC  = 0
	if strVLR_TOTAL_MULTA = "" or not IsNumeric(strVLR_TOTAL_MULTA) then strVLR_TOTAL_MULTA = 0
	if strVLR_TOTAL_JUROS = "" or not IsNumeric(strVLR_TOTAL_JUROS) then strVLR_TOTAL_JUROS = 0
	
	strVLR_TOTAL = strVLR_TOTAL_LCTO + strVLR_TOTAL_DESC - strVLR_TOTAL_MULTA - strVLR_TOTAL_JUROS
	if (cDbl(strVLR_TOTAL) < 0) then strVLR_TOTAL = 0
	
	strSITUACAO		= "ABERTA"
	strVLR_TOTAL	= Cdbl(strVLR_TOTAL)
	strVLR_ORIG		= Cdbl(strVLR_ORIG)
	
	if (strVLR_TOTAL = 0) then strSITUACAO = "ABERTA" 
	if (strVLR_TOTAL > 0) and (strVLR_TOTAL < strVLR_ORIG) then strSITUACAO = "LCTO_PARCIAL" 
	if (strVLR_TOTAL >= strVLR_ORIG) then strSITUACAO = "LCTO_TOTAL" 
	
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	strSQL = "UPDATE FIN_CONTA_PAGAR_RECEBER SET SITUACAO='" & strSITUACAO & "' WHERE COD_CONTA_PAGAR_RECEBER="  & strCOD_CONTA_PAGAR_RECEBER
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_TITULOS.DeleteLcto_exec B: " & Err.Number & " - " & Err.Description , DEFAULT_LOCATION, 1, True
	  response.end
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
	
	if strPAGAR_RECEBER = "1" then	 
		AcumulaSaldoNovo objConn, strCOD_CONTA, strDT_LCTO, strVLR_LCTO 
	else
		AcumulaSaldoNovo objConn, strCOD_CONTA, strDT_LCTO, -strVLR_LCTO 
	end if
	
	FechaDBConn ObjConn
end if

response.write "<script>"  & vbCrlf 
if strJSCRIPT_ACTION <> "" then response.write strJSCRIPT_ACTION & vbCrlf end if
if strLOCATION <> "" then response.write "location.href='" & strLOCATION & "'" & vbCrlf
response.write "</script>"
%>
