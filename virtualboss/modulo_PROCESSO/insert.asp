<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PROCESSO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_id_processo.value == '')    var_msg += '\nID Processo';
	if (document.form_insert.var_cod_categoria.value == '')  var_msg += '\nCategoria';
	if (document.form_insert.var_nome.value == '')           var_msg += '\nNome';
	if (document.form_insert.var_autores.value == '')        var_msg += '\nAutores';
	if (document.form_insert.var_descricao.value == '')      var_msg += '\nDescrição';
	
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Processos - Inserção")%>
<form name="form_insert" action="insert_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='insert.asp'>
	<div class='form_label'>*ID do Processo:</div><input name="var_id_processo" type="text" style="width:150px" value="">
	<br><div class='form_label'>*Categoria:</div><select name="var_cod_categoria">
													<option value="">Selecione</option>
			<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM PROCESSO_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME ", "COD_CATEGORIA", "NOME", "")%>
												 </select> 
	<br><div class='form_label'>*Nome:</div><textarea name="var_nome" rows="4" cols="30"></textarea>
	<br><div class='form_label'>*Autores:</div><textarea name="var_autores" rows="4" cols="30"></textarea>
	<br><div class='form_label'>*Descrição:</div><textarea name="var_descricao" rows="6" cols="40"></textarea> 
	<br><div class='form_label'>Data:</div><%=InputDate("var_data","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_data", "ver calendário")%><%if Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER" OR Request.Cookies("VBOSS")("GRUPO_USUARIO") = "SU" then%>
	<br><div class='form_label'>Homologado:</div><%=InputDate("var_dt_homologacao","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_homologacao", "ver calendário")%>
  	<%end if%>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>