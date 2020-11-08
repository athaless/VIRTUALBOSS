<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PONTO_FOLGA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO
	
	strCODIGO = GetParam("var_chavereg")

	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSQL =          "SELECT T1.COD_FOLGA, T1.ID_USUARIO, T1.DT_INI, T1.DT_FIM, T1.COD_CATEGORIA, T1.OBS "
		strSQL = strSQL & "  FROM PT_FOLGA T1"
		strSQL = strSQL & " WHERE T1.COD_FOLGA = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
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
function aplicar() 	{ document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Folga - Alteração") %>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE" value="PT_FOLGA">
	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME" value="COD_FOLGA">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PONTO_FOLGA/Update.asp?var_chavereg=<%=strCODIGO%>'>
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">*Usuário:</div><select name="DBVAR_STR_ID_USUARIOô" style="width:90px;">
												<option value="">[selecione]</option>
												<%'=montaCombo("STR","SELECT DISTINCT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL", "ID_USUARIO", "ID_USUARIO", GetValue(objRS, "ID_USUARIO"))%>
											    <%=montaCombo("STR"," SELECT ID_USUARIO FROM USUARIO WHERE TIPO LIKE '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "' AND GRP_USER <> 'SU' AND DT_INATIVO IS NULL ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", GetValue(objRS, "ID_USUARIO"))%>
											   </select>
	<br><div class="form_label">*Categoria:</div><select name="DBVAR_NUM_COD_CATEGORIAô" style="width:180px;">
													<option value="">[selecione]</option>
													<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM PT_FOLGA_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME ", "COD_CATEGORIA", "NOME", GetValue(objRS, "COD_CATEGORIA"))%>
												 </select>
	<br><div class="form_label">Dt Início:</div><%=InputDate("DBVAR_DATE_DT_INI","",PrepData(GetValue(objRS, "DT_INI"), True, False),false)%><%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_INI", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">Dt Fim:</div><%=InputDate("DBVAR_DATE_DT_FIM","",PrepData(GetValue(objRS, "DT_FIM"), True, False),false)%><%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_FIM", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_OBS" rows="5"><%=GetValue(objRS, "OBS")%></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If 
	    FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>