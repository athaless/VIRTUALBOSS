<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_NF", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 600
WMD_WIDTHTTITLES = 110
' -------------------------------------------------------------------------------
Dim objConn, objRS, strSQL
Dim intCOD_NF, strABERTURA, strDataEmissao, strDataVcto
Dim strVLR_LIM_IRRF, strVLR_LIM_REDUCAO

AbreDBConn objConn, CFG_DB 

intCOD_NF = GetParam("var_chavereg")
strABERTURA = UCase(GetParam("var_abertura"))

if intCOD_NF<>"" then
	strSQL = " SELECT"																	&_
				"	 T1.COD_NF "														&_
				"	,T1.COD_CFG_NF " 													&_
				"	,T1.NUM_NF " 														&_
				"	,T1.COD_CLI "														&_
				"	,T1.CLI_NOME "														&_
				"	,T1.OBS_NF "														&_
				"	,T1.DT_EMISSAO "													&_
				"	,T1.VLR_IRRF "														&_
				"	,T1.VLR_COMISSAO "													&_
				"	,T1.TOT_NF "														&_
				"	,T1.PRZ_VCTO "														&_
				"	,T2.VLR_LIM_IRRF "													&_
				"	,T2.VLR_LIM_REDUCAO "												&_
				" FROM"																	&_
				"	NF_NOTA T1, " 														&_
				"	CFG_NF T2 " 														&_
				" WHERE T1.COD_NF=" & intCOD_NF											&_
				" AND T1.COD_CFG_NF = T2.COD_CFG_NF "
	'Response.Write(strSQL)
	'Response.End()
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
		strDataEmissao = GetValue(objRS,"DT_EMISSAO")
		if Not IsDate(strDataEmissao) Or strDataEmissao = "" then strDataEmissao = Date
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update&var_input1=VAR_COD_CLI&var_input2=VAR_CLI_NOME&var_tipo=' + document.form_update.DBVAR_STR_TIPO.value,'640','390');
}

function BuscaServico1() {	
	AbreJanelaPAGE('BuscaServicoUm.asp?var_chavereg=' + document.formSv.var_cod_servico.value + '&var_input1=var_cod_servico&var_input2=var_servico&var_input3=var_vlr_servico&var_form=formSv','70','40');
}

function BuscaServico2() {	
	AbreJanelaPAGE('BuscaServico.asp?var_input1=var_cod_servico&var_input2=var_servico&var_input3=var_vlr_servico&var_form=formSv','760','390');
}

function Limpar() {
	formSv.var_cod_servico.value = '';
	formSv.var_servico.value = '';
	formSv.var_vlr_servico.value = '';
	formSv.var_prc_comissao.value = '';
	formSv.var_desc_extra.value = '';
}

function Marcar() {
	if (MoedaToFloat(document.form_update.var_vlr_IRRF.value) >= MoedaToFloat(document.form_update.var_vlr_LIM_IRRF.value))
		document.form_update.var_IRRF.checked = true;
	else {
		document.form_update.var_IRRF.checked = false;
		document.form_update.var_IRRF_acum.checked = false;
		//document.form_update.var_vlr_IRRF_acum.value = 0;
	}
	
	if (MoedaToFloat(document.form_update.var_total_servicos.value) >= MoedaToFloat(document.form_update.var_vlr_LIM_REDUCAO.value))
		document.form_update.var_reducao_outros.checked = true;
	else {
		document.form_update.var_reducao_outros.checked = false;
		document.form_update.var_REDUCAO_acum.checked = false;
		//document.form_update.var_vlr_REDUCAO_acum.value = 0;
	}
}

function LimparNome() {
	document.form_update.VAR_CLI_NOME.value = '';
}

