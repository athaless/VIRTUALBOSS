<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_NF", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
Dim strABERTURA 'intCOD_NF, , strDataEmissao, strDataVcto
'Dim strVLR_LIM_IRRF, strVLR_LIM_REDUCAO

AbreDBConn objConn, CFG_DB 

strABERTURA = UCase(GetParam("var_abertura"))

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input1=var_cod_cli&var_input2=var_cli_nome&var_tipo=' + document.form_insert.var_tipo.value,'640','390');
}

function LimparNome() {
	document.form_insert.var_cli_nome.value = '';
}

//****** Funções de ação dos botões - Início ******
function ok() {
	document.form_insert.DEFAULT_LOCATION.value = "";
	submeterForm();
}

function cancelar() {
	parent.frames["vbTopFrame"].document.form_principal.submit();
}

function aplicar() {
	document.form_insert.JSCRIPT_ACTION.value = "";
	submeterForm();
}

function submeterForm() {
	var var_avisos = false;
	
	if (document.form_insert.var_cod_cli.value == "") {
		var_avisos = true;
		alert('Selecionar cliente.');
	}
	if (document.form_insert.var_cod_cfg_nf.value == "") {
		var_avisos = true;
		alert('Selecionar modelo de nota.');
	}
	
	if (var_avisos == false) {
		document.form_insert.submit();
	}
}

//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Emiss&atilde;o NF - Inser&ccedil;&atilde;o") %>
<table width="100%" border="0px" cellpadding="1px" cellspacing="0px">
	<form name="form_insert" action="../modulo_FIN_NF/Insert_Exec.asp" method="post">
	<input name="var_abertura" type="hidden" value="<%=strABERTURA%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_FIN_NF/Insert.asp'>
	<tr> 
		<td width="<%=WMD_WIDTHTTITLES%>" style="text-align:right;"></td>
		<td>
			<!-- Desabilitei o combo pois esta opção no momento não pode ser diferente de CLIENTE - by Vini 20.11.2012 //-->
			<select disabled="disabled" name="var_tipo" size="1" style="width:170px;"><% MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", "ENT_CLIENTE" %></select>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;">*Cliente:&nbsp;</td>
		<td>
			<input name="var_cod_cli" type="text" style="width:30px;" value="" onChange="LimparNome();" onKeyPress="validateNumKey();" maxlength="5"><input name="var_cli_nome" type="text" style="width:340px;" value="" readonly="readonly"><a href="Javascript:void(0);" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" hspace="0" align="absmiddle"></a>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;width:120px;">Data de Emissão:&nbsp;</td>
		<td>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td style="width:160px;" nowrap="nowrap"><%=InputDate("var_dt_emissao","",PrepData(Now,true,false),false)%>
			<a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form_update.var_dt_emissao);return false;">
			<img class="PopcalTrigger" align="absmiddle" src="../img/bullet_dataatual.gif" border="0" alt="" style="cursor:hand" title="ver calendário">
			</a><span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span></td>
			<td style="width:100px; text-align:right;" nowrap="nowrap">&nbsp;&nbsp;Prazo de Vcto:&nbsp;</td>
			<td><input name="var_prz_vcto" type="text" size="6" maxlength="4" value="" onKeyPress="validateNumKey();"></td>
		</tr>
		</table>
	</tr>
	<tr>
		<td style="text-align:right;">*Modelo:&nbsp;</td>
		<td>
		<select name="var_cod_cfg_nf" size="1" style="width:200px;">
		<% montaCombo "STR", " SELECT COD_CFG_NF, DESCRICAO FROM CFG_NF WHERE DT_INATIVO IS NULL ORDER BY ORDEM, DESCRICAO ", "COD_CFG_NF", "DESCRICAO", "" %>
		</select>
		</td>
	</tr>
	<tr>
		<td style="text-align:right;" valign="top">Observa&ccedil;&atilde;o:&nbsp;</td>
		<td><textarea name="var_obs_nf" rows="5" style="width:365px;"></textarea></td>
	</tr>
	</td>
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
FechaDBConn objConn
%>