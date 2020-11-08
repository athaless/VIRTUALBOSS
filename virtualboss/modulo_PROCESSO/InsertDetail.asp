<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PROCESSO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim objRS1, objRS2
	Dim strCODIGO, strIDEXECUTOR, strTO
    Dim strTITULO, strRESPONSAVEL, strTAREFA, strDT_AGENDADO, strFULLCATEGORIA 
	
	strCODIGO = GetParam("var_chavereg")
%>
<html>
<head>
	<title>vboss</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
	<script language="JavaScript" type="text/javascript">
		//****** Funções de ação dos botões - Início ******
		function aplicar()      { submeterForm(); }
		function submeterForm() { document.form_insert.submit(); }
		//****** Funções de ação dos botões - Fim ******
		function UploadImage(formname,fieldname, dir_upload){
			var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
			window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
		}
	</script>	
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Tarefa de Processo - Inserção")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="PROCESSO_TAREFA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_TAREFA">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PROCESSO/DetailHistorico.asp?var_chavereg=<%=strCODIGO%>'>
	<input type="hidden" name="DBVAR_NUM_COD_PROCESSO"   value="<%=strCODIGO%>"/>
	<div class="form_label">Cod. Processo:</div><div class="form_bypass"><b><%=strCODIGO%></b></div>
	<br><div class='form_label'>*Número:</div><input name="DBVAR_NUM_NUMEROô" type="text" size="10">
	<br><div class='form_label'>*O que:</div><textarea name="DBVAR_STR_DESC_OQUEô" style="width:250px;height:100px"></textarea>
	<br><div class='form_label'>*Quem:</div><input name="DBVAR_STR_DESC_QUEMô" type="text" size="25">
	<br><div class='form_label'>*Quando:</div><input name="DBVAR_STR_DESC_QUANDOô" type="text" size="15">
	<br><div class='form_label'>Complementar:</div><input name="DBVAR_STR_COMPLEMENTAR" type="text">
	<br><div class='form_label'>Anexo:</div><input name="DBVAR_STR_ARQ_ANEXO" type="text" maxlength="255"><a href="javascript:UploadImage('form_insert','DBVAR_STR_ARQ_ANEXO', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"><img src="../img/BtUpload.gif" border="0" align="absmiddle"></a>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->

<!--form name="form_insert" action="insert_proctarefa_exec.asp" method="post">
	<input type="hidden" name="var_cod_processo" value="<'%=strCODIGO%>">
		<div class='form_label'>*Número:</div><input name="var_numero" type="text" size="10">
		<br><div class='form_label'>*O que:</div><textarea name="var_oque" style="width:250px;height:100px"></textarea>
		<br><div class='form_label'>*Quem:</div><input name="var_quem" type="text" size="25">
		<br><div class='form_label'>*Quando:</div><input name="var_quando" type="text" size="15">
		<br><div class='form_label'>Complementar:</div><input name="var_complementar" type="text">
		<br><div class='form_label'>Anexo:</div><input name="var_arquivo_anexo" type="text" maxlength="255"><a href="javascript:UploadImage('form_insert','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"><img src="../img/BtUpload.gif" border="0" align="absmiddle"></a>
</form>
<'%=athEndDialog(auxAVISO, "", "", "", "", "../img/butxp_aplicar.gif", "aplicar();")%-->
</body>
</html>