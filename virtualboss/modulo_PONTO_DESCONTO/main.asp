<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PONTO_DESCONTO", Request.Cookies("VBOSS")("ID_USUARIO")), true 

  Dim objConn, objRS, strSQL
  Dim strANO, strCOLOR

  AbreDBConn objConn, CFG_DB 

  strANO = GetParam("var_ano")

  strSQL =          " SELECT COD_DESCONTO, ID_USUARIO, MES, ANO, TOTAL_HR, TOTAL_MIN, OBS "
  strSQL = strSQL & " FROM PT_DESCONTO "
  strSQL = strSQL & " WHERE COD_DESCONTO > 0 "
  
  If strANO <> "" Then strSQL = strSQL & " AND ANO = " & strANO
  
  strSQL = strSQL & " ORDER BY ID_USUARIO, ANO, MES "

  Set objRS = objConn.Execute(strSQL) 
  
If Not objRS.EOF Then
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
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%"></th>
	<th width="15%" class="sortable">Usuário</th>
    <th width="10%" class="sortable" nowrap>Mês</th>
	<th width="10%" class="sortable" nowrap>Ano</th>
    <th width="10%" class="sortable" nowrap>Total</th>
    <th width="52%" class="sortable">Obs</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRS.Eof
  	    strCOLOR = swapString(strCOLOR, "#F5FAFA", "#FFFFFF")
	%>
  <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_DESCONTO","Delete.asp",GetValue(objRS,"COD_DESCONTO"),"IconAction_DEL.gif","REMOVER")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_DESCONTO","Update.asp",GetValue(objRS,"COD_DESCONTO"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_DESCONTO","Detail.asp",GetValue(objRS,"COD_DESCONTO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
    <td align="left" valign="top"><div><%=GetValue(objRS,"ID_USUARIO")%></td>
    <td align="left" valign="top" nowrap><%=MesExtenso(GetValue(objRS,"MES"))%></td>
    <td align="left" valign="top" nowrap><%=GetValue(objRS,"ANO")%></td>
    <td align="left" valign="top" nowrap><%=GetValue(objRS,"TOTAL_HR")%>:<%=GetValue(objRS,"TOTAL_MIN")%></td>
    <td align="left" valign="top"><%=GetValue(objRS,"OBS")%></td>
  </tr>
  <%
        athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
      Wend
%>
  </tbody>  
</table>
</body>
</html>
<%
	FechaRecordSet ObjRS
else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
end if
FechaDBConn objConn
%>