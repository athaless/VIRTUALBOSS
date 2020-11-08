<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, objRSAux, ObjConn, Cont
Dim strCODIGO, strRESP 
Dim strArquivo,strArquivoAnexo, strDESCRICAO
Dim strPREV_HORAS_HH, strPREV_HORAS_MM
Dim strCFG_TD, aux, auxHS, acHORAS, strResposta, bFechar
Dim strPREV_HR_INI, strPREV_HR_INI_hora, strPREV_HR_INI_min
Dim strVALOR

strCODIGO = GetParam("var_chavereg")

if strCODIGO<>"" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =          "SELECT T1.COD_TODOLIST, T1.COD_BOLETIM, T1.ARQUIVO_ANEXO, T1.ID_RESPONSAVEL, T1.ID_ULT_EXECUTOR, T1.TITULO, T1.DESCRICAO, T1.SITUACAO "
	strSQL = strSQL & "     , T1.PRIORIDADE, T1.COD_CATEGORIA, T1.PREV_DT_INI, T1.PREV_HR_INI, T1.PREV_HORAS, T1.DT_REALIZADO, T1.DESCRICAO, BS.TIPO, C1.NOME " 
	strSQL = strSQL & "  FROM TL_TODOLIST T1, TL_CATEGORIA C1, BS_BOLETIM BS"
	strSQL = strSQL & " WHERE T1.COD_TODOLIST = " & strCODIGO 
	strSQL = strSQL & "   AND T1.COD_CATEGORIA = C1.COD_CATEGORIA"
	strSQL = strSQL & "   AND T1.COD_BOLETIM = BS.COD_BOLETIM"		
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

	if not objRS.Eof then
	  strDESCRICAO  = GetValue(objRS,"DESCRICAO")
	  
	  strPREV_HORAS_HH = FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))
	  strPREV_HORAS_MM = strPREV_HORAS_HH
	  if strPREV_HORAS_HH<>"" then 
		  strPREV_HORAS_HH = Mid(strPREV_HORAS_HH, 1, InStr(strPREV_HORAS_HH, ":")-1)
		  strPREV_HORAS_MM = Mid(strPREV_HORAS_MM, InStr(strPREV_HORAS_MM, ":")+1, 2) 
	  end if 
	  
	  strPREV_HR_INI = GetValue(objRS,"PREV_HR_INI")
	  If strPREV_HR_INI <> "" Then
		strPREV_HR_INI_hora = Mid(strPREV_HR_INI, 1, InStr(strPREV_HR_INI, ":")-1)
	  	strPREV_HR_INI_min = Mid(strPREV_HR_INI, InStr(strPREV_HR_INI, ":")+1, 2)
	  End If
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_update.var_location.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_update.var_jscript_action.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Altera&ccedil;&atilde;o")%>
<form name="form_update" action="Update_ToDoExec.asp" method="post">
	<input type="hidden" name="var_cod_todolist"  value="<%=strCODIGO%>">
	<input type="hidden" name="var_data_ini_ant" value="<%=PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)%>">
	<input type="hidden" name="var_tipo" value="<%=GetValue(objRS,"TIPO")%>">
	<input type="hidden" name="var_situacao" value="<%=GetValue(objRS,"SITUACAO")%>">
	<input type="hidden" name="var_jscript_action"  value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="var_location"        value='../modulo_BS/Update_ToDo.asp?var_chavereg=<%=strCODIGO%>'>
	<div class="form_label">Cod. Atividade:</div><input name="VAR_BOLETIM" type="text" style="width:40px;" value="<%=GetValue(objRS,"COD_BOLETIM")%>" readonly>
	<br><div class="form_label">*Título:</div><input name="var_titulo" type="text" style="width:380px;" value="<%=GetValue(objRS,"TITULO")%>">
	<br><div class="form_label">*Categoria:</div><select name="var_cod_e_desc_categoria" style="width:100px;">
				<option value="">Selecione</option>
				<%
				strSQL = " SELECT COD_CATEGORIA, NOME FROM TL_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME "
				Set objRSAux = objConn.Execute(strSQL)
				
				Do While Not objRSAux.Eof
					Response.Write("<option value='" & GetValue(objRSAux,"COD_CATEGORIA") & " - " & GetValue(objRSAux,"NOME") & "'")
					If (GetValue(objRS,"COD_CATEGORIA") = GetValue(objRSAux,"COD_CATEGORIA")) Then Response.Write(" selected")
					Response.Write(">" & GetValue(objRSAux,"NOME") & "</option>")
					
					objRSAux.MoveNext
				Loop
				FechaRecordSet objRSAux
				%>
			</select>
	<br><div class="form_label">*Prioridade:</div><select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" <% if GetValue(objRS,"PRIORIDADE") = "NORMAL" then Response.Write("selected")%>>NORMAL</option>
				<option value="BAIXA"  <% if GetValue(objRS,"PRIORIDADE") = "BAIXA"  then Response.Write("selected")%>>BAIXA</option>
				<option value="MEDIA"  <% if GetValue(objRS,"PRIORIDADE") = "MEDIA"  then Response.Write("selected")%>>MÉDIA</option>
				<option value="ALTA"   <% if GetValue(objRS,"PRIORIDADE") = "ALTA"   then Response.Write("selected")%>>ALTA</option>
			</select>
	<br><div class="form_label">*Responsável:</div><select name="var_ID_RESPONSAVEL" style="width:100px;">
				<option value="">Selecione</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM BS_EQUIPE WHERE DT_INATIVO IS NULL AND COD_BOLETIM=" & GetValue(objRS,"COD_BOLETIM") & " ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(GetValue(objRS,"ID_RESPONSAVEL")))%>							
			</select>
	<br><div class="form_label">Executor:</div><select name="var_ID_ULT_EXECUTOR" size="1" style="width:100px;">
				<option value="">Selecione</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM BS_EQUIPE WHERE DT_INATIVO IS NULL AND COD_BOLETIM=" & GetValue(objRS,"COD_BOLETIM") & " ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(GetValue(objRS,"ID_ULT_EXECUTOR")))%> 							
			</select>
	<br><div class="form_label">Prev. In&iacute;cio:</div><%=InputDate("VAR_PREV_DT_INI","",PrepData(GetValue(objRS,"PREV_DT_INI"),true,false),false)%>
			&nbsp;<%=ShowLinkCalendario("form_update", "VAR_PREV_DT_INI", "ver calendário")%>
			<select name="var_prev_hr_ini_hora" size="1" style="width:40px">
				<option value="" <% If CStr(strPREV_HR_INI_hora) = "" Then Response.Write(" selected='selected'") End If %>></option>
				<% 
				For Cont = 0 to 23
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'")
					If CStr(strPREV_HR_INI_hora) = strVALOR Then Response.Write(" selected='selected'")
					Response.Write(">" & strVALOR & "</option>")
				Next
				%>
			</select>
			<select name="var_prev_hr_ini_min" size="1" style="width:60px">
				<option value="" <% If CStr(strPREV_HR_INI_min) = "" Then Response.Write(" selected='selected'") End If %>></option>
				<%
				Cont = 0
				Do While (Cont <= 55)
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'")
					If CStr(strPREV_HR_INI_min) = strVALOR Then Response.Write(" selected='selected'")
					Response.Write(">" & strVALOR & " min</option>")
					Cont = Cont + 5
				Loop
				%>
			</select>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa hh:mm</i></span>
	<br><div class="form_label">Prev. Horas:</div><input name="VAR_PREV_HORAS" type="text" style="width:40px;" maxlength="5" value="<%=strPREV_HORAS_HH%>" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
			<select name="var_prev_minutos" style="width:70px;">
				<option value="00" <% If strPREV_HORAS_MM =  "0" Then Response.Write(" selected") End If %>>00 min</option>
				<option value="25" <% If strPREV_HORAS_MM = "15" Then Response.Write(" selected") End If %>>15 min</option>
				<option value="50" <% If strPREV_HORAS_MM = "30" Then Response.Write(" selected") End If %>>30 min</option>
				<option value="75" <% If strPREV_HORAS_MM = "45" Then Response.Write(" selected") End If %>>45 min</option>
			</select>
	<br><div class="form_label">Anexo:</div><input name="var_arquivo_anexo" type="text" maxlength="250" value="<%=GetValue(objRS,"ARQUIVO_ANEXO")%>" style="width:122px;"><a href="javascript:UploadArquivo('form_update','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Tarefa:</div><textarea name="var_descricao" style="width:380px; height:160px"><%=Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'")%></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<%
  strSQL =          " SELECT COD_TL_RESPOSTA, SYS_ID_USUARIO_INS, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA, HORAS " 
  strSQL = strSQL & " FROM TL_RESPOSTA WHERE COD_TODOLIST = " & strCODIGO & " ORDER BY DTT_RESPOSTA DESC " 
  AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
  if not objRS.eof then 
    response.write ("<script>")
    response.write ("  form_update.VAR_DESCRICAO.readOnly = true;")
    response.write ("</script>")
