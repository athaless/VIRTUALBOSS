<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_LCTO_GERAIS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSa, objRSb
 Dim strMES, strMES_NEXT, strANO 
 Dim strDT_INI, strDT_FIM, strPERIODO
 Dim strORIGEM, strDESTINO, strENTIDADE
 Dim strVLR_IN, strVLR_OUT, strVALOR
 Dim strICON, strTITLE, strMOSTRA_TOTAL
 Dim strTOTAL_ENTRADA, strTOTAL_SAIDA
 Dim strSALDO_ANTERIOR, strTR
 Dim strCOD_CONTA, strPREVISTA, strREALIZADA
 Dim strTIPO, strCODIGO
 Dim ExibirSaldo
 Dim strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA
 Dim strPESQUISA, strGRP_FINAN

 AbreDBConn objConn, CFG_DB 

 strMES	= GetParam("var_mes")
 strANO	= GetParam("var_ano")
 strPERIODO = GetParam("var_periodo")
 strDT_INI = GetParam("var_dt_ini")
 strDT_FIM = GetParam("var_dt_fim")
 strPESQUISA = GetParam("var_pesquisa")
 strTIPO = GetParam("var_tipo")
 strCODIGO = GetParam("var_codigo")
 strCOD_PLANO_CONTA = GetParam("var_cod_plano_conta")
 strCOD_CENTRO_CUSTO = GetParam("var_cod_centro_custo")
 
 strCOD_CONTA = ""
 strGRP_FINAN = ""
 If InStr(strPESQUISA, "cod_conta_") > 0 Then strCOD_CONTA = Mid(strPESQUISA, InStr(strPESQUISA, "cod_conta_")+10)
 If InStr(strPESQUISA, "grp_finan_") > 0 Then strGRP_FINAN = Mid(strPESQUISA, InStr(strPESQUISA, "grp_finan_")+10)

	If strPERIODO = "FIXO" Then
		If IsEmpty(strANO) Then strANO = DatePart("YYYY", Date)
		
		if strMES="" then 
			strDT_INI = DateSerial(strANO,  1,  1)
			strDT_FIM = DateSerial(strANO, 12, 31)
		else
			strDT_INI = DateSerial(strANO, strMES, 1)
			strDT_FIM = DateAdd("D", -1, DateAdd("M", 1, strDT_INI))
		end if
	End If
	If strPERIODO = "LIVRE" Then
		If strDT_INI <> "" And strDT_FIM <> "" Then
			strMES = DatePart("M"   , strDT_INI)
			strANO = DatePart("YYYY", strDT_INI)
		End If
	End If
	If strPERIODO = "" Then
		strPERIODO = "LIVRE"
		
		strDT_INI = PrepData(DateAdd("D", -10, Date()), True, False)
		strDT_FIM = PrepData(Date(), True, False)
		strMES = DatePart("M"   , strDT_INI)
		strANO = DatePart("YYYY", strDT_INI)
	End If
	
 strSALDO_ANTERIOR = 0
 ExibirSaldo = False
 If (strCOD_CENTRO_CUSTO = "" And strCOD_PLANO_CONTA = "" And strCODIGO = "" And strTIPO = "") Then ExibirSaldo = True

 if (strANO <> "") and (strCOD_CONTA <> "" or strGRP_FINAN <> "") then
	'---------------------------------------------
	' Monta busca de lançamentos ordinários
	'---------------------------------------------
	strSQL = "SELECT PGR.COD_CONTA_PAGAR_RECEBER AS CODIGO " 		&_
				"	,CTA1.NOME AS CONTA_PREVISTA " 					&_
				"	,iif(PGR.PAGAR_RECEBER,'SAIDA','ENTRADA') AS OPERACAO " &_
				"	,'TITULOS' AS MODULO " 							&_
				"	,PGR.TIPO " 									&_
				"	,PGR.CODIGO AS COD_ENTIDADE " 					&_
				"	,PGR.HISTORICO " 								&_
				"	,ORD.VLR_LCTO AS VALOR " 						&_
				"	,ORD.DT_LCTO AS DATA " 							&_
				"	,CTA2.NOME AS CONTA_REALIZADA " 				&_
				"FROM FIN_CONTA_PAGAR_RECEBER PGR " 				&_
				"	 ,FIN_LCTO_ORDINARIO ORD " &_
				"	 ,FIN_CONTA CTA1 " &_
				"	 ,FIN_CONTA CTA2 " &_
				"WHERE ORD.SYS_DT_CANCEL IS NULL " &_
				"AND ORD.COD_CONTA_PAGAR_RECEBER=PGR.COD_CONTA_PAGAR_RECEBER " &_
				"AND PGR.COD_CONTA=CTA1.COD_CONTA " &_
				"AND ORD.COD_CONTA=CTA2.COD_CONTA "
	If strCOD_CONTA <> "" Then strSQL = strSQL & " AND CTA2.COD_CONTA = " & strCOD_CONTA
	If strGRP_FINAN <> "" Then strSQL = strSQL & " AND CTA2.GRP_FINAN LIKE '" & strGRP_FINAN & "' "
	if strDT_INI <> "" And strDT_FIM <> "" then 
		strSQL = strSQL & " AND ORD.DT_LCTO BETWEEN #" & PrepData(strDT_INI, False, False) & "# AND #" & PrepData(strDT_FIM, False, False) & "#"
	else	
		strSQL = strSQL & " AND DatePart('yyyy',ORD.DT_LCTO)>=" & strANO
	end if
	If strCODIGO <> "" And strTIPO <> "" Then strSQL = strSQL & " AND (PGR.CODIGO LIKE '" & strCODIGO & "' AND PGR.TIPO LIKE '" & strTIPO & "') " 
	If strCODIGO = "" And strTIPO <> "" Then strSQL = strSQL & " AND PGR.TIPO LIKE '" & strTIPO & "' " 
	If strCOD_CENTRO_CUSTO <> "" Then strSQL = strSQL & " AND ORD.COD_CENTRO_CUSTO = " & strCOD_CENTRO_CUSTO
	If strCOD_PLANO_CONTA <> "" Then strSQL = strSQL & " AND ORD.COD_PLANO_CONTA = " & strCOD_PLANO_CONTA
	
	'---------------------------------------------
	' Monta busca de lançamentos em conta
	'---------------------------------------------
	strSQL = strSQL &	" UNION "							&_
				"SELECT LCT.COD_LCTO_EM_CONTA AS CODIGO "		&_
				"	   ,'' AS CONTA_PREVISTA "					&_
				"	   ,iif(LCT.OPERACAO='DESPESA','SAIDA','ENTRADA') AS OPERACAO " &_
				"	   ,'LCTOCONTA' AS MODULO "					&_			
				"	   ,LCT.TIPO "								&_			
				"      ,LCT.CODIGO AS COD_ENTIDADE"				&_
				"	   ,LCT.HISTORICO "							&_
				"	   ,LCT.VLR_LCTO AS VALOR "					&_
				"	   ,LCT.DT_LCTO AS DATA "					&_
				"	   ,CTA2.NOME AS CONTA_REALIZADA "			&_
				"FROM FIN_LCTO_EM_CONTA LCT "					&_
				"	 ,FIN_CONTA CTA2 "							&_
				"WHERE LCT.COD_CONTA=CTA2.COD_CONTA "
	If strCOD_CONTA <> "" Then strSQL = strSQL & " AND CTA2.COD_CONTA = " & strCOD_CONTA
	If strGRP_FINAN <> "" Then strSQL = strSQL & " AND CTA2.GRP_FINAN LIKE '" & strGRP_FINAN & "' "
	if strDT_INI <> "" And strDT_FIM <> "" then
		strSQL = strSQL & " AND LCT.DT_LCTO BETWEEN #" & PrepData(strDT_INI, False, False) & "# AND #" & PrepData(strDT_FIM, False, False) & "#"
	else
		strSQL = strSQL & " AND DatePart('yyyy',LCT.DT_LCTO)>=" & strANO
	end if
	If strCODIGO <> "" And strTIPO <> "" Then strSQL = strSQL & " AND (LCT.CODIGO LIKE '" & strCODIGO & "' AND LCT.TIPO LIKE '" & strTIPO & "') " 
	If strCODIGO = "" And strTIPO <> "" Then strSQL = strSQL & " AND LCT.TIPO LIKE '" & strTIPO & "' " 
	If strCOD_CENTRO_CUSTO <> "" Then strSQL = strSQL & " AND LCT.COD_CENTRO_CUSTO = " & strCOD_CENTRO_CUSTO
	If strCOD_PLANO_CONTA <> "" Then strSQL = strSQL & " AND LCT.COD_PLANO_CONTA = " & strCOD_PLANO_CONTA
	
	'---------------------------------------------------------------------------------------------------------------------------
	' Monta busca para lançamentos de transferência
	' Se usuário selecionar algum dos filtros abaixo então NÃO deve trazer as transferências
	' 1) centro de custo
	' 2) plano de conta
	' 3) tipo e/ou entidade
	'---------------------------------------------------------------------------------------------------------------------------
	If (strDT_INI <> "" Or strDT_FIM <> "" Or strCOD_CONTA <> "") And strCODIGO = "" And strTIPO = "" Then 
		strSQL = strSQL &	" UNION " &_
				"SELECT" &_
				"	LTF.COD_LCTO_TRANSF AS CODIGO,"	&_
				"	'' AS CONTA_PREVISTA, " &_
				"	'SAIDA' AS OPERACAO," &_
				"   '' AS MODULO, "&_			
				"	'' AS TIPO," &_
				"   '' AS COD_ENTIDADE," &_			
				"	LTF.HISTORICO,"	&_
				"	LTF.VLR_LCTO AS VALOR,"	&_
				"	LTF.DT_LCTO AS DATA,"	&_
				"	CTA.NOME AS CONTA_REALIZADA " &_
				"FROM FIN_LCTO_TRANSF LTF "	&_
				"	 ,FIN_CONTA CTA " &_
				"WHERE LTF.COD_CONTA_ORIG=CTA.COD_CONTA "
		If strCOD_CONTA <> "" Then strSQL = strSQL & " AND LTF.COD_CONTA_ORIG = " & strCOD_CONTA
		If strGRP_FINAN <> "" Then strSQL = strSQL & " AND CTA.GRP_FINAN LIKE '" & strGRP_FINAN & "' "
		if strDT_INI <> "" And strDT_FIM <> "" then
			strSQL = strSQL & " AND LTF.DT_LCTO BETWEEN #" & PrepData(strDT_INI, False, False) & "# AND #" & PrepData(strDT_FIM, False, False) & "#"
		else
			strSQL = strSQL & " AND DatePart('yyyy',LTF.DT_LCTO)>=" & strANO
		end if
		
		strSQL = strSQL &	" UNION " &_
				"SELECT" &_
				"	LTF.COD_LCTO_TRANSF AS CODIGO,"	&_
				"	'' AS CONTA_PREVISTA, " &_
				"	'ENTRADA' AS OPERACAO," &_
				"   '' AS MODULO, "&_			
				"	'' AS TIPO," &_
				"   '' AS COD_ENTIDADE," &_			
				"	LTF.HISTORICO,"	&_
				"	LTF.VLR_LCTO AS VALOR,"	&_
				"	LTF.DT_LCTO AS DATA,"	&_
				"	CTA.NOME AS CONTA_REALIZADA " &_
				"FROM FIN_LCTO_TRANSF LTF "	&_
				"	 ,FIN_CONTA CTA " &_
				"WHERE LTF.COD_CONTA_DEST=CTA.COD_CONTA "
		If strCOD_CONTA <> "" Then strSQL = strSQL & " AND LTF.COD_CONTA_DEST = " & strCOD_CONTA
		If strGRP_FINAN <> "" Then strSQL = strSQL & " AND CTA.GRP_FINAN LIKE '" & strGRP_FINAN & "' "
		if strDT_INI <> "" And strDT_FIM <> "" then
			strSQL = strSQL & " AND LTF.DT_LCTO BETWEEN #" & PrepData(strDT_INI, False, False) & "# AND #" & PrepData(strDT_FIM, False, False) & "#"
		else
			strSQL = strSQL & " AND DatePart('yyyy',LTF.DT_LCTO)>=" & strANO
		end if
	End If
	
	strSQL = strSQL & " ORDER BY DATA"
	
	'Response.Write(strSQL)
	'Response.End()
	
	AbreRecordSet objRS, strSQL, objConn, adOpenDynamic
	
	if not objRS.Eof then 
		'-------------------------------------------------------------------------------------
		' Busca saldo anterior
		' Se foi solicitada pesquisa por alguma conta, então não exibe informações de saldo
		'-------------------------------------------------------------------------------------
		If ExibirSaldo = False Then
			strSALDO_ANTERIOR = 0
			strTR = ""
		Else
			strSQL = "SELECT DISTINCT COD_CONTA FROM FIN_SALDO_AC"
			AbreRecordSet objRSa, strSQL, objConn, adOpenDynamic
			if not objRSa.eof then
				while not objRSa.eof
					if strMES<>"" then 					
						strSQL = "SELECT VALOR AS SALDO_ANTERIOR, CDate('01/' & MES & '/' & ANO) AS DATA_AC FROM FIN_SALDO_AC WHERE "													
						strSQL = strSQL & "DateSerial(ANO,MES,1) < DateSerial(" & strANO & "," &  strMES & ",1)"					
						strSQL = strSQL & " AND COD_CONTA=" & GetValue(objRSa,"COD_CONTA") & " ORDER BY 2"						
					else
						strSQL = "SELECT VALOR AS SALDO_ANTERIOR, CDate('01/' & MES & '/' & ANO) AS DATA FROM FIN_SALDO_AC WHERE ANO<"& strANO &" AND COD_CONTA="& GetValue(objRSa,"COD_CONTA") & " ORDER BY 2"
					end if
					
					AbreRecordSet objRSb, strSQL, objConn, adOpenDynamic
					
					if not objRSb.eof then 
						objRSb.MoveLast
						if GetValue(objRSb,"SALDO_ANTERIOR")<>"" then strSALDO_ANTERIOR = strSALDO_ANTERIOR + CDbl(GetValue(objRSb,"SALDO_ANTERIOR"))
					else
						strSQL = "SELECT VLR_SALDO_INI FROM FIN_CONTA WHERE COD_CONTA=" & GetValue(objRSa,"COD_CONTA")
						AbreRecordSet objRSb, strSQL, objConn, adOpenDynamic
						if not objRSb.eof then strSALDO_ANTERIOR = strSALDO_ANTERIOR + CDbl(GetValue(objRSb,"VLR_SALDO_INI"))				
					end if
					
					FechaRecordSet objRSb
					'objRSa.MoveNext
					athMoveNext objRSa, ContFlush, 0
				wend
			end if
			FechaRecordSet objRSa				
		End If
		
		If ExibirSaldo = True Then
			'--------------------------------------------------------
			'Exibe o saldo acumulado
			'--------------------------------------------------------
			strSALDO_ANTERIOR = FormataDecimal(strSALDO_ANTERIOR,2)
			strTR = "<tr bgcolor='" & strCOLOR & "' valign='middle'><td></td><td></td><td></td><td></td><td></td>"
			strTR = strTR & "<td height='16px'>Saldo Total Anterior</div></td>"
			if CDbl(strSALDO_ANTERIOR)>0 then
				strTOTAL_ENTRADA = CDbl(strSALDO_ANTERIOR)
				strTR = strTR & "<td align='right'>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</div></td><td></td><td></td></tr>"
			else
				strTOTAL_SAIDA = CDbl(strSALDO_ANTERIOR) 
				strTR = strTR & "<td></div></td><td align='right'>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</div></td><td></td></tr>"
			end if	
		End If				
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr> 
    <th WIDTH="01%"></th>		
    <th WIDTH="01%">Data</th>		
    <th WIDTH="20%">Entidade</th>
    <th WIDTH="25%">Prevista</th>
    <th WIDTH="25%">Realizada</th>								
    <th WIDTH="25%">Histórico</th>
    <th WIDTH="01%" nowrap>Vlr Entrada</th>
    <th WIDTH="01%" nowrap>Vlr Saída</th>								
    <th WIDTH="01%"></th>		
  </TR>
  </thead>
 <tbody style="text-align:left;">
