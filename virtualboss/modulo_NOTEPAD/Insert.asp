<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%'
  ' Este módulo será LIVRE de direitos - todo mundo pode inserir, atualizar e deletar suas anotações
  ' VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_NOTEPAD", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	/*if (document.form_insert.var_nome.value == '')        var_msg += '\nNome';*/
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
/*-------------------------------------------------------------------------------------------------------------------------------------*/
function InsereTodos(prExec) {
	document.form_insert.action="BuscaTodosUsuarios.asp?var_exec=" + prExec + "&var_grupo=" + document.form_insert.var_grupo.value + "&var_form=form_insert&var_campo=DBVAR_STR_USUARIOS&var_pagina=../_database/athInsertToDB.asp";
	document.form_insert.target="ins_todos";
	document.form_insert.submit();
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Anotações - Inserção")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    		value="NOTEPAD">
	<input type="hidden" name="DEFAULT_DB"       		value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     		value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  		value="COD_NOTEPAD">
	<input type="hidden" name="DBVAR_DATETIME_SYS_DTT_INS"  value="<%=Now()%>">
	<input type="hidden" name="DBVAR_STR_ID_USUARIO"    value="<%=request.Cookies("VBOSS")("ID_USUARIO")%>">
	<input type="hidden" name="JSCRIPT_ACTION"          value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION"        value='../modulo_NOTEPAD/insert.asp'>
    <br><div class="form_label">Título:</div><input name="DBVAR_STR_TITULO" type="text" style="width:250px" maxlength="255">
    <br><div class="form_label">Descrição:</div><textarea name="DBVAR_STR_TEXTO" rows="12" style="width:350px"></textarea>
	<br><div class="form_label">Local/Tipo:</div><select name="DBVAR_STR_TIPO" style="width:70px">
											<option value="LEFT" selected>LEFT</option>
											<option value="TOP">TOP</option>
											<option value="BOTTOM">BOTTOM</option>
	 									   </select //-->
	<br><div class="form_label">Publicar:&nbsp;</div>
	<a href="#2" onClick="JavaScript:InsereTodos('T');"><img src="../img/BtBuscarTodos.gif" border="0" style="vertical-align:bottom; padding-bottom:2px;" vspace="0" hspace="0"></a><iframe name="ins_todos" width="0" height="0" src="BuscaTodosUsuarios.asp" frameborder="0"></iframe>
	<select name="var_grupo" style="width:180px;">
		<option value="ENT_COLABORADOR">Colaboradores</option>
		<% montaCombo "STR", " SELECT DISTINCT T2.COD_CLIENTE, T2.NOME_COMERCIAL FROM USUARIO T1, ENT_CLIENTE T2 WHERE T1.DT_INATIVO IS NULL AND T1.CODIGO = T2.COD_CLIENTE AND T1.TIPO = 'ENT_CLIENTE' ORDER BY T2.NOME_COMERCIAL ", "COD_CLIENTE", "NOME_COMERCIAL", "" %>
	</select>
	<br><div class="form_label"></div><textarea name="DBVAR_STR_USUARIOS" rows="4" style="width:350px;"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>