%>
<table width="90%" border="0" align="center" cellpadding="3" cellspacing="0">
	<tr><td><b>Respostas</b></td></tr> 
	<tr> 
		<td align="center"> 
			<table width="100%" border="0" cellpadding="1" cellspacing="2">
				<tr>
					<td align='left' valign='top' nowrap width="02%">Data</div></td>
					<td align='left' valign='top' nowrap width="04%">De</div></td>
					<td align='left' valign='top' nowrap width="04%">Para</div></td>
					<td align="left" valign="top" width="78%">Mensagem</div></td>
					<td align='left' valign='top' nowrap width="02%">Horas</div></td>
				</tr>
<%
				aux = 0
				acHoras = 0
				do while not objRS.Eof 
					strResposta = GetValue(objRS,"RESPOSTA")
					if strResposta<>"" then strResposta = Replace(strResposta,"<ASLW_APOSTROFE>","'")
					auxHS = 0
					if GetValue(objRS,"HORAS")<>"" then auxHS = GetValue(objRS,"HORAS")
%>
<b>
				<tr><td align='left' valign='top' nowrap bgcolor="#999999" colspan="6" height="1" width="100%"></td></tr>
				<tr>
					<td align='left' valign='top' nowrap width="02%"><%=PrepData(GetValue(objRS,"DTT_RESPOSTA"),true,true)%></div></td>
					<td align='left' valign='top' nowrap width="04%"><div style="color:#999999;"><% if GetValue(objRS,"SYS_ID_USUARIO_INS")<>"" then Response.Write LCase(GetValue(objRS,"ID_FROM"))%></div></td>
					<td align='left' valign='top' nowrap width="04%"><b><%if GetValue(objRS,"SYS_ID_USUARIO_INS")<>"" then Response.Write LCase(GetValue(objRS,"ID_TO"))%></b></div></td>
					<td align="left" valign="middle" width="78%"><%=strResposta%></div></td>
					<td style="text-align:right;" valign="middle" width="02%"><%=FormataHoraNumToHHMM(auxHS)%></div></td>
				</tr></b>
<%
					aux = 1
					acHoras = (acHoras + auxHS)
					objRS.MoveNext
				loop 
%>
				<tr><td align="left" height="01px" colspan="6" bgcolor="#999999" width="100%"></td></tr>
				<tr><td style="text-align:right;"height="30px" colspan="6" width="100%" valign="middle">Total: <%=FormataHoraNumToHHMM(acHORAS)%></div></td></tr>
			</table>
		</td>
	</tr>
</table>
<% 
 end if 
%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
	end if 
	FechaDBConn objConn
end if
%>
