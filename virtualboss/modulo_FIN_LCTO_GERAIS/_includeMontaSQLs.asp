<%
	function MontaSQLUnion_A(prCOD_CONTA, prDT_INI, prDT_FIM, prANO, prCODIGO, prTIPO, prCOD_CENTRO_CUSTO, prCOD_PLANO_CONTA, prCOD_LCTO )
		Dim strSQL
		'---------------------------------------------
		' Monta busca de lançamentos ordinários
		'---------------------------------------------
		strSQL = "SELECT PGR.COD_CONTA_PAGAR_RECEBER AS CODIGO " 		&_
 					"   ,ORD.COD_LCTO_ORDINARIO as CODIGO_LCTO " 		&_
					"	,CTA1.NOME AS CONTA_PREVISTA " 					&_
					"	,if((PGR.PAGAR_RECEBER=0),'ENTRADA','SAIDA') AS OPERACAO " &_
					"	,'TITULOS' AS MODULO " 							&_
					"	,PGR.TIPO " 									&_
					"	,PGR.CODIGO AS COD_ENTIDADE " 					&_
					"	,PGR.HISTORICO " 								&_
					"	,ORD.VLR_LCTO AS VALOR " 						&_
					"	,ORD.DT_LCTO AS DATA " 							&_
					"	,CTA2.NOME AS CONTA_REALIZADA " 				&_
					"   ,ORD.NUM_LCTO                 "                 &_ 
					"FROM FIN_CONTA_PAGAR_RECEBER PGR " 				&_
					"	 ,FIN_LCTO_ORDINARIO ORD " &_
					"	 ,FIN_CONTA CTA1 " &_
					"	 ,FIN_CONTA CTA2 " &_
					"WHERE ORD.SYS_DT_CANCEL IS NULL " &_
					"  AND ORD.COD_CONTA_PAGAR_RECEBER=PGR.COD_CONTA_PAGAR_RECEBER " &_
					"  AND PGR.COD_CONTA=CTA1.COD_CONTA " &_
					"  AND ORD.COD_CONTA=CTA2.COD_CONTA "
		If prCOD_CONTA <> "" Then strSQL = strSQL & " AND CTA2.COD_CONTA = " & prCOD_CONTA
		if prDT_INI <> "" And prDT_FIM <> "" then 
			strSQL = strSQL & " AND ORD.DT_LCTO BETWEEN '" & PrepDataBrToUni(prDT_INI, False) & "' AND '" & PrepDataBrToUni(prDT_FIM, False) & "' "
		else	
			strSQL = strSQL & " AND Year(ORD.DT_LCTO)>=" & prANO
		end if
		If prCODIGO <> "" And prTIPO <> "" Then strSQL = strSQL & " AND (PGR.CODIGO LIKE '" & prCODIGO & "' AND PGR.TIPO LIKE '" & prTIPO & "') " 
		If prCODIGO = ""  And prTIPO <> "" Then strSQL = strSQL & " AND PGR.TIPO LIKE '" & prTIPO & "' " 
		If prCOD_CENTRO_CUSTO <> ""        Then strSQL = strSQL & " AND ORD.COD_CENTRO_CUSTO = " & prCOD_CENTRO_CUSTO
		If prCOD_PLANO_CONTA <> ""         Then strSQL = strSQL & " AND ORD.COD_PLANO_CONTA = " & prCOD_PLANO_CONTA
		If prCOD_LCTO <> ""				   Then strSQL = strSQL & " AND ORD.COD_LCTO_ORDINARIO = " & prCOD_LCTO

		strSQL = strSQL & " ORDER BY DATA"
		MontaSQLUnion_A = strSQL
	end function



	function MontaSQLUnion_B(prCOD_CONTA, prDT_INI, prDT_FIM, prANO, prCODIGO, prTIPO, prCOD_CENTRO_CUSTO, prCOD_PLANO_CONTA, prCOD_LCTO)
		Dim strSQL
		'---------------------------------------------
		' Monta busca de lançamentos em conta
		'---------------------------------------------
		strSQL = 	"SELECT LCT.COD_LCTO_EM_CONTA AS CODIGO "		&_
 					"	   ,LCT.COD_LCTO_EM_CONTA as CODIGO_LCTO "	&_
					"	   ,'' AS CONTA_PREVISTA "					&_
					"	   ,if(LCT.OPERACAO='DESPESA','SAIDA','ENTRADA') AS OPERACAO " &_
					"	   ,'LCTOCONTA' AS MODULO "					&_			
					"	   ,LCT.TIPO "								&_			
					"      ,LCT.CODIGO AS COD_ENTIDADE"				&_
					"	   ,LCT.HISTORICO "							&_
					"	   ,LCT.VLR_LCTO AS VALOR "					&_
					"	   ,LCT.DT_LCTO AS DATA "					&_
					"	   ,CTA2.NOME AS CONTA_REALIZADA "			&_
					"      ,LCT.NUM_LCTO                 "          &_ 					
					"FROM FIN_LCTO_EM_CONTA LCT "					&_
					"	 ,FIN_CONTA CTA2 "							&_
					"WHERE LCT.COD_CONTA=CTA2.COD_CONTA "
		If prCOD_CONTA <> "" Then strSQL = strSQL & " AND CTA2.COD_CONTA = " & prCOD_CONTA
		if prDT_INI <> "" And prDT_FIM <> "" then
			strSQL = strSQL & " AND LCT.DT_LCTO BETWEEN '" & PrepDataBrToUni(prDT_INI, False) & "' AND '" & PrepDataBrToUni(prDT_FIM, False) & "' "
		else
			strSQL = strSQL & " AND Year(LCT.DT_LCTO)>=" & prANO
		end if
		If prCODIGO <> "" And prTIPO <> "" Then strSQL = strSQL & " AND (LCT.CODIGO LIKE '" & prCODIGO & "' AND LCT.TIPO LIKE '" & prTIPO & "') " 
		If prCODIGO = "" And prTIPO <> ""  Then strSQL = strSQL & " AND LCT.TIPO LIKE '" & prTIPO & "' " 
		If prCOD_CENTRO_CUSTO <> ""        Then strSQL = strSQL & " AND LCT.COD_CENTRO_CUSTO = " & prCOD_CENTRO_CUSTO
		If prCOD_PLANO_CONTA <> ""         Then strSQL = strSQL & " AND LCT.COD_PLANO_CONTA = " & prCOD_PLANO_CONTA
		If prCOD_LCTO <> ""				   Then strSQL = strSQL & " AND LCT.COD_LCTO_EM_CONTA = " & prCOD_LCTO

		strSQL = strSQL & " ORDER BY DATA"
		MontaSQLUnion_B = strSQL
	end function



	function MontaSQLUnion_C(prCOD_CONTA, prDT_INI, prDT_FIM, prANO, prCOD_LCTO)
		Dim strSQL
		strSQL = "SELECT LTF.COD_LCTO_TRANSF AS CODIGO "	&_
 				"	,LTF.COD_LCTO_TRANSF as CODIGO_LCTO "	&_
				"	,'' AS CONTA_PREVISTA  "				&_
				"	,'SAIDA' AS OPERACAO " 					&_
				"   ,'TRANSF' AS MODULO  "					&_			
				"	,'' AS TIPO " 							&_
				"   ,'' AS COD_ENTIDADE " 					&_			
				"	,LTF.HISTORICO "						&_
				"	,LTF.VLR_LCTO AS VALOR "				&_
				"	,LTF.DT_LCTO AS DATA "					&_
				"	,CTA.NOME AS CONTA_REALIZADA "			&_
				"   ,LTF.NUM_LCTO                "          &_ 				
				"FROM FIN_LCTO_TRANSF LTF "					&_
				"	 ,FIN_CONTA CTA " 						&_
				"WHERE LTF.COD_CONTA_ORIG=CTA.COD_CONTA "
		If prCOD_CONTA <> "" Then strSQL = strSQL & " AND LTF.COD_CONTA_ORIG = " & prCOD_CONTA
		if prDT_INI <> "" And prDT_FIM <> "" then
			strSQL = strSQL & " AND LTF.DT_LCTO BETWEEN '" & PrepDataBrToUni(prDT_INI, False) & "' AND '" & PrepDataBrToUni(prDT_FIM, False) & "' "
		else
			strSQL = strSQL & " AND Year(LTF.DT_LCTO)>=" & prANO
		end if
		If prCOD_LCTO <> ""	Then strSQL = strSQL & " AND LTF.COD_LCTO_TRANSF = " & prCOD_LCTO

		strSQL = strSQL & " ORDER BY DATA"
		MontaSQLUnion_C = strSQL
	end function



	function MontaSQLUnion_D(prCOD_CONTA, prDT_INI, prDT_FIM, prANO, prCOD_LCTO)
		Dim strSQL
		strSQL = "SELECT LTF.COD_LCTO_TRANSF AS CODIGO "	&_
 				 "	,LTF.COD_LCTO_TRANSF as CODIGO_LCTO "	&_
				 "	,'' AS CONTA_PREVISTA  "				&_
				 "	,'ENTRADA' AS OPERACAO "				&_
				 "  ,'TRANSF' AS MODULO  "					&_			
				 "	,'' AS TIPO " 							&_
				 "  ,'' AS COD_ENTIDADE " 					&_			
				 "	,LTF.HISTORICO "						&_
				 " 	,LTF.VLR_LCTO AS VALOR "				&_
				 "	,LTF.DT_LCTO AS DATA "					&_
				 "	,CTA.NOME AS CONTA_REALIZADA "			&_
				"   ,LTF.NUM_LCTO                "          &_ 				 
				 " FROM FIN_LCTO_TRANSF LTF "				&_
				 "	 ,FIN_CONTA CTA "						&_
				 " WHERE LTF.COD_CONTA_DEST=CTA.COD_CONTA "
		If prCOD_CONTA <> "" Then strSQL = strSQL & " AND LTF.COD_CONTA_DEST = " & prCOD_CONTA
		if prDT_INI <> "" And prDT_FIM <> "" then
			strSQL = strSQL & " AND LTF.DT_LCTO BETWEEN '" & PrepDataBrToUni(prDT_INI, False) & "' AND '" & PrepDataBrToUni(prDT_FIM, False) & "' "
		else
			strSQL = strSQL & " AND Year(LTF.DT_LCTO)>=" & prANO
		end if
		If prCOD_LCTO <> ""	Then strSQL = strSQL & " AND LTF.COD_LCTO_TRANSF = " & prCOD_LCTO

		strSQL = strSQL & " ORDER BY DATA"
		MontaSQLUnion_D = strSQL
	end function

%>