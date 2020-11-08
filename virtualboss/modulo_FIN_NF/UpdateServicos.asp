<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_NF", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 350
WMD_WIDTHTTITLES = 100
' -------------------------------------------------------------------------------
Dim objConn, objRS, strSQL
Dim intCOD_NF_ITEM, intCOD_NF, strFATOR
AbreDBConn objConn, CFG_DB 

intCOD_NF_ITEM = GetParam("var_chavereg")
intCOD_NF = GetParam("var_cod_nf")

if intCOD_NF_ITEM<>"" then
	strSQL =          " SELECT DESC_EXTRA, VALOR, VALOR_ORIG, PRC_COMISSAO, VLR_COMISSAO "
	strSQL = strSQL & " FROM NF_ITEM WHERE COD_NF_ITEM=" & intCOD_NF_ITEM
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.eof then
		strFATOR = ""
		if GetValue(objRS,"VALOR_ORIG") <> "" and GetValue(objRS,"VALOR") <> "" and GetValue(objRS,"VALOR_ORIG") <> "0" then
			strFATOR = GetValue(objRS,"VALOR") / GetValue(objRS,"VALOR_ORIG")
		end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function Calcular() {
	var valor1 = MoedaToFloat(document.form_update.var_valor_orig.value);
	var valor2 = MoedaToFloat(document.form_update.var_fator.value);
	var var_total = roundNumber(valor1 * valor2, 2);
	
	var_total = FloatToMoeda(var_total);
	var_total = var_total.toString();
	var_total = var_total.replace('.',',');
	
	document.form_update.var_valor.value = var_total;
	
	
	valor1 = MoedaToFloat(document.form_update.var_prc_comissao.value);
	valor2 = MoedaToFloat(document.form_update.var_valor.value);
	var_total = roundNumber(valor1 * (valor2 / 100), 2);
	
	var_total = FloatToMoeda(var_total);
	var_total = var_total.toString();
	var_total = var_total.replace('.',',');
	
	document.form_update.var_vlr_comissao.value = var_total;
}

</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0px" topmargin="0px" marginwidth="0px" marginheight="0px">
<% athBeginDialog WMD_WIDTH, "Emiss&atilde;o NF - Altera&ccedil;&atilde;o de Servi&ccedil;o" %>
<form name="form_update" action="UpdateServicos_Exec.asp" method="post">
<input type="hidden" name="var_chavereg" value="<%=intCOD_NF_ITEM%>">
<input type="hidden" name="var_cod_nf" value="<%=intCOD_NF%>">
<input type="hidden" name="var_vlr_comissao" value="<%=FormataDouble(FormataDecimal(GetValue(objRS,"VLR_COMISSAO"),2))%>">
<table width="100%" border="0px" cellpadding="1px" cellspacing="0px">
	<tr>
		<td></td>
		<td>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="1%" nowrap>Valor:</td>
			<td width="1%"></td>
			<td width="1%">Fator:</td>
			<td width="1%"></td>
			<td width="1%" align="left">Valor:</td>
			<td width="95%"></td>
		</tr>
		<tr>
			<td width="1%"><input name="var_valor_orig" type="text" class="edtext" maxlength="20" style="width:80px;" value="<%=Replace(FormataDecimal(GetValue(objRS,"VALOR_ORIG"),2), ".", "")%>" onKeyPress="validateFloatKey();"></td>
			<td width="1%">&nbsp;&nbsp;X&nbsp;&nbsp;</td>
			<td width="1%"><input name="var_fator" type="text" class="edtext" maxlength="20" style="width:40px;" value="<%=Replace(FormataDecimal(strFATOR,2), ".", "")%>" onKeyPress="validateFloatKey();" onChange="Calcular();"></td>
			<td width="1%">&nbsp;&nbsp;=&nbsp;&nbsp;</td>
			<td width="1%"><input name="var_valor" type="text" class="edtext" maxlength="20" style="width:80px;" value="<%=Replace(FormataDecimal(GetValue(objRS,"VALOR"),2), ".", "")%>" onKeyPress="validateFloatKey();"></td>
			<td width="95%"></td>
		</tr>
		</table>
		</td>
	</tr>
	<tr><td colspan="2" height="2px;"></td></tr>
	<tr>
		<td align="right" valign="top">% Comissão:&nbsp;</td>
		<td><input name="var_prc_comissao" type="text" class="edtext" maxlength="10" size="10" value="<%=GetValue(objRS,"PRC_COMISSAO")%>" onChange="Calcular();"></td>
	</tr>
	<tr><td colspan="2" height="2px;"></td></tr>
	<tr>
		<td align="right" valign="top">Descri&ccedil;&atilde;o:&nbsp;</td>
		<td><input name="var_desc_extra" type="text" class="edtext" maxlength="255" size="50" value="<%=GetValue(objRS,"DESC_EXTRA")%>"></td>
	</tr>
</table>
</form>
<% athEndDialog WMD_WIDTH, "../img/bt_save.gif", "document.form_update.submit();", "", "", "", "" %>
</body>
</html>
<%
		FechaRecordSet objRS
	end if 
	FechaDBConn objConn
end if
%>