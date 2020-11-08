<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_NF_CFG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL
 Dim strAviso, strCOLOR
 Dim strDescricao, strSerieNF

 strAviso = "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."

 strDescricao = GetParam("var_descr")
 strSerieNF	  = GetParam("var_num_snf")

	AbreDBConn objConn, CFG_DB

	strSQL = "SELECT"					& VbCrlf &_
				"	COD_CFG_NF,"		& VbCrlf &_
				"	SERIE,"				& VbCrlf &_
				"	MODELO_HTML,"		& VbCrlf &_
				"	ULT_NUM_NF,"		& VbCrlf &_
				"	DESCRICAO,"			& VbCrlf &_
				"	ALIQ_ISSQN,"		& VbCrlf &_
				"	ALIQ_IRRF,"			& VbCrlf &_
				"	ALIQ_IRPJ,"			& VbCrlf &_
				"	ALIQ_COFINS,"		& VbCrlf &_
				"	ALIQ_PIS,"			& VbCrlf &_
				"	ALIQ_CSOCIAL,"		& VbCrlf &_
				"	ORDEM,"				& VbCrlf &_																			
				"	DT_INATIVO "		& VbCrlf &_
				"FROM"					& VbCrlf &_
				"	CFG_NF "			& VbCrlf &_
				"WHERE"					& VbCrlf &_
				"	COD_CFG_NF IS NOT NULL "
				
	if strDescricao<>"" then strSQL = strSQL & " AND DESCRICAO LIKE '%" & strDescricao & "%'"
	if strSerieNF <> "" then strSQL = strSQL & " AND SERIE LIKE '%" & strSerieNF & "%' OR ULT_NUM_NF=" & strSerieNF & " "
	
	strSQL = strSQL	& "ORDER BY ORDEM"
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
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
    <th width="01%"></td>
    <th width="01%"></td>
    <th width="22%" class="sortable">S&eacute;rie</th>
    <th width="22%" class="sortable">Gerador</th>
    <th width="44%" class="sortable">Descri&ccedil;&atilde;o</th>
    <th width="01%" class="sortable" nowrap>&Uacute;ltima NF</th>
    <th width="01%" class="sortable-currency">ISSQN</th>
    <th width="01%" class="sortable-currency">IRRF</th>
    <th width="01%" class="sortable-currency">IRPJ</th>
    <th width="01%" class="sortable-currency">PIS</th>
    <th width="01%" class="sortable-currency">COFINS</th>
    <th width="01%" class="sortable-currency" nowrap>Contr. Social</th>
    <th width="01%" class="sortable-date-dmy" nowrap>Data Inativo</th>
    <th width="01%" class="sortable-numeric">Ordem</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<% 
      While Not objRs.Eof
	  	strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
	%>
	<tr bgcolor=<%=strColor%>>
		<td><%=MontaLinkGrade("modulo_FIN_NF_CFG","Delete.asp",GetValue(objRS,"COD_CFG_NF"),"IconAction_DEL.gif","REMOVER")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_NF_CFG","Update.asp",GetValue(objRS,"COD_CFG_NF"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td nowrap><%=GetValue(objRS,"SERIE")%></td>
		<td><%=GetValue(objRS,"MODELO_HTML")%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>
		<td style="text-align:right" nowrap><b><%=GetValue(objRS,"ULT_NUM_NF")%></b></td>
		<td style="text-align:right" nowrap><%=FormataDecimal(GetValue(objRS,"ALIQ_ISSQN"),2)%>&nbsp;%</td>
		<td style="text-align:right" nowrap><%=FormataDecimal(GetValue(objRS,"ALIQ_IRRF"),2)%>&nbsp;%</td>
		<td style="text-align:right" nowrap><%=FormataDecimal(GetValue(objRS,"ALIQ_IRPJ"),2)%>&nbsp;%</td>
		<td style="text-align:right" nowrap><%=FormataDecimal(GetValue(objRS,"ALIQ_PIS"),2)%>&nbsp;%</td>
		<td style="text-align:right" nowrap><%=FormataDecimal(GetValue(objRS,"ALIQ_COFINS"),2)%>&nbsp;%</td>
		<td style="text-align:right" nowrap><%=FormataDecimal(GetValue(objRS,"ALIQ_CSOCIAL"),2)%>&nbsp;%</td>
		<td style="text-align:right"><%=PrepData(GetValue(objRS,"DT_INATIVO"),true,false)%></td>
		<td style="text-align:right" nowrap><%=GetValue(objRS,"ORDEM")%></td>
	</tr>
	<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend
	%>
 </tbody>
</table>
</body>
</html>
<%
	else
		Mensagem strAviso, "", "", true
	end if
	
	FechaRecordSet objRS
	FechaDBConn objConn
%>