<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PROJETO_BACKLOG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
    Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO
	
	strCODIGO = GetParam("var_chavereg")

	if strCODIGO<>"" then
		AbreDBConn objConn, CFG_DB 
		
		strSQL = " SELECT COD_PRJ_BACKLOG, COD_PROJETO, TITULO, DESCRICAO, TAMANHO, ROI, STATUS FROM prj_backlog WHERE COD_PRJ_BACKLOG = " & strCODIGO
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.DBVAR_STR_TITULOô.value == '') var_msg += '\nTítulo';
	if (document.form_update.DBVAR_NUM_COD_PROJETOô.value == '')  var_msg += '\nProjeto';	
	
	if (var_msg == ''){
		document.form_update.submit();
	}
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Projeto Backlog - Alteração") %>
  <form id="form_update" name="form_update" action="../_database/athUpdateToDB.asp" method="post">
  	<input type="hidden" id="DEFAULT_TABLE"		name="DEFAULT_TABLE"	 value="PRJ_BACKLOG">
  	<input type="hidden" id="DEFAULT_DB"		name="DEFAULT_DB"		 value="<%=CFG_DB%>">
    <input type="hidden" id="FIELD_PREFIX" 		name="FIELD_PREFIX" 	 value="DBVAR_">
  	<input type="hidden" id="RECORD_KEY_NAME"	name="RECORD_KEY_NAME"	 value="COD_PRJ_BACKLOG">
	<input type="hidden" id="DBVAR_DATE_SYS_DTT_ALT" 		name="DBVAR_DATE_SYS_DTT_ALT" value="<%=PrepDataBrToUni(Now, False)%>">
	<input type="hidden" id="DBVAR_STR_SYS_ID_USUARIO_ALT"  name="DBVAR_STR_SYS_ID_USUARIO_ALT" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">	
	<input type="hidden" id="DEFAULT_LOCATION"  name="DEFAULT_LOCATION" value='../modulo_PROJETO_BACKLOG/update.asp'>
	<input type="hidden" id="JSCRIPT_ACTION"    name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
  	<input type="hidden" id="RECORD_KEY_VALUE"  name="RECORD_KEY_VALUE" value="<%=GetValue(objRS, "COD_PRJ_BACKLOG")%>">	
	<div class='form_label'>*Projeto:</div><select id="DBVAR_NUM_COD_PROJETOô" name="DBVAR_NUM_COD_PROJETOô" style="width:100px;">
                           				    <option value="">[selecione]</option>
 				                            <%=montaCombo("STR"," SELECT COD_PROJETO, TITULO FROM PRJ_PROJETO ORDER BY TITULO ", "COD_PROJETO","TITULO",GetValue(objRS, "COD_PROJETO"))%>
			                              </select>
  	<br><div class='form_label'>*Título:</div><input id="DBVAR_STR_TITULOô" name="DBVAR_STR_TITULOô" type="text" style="width:300px;" value="<%=GetValue(objRS,"TITULO")%>" maxlength="255">
	<br><div class='form_label'>Descrição:</div><textarea id="DBVAR_STR_DESCRICAO" name="DBVAR_STR_DESCRICAO" style="width:350px; height:160px;"><%=GetValue(objRS,"DESCRICAO")%></textarea>
    <br><div class='form_label'>Tamanho:</div><input id="DBVAR_NUM_TAMANHO" name="DBVAR_NUM_TAMANHO" type="text" style="width:60px;" value="<%=GetValue(objRS,"TAMANHO")%>"  maxlength="10" onKeyPress="validateNumKey();">
	<br><div class='form_label'></div><span class="texto_ajuda">&nbsp;estimativa de tamanho, classificação (de 1 a 10), quantidade de horas, etc.</span>
    <br><div class='form_label'>ROI:</div><input id="DBVAR_NUM_ROI" name="DBVAR_NUM_ROI" type="text" style="width:80px;" value="<%=GetValue(objRS,"ROI")%>" maxlength="15" onKeyPress="validateNumKey();">
    <br><div class='form_label'></div><span class="texto_ajuda">&nbsp;quanto maior o ROI, maior prioridade p/ entrada em sprint,</span>
    <br><div class='form_label'></div><span class="texto_ajuda">&nbsp;seguindo recomendação para aplicação do framework SCRUM.</span> 	
    <br><div class='form_label'>Status:</div><select id="DBVAR_STR_STATUS" name="DBVAR_STR_STATUS" style="width:80px;">
										       <option value="ABERTO" 	 <%if GetValue(objRS,"STATUS") = "ABERTO" then Response.write("selected") %>>ABERTO</option>
											   <option value="CANCELADO" <%if GetValue(objRS,"STATUS") = "CANCELADO" then Response.write("selected") %>>CANCELADO</option>
											   <option value="EXECUTANDO" title="EXECUTANDO/SPRINT" <%if GetValue(objRS,"STATUS") = "EXECUTANDO" then Response.write("selected") %>>EXECUTANDO</option>
											   <option value="FECHADO"    title="FECHADO/CONCLUIDO" <%if GetValue(objRS,"STATUS") = "FECHADO" then Response.write("selected") %>>FECHADO</option>
     	                                     </select>
  </form>
<%
 response.write athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")
%>
</body>
</html>
<%
		End If
		FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>