<%	
	  strMES = month(GetValue(objRS,"DATA"))
      Dim Ct, strCOLOR
	
      Ct = 1  
		while not objRS.Eof	
			if (Ct mod 2) = 0 then
				strCOLOR = "#FFFFFF"
			else
				strCOLOR = "#F5FAFA"
			end if

			strVALOR = "0,00"	
			if GetValue(objRS,"VALOR")<>"" then	strVALOR = FormataDecimal(GetValue(objRS,"VALOR"),2)
			
			strSQL=""
			if GetValue(objRS,"TIPO")="ENT_CLIENTE"	    and IsNumeric(GetValue(objRS,"COD_ENTIDADE")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE		WHERE COD_CLIENTE     =" & GetValue(objRS,"COD_ENTIDADE")
			if GetValue(objRS,"TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"COD_ENTIDADE")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR  =" & GetValue(objRS,"COD_ENTIDADE")
			if GetValue(objRS,"TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"COD_ENTIDADE")) then strSQL = "SELECT NOME                   FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & GetValue(objRS,"COD_ENTIDADE")

			strENTIDADE=""
			if strSQL<>"" then 
				AbreRecordSet objRSa, strSQL, objConn, adOpenDynamic
				strENTIDADE=""
				if not objRSa.Eof then strENTIDADE = GetValue(objRSa,"NOME")
				FechaRecordSet objRSa
			end if 

			strVLR_IN = ""
			strVLR_OUT = ""
	
			strPREVISTA = GetValue(objRS,"CONTA_PREVISTA")
			strREALIZADA = GetValue(objRS,"CONTA_REALIZADA")
			
			if GetValue(objRS,"OPERACAO")<>"ENTRADA" then
				strVLR_OUT = strVALOR
				strTOTAL_SAIDA = strTOTAL_SAIDA + CDbl(strVLR_OUT)
				strSALDO_ANTERIOR = strSALDO_ANTERIOR - CDbl(strVLR_OUT)
				
				strICON  = "Pagar"
				strTITLE = "SAIDA"					
			else
				strVLR_IN = strVALOR
				strTOTAL_ENTRADA = strTOTAL_ENTRADA + CDbl(strVLR_IN)
				strSALDO_ANTERIOR = strSALDO_ANTERIOR + CDbl(strVLR_IN)
				
				strICON  = "Receber"
				strTITLE = "ENTRADA"
			end if

			Response.Write(strTR)
			strTR=""
%>
	<TR bgcolor=<%=strCOLOR%>>		
		<TD>
		<%
		If GetValue(objRS,"MODULO") <> "" Then
			Response.Write(MontaLinkGrade("modulo_FIN_"& GetValue(objRS,"MODULO"),"Detail.asp",GetValue(objRS,"CODIGO"),"IconAction_DETAIL.gif","DETALHE"))
		End If
		%>
		</TD>
		<TD nowrap><%=PrepData(GetValue(objRS,"DATA"),true,false)%></TD>
		<TD nowrap><%=strENTIDADE%></TD>
		<TD nowrap><%=strPREVISTA%></TD>
		<TD nowrap><%=strREALIZADA%></TD>
		<TD><%=GetValue(objRS,"HISTORICO")%></TD>
		<TD ALIGN="right"><%=strVLR_IN%></TD>
		<TD ALIGN="right"><%=strVLR_OUT%></TD>
		<TD nowrap><DIV STYLE="background: url(../img/icon_FinConta<%=strICON%>.gif) no-repeat center; width:21px;" TITLE="<%=strTITLE%>"></DIV></TD></TR>
	</TR>
<%
		strMES = Month(GetValue(objRS,"DATA"))
			
		Ct = Ct + 1
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			
		strMOSTRA_TOTAL = objRS.eof
		if not objRS.eof then strMES_NEXT = month(GetValue(objRS,"DATA"))
			
		if (strMES<>strMES_NEXT) or strMOSTRA_TOTAL then
%>
<% 'Response.Write("<tfoot>") %>
	<TR>
		<TD COLSPAN="6" align="right" WIDTH="98%">Valor Total:</TD>
		<TD WIDTH="01%" align="right"><b><%=FormataDecimal(strTOTAL_ENTRADA,2)%></b></TD>
		<TD WIDTH="01%" align="right"><b><%=FormataDecimal(strTOTAL_SAIDA,2)%></b></TD>
		<TD>&nbsp;</TD>
	</TR>
	<% If ExibirSaldo = True Then %>
	<TR ALIGN="right">
		<TD COLSPAN="6" align="right">Saldo no período:</TD>
		<TD>&nbsp;</TD>
		<TD nowrap align="right"><b><%=FormataDecimal(strSALDO_ANTERIOR,2)%></b></TD>
		<TD>&nbsp;</TD>		
	</TR>
    <% End If %>
<% 'Response.Write("</tfoot>") %>
<%
			strTOTAL_ENTRADA = "0,00"
			strTOTAL_SAIDA   = "0,00"
			
			If ExibirSaldo = True Then
				strTR = strTR & "<tr><td colspan='9' width='100%' style='border-bottom:1px solid #333333;'><span style='width:100%'></span></td></tr>"
				strTR = strTR & "<tr bgcolor='" & strCOLOR & "' valign='middle'><td></td><td></td><td></td><td></td><td></td>"
				strTR = strTR & "<td height='16px'>Saldo Total Anterior</div></td>"
				if CDbl(strSALDO_ANTERIOR)>0 then 
					strTOTAL_ENTRADA = CDbl(strSALDO_ANTERIOR)
					strTR = strTR & "<td align='right'>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</div></td><td></td><td></td></tr>"
				else
					strTOTAL_SAIDA = CDbl(strSALDO_ANTERIOR) 
					strTR = strTR & "<td></div></td><td align='right'>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</div></td><td></td></tr>"
				end if
				If strCOD_CONTA = "" Then
					if not objRS.eof then Response.Write(strTR)
				End If
				strTR=""
			End If
		end if
	wend
%>
 </tbody>
</table>
</body>
</html>
<%
		FechaRecordSet objRS
	else
		Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	end if
	FechaDBConn objConn
end if
%>