<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_ACCOUNT", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_insert.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Account Service - Inserção")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="ACCOUNT_SERVICE">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_ACCOUNT_SERVICE">
	<input type="hidden" name="DBVAR_DATE_SYS_DT_INS" value="<%=PrepDataBrToUni(Now, False)%>">
	<input type="hidden" name="DBVAR_STR_SYS_USR_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<input type="hidden" name="JSCRIPT_ACTION"   	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_ACCOUNT/insert.asp'>
    <div class="form_label">Grupo:</div><input name="DBVAR_STR_GRUPO" type="text" style="width:120px" maxlength="80">
	<br><div class="form_label">Fornecedor:</div><input name="DBVAR_STR_FORNECEDOR" type="text" style="width:150px" maxlength="80">
    <br><div class="form_label">*Tipo:</div><select name="DBVAR_STR_TIPOô" style="width:60px">
									          <option value="" selected>[tipo]</option>
											  <option value="ftp">ftp</option>
											  <option value="e-mail">e-mail</option>
											  <option value="vnc">vnc</option>
											  <option value="csm">csm</option>
											  <option value="arest">arest</option>
											  <option value="wsys">wsys</option>
											  <option value="odbc">odbc</option>
											  <option value="telnet">telnet</option>
											  <option value="painel">painel</option>
											  <option value="plesk">plesk</option>
											  <option value="helpdesk">helpdesk</option>
											  <option value="adsl">adsl</option>
											  <option value="ssl">ssl</option>
											  <option value="msn">msn</option>
											  <option value="icq">icq</option>
											  <option value="skype">skype</option>
											  <option value="orkut">orkut</option>
											  <option value="gazzag">gazzag</option>
											  <option value="facebook">facebook</option>
											  <option value="twitter">twitter</option>
											  <option value="bank">bank</option>
											  <option value="card">card</option>
											  <option value="db">db</option>
											  <option value="stat">stat</option>
											  <option value="outros">outros</option>
									        </select>
	<br><div class="form_label">Nome/Usr:</div><input name="DBVAR_STR_CONTA_USR" type="text" style="width:220px" maxlength="250">
	<br><div class="form_label">Senha:</div><input name="DBVAR_CRIPTO_CONTA_SENHA" type="password" style="width:100px" maxlength="50">
	<br><div class="form_label">Info Extra1:</div><input name="DBVAR_STR_CONTA_EXTRA1" type="text" style="width:250px" maxlength="50">
	<br><div class="form_label">Info Extra2:</div><input name="DBVAR_STR_CONTA_EXTRA2" type="text" style="width:250px" maxlength="50">
	<br><div class="form_label">Info Extra3:</div><input name="DBVAR_STR_CONTA_EXTRA3" type="text" style="width:250px" maxlength="50">
	<br><div class="form_label">Ender/URL:</div><input name="DBVAR_STR_ENDER_URL" type="text" style="width:200px" maxlength="250">
	<br><div class="form_label">Obs.:</div><textarea name="DBVAR_STR_OBS" rows="5" cols="60"></textarea>
	<br><div class="form_label">Ordem:</div><input name="DBVAR_NUM_ORDEM" type="text" style="width:30px">
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" class="inputclean" type="radio" value="NULL" checked>Ativo&nbsp;&nbsp; <input name="DBVAR_DATE_DT_INATIVO" class="inputclean" type="radio" value="<%=PrepDataBrToUni(Date, False)%>">Inativo
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>