function BuscaAcum(prTipo, prCodNF, prCodCli, prMes, prAno) {
	var var_pagina = 'Busca' + prTipo + '.asp';
	
	prCodCli = eval('document.form_update.VAR_COD_CLI.value');
	if ((prTipo == 'IRRF') || (prTipo == 'REDUCAO')) {
		AbreJanelaPAGE(var_pagina + '?var_chavereg=' + prCodNF + '&var_cod_cli=' + prCodCli + '&var_mes=' + prMes + '&var_ano=' + prAno,'540','280');
	}
}

function VerificaAcum(prTipo) {
	var valor1, valor2, valor3;
	
	if ((prTipo == 'IRRF') && (!document.form_update.var_IRRF_acum.checked)) {
		valor1 = document.form_update.var_vlr_IRRF.value;
		valor1 = valor1.toString();
		valor1 = valor1.replace('.', '');
		valor1 = valor1.replace(',', '.');
		
		valor2 = document.form_update.var_vlr_IRRF_acum.value;
		valor2 = valor2.toString();
		valor2 = valor2.replace('.', '');
		valor2 = valor2.replace(',', '.');
		
		valor3 = Number(Number(valor1) - Number(valor2));
		valor3 = roundNumber(valor3, 2);
		
		valor3 = valor3.toString();
		valor3 = valor3.replace(',', '');
		valor3 = valor3.replace('.', ',');
		
		document.form_update.var_vlr_IRRF.value = valor3;
		document.form_update.var_vlr_IRRF_acum.value = 0;
	}
	if ((prTipo == 'REDUCAO') && (!document.form_update.var_REDUCAO_acum.checked)) {
		valor1 = document.form_update.var_vlr_reducao_outros.value;
		valor1 = valor1.toString();
		valor1 = valor1.replace('.', '');
		valor1 = valor1.replace(',', '.');
		
		valor2 = document.form_update.var_vlr_REDUCAO_acum.value;
		valor2 = valor2.toString();
		valor2 = valor2.replace('.', '');
		valor2 = valor2.replace(',', '.');
		
		valor3 = Number(Number(valor1) - Number(valor2));
		valor3 = roundNumber(valor3, 2);
		
		valor3 = valor3.toString();
		valor3 = valor3.replace(',', '');
		valor3 = valor3.replace('.', ',');
		
		document.form_update.var_vlr_reducao_outros.value = valor3;
		document.form_update.var_vlr_REDUCAO_acum.value = 0;
	}
}

function AplicarServico() {
	var var_codigo = formSv.var_servico.value;
	
	if (!isNaN(var_codigo)) {
		BuscaServico1();
	}
	else {
		document.formSv.submit();
	}
	Limpar();
}


//****** Funções de ação dos botões - Início ******
function ok() {
	document.form_update.DEFAULT_LOCATION.value = "";
	submeterForm();
}

function cancelar() {
	parent.frames["vbTopFrame"].document.form_principal.submit();
}

function aplicar() {
	document.form_update.JSCRIPT_ACTION.value = "";
	submeterForm();
}

