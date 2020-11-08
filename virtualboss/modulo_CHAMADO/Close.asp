<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|CLOSE|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, ObjConn
Dim objRS1, objRS2
Dim strCODIGO, strIDEXECUTOR, strTO, strLOCAL, strPRIORIDADE
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strPREV_DT_INI, strFULLCATEGORIA

strCODIGO = GetParam("var_chavereg")
strIDEXECUTOR = LCase(GetParam("var_ultexec"))
strLOCAL = GetParam("var_local")

if (strIDEXECUTOR="") then strIDEXECUTOR = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	'Busca todos os dados da tarefa apenas para poder repassá-los 
	'para a InsertRespostaExec para que ela possa enviar e-mails completos
	strSQL = "SELECT TT.TITULO, TT.ID_RESPONSAVEL, TT.PREV_DT_INI, TT.SITUACAO" &_
				"   ,TT.COD_BOLETIM ,TT.PRIORIDADE, TT.DESCRICAO, TC.COD_CATEGORIA, TC.NOME " &_
				"FROM TL_TODOLIST TT, TL_CATEGORIA TC " &_
				"WHERE TT.COD_CATEGORIA = TC.COD_CATEGORIA AND TT.COD_TODOLIST = " & strCODIGO 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then
		strTITULO        = GetValue(objRS,"TITULO")
		strRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		strPREV_DT_INI   = GetValue(objRS,"PREV_DT_INI")
		strFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & GetValue(objRS,"NOME")
		strDESCRICAO     = GetValue(objRS,"DESCRICAO")
		strPRIORIDADE    = GetValue(objRS,"PRIORIDADE")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_close.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_close.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { 
	var var_msg = '';
	
	if (document.form_close.var_resposta.value == '') var_msg += '\nResposta';
	
	if (var_msg == ''){
		document.form_close.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Atendimento - Resposta para Fechamento")%>
<form name="form_close" action="Close_Exec.asp" method="post">
	<input type="hidden" name="var_chavereg"             value="<%=strCODIGO%>">
	<input type="hidden" name="var_id_responsavel"       value="<%=strRESPONSAVEL%>">
	<input type="hidden" name="var_titulo"               value="<%=strTITULO%>">
	<input type="hidden" name="var_situacao"             value="FECHADO">
	<input type="hidden" name="var_prioridade"           value="<%=strPRIORIDADE%>">
	<input type="hidden" name="var_descricao"            value="<%=Server.HTMLEncode(strDESCRICAO)%>">
	<input type="hidden" name="var_prev_dt_ini"          value="<%=strPREV_DT_INI%>">
	<input type="hidden" name="var_cod_e_desc_categoria" value="<%=strFULLCATEGORIA%>">
	<input type="hidden" name="var_local"                value="<%=strLOCAL%>">
	<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_CHAMADO/default.htm'>
	<div class="form_label">Título:</div><div class="form_bypass"><%=strTITULO%></div>
	<br><div class="form_label">DE:</div><div class="form_bypass"><%	
		if strRESPONSAVEL = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) then
			Response.Write strRESPONSAVEL & " - (Resp)"
			Response.Write "<input type='hidden' name='var_from' value='" & strRESPONSAVEL & "'>"
		elseif LCase(strIDEXECUTOR) = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) then
			Response.Write LCase(strIDEXECUTOR)
			Response.Write "<input type='hidden' name='var_from' value='" & LCase(strIDEXECUTOR) & "'>"
		else
			Response.Write LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & " - (Exec: " & LCase(strIDEXECUTOR) & ")"
			Response.Write "<input type='hidden' name='var_from' value='" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'>"
		end if
		%></div>
	<input type="hidden" name="var_to" value="<%=strRESPONSAVEL%>">
	<br><div class="form_label">PARA:&nbsp;</div><div class="form_bypass"><strong><%=strRESPONSAVEL%></strong>&nbsp;<span class="texto_ajuda">Resposta enviada para o responsável</span></div>
	<br><div class="form_label">*Resposta</div><textarea name="var_resposta" style="width:380px; height:100px;"></textarea>
	<br><div class="form_label">Data Realizado:</div><div class="form_bypass"><%=PrepData(Now, True, False)%>&nbsp;<span class="texto_ajuda">(hoje)</span></div>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
	end if
	FechaDBConn objConn
end if 
%>