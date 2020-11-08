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
<%=athBeginDialog(WMD_WIDTH, "Histórico de Colaborador - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="ENT_HISTORICO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_HISTORICO">
	<input type="hidden" name="DBVAR_NUM_CODIGO" value="<%=strCODIGO%>">
	<input type="hidden" name="DBVAR_STR_TIPO"   value="ENT_COLABORADOR">
	<input type="hidden" name="DBVAR_AUTODATE_SYS_DTT_INS" value="">
	<input type="hidden" name="DBVAR_STR_SYS_USR_INS"      value="<%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_COLABORADOR/InsertHistorico.asp?var_codigo=<%=strCODIGO%>'>
	<div class="form_label">*Comentário:</div><textarea name="DBVAR_STR_TEXTO" rows="14" style="width:340px;"></textarea>
   	<br><div class="form_label">Anexo:</div><input name="DBVAR_STR_ARQUIVO_ANEXO" type="text" readonly="readonly" maxlength="250" value="" style="width:160px;"><a href="javascript:UploadArquivo('form_insert','DBVAR_STR_ARQUIVO_ANEXO', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//COLABORADOR_Anexos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a><span class="texto_ajuda">&nbsp;</span>		
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
FechaDBConn objConn
%>