function submeterForm() {
	var var_avisos = false;
	var valor1, valor2;
	
	valor1 = FloatToMoeda(document.form_update.var_vlr_LIM_IRRF.value);
	valor1 = valor1.toString();
	valor1 = valor1.replace('.', ',');
	
	valor2 = FloatToMoeda(document.form_update.var_vlr_LIM_REDUCAO.value);
	valor2 = valor2.toString();
	valor2 = valor2.replace('.', ',');
	
	if ((document.form_update.var_IRRF.checked) && (MoedaToFloat(document.form_update.var_vlr_IRRF.value) < MoedaToFloat(document.form_update.var_vlr_LIM_IRRF.value))) {
		var_avisos = true;
		alert('O valor do IRRF é menor que R$ ' + valor1 + '.\nÉ aconselhável não incluir o IRRF nesta nota de serviço.');
	}
	if ((!document.form_update.var_IRRF.checked) && (MoedaToFloat(document.form_update.var_vlr_IRRF.value) >= MoedaToFloat(document.form_update.var_vlr_LIM_IRRF.value))) {
		var_avisos = true;
		alert('O valor do IRRF é igual ou maior que R$ ' + valor1 + '.\nÉ aconselhável incluir o IRRF nesta nota de serviço.');
	}
	
	if ((document.form_update.var_reducao_outros.checked) && (MoedaToFloat(document.form_update.var_total_servicos.value) < MoedaToFloat(document.form_update.var_vlr_LIM_REDUCAO.value))) {
		var_avisos = true;
		alert('O valor da Contribuição Social é menor que R$ ' + valor2 + '.\nÉ aconselhável não incluir a redução de Contribuição Social nesta nota de serviço.');
	}
	if ((!document.form_update.var_reducao_outros.checked) && (MoedaToFloat(document.form_update.var_total_servicos.value) >= MoedaToFloat(document.form_update.var_vlr_LIM_REDUCAO.value))) {
		var_avisos = true;
		alert('O valor da Contribuição Social é igual ou maior que R$ ' + valor2 + '.\nÉ aconselhável incluir a redução de Contribuição Social nesta nota de serviço.');
	}
	
	if (var_avisos == false) {
		document.form_update.submit();
	}
	else {
		if (confirm('Deseja atualizar dados da nota apesar do(s) aviso(s)?')) {
			document.form_update.submit();
		}
	}
}

