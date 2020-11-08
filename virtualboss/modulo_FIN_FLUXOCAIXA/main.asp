<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_FLUXOCAIXA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSa
 Dim strVLR_CONTA, strVLR_SALDO
 Dim strPERIODO, strDT_INI, strDT_FIM
 Dim strCONTA, strTIPO, strENTIDADE, strCODIGO_ENT, strTIPO_ENT
 Dim strICON, strTITLE
 Dim strTOTAL_A_PAGAR, strTOTAL_A_RECEBER
 Dim strTOTAL_PREVISAO, strBOLETO_EMITIDO, strCOLOR,strFilePath,strFileName
 Dim strCALC_TAXAS, strRECALC_TAXAS, strNF_RECIBO
 
 AbreDBConn objConn, CFG_DB 
 
 strCONTA	       = GetParam("var_fin_conta")
 strTIPO           = GetParam("var_pr")
 strCODIGO_ENT     = GetParam("var_codigo")
 strTIPO_ENT       = GetParam("var_tipo")
 strPERIODO        = GetParam("var_periodo")
 strBOLETO_EMITIDO = GetParam("var_boleto_emitido")
 strNF_RECIBO      = GetParam("var_nf_recibo")
 
 if IsNumeric(strTIPO) then strTIPO = CInt(strTIPO)
 
 strDT_INI = ""
 strDT_FIM = ""
 
 If strPERIODO = "TODOS"            Then strDT_FIM = Date() 'nesta caso colocamos preenchemos com a data atual mas não haverá filtro por data na consulta
 If strPERIODO = "ATE_HOJE"         Then strDT_FIM = Date()
 If strPERIODO = "ATE_AMANHA"       Then strDT_FIM = DateAdd("D",  1, Date)
 If strPERIODO = "ATE_7D"           Then strDT_FIM = DateAdd("D",  7, Date)
 If strPERIODO = "ATE_15D"          Then strDT_FIM = DateAdd("D", 15, Date)
 If strPERIODO = "ATE_MES_ATUAL"    Then strDT_FIM = DateAdd("D", -1, DateSerial(DatePart("YYYY", DateAdd("M", 1, Date)), DatePart("M", DateAdd("M", 1, Date)), 1))
 If strPERIODO = "ATE_MES_SEGUINTE" Then strDT_FIM = DateAdd("D", -1, DateSerial(DatePart("YYYY", DateAdd("M", 2, Date)), DatePart("M", DateAdd("M", 2, Date)), 1))
 If strPERIODO = "APENAS_NESTE_MES" Then
 	strDT_INI = DateSerial(DatePart("YYYY", Date), DatePart("M", Date), 1)
	strDT_FIM = DateAdd("D", -1, DateSerial(DatePart("YYYY", DateAdd("M", 1, Date)), DatePart("M", DateAdd("M", 1, Date)), 1))
 End If
 
 strCALC_TAXAS = VerificaDireito("|CALC_TAXAS|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), False)
 strRECALC_TAXAS = VerificaDireito("|RECALC_TAXAS|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), False)
 
 if strDT_FIM<>"" then
	strSQL = " SELECT T1.COD_CONTA_PAGAR_RECEBER "								  &_
				"	, T1.TIPO " 												  &_
				"	, T1.CODIGO " 												  &_
				"	, T1.HISTORICO " 											  &_
				"	, T1.NUM_DOCUMENTO " 										  &_
				"	, T1.PAGAR_RECEBER " 										  &_
				"	, T1.DT_VCTO " 												  &_
				"	, T1.NUM_IMPRESSOES "										  &_				
				"	, T1.SITUACAO " 											  &_
				"	, DATEDIFF(CURDATE(), T1.DT_VCTO) AS NUM_DIAS " 			  &_
				"	, T2.NOME 				AS CONTA " 							  &_
				"	, T3.COD_PLANO_CONTA " 										  &_
				"	, T3.NOME 				AS PLANO_CONTA "					  &_
				"	, T3.COD_REDUZIDO 		AS PLANO_CONTA_COD_REDUZIDO "		  &_
				"	, T4.NOME               AS CENTRO_CUSTO " 					  &_
				"	, T4.COD_REDUZIDO 		AS CENTRO_CUSTO_COD_REDUZIDO " 		  &_
				"	, T1.VLR_CONTA "											  &_
				"	, T1.ARQUIVO_ANEXO "										  &_
				"	, T1.MARCA_NFE "											  &_
                "	, T1.COD_NF "											      &_				
                "	, (CASE WHEN ((T1.COD_NF <> '') AND (T1.COD_NF IS NOT NULL))" &_
                "	         THEN (SELECT NF.ARQUIVO                            " &_
                "	  			   FROM NF_NOTA AS NF                           " &_
                "	                WHERE NF.ARQUIVO IS NOT NULL                " &_
                "	                  AND NF.SITUACAO = 'EMITIDA'               " &_
                "	                  AND NF.COD_NF = T1.COD_NF)                " &_
                "	         ELSE ''                                            " &_
                "	   END) AS NF_ARQUIVO				                        " &_
				"	, (SELECT SUM(VLR_LCTO) FROM FIN_LCTO_ORDINARIO WHERE COD_CONTA_PAGAR_RECEBER = T1.COD_CONTA_PAGAR_RECEBER) AS VLR_LCTO "	&_
				"	, (SELECT SUM(VLR_MULTA) FROM FIN_LCTO_ORDINARIO WHERE COD_CONTA_PAGAR_RECEBER = T1.COD_CONTA_PAGAR_RECEBER) AS VLR_MULTA "	&_
				"	, (SELECT SUM(VLR_JUROS) FROM FIN_LCTO_ORDINARIO WHERE COD_CONTA_PAGAR_RECEBER = T1.COD_CONTA_PAGAR_RECEBER) AS VLR_JUROS "	&_
				"	, (SELECT SUM(VLR_DESC) FROM FIN_LCTO_ORDINARIO WHERE COD_CONTA_PAGAR_RECEBER = T1.COD_CONTA_PAGAR_RECEBER) AS VLR_DESC "	&_
				"	, (SELECT COUNT(COD_CONTA_PAGAR_RECEBER) FROM FIN_LCTO_ORDINARIO WHERE COD_CONTA_PAGAR_RECEBER = T1.COD_CONTA_PAGAR_RECEBER) AS TOTAL_LCTOS "	&_
				"FROM FIN_CONTA_PAGAR_RECEBER	AS T1 " 						&_
				"	, FIN_CONTA					AS T2 " 						&_
				"	, FIN_PLANO_CONTA			AS T3 "							&_
				"	, FIN_CENTRO_CUSTO			AS T4 "							&_
				"WHERE T1.COD_CONTA = T2.COD_CONTA "							&_
				"AND T1.COD_PLANO_CONTA = T3.COD_PLANO_CONTA "					&_
				"AND T1.COD_CENTRO_CUSTO = T4.COD_CENTRO_CUSTO "				&_
				"AND T2.DT_INATIVO IS NULL "
	
	if strTIPO > 0 then
		if strTIPO = 1 then strSQL = strSQL & " AND T1.PAGAR_RECEBER <> 0"
		if strTIPO = 2 then strSQL = strSQL & " AND T1.PAGAR_RECEBER = 0"
	end if
	
	if strCONTA<>"" then strSQL = strSQL & " AND (T2.COD_CONTA =" & strCONTA & ") "
	
	if strCODIGO_ENT<>"" and strTIPO_ENT<>"" then strSQL = strSQL & " AND (T1.TIPO='" & strTIPO_ENT & "' AND T1.CODIGO='" & strCODIGO_ENT & "')"
	
	If strPERIODO <> "TODOS" Then
	  If strPERIODO <> "APENAS_NESTE_MES" Then
		  strSQL = strSQL & " AND T1.DT_VCTO <= '" & PrepDataBrToUni(strDT_FIM,False) & "' "
	  Else
		  strSQL = strSQL & " AND T1.DT_VCTO BETWEEN '" & PrepDataBrToUni(strDT_INI,False) & "' AND '" & PrepDataBrToUni(strDT_FIM,False) & "' "
	  End If
	End if
	
	If strBOLETO_EMITIDO = "SIM" Then strSQL = strSQL & " AND T1.NUM_IMPRESSOES > 0 "
	If strBOLETO_EMITIDO = "NAO" Then strSQL = strSQL & " AND (T1.NUM_IMPRESSOES = 0 OR T1.NUM_IMPRESSOES IS NULL) "
	
	If (strNF_RECIBO <> "") Then
		If 	(strNF_RECIBO = "A_GERAR") Then
			strSQL = strSQL & " AND (T1.PAGAR_RECEBER = 0 AND T1.TIPO = 'ENT_CLIENTE' AND T1.SITUACAO <> 'CANCELADA' AND COALESCE(T1.COD_NF,'') = '')"				
		Else  
			strSQL = strSQL & "  AND (T1.COD_NF = (SELECT NF1.COD_NF               " &_
               		  		  "	   	                 FROM NF_NOTA AS NF1           " &_
                			  "	                    WHERE NF1.ARQUIVO IS NOT NULL  " &_
                              "	                      AND NF1.SITUACAO = 'EMITIDA' " &_
                              "	                      AND NF1.COD_NF = T1.COD_NF)) " 
		End	If			
	End If
	
	strSQL = strSQL & " AND (T1.SITUACAO LIKE 'ABERTA' OR T1.SITUACAO LIKE 'LCTO_PARCIAL') "
	strSQL = strSQL & " ORDER BY T1.DT_VCTO "
	
	'athDebug strSQL, false
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.Eof then 
		strTOTAL_A_PAGAR  = 0
		strTOTAL_A_RECEBER= 0
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr>
	<th width="01%"></th>
	<th width="01%"></th>
	<th width="01%"></th>
	<th width="01%"></th>
	<th width="01%"></th>
	<th width="31%" class="sortable">Entidade</th>
	<th width="10%" class="sortable">Conta</th>								
	<th width="20%" class="sortable" nowrap>Plano de Conta</th>
	<th width="05%" class="sortable-numeric" nowrap>Num Doc</th>		
	<th width="03%" class="sortable-numeric">Atraso</th>
	<th width="01%" class="sortable-date-dmy" nowrap>Dt Vcto</th>
	<th width="10%" class="sortable-numeric">Valor</th>
	<th width="10%" class="sortable-numeric">Débito</th>
	<th width="01%"></th>
	<th width="01%"></th>
	<th width="01%"></th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%	
 		while not objRS.Eof
			strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
			
			strVLR_CONTA = 0
			if CDbl("0" & GetValue(objRS,"VLR_CONTA")) <> 0 then strVLR_CONTA = GetValue(objRS,"VLR_CONTA")
			
			strVLR_SALDO = strVLR_CONTA
			if CDbl("0" & GetValue(objRS,"VLR_LCTO"))  <> 0 then strVLR_SALDO = strVLR_SALDO - GetValue(objRS,"VLR_LCTO")
			if CDbl("0" & GetValue(objRS,"VLR_MULTA")) <> 0 then strVLR_SALDO = strVLR_SALDO + GetValue(objRS,"VLR_MULTA")
			if CDbl("0" & GetValue(objRS,"VLR_JUROS")) <> 0 then strVLR_SALDO = strVLR_SALDO + GetValue(objRS,"VLR_JUROS")
			if CDbl("0" & GetValue(objRS,"VLR_DESC"))  <> 0 then strVLR_SALDO = strVLR_SALDO - GetValue(objRS,"VLR_DESC")
			
			strVLR_CONTA = FormataDecimal(strVLR_CONTA ,2)
			strVLR_SALDO = FormataDecimal(strVLR_SALDO ,2)
			
			strICON  = "Receber"
			strTITLE = "Conta a Receber"
			if GetValue(objRS,"PAGAR_RECEBER") <> "0" then
				strICON  = "Pagar"
				strTITLE = "Conta a Pagar"
			end if
			
			strSQL=""
			strSQL = "SELECT NOME"
			if GetValue(objRS,"TIPO")<>"ENT_COLABORADOR" then strSQL = strSQL & "_COMERCIAL"
			if IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = strSQL & " AS NOME FROM " & GetValue(objRS,"TIPO") & " WHERE COD_" & Mid(GetValue(objRS,"TIPO"),5) & "=" & GetValue(objRS,"CODIGO")
			
			strENTIDADE=""
			if strSQL<>"" then 
				AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1			
				strENTIDADE=""
				if not objRSa.Eof then strENTIDADE = GetValue(objRSa,"NOME")
				FechaRecordSet objRSa
			end if 	
			
			if GetValue(objRS,"PAGAR_RECEBER") <> "0" then strTOTAL_A_PAGAR = strTOTAL_A_PAGAR + strVLR_SALDO
			if GetValue(objRS,"PAGAR_RECEBER") = "0" then strTOTAL_A_RECEBER = strTOTAL_A_RECEBER + strVLR_SALDO
%>
		<tr bgcolor="<%=strCOLOR%>" valign="middle">		
			<td align="center" height="16" title="REMOVER">
			<% 
			 if (CInt("0" & GetValue(objRS,"TOTAL_LCTOS"))<1) then
				response.write (MontaLinkGrade("modulo_FIN_TITULOS","Delete.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DEL.gif","REMOVER") )
			 end if
			%>
			</td>
			<td align="center" title="DETALHE"><%=MontaLinkGrade("modulo_FIN_TITULOS","Detail.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DETAILADD.gif","DETALHE")%></td>		
			<td title="GERAR TAXAS/REGERAR TAXAS">
			<%
			if GetValue(objRS,"PAGAR_RECEBER") = "0" then 
				if strCALC_TAXAS And GetValue(objRS,"SITUACAO") = "ABERTA" And (GetValue(objRS,"MARCA_NFE") = "" Or GetValue(objRS,"MARCA_NFE") = "SEM_NFE") then 
					Response.Write(MontaLinkGrade("modulo_FIN_TITULOS","GeraTaxasTituloP1.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_GERATAXAS1.gif","GERAR TAXAS"))
				else 
					if strRECALC_TAXAS And GetValue(objRS,"SITUACAO") = "ABERTA" And GetValue(objRS,"MARCA_NFE") = "COM_NFE" then 
						Response.Write(MontaLinkGrade("modulo_FIN_TITULOS","GeraTaxasTituloP1.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_GERATAXAS2.gif","REGERAR TAXAS"))
					end if
				end if
			end if
			%>
			</td>
			<td align="center" title="GERAR BOLETO">
			<% 
			 if GetValue(objRS,"PAGAR_RECEBER") = "0" then 
				response.write(MontaLinkGrade("modulo_FIN_BOLETO","ShowBoleto.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_BOLETO.gif","GERAR BOLETO"))
			 end if 
			%>
			</td>	
            
			<td align="center" title="GERAR/VISUALIZAR NF/RECIBO">
			<% 
			 if (GetValue(objRS,"PAGAR_RECEBER") = "0") and (GetValue(objRS,"TIPO")= "ENT_CLIENTE") and (GetValue(objRS,"SITUACAO") <> "CANCELADA") and (GetValue(objRS,"COD_NF") = "") then 
			     response.write(MontaLinkGrade("modulo_FIN_FLUXOCAIXA","InsertNFdeTitulo.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_GERARNF.gif","GERAR NF/RECIBO"))
			 else
			   if GetValue(objRS,"NF_ARQUIVO") = "" then
			     Response.Write("&nbsp;")
			   else
 			     Response.Write(MontaLinkPopup("upload/" & Request.Cookies("VBOSS")("CLINAME") & "/FIN_Notas",GetValue(objRS,"NF_ARQUIVO"),"","Icon_BOLETO.gif","VISUALIZAR NF/RECIBO","840","550","yes"))
			   end if   
			 end if 
			%>
            
			</td>	
			<td><%=strENTIDADE%></td>
			<td nowrap><%=GetValue(objRS,"CONTA")%></td>
			<td nowrap><%=GetValue(objRS,"PLANO_CONTA_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td>
			<td nowrap><%=GetValue(objRS,"NUM_DOCUMENTO")%></div></td>
			<td align="right" nowrap><%if GetValue(objRS,"NUM_DIAS")>"0" Then Response.Write(GetValue(objRS, "NUM_DIAS") & " dia(s)")%></td>
			<td align="right"><%=PrepData(GetValue(objRS,"DT_VCTO"),true,false)%></td>
			<td align="right"><%=strVLR_CONTA%></td>
			<td align="right"><%=strVLR_SALDO%></td>
			<td style="background: url(../img/icon_FinConta<%=strICON%>.gif) no-repeat center; width:21px;" title="<%=strTITLE%>"></td>
			<td valign="middle" title="BOLETO 1">
				<% 
				 if GetValue(objRS,"NUM_IMPRESSOES")<>"" and CInt("0" & GetValue(objRS,"NUM_IMPRESSOES"))>0 then
					strFilePath = "upload/" & UCase(Request.Cookies("VBOSS")("CLINAME")) & "/FIN_Boletos"
					strFileName	= "Boleto_"    & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER") & "_" & GetValue(objRS,"NUM_IMPRESSOES") & ".htm"
					response.write(MontaLinkPopup(strFilePath, strFileName, "", "Icon_BOLETO.gif", "BOLETO 1", "700", "500", "yes"))
				 end if 
				%>
			</td>
			<td title="ANEXO">
			<% 
			if GetValue(objRS,"ARQUIVO_ANEXO")<>"" then
				strFilePath = "upload/" & UCase(Request.Cookies("VBOSS")("CLINAME")) & "/FIN_Titulos"
				strFileName	= GetValue(objRS,"ARQUIVO_ANEXO")
				response.write(MontaLinkPopup(strFilePath, strFileName, "", "ico_clip.gif", "ANEXO", "700", "500", "yes"))
			end if 
			%>
			</td>
		</tr>
		<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend	
		'--------------------------------------------------------------------------------------------
		'	Parte contendo as informações sobre os totais (fluxo)
		'--------------------------------------------------------------------------------------------
		strTOTAL_PREVISAO  = strTOTAL_A_RECEBER - strTOTAL_A_PAGAR
		
		strTOTAL_A_RECEBER = FormataDecimal(strTOTAL_A_RECEBER,2)
		strTOTAL_A_PAGAR   = FormataDecimal(strTOTAL_A_PAGAR  ,2)
		strTOTAL_PREVISAO  = FormataDecimal(strTOTAL_PREVISAO ,2)
		%>
  </tbody>
</table>
<table align="right" cellpadding="0" cellspacing="0" width="200px" bgcolor="#F5FAFA" style="border: 1px solid; border-color: #C1DAD7;" class="tablesort">
  <tbody>
	<% if strTIPO=0 or strTIPO=2 then %>
	<tr>
	  <td align="right" nowrap>Total a Receber:</td>
	  <td align="right" nowrap><b><%=strTOTAL_A_RECEBER%></b></td>
	</tr>
	<% end if %>
	<% if strTIPO=0 or strTIPO=1 then %>
	<tr>
	  <td align="right" nowrap>Total a Pagar:</td>
	  <td align="right" nowrap><b><%=strTOTAL_A_PAGAR%></b></td>
	</tr>
	<% end if %>
	<% if strTIPO=0 then %>
	<tr>
	  <td></td>
	  <td align="right" nowrap><b><%=strTOTAL_PREVISAO%></b></td>
    </tr>
	<% end if %>
  </tbody>
</table>
</body>
</html>
<%
	else
		Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	end if
	FechaRecordSet objRS
end if
FechaDBConn objConn
%>