<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_ADM_CARGOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.DBVAR_STR_TITULOô.value == '') var_msg += '\nTítulo';
	
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
<%=athBeginDialog(WMD_WIDTH, "Cargos - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="ADM_CARGO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CARGO">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_ADM_CARGOS/insert.asp'>
	<input type="hidden" name="DBVAR_DATETIME_SYS_DTT_INS"   value="<%=now()%>">
	<input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<div class="form_label">*Título:</div><input name="DBVAR_STR_TITULOô" type="text" value="" maxlength="50" style="width:250px;">
	<br><div class="form_label">Unidade:</div><input name="DBVAR_STR_UNIDADE" type="text" value="" maxlength="250" style="width:250px;">
	<br><div class="form_label">Departamento:</div><input name="DBVAR_STR_DEPARTAMENTO" type="text" value="" maxlength="250" style="width:150px">
	<br><div class="form_label">Setor:</div><input name="DBVAR_STR_SETOR" type="text" value="" maxlength="250" style="width:150px">
	<br><div class="form_label">Superior Hierárquico:</div><input name="DBVAR_STR_SUP_HIERARQUICO" type="text" value="" maxlength="250" style="width:150px">
	<br><div class="form_label">Descrição:</div><textarea name="DBVAR_STR_DESCRICAO" rows="8"></textarea>
	<br><div class="form_label">Atividades:</div><textarea name="DBVAR_STR_ATIVIDADES" rows="7"></textarea>
	<br><div class="form_label">Qualificações:</div><textarea name="DBVAR_STR_QUALIFICACOES" rows="4"></textarea>
	<br><div class="form_label">Competências:</div><textarea name="DBVAR_STR_COMPETENCIAS" rows="4"></textarea>
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="NULL" checked>Ativo
	&nbsp;&nbsp;<div class="form_label_nowidth"><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="">Inativo</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>