//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Emiss&atilde;o NF - Altera&ccedil;&atilde;o") %>
<table width="100%" border="0px" cellpadding="1px" cellspacing="0px">
	<form name="form_update" action="../modulo_FIN_NF/Update_Exec.asp" method="post">
	<input name="VAR_COD_NF" 				 type="hidden" value="<%=intCOD_NF%>">
	<input name="var_abertura"      		 type="hidden" value="<%=strABERTURA%>">
	<input name="var_vlr_PIS"                type="hidden" value="">
	<input name="var_vlr_COFINS"             type="hidden" value="">
	<input name="var_vlr_CSOCIAL"            type="hidden" value="">
	<input name="var_vlr_LIM_IRRF"           type="hidden" value="<%=FormataDouble(GetValue(objRS, "VLR_LIM_IRRF"))%>">
	<input name="var_vlr_LIM_REDUCAO"        type="hidden" value="<%=FormataDouble(GetValue(objRS, "VLR_LIM_REDUCAO"))%>">
	<input name="var_vlr_COMISSAO"           type="hidden" value="">
	<input name="var_cod_nfs_IRRF"           type="hidden" value="">
	<input name="var_cod_nfs_REDUCAO"        type="hidden" value="">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_FIN_NF/Update.asp?var_chavereg=<%=intCOD_NF%>'>
	<tr> 
		<td width="<%=WMD_WIDTHTTITLES%>" style="text-align:right;"></td>
		<td>
			<select name="DBVAR_STR_TIPO" size="1" style="width:170px;"><% MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", GetValue(objRS, "TIPO")%></select>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;">*Cliente:&nbsp;</td>
		<td>
			<input name="VAR_COD_CLI" type="text" style="width:30px;" value="<%=GetValue(objRS,"COD_CLI")%>" onChange="LimparNome();" onKeyPress="validateNumKey();" maxlength="5"><input name="VAR_CLI_NOME" type="text" style="width:340px;" value="<%=GetValue(objRS,"CLI_NOME")%>" readonly><a href="Javascript:void(0);" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" hspace="0" align="absmiddle"></a>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;width:120px;">Data de Emissão:&nbsp;</td>
		<td>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="50%"><%=InputDate("VAR_DT_EMISSAO","",PrepData(strDataEmissao,true,false),false)%>
			<a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form_update.VAR_DT_EMISSAO);return false;">
			<img class="PopcalTrigger" align="absmiddle" src="../img/bullet_dataatual.gif" border="0" alt="" style="cursor:hand" title="ver calendário">
			</a><span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span></td>
			<td style="text-align:right;" nowrap="nowrap" width="10%">&nbsp;&nbsp;Prazo de Vcto:&nbsp;</td>
			<td width="40%"><input name="VAR_PRZ_VCTO" type="text" size="6" maxlength="4" value="<%=GetValue(objRS, "PRZ_VCTO")%>" onKeyPress="validateNumKey();"></td>
		</tr>
		</table>
	</tr>
	<tr>
		<td style="text-align:right;">*Modelo:&nbsp;</td>
		<td>
		<select name="VAR_COD_CFG_NF" size="1">
		<% montaCombo "STR", " SELECT COD_CFG_NF, DESCRICAO FROM CFG_NF WHERE DT_INATIVO IS NULL ORDER BY ORDEM, DESCRICAO ", "COD_CFG_NF", "DESCRICAO", GetValue(objRS,"COD_CFG_NF") %>
		</select>
		</td>
	</tr>
	<tr>
		<td style="text-align:right;" valign="top">Observa&ccedil;&atilde;o:&nbsp;</td>
		<td><textarea name="VAR_OBS_NF" rows="5" style="width:365px;"><%=GetValue(objRS,"OBS_NF")%></textarea></td>
	</tr>

	<tr><td colspan="2" height="10"></td></tr>
    <tr> 
      <td></td>
      <td><div class="divgrupo"><b>Totais</b></div></td>
    </tr>
    <tr><td colspan="2" height="10"></td></tr>
	<tr>
		<td style="text-align:right;">*Servi&ccedil;o:&nbsp;</td>
		<td valign="middle"><input name="var_total_servicos" type="text" style="width:80px;" maxlength="15" onKeyPress="validateFloatKey();" readonly="true">&nbsp;</td>
	</tr>

	<tr>
		<td style="text-align:right;"></td>
		<td valign="middle">
			<table border="0px" cellpadding="2px" cellspacing="0px">
				<tr>
					<td width="1%"><input name="var_IRRF" type="checkbox" class="inputclean" title="Aplicar o valor do IRRF na nota" onClick="this.value=this.checked;"></td>
					<td width="1%" style="text-align:right;" nowrap>IRRF:</td>
					<td width="1%"><input name="var_vlr_IRRF" type="text" style="width:60px;" maxlength="15" readonly></td>
					<td width="1%"><a href="javascript:void(0);" onClick="javascript:BuscaAcum('IRRF', '<%=intCOD_NF%>', '', '<%=Month(Date())%>', '<%=Year(Date())%>');"><img src="../img/BtBuscar.gif" border="0"></a></td>
					<td width="1%"><input name="var_IRRF_acum" type="checkbox" class="inputclean" title="Aplicar o valor do IRRF acumulado na nota" onClick="this.value=this.checked;VerificaAcum('IRRF');"></td>
					<td width="1%" style="text-align:right;" nowrap>IRRF Acum:</td>
					<td width="94%" align="left"><input name="var_vlr_IRRF_acum" type="text" style="width:60px;" maxlength="15" readonly></td>
				</tr>
			</table>
		</td>	
	</tr>
	<tr>
		<td style="text-align:right;"></td>
		<td valign="middle">
			<table border="0px" cellpadding="2px" cellspacing="0px">
				<tr>
					<td width="1%"><input name="var_reducao_outros" type="checkbox" class="inputclean" title="Aplicar o valor da Contribuição Social na nota" onClick="this.value=this.checked;"></td>
					<td width="1%" style="text-align:right;" nowrap>Redução C.S., PIS, COFINS:</td>
					<td width="1%"><input name="var_vlr_reducao_outros" type="text" style="width:60px;" maxlength="15" readonly></td>
					<td width="1%"><a href="javascript:void(0);" onClick="javascript:BuscaAcum('REDUCAO', '<%=intCOD_NF%>', '', '<%=Month(Date())%>', '<%=Year(Date())%>');"><img src="../img/BtBuscar.gif" border="0"></a></td>
					<td width="1%"><input name="var_REDUCAO_acum" type="checkbox" class="inputclean" title="Aplicar o valor da Redução acumulada na nota" onClick="this.value=this.checked;VerificaAcum('REDUCAO');"></td>
					<td width="1%" style="text-align:right;" nowrap>Redução Acum:</td>
					<td width="94%" align="left"><input name="var_vlr_REDUCAO_acum" type="text" style="width:60px;" maxlength="15" readonly></td>
				</tr>
			</table>
		</td>
	</tr>
