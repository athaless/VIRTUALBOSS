<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_SERVICO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
<script language="JavaScript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_insert.submit(); }
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Servi&ccedil;os - Inser&ccedil;&atilde;o")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="SV_SERVICO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_SERVICO">
	<input type="hidden" name="JSCRIPT_ACTION"   	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_FIN_SERVICO/insert.asp'>
	<div class="form_label">*T&iacute;tulo:</div><input name="DBVAR_STR_TITULO�" type="text" style="width:250px;">
	<br><div class="form_label">Descri&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_DESCRICAO" rows="6" style="width:250px;"></textarea>
	<br><div class="form_label">*Valor:</div><input name="DBVAR_MOEDA_VALOR�" type="text" style="width:60px;" maxlength="15" onKeyPress="validateFloatKey();">
	<br><div class="form_label">Al�quota ISSQN:</div><input name="DBVAR_MOEDA_ALIQ_ISSQN" type="text" style="width:60px;" maxlength="15" onKeyPress="validateFloatKey();">
	<br><div class="form_label">*Categoria:</div><select name="DBVAR_NUM_COD_CATEGORIA�" style="width:120px;">
					<option value="" selected>
					<%=MontaCombo("STR","SELECT COD_CATEGORIA, NOME FROM SV_CATEGORIA ORDER BY NOME","COD_CATEGORIA","NOME","")%>
				 </select>
	<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_OBS" rows="6" style="width:250px;"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>