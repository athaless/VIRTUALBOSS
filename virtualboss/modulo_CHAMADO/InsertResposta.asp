<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS_RESP|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, objRSPARA, ObjConn
Dim objRS1, objRS2
Dim strCODIGO, strIDEXECUTOR, strTO
Dim strTITULO, strRESPONSAVEL, strEXECUTOR, strDESCRICAO, strPREV_DT_INI, strFULLCATEGORIA, strCOD_BOLETIM
Dim bUpload

strCODIGO     = GetParam("var_chavereg")
strIDEXECUTOR = LCase(GetParam("var_ultexec"))

bUpload = VerificaDireito("|UPLOAD|", BuscaDireitosFromDB("modulo_RESPOSTA", Request.Cookies("VBOSS")("ID_USUARIO")), false)

if (strIDEXECUTOR="") then strIDEXECUTOR = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	'Busca todos os dados da tarefa apenas para poder repassá-los 
	'para a InsertRespostaExec para que ela possa enviar e-mails completos
	strSQL = "SELECT TT.TITULO, TT.ID_RESPONSAVEL, TT.PREV_DT_INI, TT.SITUACAO " &_
			 "     , TT.COD_BOLETIM ,TT.PRIORIDADE, TT.DESCRICAO, TC.COD_CATEGORIA, TC.NOME, TT.ID_ULT_EXECUTOR " &_
			 " FROM TL_TODOLIST TT, TL_CATEGORIA TC " &_
			 " WHERE TT.COD_CATEGORIA = TC.COD_CATEGORIA AND TT.COD_TODOLIST = " & strCODIGO 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then
		strTITULO        = GetValue(objRS,"TITULO")
		strRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		strEXECUTOR      = LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))
		strPREV_DT_INI   = GetValue(objRS,"PREV_DT_INI")
		strFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & GetValue(objRS,"NOME")
		strDESCRICAO     = GetValue(objRS,"DESCRICAO")
		strCOD_BOLETIM   = GetValue(objRS,"COD_BOLETIM")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
//****** Funções de ação dos botões - Início ******
function ok() { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_to.value == '') var_msg += '\nPara';
	if (document.form_insert.var_resposta.value == '') var_msg += '\nResposta';
	
	if (var_msg == ''){
		document.form_insert.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Atendimento - Inserção de Resposta")%>
<form name="form_insert" action="InsertRespostaExec.asp" method="post">
	<input type="hidden" name="var_chavereg"             value="<%=strCODIGO%>">
	<input type="hidden" name="var_id_responsavel"       value="<%=strRESPONSAVEL%>">
	<input type="hidden" name="var_titulo"               value="<%=strTITULO%>">
	<input type="hidden" name="var_descricao"            value="<%=Server.HTMLEncode(strDESCRICAO)%>">
	<input type="hidden" name="var_prev_dt_ini"          value="<%=strPREV_DT_INI%>">
	<input type="hidden" name="var_cod_e_desc_categoria" value="<%=strFULLCATEGORIA%>">
	<input type="hidden" name="JSCRIPT_ACTION"           value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION"         value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<div class="form_label">DE:</div><div class="form_bypass"><%	
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
	<br><div class="form_label">*PARA:</div><select name="var_to" size="1" style="width:100px;">
				<%
				' Mostra somente os usuários no combo PARA (encaminhamento da resposta), 
				' que estiveram envolvidos em respostas anteriores desta tarefa e ATIVOS
				strSQL =          " SELECT DISTINCT T1.ID_FROM AS ID_USUARIO, T2.APELIDO " 
				strSQL = strSQL & "   FROM TL_RESPOSTA T1, USUARIO T2 "
				strSQL = strSQL & "  WHERE T1.COD_TODOLIST = " & strCODIGO & " AND T1.ID_FROM <> '" & strRESPONSAVEL & "' "
				strSQL = strSQL & "    AND T1.ID_FROM = T2.ID_USUARIO "
				strSQL = strSQL & "    AND T2.DT_INATIVO IS NULL "
				strSQL = strSQL & " UNION "
				strSQL = strSQL & " SELECT DISTINCT T1.ID_TO AS ID_USUARIO, T2.APELIDO "
				strSQL = strSQL & "   FROM TL_RESPOSTA T1, USUARIO T2 "
				strSQL = strSQL & "  WHERE T1.COD_TODOLIST = " & strCODIGO & " AND T1.ID_TO <> '" & strRESPONSAVEL & "' "
				strSQL = strSQL & "    AND T1.ID_TO = T2.ID_USUARIO "
				strSQL = strSQL & "    AND T2.DT_INATIVO IS NULL "
				strSQL = strSQL & " ORDER BY 2 "
				
				'ATENÇÂO Esta parte (abaixo) não chegou a ser acionada, pois o departamento de atendimento desidiu que antes de 
				'inativar alguém deve mesmo repassar seus chamados abertos para um outro atendente ativo
				
				' ... mas, no caso todos eles estejam já inativos, então o sistema mostra 
				' outros usuários colaboradores em geral, caso contrário o cliente
				' fica sem opção de para quem encaminhar a resposta
				'AbreRecordSet objRSPARA, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
				'if (objRSPARA.Eof) then
				'	strSQL = strSQL & " SELECT DISTINCT ID_USUARIO, APELIDO "
				'	strSQL = strSQL & "   FROM USUARIO "
				'	strSQL = strSQL & "  WHERE TIPO LIKE 'ENT_COLABORADOR' "
				'	strSQL = strSQL & "    AND DT_INATIVO IS NULL "
				'	strSQL = strSQL & "    AND GRP_USER NOT LIKE 'SU' "
				'	strSQL = strSQL & " ORDER BY 2 "
				'end if
				'FechaRecordSet objRSPARA

				Response.Write montaCombo("STR", strSQL,"ID_USUARIO","APELIDO",strEXECUTOR)
				%>
			</select>
	<br><div class="form_label">Situação:</div><select name="var_situacao" style="width:100px;">
			<option value="EXECUTANDO" selected>Executando</option>
			<option value="FECHADO">Fechado</option>
		</select>
	<br><div class="form_label">Prioridade:</div><select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" <% if GetValue(objRS,"PRIORIDADE")="NORMAL" then Response.Write("selected") %>>NORMAL</option>
				<option value="BAIXA"  <% if GetValue(objRS,"PRIORIDADE")="BAIXA"  then Response.Write("selected") %>>BAIXA</option>
				<option value="MEDIA"  <% if GetValue(objRS,"PRIORIDADE")="MEDIA"  then Response.Write("selected") %>>MEDIA</option>
				<option value="ALTA"   <% if GetValue(objRS,"PRIORIDADE")="ALTA"   then Response.Write("selected") %>>ALTA</option>
			</select>
	<br><div class="form_label">*Resposta:</div><textarea name="var_resposta" rows="8" style="width:340px;"></textarea>
	<br><div class="form_label">Sigiloso:</div><textarea name="var_sigiloso" rows="4" style="width:340px;"></textarea>
	<div style="padding-left:110px;"><span class="texto_ajuda"><i>Este campo será visualizado por seu autor e pelo executor da tarefa</i></span></div>
	<% If bUpload Then %>
		<br><div class='form_label'>Anexo:</div><input name="var_arquivo_anexo" type="text" maxlength="250" value="" style="width:122px;"><a href="javascript:UploadArquivo('form_insert','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//RESPOSTA_Anexos');"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
	<% End If %>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
	end if
	FechaDBConn objConn
end if 
%>