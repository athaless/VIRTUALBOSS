<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS_RESP|", BuscaDireitosFromDB("modulo_BS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 520
WMD_WIDTHTTITLES = 140
' -------------------------------------------------------------------------------
Dim strSQL, objRS, ObjConn
Dim objRS1, objRS2
Dim strCODIGO, strCOD_BOLETIM, strIDEXECUTOR, strTO
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strPREV_DT_INI, strFULLCATEGORIA

strCODIGO      = GetParam("var_chavereg")
strIDEXECUTOR  = LCase(GetParam("var_ultexec"))
strCOD_BOLETIM = GetParam("var_codigo") 'COD_BOLETIM (BS_BOLETIM)

if (strIDEXECUTOR="") then strIDEXECUTOR = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

if strCODIGO<>"" then
	AbreDBConn objConn, CFG_DB 
	
	'Busca todos os dados da tarefa apenas para poder repassá-los 
	'para a InsertRespostaExec para que ela possa enviar e-mails completos
	strSQL = "SELECT" 	&_ 
				"	TT.TITULO,"				&_ 
				"	TT.ID_RESPONSAVEL," 	&_ 
				"	TT.PREV_DT_INI," 		&_ 
				"	TT.SITUACAO," 			&_
				"   TT.PRIORIDADE," 		&_ 
				"	TT.DESCRICAO,"			&_ 
				"	TC.COD_CATEGORIA," 	&_ 
				"	TC.NOME " 		&_
				"FROM" 		&_ 
				"	TL_TODOLIST TT," 		&_ 
				"	TL_CATEGORIA TC " 	&_
				"WHERE" 		&_ 
				"	TT.COD_CATEGORIA = TC.COD_CATEGORIA AND" &_
				"   TT.COD_TODOLIST = " & strCODIGO 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then
		strTITULO        = GetValue(objRS,"TITULO")
		strRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		strPREV_DT_INI   = PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)
		strFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & GetValue(objRS,"NOME")
		strDESCRICAO     = GetValue(objRS,"DESCRICAO")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
//****** Funções de ação dos botões - Início ******
function ok()			{  }
function cancelar()		{  }
function aplicar()      { document.form_insert.var_jscript_action.value = ""; submeterForm(); }
function submeterForm() { document.form_insert.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Inserção de Resposta")%>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
<form name="form_insert" action="InsertRespostaExec.asp" method="post">
<input type="hidden" name="var_chavereg"				value="<%=strCODIGO%>">
<input type="hidden" name="var_codigo"					value="<%=strCOD_BOLETIM%>">
<input type="hidden" name="var_id_responsavel"			value="<%=strRESPONSAVEL%>">
<input type="hidden" name="var_titulo"					value="<%=strTITULO%>">
<input type="hidden" name="var_descricao"				value="<%=Server.HTMLEncode(strDESCRICAO)%>">
<input type="hidden" name="var_prev_dt_ini"				value="<%=strPREV_DT_INI%>">
<input type="hidden" name="var_cod_e_desc_categoria"	value="<%=strFULLCATEGORIA%>">
<input type="hidden" name="var_jscript_action"			value='window.close()'>
<input type="hidden" name="var_location"				value='InsertResposta.asp?var_chavereg=<%=strCODIGO%>&var_codigo=<%=strCOD_BOLETIM%>&var_ultexec=<%=strIDEXECUTOR%>'>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<tr>
		<td width="<%=WMD_WIDTHTTITLES%>" style="text-align:right;" valign="middle">DE:&nbsp;</td>
		<td>
		<%
		if strRESPONSAVEL = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) then
			Response.Write strRESPONSAVEL & " - (Resp)"
			Response.Write "<input type='hidden' name='var_FROM' value='" & strRESPONSAVEL & "'>"
		elseif LCase(strIDEXECUTOR) = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) then
			Response.Write LCase(strIDEXECUTOR)
			Response.Write "<input type='hidden' name='var_FROM' value='" & LCase(strIDEXECUTOR) & "'>"
		else
			Response.Write LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & " - (Exec: " & LCase(strIDEXECUTOR) & ")"
			Response.Write "<input type='hidden' name='var_FROM' value='" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'>"
		end if
		%>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;" valign="middle">*PARA:&nbsp;</td>
		<td>
			<select name="var_TO" size="1" class="edtext" style="width:100px;"> 
				<%=montaCombo("STR","SELECT ID_USUARIO FROM BS_EQUIPE WHERE DT_INATIVO IS NULL AND COD_BOLETIM=" & strCOD_BOLETIM & " ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",lcase(strIDEXECUTOR))%>
			</select>&nbsp;<span class="texto_ajuda"><i>(membros da equipe da Atividade/BS: <%=strCOD_BOLETIM%>)</i>
		</td>					
	</tr>
	<tr> 
		<td style="text-align:right;" valign="middle">Situação:&nbsp;</td>
		<td>
		<select name="var_situacao" class="edtext" style="width:100px;">
			<option value="EXECUTANDO" selected>Executando</option>
			<option value="FECHADO">Fechado</option>
		</select>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;" valign="middle">Prioridade:&nbsp;</td>
		<td>
			<select name="var_prioridade" class="edtext" style="width:100px;">
				<option value="NORMAL" <% if GetValue(objRS,"PRIORIDADE") = "NORMAL" then Response.Write("selected") %>>NORMAL</option>
				<option value="BAIXA"  <% if GetValue(objRS,"PRIORIDADE") = "BAIXA"  then Response.Write("selected") %>>BAIXA</option>
				<option value="MEDIA"  <% if GetValue(objRS,"PRIORIDADE") = "MEDIA"  then Response.Write("selected") %>>MEDIA</option>
				<option value="ALTA"   <% if GetValue(objRS,"PRIORIDADE") = "ALTA"   then Response.Write("selected") %>>ALTA</option>
			</select>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;" valign="top">Resposta:&nbsp;</td>
		<td><textarea name="var_resposta" class="edtext" style="width:360px; height:110px"></textarea></td>
	</tr>
	<tr> 
		<td style="text-align:right;" valign="middle">Horas dispendidas:&nbsp;</td>
		<td>
			<input name="var_horas" type="text" class="edtext" style="width:40px;" maxlength="5" value="" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
			<select name="var_minutos" class="edtext" style="width:60px">
				<option value="00" selected>00 min</option>
				<option value="25">15 min</option>
				<option value="50">30 min</option>
				<option value="75">45 min</option>
			</select>
		</td>					
	</tr>
	<tr><td></td><td class="texto_ajuda"><i>Campos com <span style="font-size:8px; vertical-align:middle; width:10px;">*</span>são obrigatórios</i></td></tr>
</form>
</table>
<%=athEndDialog("", "", "", "", "", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
	end if
	FechaDBConn objConn
end if 
%>