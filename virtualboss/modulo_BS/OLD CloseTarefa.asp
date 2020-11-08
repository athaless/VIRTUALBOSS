<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS_RESP|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 500
WMD_WIDTHTTITLES = 100
' -------------------------------------------------------------------------------
Dim strSQL, objRS, ObjConn
Dim objRS1, objRS2
Dim strCODIGO, strIDEXECUTOR, strTO, strSITUACAO, strPRIORIDADE
Dim strTITULO, strRESPONSAVEL, strDESCRICAO, strPREV_DT_INI, strFULLCATEGORIA, bFechar

strCODIGO     = GetParam("var_chavereg")
strIDEXECUTOR = LCase(GetParam("var_ultexec"))

if (strIDEXECUTOR="") then strIDEXECUTOR = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	' - Buscva todos os dados da tarefa apenas para poder repassá-los 
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
		strSITUACAO      = GetValue(objRS,"SITUACAO")
		strPRIORIDADE    = GetValue(objRS,"PRIORIDADE")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
//****** Funções de ação dos botões - Início ******
function ok()			{ document.formclose.var_location.value = ""; submeterForm(); }
function cancelar()		{ window.close(); }
function aplicar()      {  }
function submeterForm() { document.formclose.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Resposta para Fechamento")%>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
<form name="formclose" action="CloseTarefaExec.asp" method="post">
	<input type="hidden" name="var_chavereg"             value="<%=strCODIGO%>">
	<input type="hidden" name="var_id_responsavel"       value="<%=strRESPONSAVEL%>">
	<input type="hidden" name="var_titulo"               value="<%=strTITULO%>">
	<input type="hidden" name="var_prioridade"           value="<%=strPRIORIDADE%>">
	<input type="hidden" name="var_descricao"            value="<%=Server.HTMLEncode(strDESCRICAO)%>">
	<input type="hidden" name="var_prev_dt_ini"          value="<%=strPREV_DT_INI%>">
	<input type="hidden" name="var_cod_e_desc_categoria" value="<%=strFULLCATEGORIA%>">
	<input type="hidden" name="var_situacao"             value="FECHADO">
	<input type="hidden" name="var_jscript_action"		 value='window.close()'>
	<input type="hidden" name="var_location"			 value=''>
	<tr> 
		<td width="<%=WMD_WIDTHTTITLES%>" style="text-align:right;">Título:&nbsp;</td>
		<td><%=strTITULO%></td>
	</tr>
	<tr> 	                         
		<td style="text-align:right;">DE:&nbsp;</td>
		<td>
		<%	
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
		%>
		</td>
	</tr>
	<input type="hidden" name="var_to" value="<%=strRESPONSAVEL%>">
	<tr> 
		<td style="text-align:right;">PARA:&nbsp;</td>
		<td><strong><%=strRESPONSAVEL%></strong>&nbsp;<span class="texto_ajuda">Resposta enviada para o responsável</span>
		<!--
			<select name="var_TO" size="1" style="width:100px;">
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",strIDEXECUTOR)%>
			</select>
		-->
		</td>
	</tr>
	<!--
	<tr> 
		<td style="text-align:right;">Prioridade:&nbsp;</td>
		<td>
			<select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" <% 'if GetValue(objRS,"PRIORIDADE")="NORMAL" then Response.Write("selected") %>>NORMAL</option>
				<option value="BAIXA"  <% 'if GetValue(objRS,"PRIORIDADE")="BAIXA"  then Response.Write("selected") %>>BAIXA</option>
				<option value="MEDIA"  <% 'if GetValue(objRS,"PRIORIDADE")="MEDIA"  then Response.Write("selected") %>>MEDIA</option>
				<option value="ALTA"   <% 'if GetValue(objRS,"PRIORIDADE")="ALTA"   then Response.Write("selected") %>>ALTA</option>
			</select>
		</td>
	</tr>
	-->
	<tr> 
		<td style="text-align:right;" valign="top">*Resposta:&nbsp;</td>
		<td><textarea name="var_resposta" style="width:380px; height:110px;"></textarea></td>
	</tr>
	<!--
	<tr> 
		<td style="text-align:right;" valign="top">Sigiloso:&nbsp;</td>
		<td><textarea name="var_sigiloso" style="width:380px; height:80px;"></textarea><br><span class="texto_ajuda"><i>Este campo será visualizado por seu autor e pelo executor da tarefa</i></span></td>
	</tr>
	<tr> 
		<td style="text-align:right;">Horas dispendidas:&nbsp;</td>
		<td><input name="var_horas" type="text" maxlength="5" style="width:40px;" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
	<select name="var_minutos" style="width:70px;">
		<option value="00" selected>00 min</option>
		<option value="25">15 min</option>
		<option value="50">30 min</option>
		<option value="75">45 min</option>
	</select>
		</td>
	</tr>
	-->
	<tr> 
		<td style="text-align:right;">Data Realizado:&nbsp;</td>
		<td><%=PrepData(Now, True, False)%>&nbsp;<span class="texto_ajuda">(hoje)</span></td>
	</tr>
	<tr><td></td><td class="texto_ajuda"><i>Campos com <span style="font-size:8px; vertical-align:middle; width:10px;">*</span>são obrigatórios</i></td></tr>
</form>
</table>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
	end if
	FechaDBConn objConn
end if 
%>