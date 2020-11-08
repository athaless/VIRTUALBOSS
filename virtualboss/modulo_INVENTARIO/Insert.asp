<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_INVENTARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Inventário - Inserção")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    		value="INVENTARIO">
	<input type="hidden" name="DEFAULT_DB"       		value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     		value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  		value="COD_INVENTARIO">
	<input type="hidden" name="DBVAR_DATE_SYS_DT_INS"   value="<%= Date()%>">
	<input type="hidden" name="DBVAR_STR_SYS_USR_INS"   value="<%=request.Cookies("VBOSS")("ID_USUARIO")%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_INVENTARIO/insert.asp'>
    <div class="form_label">ID:</div><input name="DBVAR_STR_ID_ITEM" type="text" style="width:120px" maxlength="50">
    <br><div class="form_label">Nome:</div><input name="DBVAR_STR_NOME_ITEM" type="text" style="width:220px" maxlength="255">
    <br><div class="form_label">Descrição:</div><textarea name="DBVAR_STR_DESC_ITEM" rows="5" cols="60"></textarea>
    <br><div class="form_label">Owner:</div><input name="DBVAR_STR_PROPRIEDADE" type="text" style="width:150px" maxlength="80" value="">
	<br><div class="form_label">Divisão/Área:</div><input name="DBVAR_STR_DIVISAO" type="text" style="width:150px" maxlength="80">
	<br><div class="form_label">Tipo:</div><select name="DBVAR_STR_TIPO" style="width:150px">
        									<option value="" selected>[tipo]</option>
											<option value="VEICULO">VEÍCULO (VU 5)</option>
											<option value="MOVEIS">MÓVEIS (VU 10)</option>
											<option value="IMOVEL">IMÓVEL (VU 25)</option>
											<option value="HARDWARE">HARDWARE (VU 10)</option>
											<option value="SOFTWARE">SOFTWARE (VU 1)</option>
											<option value="OUTROS">OUTROS (VU ~)</option>
	 									   </select>
    <br><div class="form_label">Marca:</div><input name="DBVAR_STR_MARCA" type="text" style="width:220px" maxlength="50">
	<br><div class="form_label">Local da Compra:</div><input name="DBVAR_STR_LOCAL_COMPRA" type="text" style="width:250px" maxlength="50">
	<br><div class="form_label">Preço da Compra ou Avaliação:</div><input name="DBVAR_MOEDA_PRC_COMPRA" type="text" style="width:60px" maxlength="10" onKeyPress="validateFloatKey();">
	<br><div class="form_label">Data da Compra ou Avaliação:</div><%=InputDate("DBVAR_DATE_DT_COMPRA","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_COMPRA", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
    <br><div class="form_label">Data da Garantia:</div><%=InputDate("DBVAR_DATE_DT_GARANTIA","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_GARANTIA", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
    <br><div class="form_label">Obs.:</div><textarea name="DBVAR_STR_OBS" rows="5" cols="60"></textarea>
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="NULL" checked>Ativo&nbsp;&nbsp;<input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="<%=Date()%>">Inativo
	<br><div class="form_label">Anexo:</div><input name="DBVAR_STR_ARQUIVO_ANEXO" type="text" readonly="readonly" maxlength="250" value="" style="width:160px;"><a href="javascript:UploadArquivo('form_insert','DBVAR_STR_ARQUIVO_ANEXO', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//INVENTARIO_Anexos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a><span class="texto_ajuda">&nbsp; Anexo.</span>		
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>