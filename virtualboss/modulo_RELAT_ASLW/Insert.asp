<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_RELAT_ASLW", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.radExecDefault.checked) {
		document.form_insert.var_executor.value = 'ExecASLW.asp';
	}
	else {
		document.form_insert.var_executor.value = document.form_insert.var_executor_outro.value;
	}
	
	if (document.form_insert.var_nome.value == '') var_msg += '\nNome';
	
	if (var_msg == ''){
		document.form_insert.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Relatório - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="Insert_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='insert.asp'>
	<input type="hidden" name="var_executor" value="">
	<div class="form_label">Categoria:</div><select name="var_cod_categoria">
												<option value="">Selecione...</option>
												<% montaCombo "STR", " SELECT COD_CATEGORIA, NOME FROM ASLW_CATEGORIA ORDER BY NOME ", "COD_CATEGORIA", "NOME", "" %>
											</select>
	<br><div class="form_label">*Nome:</div><input name="var_nome" type="text" value="" style="width:240px;">
	<br><div class="form_label">Descrição:</div><textarea name="var_descricao" cols="50" rows="5"></textarea>
	<br><div class="form_label">*Executor:</div><input type="radio" name="radExec" id="radExecDefault" value="" checked class="inputclean">Default<input name="var_executor_aslw" type="text" style="width:90px;" readonly="readonly" value="ExecASLW.asp"><img src="../img/bt_execSQL_disabled.gif" width="13" height="17" alt="Testar SQL" title="Testar SQL" style="vertical-align:bottom; padding-bottom:2px;" vspace="0" hspace="0" border="0" onClick="alert('Você deve gravar esse ASL para poder testar.')">
	<br><div class="form_label">&nbsp;</div><input type="radio" name="radExec" id="radExecOutro" value="" class="inputclean">Outro<input name="var_executor_outro" type="text" value="<Digite seu relatório>" style="width:180px;"><img src="../img/bt_execSQL_disabled.gif" width="13" height="17" alt="Testar" title="Testar" style="vertical-align:bottom; padding-bottom:2px;" vspace="0" hspace="0" border="0" onClick="alert('Você deve gravar esse ASL para poder testar.')">
	<br><div class="form_label">Parâmetro:</div><textarea name="var_parametro" cols="50" rows="20"></textarea><br>
    <br><div class="texto_ajuda" style="padding-left:110px; padding-right:20px;">
    	<div>Consulta SQL que permite a colocação de variáveis ambiente em Session ou Cookies (com o uso de chaves { }) e parâmetros de filtragem (com o uso de colchetes [ ])<br> 
	        <b>Ex.:</b> SELECT * FROM usuario WHERE id_usuario like '{ID_USUARIO}%'  AND cod_usuario > [mincoduser] 
        </div> 
	<br><div class="form_label">Status:</div> <input name="var_dt_inativo" type="radio" value="NULL" class="inputclean" checked>Ativo&nbsp;&nbsp;<input name="var_dt_inativo" type="radio" value="<%=Date()%>" class="inputclean">Inativo
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>