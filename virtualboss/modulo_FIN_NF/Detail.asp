<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL
 Dim strCOD_NF, strSALDO_INI, strSALDO
 Dim strCOLOR

 strCOD_NF = GetParam("var_chavereg")
	
 if strCOD_NF<>"" then
	AbreDBConn objConn, CFG_DB
	
	strSQL = "SELECT"							&_
				"	NF.COD_NF,"					&_
				"	NF.NUM_NF,"					&_
				"	NF.SERIE,"					&_
				"	NF.COD_CLI,"				&_
				"	NF.CLI_NOME,"				&_			
				"	NF.CLI_ENDER,"				&_			
				"	NF.CLI_NUM_DOC,"			&_			
				"	NF.CLI_INSC_ESTADUAL,"		&_			
				"	NF.CLI_CEP,"				&_															
				"	NF.CLI_BAIRRO,"				&_															
				"	NF.CLI_CIDADE,"				&_															
				"	NF.CLI_ESTADO,"				&_															
				"	NF.CLI_FONE,"				&_
                " 	CL.EMAIL AS CLI_EMAIL,"	    &_
				"	NF.OBS_NF,"			     	&_
				"	NF.COD_CONTRATO,"			&_
				"	NF.NUM_CONTRATO,"			&_
				"	NF.OBS_CONTRATO,"			&_
				"	NF.TOT_SERVICO,"			&_
				"	NF.TOT_NF,"				    &_
				"	NF.TOT_IMPOSTO,"			&_
				"	NF.TOT_IMPOSTO_CLI,"		&_			
				"	NF.VLR_ISSQN,"				&_			
				"	NF.VLR_IRPJ,"				&_			
				"	NF.VLR_COFINS,"			    &_			
				"	NF.VLR_PIS,"				&_			
				"	NF.VLR_CSOCIAL,"			&_			
				"	NF.VLR_IRRF,"				&_																					
				"	NF.VLR_COMISSAO,"			&_
				"	NF.SITUACAO,"				&_																			
				"	NF.DT_EMISSAO, "			&_
				"   NF.PRZ_VCTO "				&_
				"FROM NF_NOTA NF "	    	    &_
				"LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = NF.COD_CLI) " &_
				"WHERE SYS_DTT_INATIVO IS NULL AND COD_NF="	& strCOD_NF	
	'athDebug strSQL, true			
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
	<tr>
      <th width="150"></th>
      <th>Dados</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
