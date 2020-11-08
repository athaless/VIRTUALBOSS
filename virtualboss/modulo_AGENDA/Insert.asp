<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_AGENDA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim strSQL, objRS, ObjConn

 Dim strCITADOS, strAUX, bolSELECTED, i

 strCITADOS  = GetParam("var_citados")

 bolSELECTED = false

 AbreDBConn objConn, CFG_DB 
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
	
	if (document.form_insert.var_titulo.value == '')               var_msg += '\nTítulo';
	if (document.form_insert.var_cod_e_desc_categoria.value == '') var_msg += '\nCategoria';
	if (document.form_insert.var_prioridade.value == '')           var_msg += '\nPrioridade';
	if (document.form_insert.var_id_responsavel.value == '')       var_msg += '\nResponsável';
	if (document.form_insert.var_descricao.value == '')            var_msg += '\nTarefa';
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
function InsereTodos(prExec) {
	document.form_insert.action="BuscaTodosUsuarios.asp?var_exec=" + prExec + "&var_grupo=" + document.form_insert.var_grupo.value + "&var_form=form_insert&var_campo=var_id_citados&var_pagina=insert_exec.asp";
	document.form_insert.target="ins_todos";
	document.form_insert.submit();
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Agenda - Inser&ccedil;&atilde;o")%>
<form name="form_insert" action="insert_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='insert.asp'>
	<div class='form_label'>*Título:</div><input name="var_titulo" type="text" style="width:350px;">
	<br><div class='form_label'>*Situação:</div><select name="var_situacao" style="width:100px;">
													<option value="ABERTO" selected>ABERTO</option>
													<option value="FECHADO">FECHADO</option>
												</select>
	<br><div class='form_label'>*Categoria:</div><select name="var_cod_e_desc_categoria" style="width:100px;">
													<option value="" selected>Selecione</option>
				<%
				strSQL = " SELECT COD_CATEGORIA, NOME FROM AG_CATEGORIA WHERE DT_INATIVO is NULL ORDER BY NOME "
				Set objRS = objConn.Execute(strSQL)
				Do While Not objRS.Eof
					Response.Write("<option value='" & GetValue(objRS, "COD_CATEGORIA") & " - " & GetValue(objRS, "NOME") & "'>")
					Response.Write(GetValue(objRS, "NOME") & "</option>")
					
					objRS.MoveNext
				Loop
				FechaRecordSet objRS
				%>
					 </select>
	<br><div class='form_label'>*Prioridade:</div><select name="var_prioridade" style="width:100px;">
													<option value="NORMAL" selected>NORMAL</option>
													<option value="BAIXA">BAIXA</option>
													<option value="MEDIA">MÉDIA</option>
													<option value="ALTA">ALTA</option>
										 		  </select>
	<br><div class='form_label'>*Responsável:</div><select name="var_id_responsavel" style="width:100px;">
													<option value="">Selecione</option>
													<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(Request.Cookies("VBOSS")("ID_USUARIO")))%> 
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
	<br><div class='form_label'>Data Prevista:</div><%=InputDate("var_prev_dt_ini","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_prev_dt_ini", "ver calendário")%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span>&nbsp;&nbsp;<div class="form_label_nowidth">Hora:</div><input name="var_hh" type="text" style="width:20px;" maxlength="2" value="<%=ATHFormataTamLeft(Hour(now),2,"0")%>" onFocus="this.value=''" onKeyPress="validateNumKey();"><select name="var_mm" style="width:70px; vertical-align:middle;">
<%
				while i<60
					strAUX = "<option value='" & ATHFormataTamLeft(i,2,"0") & "'"
					if Minute(now)<i+2.5 and not bolSELECTED then 
						strAUX = strAUX & " selected"
						bolSELECTED = true
					end if
					strAUX = strAUX & ">" & ATHFormataTamLeft(i,2,"0")
					strAUX = strAUX & " min</option>"
					Response.Write(strAUX)
					i=i+5
				wend						
			%></select><span class="texto_ajuda">&nbsp;<i>hh:mm</i></span>
	<br><div class='form_label'>Prev. Horas:</div><input name="var_prev_horas" type="text" style="width:40px;" maxlength="5" value="" onKeyPress="validateNumKey();">&nbsp;h&nbsp;<select name="var_prev_minutos" style="width:70px;">
				<option value="00" selected>00 min</option>
				<option value="25">15 min</option>
				<option value="50">30 min</option>
				<option value="75">45 min</option>
			</select>
	<br><div class='form_label'>Data Realizado:</div><%=InputDate("var_dt_realizado","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_realizado", "ver calendário")%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span>
	<br><div class='form_label'>*Tarefa:</div><textarea name="var_descricao" style="width:350px; height:140px;"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
FechaDBConn objConn
%>