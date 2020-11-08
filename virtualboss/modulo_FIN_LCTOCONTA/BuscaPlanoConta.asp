<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim strSQL, objRS, objRSAux, ObjConn
Dim strFORM, strVEZES, strCOD_RAIZ, strPALAVRA_CHAVE
Dim strRETORNO1, strRETORNO2
Dim strCOLOR

strFORM = GetParam("var_form")
strVEZES = GetParam("var_vezes")
strRETORNO1 = GetParam("var_retorno1")
strRETORNO2 = GetParam("var_retorno2")
strPALAVRA_CHAVE = GetParam("var_palavra_chave")

AbreDBConn objConn, CFG_DB

%>
<html>
<head>
<title>vboss</title>
<script language="JavaScript" type="text/javascript">
<!--
function Retorna(valor1,valor2) { 
	var objOption;
	
	if ('<%=strVEZES%>' != '1') {
		if (window.opener.document.<%=strFORM%>.<%=strRETORNO1%>.options.length > 0) {
			window.opener.document.<%=strFORM%>.<%=strRETORNO1%>.remove(window.opener.document.<%=strFORM%>.<%=strRETORNO1%>.options.length-1);
		}
	}
	
	// Cria uma nova opção no combo	
	objOption = window.opener.document.createElement("OPTION");
	
	window.opener.document.<%=strFORM%>.<%=strRETORNO1%>.options.add(objOption);
	
	objOption.innerText = valor2;
	objOption.value = valor1;
	objOption.selected = 1;
	
	window.close();
}

function findText(strSearchTerm){
  var range = document.body.createTextRange();
  var found = range.findText(strSearchTerm);
  range.select()
  range.scrollIntoView()
}

//-->
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
	strSQL = " SELECT COD_PLANO_CONTA, COD_REDUZIDO, NOME, NIVEL, DT_INATIVO FROM FIN_PLANO_CONTA "
	If strPALAVRA_CHAVE <> "" Then strSQL = strSQL & " WHERE NOME LIKE '" & strPALAVRA_CHAVE & "%' "
	strSQL = strSQL & " ORDER BY COD_REDUZIDO, ORDEM, NOME"
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
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
    <th width="15%" class="sortable" nowrap>Cod Reduzido</th>
	<th width="74%" class="sortable">Nível/Nome</th>
	<th width="1%" class="sortable-date-dmy" nowrap="nowrap">Dt Inativo</th>
 </tr>
 </thead>
 <tbody style="text-align:left;">
<%
		while not objRS.Eof
			strCOLOR = swapString(strCOLOR,"#FFFFFF","#F5FAFA")
%>
	<tr bgcolor="<%=strCOLOR%>" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="Retorna('<%=GetValue(objRS,"COD_PLANO_CONTA")%>','<%=GetValue(objRS,"COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS,"NOME")%>');">
		<td></td>
		<td style="text-align:right;"><%=GetValue(objRS,"COD_PLANO_CONTA")%></td>
		<td><%=GetValue(objRS,"COD_REDUZIDO")%></td>
		<td><img src="../img/Custos_Nivel<%=GetValue(objRS,"NIVEL")%>.gif" border="0"><%=GetValue(objRS,"NOME")%></td>
		<td style="text-align:right;"><%=PrepData(GetValue(objRS,"DT_INATIVO"), True, False)%></td>
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