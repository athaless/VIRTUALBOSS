<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FORNECEDOR", Request.Cookies("VBOSS")("ID_USUARIO")), true

 Dim objConn, objRS, strSQL, strSQLClause
 Dim strTEXTO, strCOD_CATEGORIA, strSITUACAO, strAno, strINICIAL, strNOME, strCNPJ
 Dim strUSER_ID, strCOLOR
 Dim strIMG_HOMOLOGACAO, strALT_HOMOLOGACAO

 AbreDBConn objConn, CFG_DB 

 strNOME      = GetParam("var_nome")
 strCNPJ      = GetParam("var_cnpj")
 strSITUACAO  = GetParam("var_situacao")
 strAno       = GetParam("selAno")
 strINICIAL   = GetParam("var_inicial")

 strSql =          " SELECT ENT_FORNECEDOR.COD_FORNECEDOR, ENT_FORNECEDOR.RAZAO_SOCIAL, ENT_FORNECEDOR.NOME_FANTASIA, ENT_FORNECEDOR.NOME_COMERCIAL, ENT_FORNECEDOR.FONE_1, ENT_FORNECEDOR.DT_INATIVO, ENT_FORNECEDOR.NUM_DOC, ENT_FORNECEDOR.CONTATO "
 strSql = strSql & " FROM ENT_FORNECEDOR "
 strSql = strSql & " WHERE TRUE " 

 strSQLClause = ""
 if strNOME <> ""            then strSQLClause = strSQLClause & " AND (ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '%" & strNOME & "%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '%" & strNOME & "%' OR ENT_FORNECEDOR.NOME_COMERCIAL LIKE '%" & strNOME & "%')"
 if strCNPJ <> ""            then strSQLClause = strSQLClause & " AND ENT_FORNECEDOR.NUM_DOC LIKE '%" & strCNPJ & "%'" 
 if strSITUACAO = "INATIVO"  then strSQLClause = strSQLClause & " AND ENT_FORNECEDOR.DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"    then strSQLClause = strSQLClause & " AND ENT_FORNECEDOR.DT_INATIVO IS NULL "
 
 if strINICIAL <> "" then
	if strINICIAL <> "0-9" then
		strSQLClause = strSQLClause & " AND ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '" & strINICIAL & "%'"
	else 
		strSQLClause = strSQLClause & " AND ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '0%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '0%' "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '1%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '1%'  "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '2%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '2%'  "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '3%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '3%'  "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '4%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '4%'  "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '5%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '5%'  "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '6%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '6%'  "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '7%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '7%'  "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '8%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '8%'  "
		strSQLClause = strSQLClause & " OR ENT_FORNECEDOR.RAZAO_SOCIAL LIKE '9%' OR ENT_FORNECEDOR.NOME_FANTASIA LIKE '9%'  "
	end if
end if
 
if (strSQLClause <> "") then strSql = strSql & strSQLClause 

strSql = strSql & " ORDER BY ENT_FORNECEDOR.NOME_COMERCIAL, ENT_FORNECEDOR.DT_CADASTRO DESC, ENT_FORNECEDOR.COD_FORNECEDOR "
Set objRS = objConn.Execute(strSql) 
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
	<th width="1%"  class="sortable-numeric" nowrap>Cod</th>
    <th width="92%" class="sortable" nowrap>Nome Fantasia</th>
	<th width="1%"  class="sortable" nowrap>Nome Comercial</th>
    <th width="1%"  class="sortable" nowrap>Fone</th>
    <th width="1%"  class="sortable" nowrap>Contato</th>
	<th width="1%"  class="sortable" nowrap>CNPJ/CPF</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRS.Eof
	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		
		If IsDate(getValue(objRS,"DT_INATIVO")) Then
			strIMG_HOMOLOGACAO = "CliInativo.gif"
			strALT_HOMOLOGACAO = "Inativo" 
		Else 
			strIMG_HOMOLOGACAO = "CliAtivo.gif"
			strALT_HOMOLOGACAO = "Ativo" 
		End If 
	%>
  <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%"><%=MontaLinkGrade("modulo_FORNECEDOR","Delete.asp",GetValue(objRS,"COD_FORNECEDOR"),"IconAction_DEL.gif","REMOVER")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_FORNECEDOR","Update.asp",GetValue(objRS,"COD_FORNECEDOR"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_FORNECEDOR","Detail.asp",GetValue(objRS,"COD_FORNECEDOR"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
	<td style="text-align:right" nowrap><%=getValue(objRS,"COD_FORNECEDOR")%></td>
    <td><%=getValue(objRS,"NOME_FANTASIA")%></td>
    <td nowrap><%=getValue(objRS,"NOME_COMERCIAL")%></td>
    <td nowrap><%=getValue(objRS,"FONE_1")%></td>
    <td nowrap><%=getValue(objRS,"CONTATO")%></td>
    <td nowrap><%=getValue(objRS,"NUM_DOC")%></td>
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