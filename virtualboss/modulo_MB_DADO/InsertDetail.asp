<!--#include file="../_database/athdbConn.asp"--><%'-- ATEN��O: language, option explicit, etc... est�o no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_MB_DADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Const WMD_WIDTH   = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 	Const auxAVISO    = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"
	Dim   auxContador, objConn, strCODIGO
	
	strCODIGO = GetParam("var_chavereg")
	
	AbreDBConn objConn, CFG_DB
	
	'Inicializa��o de Vari�veis
	'auxContador = 0
%>
<html>
	<head>
		<title>vboss</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
		<script language="JavaScript" type="text/javascript">
			//****** Fun��es de a��o dos bot�es - In�cio ******
			function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
			function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
			function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
			
			function submeterForm() {
				var var_msg = '';
				if (document.form_insert.DBVAR_STR_TITULO�.value   == '')  var_msg += '\n T�tulo';
			
				if (var_msg == ''){ document.form_insert.submit(); } 
				else{ alert('Favor verificar campos obrigat�rios:\n' + var_msg); }
			}
			//****** Fun��es de a��o dos bot�es - Fim ******
		</script>
	</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Item Dado - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="MB_DADO_ITEM">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_DADO_ITEM">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_MB_DADO/DetailHistorico.asp?var_chavereg=<%=strCODIGO%>'>
	<input type="hidden" name="DBVAR_NUM_COD_DADO"   value="<%=strCODIGO%>"/>
	<div class="form_label">Cod. DADO:</div><div class="form_bypass"><b><%=strCODIGO%></b></div>
	<br><div class="form_label">*T�tulo:</div><input name="DBVAR_STR_TITULO�" type="text" style="width:270px;" maxlength="200" value="">
	<br><div class="form_label">Extra:</div><input name="DBVAR_STR_EXTRA" type="text" style="width:150px;" maxlength="50" value="">
	<br><div class="form_label">Tamanho:</div><input name="DBVAR_STR_TAMANHO" type="text" style="width:150px;" maxlength="20" />
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>