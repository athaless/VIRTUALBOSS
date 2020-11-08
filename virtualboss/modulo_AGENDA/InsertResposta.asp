<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, ObjConn
Dim objRS1, objRS2
Dim strCODIGO, strIDCITADOS, strTO
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strPREV_DT_INI, strFULLCATEGORIA 
Dim strCITADOS

strCODIGO    = GetParam("var_chavereg")
strIDCITADOS = GetParam("var_ultexec")

if (strIDCITADOS="") then strIDCITADOS = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

if strCODIGO<>"" then
	AbreDBConn objConn, CFG_DB 
	' Busca todos os dados da tarefa apenas para poder repassá-los 
	' para a InsertRespostaExec para que ela possa enviar e-mails completos
	strSQL = "SELECT" 					&_
				"	T1.TITULO," 			&_
				"	T1.ID_RESPONSAVEL," 	&_
				"	T1.ID_CITADOS," 		&_
				"	T1.PREV_DT_INI," 		&_
				"	T1.SITUACAO," 			&_
				"   T1.PRIORIDADE," 		&_
				"	T1.DESCRICAO," 		&_
				"	T2.COD_CATEGORIA," 	&_
				"	T2.NOME " 				&_
				"FROM" 						&_
				"	AG_AGENDA T1," 		&_
				"	AG_CATEGORIA T2 " 	&_
				"WHERE"	 					&_
			 	"	T1.COD_CATEGORIA = T2.COD_CATEGORIA AND" &_
			 	"	T1.COD_AGENDA=" & strCODIGO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.Eof then
		strTITULO        = GetValue(objRS,"TITULO")
		strRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		strPREV_DT_INI   = GetValue(objRS,"PREV_DT_INI")
		strFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & GetValue(objRS,"NOME")
		strDESCRICAO     = GetValue(objRS,"DESCRICAO")
		strCITADOS 		  = LCase(GetValue(objRS,"ID_CITADOS")) 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_id_citados.value == '') var_msg += '\nCitados';
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Agenda - Inserção de Resposta")%>
<form name="form_insert" action="InsertRespostaExec.asp" method="post">
	<!-- input type="hidden" name="JSCRIPT_ACTION"   		 value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 		 value='InsertResposta.asp' -->
	<input type="hidden" name="var_chavereg"             value="<%=strCODIGO%>">
	<input type="hidden" name="var_id_responsavel"       value="<%=strRESPONSAVEL%>">
	<input type="hidden" name="var_titulo"               value="<%=strTITULO%>">
	<input type="hidden" name="var_DESCRICAO"            value="<%=Server.HTMLEncode(strDESCRICAO)%>">
	<input type="hidden" name="var_PREV_DT_INI"          value="<%=strPREV_DT_INI%>">
	<input type="hidden" name="var_cod_e_desc_categoria" value="<%=strFULLCATEGORIA%>">
	<input type="hidden" name="var_FROM"                 value="<%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%>">
	    <div class='form_label'>DE:</div><div class="form_bypass"><%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%></div>
	<br><div class='form_label'>*Citados:</div><textarea name="var_id_citados" rows="3" style="width:260px;"><%=strCITADOS%></textarea><a href="#" onClick="JavaScript:AbreJanelaPAGE('BuscaPorUsuario.asp?var_form=form_insert','600','350');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:bottom; padding-bottom:4px;" vspace="0" hspace="0"></a>
	<br><div class='form_label'>Situação:</div><select name="var_situacao" style="width:100px;">
				<option value="ABERTO"  <% if GetValue(objRS,"SITUACAO")="ABERTO"  then Response.Write("selected") %>>ABERTO</option>
				<option value="FECHADO" <% if GetValue(objRS,"SITUACAO")="FECHADO" then Response.Write("selected") %>>FECHADO</option>
			</select>
	<br><div class='form_label'>Prioridade:</div><select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" <% if GetValue(objRS,"PRIORIDADE")="NORMAL" then Response.Write("selected") %>>NORMAL</option>
				<option value="BAIXA"  <% if GetValue(objRS,"PRIORIDADE")="BAIXA"  then Response.Write("selected") %>>BAIXA</option>
				<option value="MEDIA"  <% if GetValue(objRS,"PRIORIDADE")="MEDIA"  then Response.Write("selected") %>>MEDIA</option>
				<option value="ALTA"   <% if GetValue(objRS,"PRIORIDADE")="ALTA"   then Response.Write("selected") %>>ALTA</option>
			</select>
	<br><div class='form_label'>Data Fechamento:</div><%=InputDate("var_dt_realizado","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_realizado", "ver calendário")%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span>
	<br><div class='form_label'>Resposta:</div><textarea name="var_resposta" style="width:300px; height:120px;"></textarea>
	<br><div class='form_label'>Horas dispendidas:</div><input name="var_horas" type="text" maxlength="5" style="width:40px;" onKeyPress="validateNumKey();">&nbsp;h&nbsp;<select name="var_minutos" style="width:70px;">
				<option value="00" selected>00 min</option>
				<option value="25">15 min</option>
				<option value="50">30 min</option>
				<option value="75">45 min</option>
			</select>
</form>
<%=athEndDialog(auxAVISO, "", "", "", "", "../img/butxp_aplicar.gif", "aplicar();")%>
<%'=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
	end if
	FechaDBConn objConn
end if 
%>