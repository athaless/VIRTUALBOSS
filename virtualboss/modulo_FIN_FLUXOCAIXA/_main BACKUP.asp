<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_FLUXOCAIXA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSa
 Dim strCOOKIE_ID_USUARIO, strGRUPO_USUARIO
 Dim strENTIDADE, strSALDO
 Dim strPERIODO, strDT_INI, strDT_FIM
 Dim strCONTA, strTIPO
 Dim strICON, strTITLE
 Dim strCODIGO_ENT, strTIPO_ENT
 Dim strTOTAL_A_PAGAR, strTOTAL_A_RECEBER
 Dim strTOTAL_PREVISAO, strBOLETO_EMITIDO, strCOLOR

 AbreDBConn objConn, CFG_DB 

 strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 strGRUPO_USUARIO 	  = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))

 strCONTA	       = GetParam("var_fin_conta")
 strTIPO           = GetParam("var_pr")
 strCODIGO_ENT     = GetParam("var_codigo")
 strTIPO_ENT       = GetParam("var_tipo")
 strPERIODO        = GetParam("var_periodo")
 strBOLETO_EMITIDO = GetParam("var_boleto_emitido")
 
 if IsNumeric(strTIPO) then strTIPO = CInt(strTIPO)
 
 strDT_INI = ""
 strDT_FIM = ""
 
 If strPERIODO = "ATE_HOJE"         Then strDT_FIM = Date()
 If strPERIODO = "ATE_7D"           Then strDT_FIM = DateAdd("D",  7, Date)
 If strPERIODO = "ATE_15D"          Then strDT_FIM = DateAdd("D", 15, Date)
 If strPERIODO = "ATE_MES_ATUAL"    Then strDT_FIM = DateAdd("D", -1, DateSerial(DatePart("YYYY", DateAdd("M", 1, Date)), DatePart("M", DateAdd("M", 1, Date)), 1))
 If strPERIODO = "ATE_MES_SEGUINTE" Then strDT_FIM = DateAdd("D", -1, DateSerial(DatePart("YYYY", DateAdd("M", 2, Date)), DatePart("M", DateAdd("M", 2, Date)), 1))
 If strPERIODO = "APENAS_NESTE_MES" Then
 	strDT_INI = DateSerial(DatePart("YYYY", Date), DatePart("M", Date), 1)
	strDT_FIM = DateAdd("D", -1, DateSerial(DatePart("YYYY", DateAdd("M", 1, Date)), DatePart("M", DateAdd("M", 1, Date)), 1))
 End If
 
 if strDT_FIM<>"" then
	strSQL = " SELECT" 															&_
				"	T1.COD_CONTA_PAGAR_RECEBER,"								&_
				"	T1.TIPO," 													&_
				"	T1.CODIGO," 												&_
				"	T1.HISTORICO," 												&_
				"	T1.NUM_DOCUMENTO," 											&_
				"	T1.PAGAR_RECEBER," 											&_
				"	T1.DT_VCTO," 												&_
				"	T1.VLR_CONTA,"												&_
				"	T1.NUM_IMPRESSOES,"											&_				
				"	T1.SITUACAO," 												&_
				"	DATEDIFF(CURDATE(),T1.DT_VCTO) AS NUM_DIAS," 				&_
				"	T2.NOME 				AS CONTA," 							&_
				"	T3.NOME 				AS PLANO_CONTA,"					&_
				"	T3.COD_REDUZIDO 		AS PLANO_CONTA_COD_REDUZIDO,"		&_
				"	T3.COD_PLANO_CONTA," 										&_
				"	T4.NOME AS CENTRO_CUSTO," 									&_
				"	T4.COD_REDUZIDO 		AS CENTRO_CUSTO_COD_REDUZIDO " 		&_
				"FROM"															&_ 
				"	FIN_CONTA_PAGAR_RECEBER AS T1," 							&_
				"	FIN_CONTA 				AS T2," 							&_
				"	FIN_PLANO_CONTA 		AS T3,"								&_
				"	FIN_CENTRO_CUSTO 		AS T4 "								&_
				"WHERE" 														&_
				"	T1.COD_CONTA  		= T2.COD_CONTA AND" 					&_
				"	T1.COD_PLANO_CONTA  = T3.COD_PLANO_CONTA AND" 				&_
				"	T1.COD_CENTRO_CUSTO = T4.COD_CENTRO_CUSTO AND"              &_
				"	T2.DT_INATIVO IS NULL "
	
	if strTIPO > 0 then
		if strTIPO = 1 then strSQL = strSQL & " AND T1.PAGAR_RECEBER<>0"
		if strTIPO = 2 then strSQL = strSQL & " AND T1.PAGAR_RECEBER=0"
	end if
	
	if strCONTA<>"" then strSQL = strSQL & " AND (T2.COD_CONTA =" & strCONTA & ") "
	
	if strCODIGO_ENT<>"" and strTIPO_ENT<>"" then strSQL = strSQL & " AND (T1.TIPO='" & strTIPO_ENT & "' AND T1.CODIGO='" & strCODIGO_ENT & "')"
	
	If strPERIODO <> "APENAS_NESTE_MES" Then
		strSQL = strSQL & " AND T1.DT_VCTO <= '" & PrepDataBrToUni(strDT_FIM,False) & "' "
	Else
		strSQL = strSQL & " AND T1.DT_VCTO BETWEEN '" & PrepDataBrToUni(strDT_INI,False) & "' AND '" & PrepDataBrToUni(strDT_FIM,False) & "' "
	End If
	
	If strBOLETO_EMITIDO = "SIM" Then strSQL = strSQL & " AND T1.NUM_IMPRESSOES > 0 "
	If strBOLETO_EMITIDO = "NAO" Then strSQL = strSQL & " AND (T1.NUM_IMPRESSOES = 0 OR T1.NUM_IMPRESSOES IS NULL) "
	
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
	<th width="40%" class="sortable">Entidade</th>
	<th width="15%" class="sortable">Conta</th>								
	<th width="20%" class="sortable" nowrap>Plano de Conta</th>
	<th width="5%" class="sortable-numeric" nowrap>Num Doc</th>		
	<th width="03%">Atraso</th>
	<th width="01%" class="sortable-date-dmy" nowrap>Dt Vcto</th>
	<th width="10%" class="sortable-numeric">Valor</th>								
	<th width="01%"></th>
	<th width="01%"></th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%	
 		while not objRS.Eof
			strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
			
			strSALDO = 0
			if GetValue(objRS,"VLR_CONTA")<>"" then strSALDO = FormataDecimal(GetValue(objRS,"VLR_CONTA"),2)
			
			strICON  = "Receber"
			strTITLE = "Conta a Receber"
			if GetValue(objRS,"PAGAR_RECEBER") = "1" then
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
		
			strSQL = "SELECT COUNT(COD_CONTA_PAGAR_RECEBER) AS LCTOS FROM FIN_LCTO_ORDINARIO WHERE COD_CONTA_PAGAR_RECEBER=" & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")
			AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1						
			
			if GetValue(objRS,"PAGAR_RECEBER") = "1" then strTOTAL_A_PAGAR   = strTOTAL_A_PAGAR   + strSALDO
			if GetValue(objRS,"PAGAR_RECEBER") = "0" then strTOTAL_A_RECEBER = strTOTAL_A_RECEBER + strSALDO					
