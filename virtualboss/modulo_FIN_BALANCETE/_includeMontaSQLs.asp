<%
function MontaSQLUnion_A(prMES, prANO, prTPCONS)
	Dim strSQL
	
	strSQL =          " SELECT fpc.COD_REDUZIDO "
	strSQL = strSQL & "      , fpc.DESCRICAO "
	strSQL = strSQL & "      , lcto.DT_LCTO AS DATA "
	strSQL = strSQL & "      , lcto.HISTORICO "
	strSQL = strSQL & "      , lcto.VLR_LCTO AS VALOR "
	strSQL = strSQL & "      , IF(tit.PAGAR_RECEBER=0,'RECEITA','DESPESA') as OPERACAO"
	strSQL = strSQL & "      , lcto.TIPO "
	strSQL = strSQL & "      , lcto.CODIGO AS COD_ENTIDADE "
	strSQL = strSQL & "  FROM fin_lcto_ordinario lcto "

	IF prTPCONS = "CENTRO_CUSTO" THEN
	  strSQL = strSQL & "     , fin_centro_custo fpc "
	ELSE  
	  strSQL = strSQL & "     , fin_plano_conta fpc "
	END IF

	strSQL = strSQL & "     , fin_conta_pagar_receber tit "

	IF prTPCONS = "CENTRO_CUSTO" THEN
	  strSQL = strSQL & " WHERE lcto.COD_CENTRO_CUSTO = fpc.COD_CENTRO_CUSTO "
	ELSE  
	  strSQL = strSQL & " WHERE lcto.COD_PLANO_CONTA = fpc.COD_PLANO_CONTA "
	END IF

	strSQL = strSQL & "   AND lcto.COD_CONTA_PAGAR_RECEBER = tit.COD_CONTA_PAGAR_RECEBER "
	strSQL = strSQL & "   AND lcto.SYS_DT_CANCEL IS NULL "
	if prMES <> "" then strSQL = strSQL & " AND Month(lcto.DT_LCTO)=" & prMES
	if prANO <> "" then strSQL = strSQL & " AND Year(lcto.DT_LCTO)=" & prANO
	strSQL = strSQL & " ORDER BY 1,3 "
	
	MontaSQLUnion_A = strSQL
end function

function MontaSQLUnion_B(prMES, prANO, prTPCONS)
	Dim strSQL
	
	strSQL = strSQL & " SELECT fpc.COD_REDUZIDO "
	strSQL = strSQL & "      , fpc.DESCRICAO "
	strSQL = strSQL & "      , lcto.DT_LCTO AS DATA "
	strSQL = strSQL & "      , lcto.HISTORICO "
	strSQL = strSQL & "      , lcto.VLR_LCTO AS VALOR "
	strSQL = strSQL & "      , lcto.OPERACAO "
	strSQL = strSQL & "      , lcto.TIPO "
	strSQL = strSQL & "      , lcto.CODIGO AS COD_ENTIDADE "
	strSQL = strSQL & "   FROM fin_lcto_em_conta lcto"

	IF prTPCONS = "CENTRO_CUSTO" THEN
		strSQL = strSQL & "		 , fin_centro_custo fpc "
	ELSE  
		strSQL = strSQL & "		 , fin_plano_conta fpc "
	END IF

	IF prTPCONS = "CENTRO_CUSTO" THEN
		strSQL = strSQL & " WHERE lcto.COD_CENTRO_CUSTO = fpc.COD_CENTRO_CUSTO "
	ELSE  
		strSQL = strSQL & " WHERE lcto.COD_PLANO_CONTA = fpc.COD_PLANO_CONTA "
	END IF

	if prMES <> "" then strSQL = strSQL & " AND Month(lcto.DT_LCTO)=" & prMES
	if prANO <> "" then strSQL = strSQL & " AND Year(lcto.DT_LCTO)=" & prANO
	strSQL = strSQL & " ORDER BY 1,3 "
	
	MontaSQLUnion_B = strSQL
end function
%>