<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_NFREPORT", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"-->
<%
  Dim objConn, objRS, strSQL 
  Dim strAviso, strSituacao, strNumNF, strSerieNF, strCodCfgNF, strCodConta
  Dim strDtIni, strDtFim, strCodCli, strFilePath
  Dim strCOLOR
  
  strAviso = "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
  strColor = "#DAEEFA"

  strSituacao = GetParam("var_situacao")
  strSerieNF  = GetParam("var_serie")
  strNumNF    = Replace(GetParam("var_num_nf"),"'","")
  strDtIni    = GetParam("var_dt_ini")
  strDtFim    = GetParam("var_dt_fim")
  strCodCli   = GetParam("var_cod_cli")
  strCodCfgNF = GetParam("var_cod_cfg_nf")
  strCodConta = GetParam("var_cod_conta")
  
  AbreDBConn objConn, CFG_DB

  strSQL = " SELECT"													& VbCrlf &_
			"	T1.COD_NF,"												& VbCrlf &_
			"	T1.NUM_NF,"												& VbCrlf &_
			"	T1.SERIE,"												& VbCrlf &_
			"	T1.CLI_NOME,"											& VbCrlf &_
			"	CLI_NUM_DOC,"											& VbCrlf &_
			"	T1.OBS_NF,"												& VbCrlf &_
			"	T1.VLR_ISSQN,"											& VbCrlf &_
			"	T1.VLR_IRPJ,"											& VbCrlf &_
			"	T1.VLR_COFINS,"											& VbCrlf &_
			"	T1.VLR_PIS,"											& VbCrlf &_
			"	T1.VLR_CSOCIAL,"										& VbCrlf &_
			"	T1.VLR_IRRF,"											& VbCrlf &_
			"	T1.VLR_IRRF_ACUM,"										& VbCrlf &_
			"	T1.VLR_REDUCAO_ACUM,"									& VbCrlf &_
			"	T1.TOT_IMPOSTO,"										& VbCrlf &_
			"	T1.TOT_IMPOSTO_CLI,"									& VbCrlf &_
			"	T1.TOT_SERVICO,"										& VbCrlf &_
			"	T1.TOT_NF,"												& VbCrlf &_
			"	T1.SITUACAO,"											& VbCrlf &_																			
			"	T1.DT_EMISSAO, "										& VbCrlf &_
			"	T1.ARQUIVO, "											& VbCrlf &_
			"	COUNT(T2.COD_NF) AS TOTAL "								& VbCrlf &_
			" FROM "													& VbCrlf &_
			"	NF_NOTA T1 "											& VbCrlf &_
			" LEFT OUTER JOIN "											& VbCrlf &_
			"	FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_NF = T2.COD_NF) " & VbCrlf &_
			" WHERE"													& VbCrlf &_
			"	T1.SYS_DTT_INATIVO IS NULL "							& VbCrlf

 if strSituacao<>"" then strSQL = strSQL & " AND T1.SITUACAO ='" & strSituacao & "'"	& VbCrlf end if
 if strSerieNF<>"" then strSQL = strSQL & " AND T1.SERIE ='" & strSerieNF & "'" & VbCrlf end if
 if strNumNF<>"" and IsNumeric(strNumNF) then  strSQL = strSQL & " AND T1.NUM_NF='" & strNumNF & "'" & VbCrlf end if
 if strCodCli<>"" then strSQL = strSQL & " AND T1.COD_CLI =" & strCodCli & VbCrlf end if
 if strCodCfgNF<>"" then strSQL = strSQL & " AND T1.COD_CFG_NF =" & strCodCfgNF & VbCrlf end if
