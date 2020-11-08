<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PONTO_FOLGA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_insert.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Folga - Inserção") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE" value="PT_FOLGA">
	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME" value="COD_FOLGA">
	<input type="hidden" name="JSCRIPT_ACTION"   	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_PONTO_FOLGA/insert.asp'>
	<div class="form_label">*Usuário:</div><select name="DBVAR_STR_ID_USUARIOô" style="width:90px;">
											<option value="">[selecione]</option>
											<%'=montaCombo("STR","SELECT DISTINCT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL", "ID_USUARIO", "ID_USUARIO", "")%>
											<%=montaCombo("STR"," SELECT ID_USUARIO FROM USUARIO WHERE TIPO LIKE '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "' AND GRP_USER <> 'SU' AND DT_INATIVO IS NULL ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO"))%>
										   </select>
	<br><div class="form_label">*Categoria:</div><select name="DBVAR_NUM_COD_CATEGORIAô" style="width:180px;">
													<option value="">[selecione]</option>
													<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM PT_FOLGA_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME ", "COD_CATEGORIA", "NOME", "")%>
												 </select>
	<br><div class="form_label">Dt Início:</div><%=InputDate("DBVAR_DATE_DT_INI","","",false)%><%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_INI", "ver calendário")%><span class="texto_ajuda">&nbsp;dd/mm/aaaa</span>
	<br><div class="form_label">Dt Fim:</div><%=InputDate("DBVAR_DATE_DT_FIM","","",false)%><%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_FIM", "ver calendário")%><span class="texto_ajuda">&nbsp;dd/mm/aaaa</span>
	<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_OBS" rows="5"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>