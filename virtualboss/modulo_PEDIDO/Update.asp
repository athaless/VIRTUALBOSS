<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PEDIDO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim objConn, objRS, strSQL
	Dim strCODIGO, strNOME, strMSG
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT T1.COD_CLI AS CODIGO, T1.TIPO, T1.OBS_NF, T1.TOT_SERVICO, T1.SITUACAO, T1.DT_EMISSAO "
		strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLI_NOME "
		'strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNEC_NOME "
		'strSQL = strSQL & "      , T4.NOME AS COLAB_NOME "
		strSQL = strSQL & " FROM NF_NOTA T1 "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T2 ON (T1.COD_CLI = T2.COD_CLIENTE) "
		'strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T3 ON (T1.CODIGO = T3.COD_FORNECEDOR) "
		'strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO = T4.COD_COLABORADOR) "
		strSQL = strSQL & " WHERE COD_NF = " & strCODIGO
		
		'athDebug strSQL, False
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
			'If GetValue(objRS, "TIPO") = "ENT_CLIENTE" Then 
			strNOME = GetValue(objRS, "CLI_NOME")
			'If GetValue(objRS, "TIPO") = "ENT_FORNECEDOR" Then strNOME = GetValue(objRS, "FORNEC_NOME")
			'If GetValue(objRS, "TIPO") = "ENT_COLABORADOR" Then strNOME = GetValue(objRS, "COLAB_NOME")
			
			strMSG = ""
			If GetValue(objRS, "SITUACAO") <> "ABERTO" Then strMSG = strMSG & "Pedido em situação diferente de aberto"
			
			If strMSG <> "" Then
				Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
				Response.End()
			End If
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.DBVAR_NUM_COD_CLIô.value == '') var_msg += '\nTítulo';
	
	if (var_msg == ''){
		document.form_update.submit();
	} else{
		alert('Favor verificar campos:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update&var_input=DBVAR_NUM_COD_CLIô&var_input_tipo=DBVAR_STR_TIPO&var_tipo=' + document.form_update.DBVAR_STR_TIPO.value,'640','390');
}

function LimparCampo(prForm, prCampo) {
	eval("document." + prForm + "." + prCampo + ".value = '';");
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Pedido - Altera&ccedil;&atilde;o") %>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="NF_NOTA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_NF">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_PEDIDO/Update.asp?var_chavereg=<%=strCODIGO%>">
	<input type="hidden" name="DBVAR_STR_SITUACAO" value="ABERTO">
	<input type="hidden" name="DBVAR_DATETIME_SYS_DTT_UPD" value="<%=now()%>">
	<input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_UPD" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">*Entidade:</div><input name="DBVAR_NUM_COD_CLIô" type="text" maxlength="10" value="<%=GetValue(objRS, "CODIGO")%>" onKeyPress="validateNumKey();" style="vertical-align:bottom; width:40px;"><select name="DBVAR_STR_TIPO" size="1" style="width:185px;"><%
		 MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", GetValue(objRS, "TIPO")%></select><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
	<br><div class="form_label">Data Emissão:</div><%=InputDate("DBVAR_DATE_DT_EMISSAO","",GetValue(objRS,"DT_EMISSAO"),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_EMISSAO", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">Observação:</div><textarea name="DBVAR_STR_OBS_NF" rows="6"><%=GetValue(objRS, "OBS_NF")%></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>