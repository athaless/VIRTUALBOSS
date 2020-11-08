<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_AGENDA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
Dim strSQL, objRS, ObjConn, objRSAux
Dim strCODIGO, strRESP 
Dim strArquivo,strArquivoAnexo, strDESCRICAO
Dim strPREV_HORAS_HH, strPREV_HORAS_MM
Dim strDT_INI, strHH_INI, strMM_INI
Dim strCITADOS, strAUX, bolSELECTED, i

strCODIGO = GetParam("var_chavereg")

bolSELECTED = false

if strCODIGO<>"" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL = "SELECT"						&_
				"	T1.COD_AGENDA,"		&_
				"	T1.ARQUIVO_ANEXO,"	&_
				"	T1.ID_RESPONSAVEL,"	&_
				"	T1.ID_CITADOS,"		&_
				"	T1.TITULO,"				&_
				"	T1.DESCRICAO,"			&_
				"	T1.SITUACAO,"			&_
				"	T1.PRIORIDADE,"		&_
				"	T1.COD_CATEGORIA," 	&_
				"	T1.PREV_DT_INI," 		&_
				"	T1.PREV_HORAS," 		&_
				"	T1.DT_REALIZADO," 	&_
				"	T1.DESCRICAO,"			&_
				"	C1.NOME "				&_
				"FROM" 						&_
				"	AG_AGENDA T1,"			&_
				"	AG_CATEGORIA C1 "		&_
				"WHERE"						&_
				"	T1.COD_AGENDA=" & strCODIGO & " AND" &_
				"	T1.COD_CATEGORIA=C1.COD_CATEGORIA"	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	
	if not objRS.eof then
		strArquivo	= GetValue(objRS,"ARQUIVO_ANEXO")
		strDESCRICAO= GetValue(objRS,"DESCRICAO")
		strCITADOS 	= LCase(GetValue(objRS,"ID_CITADOS"))
		
		'if mid(strCITADOS,1,1)=";" then	strCITADOS = mid(strCITADOS,2)
		
		if not IsNull(strArquivo) or strArquivo<>"" then
			strArquivoAnexo = mid(strArquivo,InStr(1,strArquivo,"_")+1)
			strArquivoAnexo = mid(strArquivoAnexo,InStr(1,strArquivoAnexo,"_")+1)
		end if
		
		strPREV_HORAS_HH = FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))
		strPREV_HORAS_MM = strPREV_HORAS_HH
		
		if strPREV_HORAS_HH<>"" then 
			strPREV_HORAS_HH = mid(strPREV_HORAS_HH,1,InStr(strPREV_HORAS_HH,":")-1)
			strPREV_HORAS_MM = mid(strPREV_HORAS_MM,InStr(strPREV_HORAS_MM,":")+1,2) 
		end if 

		strHH_INI = "00"
		strMM_INI =	"00"	
		strDT_INI = PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)
		if InStr(GetValue(objRS,"PREV_DT_INI")," ")>0 then 
			strDT_INI = PrepData(mid(GetValue(objRS,"PREV_DT_INI"),1,InStr(GetValue(objRS,"PREV_DT_INI")," ")-1),true,false)
			strHH_INI = mid(GetValue(objRS,"PREV_DT_INI"),InStr(GetValue(objRS,"PREV_DT_INI")," ")+1,2)
			strMM_INI =	mid(GetValue(objRS,"PREV_DT_INI"),InStr(GetValue(objRS,"PREV_DT_INI"),":")+1,2)	
		end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
/****** Funções de ação dos botões - Início ******/
function ok()       { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.var_titulo.value == '')               var_msg += '\nTítulo';
	if (document.form_update.var_cod_e_desc_categoria.value == '') var_msg += '\nCategoria';
	if (document.form_update.var_prioridade.value == '')           var_msg += '\nPrioridade';
	if (document.form_update.var_id_responsavel.value == '')       var_msg += '\nResponsável';
	if (document.form_update.var_descricao.value == '')            var_msg += '\nTarefa';
	if (var_msg == '')
		document.form_update.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******/