</form>
</table>
<table width="100%" border="0px" cellpadding="1px" cellspacing="0px">
<form name="formSv" action="InsertServicos_Exec.asp" method="post" target="iServicos">
<input name="var_cod_nf" type="hidden" value="<%=intCOD_NF%>">
	<tr><td colspan="2" height="10"></td></tr>
    <tr> 
      <td></td>
      <td><div class="divgrupo"><b>Servi&ccedil;os</b>&nbsp;&nbsp;<a href="Javascript:void(0);" onClick="JavaScript:BuscaServico2();"><img src="../img/BtBuscar.gif" border="0" hspace="4" align="absmiddle"></a>&nbsp;</div></td>
    </tr>
    <tr><td colspan="" height="10"></td></tr>
	<tr>
		<td valign="middle" style="padding-left:30px;" width="1%"></td>
		<td valign="middle">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="1%">Cod</td>
			<td width="1%">Título</td>
			<td width="1%">Valor</td>
			<td width="1%">Fator</td>
			<td width="1%" nowrap="nowrap">% Comissão</td>
			<td width="95%"></td>
		</tr>
		<tr>
			<td width="1%"><input name="var_cod_servico" type="text" style="width:40px;" value="" onKeyPress="validateNumKey();" maxlength="5">&nbsp;</td>
			<td width="1%"><input name="var_servico" type="text" style="width:240px;" value="" readonly="">&nbsp;</td>
			<td width="1%"><input name="var_vlr_servico" type="text" style="width:80px;" value="">&nbsp;</td>
			<td width="1%"><input name="var_fator" type="text" style="width:30px;" value="1">&nbsp;</td>
			<td width="1%"><input name="var_prc_comissao" type="text" style="width:52px;" value="">&nbsp;</td>
			<td width="95%" align="left" valign="top"><a href="Javascript:void(0);" onClick="JavaScript:AplicarServico();"><img src="../img/BtOk.gif" border="0" hspace="2" align="absmiddle"></a></td>
		</tr>
		<tr>
			<td width="5%" colspan="5"><input type="text" name="var_desc_extra" maxlength="255" style="width:454px;"></td>
			<td width="95%"></td>
		</tr>
		</table>
		</td>
	</tr>
	<tr><td colspan="2" height="5px;"></td></tr>	
	<tr>
		<td align="right" colspan="2">
			<iframe frameborder="0" name="iServicos" id="iServicos" src="DetailServicos.asp?var_chavereg=<%=intCOD_NF%>" width="90%" align="center"></iframe>
		</td>
	</tr>	
</form>
</table>
<div class="texto_ajuda" style="padding-left:30px; font-style:italic;">
	Campos com <span style="font:8px; vertical-align:middle; width:10px;">&nbsp;*</span> são obrigatórios
</div>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>

<% 
'If strABERTURA = "EXTERNA" Then 
'	athEndDialog WMD_WIDTH, "../img/bt_save.gif", "Javascript:Verifica();", "../img/bt_cancelar.gif", "window.close();", "", "" 
'Else
'	athEndDialog WMD_WIDTH, "../img/bt_save.gif", "Javascript:Verifica();", "../img/bt_cancelar.gif", "history.go(-1);", "", "" 
'End If
%>
<iframe name="gToday:normal:agenda.js" id="gToday:normal:agenda.js"
        src="../_calendar/source/ipopeng.htm" scrolling="no" frameborder="0"
        style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
end if

FechaDBConn objConn
%>
<script>
	Marcar();
</script>