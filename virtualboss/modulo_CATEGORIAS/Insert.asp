<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CATEGORIAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"
 ' -------------------------------------------------------------------------------
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function SetTable(pr_table){ document.forms[0].elements[0].value = pr_table + 'CATEGORIA'; }
//----------------------------------------------------------------------------------------------------

//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { 
	var var_msg = '';
	
	if (document.form_insert.var_table.value == '')       { var_msg += '\nTabela'; }
	if (document.form_insert.DBVAR_STR_NOME�.value == '') { var_msg += '\nCategoria'; }
	
	if (var_msg == ''){
		document.form_insert.submit();
	}else {
		alert('Favor verificar campos obrigat�rios:\n' + var_msg);
	}
}
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Categorias - Inser��o")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CATEGORIA">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_CATEGORIAS/insert.asp'>
	<div class="form_label">*Tabela:</div><select name="var_table" onChange="SetTable(this.value);">
		<option value="" selected>[tabela]</option>
		<option value="AG_">AGENDA</option>
		<option value="CH_">CHAMADOS</option>
		<option value="PT_FOLGA_">FOLGAS</option>
		<option value="PROCESSO_">PROCESSOS</option>
		<option value="ASLW_">RELAT�RIOS</option>
		<option value="SV_">SERVI�OS</option>
		<optgroup label="Project Manager">
			<option value="TL_">TAREFAS</option>
			<option value="BS_">ATIVIDADES</option>
			<option value="PRJ_">PROJETOS</option>
		</optgroup>
		<optgroup label="Biblioteca">
			<option value="MB_LIVRO_">LIVROS</option>
			<option value="MB_REVISTA_">REVISTAS</option>
			<option value="MB_MANUAL_">MANUAIS</option>
			<option value="MB_VIDEO_">V�DEOS</option>
			<option value="MB_DISCO_">DISCOS</option>
			<option value="MB_DADO_">DADOS</option>
		</optgroup>
	</select>
	<br><div class="form_label">*Categoria:</div><input name="DBVAR_STR_NOME�" type="text" style="width:160px;" value="">
	<br><div class="form_label">Descri��o:</div><textarea name="DBVAR_STR_DESCRICAO" type="text" cols="40" rows="5"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>