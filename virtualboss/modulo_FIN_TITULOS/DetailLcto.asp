<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, objRSa, strSQL
Dim strCOD_LCTO_ORDINARIO 
Dim strENTIDADE
		
strCOD_LCTO_ORDINARIO = GetParam("var_chavereg")

if strCOD_LCTO_ORDINARIO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" 		&_	
				"	ORD.COD_LCTO_ORDINARIO," 	&_
				"	ORD.COD_CONTA_PAGAR_RECEBER," &_
				"	ORD.TIPO,"	&_
				"	ORD.CODIGO,"	&_
				"	ORD.COD_CONTA,"		&_
				"	CTA.NOME AS CONTA,"	&_
				"	ORD.COD_PLANO_CONTA,"&_
				"	PLN.NOME AS PLANO_CONTA,"	&_
				"	ORD.COD_CENTRO_CUSTO,"		&_
				"	CTO.NOME AS CENTRO_CUSTO,"	&_
				"	ORD.HISTORICO,"		&_
				"	ORD.NUM_LCTO,"			&_
				"	ORD.DT_LCTO,"			&_
				"	ORD.VLR_ORIG,"			&_
				"	ORD.VLR_MULTA,"		&_
				"	ORD.VLR_JUROS,"		&_
				"	ORD.VLR_DESC,"			&_
				"	ORD.VLR_LCTO,"			&_
				"	ORD.OBS "	&_
				"FROM "		&_
				"	FIN_LCTO_ORDINARIO ORD "	&_
				"INNER JOIN"	&_
				"	FIN_CONTA CTA ON (ORD.COD_CONTA=CTA.COD_CONTA) "	&_
				"INNER JOIN"	&_
				"	FIN_PLANO_CONTA PLN ON (ORD.COD_PLANO_CONTA=PLN.COD_PLANO_CONTA) "	&_
				"INNER JOIN"	&_
				"	FIN_CENTRO_CUSTO CTO ON (ORD.COD_CENTRO_CUSTO=CTO.COD_CENTRO_CUSTO) "	&_
				"WHERE"			&_
				"	ORD.COD_LCTO_ORDINARIO=" & strCOD_LCTO_ORDINARIO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then
		strSQL=""					 
		if GetValue(objRS,"TIPO")="ENT_CLIENTE"	    then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE	 WHERE COD_CLIENTE     =" & GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO")="ENT_FORNECEDOR"  then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR	 WHERE COD_FORNECEDOR  =" & GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO")="ENT_COLABORADOR" then strSQL = "SELECT NOME                  FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & GetValue(objRS,"CODIGO")

		strENTIDADE=""
		if strSQL<>"" then
			AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
			if not objRSa.Eof then strENTIDADE = GetValue(objRSa, "NOME")
			FechaRecordSet objRSa
		end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" class="tablesort">
 <thead> 
	<tr>
      <th width="150"></th>
      <th>Dados</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
	<tr><td align="right">Código:&nbsp;</td><td><%=strCOD_LCTO_ORDINARIO%></td></tr>
	<tr><td align="right" nowrap>Conta a Pagar e Receber:&nbsp;</td><td><%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%></td></tr>	
	<tr><td align="right">Conta:&nbsp;</td><td><%=GetValue(objRS,"CONTA")%></td></tr>    	
	<tr><td align="right">Entidade:&nbsp;</td><td><%=strENTIDADE%></td></tr>
	<tr><td align="right">Plano de Conta:&nbsp;</td><td><%=GetValue(objRS,"PLANO_CONTA")%></td></tr>
	<tr><td align="right">Centro de Custo:&nbsp;</td><td><%=GetValue(objRS,"CENTRO_CUSTO")%></td></tr>    
	<tr><td align="right">Número:&nbsp;</td><td><%=GetValue(objRS,"NUM_LCTO")%></td></tr>    
	<tr><td align="right">Data:&nbsp;</td><td><%=PrepData(GetValue(objRS,"DT_LCTO"), True, False)%></td></tr>
	<tr><td align="right">Histórico:&nbsp;</td><td><%=GetValue(objRS,"HISTORICO")%></td></tr>
	<tr><td align="right">Observação:&nbsp;</td><td><%=GetValue(objRS,"OBS")%></td></tr>
	<tr><td align="right">Valor Original:&nbsp;</td><td align="left"><%=FormataDecimal(GetValue(objRS,"VLR_ORIG"),2)%></td></tr>
	<tr><td align="right">Valor Multa:&nbsp;</td><td align="left"><%=FormataDecimal(GetValue(objRS,"VLR_MULTA"),2)%></td></tr>
	<tr><td align="right">Valor Juros:&nbsp;</td><td align="left"><%=FormataDecimal(GetValue(objRS,"VLR_JUROS"),2)%></td></tr>
	<tr><td align="right">Valor Desconto:&nbsp;</td><td align="left"><%=FormataDecimal(GetValue(objRS,"VLR_DESC"),2)%></td></tr>
	<tr><td align="right">Valor Lançamento:&nbsp;</td><td align="left"><%=FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)%></td></tr>
 </tbody>
</table>
</body>
</html>
<%
	end if	 
	FechaRecordSet objRS
	FechaDBConn objConn
end if 
%>