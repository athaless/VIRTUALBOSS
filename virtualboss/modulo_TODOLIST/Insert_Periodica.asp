<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 Dim i

 Dim strSQL, objRS, objRSAux, ObjConn
 Dim Cont, strVALOR

 AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_insert.submit(); }
//****** Funções de ação dos botões - Fim ******
function selecionaop() {
	if(form_insert.var_diasemsel.checked == true) {
		for(cont=1;cont<=7;cont++) eval("form_insert.chb"+cont+".disabled = false");
		document.form_insert.var_dianum.disabled = true;
	}
	else {
		for(cont=1;cont<=7;cont++) eval("form_insert.chb"+cont+".disabled = true");
		document.form_insert.var_dianum.disabled = false;
	}
}
</script>
</head>
<body Onload="selecionaop();">
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Inser&ccedil;&atilde;o Peri&oacute;dica")%>
<form name="form_insert" action="insert_periodica_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_TODOLIST/Insert_Periodica.asp'>
	<div class="form_label" style="float:left;"><img src="../IMG/IcoToDOInsert.gif"></div><div class="form_bypass_multiline" style="display:block;" >Este formul&aacute;rio permite o agendamento de atividades peri&oacute;dicas diversas, por exemplo, voc&ecirc; pode definir uma atividade para todo dia 20 &agrave;s 12:00 horas durante um per&iacute;odo X, ou definir uma atividade peri&oacute;dica semanal tipo todas as ter&ccedil;as.</div>	
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Intervalo de Agendamento</b>
		<br><br><div class="form_label">Início:</div><%=InputDate("var_data_inicio","edtext",PrepData(Date,true,false),false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_data_inicio", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
		<br><div class="form_label">Fim:</div><%=InputDate("var_data_fim","edtext",PrepData(Date,true,false),false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_data_fim", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
	</div>
	
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Inserir atividade nos seguintes meses no per&iacute;odo selecionado</b>
		<br><br><div class="form_label"></div>
		<% 
			for i=1 to 12
				if i = 7 then %>
				<br><div class="form_label"></div>
		<% 		
				end if
				if i<10 then %>						
					<input name="var_mes" id="chbmes<%=i%>" type="checkbox" class="inputclean" value="0<%=i%>" 
					 style="height:15px; width:15px;"><%=mid(MesExtenso(i),1,3)%>&nbsp;
				<% else %>
					<input name="var_mes" id="chbmes<%=i%>" type="checkbox" class="inputclean" value="<%=i%>" 
					 style="height:15px; width:15px;"><%=mid(MesExtenso(i),1,3)%>&nbsp;
				<% end if
				if i=6 then %>
					<br>
				<% end if
				   next
		%>
	</div>
	
	<div class="form_grupo" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
  		style="cursor:pointer;">
		<b>Agendamento por dia</b>
		<br><br><div class="form_label"></div><input type="radio" name="r1" id="var_dianumsel" onClick="selecionaop();" 
											   class="inputclean" checked/>&nbsp;do m&ecirc;s<select name="var_dianum" onFocus="if(disabled)blur();" style="width:50px" class="edtext_combo">
												<% for i=1 to 31 %>
												<option value="<%=i%>"><%=i%></option>
												<% next %>
											  </select>
		<br><div class="form_label"></div><input type="radio" name="r1" id="var_diasemsel" class="inputclean" 
									 onClick="selecionaop();" />&nbsp;da semana
		<br><div class="form_label"></div><input name="var_diasem" type="checkbox" class="inputclean" value="1" id="chb1" style="height:10px; width:10px;">&nbsp;Dom&nbsp;<input name="var_diasem" type="checkbox" class="inputclean" value="2" id="chb2" style="height:10px; width:10px;">&nbsp;Seg&nbsp;<input name="var_diasem" type="checkbox" class="inputclean" value="3" id="chb3" style="height:10px; width:10px;">&nbsp;Ter&nbsp;<input name="var_diasem" type="checkbox" class="inputclean" value="4" id="chb4" style="height:10px; width:10px;">&nbsp;Qua&nbsp;<input name="var_diasem" type="checkbox" class="inputclean" value="5" id="chb5" style="height:10px; width:10px;">&nbsp;Qui&nbsp;<input name="var_diasem" type="checkbox" class="inputclean" value="6" id="chb6" style="height:10px; width:10px;">&nbsp;Sex&nbsp;<input name="var_diasem" type="checkbox" class="inputclean" value="7" id="chb7" style="height:10px; width:10px;">&nbsp;S&aacute;b&nbsp;
	</div>
	
	<br><div class="form_label">*T&iacute;tulo:</div><input name="var_titulo" type="text" size="50" style="width:302px;">
	<br><div class="form_label">*Situação:</div><select name="var_situacao" style="width:100px;">
													<option value="ABERTO" selected>ABERTO</option>
													<option value="OCULTO">OCULTO</option>
												</select><div class="form_label_nowidth">&nbsp;*Categoria:&nbsp;</div>
												<select name="var_cod_e_desc_categoria" style="width:100px">
													<option value="" selected>Selecione</option>
				<%
				strSQL = " SELECT COD_CATEGORIA, NOME FROM TL_CATEGORIA WHERE DT_INATIVO IS NULL AND NOME <> 'CHAMADO' ORDER BY NOME "
				Set objRSAux = objConn.Execute(strSQL)
				
				Do While Not objRSAux.Eof
					Response.Write("<option value='" & GetValue(objRSAux,"COD_CATEGORIA") & " - " & GetValue(objRSAux,"NOME") & "'>")
					Response.Write(GetValue(objRSAux,"NOME") & "</option>")
					
					objRSAux.MoveNext
				Loop
				FechaRecordSet objRSAux
				%>
												</select>
	<br><div class="form_label">*Prioridade:</div><select name="var_prioridade" style="width:100px">
				<option value="NORMAL" selected>NORMAL</option>
				<option value="BAIXA">BAIXA</option>
				<option value="MEDIA">MÉDIA</option>
				<option value="ALTA">ALTA</option>
			</select>
	<br><div class="form_label">*Responsável:</div><select name="var_id_responsavel" style="width:100px">
				<option value="">Selecione</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(Request.Cookies("VBOSS")("ID_USUARIO")))%> 
			</select><div class="form_label_nowidth">&nbsp;*Executor:&nbsp;</div><select name="var_id_executor" size="1" style="width:100px">
				<option value="">Selecione</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO","")%> 
			</select>
	<br><div class="form_label">Hora de Início:</div><select name="var_prev_hr_ini_hora" size="1" style="width:40px">
				<option value="" selected="selected"></option>
				<% 
				For Cont = 0 to 23
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'>" & strVALOR & "</option>")
				Next
				%>
			</select>
			<select name="var_prev_hr_ini_min" size="1" style="width:60px">
				<option value="" selected="selected"></option>
				<%
				Cont = 0
				Do While (Cont <= 55)
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'>" & strVALOR & " min</option>")
					Cont = Cont + 5
				Loop
				%>
			</select>
	<br><div class="form_label">Prev. Horas:</div><input name="var_prev_horas" type="text" style="width:50px" maxlength="5" value="" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
			<select name="var_prev_minutos" style="width:70px">
				<option value="00" selected>00 min</option>
				<option value="25">15 min</option>
				<option value="50">30 min</option>
				<option value="75">45 min</option>
			</select>
	<br><div class="form_label">*Tarefa:</div><textarea name="var_descricao" style="width:302px; height:80px;"></textarea></td>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
FechaDBConn objConn
%>