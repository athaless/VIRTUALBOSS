<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_PCONTAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
	
	if (document.form_insert.var_nome.value == '') var_msg += '\nNome';
	
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Plano de Conta - Inserção") %>
<form name="form_insert" action="InsUpd_Exec.asp" method="post">
	<input type="hidden" name="var_oper"			value="INS">
	<input type="hidden" name="JSCRIPT_ACTION"   	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_FIN_PCONTAS/insert.asp'>
	<div class="form_label"></div><div class="form_bypass"><b>Plano de Contas a que estará associado</b></div>
	<br><div class="form_label">Plano de Conta:</div><input name="var_cod_plano_conta_pai" type="text" size="5" maxlength="10"><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_insert&var_retorno1=var_cod_plano_conta_pai&var_retorno2=var_hierarquia', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
	<br><div class="form_label">Hierarquia:</div><input name="var_hierarquia" type="text" maxlength="50" readonly="readonly" style="width:250px; color:#000000; background-color:#FFFFFF; border:0px;">
	<br><div class="form_label"></div><div class="form_bypass"><b>Dados do Plano de Conta</b></div>
	<br><div class="form_label">Código Reduzido:</div><input name="var_cod_reduzido" type="text" size="25" maxlength="50">
	<br><div class="form_label">*Nome:</div><input name="var_nome" type="text" size="40" maxlength="50">
	<br><div class="form_label">Descrição:</div><input name="var_descricao" type="text" maxlength="250" style="width:250px;">
	<br><div class="form_label">DRE:</div><input name="var_dre" id="var_dre" class="inputclean" type="radio" value="True">Sim<input name="var_dre" id="var_dre" class="inputclean" type="radio" value="False" checked="checked">Não&nbsp;<span class="texto_ajuda">Deve aparecer no Demonstrativo do Relatório de Exercício</span>
	<br><div class="form_label">Ordem:</div><input name="var_ordem" type="text" size="10" maxlength="10" onKeyPress="validateNumKey();">
	<br><div class="form_label">Status:</div><input name="var_dt_inativo" type="radio" class="inputclean" value="" checked>Ativo&nbsp;&nbsp;<input name="var_dt_inativo" type="radio" class="inputclean" value="<%=Date()%>">Inativo
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>