' if strCodConta<>"" then strSQL = strSQL & " AND T2.COD_CONTA =" & strCodConta & VbCrlf end if
 
 if (IsDate(strDtIni) and strDtIni<>"") and (IsDate(strDtFim) and strDtFim<>"") then
	strSQL = strSQL & " AND T1.DT_EMISSAO BETWEEN '" & PrepDataBrToUni(strDtIni,false) & "' AND '" & PrepDataBrToUni(strDtFim,false) & "'" & VbCrlf
 end if

 strSQL = strSQL  &_
			" GROUP BY "				& VbCrlf &_
			"	T1.COD_NF,"				& VbCrlf &_
			"	T1.NUM_NF,"				& VbCrlf &_
			"	T1.SERIE,"				& VbCrlf &_
			"	T1.CLI_NOME,"			& VbCrlf &_
			"	T1.OBS_NF,"				& VbCrlf &_
			"	T1.TOT_SERVICO,"		& VbCrlf &_
			"	T1.TOT_NF,"				& VbCrlf &_
			"	T1.TOT_IMPOSTO,"		& VbCrlf &_
			"	T1.SITUACAO,"			& VbCrlf &_																			
			"	T1.DT_EMISSAO,"			& VbCrlf &_
			"	T1.ARQUIVO"				& VbCrlf &_
			"ORDER BY"				    & VbCrlf &_
			"	T1.DT_EMISSAO, T1.SITUACAO, T1.NUM_NF "


 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 if not objRS.eof then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort... class="sortable-date-dmy" / class="sortable-currency" / class="sortable-numeric" / class="sortable" -->
 <thead>
   <tr> 		
		<th></th>
        <th width="01%" class="sortable-numeric" nowrap>N.NF</th>
        <th width="01%" class="sortable-date-dmy" nowrap>Dt Emissão</th>
        <th width="01%" class="sortable">S&eacute;rie</th>
        <th width="40%" class="sortable">Cliente</th>
        <th width="01%" class="sortable-currency" nowrap>CNPJ</th>
        <th width="01%" class="sortable-currency" nowrap>ISSQN</th>
        <th width="01%" class="sortable-currency" nowrap>IRPJ</th>
        <th width="04%" class="sortable-currency" nowrap>COFINS</th>
        <th width="04%" class="sortable-currency" nowrap>PIS</th>
        <th width="05%" class="sortable-currency" nowrap>CSSS</th>
        <th width="05%" class="sortable-currency" nowrap>IRRF</th>
        <th width="05%" class="sortable-currency" nowrap>IRRF Ac</th>
        <th width="05%" class="sortable-currency" nowrap>Reducao Ac</th>
        <th width="05%" class="sortable-currency" nowrap>Total Imp. Cli</th>
        <th width="05%" class="sortable-currency" nowrap>Total Imp.</th>
        <th width="05%" class="sortable-currency" nowrap>Total Servi&ccedil;o</th>
        <th width="05%" class="sortable-currency" nowrap>Total NF</th>
        <th width="05%" class="sortable">Situa&ccedil;&atilde;o</th>			
	</tr>
  </thead>
 <tbody style="text-align:left;">
<% 
     While Not objRs.Eof
	   strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
	%>	
		<td></td>
        <td align="right" nowrap><%=GetValue(objRS,"NUM_NF")%></td>
        <td nowrap><%=PrepData(GetValue(objRS,"DT_EMISSAO"),true,false)%></td>
		<td nowrap><%=GetValue(objRS,"SERIE")%></td>
		<td align="left"><%=GetValue(objRS,"CLI_NOME")%></td>
		<td align="left" style="mso-number-format:'\@'"><%=RetNumbers(GetValue(objRS,"CLI_NUM_DOC"))%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VLR_ISSQN"),2)%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VLR_IRPJ"),2)%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VLR_COFINS"),2)%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VLR_PIS"),2)%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VLR_CSOCIAL"),2)%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VLR_IRRF"),2)%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VLR_IRRF_ACUM"),2)%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VLR_REDUCAO_ACUM"),2)%></td>
        <td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"TOT_IMPOSTO_CLI"),2)%></td>
		<td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"TOT_IMPOSTO"),2)%></td>
		<td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"TOT_SERVICO"),2)%></td>
		<td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"TOT_NF"),2)%></td>
		<td nowrap>
			<%
                If GetValue(objRS,"SITUACAO") = "EM_EDICAO"   Then Response.Write("Em Edição")
                If GetValue(objRS,"SITUACAO") = "NAO_EMITIDA" Then Response.Write("Não Emitida")
                If GetValue(objRS,"SITUACAO") = "EMITIDA"     Then Response.Write("Emitida")
                If GetValue(objRS,"SITUACAO") = "CANCELADA"   Then Response.Write("Cancelada")
            %>
        </td>		
	</tr>
	<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend
		FechaRecordSet objRS
	%>
  </tbody>
</table>
</body>
</html>
<%
else
	Mensagem strAviso, "", "", true
end if
FechaDBConn objConn
%>