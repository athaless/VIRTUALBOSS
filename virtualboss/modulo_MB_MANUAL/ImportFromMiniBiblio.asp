<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|IMPORT|", BuscaDireitosFromDB("modulo_MB_MANUAL", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Const WMD_WIDTH   = 540 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO    = "dlg_warning.gif:ATENÇÃO!Você está prestes importar registros de arquivos do MiniBiblio. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

	Dim   auxContador, objConn
	
	AbreDBConn objConn, CFG_DB
	
	'Inicialização de Variáveis
	'auxContador = 0
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
			
			function submeterForm() {
				var var_msg = '';
				if (document.form_insert.DBVAR_STR_ARQUIVO.value == '') var_msg += '\n Arquivo';
				
				if (var_msg == ''){ document.form_insert.submit(); } 
				else{ alert('Favor verificar campos obrigatórios:\n' + var_msg); }
			}
			//****** Funções de ação dos botões - Fim ******
		</script>
	</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Manual - Importação (MiniBiblio)") %>
<form name="form_insert" action="ImportFromMiniBiblio_exec.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="MB_MANUAL">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_MANUAL">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_MB_MANUAL/data.asp'>
	<input type="hidden" name="DBVAR_DATETIME_SYS_DTT_INS"   value="<%=now()%>">
	<input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<br><div class="form_label">Arquivo:</div><input name="DBVAR_STR_ARQUIVO" type="text" maxlength="250" value="" style="width:200px;">
	<a href="javascript:UploadArquivo('form_insert','DBVAR_STR_ARQUIVO', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//');">
	<img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>&nbsp;<span class="texto_ajuda">(buffer_manuais.dbb)</span>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
  FechaDBConn objConn
%>
