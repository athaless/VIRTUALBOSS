<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_ADM_CLASSES", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim objConn, objRS, strSQL
	Dim strCODIGO
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	if strCODIGO <> "" then 
		strSQL =          " SELECT ID_CLASSE, DESCRICAO, PESO_MIN, PESO_MAX, PONTOS, DT_INATIVO "
		strSQL = strSQL & "	FROM ADM_CLASSE "
		strSQL = strSQL & " WHERE COD_CLASSE = " & strCODIGO
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRS.eof then
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
	
	if (document.form_update.DBVAR_STR_ID_CLASSEô.value == '') var_msg += '\nID Classe';
	
	if (var_msg == ''){
		document.form_update.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Classes - Altera&ccedil;&atilde;o") %>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="ADM_CLASSE">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CLASSE">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_ADM_CLASSES/Update.asp?var_chavereg=<%=strCODIGO%>">
	<input type="hidden" name="DBVAR_DATETIME_SYS_DTT_ALT"   value="<%=now()%>">
	<input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_ALT" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">ID Classe:</div><input name="DBVAR_STR_ID_CLASSEô" type="text" style="width:40px;" maxlength="10" value="<%=GetValue(objRS, "ID_CLASSE")%>">
	<br><div class="form_label">Peso Mínimo:</div><input name="DBVAR_NUM_PESO_MIN" type="text" style="width:40px;" maxlength="10" value="<%=GetValue(objRS, "PESO_MIN")%>" onKeyPress="validateNumKey();">
	<br><div class="form_label">Peso Máximo:</div><input name="DBVAR_NUM_PESO_MAX" type="text" style="width:40px;" maxlength="10" value="<%=GetValue(objRS, "PESO_MAX")%>" onKeyPress="validateNumKey();">
	<br><div class="form_label">Pontos:</div><input name="DBVAR_NUM_PONTOS" type="text" style="width:40px;" maxlength="10" value="<%=GetValue(objRS, "PONTOS")%>" onKeyPress="validateNumKey();">
	<br><div class="form_label">Descrição:</div><input name="DBVAR_STR_DESCRICAO" type="text" style="width:180px;" maxlength="250" value="<%=GetValue(objRS, "DESCRICAO")%>">
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="NULL" <%if GetValue(objRS,"DT_INATIVO")="" then Response.Write("checked") %>>Ativo
	&nbsp;&nbsp;<div class="form_label_nowidth"><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="<%=PrepData(Date,true,false)%>" <%if IsDate(GetValue(objRS,"DT_INATIVO")) and GetValue(objRS,"DT_INATIVO")<>"" then Response.Write("checked") %>>Inativo</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>