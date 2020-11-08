<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athTaxasFunctions.asp"-->
<%
	Dim objConn, objRS, objRSCT, strSQL
	Dim strCOD_DADO, strMSG, strDT_AGORA, strTIPO, strCODIGO, strCOD_TITULOS
	Dim strTOTAL_IRRF, strTOTAL_PIS, strTOTAL_COFINS, strTOTAL_CSOCIAL, strTOTAL_IRPJ
	Dim strTOTAL_ISSQN, strVLR_BASE, strTOTAL_IMPOSTOS, strTOTAL_REDUCAO, strVLR_FINAL
	Dim strCOD_ACUM_IRRF, strCOD_ACUM_REDUCAO
	Dim strTOTAL_ACUM_IRRF, strTOTAL_ACUM_REDUCAO
	Dim strCODIGOS_ACUM_IRRF, strCODIGOS_ACUM_REDUCAO
	Dim strCOD_CFG_NF, strOPCAO
	Dim strALIQ_ISSQN, strALIQ_IRPJ, strALIQ_COFINS, strALIQ_PIS, strALIQ_CSOCIAL, strALIQ_IRRF
	
	strCOD_DADO = GetParam("var_chavereg")
	strTIPO		= GetParam("var_tipo")
	strCODIGO	= GetParam("var_codigo")
	
	strCOD_CFG_NF			= GetParam("var_cod_cfg_nf")
	strALIQ_ISSQN			= GetParam("var_aliq_issqn")
	strALIQ_IRPJ			= GetParam("var_aliq_irpj")
	strALIQ_COFINS			= GetParam("var_aliq_cofins")
	strALIQ_PIS				= GetParam("var_aliq_pis")
	strALIQ_CSOCIAL			= GetParam("var_aliq_csocial")
	strALIQ_IRRF			= GetParam("var_aliq_irrf")
	strVLR_BASE				= GetParam("var_vlr_base")
	strTOTAL_IRRF 			= GetParam("var_total_irrf")
	strTOTAL_PIS 			= GetParam("var_total_pis")
	strTOTAL_COFINS 		= GetParam("var_total_cofins")
	strTOTAL_CSOCIAL 		= GetParam("var_total_csocial")
	strTOTAL_IRPJ 			= GetParam("var_total_irpj")
	strTOTAL_ISSQN			= GetParam("var_total_issqn")
	strTOTAL_IMPOSTOS		= GetParam("var_total_impostos")
	strTOTAL_REDUCAO		= GetParam("var_total_reducao")
	strVLR_FINAL 			= GetParam("var_vlr_final")
	strCOD_ACUM_IRRF		= GetParam("var_cod_acum_irrf")
	strCOD_ACUM_REDUCAO		= GetParam("var_cod_acum_reducao")
	strTOTAL_ACUM_IRRF		= GetParam("var_total_acum_irrf")
	strTOTAL_ACUM_REDUCAO	= GetParam("var_total_acum_reducao")
	strCODIGOS_ACUM_IRRF	= GetParam("var_codigos_acum_irrf")
	strCODIGOS_ACUM_REDUCAO	= GetParam("var_codigos_acum_reducao")
	
	'athDebug "<br>strCOD_DADO " & strCOD_DADO, False
	'athDebug "<br>strTOTAL_IRRF " & strTOTAL_IRRF, False
	'athDebug "<br>strTOTAL_PIS " & strTOTAL_PIS, False
	'athDebug "<br>strTOTAL_COFINS " & strTOTAL_COFINS, False
	'athDebug "<br>strTOTAL_CSOCIAL " & strTOTAL_CSOCIAL, False
	'athDebug "<br>strTOTAL_IRPJ " & strTOTAL_IRPJ, False
	'athDebug "<br>strTOTAL_ISSQN " & strTOTAL_ISSQN, False
	'athDebug "<br>strCOD_CFG_NF " & strCOD_CFG_NF, False
	'athDebug "<br>strVLR_BASE " & strVLR_BASE, False
	'athDebug "<br>strTOTAL_IMPOSTOS " & strTOTAL_IMPOSTOS, False
	'athDebug "<br>strTOTAL_REDUCAO " & strTOTAL_REDUCAO, False
	'athDebug "<br>strVLR_FINAL " & strVLR_FINAL, False
	'athDebug "<br>strCOD_ACUM_IRRF " & strCOD_ACUM_IRRF, False
	'athDebug "<br>strCOD_ACUM_REDUCAO " & strCOD_ACUM_REDUCAO, False
	'athDebug "<br>strTOTAL_ACUM_IRRF " & strTOTAL_ACUM_IRRF, False
	'athDebug "<br>strTOTAL_ACUM_REDUCAO " & strTOTAL_ACUM_REDUCAO, False
	'athDebug "<br>strCODIGOS_ACUM_IRRF " & strCODIGOS_ACUM_IRRF, False
	'athDebug "<br>strCODIGOS_ACUM_REDUCAO " & strCODIGOS_ACUM_REDUCAO, False
	
	If strCOD_ACUM_IRRF = "" Then strCOD_ACUM_IRRF = "NULL"
	If strCOD_ACUM_REDUCAO = "" Then strCOD_ACUM_REDUCAO = "NULL"
	
	strMSG = ""
	If strCOD_DADO = "" Then strMSG = strMSG & "Parâmetro inválido para conta a pagar e receber<br>"
	
	If strMSG <> "" Then
		Mensagem strMSG, "Javascript:history.go(-1);", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	'--------------------------------------------------
	'Apaga as taxas da conta e trata das implicações
	'--------------------------------------------------
	ApagaTaxasGeral strCOD_DADO, objConn
	
	'--------------------------------------------
	'Insere taxas novas
	'--------------------------------------------
	strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
	
	strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER_TAXAS ( COD_CONTA_PAGAR_RECEBER, TIPO, CODIGO, TOTAL_IRRF, TOTAL_PIS, TOTAL_COFINS, TOTAL_CSOCIAL " 
	strSQL = strSQL & "                                           , TOTAL_IRPJ, TOTAL_ISSQN, VLR_BASE, TOTAL_IMPOSTOS, TOTAL_REDUCAO, VLR_FINAL "
	strSQL = strSQL & "                                           , ALIQ_ISSQN, ALIQ_IRPJ, ALIQ_COFINS, ALIQ_PIS, ALIQ_CSOCIAL, ALIQ_IRRF "
	strSQL = strSQL & "                                           , COD_CFG_NF, COD_ACUM_IRRF, COD_ACUM_REDUCAO, TOTAL_ACUM_IRRF, TOTAL_ACUM_REDUCAO "
	strSQL = strSQL & "                                           , SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) " 
	strSQL = strSQL & " VALUES ( " & strCOD_DADO & ", '" & strTIPO & "', " & strCODIGO & ", " & strTOTAL_IRRF & ", " & strTOTAL_PIS & ", " & strTOTAL_COFINS & ", " & strTOTAL_CSOCIAL
	strSQL = strSQL & "        , " & strTOTAL_IRPJ & ", " & strTOTAL_ISSQN & ", " & strVLR_BASE & ", " & strTOTAL_IMPOSTOS & ", " & strTOTAL_REDUCAO & ", " & strVLR_FINAL
	strSQL = strSQL & "        , " & strALIQ_ISSQN & ", " & strALIQ_IRPJ & ", " & strALIQ_COFINS & ", " & strALIQ_PIS & ", " & strALIQ_CSOCIAL & ", " & strALIQ_IRRF
	strSQL = strSQL & "        , " & strCOD_CFG_NF & ", " & strCOD_ACUM_IRRF & ", " & strCOD_ACUM_REDUCAO & ", " & strTOTAL_ACUM_IRRF & ", " & strTOTAL_ACUM_REDUCAO
	strSQL = strSQL & "        , " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' ) " 
	
	'athdebug "<br><br>" & strSQL, False
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_TITULOS.GeraTaxasTitulo_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	'------------------------------------------------------------------------
	'Atualiza valor e marca a conta como podendo ser associada a uma NFE
	'------------------------------------------------------------------------
	strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER " 
	strSQL = strSQL & " SET VLR_CONTA_ORIG = " & strVLR_BASE 
	strSQL = strSQL & "   , VLR_CONTA = " & strVLR_FINAL 
	strSQL = strSQL & "   , MARCA_NFE = 'COM_NFE' " 
	strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_DADO 
	
	'athdebug "<br><br>" & strSQL, False

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_TITULOS.GeraTaxasTitulo_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	'--------------------------------------------------------------------
	'Se teve acúmulos de IRRF então marca as contas a pagar e receber
	'--------------------------------------------------------------------
	If strCODIGOS_ACUM_IRRF <> "" Then
		strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER_TAXAS " 
		strSQL = strSQL & " SET COD_ACUM_IRRF = " & strCOD_ACUM_IRRF 
		strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER IN (" & strCODIGOS_ACUM_IRRF & ") "
		strSQL = strSQL & " AND TIPO LIKE '" & strTIPO & "' "
		strSQL = strSQL & " AND CODIGO = " & strCODIGO
		strSQL = strSQL & " AND Month(SYS_DT_CRIACAO) = " & Month(Date)
		strSQL = strSQL & " AND Year(SYS_DT_CRIACAO) = " & Year(Date)
		
		'athdebug "<br><br>" & strSQL, False
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_TITULOS.GeraTaxasTitulo_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
	End If
	
	'-------------------------------------------------------------------------------
	'Se teve acúmulos de Outras Reduções então marca as contas a pagar e receber
	'-------------------------------------------------------------------------------
	If strCODIGOS_ACUM_REDUCAO <> "" Then
		strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER_TAXAS " 
		strSQL = strSQL & " SET COD_ACUM_REDUCAO = " & strCOD_ACUM_REDUCAO 
		strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER IN (" & strCODIGOS_ACUM_REDUCAO & ") "
		strSQL = strSQL & " AND TIPO LIKE '" & strTIPO & "' "
		strSQL = strSQL & " AND CODIGO = " & strCODIGO
		strSQL = strSQL & " AND Month(SYS_DT_CRIACAO) = " & Month(Date)
		strSQL = strSQL & " AND Year(SYS_DT_CRIACAO) = " & Year(Date)
		
		'athdebug "<br><br>" & strSQL, False
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_TITULOS.GeraTaxasTitulo_Exec D: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
	End If
	
	FechaDBConn ObjConn
%>
<script>
	parent.frames["vbTopFrame"].document.form_principal.submit();
</script>