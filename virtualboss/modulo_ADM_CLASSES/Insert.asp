<!--#include file="../_database/athdbConn.asp"--><%'-- ATEN��O: language, option explicit, etc... est�o no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_NF_CFG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.DBVAR_STR_ID_CLASSE�.value == '') var_msg += '\nID Classe';
	
	if (var_msg == ''){
		document.form_insert.submit();
	} else{
		alert('Favor verificar campos obrigat�rios:\n' + var_msg);
	}
}
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Classes - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="ADM_CLASSE">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CLASSE">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_ADM_CLASSES/insert.asp'>
	<input type="hidden" name="DBVAR_DATETIME_SYS_DTT_INS"   value="<%=now()%>">
	<input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<br><div class="form_label">ID Classe:</div><input name="DBVAR_STR_ID_CLASSE�" type="text" style="width:40px;" maxlength="10" value="">
	<br><div class="form_label">Peso M�nimo:</div><input name="DBVAR_NUM_PESO_MIN" type="text" style="width:40px;" maxlength="10" value="" onKeyPress="validateNumKey();">
	<br><div class="form_label">Peso M�ximo:</div><input name="DBVAR_NUM_PESO_MAX" type="text" style="width:40px;" maxlength="10" value="" onKeyPress="validateNumKey();">
	<br><div class="form_label">Pontos:</div><input name="DBVAR_NUM_PONTOS" type="text" style="width:40px;" maxlength="10" value="" onKeyPress="validateNumKey();">
	<br><div class="form_label">Descri��o:</div><input name="DBVAR_STR_DESCRICAO" type="text" style="width:180px;" maxlength="250" value="">
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="NULL" checked>Ativo
	&nbsp;&nbsp;<div class="form_label_nowidth"><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="">Inativo</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>