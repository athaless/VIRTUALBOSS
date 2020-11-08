<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
 
 strCFG_TD = "align='left' valign='top' nowrap"

 If strCODIGO <> "" Then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =          "SELECT T1.COD_TODOLIST, T1.ARQUIVO_ANEXO, T1.ID_RESPONSAVEL, T1.ID_ULT_EXECUTOR, T1.TITULO, T1.DESCRICAO "
	strSQL = strSQL & "     , T1.SITUACAO, T1.PRIORIDADE, T1.COD_CATEGORIA, T1.PREV_DT_INI, T1.PREV_HR_INI, T1.PREV_HORAS "
	strSQL = strSQL & "     , T1.DT_REALIZADO, T1.DESCRICAO, C1.NOME, T1.COD_BOLETIM "
	strSQL = strSQL & "  FROM TL_TODOLIST T1, TL_CATEGORIA C1 "
	strSQL = strSQL & " WHERE T1.COD_TODOLIST = " & strCODIGO
	strSQL = strSQL & "   AND T1.COD_CATEGORIA = C1.COD_CATEGORIA "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.Eof then
	  strArquivo	= GetValue(objRS,"ARQUIVO_ANEXO")
	  strDESCRICAO  = GetValue(objRS,"DESCRICAO")
	  if not IsNull(strArquivo) or strArquivo <> "" then
		  strArquivoAnexo = Mid(strArquivo,inStr(1,strArquivo,"_")+1)
		  strArquivoAnexo = Mid(strArquivoAnexo,inStr(1,strArquivoAnexo,"_")+1)
	  end if
	  
	  strPREV_HORAS_HH = FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))
	  strPREV_HORAS_MM = strPREV_HORAS_HH
	  if strPREV_HORAS_HH <> "" then 
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
	function ok()			{ document.formcopia.DEFAULT_LOCATION.value = ""; submeterForm(); }
	function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
	function aplicar()      {  }
	function submeterForm() { document.formcopia.submit(); }
	//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Cópia")%>
<form name="formcopia" action="copia_exec.asp" method="post">
	<input type="hidden" name="var_situacao" value="ABERTO">
	<input type="hidden" name="var_cod_boletim" value="<%=GetValue(objRS,"COD_BOLETIM")%>">
	<input type="hidden" name="JSCRIPT_ACTION"	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION"	value=''>
	<div class="form_label">*Título:</div><input name="var_titulo" type="text" style="width:300px;" value="<%=GetValue(objRS,"TITULO")%>">
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
				<option value="NORMAL" <% If GetValue(objRS,"PRIORIDADE") = "NORMAL" Then Response.Write("selected")%>>NORMAL</option>
				<option value="BAIXA"  <% If GetValue(objRS,"PRIORIDADE") = "BAIXA"  Then Response.Write("selected")%>>BAIXA</option>
				<option value="MEDIA"  <% If GetValue(objRS,"PRIORIDADE") = "MEDIA"  Then Response.Write("selected")%>>MÉDIA</option>
				<option value="ALTA"   <% If GetValue(objRS,"PRIORIDADE") = "ALTA"   Then Response.Write("selected")%>>ALTA</option>
			</select> 
	<br><div class="form_label">*Responsável:</div><select name="var_ID_RESPONSAVEL" style="width:100px;">
				<option value="">Selecione</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(GetValue(objRS,"ID_RESPONSAVEL")))%> 
			</select>
	<br><div class="form_label">Executor:</div><select name="var_ID_ULT_EXECUTOR" size="1" style="width:100px;">
				<option value="">Selecione</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(GetValue(objRS,"ID_ULT_EXECUTOR")))%> 
			</select>
	<br><div class="form_label">Prev. In&iacute;cio:</div><%=InputDate("VAR_PREV_DT_INI","",PrepData(GetValue(objRS,"PREV_DT_INI"),true,false),false)%>&nbsp;<%=ShowLinkCalendario("formcopia", "VAR_PREV_DT_INI", "ver calendário")%>&nbsp;
			<select name="var_prev_hr_ini_hora" size="1" style="width:40px;">
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
			<select name="var_prev_hr_ini_min" size="1" style="width:60px;">
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
	<br><div class="form_label">Prev. Horas:</div><input name="var_prev_horas" type="text" style="width:40px;" maxlength="5" value="<%=strPREV_HORAS_HH%>" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
			<select name="var_prev_minutos" style="width:70px;">
				<option value="00" <% If strPREV_HORAS_MM =  "0" Then Response.Write(" selected") End If %>>00 min</option>
				<option value="25" <% If strPREV_HORAS_MM = "15" Then Response.Write(" selected") End If %>>15 min</option>
				<option value="50" <% If strPREV_HORAS_MM = "30" Then Response.Write(" selected") End If %>>30 min</option>
				<option value="75" <% If strPREV_HORAS_MM = "45" Then Response.Write(" selected") End If %>>45 min</option>
			</select>
	<br><div class="form_label">*Tarefa:</div><textarea name="var_descricao" style="width:350px; height:160px;"><%=Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'")%></textarea></td>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>
