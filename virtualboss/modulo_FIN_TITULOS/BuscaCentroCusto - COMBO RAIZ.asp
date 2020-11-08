<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim strSQL, objRS, objRSAux, ObjConn
Dim strFORM, strVEZES, strCOD_RAIZ
Dim strRETORNO1, strRETORNO2
Dim strCOLOR

Sub ExibeLinha(prCOD_CENTRO_CUSTO, prCOD_REDUZIDO, prNOME, prNIVEL, prDT_INATIVO, prCOLOR)
	Response.Write("<tr bgcolor=" & prCOLOR & " style='cursor:hand;' onMouseOver=""this.style.backgroundColor='#FFCC66';"" onMouseOut=""this.style.backgroundColor='';"" onClick=""Retorna('" & prCOD_CENTRO_CUSTO & "','" & prNOME & "');"">")
	Response.Write("	<td></td>")
	Response.Write("	<td style='text-align:right;'>" & prCOD_CENTRO_CUSTO & "</td>")
	Response.Write("	<td>" & prCOD_REDUZIDO & "</td>")
	Response.Write("	<td><img src='../img/Custos_Nivel" & prNIVEL & ".gif' border='0'>" & prNOME & "</td>")
	Response.Write("	<td style='text-align:right;'>" & PrepData(prDT_INATIVO, True, False) & "</td>")
	Response.Write("</tr>")
End Sub

Sub ExibeFilhos(prCOD_CENTRO_CUSTO, prCOLOR)
	Dim objRSAux
	
	strSQL =          " SELECT COD_CENTRO_CUSTO, COD_REDUZIDO, NOME, NIVEL, DT_INATIVO "
	strSQL = strSQL & " FROM FIN_CENTRO_CUSTO WHERE COD_CENTRO_CUSTO_PAI = " & prCOD_CENTRO_CUSTO
	strSQL = strSQL & " ORDER BY COD_REDUZIDO, ORDEM, NOME"
	
	Set objRSAux = objConn.Execute(strSQL)
	
	while not objRSAux.Eof
		prCOLOR = swapString(prCOLOR,"#FFFFFF","#F5FAFA")
		ExibeLinha GetValue(objRSAux,"COD_CENTRO_CUSTO"), GetValue(objRSAux,"COD_REDUZIDO"), GetValue(objRSAux,"NOME"), GetValue(objRSAux,"NIVEL"), GetValue(objRSAux,"DT_INATIVO"), prCOLOR
		ExibeFilhos GetValue(objRSAux,"COD_CENTRO_CUSTO"), prCOLOR
		
		objRSAux.MoveNext
	wend
	FechaRecordSet objRSAux
End Sub

strFORM = GetParam("var_form")
strVEZES = GetParam("var_vezes")
strRETORNO1 = GetParam("var_retorno1")
strRETORNO2 = GetParam("var_retorno2")
strCOD_RAIZ = GetParam("var_cod_raiz")

AbreDBConn objConn, CFG_DB

If strCOD_RAIZ = "" Then
	strSQL = " SELECT COD_CENTRO_CUSTO, COD_REDUZIDO, NOME, NIVEL, DT_INATIVO FROM FIN_CENTRO_CUSTO WHERE COD_CENTRO_CUSTO_PAI IS NULL ORDER BY COD_REDUZIDO, ORDEM, NOME "
	Set objRS = objConn.Execute(strSQL)
	If Not objRS.Eof Then strCOD_RAIZ = GetValue(objRS, "COD_CENTRO_CUSTO")
	FechaRecordSet objRS
End If
%>
<html>
<head>
<title>vboss</title>
<script language="JavaScript" type="text/javascript">
<!--
function Retorna(valor1,valor2) { 
	var objOption;
	
	if ('1'!='<%=strVEZES%>')
		window.opener.document.<%=strFORM%>.<%=strRETORNO1%>.remove(window.opener.document.<%=strFORM%>.<%=strRETORNO1%>.options.length-1);
	
	// Cria uma nova opção no combo	
	objOption = window.opener.document.createElement("OPTION");
	
	window.opener.document.<%=strFORM%>.<%=strRETORNO1%>.options.add(objOption);
	
	objOption.innerText = valor2;
	objOption.value = valor1;
	objOption.selected = 1;
	
	window.close();
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
		<form name="form_principal" method="post" action="BuscaCentroCusto.asp">
			<input name="var_form"     type="hidden" value="<%=strFORM%>">
			<input name="var_retorno1" type="hidden" value="<%=strRETORNO1%>">
			<input name="var_retorno2" type="hidden" value="<%=strRETORNO2%>">
			<div class="form_label_nowidth">Nome:</div>
			<!-- input name="var_palavra_chave" type="text" class="edtext" style="widows:80px;" value="<%'=strPALAVRA_CHAVE%>" -->
			<select name="var_cod_raiz" size="1" class="edtext_combo" style="width:180px;">
				<% montaCombo "STR", " SELECT COD_CENTRO_CUSTO, NOME FROM FIN_CENTRO_CUSTO WHERE COD_CENTRO_CUSTO_PAI IS NULL ORDER BY COD_REDUZIDO ", "COD_CENTRO_CUSTO", "NOME", strCOD_RAIZ %>
			</select>
			<div onClick="document.form_principal.submit();" class="btsearch"></div>
		</form>
	</div>
	</td>
</tr>
</table>
<%
If strCOD_RAIZ <> "" Then
	strSQL = " SELECT COD_CENTRO_CUSTO, COD_REDUZIDO, NOME, NIVEL, DT_INATIVO FROM FIN_CENTRO_CUSTO WHERE COD_CENTRO_CUSTO_PAI IS NULL "
	If strCOD_RAIZ <> "" Then strSQL = strSQL & " AND COD_CENTRO_CUSTO = " & strCOD_RAIZ
	strSQL = strSQL & " ORDER BY COD_REDUZIDO, ORDEM, NOME "
	
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
		'strCOLOR = swapString(strCOLOR,"#FFFFFF","#F5FAFA")
		while not objRS.Eof
			'ExibeLinha GetValue(objRS,"COD_CENTRO_CUSTO"), GetValue(objRS,"COD_REDUZIDO"), GetValue(objRS,"NOME"), GetValue(objRS,"NIVEL"), GetValue(objRS,"DT_INATIVO"), strCOLOR
			ExibeFilhos GetValue(objRS,"COD_CENTRO_CUSTO"), strCOLOR
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
End If
%>
</body>
</html>
<% 
FechaDBConn objConn 
%>