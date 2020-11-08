<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"
 
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
function submeterForm() { document.form_insert.submit(); }
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Enquete - Inser��o")%>     
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="EN_ENQUETE">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_ENQUETE">
	<input type="hidden" name="JSCRIPT_ACTION"   	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_ENQUETE/insert.asp'>
    <div class="form_label">* T�tulo:</div><input name="DBVAR_STR_TITULO�" type="text" style="width:300px" value="" maxlength="250">
    <br><div class="form_label">Entidade:</div><select name="DBVAR_STR_TIPO_ENTIDADE�"><option value=""></option><option value="ENT_COLABORADOR">COLABORADOR</option><option value="ENT_CLIENTE">CLIENTE</option><!--option value="ENT_FORNECEDOR">FORNECEDOR</option//--></select>
    <br><div class="form_label">Qu�rum:</div><select name="DBVAR_NUM_QUORUM"><option value="0">0</option><option value="1">1</option><option value="5">5</option><option value="10">10</option><option value="25">25</option><option value="50">50</option><option value="75">75</option><option value="100">100</option></select>
    <div style="padding-left:110px;"><span class="texto_ajuda">O valores do campo Quorum, referem-se ao porcentual m�nimo de respostas para que os resultados da enquete sejam vistos por usu�rio que j� respondeu</span></div>
    <br><div class="form_label">Data In�cio:</div><%=InputDate("DBVAR_DATE_DT_INI","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_INI", "ver calend�rio")%>
    <br><div class="form_label">Data Fim:</div><%=InputDate("DBVAR_DATE_DT_FIM","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_FIM", "ver calend�rio")%>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>