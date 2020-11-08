<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|DESBLOQUEIA|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO! Você está prestes a liberar o atendimento para este chamado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]"
 'CONFIRMA O INÍCIO DO ATENDIMENTO PARA ESTE CHAMADO?<br>Preencha os campos abaixo e confirme a ação!"

	Dim objConn, objRS1, objRS2, strSQL
	Dim strCODIGO, strTOTAL, strNOME
	Dim Cont, strVALOR
	Dim strCOD_CATEGORIA, strCATEGORIA
	Dim strDESCRICAO1, strDESCRICAO2, strSIGILOSO1, strSIGILOSO2
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT COD_CATEGORIA, NOME "
		strSQL = strSQL & " FROM TL_CATEGORIA "
		strSQL = strSQL & " WHERE NOME LIKE 'CHAMADO' "
		
		Set objRS1 = objConn.Execute(strSQL)
		
		strCOD_CATEGORIA = ""
		strCATEGORIA = ""
		If Not objRS1.Eof Then
			strCOD_CATEGORIA = GetValue(objRS1, "COD_CATEGORIA")
			strCATEGORIA = GetValue(objRS1, "NOME")
		End If
		
		FechaRecordSet objRS1
		
		strSQL =          " SELECT T1.TITULO, T1.DESCRICAO, T1.SIGILOSO, T1.PRIORIDADE, T1.ARQUIVO_ANEXO, T1.COD_CATEGORIA "
		strSQL = strSQL & "      , T1.SYS_ID_USUARIO_INS, T2.COD_CLIENTE, T2.NOME_FANTASIA AS CLIENTE "
		strSQL = strSQL & "      , T3.NOME AS CATEGORIA "
		strSQL = strSQL & " FROM CH_CHAMADO T1, ENT_CLIENTE T2, CH_CATEGORIA T3 "
		strSQL = strSQL & " WHERE T1.COD_CLI = T2.COD_CLIENTE "
		strSQL = strSQL & " AND T1.COD_CATEGORIA = T3.COD_CATEGORIA "
		strSQL = strSQL & " AND T1.COD_CHAMADO = " & strCODIGO
		
		Set objRS1 = objConn.Execute(strSQL)
		
		If Not objRS1.Eof Then
			strDESCRICAO1 = Replace(GetValue(objRS1, "DESCRICAO"),"""","&quot;")
			strSIGILOSO1  = Replace(GetValue(objRS1, "SIGILOSO"),"""","&quot;")
			
			strDESCRICAO2 = Replace(GetValue(objRS1, "DESCRICAO"),Chr(13),"<br>")
			strSIGILOSO2  = Replace(GetValue(objRS1, "SIGILOSO"),Chr(13),"<br>")
			
			strDESCRICAO2 = Replace(strDESCRICAO2,"<ASLW_APOSTROFE>","'")
			strSIGILOSO2  = Replace(strSIGILOSO2,"<ASLW_APOSTROFE>","'")
			
			strDESCRICAO2 = Replace(strDESCRICAO2, "''", "'")
			strSIGILOSO2  = Replace(strSIGILOSO2, "''", "'")
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
	if (document.form_insert.var_executor.value == '') var_msg += '\nInformar quem desbloqueia';
	
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
<%=athBeginDialog(WMD_WIDTH, "Chamado - Desbloqueio")%>
<form name="form_insert" action="Desbloqueia_Chamado_Exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<input type="hidden" name="var_executor" value="<%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%>">
	<input name="JSCRIPT_ACTION" type="hidden" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input name="DEFAULT_LOCATION" type="hidden" value=''>
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Dados do Chamado</b><br>
		<br><div class="form_label">Cliente:</div><div class="form_bypass"><%=GetValue(objRS1, "COD_CLIENTE")%> - <%=GetValue(objRS1, "CLIENTE")%></div>
		<br><div class="form_label">Usuário:</div><div class="form_bypass"><%=GetValue(objRS1, "SYS_ID_USUARIO_INS")%></div>
		<br><div class="form_label">Título:</div><div class="form_bypass"><%=GetValue(objRS1, "TITULO")%></div>
		<br><div class="form_label">Categoria:</div><div class="form_bypass"><%=GetValue(objRS1, "CATEGORIA")%></div>
		<br><div class="form_label">Descrição:</div><div class="form_bypass_multiline"><%=strDESCRICAO2%></div>
		<br><div class="form_label">Sigiloso:</div><div style="margin-left:115px; margin-right:20px; text-align:left;"><%=strSIGILOSO2%></div>
		<br><div class="form_label">Prioridade:</div><div class="form_bypass"><%=GetValue(objRS1, "PRIORIDADE")%></div>
		<%
		If GetValue(objRS1, "ARQUIVO_ANEXO") <> "" Then %>		
			<br><div class="form_label">Arquivo Anexo:</div><div class="form_bypass"><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=GetValue(objRS1,"ARQUIVO_ANEXO")%>" target="_blank" style="cursor:hand;"><%=GetValue(objRS1, "ARQUIVO_ANEXO")%></a><% 
		End If
		%></div>
	</div>
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Dados para o Desbloqueio</b><br>
		<br><div class="form_label">*Desbloqueado por:</div><div class="form_bypass"><%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%></div>
		<br><div class="form_label">*Categoria:</div><select name="var_cod_categoria" style="width:100px;">
		<%
		strSQL = " SELECT COD_CATEGORIA, NOME FROM CH_CATEGORIA ORDER BY NOME "
		Set objRS2 = objConn.Execute(strSQL)
		
		Do While Not objRS2.Eof 
			Response.Write("<option value='" & GetValue(objRS2, "COD_CATEGORIA") & "'")
			If GetValue(objRS2, "COD_CATEGORIA") = GetValue(objRS1, "COD_CATEGORIA") Then Response.Write(" selected='selected'")
			Response.Write(">" & GetValue(objRS2, "NOME") & "</option>")
			
			objRS2.MoveNext
		Loop
		FechaRecordSet objRS2
		%>
		</select>
		<br><div class="form_label">Horas:</div><input name="var_horas" type="text" style="width:40px;" maxlength="5" value="" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
		<select name="var_minutos" style="width:70px;">
			<option value="00" selected>00 min</option>
			<option value="25">15 min</option>
			<option value="50">30 min</option>
			<option value="75">45 min</option>
		</select>&nbsp;Total de horas a liberar para atender chamado&nbsp;
		<br><div class="form_label">Valor:</div><input name="var_valor" type="text" style="width:70px;" maxlength="10" value="" onKeyPress="validateFloatKey();">&nbsp;Valor liberado em R$ para atender este chamado&nbsp;
		<br><div class="form_label">Comentário:</div><textarea name="var_comentario1" rows="6" style="width:305px;"></textarea>
		<br><div class="form_label">Comentário Sigiloso:</div><textarea name="var_comentario2" rows="4" style="width:305px;"></textarea>
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If
		FechaRecordSet objRS1
	End If
	FechaDBConn objConn
%>
