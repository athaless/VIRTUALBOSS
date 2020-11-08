<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim objConn, objRS, strSQL  
Dim strFORM, strTIPO, strINPUT1, strINPUT2, strINPUT3, strINPUT4, strCOD_CATEGORIA
Dim strCOLOR

AbreDBConn objConn, CFG_DB 

strINPUT1 = GetParam("var_input1")
strINPUT2 = GetParam("var_input2")
strINPUT3 = GetParam("var_input3")
strINPUT4 = GetParam("var_input4")
strFORM = GetParam("var_form")
strCOD_CATEGORIA = GetParam("var_cod_categoria")

%>
<html>
<head>
<title>vboss</title>
<script>
function Retorna(valor1, valor2, valor3, valor4) { 
	window.opener.document.<%=strFORM%>.<%=strINPUT1%>.value = valor1;
	window.opener.document.<%=strFORM%>.<%=strINPUT2%>.value = valor2;
	window.opener.document.<%=strFORM%>.<%=strINPUT3%>.value = valor3;
	window.opener.document.<%=strFORM%>.<%=strINPUT4%>.value = valor4;
	
	window.close();
}
</script>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);        vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;"></td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg);   vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
	<div class="form_line">
		<form name="form_principal" method="post" action="BuscaServico.asp">
			<input name="var_form"   type="hidden" value="<%=strFORM%>">
			<input name="var_input1" type="hidden" value="<%=strINPUT1%>">
			<input name="var_input2" type="hidden" value="<%=strINPUT2%>">
			<input name="var_input3" type="hidden" value="<%=strINPUT3%>">
			<input name="var_input4" type="hidden" value="<%=strINPUT4%>">
			<select name="var_cod_categoria" class="edtext_combo" size="1">
				<option value="">[categoria]</option>
				<% MontaCombo "STR", "SELECT COD_CATEGORIA, NOME, DESCRICAO FROM SV_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME, DESCRICAO ", "COD_CATEGORIA", "NOME", strCOD_CATEGORIA %>
			</select>
			<div onClick="document.form_principal.submit();" class="btsearch"></div>
		</form>
	</div>
	</td>
</tr>
</table>
<%
	strSQL =          " SELECT COD_SERVICO, TITULO, DESCRICAO, VALOR, ALIQ_ISSQN, DT_INATIVO "
	strSQL = strSQL & " FROM SV_SERVICO WHERE DT_INATIVO IS NULL "
	If strCOD_CATEGORIA <> "" Then strSQL = strSQL & " AND COD_CATEGORIA = " & strCOD_CATEGORIA
	strSQL = strSQL & " ORDER BY TITULO "
	
	Set objRS = objConn.Execute(strSql) 
	if not objRS.Eof then
%>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
 <tr>
    <th width="01%"></th>
	<th width="09%" class="sortable-numeric">Cod</th>
    <th width="44%" class="sortable">Título</th>
	<th width="44%" class="sortable">Descrição</th>
	<th width="1%" class="sortable-currency" nowrap="nowrap">Valor</th>
	<th width="1%" class="sortable-currency" nowrap="nowrap">ISSQN</th>
 </tr>
 </thead>
 <tbody style="text-align:left;">
<%
		while not objRS.Eof
			strCOLOR = swapString(strCOLOR,"#FFFFFF","#F5FAFA")
%>
	<tr bgcolor="<%=strCOLOR%>" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="Retorna('<%=GetValue(objRS,"COD_SERVICO")%>','<%=GetValue(objRS,"TITULO")%>','<%=GetValue(objRS,"DESCRICAO")%>','<%=GetValue(objRS,"VALOR")%>');">
		<td></td>
		<td style="text-align:right;"><%=GetValue(objRS,"COD_SERVICO")%></td>
		<td><%=GetValue(objRS,"TITULO")%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>
		<td style="text-align:right;"><% If GetValue(objRS,"VALOR") <> "" Then Response.Write(FormataDecimal(GetValue(objRS,"VALOR"), 2)) %></td>
		<td style="text-align:right;"><% If GetValue(objRS,"ALIQ_ISSQN") <> "" Then Response.Write(FormataDecimal(GetValue(objRS,"ALIQ_ISSQN"), 2)) %></td>
	</tr>
<%
			objRS.MoveNext
		wend
%>
 </tbody>
</table>
<%
	else
		Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	end if
	FechaRecordSet objRS
%>
</body>
</html>
<% FechaDBConn objConn %>