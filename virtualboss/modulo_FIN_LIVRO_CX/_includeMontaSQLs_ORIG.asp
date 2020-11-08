<%
	function MontaSQLUnion_A(prDT_INI, prDT_FIM, prANO)
		Dim strSQL
		strSQL = "SELECT PGR.COD_CONTA_PAGAR_RECEBER AS CODIGO " 		&_
					"	,CTA1.NOME AS CONTA_PREVISTA " 					&_
					"	,if((PGR.PAGAR_RECEBER=0),'ENTRADA','SAIDA') AS OPERACAO " &_
					"	,'TITULOS' AS MODULO " 							&_
					"	,PGR.TIPO " 									&_
					"	,PGR.CODIGO AS COD_ENTIDADE " 					&_
					"	,PGR.HISTORICO " 								&_
					"	,ORD.VLR_LCTO AS VALOR " 						&_
					"	,ORD.DT_LCTO AS DATA " 							&_
					"	,CTA2.NOME AS CONTA_REALIZADA " 				&_
					"  ,PC.COD_PLANO_CONTA "   				            &_
					"  ,PC.COD_REDUZIDO " 				                &_
					"  ,PC.NOME AS NOME_PLANO_CONTA "                   &_
					"  ,ORD.COD_LCTO_ORDINARIO AS COD_AUX "             &_
					"FROM FIN_CONTA_PAGAR_RECEBER PGR " 				&_
					"	 ,FIN_LCTO_ORDINARIO ORD " &_
					"	 ,FIN_CONTA CTA1 " &_
					"	 ,FIN_CONTA CTA2 " &_
					"	 ,FIN_PLANO_CONTA PC " &_
					"WHERE ORD.SYS_DT_CANCEL IS NULL " &_
					"AND ORD.COD_CONTA_PAGAR_RECEBER=PGR.COD_CONTA_PAGAR_RECEBER " &_
					"AND PGR.COD_CONTA=CTA1.COD_CONTA " &_
					"AND ORD.COD_CONTA=CTA2.COD_CONTA " &_
					"AND ORD.COD_PLANO_CONTA = PC.COD_PLANO_CONTA" 

		if not IsNull(prDT_INI) then 
			strSQL = strSQL & " AND ORD.DT_LCTO BETWEEN '" & PrepDataBrToUni(prDT_INI,false) & "' AND '" & PrepDataBrToUni(prDT_FIM,false) & "'"
		else	
			strSQL = strSQL & " AND Year(ORD.DT_LCTO)>=" & prANO
		end if
		strSQL = strSQL & " ORDER BY COD_AUX " 'DATA
		MontaSQLUnion_A = strSQL
	end function
	
	
	function MontaSQLUnion_B(prDT_INI, prDT_FIM, prANO)
		Dim strSQL
		strSQL =    " SELECT LCT.COD_LCTO_EM_CONTA AS CODIGO " &_
					"	   ,'' AS CONTA_PREVISTA "					&_
					"	   ,if(LCT.OPERACAO='DESPESA','SAIDA','ENTRADA') AS OPERACAO " &_
					"	   ,'LCTOCONTA' AS MODULO "					 &_			
					"	   ,LCT.TIPO "								 &_			
					"      ,LCT.CODIGO AS COD_ENTIDADE"				 &_
					"	   ,LCT.HISTORICO "							 &_
					"	   ,LCT.VLR_LCTO AS VALOR "					 &_
					"	   ,LCT.DT_LCTO AS DATA "					 &_
					"	   ,CTA2.NOME AS CONTA_REALIZADA "			 &_
					"  ,PC.COD_PLANO_CONTA "   				         &_
					"  ,PC.COD_REDUZIDO " 				             &_
					"  ,PC.NOME AS NOME_PLANO_CONTA "                &_
					"  ,LCT.COD_LCTO_EM_CONTA AS COD_AUX "           &_
					"FROM FIN_LCTO_EM_CONTA LCT "					 &_
					"	 ,FIN_CONTA CTA2 "							 &_
					"	 ,FIN_PLANO_CONTA PC "                       &_
					"WHERE LCT.COD_CONTA=CTA2.COD_CONTA "            &_
					"  AND LCT.COD_PLANO_CONTA = PC.COD_PLANO_CONTA" 

		if not IsNull(strDT_INI) then 
			strSQL = strSQL & " AND LCT.DT_LCTO BETWEEN '" & PrepDataBrToUni(prDT_INI,false) & "' AND '" & PrepDataBrToUni(prDT_FIM,false) & "'"
		else
			strSQL = strSQL & " AND Year(LCT.DT_LCTO)>=" & prANO
		end if
		strSQL = strSQL & " ORDER BY COD_AUX " 'DATA
		MontaSQLUnion_B = strSQL
	end function

%>