<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_BOLETO", Request.Cookies("VBOSS")("ID_USUARIO")), true 

 Dim objConn, objRS, strSQL
 Dim strAviso
 Dim strSITUACAO, strDESCRICAO
 Dim strCOLOR
	

 strAviso = "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
 strColor = "#DAEEFA"

 strSITUACAO  = GetParam("var_situacao")
 strDESCRICAO = GetParam("var_descricao")

	AbreDBConn objConn, CFG_DB
	
	strSQL = "SELECT"						&_
				"	COD_CFG_BOLETO,"		&_
				"	DESCRICAO,"				&_
				"	CEDENTE_CNPJ,"			&_
				"	CEDENTE_NOME,"			&_
				"	CEDENTE_AGENCIA,"		&_
				"	CEDENTE_CODIGO,"		&_
				"	CEDENTE_CODIGO_DV,"		&_
				"	COD_CLIENTE,"			&_				
				"	BANCO_CODIGO,"			&_
				"	BANCO_DV,"				&_
				"	BOLETO_CARTEIRA "		&_
				"FROM"						&_
				"	CFG_BOLETO "			&_
				"WHERE COD_CFG_BOLETO > 0 " 
	if strSITUACAO="ATIVO"   then strSITUACAO = " AND DT_INATIVO NULL " 
	if strSITUACAO="INATIVO" then strSITUACAO = " AND DT_INATIVO NOT NULL " 
	if strDESCRICAO<>"" then strSQL = strSQL & " AND DESCRICAO LIKE '" & strDESCRICAO & "%' "
	strSQL = strSQL	& " ORDER BY DESCRICAO"
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr> 
	<th width="1%"></th>
	<th width="1%"></th>
	<th width="20%" class="sortable">Descri&ccedil;&atilde;o</th>
	<th width="30%" class="sortable">Cedente</th>
	<th width="13%"  class="sortable">CNPJ</th>
	<th width="7%"  class="sortable">Agência</th>
	<th width="7%"  class="sortable">Conta</th>
	<th width="7%"  class="sortable">Carteira</th>
	<th width="7%"  nowrap>Cod. Banco</th>
	<th width="7%"  nowrap>Cod. Cliente</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
 <% 
      While Not objRs.Eof
  	    strCOLOR = swapString(strCOLOR,"#FFFFFF","#F5FAFA")
 %>
	<tr bgcolor=<%=strCOLOR%>> 
		<td><%=MontaLinkGrade("modulo_FIN_BOLETO","Delete.asp",GetValue(objRS,"COD_CFG_BOLETO"),"IconAction_DEL.gif","REMOVER")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_BOLETO","Update.asp",GetValue(objRS,"COD_CFG_BOLETO"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td nowrap><%=GetValue(objRS,"DESCRICAO")%></td>
		<td nowrap><%=GetValue(objRS,"CEDENTE_NOME")%></td>
		<td nowrap><%=GetValue(objRS,"CEDENTE_CNPJ")%></td>
		<td><%=GetValue(objRS,"CEDENTE_AGENCIA")%></td>
		<td nowrap><%=GetValue(objRS,"CEDENTE_CODIGO")%>&nbsp;-&nbsp;<%=GetValue(objRS,"CEDENTE_CODIGO_DV")%></td>
		<td><%=GetValue(objRS,"BOLETO_CARTEIRA")%></td>
		<td nowrap><%=GetValue(objRS,"BANCO_CODIGO")%>&nbsp;-&nbsp;<%=GetValue(objRS,"BANCO_DV")%></td>
		<td><%=GetValue(objRS,"COD_CLIENTE")%></td>
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