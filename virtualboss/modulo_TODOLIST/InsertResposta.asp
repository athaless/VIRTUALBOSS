<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS_RESP|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, objRSAux, ObjConn
Dim strCODIGO, strIDEXECUTOR, strTO, strGRUPO
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strPREV_DT_INI, strFULLCATEGORIA, strCOD_BOLETIM
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
			 "     , TT.COD_BOLETIM ,TT.PRIORIDADE, TT.DESCRICAO, TC.COD_CATEGORIA, TC.NOME " &_
			 " FROM TL_TODOLIST TT, TL_CATEGORIA TC " &_
			 " WHERE TT.COD_CATEGORIA = TC.COD_CATEGORIA AND TT.COD_TODOLIST = " & strCODIGO 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then
		strTITULO        = GetValue(objRS,"TITULO")
		strRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
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
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_to.value == '')        var_msg += '\nPara';
	if (document.form_insert.var_resposta.value == '')  var_msg += '\nResposta';
	
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Inserção de Resposta")%>
<form name="form_insert" action="InsertRespostaExec.asp" method="post">
	<input type="hidden" name="var_chavereg"             value="<%=strCODIGO%>">
	<input type="hidden" name="var_cod_boletim"          value="<%=strCOD_BOLETIM%>">
	<input type="hidden" name="var_id_responsavel"       value="<%=strRESPONSAVEL%>">
	<input type="hidden" name="var_titulo"               value="<%=strTITULO%>">
	<input type="hidden" name="var_descricao"            value="<%=Server.HTMLEncode(strDESCRICAO)%>">
	<input type="hidden" name="var_prev_dt_ini"          value="<%=strPREV_DT_INI%>">
	<input type="hidden" name="var_cod_e_desc_categoria" value="<%=strFULLCATEGORIA%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='InsertResposta.asp?var_chavereg=<%=strCODIGO%>'>
	<div class='form_label'>DE:</div><div class="form_bypass"><%	
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
	<br><div class='form_label'>*PARA:</div><select name="var_to" size="1" style="width:100px;">
			<%
			' Se ELE é o RESP então o combo PARA deve estar com o EXECUTOR selecionado (intervensão)
			' Se ELE é EXECUTOR então o combo PARA deve estar com o EXECUTOR selecionado
			
 			'Busca os usuários colegas do usuário logado e também os colegas do responsável 
			'do TODO(que no caso de chamados serão colegas da empresa cliente)
			if strCOD_BOLETIM = "" then
				strSQL = "         SELECT DISTINCT ID_USUARIO "
				strSQL = strSQL & "  FROM USUARIO "
				strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
				strSQL = strSQL & "   AND (TIPO = '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "' "
				strSQL = strSQL & "        OR ( "
				strSQL = strSQL & "             TIPO   = (SELECT TIPO FROM USUARIO WHERE ID_USUARIO='" & strRESPONSAVEL & "') AND "
				strSQL = strSQL & "             CODIGO = (SELECT CODIGO FROM USUARIO WHERE ID_USUARIO='" & strRESPONSAVEL & "') "
				strSQL = strSQL & "           ) "
				strSQL = strSQL & "       ) "
				strSQL = strSQL & " ORDER BY TIPO DESC, ID_USUARIO "
				response.write montaCombo("STR",strSQL,"ID_USUARIO","ID_USUARIO",lcase(strIDEXECUTOR))
			else
  			   'Se o TODO pertence A UM BS/ATIVIDADE então busca só os membros da equipe
			   response.write montaCombo("STR","SELECT ID_USUARIO FROM BS_EQUIPE WHERE DT_INATIVO IS NULL AND COD_BOLETIM=" & strCOD_BOLETIM & " ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",lcase(strIDEXECUTOR))
			end if
			%>
			</select>
	<br><div class='form_label'>Situação:</div><select name="var_situacao" style="width:100px;">
			<option value="EXECUTANDO" selected>Executando</option>
			<option value="ESPERA">Espera</option>
            <!-- Colocar uma tarefa Em ESPERA só é permitido pra atendentes, na inserção de 
                 resposta disponibilizada para o cliente não tem essa opção, sendo assim 
                 quando ele responde uma tarefa que esta em espera ela automaticamente 
                 passa a voltar para o estao EXECUTANDO.
            //-->
			<option value="CANCELADO">Cancelado</option>
            <!-- Marcar um ToDo como CANCELADO só é permitido pra atendentes, na inserção de 
                 resposta disponibilizada para o cliente não deve ter essa opção,
            //-->
			<option value="FECHADO">Fechado</option>
		</select>
	<br><div class='form_label'>Prioridade:</div><select name="var_prioridade" style="width:100px;">
			<option value="NORMAL" <% if GetValue(objRS,"PRIORIDADE")="NORMAL" then Response.Write("selected") %>>NORMAL</option>
			<option value="BAIXA"  <% if GetValue(objRS,"PRIORIDADE")="BAIXA"  then Response.Write("selected") %>>BAIXA</option>
			<option value="MEDIA"  <% if GetValue(objRS,"PRIORIDADE")="MEDIA"  then Response.Write("selected") %>>MEDIA</option>
			<option value="ALTA"   <% if GetValue(objRS,"PRIORIDADE")="ALTA"   then Response.Write("selected") %>>ALTA</option>
		</select>
	<br><div class='form_label'>*Resposta:</div><textarea name="var_resposta" rows="8" style="width:340px;"></textarea>
	<br><div class='form_label'>Sigiloso:</div><textarea name="var_sigiloso" rows="4" style="width:340px;"></textarea>
	<div style="padding-left:110px;"><span class="texto_ajuda"><i>Informe aqui dados sigilosos para a resposta.<br />Este campo será visualizado pelo executor da tarefa.</i></span></div>
	<div class='form_label'>Horas dispendidas:</div><input name="var_horas" type="text" maxlength="5" style="width:40px;" onKeyPress="validateNumKey();">h<select name="var_minutos" style="width:70px;">
				<option value="00" selected>00 min</option>
				<option value="05">03 min</option>
				<option value="10">06 min</option>
				<option value="25">15 min</option>
				<option value="50">30 min</option>
				<option value="75">45 min</option>
			</select>
	<% If bUpload Then %>
		<br><div class='form_label'>Anexo:</div><input name="var_arquivo_anexo" type="text" maxlength="250" value="" style="width:122px;"><a href="javascript:UploadArquivo('form_insert','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//RESPOSTA_Anexos');"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
	<% End If %>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
	end if
	FechaDBConn objConn
end if 
%>