function InsereTodos(prExec) {
	document.form_update.action="BuscaTodosUsuarios.asp?var_exec=" + prExec + "&var_grupo=" + document.form_update.var_grupo.value + "&var_form=form_update&var_campo=var_id_citados&var_pagina=update_exec.asp";
	document.form_update.target="ins_todos";
	document.form_update.submit();
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Agenda - Alteração")%>
<form name="form_update" action="update_exec.asp" method="post">
	<input name="var_cod_agenda" type="hidden" value="<%=strCODIGO%>">
	<input name="var_data_ant"   type="hidden" value="<%=PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)%>">
	<input name="JSCRIPT_ACTION"	type="hidden" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input name="DEFAULT_LOCATION"  type="hidden" value='../modulo_AGENDA/Update.asp?var_chavereg=<%=strCODIGO%>'>
	<div class='form_label'>Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class='form_label'>*Título:</div><input name="var_titulo" type="text" value="<%=GetValue(objRS,"TITULO")%>" style="width:350px;">
	<br><div class='form_label'>*Situação:</div><select name="var_situacao" style="width:100px;">
					<option value="ABERTO"  <% if objRS("SITUACAO")="ABERTO"  then Response.Write("selected")%>>ABERTO</option>
					<option value="FECHADO" <% if objRS("SITUACAO")="FECHADO" then Response.Write("selected")%>>FECHADO</option>
												</select>
	<br><div class='form_label'>*Categoria:</div><select name="var_cod_e_desc_categoria" style="width:100px;">
									<option value="">Selecione</option>
				<%
				strSQL = "SELECT COD_CATEGORIA, NOME FROM AG_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME "
				Set objRSAux = objConn.Execute(strSQL)
				
				Do While Not objRSAux.Eof
					Response.Write("<option value='" & GetValue(objRSAux, "COD_CATEGORIA") & " - " & GetValue(objRSAux, "NOME") & "'")
					If CStr(GetValue(objRSAux, "COD_CATEGORIA")) = CStr(GetValue(objRS,"COD_CATEGORIA")) Then Response.Write(" selected")
					Response.Write(">" & GetValue(objRSAux, "NOME") & "</option>")
					
					objRSAux.MoveNext
				Loop
				FechaRecordSet objRSAux
				%> 
								</select>
	<br><div class='form_label'>*Prioridade:</div><select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" <% if GetValue(objRS,"PRIORIDADE")="NORMAL" then Response.Write("selected")%>>NORMAL</option>
				<option value="BAIXA"  <% if GetValue(objRS,"PRIORIDADE")="BAIXA"  then Response.Write("selected")%>>BAIXA</option>
				<option value="MEDIA"  <% if GetValue(objRS,"PRIORIDADE")="MEDIA"  then Response.Write("selected")%>>MÉDIA</option>
				<option value="ALTA"   <% if GetValue(objRS,"PRIORIDADE")="ALTA"   then Response.Write("selected")%>>ALTA</option>
			</select>
	<br><div class='form_label'>*Responsável:</div><select name="var_id_responsavel" style="width:100px;">
				<option value="">Selecione</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(GetValue(objRS,"ID_RESPONSAVEL")))%> 
			</select>
	<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
		<br><div class="form_label">Citados:</div>
		<a href="#2" onClick="JavaScript:InsereTodos('T');"><img src="../img/BtBuscarTodos.gif" border="0" style="vertical-align:bottom; padding-bottom:2px;" vspace="0" hspace="0"></a><iframe name="ins_todos" width="0" height="0" src="BuscaTodosUsuarios.asp" frameborder="0"></iframe>
<select name="var_grupo" style="width:180px;">
			<option value="ENT_COLABORADOR">Colaboradores</option>
			<% montaCombo "STR", " SELECT DISTINCT T2.COD_CLIENTE, T2.NOME_COMERCIAL FROM USUARIO T1, ENT_CLIENTE T2 WHERE T1.DT_INATIVO IS NULL AND T1.CODIGO = T2.COD_CLIENTE AND T1.TIPO = 'ENT_CLIENTE' ORDER BY T2.NOME_COMERCIAL ", "COD_CLIENTE", "NOME_COMERCIAL", "" %>
		</select>
		<br><div class="form_label"></div>
	<% Else %>
		<br><div class="form_label">Citados:</div>
	<% End If %><textarea name="var_id_citados" rows="3" style="width:260px;"><%=strCITADOS%></textarea>
	<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
	<a href="#1" onClick="JavaScript:AbreJanelaPAGE('BuscaPorUsuario.asp?var_form=form_insert', '600', '350');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:bottom; padding-bottom:4px;" vspace="0" hspace="0"></a>
	<% End If %>	
	<div class="form_ajuda">Informe usuário do sistema, como <b><%=Request.Cookies("VBOSS")("ID_USUARIO")%></b> por exemplo, e use ponto e vírgula como separador se digitar mais de um</div>
	<br><div class="form_label">Previsão:</div><%=InputDate("var_prev_dt_ini","",strDT_INI,false)%>&nbsp;<%=ShowLinkCalendario("form_update", "var_prev_dt_ini", "ver calendário")%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span>&nbsp;Hora:&nbsp;<input name="var_hh" type="text" style="width:20px;" maxlength="2" value="<%=strHH_INI%>" onFocus="this.value=''" onKeyPress="validateNumKey();">h&nbsp;<select name="var_mm" style="width:70px; vertical-align:middle;">
			<%
			while(i<60)
				strAUX = "<option value='" & ATHFormataTamLeft(i,2,"0") & "'"
				if CInt(strMM_INI)<i+2.5 and not bolSELECTED then 
					strAUX = strAUX & " selected"
					bolSELECTED = true
				end if
				strAUX = strAUX & ">" & ATHFormataTamLeft(i,2,"0")
				strAUX = strAUX & " min</option>"
				Response.Write(strAUX)
				i=i+5
			wend						
			%>
			</select><span class="texto_ajuda">&nbsp;<i>hh:mm</i></span>
	<br><div class="form_label">Prev. Horas:</div><input name="var_prev_horas" type="text" style="width:40px;" maxlength="5" value="<%=strPREV_HORAS_HH%>" onKeyPress="validateNumKey();">&nbsp;h&nbsp;<select name="var_prev_minutos" style="width:70px;">
				<option value="00" <% if strPREV_HORAS_MM="00" then Response.Write(" selected") %>>00 min</option>
				<option value="25" <% if strPREV_HORAS_MM="15" then Response.Write(" selected") %>>15 min</option>
				<option value="50" <% if strPREV_HORAS_MM="30" then Response.Write(" selected") %>>30 min</option>
				<option value="75" <% if strPREV_HORAS_MM="45" then Response.Write(" selected") %>>45 min</option>
			</select>
	<br><div class="form_label">Data Realizado:</div><%=InputDate("var_dt_realizado","",PrepData(GetValue(objRS,"DT_REALIZADO"),true,false),false)%>&nbsp;&nbsp;<%=ShowLinkCalendario("form_update", "var_dt_realizado", "ver calendário")%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span>
	<br><div class="form_label">*Tarefa:</div><textarea name="var_descricao" style="width:350px; height:140px;"><%=Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'")%></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
	end if 
	FechaDBConn objConn
end if 
%>