<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_CATEGORIAS", Request.Cookies("VBOSS")("ID_USUARIO")), true

 Dim objConn, objRS, objRSa, strSQL
 Dim strLETRA, strTABELA, strCOLOR

 strTABELA = GetParam("var_tabela")
 strLETRA = GetParam("var_letra")

 if strTABELA<>"" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL = "SELECT COD_CATEGORIA, NOME, DESCRICAO FROM " & strTABELA & "CATEGORIA "
	if strLETRA <> "" then strSQL = strSQL & " WHERE NOME LIKE '" & strLETRA & "%' "
	strSQL = strSQL & " ORDER BY 2 "
	
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
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%" class="sortable" nowrap>Cod</th>
	<th width="48" class="sortable" nowrap>Nome</th>
    <th width="49%" class="sortable" nowrap>Descrição</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRS.Eof
        strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
	%>
	<tr bgcolor="<%=strCOLOR%>" valign="middle">
		<td width="1%"><%=MontaLinkGrade("modulo_CATEGORIAS","Delete.asp",GetValue(objRS,"COD_CATEGORIA") & "&var_table=" & strTABELA,"IconAction_DEL.gif","REMOVER")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_CATEGORIAS","Update.asp",GetValue(objRS,"COD_CATEGORIA") & "&var_table=" & strTABELA,"IconAction_EDIT.gif","ALTERAR")%></td>
		<td nowrap><%=GetValue(objRS,"COD_CATEGORIA")%></td>
		<td><%=GetValue(objRS,"NOME")%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>		
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
else
	Mensagem "É necessário escolher uma tabela para realizar uma consulta.", "", "", True
end if
%>