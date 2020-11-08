<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|ATENDE|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO! Você está prestes a confirmar o início de atendimento para este chamado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]"
 Const auxERRO   = "dlg_error.gif:Chamado em situação diferente de ABERTO.<br> Para sair clique em [cancelar]"
 'CONFIRMA O INÍCIO DO ATENDIMENTO PARA ESTE CHAMADO?<br>Preencha os campos abaixo e confirme a ação!"

	Dim objConn, objRS, objRSAux, strSQL
	Dim strCODIGO, strTOTAL, strNOME, strAUX
	Dim Cont, strVALOR
	Dim strCOD_CATEGORIA, strCATEGORIA
	Dim strDESCRICAO1, strDESCRICAO2, strSIGILOSO1, strSIGILOSO2
	Dim strDESBLOQUEIO1, strDESBLOQUEIO2, strSITUACAO
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT COD_CATEGORIA, NOME "
		strSQL = strSQL & "   FROM TL_CATEGORIA "
		strSQL = strSQL & "  WHERE NOME LIKE 'CHAMADO' "
		
		Set objRS = objConn.Execute(strSQL)
		
		strCOD_CATEGORIA = ""
		strCATEGORIA = ""
		If Not objRS.Eof Then
			strCOD_CATEGORIA = GetValue(objRS, "COD_CATEGORIA")
			strCATEGORIA = GetValue(objRS, "NOME")
		End If
		
		FechaRecordSet objRS
		
		strSQL =          " SELECT T1.TITULO, T1.DESCRICAO, T1.SIGILOSO, T1.PRIORIDADE, T1.ARQUIVO_ANEXO, T1.HORAS, T1.SYS_ID_USUARIO_INS, T1.SITUACAO, T1.EXTRA "
		strSQL = strSQL & "      , T2.COD_CLIENTE, T2.NOME_FANTASIA AS CLIENTE "
		strSQL = strSQL & "      , T3.NOME AS CATEGORIA, T3.COD_CATEGORIA "
		strSQL = strSQL & "      , T1.SYS_ID_USUARIO_DESBLOQUEIO, T1.SYS_DTT_DESBLOQUEIO, T1.DESBLOQUEIO, T1.DESBLOQUEIO_SIGI "
		strSQL = strSQL & "  FROM CH_CHAMADO T1, ENT_CLIENTE T2, CH_CATEGORIA T3 "
		strSQL = strSQL & " WHERE T1.COD_CLI = T2.COD_CLIENTE "
		strSQL = strSQL & "   AND T1.COD_CATEGORIA = T3.COD_CATEGORIA "
		strSQL = strSQL & "   AND T1.COD_CHAMADO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
			'Estes dados são repassados pra próxima página
			strDESCRICAO1 = Replace(GetValue(objRS, "DESCRICAO"),"""","&quot;")
			strSIGILOSO1  = Replace(GetValue(objRS, "SIGILOSO"),"""","&quot;")
			strSITUACAO   = GetValue(objRS, "SITUACAO")

			
			'Estes dados são exibidos na tela
			strDESCRICAO2   = Replace(GetValue(objRS, "DESCRICAO"),Chr(13),"<br>")
			strSIGILOSO2    = Replace(GetValue(objRS, "SIGILOSO"),Chr(13),"<br>")
			strDESBLOQUEIO1 = Replace(GetValue(objRS, "DESBLOQUEIO"),Chr(13),"<br>")
			strDESBLOQUEIO2 = Replace(GetValue(objRS, "DESBLOQUEIO_SIGI"),Chr(13),"<br>")
			
			strDESCRICAO2   = Replace(strDESCRICAO2,"<ASLW_APOSTROFE>","'")
			strSIGILOSO2    = Replace(strSIGILOSO2,"<ASLW_APOSTROFE>","'")
			strDESBLOQUEIO1 = Replace(strDESBLOQUEIO1,"<ASLW_APOSTROFE>","'")
			strDESBLOQUEIO2 = Replace(strDESBLOQUEIO2,"<ASLW_APOSTROFE>","'")
			
			strDESCRICAO2   = Replace(strDESCRICAO2, "''", "'")
			strSIGILOSO2    = Replace(strSIGILOSO2, "''", "'")
			strDESBLOQUEIO1 = Replace(strDESBLOQUEIO1, "''", "'")
			strDESBLOQUEIO2 = Replace(strDESBLOQUEIO2, "''", "'")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { }
function submeterForm() { 
	var var_msg = '';
	
	if (document.form_insert.var_chavereg.value == '') var_msg += '\nParâmetro inválido para chamado';
	if (document.form_insert.var_titulo.value == '') var_msg += '\nInformar título';
	if (document.form_insert.var_from.value == '') var_msg += '\nInformar solicitante';
	if (document.form_insert.var_to.value == '') var_msg += '\nInformar executor';
	if (document.form_insert.var_prev_dt_ini.value == '') var_msg += '\nInformar previsão de início';
	if (document.form_insert.var_cod_categoria.value == '') var_msg += '\nInformar código da categoria';
	if (document.form_insert.var_prioridade.value == '') var_msg += '\nInformar prioridade';
	if (document.form_insert.var_descricao.value == '') var_msg += '\nInformar descrição do chamado';
	if (document.form_insert.var_resposta.value == '') var_msg += '\nInformar resposta';
	
	if (var_msg == '') 
		document.form_insert.submit(); 
	else {
		alert('Verificar mensagens:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Chamado - Atendimento")%>
<form name="form_insert" action="Atende_Chamado_Exec.asp" method="post">
	<%
	'Como pedido da equipe de atendimento, o parâmetro EXTRA do chamado (que vem apartir da 
	'LOGIN EXTERNA), deve ser repassado para o TODO, então a opção foi concatená-lo a descrição e titulo (onde pode truncar) do mesmo
	strAUX = GetValue(objRS, "TITULO")
	IF (GetValue(objRS,"EXTRA")<>"") THEN
	  strDESCRICAO1 = "(" & GetValue(objRS, "EXTRA") & ")<br>" & strDESCRICAO1
	  strAUX		= GetValue(objRS, "TITULO") & " (" & GetValue(objRS, "EXTRA") & ")"
	END IF
	%>
	<input type="hidden" name="var_chavereg"		 value="<%=strCODIGO%>">
	<input type="hidden" name="var_titulo"			 value="<%=Replace(strAUX,"""","''")%>">
	<input type="hidden" name="var_from"			 value="<%=LCase(GetValue(objRS, "SYS_ID_USUARIO_INS"))%>">
	<input type="hidden" name="var_to"				 value="<%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%>">
	<input type="hidden" name="var_cod_categoria"	 value="<%=strCOD_CATEGORIA%>"> 
	<input type="hidden" name="var_categoria"	     value="<%=strCATEGORIA%>">
	<input type="hidden" name="var_descricao"		 value="<%=strDESCRICAO1%>">
	<input type="hidden" name="var_sigiloso"		 value="<%=strSIGILOSO1%>">
	<input type="hidden" name="var_arquivo_anexo"	 value="<%=GetValue(objRS, "ARQUIVO_ANEXO")%>">
	<input type="hidden" name="var_prioridade"		 value="NORMAL">
	<input type="hidden" name="var_cod_cli"			 value="<%=GetValue(objRS, "COD_CLIENTE")%>">
	<input name="JSCRIPT_ACTION" type="hidden"		 value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input name="DEFAULT_LOCATION" type="hidden" 	 value=''>
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Dados do Chamado</b><br>
		<br><div class="form_label">Cliente:</div><div class="form_bypass"><%=GetValue(objRS, "COD_CLIENTE")%> - <%=GetValue(objRS, "CLIENTE")%></div>
		<br><div class="form_label">Título:</div><div class="form_bypass"><%=GetValue(objRS, "TITULO")%></div>
		<br><div class="form_label">Categoria:</div><div class="form_bypass"><%=GetValue(objRS, "CATEGORIA")%></div>
		<br><div class="form_label">Descrição:</div><div class="form_bypass_multiline"><%=strDESCRICAO2%></div>
		<br><div class="form_label">Sigiloso:</div><div style="margin-left:115px; margin-right:20px; text-align:left;"><%=strSIGILOSO2%></div>
		<br><div class="form_label">Prioridade:</div><div class="form_bypass"><%=GetValue(objRS, "PRIORIDADE")%></div>
		<%
		If GetValue(objRS, "ARQUIVO_ANEXO") <> "" Then %>
			<br><div class="form_label">Arquivo Anexo:</div><div class="form_bypass"><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=GetValue(objRS,"ARQUIVO_ANEXO")%>" target="_blank" style="cursor:hand;"><%=GetValue(objRS, "ARQUIVO_ANEXO")%></a><% 
		End If
		%></div>
	</div>
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Dados para o Atendimento</b><br>
		<br><div class="form_label">*De:</div><div class="form_bypass"><%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%></div>
		<br><div class="form_label">*Para:</div><div class="form_bypass"><%=LCase(GetValue(objRS, "SYS_ID_USUARIO_INS"))%></div>
		<% If GetValue(objRS, "SYS_ID_USUARIO_DESBLOQUEIO") <> "" Then %>
			<br><div class="form_label">Desbloqueado por:</div><div class="form_bypass"><%=GetValue(objRS, "SYS_ID_USUARIO_DESBLOQUEIO")%>, em <%=PrepData(GetValue(objRS, "SYS_DTT_DESBLOQUEIO"), True, True)%></div>
			<br><div class="form_label">Comentário:</div><div style="margin-left:115px; margin-right:20px; text-align:left;"><%=strDESBLOQUEIO1%></div>
			<% If UCase(CStr(Request.Cookies("VBOSS")("ID_USUARIO"))) = UCase(CStr(GetValue(objRS, "SYS_ID_USUARIO_DESBLOQUEIO"))) Then %>
				<br><div class="form_label">Sigiloso:</div><div style="margin-left:115px; margin-right:20px; text-align:left;"><%=strDESBLOQUEIO2%></div>
			<% End If %>
			<% If CDbl("0" & GetValue(objRS, "HORAS")) > 0 Then %>
				<br><div class="form_label">Horas liberadas:</div><div class="form_bypass"><%=FormataHoraNumToHHMM(GetValue(objRS, "HORAS"))%></div>
			<% End If %>
		<% End If %>
		<br><div class="form_label">Data Prevista:</div><%=InputDate("var_prev_dt_ini", "", PrepData(Date, True, False),false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_prev_dt_ini", "ver calendário")%>
			<select name="var_prev_hr_ini_hora" size="1" style="width:40px">
				<option value="" selected="selected"></option>
				<% 
				For Cont = 0 to 23
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'>" & strVALOR & "</option>")
				Next
				%>
			</select>
			<select name="var_prev_hr_ini_min" size="1" style="width:60px;">
				<option value="" selected="selected"></option>
				<%
				Cont = 0
				Do While (Cont <= 55)
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'>" & strVALOR & " min</option>")
					Cont = Cont + 5
				Loop
				%>
			</select>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa hh:mm</i></span>		
		<br><div class="form_label">Prev. Horas:</div><select name="var_prev_horas" size="1" style="width:40px">
			<option value="" selected="selected"></option>
			<% 
			For Cont = 0 to 23
				If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
				Response.Write("<option value='" & strVALOR & "'>" & strVALOR & "</option>")
			Next
			%>
			</select><select name="var_prev_minutos" size="1" style="width:60px;">
				<option value="" selected="selected"></option>
				<option value="00">00 min</option>
				<option value="25">15 min</option>
				<option value="50">30 min</option>
				<option value="75">45 min</option>
			</select>
		<br><div class="form_label">*Categoria:</div><select name="var_cod_nova_categoria" style="width:100px;">
			<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM CH_CATEGORIA ORDER BY NOME ","COD_CATEGORIA","NOME",GetValue(objRS,"COD_CATEGORIA"))%>
		</select>
		<br><div class="form_label">*Resposta:</div><textarea name="var_resposta" rows="5" style="width:305px;"></textarea>
		<br><div class="form_label">Sigiloso:</div><textarea name="var_resposta_secreta" rows="3" style="width:305px;"></textarea>
		<br><div class='form_label'>Horas:</div><select name="var_horas_real" size="1" style="width:40px">
			<option value="" selected="selected"></option>
			<% 
			For Cont = 0 to 23
				If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
				Response.Write("<option value='" & strVALOR & "'>" & strVALOR & "</option>")
			Next
			%>
			</select><select name="var_minutos_real" size="1" style="width:60px;">
				<option value="" selected="selected"></option>
				<option value="00">00 min</option>
				<option value="25">15 min</option>
				<option value="50">30 min</option>
				<option value="75">45 min</option>
			</select>&nbsp;<span class="texto_ajuda">&nbsp;<i>Tempo dispendido</i></span>
		</div>
</form>
<%
 if (strSITUACAO = "ABERTO") then
   response.write (athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", ""))
 else
   response.write (athEndDialog(auxERRO, "", "", "../img/butxp_cancelar.gif", "cancelar();", "", ""))
 end if
%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>
