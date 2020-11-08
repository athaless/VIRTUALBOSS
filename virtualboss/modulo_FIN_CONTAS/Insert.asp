<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_CONTAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim strSQL, objRS, ObjConn
 Dim strCODIGO, strData, strRESP, arrESTADOS, arrNOMES, Cont
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
	
	if (document.form_insert.var_nome.value == '')           var_msg += '\nNome';
	if (document.form_insert.var_vlr_saldo_ini.value == '')  var_msg += '\nSaldo inicial';
	if (document.form_insert.var_dt_cadastro.value == '')    var_msg += '\nData de Cadastro';
	if (document.form_insert.var_cod_banco.value == '')      var_msg += '\nBanco';
	
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Conta Banco - Inserção") %>
<form name="form_insert" action="Insert_Exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_FIN_CONTAS/insert.asp'>
	<div class="form_label">*Nome:&nbsp;</div><input name="var_nome" type="text" style="width:230px;" maxlength="255">
	<br><div class="form_label">Tipo:&nbsp;</div><select name="var_tipo" style="width:140px;" onChange="form_insert.var_vlr_saldo_ini.focus();">
				<option value="">[selecione]</option>
				<option value="CONTA CORRENTE">Conta-corrente</option>
				<option value="CARTAO DE CREDITO">Cartão de Crédito</option>
				<option value="DINHEIRO">Dinheiro</option>
				<option value="INVESTIMENTOS">Investimentos</option>
				<option value="POUPANCA">Poupança</option>
				<option value="OUTROS">Outros</option>																								
			</select>
	<br><div class="form_label">*Saldo Inicial:&nbsp;</div><input name="var_vlr_saldo_ini" type="text" style="width:50px;" maxlength="50" onKeyPress="validateFloatKey();">
	<br><div class="form_label">*Data Cadastro:&nbsp;</div><%=InputDate("var_dt_cadastro","",Date,true)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_cadastro", "ver calendário")%><span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span>
	<br><div class="form_label">Descrição:&nbsp;</div><textarea name="var_descricao" rows="5" style="width:230px;"></textarea>
	<br><div class="form_label">Ordem:&nbsp;</div><input name="var_ordem" type="text" style="width:40px;" onKeyPress="validateNumKey();">
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Informações sobre o Banco</b><br>
		<br><div class="form_label">*Banco:</div><select name="var_cod_banco" style="width:140px;">
				<option value="">[selecione]</option>
				<%=montaCombo("STR","SELECT COD_BANCO, NOME FROM FIN_BANCO ORDER BY COD_BANCO","COD_BANCO","NOME","")%>
			</select>
		<br><div class="form_label">Agência:</div><input name="var_agencia" type="text" style="width:80px;" maxlength="50">
		<br><div class="form_label">Conta:</div><input name="var_conta" type="text" style="width:120px;" maxlength="50">
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>