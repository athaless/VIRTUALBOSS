<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Dim objConn , objRS, strSQL
	Dim strCODIGO
	
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

strCODIGO = Getparam("var_codigo")
 
AbreDBConn objConn, CFG_DB

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
function submeterForm() { document.form_insert.submit(); }
//****** Funções de ação dos botões - Fim ******

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Questão - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="EN_QUESTAO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_QUESTAO">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_ENQUETE/InsertEnquete.asp?var_codigo=<%=strCODIGO%>'>
   	<br><div class="form_label">Enquete:</div><select name='DBVAR_NUM_COD_ENQUETE' id='DBVAR_NUM_COD_ENQUETE' style='width:150px;'><option value='' selected></option><%=montaCombo("STR","SELECT COD_ENQUETE, TITULO FROM EN_ENQUETE ", "COD_ENQUETE", "TITULO", "") %></select>
    <br><div class="form_label">Ordem:</div><input name="DBVAR_NUM_ORDEM" type="text" maxlength="2" value="" style="width:30px;">
    <br><div class="form_label">Questão:</div><input name="DBVAR_STR_QUESTAO" type="text" maxlength="250" value="" style="width:200px;">
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
FechaDBConn objConn
%>