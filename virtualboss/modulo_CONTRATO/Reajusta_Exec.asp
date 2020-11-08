<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn, auxStr
	Dim strTP_REAJUSTE, strFATOR_REAJUSTE, strCOD_CONTRATO, strINTERVALO, strDT_AGORA, strDTT_PROX_REAJUSTE, strALT_ID_USUARIO, strTIPO_REAJUSTE
	Dim strMSG, Desloc	

	strCOD_CONTRATO     = GetParam("var_chavereg"        )
	strTP_REAJUSTE      = GetParam("var_tp_reajuste"     )
	strFATOR_REAJUSTE   = GetParam("var_fator_reajuste"  )	
	strTIPO_REAJUSTE    = GetParam("var_checkbox_reajuste"  )	
	strALT_ID_USUARIO   =  Request.Cookies("VBOSS")("ID_USUARIO")

	If Not IsNumeric(strCOD_CONTRATO  ) Then strCOD_CONTRATO     = ""
	'If Not IsNumeric(strTP_REAJUSTE   ) Then strTP_REAJUSTE      = ""
	If Not IsNumeric(strFATOR_REAJUSTE) Then strFATOR_REAJUSTE   = ""

	strMSG = ""
	If strCOD_CONTRATO     = "" Then strMSG = strMSG & "Parâmetro inválido para contrato<br>"
	If strFATOR_REAJUSTE   = "" Then strMSG = strMSG & "Parâmetro inválido para fator de reajuste<br>"
	If strTP_REAJUSTE      = "" Then strMSG = strMSG & "Parametro inválido para tipo de reajuste<br>"

	If strMSG <> "" Then 
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	If (strFATOR_REAJUSTE <> "0") Then
		strFATOR_REAJUSTE = FormatNumber(strFATOR_REAJUSTE, 3) 
		strFATOR_REAJUSTE = Replace(strFATOR_REAJUSTE,".","")
		strFATOR_REAJUSTE = Replace(strFATOR_REAJUSTE,",",".")				
	End If 	
	
	'--------------------------------------
	'Define parâmetros da periodicidade
	'--------------------------------------
	strINTERVALO = ""
	If strTP_REAJUSTE = "DIARIA"     Then strINTERVALO = "D"
	If strTP_REAJUSTE = "SEMANAL"    Then strINTERVALO = "WW"
	If strTP_REAJUSTE = "QUINZENAL"  Then strINTERVALO = "WW" 'WW x 2
	If strTP_REAJUSTE = "MENSAL"     Then strINTERVALO = "M"
	If strTP_REAJUSTE = "BIMESTRAL"  Then strINTERVALO = "M" 'M x 2
	If strTP_REAJUSTE = "TRIMESTRAL" Then strINTERVALO = "Q"
	If strTP_REAJUSTE = "SEMESTRAL"  Then strINTERVALO = "Q" 'Q x 2
	If strTP_REAJUSTE = "ANUAL"      Then strINTERVALO = "YYYY"

	Desloc = 1
	If strTP_REAJUSTE = "QUINZENAL"  Then Desloc = 2
	If strTP_REAJUSTE = "BIMESTRAL"  Then Desloc = 2
	If strTP_REAJUSTE = "SEMESTRAL"  Then Desloc = 2

	strDTT_PROX_REAJUSTE = "'" & PrepDataBrToUni(DateAdd(strINTERVALO, Desloc, Now), False) & "'"	
	
	'athDebug strDTT_PROX_REAJUSTE, True
	
	strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"
	
	AbreDBConn objConn, CFG_DB 
	
	'-----------------------------
	'Atualiza dados de reajuste do contrato
	'-----------------------------			
	auxStr = ""
	if lcase(strTIPO_REAJUSTE="true") then	
		auxStr = "(REDUÇÃO) " 
	end if
	
	strSQL =          " UPDATE CONTRATO SET TP_REAJUSTE  = '" & strTP_REAJUSTE &"'" 
	strSQL = strSQL & "		,FATOR_REAJUSTE    = "  & strFATOR_REAJUSTE   
	strSQL = strSQL & "		,DTT_ULT_REAJUSTE  = "  & strDT_AGORA       
	strSQL = strSQL & "		,DTT_PROX_REAJUSTE = "  & strDTT_PROX_REAJUSTE 
	strSQL = strSQL & "		,OBS = CONCAT(OBS, '" & vbNewLine & "Aplicado reajuste " & auxStr & "de " & strFATOR_REAJUSTE  & " % em " & Now & " por " & strALT_ID_USUARIO & ".')" 
	strSQL = strSQL & "		,SYS_ALT_ID_USUARIO = " & "'" & strALT_ID_USUARIO  & "'" 
	strSQL = strSQL & "		,SYS_DT_ALTERACAO   = "       & strDT_AGORA 	
	strSQL = strSQL & "	WHERE COD_CONTRATO = " & strCOD_CONTRATO
	
	'athDebug strSQL, true

	'AQUI: NEW TRANSACTION
	set objRS  = objConn.Execute("start transaction")
	set objRS  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRS = objConn.Execute("rollback")
		Mensagem "modulo_CONTRATO.Reajusta_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRS = objConn.Execute("commit")
	End If		
	
	'---------------------------------------------
	'Reajusta as parcelas do contrato
	'---------------------------------------------	
	auxStr = "+"
	if lcase(strTIPO_REAJUSTE="true") then	
		auxStr = "-"
	end if

	strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER "
	strSQL = strSQL & " SET VLR_CONTA = ROUND(VLR_CONTA *(1 " & auxStr & " (" & strFATOR_REAJUSTE & "/100)),2)" 
	strSQL = strSQL & "   , SYS_DT_ALTERACAO       = " & strDT_AGORA
	strSQL = strSQL & "   , SYS_COD_USER_ALTERACAO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
	strSQL = strSQL & " WHERE COD_CONTRATO = " & strCOD_CONTRATO
	strSQL = strSQL & "   AND SITUACAO     = 'ABERTA'"
	
	'athDebug strSQL, true

	'AQUI: NEW TRANSACTION
	set objRS  = objConn.Execute("start transaction")
	set objRS  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRS = objConn.Execute("rollback")
		Mensagem "modulo_CONTRATO.Reajusta_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRS = objConn.Execute("commit")
	End If			

	FechaDBConn ObjConn
%>
<script>
	parent.frames["vbTopFrame"].document.form_principal.submit();
</script>