<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PONTO_DESCONTO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim strSQL, objRS, ObjConn
 Dim strCODIGO, Cont
	
 strCODIGO = GetParam("var_chavereg")

 If strCODIGO <> "" Then
	AbreDBConn objConn, CFG_DB 
		
	strSQL =          " SELECT COD_DESCONTO, ID_USUARIO, MES, ANO, TOTAL_HR, TOTAL_MIN, OBS "
	strSQL = strSQL & " FROM PT_DESCONTO "
	strSQL = strSQL & " WHERE COD_DESCONTO = " & strCODIGO
	
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
<%=athBeginDialog(WMD_WIDTH, "Desconto - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE" value="PT_DESCONTO">
	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME" value="COD_DESCONTO">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_PONTO_DESCONTO/Update.asp?var_chavereg=<%=strCODIGO%>">
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">*Usuário:</div><select name="DBVAR_STR_ID_USUARIOô" style="width:90px;">
												<option value="">[selecione]</option>
												<%=montaCombo("STR","SELECT DISTINCT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL", "ID_USUARIO", "ID_USUARIO", GetValue(objRS, "ID_USUARIO"))%>
											   </select>
	<br><div class="form_label">*Período:</div><select name="DBVAR_NUM_MESô" style="width:100px;">
												<option value="">[selecione]</option>
												<%
													For Cont = 1 to 12
													Response.Write("<option value='" & Cont & "'")
													If CStr(GetValue(objRS, "MES")) = CStr(Cont) Then Response.Write(" selected='selected'")
														Response.Write(">" & MesExtenso(Cont) & "</option>")
													Next
												%>
											   </select><input type="text" name="DBVAR_NUM_ANOô" value="<%=GetValue(objRS, "ANO")%>" 
											    maxlength="4" style="width:40px;" onKeyPress="validateNumKey();">
											   <span class="texto_ajuda">mês/ano</span>
		<br><div class="form_label">*Horas de Desconto:</div><input name="DBVAR_NUM_TOTAL_HRô" type="text" style="width:40px;" maxlength="5" value="<%=GetValue(objRS,"TOTAL_HR")%>" onKeyPress="validateNumKey();">
															 <select name="DBVAR_NUM_TOTAL_MINô" style="width:70px" >
															  <option value="0" selected>00 min</option>
																<%
																	Cont = 5
																	Do While (Cont <= 55)
																	Response.Write("<option value='" & Cont & "'")
																	If CStr(GetValue(objRS, "TOTAL_MIN")) = CStr(Cont) Then Response.Write(" selected='selected'")
																		Response.Write(">" & Cont & " min</option>")
																		Cont = Cont + 5
																	Loop
																%>
															  </select>
		<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_OBS" rows="5"><%=GetValue(objRS, "OBS")%></textarea>
	</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
	End If 
    FechaRecordSet objRS
	FechaDBConn objConn
End If 
%>