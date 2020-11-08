<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim strCOD_CONTA
		
strCOD_CONTA = GetParam("var_chavereg")
	
if strCOD_CONTA <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" &_	
				"	COD_LCTO_TRANSF,"	&_
				"	T2.NOME AS CONTA_ORIG," &_
				"	T3.NOME AS CONTA_DEST," &_
				"	HISTORICO,"	&_
				"	OBS,"	&_
				"	NUM_LCTO,"	&_
				"	VLR_LCTO,"	&_
				"	DT_LCTO "	&_
				"FROM" 	&_
				"	FIN_LCTO_TRANSF," &_
				"	FIN_CONTA AS T2," &_
				"	FIN_CONTA AS T3 "	&_
				"WHERE" 	&_	
				"	COD_CONTA_ORIG = T2.COD_CONTA AND COD_CONTA_DEST = T3.COD_CONTA AND"	&_
				"	COD_LCTO_TRANSF=" & strCOD_CONTA
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
%>
<html>
<head>
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
      <th width="150"></th>
      <th>Dados</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
  <tr><td align="right">Código:&nbsp;</td>		<td><%=strCOD_CONTA%></td></tr>
  <tr><td align="right">Origem:&nbsp;</td>		<td><%=GetValue(objRS,"CONTA_ORIG")%></td></tr>
  <tr><td align="right">Destino:&nbsp;</td>		<td><%=GetValue(objRS,"CONTA_DEST")%></td></tr>
  <tr><td align="right">Histórico:&nbsp;</td>	<td><%=GetValue(objRS,"HISTORICO")%></td></tr>
  <tr><td align="right">Número:&nbsp;</td>		<td><%=GetValue(objRS,"NUM_LCTO")%></td></tr>  
  <tr><td align="right">Valor:&nbsp;</td>		<td><%=FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)%></td></tr>
  <tr><td align="right">Observação:&nbsp;</td>	<td><%=GetValue(objRS,"OBS")%></td></tr>
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