<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PEDIDO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.DBVAR_NUM_COD_CLIô.value == '') var_msg += '\nEntidade';
	
	if (var_msg == ''){
		document.form_insert.submit();
	} else{
		alert('Favor verificar campos:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
/*function BuscaEntidade() {
	if ((document.form_insert.DBVAR_NUM_COD_CLIô.value != '') && (document.form_insert.var_nome.value == ''))
		AbreJanelaPAGE('BuscaEntidadeUm.asp?var_chavereg=' + document.form_insert.DBVAR_NUM_COD_CLIô.value + '&var_tipo=' + document.form_insert.DBVAR_STR_TIPO.value + '&var_form=form_insert&var_input1=DBVAR_NUM_COD_CLIô&var_input2=DBVAR_STR_TIPO&var_input3=var_nome','300','200');
	else
		AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input1=DBVAR_NUM_COD_CLIô&var_input2=DBVAR_STR_TIPO&var_input3=var_nome','640','390');
}*/
function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input=DBVAR_NUM_COD_CLIô&var_input_tipo=DBVAR_STR_TIPO&var_tipo=' + document.form_insert.DBVAR_STR_TIPO.value,'640','390');
}

function LimparCampo(prForm, prCampo) {
	eval("document." + prForm + "." + prCampo + ".value = '';");
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Pedido - Inser&ccedil;&atilde;o")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="NF_NOTA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_NF">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PEDIDO/insert.asp'>
	<input type="hidden" name="DBVAR_STR_SITUACAO" value="ABERTO">
	<input type="hidden" name="DBVAR_DATETIME_SYS_DTT_INS" value="<%=now()%>">
	<input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<br><div class="form_label">*Entidade:</div><input name="DBVAR_NUM_COD_CLIô" type="text" maxlength="10" value="" onKeyPress="validateNumKey();" style="vertical-align:bottom; width:40px;"><select name="DBVAR_STR_TIPO" size="1" style="width:185px;"><%
		 MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO","" %></select><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
	<br><div class="form_label">Data Emissão:</div><%=InputDate("DBVAR_DATE_DT_EMISSAO","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_EMISSAO", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">Observação:</div><textarea name="DBVAR_STR_OBS_NF" rows="6"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>