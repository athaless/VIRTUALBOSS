<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim objConn, objRS, strSQL  
Dim strNOME, strTABLE, strTYPE
Dim strPALAVRA_CHAVE, strFORM, strTIPO, strINPUT, strINPUT_TIPO
Dim strINPUT_NOME, strVEZES
Dim strCOLOR

AbreDBConn objConn, CFG_DB 

strINPUT = GetParam("var_input")
strINPUT_TIPO = GetParam("var_input_tipo")
strINPUT_NOME = "var_entidade" 'GetParam("var_input_nome")
strTIPO  = GetParam("var_tipo")
strVEZES = GetParam("var_vezes")
strFORM = GetParam("var_form")
strPALAVRA_CHAVE = GetParam("var_palavra_chave")
%>
<html>
<head>
<title>vboss</title>
<script language="JavaScript" type="text/javascript">
function Retorna(valor1,valor2) { 
	var objOption;
	
	window.opener.document.<%=strFORM%>.<%=strINPUT%>.value = valor1;
	window.opener.document.<%=strFORM%>.<%=strINPUT_TIPO%>.value = '<%=strTIPO%>';
	
	if ('form_principal'=='<%=strFORM%>') {
		// Apaga última opção do combo
		if ('1'!='<%=strVEZES%>')
			window.opener.document.<%=strFORM%>.<%=strINPUT_NOME%>.remove(window.opener.document.<%=strFORM%>.<%=strINPUT_NOME%>.options.length-1);
		
		// Cria uma nova opção no combo	
		objOption = window.opener.document.createElement("OPTION");
		
		window.opener.document.<%=strFORM%>.<%=strINPUT_NOME%>.options.add(objOption);		
		objOption.innerText = valor2;
		objOption.value = "";	
		objOption.selected = 1;
	}
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
	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
	<div class="form_line">
		<form name="form_busca" id="form_busca" action="?form_busca">
			<!-- phrase --><input type="hidden" class="inputclean" id="phrase" name="phrase" style="width:10px; height:10px;" />
			<!-- cases  --><input type="hidden" class="inputclean" id="cases"  name="cases"  style="width:10px; height:10px;" />
			<!-- regex  --><input type="hidden" class="inputclean" id="regex"  name="regex"  style="width:10px; height:10px;" />&nbsp;&nbsp;&nbsp;

			<input type="text" name="result" id="result" size="10" style="border:0" readonly="readonly" onclick="unhighlight(this.value.substring(this.value.indexOf('x ')+1))"/>
			<label for="query" title=" Alt+Q ">Busca: <input type="text" id="query" name="query" size="15" accesskey="q" class="edtext"  /></label>

			<div onClick="return hi(document.getElementById('form_busca'), 'query', 'result');" class="btsearch"></div>
		</form>
	</div>
	</td>
	</tr>
</table>
<%
	strSQL = ""
	If strTIPO = "ENT_FORNECEDOR" Then	
		strSQL = " SELECT COD_FORNECEDOR AS CODIGO, NOME_FANTASIA AS NOME, EMAIL, DT_INATIVO FROM ENT_FORNECEDOR " 
		If strPALAVRA_CHAVE <> "" Then
			strSQL = strSQL & " WHERE (NOME_FANTASIA LIKE '%" & strPALAVRA_CHAVE & "%' OR RAZAO_SOCIAL LIKE '%" & strPALAVRA_CHAVE & "%' OR NOME_COMERCIAL LIKE '%" & strPALAVRA_CHAVE & "%') " 
		End If 
		strSQL = strSQL & " ORDER BY 2 " 
	End If 
	If strTIPO = "ENT_CLIENTE" Then 
		strSQL = " SELECT COD_CLIENTE AS CODIGO, NOME_FANTASIA AS NOME, EMAIL, DT_INATIVO FROM ENT_CLIENTE " 
		If strPALAVRA_CHAVE <> "" Then
			strSQL = strSQL & " WHERE (NOME_FANTASIA LIKE '%" & strPALAVRA_CHAVE & "%' OR RAZAO_SOCIAL LIKE '%" & strPALAVRA_CHAVE & "%' OR NOME_COMERCIAL LIKE '%" & strPALAVRA_CHAVE & "%') " 
		End If 
		strSQL = strSQL & " ORDER BY 2 " 
	End If 
	If strTIPO = "ENT_COLABORADOR" Then 
		strSQL = " SELECT COD_COLABORADOR AS CODIGO, NOME, EMAIL, DT_INATIVO FROM ENT_COLABORADOR " 
		If strPALAVRA_CHAVE <> "" Then
			strSQL = strSQL & " WHERE (NOME LIKE '%" & strPALAVRA_CHAVE & "%') " 
		End If 
		strSQL = strSQL & " ORDER BY 2 " 
	End If
	
	Set objRS = objConn.Execute(strSQL) 
	
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
    <th width="90%" class="sortable" nowrap>Nome/N.Fantasia</th>
 </tr>
 </thead>
 <tbody style="text-align:left;">
<%
		while not objRS.Eof
			strCOLOR = swapString(strCOLOR,"#FFFFFF","#F5FAFA")
%>
	<tr bgcolor="<%=strCOLOR%>" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="Retorna('<%=GetValue(objRS,"CODIGO")%>','<%=GetValue(objRS,"NOME")%>');">
		<td></td>
		<td style="text-align:right;"><%=GetValue(objRS,"CODIGO")%></td>
		<td><%=GetValue(objRS,"NOME")%></td>
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