<tr><td align="right">Cod.:&nbsp;</td><td><%=strCOD_NF%></td></tr>
	<tr><td align="right">Num. NF:&nbsp;</td><td><%=GetValue(objRS,"NUM_NF")%></td></tr>
	<tr><td align="right">S&eacute;rie:&nbsp;</td><td><%=GetValue(objRS,"SERIE")%></td></tr>
	<tr><td colspan="2" height="7px"></td></tr>
    <!-- ------------------------- Dados do Cliente ------------------------- -->
	<tr><td align="right">Cliente:&nbsp;</td><td><%=GetValue(objRS,"COD_CLI")%>&nbsp;-&nbsp;<%=GetValue(objRS,"CLI_NOME")%></td></tr>
	<tr><td align="right">Endere&ccedil;o:&nbsp;</td><td><%=GetValue(objRS,"CLI_ENDER")%></td></tr>
	<tr><td align="right">Bairro:&nbsp;</td><td><%=GetValue(objRS,"CLI_BAIRRO")%></td></tr>
	<tr><td align="right">Cidade:&nbsp;</td><td><%=GetValue(objRS,"CLI_CIDADE")%></td></tr>
	<tr><td align="right">Estado:&nbsp;</td><td><%=GetValue(objRS,"CLI_ESTADO")%></td></tr>
	<tr><td align="right">CEP:&nbsp;</td><td><%=GetValue(objRS,"CLI_CEP")%></td></tr>
	<tr><td align="right">Fone:&nbsp;</td><td><%=GetValue(objRS,"CLI_FONE")%></td></tr>
	<tr><td align="right">E-mail:&nbsp;</td><td><%=GetValue(objRS,"CLI_EMAIL")%></td></tr>	
	<tr><td colspan="2" height="7px"></td></tr>
    <!-- ------------------------- Dados do Contrato ------------------------- -->
	<tr><td align="right">N&deg;. Doc.:&nbsp;</td><td><%=GetValue(objRS,"CLI_NUM_DOC")%></td></tr>
	<tr><td align="right">Cod. Contrato:&nbsp;</td><td><%=GetValue(objRS,"COD_CONTRATO")%></td></tr>
	<tr><td align="right">N&deg;. Contrato:&nbsp;</td><td><%=GetValue(objRS,"NUM_CONTRATO")%></td></tr>
	<tr><td align="right">Observa&ccedil;&atilde;o:&nbsp;</td><td><%=GetValue(objRS,"OBS_CONTRATO")%></td></tr>
	<tr><td colspan="2" height="7px"></td></tr>
    <!-- ------------------------- Valores da Nota ------------------------- -->
	<tr><td align="right">Total Servi&ccedil;o:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"TOT_SERVICO"),2)%></td></tr>
	<tr><td align="right">Total NF:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"TOT_NF"),2)%></td></tr>
	<tr><td align="right">Total Imposto:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"TOT_IMPOSTO"),2)%></td></tr>
	<tr><td align="right">Total Imposto - Cliente:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"TOT_IMPOSTO_CLI"),2)%></td></tr>
	<tr><td align="right">Valor ISSQN:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"VLR_ISSQN"),2)%></td></tr>
	<tr><td align="right">Valor IRRF:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"VLR_IRRF"),2)%></td></tr>
	<tr><td align="right">Valor IRPJ:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"VLR_IRPJ"),2)%></td></tr>
	<tr><td align="right">Valor PIS:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"VLR_PIS"),2)%></td></tr>
	<tr><td align="right">Valor COFINS:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"VLR_COFINS"),2)%></td></tr>
	<tr><td align="right">Valor Contr. Social:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"VLR_CSOCIAL"),2)%></td></tr>
	<tr><td align="right">Valor Comissão:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"VLR_COMISSAO"),2)%></td></tr>
	<tr><td colspan="2" height="7px"></td></tr>
    <!-- ------------------------- Informações da Nota ------------------------- -->
	<tr><td align="right">Situa&ccedil;&atilde;o:&nbsp;</td><td>
	<%
	If GetValue(objRS,"SITUACAO") = "EM_EDICAO"   Then Response.Write("Em Edição")
	If GetValue(objRS,"SITUACAO") = "NAO_EMITIDA" Then Response.Write("Não Emitida")
	If GetValue(objRS,"SITUACAO") = "EMITIDA"     Then Response.Write("Emitida")
	If GetValue(objRS,"SITUACAO") = "CANCELADA"   Then Response.Write("Cancelada")
	%>
	</td></tr>
	<tr><td align="right">Data Emiss&atilde;o:&nbsp;</td><td><%=PrepData(GetValue(objRS,"DT_EMISSAO"),true,false)%></td></tr>
	<tr><td align="right">Prz Vcto:&nbsp;</td><td><%=GetValue(objRS,"PRZ_VCTO")%></td></tr>
	<tr id="tableheader_last_row"><td align="right">Observa&ccedil;&atilde;o:&nbsp;</td><td><%=GetValue(objRS,"OBS_NF")%></td></tr>	
  </tbody>
</table>
<%
		FechaRecordSet objRS
		
		strSQL = " SELECT"				&_
					"	COD_NF,"		&_
					"	COD_SERVICO,"	&_
					"	TIT_SERVICO,"	&_
					"	DESC_SERVICO,"	&_
					"	DESC_EXTRA,"	&_
					"	OBS_SERVICO,"	&_
					"	VALOR_ORIG,"	&_
					"	VALOR "			&_
					" FROM"				&_
					"	NF_ITEM"		&_
					" WHERE COD_NF=" & strCOD_NF
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRS.eof then
%>
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
		<th width="01%" class="sortable-numeric" nowrap>Cod.&nbsp;NF</th>
		<th width="22%" class="sortable">Servi&ccedil;o</th>
		<th width="21%" class="sortable">Descri&ccedil;&atilde;o</th>
		<th width="21%" class="sortable">Extra</th>
		<th width="33%" class="sortable">Observa&ccedil;&atilde;o</th>
		<th width="01%" class="sortable-currency" nowrap>Valor Original</th>
		<th width="01%" class="sortable-currency">Valor</th>		
	</tr>
  </thead>
 <tbody style="text-align:left;">
	<% 
	
     While Not objRS.Eof
        strCOLOR = swapString(strCOLOR, "#FFFFFF", "#F5FAFA")
	%>
		<tr bgcolor=<%=strCOLOR%>>
			<td nowrap><%=GetValue(objRS,"COD_NF")%></td>		
			<td><%=GetValue(objRS,"COD_SERVICO")%>&nbsp;-&nbsp;<%=GetValue(objRS,"TIT_SERVICO")%></td>		
			<td><%=GetValue(objRS,"DESC_SERVICO")%></td>		
			<td><%=GetValue(objRS,"DESC_EXTRA")%></td>		
			<td><%=GetValue(objRS,"OBS_SERVICO")%></td>		
			<td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VALOR_ORIG"),2)%></td>
			<td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VALOR"),2)%></td>		
		</tr>
	<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend
	end if
	FechaRecordSet objRS
	%>
 </tbody>
</table>
</body>
</html>
<%
	end if 
	FechaDBConn objConn
end if 
%>