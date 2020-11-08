<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSa
 Dim strCOOKIE_ID_USUARIO, strGRUPO_USUARIO
 Dim strVLRTIT
 Dim strDT_INI, strDT_FIM, strPERIODO
 Dim strCONTA_PREVISTA, strCONTA_REALIZADA, strSITUACAO, strTIPO
 Dim strICON, strTITLE, strCODTIT
 Dim strCODIGO_ENT, strTIPO_ENT, strCOD_CONTAS_LCTOS, strCONTAS_LCTOS, strCODCCUSTO, strCODCONTRATO
 Dim Selecionado
 Dim strCOLOR
 Dim strFilePath, strFileName
 Dim strRECALC_TAXAS
 Dim acTOT_PAGAR, acTOT_RECEBER, acTOT_QUITADO
 
 
 AbreDBConn objConn, CFG_DB 
 
 strCONTA_PREVISTA	  = GetParam("var_fin_conta_prevista")
 strCONTA_REALIZADA	  = GetParam("var_fin_conta_realizada")
 strTIPO			  = GetParam("var_pr")	
 strSITUACAO		  = GetParam("var_situacao")
 strCODIGO_ENT		  = GetParam("var_codigo")
 strTIPO_ENT		  = GetParam("var_tipo")
 strDT_INI			  = GetParam("var_dt_ini") 
 strDT_FIM			  = GetParam("var_dt_fim") 
 strCODTIT			  = GetParam("var_cod_tit") 
 strCODCCUSTO	      = GetParam("var_centro_custo")
 strCODCONTRATO       = GetParam("var_cod_contrato")
 
 if not IsDate(strDT_INI) then strDT_INI = ""
 if not IsDate(strDT_FIM) then strDT_FIM = ""

 strRECALC_TAXAS = VerificaDireito("|RECALC_TAXAS|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), False)
 
	strSQL = 	" SELECT T1.COD_CONTA_PAGAR_RECEBER " 								&_
				"	,	T1.TIPO " 													&_
				"	,	T1.CODIGO " 												&_
				"	,	T1.DT_EMISSAO " 											&_
				"	,	T1.HISTORICO " 												&_
				"	,	T1.TIPO_DOCUMENTO " 										&_
				"	,	T1.NUM_DOCUMENTO " 											&_
				"	,	T1.PAGAR_RECEBER " 											&_
				"	,	T1.NUM_IMPRESSOES "											&_
				"	,	T1.DT_VCTO " 												&_
				"	,	T1.VLR_CONTA " 												&_
				"	,	T2.NOME AS CONTA " 											&_
				"	,	T1.SITUACAO " 												&_
				"	,	T1.COD_NF "													&_
				"	,	T3.NOME AS PLANO_CONTA " 									&_
				"	,	T3.COD_PLANO_CONTA " 										&_
				"	,	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO " 				&_
				"	,	T4.NOME AS CENTRO_CUSTO " 									&_
				"	,	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO " 				&_
				"	,	T1.ARQUIVO_ANEXO " 											&_
				"	,	T1.MARCA_NFE " 												&_
				"	,	T1.COD_CONTRATO "											&_
				"	,	COUNT(T5.COD_LCTO_ORDINARIO) AS LCTOS "						&_
				"	,	SUM(T5.VLR_LCTO) AS VRL_LCTOS "		  				        &_
				"	,	CASE WHEN (T1.TIPO = 'ENT_CLIENTE') "						&_
				"		  THEN (SELECT NOME_COMERCIAL FROM ENT_CLIENTE WHERE COD_CLIENTE = T1.CODIGO) "					&_
				"		  ELSE CASE WHEN (T1.TIPO = 'ENT_FORNECEDOR') "													&_
				"		         THEN (SELECT NOME_COMERCIAL FROM ENT_FORNECEDOR WHERE COD_FORNECEDOR = T1.CODIGO) "	&_
				"		         ELSE CASE WHEN (T1.TIPO = 'ENT_COLABORADOR') "											&_
				"		                THEN (SELECT NOME FROM ENT_COLABORADOR WHERE COD_COLABORADOR = T1.CODIGO) "		&_
				"		                ELSE '' "									&_
				"		              END "											&_
				"		       END "												&_
				"		END AS ENTIDADE "											&_
				" FROM FIN_CONTA_PAGAR_RECEBER AS T1 " 								&_
				" LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) "	&_
				" LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) "		&_
				" LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	&_
				" LEFT OUTER JOIN FIN_LCTO_ORDINARIO AS T5 ON (T1.COD_CONTA_PAGAR_RECEBER = T5.COD_CONTA_PAGAR_RECEBER) " &_
				" WHERE T2.DT_INATIVO IS NULL "

	if strCODTIT<>"" then  strSQL = strSQL & " AND T1.COD_CONTA_PAGAR_RECEBER = " & strCODTIT 

	if strDT_INI<>"" and strDT_FIM<>"" then strSQL = strSQL & "	AND T1.DT_VCTO BETWEEN '"& PrepDataBrToUni(strDT_INI,false) &"' AND '"& PrepDataBrToUni(strDT_FIM,false) &"'"
	
	if strSITUACAO<>"" then
		if mid(strSITUACAO,1,1)="_" then 
			strSQL = strSQL & " AND T1.SITUACAO NOT LIKE '"& mid(strSITUACAO,2) &"' AND T1.SITUACAO NOT LIKE 'CANCELADA'"
		else
			strSQL = strSQL & " AND T1.SITUACAO LIKE '"& strSITUACAO &"'"
		end if
	end if
	
	if strTIPO="PAGAR"   then  strSQL = strSQL & " AND T1.PAGAR_RECEBER <> 0 "
	if strTIPO="RECEBER" then  strSQL = strSQL & " AND T1.PAGAR_RECEBER = 0 "
	
	if strCONTA_PREVISTA<>"" then strSQL = strSQL &	" AND (T2.COD_CONTA ="& strCONTA_PREVISTA &") "
	
	if strCODIGO_ENT<>"" and strTIPO_ENT<>"" then strSQL = strSQL & " AND (T1.TIPO LIKE '"& strTIPO_ENT &"' AND T1.CODIGO LIKE '"& strCODIGO_ENT &"')"
	
	'adicionado filtro por centro de custo - by vini 25.01.2013
	if strCODCCUSTO<>"" then strSQL = strSQL &	" AND (T4.COD_CENTRO_CUSTO="& strCODCCUSTO & ") "
	
	if strCODCONTRATO<>"" then strSQL = strSQL & " AND (T1.COD_CONTRATO=" & strCODCONTRATO & ") "
	
	strSQL = strSQL & " GROUP BY T1.COD_CONTA_PAGAR_RECEBER "
	strSQL = strSQL & "		,	T1.TIPO "
	strSQL = strSQL & "		,	T1.CODIGO "
	strSQL = strSQL & "		,	T1.DT_EMISSAO "
	strSQL = strSQL & "		,	T1.HISTORICO "
	strSQL = strSQL & "		,	T1.TIPO_DOCUMENTO "
	strSQL = strSQL & "		,	T1.NUM_DOCUMENTO "
	strSQL = strSQL & "		,	T1.PAGAR_RECEBER "
	strSQL = strSQL & "		,	T1.NUM_IMPRESSOES "
	strSQL = strSQL & "		,	T1.DT_VCTO "
	strSQL = strSQL & "		,	T1.VLR_CONTA "
	strSQL = strSQL & "		,	T2.NOME "
	strSQL = strSQL & "		,	T1.SITUACAO "
	strSQL = strSQL & "		,	T1.COD_NF "
	strSQL = strSQL & "		,	T3.NOME "
	strSQL = strSQL & "		,	T3.COD_PLANO_CONTA "
	strSQL = strSQL & "		,	T3.COD_REDUZIDO "
	strSQL = strSQL & "		,	T4.NOME "
	strSQL = strSQL & "		,	T4.COD_REDUZIDO "
	strSQL = strSQL & "		,	T1.ARQUIVO_ANEXO "
	strSQL = strSQL & "		,	T1.MARCA_NFE "
	strSQL = strSQL & "		,	T1.COD_CONTRATO "
	strSQL = strSQL & " ORDER BY T1.DT_VCTO, T1.COD_CONTA_PAGAR_RECEBER "
	
	'athdebug strSQL, false
	
 	if (strDT_INI = "") or (strDT_FIM = "") then 
		Mensagem "Período de pesquisa inválido de [ " & strDT_INI & " ] até [ " & strDT_FIM & " ].", "", "", True
		Response.End()
	else 
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	end if
	
	
	if not objRS.Eof then 
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<!--link rel="stylesheet" type="text/css" href="../_css/virtualboss.css"-->
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
 <tr>
    <th width="01%"></th>
    <th width="01%"></th>
    <th width="01%"></th>
    <th width="1%"  class="sortable">Cód.</th>
    <th width="30%" class="sortable">Entidade</th>
	<th width="5%" class="sortable" nowrap>C.Prev</th>
    <!-- th width="...%" class="sortable" nowrap>C.Lcto</th //-->
    <th width="25%" class="sortable" nowrap>Plano de Conta</th>
	<th width="25%" class="sortable" nowrap>Centro de Custo</th>
    <th width="10%" class="sortable" nowrap>Num.DOC</th>
    <!-- <th width="01%" class="sortable-date-dmy" nowrap>Dt Emissão</th //-->
    <th width="01%" class="sortable-date-dmy" nowrap>Dt Vcto</th>
    <th width="05%" class="sortable-numeric" nowrap title="Valor original do título">Valor</th>
    <th width="05%" class="sortable-numeric" nowrap title="Valor pago ou recebido">Pago</th>
    <th width="01%"></th>
    <th width="01%"></th>
	<th width="01%"></th>
	<th width="01%"></th>	
 </tr>
 </thead>
 <tbody style="text-align:left;">
<%
		acTOT_PAGAR   = 0
		acTOT_RECEBER = 0
		acTOT_QUITADO = 0
		While Not objRs.Eof
			strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
			
			if GetValue(objRS,"VLR_CONTA")<>"" then 
			   strVLRTIT = FormataDecimal(GetValue(objRS, "VLR_CONTA"),2) 
			else 
			   strVLRTIT = "0,00"
			end if
%>
	<tr bgcolor="<%=strCOLOR%>">
		<td>
		<% if Cint("0" & GetValue(objRS,"LCTOS"))<1 then %>
			<%=MontaLinkGrade("modulo_FIN_TITULOS","Delete.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DEL.gif","REMOVER")%>
		<% end if %>
		</td>
		<td><%=MontaLinkGrade("modulo_FIN_TITULOS","Update.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_TITULOS","Detail.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DETAILADD.gif","DETALHE COM INSERÇÃO DE LCTO")%></td>		
		<td><%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%></td>
		<td><%=GetValue(objRS,"ENTIDADE")%></td>
		<td nowrap><%=GetValue(objRS,"CONTA")%></td>
		<!-- td nowrap><%'=strCONTAS_LCTOS%></td //-->
		<td nowrap><%=GetValue(objRS,"PLANO_CONTA_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td>
		<td nowrap><%=GetValue(objRS,"CENTRO_CUSTO_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS,"CENTRO_CUSTO")%></td>		
		<td nowrap><%=GetValue(objRS,"NUM_DOCUMENTO")%></td>
		<!-- td align="right"><%=PrepData(GetValue(objRS,"DT_EMISSAO"),true,false)%></td //-->
		<td align="right"><%=PrepData(GetValue(objRS,"DT_VCTO"),true,false)%></td>
		<td align="right"><%=strVLRTIT%></td>
		<td align="right"><%if GetValue(objRS, "VRL_LCTOS")<>"" then response.write(FormataDecimal(GetValue(objRS, "VRL_LCTOS"),2)) %>
        </td>
		<%
			if CInt(GetValue(objRS,"PAGAR_RECEBER")) <> 0 then 
				strICON  = "icon_FinContaPagar"
				strTITLE = "Conta a Pagar"					
			else
				strICON  = "icon_FinContaReceber"
				strTITLE = "Conta a Receber"
			end if
		%>
		<td style="background:url(../img/<%=strICON%>.gif) no-repeat top; width:21px;" title="<%=strTITLE%>"></td>
		<td>
		<% 
			if GetValue(objRS,"NUM_IMPRESSOES")<>"" and CInt("0" & GetValue(objRS,"NUM_IMPRESSOES"))>0 then
				strFilePath = "upload/" & UCase(Request.Cookies("VBOSS")("CLINAME")) & "/FIN_Boletos"
				strFileName	= "Boleto_" & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER") & "_" & GetValue(objRS,"NUM_IMPRESSOES") & ".htm"
				response.write(MontaLinkPopup(strFilePath, strFileName, "", "Icon_BOLETO.gif", "BOLETO", "700", "500", "yes"))
			end if 
		%>
		</td>	
		<td title="CONTRATO VINCULADO">
		<% 
          if GetValue(objRS,"COD_CONTRATO")<>"" then
  	        Response.write(MontaLinkPopup("modulo_CONTRATO", "Detail.asp", GetValue(objRS,"COD_CONTRATO"), "IconStatus_CONTRATADO.gif", "CONTRATO VINCULADO", "700", "500", "yes"))
		  end if 
		%>
		</td>	
		<td>
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
'			End If
			if CInt(GetValue(objRS,"PAGAR_RECEBER")) <> 0 then 
				acTOT_PAGAR   = acTOT_PAGAR + strVLRTIT 
			else
				acTOT_RECEBER = acTOT_RECEBER + strVLRTIT
			End if
			'acTOT_QUITADO = acTOT_QUITADO + CDbl(GetValue(objRS,"VRL_LCTOS"))
			
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend
%>
	<tfoot>
        <tr>
          <td COLSPAN="9" align="right" WIDTH="98%">Totais&nbsp;&nbsp;</td>
          <td WIDTH="01%" align="right">PAGAR:</td>
          <td COLSPAN="2" align="right"><b><%=FormataDecimal(acTOT_PAGAR,2)%></b></td>
          <td colspan="4"></td>
        </tr>
        <tr>
          <td COLSPAN="9" align="right" WIDTH="98%"></td>
          <td WIDTH="01%" align="right">RECEBER:</td>
          <td COLSPAN="2" align="right"><b><%=FormataDecimal(acTOT_RECEBER,2)%></b></td>
          <td colspan="4"></td>
        </tr>
        <!-- tr>
          <td COLSPAN="9" align="right" WIDTH="98%"></td>
          <td WIDTH="01%" align="right">QUITADO:</td>
          <td COLSPAN="2" align="right"><b><%=FormataDecimal(acTOT_RECEBER,2)%></b></td>
          <td colspan="4"></td>
        </tr //-->
    </tfoot>
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
%>