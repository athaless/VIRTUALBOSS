<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_MENU", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
	if (document.form_insert.var_cod_menu_pai.value == '') { var_msg += '\nMenu Pai' };
	if (var_msg == ''){ document.form_insert.submit(); }
	else { alert('Favor verificar campos obrigatórios:\n' + var_msg); }
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Menu Principal - Inserção")%>
<form name="form_insert" action="Insert_Exec.asp" method="post">
<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_MENU/insert.asp'>
<div class='form_label'>*Menu Pai:</div><input name="var_cod_menu_pai" type="text" style="width:35px"><a style="cursor:pointer;" onClick="AbreJanelaPAGE('BuscaPorMenu.asp?var_form=form_insert&var_campo=var_cod_menu_pai','540','360');"><img src="../img/BtBuscar.gif" title="Pesquisar" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
<br><div class='form_label'>Rótulo:</div><input name="var_rotulo" type="text" style="width:150px" maxlength="80">
<br><div class='form_label'>Link:</div><textarea name="var_link" rows="4" cols="30"></textarea>
<!--
<br><div class='form_label'>Módulo:</div><select name="var_id_app">
    <option value="" selected>[selecione]</option>
	<% 'montacombo "STR", " SELECT DISTINCT ID_APP FROM SYS_APP_DIREITO ", "ID_APP", "ID_APP", "" %>
	</select>
-->
<br><div class='form_label'>Imagem:</div><input name="var_img" type="text" style="width:150px">
<br><div class='form_label'>Ordem:</div><input name="var_ordem" type="text" style="width:50px">
<br><div class='form_label'>Status:</div><input name="var_dt_inativo" type="radio" class="inputclean" value="NULL" checked>
	<div class='form_label_nowidth'>Ativo</div><input name="var_dt_inativo" type="radio" class="inputclean" value="<%=Date()%>">
	<div class='form_label_nowidth'>Inativo</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>