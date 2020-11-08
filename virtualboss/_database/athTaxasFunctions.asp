<%
Sub ApagaTaxas(prCOD_CONTA_PAGAR_RECEBER, prObjConn)
	Dim strSQLLocal, objRSCTLocal

	strSQLLocal = " DELETE FROM FIN_CONTA_PAGAR_RECEBER_TAXAS WHERE COD_CONTA_PAGAR_RECEBER = " & prCOD_CONTA_PAGAR_RECEBER
	
	prObjConn.Execute(strSQLLocal)
	
	strSQLLocal =               " UPDATE FIN_CONTA_PAGAR_RECEBER " 
	strSQLLocal = strSQLLocal & " SET VLR_CONTA = VLR_CONTA_ORIG "
	strSQLLocal = strSQLLocal & "   , MARCA_NFE = NULL " 
	strSQLLocal = strSQLLocal & " WHERE COD_CONTA_PAGAR_RECEBER = " & prCOD_CONTA_PAGAR_RECEBER 
	'AQUI: NEW TRANSACTION
	set objRSCTLocal  = objConn.Execute("start transaction")
	set objRSCTLocal  = objConn.Execute("set autocommit = 0")
	prObjConn.Execute(strSQLLocal)
	If Err.Number <> 0 Then
		set objRSCTLocal = objConn.Execute("rollback")
		Mensagem "_database.athTaxasFunctions.ApagaTaxas: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCTLocal = objConn.Execute("commit")
	End If
End Sub

Sub ApagaAcumulos(prCOD_CONTA_PAGAR_RECEBER, prTIPO_ACUMULO, prObjConn)
	Dim strSQLLocal, objRSCTLocal
	
	If prTIPO_ACUMULO = "IRRF" Or prTIPO_ACUMULO = "REDUCAO" Then
		strSQLLocal =               " UPDATE FIN_CONTA_PAGAR_RECEBER_TAXAS "
		strSQLLocal = strSQLLocal & " SET COD_ACUM_" & prTIPO_ACUMULO & " = NULL "
		strSQLLocal = strSQLLocal & " WHERE COD_ACUM_IRRF = " & prCOD_CONTA_PAGAR_RECEBER
		
		'AQUI: NEW TRANSACTION
		set objRSCTLocal  = objConn.Execute("start transaction")
		set objRSCTLocal  = objConn.Execute("set autocommit = 0")
		prObjConn.Execute(strSQLLocal)
		If Err.Number <> 0 Then
			set objRSCTLocal = objConn.Execute("rollback")
			Mensagem "_database.athTaxasFunctions.ApagaAcumulos: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCTLocal = objConn.Execute("commit")
		End If
	End If
End Sub

Function CalcTotalAcumulos(prCOD_CONTA_PAGAR_RECEBER, prTIPO_ACUMULO, prObjConn)
	Dim Retorno, strSQLLocal, objRSLocal
	
	Retorno = 0
	If prTIPO_ACUMULO = "IRRF" Or prTIPO_ACUMULO = "REDUCAO" Then
		strSQLLocal = " SELECT COUNT(COD_CONTA_TAXAS) AS TOTAL FROM FIN_CONTA_PAGAR_RECEBER_TAXAS WHERE COD_ACUM_" & prTIPO_ACUMULO & " = " & prCOD_CONTA_PAGAR_RECEBER
		Set objRSLocal = prObjConn.Execute(strSQLLocal)
		If Not objRSLocal.Eof Then Retorno = CDbl("0" & GetValue(objRSLocal, "TOTAL"))
		FechaRecordSet objRSLocal
	End If
	
	CalcTotalAcumulos = Retorno
End Function

Function BuscaCodAcumulo(prCOD_CONTA_PAGAR_RECEBER, prTIPO_ACUMULO, prObjConn)
	Dim Retorno, strSQLLocal, objRSLocal
	
	Retorno = ""
	If prTIPO_ACUMULO = "IRRF" Or prTIPO_ACUMULO = "REDUCAO" Then
		strSQLLocal = " SELECT COD_ACUM_" & prTIPO_ACUMULO & " AS CODIGO FROM FIN_CONTA_PAGAR_RECEBER_TAXAS WHERE COD_CONTA_PAGAR_RECEBER = " & prCOD_CONTA_PAGAR_RECEBER
		Set objRSLocal = prObjConn.Execute(strSQLLocal)
		If Not objRSLocal.Eof Then Retorno = GetValue(objRSLocal, "CODIGO")
		FechaRecordSet objRSLocal
	End If
	
	BuscaCodAcumulo = Retorno
End Function

Sub ApagaTaxasGeral(prCOD_CONTA_PAGAR_RECEBER, prObjConn)
	Dim strTOTAL1, strTOTAL2, strCODIGO1, strCODIGO2
	
	'------------------------------------------------------------------------------------------------
	'Deleta taxas antigas da conta a pagar e receber, mas antes trata dos acúmulos
	'Busca se teve acúmulos nas próprias taxas do título e se teve acúmulos em outros títulos
	'------------------------------------------------------------------------------------------------
	strTOTAL1 = CalcTotalAcumulos(prCOD_CONTA_PAGAR_RECEBER, "IRRF", prObjConn)
	strTOTAL2 = CalcTotalAcumulos(prCOD_CONTA_PAGAR_RECEBER, "REDUCAO", prObjConn)
	
	strCODIGO1 = BuscaCodAcumulo(prCOD_CONTA_PAGAR_RECEBER, "IRRF", prObjConn)
	strCODIGO2 = BuscaCodAcumulo(prCOD_CONTA_PAGAR_RECEBER, "REDUCAO", prObjConn)
	
	'------------------------------------------------------------------------------------------------
	' CASO 1
	' - verifica quantos acúmulos existem para o título X
	' - se for zero é porque não tem acúmulo, então (1) apaga taxas do título X
	' - se for um é nele mesmo que acumulou, então (2) apaga taxas do título X
	' - se mais de um então (3) apaga nas outras taxas a informação de que teve acúmulo no título X
	'                       (4) apaga taxas do título X
	'
	' CASO 2
	' - verifica se título X acumula em um outro título Y
	' - se acumulou então (5) apaga nas outras taxas a informação de que teve acúmulo no título Y
	'                     (6) apaga taxas do título Y
	'                     (7) apaga taxas do título X
	'------------------------------------------------------------------------------------------------
	ApagaTaxas prCOD_CONTA_PAGAR_RECEBER, prObjConn '(1)(2)(4)(7)
	
	If strTOTAL1 > 1 Then ApagaAcumulos prCOD_CONTA_PAGAR_RECEBER, "IRRF", prObjConn '(3)
	If strTOTAL2 > 1 Then ApagaAcumulos prCOD_CONTA_PAGAR_RECEBER, "REDUCAO", prObjConn '(3)
	
	If strCODIGO1 <> "" And strCODIGO1 <> prCOD_CONTA_PAGAR_RECEBER Then
		ApagaAcumulos strCODIGO1, "IRRF", prObjConn '(5)
		ApagaTaxasGeral strCODIGO1, prObjConn       'faz o (6) lá dentro
	End If
	If strCODIGO2 <> "" And strCODIGO2 <> prCOD_CONTA_PAGAR_RECEBER Then
		ApagaAcumulos strCODIGO2, "REDUCAO", prObjConn '(5)
		ApagaTaxasGeral strCODIGO2, prObjConn          'faz o (6) lá dentro
	End If
End Sub
%>