%>
		<tr bgcolor=<%=strCOLOR%> valign="middle">		
			<td align="center" height="16">
			<% 
			 if (CInt("0" & GetValue(objRSa,"LCTOS"))<1) then
				response.write (MontaLinkGrade("modulo_FIN_TITULOS","Delete.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DEL.gif","REMOVER") )
			 end if
			%>
			</td>
			<td align="center"><%=MontaLinkGrade("modulo_FIN_TITULOS","Detail.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DETAIL.gif","DETALHE")%></td>		
			<td align="center">
			<% 
			 if GetValue(objRS,"SITUACAO")<>"LCTO_TOTAL" and GetValue(objRS,"SITUACAO")<>"CANCELADA" then 
				response.write (MontaLinkGrade("modulo_FIN_TITULOS","InsertLcto.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DETAILADD.gif","INSERIR LANÇAMENTO") )
			 end if 
			%>
			</td>		
			<td align="center">
			<% 
			 if GetValue(objRS,"PAGAR_RECEBER") = "0" then 
				response.write (MontaLinkGrade("modulo_FIN_BOLETO","ShowBoleto.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_BOLETO.gif","GERAR BOLETO") )
			 end if 
			%>
			</td>
			<td><%=strENTIDADE%></td>
			<td nowrap><%=GetValue(objRS,"CONTA")%></td>
			<td nowrap><%=GetValue(objRS,"PLANO_CONTA_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td>
			<td nowrap><%=GetValue(objRS,"NUM_DOCUMENTO")%></div></td>
			<td align="right" nowrap><%if GetValue(objRS,"NUM_DIAS")>"0" Then Response.Write(GetValue(objRS, "NUM_DIAS") & " dia(s)")%></td>
			<td align="right"><%=PrepData(GetValue(objRS,"DT_VCTO"),true,false)%></td>
			<td align="right"><%=strSALDO%></td>
			<td style="background: url(../img/icon_FinConta<%=strICON%>.gif) no-repeat center; width:21px;" title="<%=strTITLE%>"></td>
			<td valign="middle">
				<% 
				 if GetValue(objRS,"NUM_IMPRESSOES")<>"" and CInt("0" & GetValue(objRS,"NUM_IMPRESSOES"))>0 then
					Dim strFilePath, strFileName
					strFilePath =	"../upload/" & UCase(Request.Cookies("VBOSS")("CLINAME")) & "/FIN_Boletos/" 
					strFileName	=	"Boleto_" & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER") & "_" & GetValue(objRS,"NUM_IMPRESSOES") & ".htm"
					strFilePath	= strFilePath & strFileName
				    'response.write (MontaLinkGrade("modulo_FIN_FLUXOCAIXA",strFilePath,"","Icon_BOLETO.gif","BOLETO") )
				%>
					<a href="#" onClick="javascript:window.open('<%=strFilePath%>', '', 'width=700,height=500,top=30,left=30,scrollbars=1,resizable=yes');">
					  <img src="../img/Icon_BOLETO.gif" border="0px"></a>
				<% end if %>
			</td>
		</tr>
		<%
			FechaRecordSet objRSa
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
		FechaRecordSet objRS
	else
		Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	end if
	FechaDBConn objConn
end if
%>