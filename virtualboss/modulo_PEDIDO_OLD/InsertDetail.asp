<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PEDIDO_OLD", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 
 Dim strCODIGO
 
 strCODIGO = GetParam("var_chavereg")
 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function aplicar()      { submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	//if (document.form_insert.DBVAR_STR_TITULOô.value == '') var_msg += '\nTítulo';
	//if ((document.form_insert.DBVAR_NUM_NUM_PARC.value == '1') && (document.form_insert.DBVAR_STR_FREQUENCIA.value != '')) var_msg += '\nNúmero de parcelas e freqüência não conferem';
	//if ((document.form_insert.DBVAR_NUM_NUM_PARC.value != '1') && (document.form_insert.DBVAR_STR_FREQUENCIA.value == '')) var_msg += '\nNúmero de parcelas e freqüência não conferem';
	
	if (var_msg == ''){
		document.form_insert.submit();
	} else{
		alert('Favor verificar campos:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
function BuscaEntidade() {
	if ((document.form_insert.DBVAR_NUM_CODIGO.value != '') && (document.form_insert.var_nome.value == ''))
		AbreJanelaPAGE('BuscaEntidadeUm.asp?var_chavereg=' + document.form_insert.DBVAR_NUM_CODIGO.value + '&var_tipo=' + document.form_insert.DBVAR_STR_TIPO.value + '&var_form=form_insert&var_input1=DBVAR_NUM_CODIGO&var_input2=DBVAR_STR_TIPO&var_input3=var_nome','300','200');
	else
		AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input1=DBVAR_NUM_CODIGO&var_input2=DBVAR_STR_TIPO&var_input3=var_nome','640','390');
}

function BuscaServico1() {	
	AbreJanelaPAGE('BuscaServicoUm.asp?var_chavereg=' + document.form_insert.var_cod_servico.value + '&var_input1=var_cod_servico&var_input2=var_nome&var_input3=var_descricao&var_input4=var_valor&var_form=form_insert','70','40');
}

function BuscaServico2() {	
	AbreJanelaPAGE('BuscaServico.asp?var_input1=var_cod_servico&var_input2=var_nome&var_input3=var_descricao&var_input4=var_valor&var_form=form_insert','760','390');
}

function LimparCampo(prForm, prCampo) {
	eval("document." + prForm + "." + prCampo + ".value = '';");
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Item de Pedido - Inser&ccedil;&atilde;o")%>
<form name="form_insert" action="InsertDetail_Exec.asp" method="post">
	<input type="hidden" name="var_cod_pedido" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PEDIDO_OLD/insert.asp'>
	<div class="form_label">Serviço:</div><input name="var_cod_servico" type="text" style="width:30px;" value="" onChange="LimparCampo('form_insert', 'var_nome');" onKeyPress="validateNumKey();" maxlength="5"><input name="var_nome" type="text" value="" maxlength="250" style="width:250px;"><a href="Javascript:void(0);" onClick="JavaScript:BuscaServico2();"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">Descrição:</div><input name="var_descricao" type="text" value="" maxlength="250" style="width:290px;">
	<br><div class="form_label">Valor:</div><input name="var_valor" type="text" value="" maxlength="10" style="width:50px" onKeyPress="validateFloatKey();">
</form>
<%=athEndDialog(auxAVISO, "", "", "", "", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>