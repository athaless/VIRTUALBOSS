<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim objConn, objRS, strSQL  
Dim strFORM, strTIPO, strINPUT1, strINPUT2, strINPUT3, strCOD_CATEGORIA

AbreDBConn objConn, CFG_DB 

strINPUT1 = GetParam("var_input1")
strINPUT2 = GetParam("var_input2")
strINPUT3 = GetParam("var_input3")
strCOD_CATEGORIA = GetParam("var_cod_categoria")
strFORM = GetParam("var_form")

%>
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<script>
function Retorna(valor1, valor2, valor3) { 
	window.opener.document.<%=strFORM%>.<%=strINPUT1%>.value = valor1;
	window.opener.document.<%=strFORM%>.<%=strINPUT2%>.value = valor2;
	window.opener.document.<%=strFORM%>.<%=strINPUT3%>.value = valor3;
	window.close();
}
</script>
</head>
<body bgcolor="#ffffff" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table align="center" cellpadding="0" cellspacing="0" width="100%" height="58">
	<tr>
		<td width="4%" background="../img/Menu_TopBGLeft.jpg"></td>
		<td width="1%" ><img src="../img/Menu_TopImgCenter.jpg"></td>
		<td width="95%" background="../img/Menu_TopBgRight.jpg" align="right">
			<div style="padding-top:20px;padding-right:3px;"> 
				<table height="30" cellpadding="0" cellspacing="0" border="0">
					<form name="FormBusca" method="post" action="BuscaServico.asp">
					<input name="var_form" type="hidden" value="<%=strFORM%>"><%'Form que deve ser enviado o valor%>
					<input name="var_input1" type="hidden" value="<%=strINPUT1%>"><%'Nome do input que recebe o valor%>
					<input name="var_input2" type="hidden" value="<%=strINPUT2%>"><%'Nome do input que recebe o valor%>
					<input name="var_input3" type="hidden" value="<%=strINPUT3%>"><%'Nome do input que recebe o valor%>
					<tr>
						<td width="50">
							<select name="var_cod_categoria" class="edtext" size="1">
								<option value="">[categoria]</option>
								<% MontaCombo "STR", "SELECT COD_CATEGORIA, NOME, DESCRICAO FROM SV_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME, DESCRICAO ", "COD_CATEGORIA", "NOME", strCOD_CATEGORIA %>
							</select>
						</td>
						<td width="5"></td>
						<td width="27"><a href="javascript:document.FormBusca.submit();"><img src="../img/bt_search_mini.gif" alt="Atualizar consulta..."  border="0"></a></td>
					</tr>
					</form>
				</table>
			</div>
		</td>
	</tr>
</table>
<%
	strSQL =          " SELECT COD_SERVICO, TITULO, DESCRICAO, VALOR, DT_INATIVO "
	strSQL = strSQL & " FROM SV_SERVICO WHERE DT_INATIVO IS NULL "
	If strCOD_CATEGORIA <> "" Then strSQL = strSQL & " AND COD_CATEGORIA = " & strCOD_CATEGORIA
	strSQL = strSQL & " ORDER BY TITULO "
	
	Set objRS = objConn.Execute(strSql) 
	if not objRS.Eof then
%>
<table cellpadding="0" cellspacing="1" width="99%" align="center">
	<tr><td height="2" colspan="4"></td></tr>
	<tr bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC"> 
		<td width="1%"  bgcolor="#CCCCCC" align="left" class="arial11Bold"><div style="padding-left:3px; padding-right:3px;">Cod</div></td>
		<td width="40%" bgcolor="#CCCCCC" align="left" class="arial11Bold"><div style="padding-left:3px; padding-right:3px;">Título</div></td>
		<td width="58%" bgcolor="#CCCCCC" align="left" class="arial11Bold"><div style="padding-left:3px; padding-right:3px;">Descrição</div></td>
		<td width="1%" bgcolor="#CCCCCC" align="right" class="arial11Bold"><div style="padding-left:3px; padding-right:3px;">Valor</div></td>
	</tr>
<%
		Dim Ct, strCOLOR 
		Ct = 1  
		while not objRS.Eof
			strCOLOR   = "#DAEEFA"
%>
	<tr bgcolor=<%=strCOLOR%> style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="Retorna('<%=GetValue(objRS,"COD_SERVICO")%>', '<%=GetValue(objRS,"TITULO")%>', '<%=FormataDecimal(GetValue(objRS,"VALOR"), 2)%>');"> 
		<td align="left" valign="middle" nowrap><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"COD_SERVICO")%>&nbsp;</div></td>
		<td align="left" valign="middle"><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"TITULO")%>&nbsp;</div></td>
		<td align="left" valign="middle"><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"DESCRICAO")%>&nbsp;</div></td>
		<td align="right" valign="middle" nowrap><div style="padding-left:3px; padding-right:3px;"><%=FormataDecimal(GetValue(objRS,"VALOR"), 2)%>&nbsp;</div></td>
	</tr>
<%
			Ct = Ct + 1
			objRS.MoveNext
		wend
%>
	<tr><td bgcolor="#CCCCCC" colspan="4" align="center" height="1"></td></tr>
</table>
<%
	else
		Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	end if
	
	FechaRecordSet objRS
%>
</body>
</html>
<%
	FechaDBConn objConn
%>