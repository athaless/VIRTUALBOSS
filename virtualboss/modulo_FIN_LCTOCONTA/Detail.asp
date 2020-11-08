<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, objRSa, strSQL
Dim strCOD_CONTA, strVLR_LCTO, strENTIDADE
		
strCOD_CONTA   = GetParam("var_chavereg")
	
if strCOD_CONTA <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" &_	
				"	LCTO.COD_LCTO_EM_CONTA,"	&_	
				"	LCTO.OPERACAO,"&_	
				"	LCTO.CODIGO,"	&_	
				"	LCTO.TIPO,"		&_	
				"	PLAN.COD_REDUZIDO,"	&_
				"	CTA.NOME,"		&_
				"	PLAN.NOME AS PLANO_CONTA,"	&_	
				"	CUST.NOME AS CENTRO_CUSTO,"&_	
				"	LCTO.HISTORICO,"	&_
				"	LCTO.OBS,"		&_					
				"	LCTO.NUM_LCTO,"	&_	
				"	LCTO.VLR_LCTO,"	&_		
				"	LCTO.DT_LCTO "		&_	
				"FROM ((("	&_	
				"	FIN_LCTO_EM_CONTA LCTO "	&_	
				"LEFT OUTER JOIN"		&_	
				"	FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA = LCTO.COD_PLANO_CONTA)) "	&_	
				"LEFT OUTER JOIN"		&_	
				"	FIN_CENTRO_CUSTO CUST ON (CUST.COD_CENTRO_CUSTO = LCTO.COD_CENTRO_CUSTO)) "	&_	
				"LEFT OUTER JOIN"		&_	
				"	FIN_CONTA CTA ON (LCTO.COD_CONTA=CTA.COD_CONTA )) "	&_	
				"WHERE"		&_	
				"	LCTO.COD_LCTO_EM_CONTA=" & strCOD_CONTA	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
		if GetValue(objRS,"VLR_LCTO")<>"" then strVLR_LCTO = FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)
		strSQL=""					 
		if GetValue(objRS, "TIPO")="ENT_CLIENTE"     and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE		WHERE COD_CLIENTE     =" & GetValue(objRS,"CODIGO")
		if GetValue(objRS, "TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR  =" & GetValue(objRS,"CODIGO")
		if GetValue(objRS, "TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME                  FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & GetValue(objRS,"CODIGO")
	
		strENTIDADE=""
		if strSQL<>"" then 
			Set objRSa = objConn.Execute(strSQL)
			if not objRSa.Eof then strENTIDADE = GetValue(objRSa, "NOME")
			FechaRecordSet objRSa
		end if 
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
</head>
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
  <tr><td align="right">Código:&nbsp;</td><td><%=strCOD_CONTA%></td></tr>
  <tr><td align="right">Operação:&nbsp;</td><td><%=GetValue(objRS,"OPERACAO")%></td></tr>
  <tr><td align="right">Entidade:&nbsp;</td><td><%=strENTIDADE%></td></tr>
  <tr><td align="right">Histórico:&nbsp;</td><td><%=GetValue(objRS,"HISTORICO")%></td></tr>
  <tr><td align="right">Conta:&nbsp;</td><td><%=GetValue(objRS,"NOME")%></td></tr>    
  <tr><td align="right">Plano de Conta:&nbsp;</td><td><%=GetValue(objRS,"COD_REDUZIDO")%>&nbsp;&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td></tr>
  <tr><td align="right">Centro de Custo:&nbsp;</td><td><%=GetValue(objRS,"CENTRO_CUSTO")%></td></tr>    
  <tr><td align="right">Número:&nbsp;</td><td><%=GetValue(objRS,"NUM_LCTO")%></td></tr>  
  <tr><td align="right">Valor:&nbsp;</td><td><%=strVLR_LCTO%></td></tr>
  <tr><td align="right">Data:&nbsp;</td><td><%=PrepData(GetValue(objRS,"DT_LCTO"),true,false)%></td></tr>
  <tr id="tableheader_last_row"><td align="right">Observação:&nbsp;</td><td><%=GetValue(objRS,"OBS")%></td></tr>
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