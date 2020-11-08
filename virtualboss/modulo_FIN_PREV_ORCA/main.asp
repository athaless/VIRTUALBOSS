<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_PREV_ORCA", Request.Cookies("VBOSS")("ID_USUARIO")), true  %>
 <!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, objRSa, strSQL
 Dim strSITUACAO, strCOLOR

 AbreDBConn objConn, CFG_DB 

 strSITUACAO = GetParam("var_situacao")

 ' Previsões do mês atual até o fim do ano corrente
 strSQL = "SELECT COD_PREV_ORCA, DESCRICAO, DT_PREV_INI, DT_PREV_FIM FROM FIN_PREV_ORCA WHERE 1=1"

 if strSITUACAO="VIGENTES" then
	strSQL = strSQL & " AND DT_PREV_FIM >= '" & PrepDataBrToUni(Date,false) & "'"
 elseif InStr(strSITUACAO,"_")>0 then
	strSQL = strSQL & " AND DT_PREV_FIM <= '" & PrepDataBrToUni(Date,false) & "'"
 end if

 strSQL = strSQL &	" ORDER BY DT_PREV_INI, DT_PREV_FIM"
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

if not objRS.eof then
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
    <th width="01%"></th>
    <th width="01%"></th>
    <th width="01%"></th>
    <th width="05%" class="sortable-numeric" nowrap>Cod</th>
    <th width="05%" class="sortable-date-dmy" nowrap>Data Início</th>
    <th width="05%" class="sortable-date-dmy" nowrap>Data Fim</th>
    <th width="72%" class="sortable">Descrição</th>
    <th width="10%" class="sortable-currency">Total</th>
  </thead>
 <tbody style="text-align:left;">
<% 
      While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
		
		strSQL = "SELECT SUM(ORCA.VALOR) AS TOTAL FROM FIN_PLANO_PREV_ORCA ORCA "	&_
				 "  LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA=ORCA.COD_PLANO_CONTA) " &_
				 " WHERE PLAN.COD_PLANO_CONTA_PAI IS NULL AND ORCA.COD_PREV_ORCA=" & GetValue(objRS,"COD_PREV_ORCA")
		AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	%>	
	<tr bgcolor=<%=strCOLOR%>>
		<td><%=MontaLinkGrade("modulo_FIN_PREV_ORCA","Delete.asp",GetValue(objRS,"COD_PREV_ORCA"),"IconAction_DEL.gif","REMOVER")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_PREV_ORCA","Update.asp",GetValue(objRS,"COD_PREV_ORCA"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_PREV_ORCA","InsertPrev.asp",GetValue(objRS,"COD_PREV_ORCA"),"IconAction_DETAILADD.gif","")%></td>						
		<td><%=GetValue(objRS,"COD_PREV_ORCA")%></td>
		<td align="right" nowrap><%=PrepData(GetValue(objRS,"DT_PREV_INI"),true,false)%></td>
		<td align="right" nowrap><%=PrepData(GetValue(objRS,"DT_PREV_FIM"),true,false)%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>
		<td align="right" nowrap><%=FormataDecimal(GetValue(objRSa,"TOTAL"),2)%></td>
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
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
end if

FechaRecordSet objRS
FechaDBConn objConn
%>