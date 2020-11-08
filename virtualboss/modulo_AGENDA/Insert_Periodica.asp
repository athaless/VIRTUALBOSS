<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS_MULT|", BuscaDireitosFromDB("modulo_AGENDA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"--> 
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 585
WMD_WIDTHTTITLES = 100

Dim CFG_TD_BLANK
CFG_TD_BLANK = "<td width='12px'></td>"

Dim strCITADOS, strAUX, bolSELECTED, i
strCITADOS  = GetParam("var_citados")
bolSELECTED = false
' -------------------------------------------------------------------------------
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
function UploadImage(formname,fieldname, dir_upload) {
	var strcaminho;
	
	strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
	window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

function selecionaop() {
	if(form_insert.diasemsel.checked == true) {
		for(cont=1;cont<=7;cont++) eval("form_insert.chb"+cont+".disabled = false");
		document.form_insert.dianum.disabled = true;
	}
	else {
		for(cont=1;cont<=7;cont++) eval("form_insert.chb"+cont+".disabled = true");
		document.form_insert.dianum.disabled = false;
	}
}

function InsereTodos(pr_bool) {
	with(document.form_insert) {
		action = 'BuscaTodosUsuarios.asp?var_chavereg=' + pr_bool;
		target = 'ins_todos';
		submit();
	}
}
</script>
</head>
<body bgcolor="#FFFFFF"  text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" Onload="selecionaop();">
<% athBeginDialog WMD_WIDTH, "Agenda - Inser&ccedil;&atilde;o Peri&oacute;dica" %>				
<form name="form_insert" action="insert_periodica_exec.asp" method="post">
<table width="580px" border="0" cellpadding="0" cellspacing="0" style="padding-left:10px; padding-right:10px;">
	<tr> 
		<td colspan="2" valign="top">
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<td><img src="../IMG/IcoToDOInsert.gif" width="36" height="35"></td><td width="15px"></td>
					<td align="justify" style="paddinf-left:8px;" >
						Este formul&aacute;rio permite o agendamento 
						de atividades peri&oacute;dicas diversas, por exemplo, voc&ecirc; pode definir 
						uma atividade para todo dia 20 &agrave;s 12:00 horas durante um per&iacute;odo 
						X, ou definir uma atividade peri&oacute;dica semanal tipo todas as ter&ccedil;as.
					</td>
				</tr>
			</table>
		</td>
  </tr>
	<tr><td colspan="2"><hr/></td></tr>
	<tr><td colspan="2">Defina o intervalo para o agendamento:</td></tr>
	<tr><td colspan="2" height="5px"></td></tr>
	<tr> 
		<td colspan="2">
			<table width="1%" border="0" cellpadding="0" cellspacing="0" style="padding:5px 0px 5px 0px;">
			<tr> 
				<td width="33%" colspan="2">Data de &iacute;nício:</td>
				<td width="33%" colspan="2">Data de fim:</td>
				<td width="34%" colspan="2">Hora:</td>
			</tr>
			<tr><td colspan="6" height="5px"></td></tr>
				<tr>
					<td valign="middle" nowrap="nowrap"><%=InputDate("datainicio","edtext",PrepData(Date,true,false),false)%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span></td>
					<td valign="middle"><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form_insert.datainicio);return false;"><img class="PopcalTrigger" align="absmiddle" src="../img/bullet_dataatual.gif" border="0" alt="" style="cursor:hand" title="ver calendário" hspace="4"></a></td>
					<td valign="middle" nowrap="nowrap"><%=InputDate("datafim","edtext",PrepData(Date,true,false),false)%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span></td>
					<td valign="middle"><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form_insert.datafim);return false;"><img class="PopcalTrigger" align="absmiddle" src="../img/bullet_dataatual.gif" border="0" alt="" style="cursor:hand" title="ver calendário" hspace="4"></a></td>
					<td valign="middle" nowrap="nowrap">
						<input name="var_hh" type="text" class="edtext" style="width:20px;" maxlength="2" value="<%=ATHFormataTamLeft(Hour(now),2,"0")%>" onFocus="this.value=''" onKeyPress="validateNumKey();">&nbsp;h&nbsp;<select name="var_mm" class="edtext" style="width:70px;">							
						<%
						while i<60
							strAUX = "<option value='" & ATHFormataTamLeft(i,2,"0") & "'"
							if Minute(now)<i+2.5 and not bolSELECTED then 
								strAUX = strAUX & " selected"
								bolSELECTED = true
							end if
							strAUX = strAUX & ">" & ATHFormataTamLeft(i,2,"0")
							strAUX = strAUX & " min</option>" & vbcrlf
							Response.Write(strAUX)
							i=i+5
						wend						
						%>
						</select>
					</td>
					<td valign="middle" nowrap="nowrap">&nbsp;<span class="texto_ajuda">&nbsp;<i>hh:mm</i></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="2" height="5px"></td></tr>
	<tr><td colspan="2"><hr/></td></tr>
	<tr><td colspan="2">Inserir atividade apenas nos seguintes meses dentro do per&iacute;odo selecionado:</td></tr>
	<tr><td colspan="2" height="5px"></td></tr>
	<tr> 
		<td colspan="2" align="left" class="Tahomapreta10">
			<table align="left" border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>		
				<% for i=1 to 12 %>	
					<td style="text-align:right;" valign="middle"><input name="mes" type="checkbox" id="chbmes<%=i%>" value="<%=ATHFormataTamLeft(i,2,"0")%>" style="height:15px; width:15px;"></td>
					<td align="left" valign="middle" style="padding-right:2px;">&nbsp;<%=mid(MesExtenso(i),1,3)%></td>
				<%	next %>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="2" height="5px"></td></tr>
	<tr> 
		<td class="Tahomapreta10" valign="middle"><input type="radio" name="r1" id="dianumsel" onClick="selecionaop();" checked>Agendamento pelo dia do m&ecirc;s:</td>
		<td valign="middle">
			<select name="dianum" onFocus="if(disabled)blur();" class="edtext">
				<% for i=1 to 31 %>
					<option value="<%=ATHFormataTamLeft(i,2,"0")%>"><%=ATHFormataTamLeft(i,2,"0")%></option>
				<% next %>
			</select>
		</td>
	</tr>
	<tr><td colspan="2" height="5px"></td></tr>
	<tr>
		<td class="Tahomapreta10" valign="middle"><input type="radio" name="r1" id="diasemsel" onClick="selecionaop();">Agendamento pelo dia da semana:</td>
		<td class="Tahomapreta10" valign="middle" nowrap>
			<table style="text-align:right;" bgcolor="#E4E4E4" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr align="center">
					<td height="22px" width="5px"></td>
					<td valign="middle"><input name="diasem" type="checkbox" value="1" id="chb1" style="height:10px; width:10px;"></td>
					<td valign="middle" style="color:#FF0000;">&nbsp;Dom&nbsp;</td><td width="10px"></td>
					<td valign="middle"><input name="diasem" type="checkbox" value="2" id="chb2" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Seg&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="diasem" type="checkbox" value="3" id="chb3" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Ter&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="diasem" type="checkbox" value="4" id="chb4" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Qua&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="diasem" type="checkbox" value="5" id="chb5" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Qui&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="diasem" type="checkbox" value="6" id="chb6" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Sex&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="diasem" type="checkbox" value="7" id="chb7" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;S&aacute;b&nbsp;</td><td width="15px"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="2"><hr/></td></tr>
	<tr> 
		<td colspan="2">
			<table align="left" border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr> 
					<td width="1%" style="text-align:right;" nowrap="nowrap">*T&iacute;tulo:&nbsp;</td>
					<td colspan="3"><input name="VAR_TITULO" type="text" class="edtext" size="50" style="width:302px;"></td>
				</tr>
				<tr><td colspan="4" height="5px"></td></tr>
				<tr> 
					<td style="text-align:right;" nowrap>*Situa&ccedil;&atilde;o:&nbsp;</td>
					<td colspan="3">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="22%">
									<select name="VAR_SITUACAO" class="edtext" style="width:100px;">
										<option value="ABERTO" selected>ABERTO</option>
										<option value="FECHADO">FECHADO</option>
									</select>
								</td>
								<td width="10%" style="text-align:right;">*Categoria:&nbsp;</td>
								<td width="20%" style="text-align:right;">
									<select name="VAR_COD_E_DESC_CATEGORIA" class="edtext" style="width:128px;">
										<option value="" selected>Selecione</option>
										<%=montaCombo("STR","SELECT COD_CATEGORIA & ' - ' & NOME as FULLCATEG, NOME FROM AG_CATEGORIA WHERE DT_INATIVO is NULL ORDER BY NOME","FULLCATEG","NOME","")%> 
									</select>
								</td>
								<td width="100px"></td>
								<td width="500px" style="text-align:right;">*Prioridade:&nbsp;</td>
								<td width="100px" style="text-align:right;">
									<select name="VAR_PRIORIDADE" class="edtext" style="width:100px;">
										<option value="NORMAL" selected>NORMAL</option>
										<option value="BAIXA">BAIXA</option>
										<option value="MEDIA">MÉDIA</option>
										<option value="ALTA">ALTA</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td colspan="4" height="5px"></td></tr>
				<tr>
					<td style="text-align:right;">*Responsável:&nbsp;</td>
					<td colspan="3">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="22%">								
									<select name="VAR_ID_RESPONSAVEL" class="edtext" style="width:100px;">
										<option value="">Selecione</option>
										<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(Request.Cookies("VBOSS")("ID_USUARIO")))%> 
									</select>
								</td>
								<td width="20%" style="text-align:right;">
									<iframe name="ins_todos" width="0" height="0" src="BuscaTodosUsuarios.asp" frameborder="0"></iframe>		
									*Citados:&nbsp;
								</td>
								<td style="text-align:right;" nowrap>
									<input name="var_id_citados" type="text" class="edtext" value="<%=strCITADOS%>" style="width:211px;">&nbsp;
									<a href="#" onClick="JavaScript:AbreJanelaPAGE('BuscaPorUsuario.asp', '600', '350');">
										<img src="../img/BtBuscar.gif" border="0" align="absmiddle">
									</a>&nbsp;
									<a href="#" onClick="JavaScript:InsereTodos('true');">
										<img src="../img/BtBuscarTodos.gif" border="0" align="absmiddle" title="Inserir todos">
									</a>							
								</td>
							</tr>
						</table>																																
					</td>
				</tr>
				<tr><td colspan="4" height="5px"></td></tr>							
				<tr> 
					<td width="1%" style="text-align:right;">Prev. Horas:&nbsp;</td>
					<td>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td><input name="var_prev_horas" type="text" class="edtext" style="width:40px;" maxlength="5" value="" onKeyPress="validateNumKey();">&nbsp;h&nbsp;</td>
								<td>
									<select name="var_prev_minutos" class="edtext" style="width:70px;">
										<option value="00" selected>00 min</option>
										<option value="25">15 min</option>
										<option value="50">30 min</option>
										<option value="75">45 min</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td colspan="4" height="5px"></td></tr>
				<tr> 
					<td style="text-align:right;" valign="top" nowrap="nowrap">*Tarefa:&nbsp;</td>
					<td colspan="3"><textarea name="VAR_DESCRICAO" class="edtext" style="width:302px; height:80px;"></textarea></td>
				</tr>
				<tr><td colspan="4" height="2px"></td></tr>
				<tr><td style="text-align:right;"></td><td class="texto_ajuda"><i>Campos com <span style="font-size:8px; vertical-align:middle; width:10px;">*</span>são obrigatórios</i></td></tr>			
			</table>
		</td>					
	</tr>
</table>
</form>
<% athEndDialog WMD_WIDTH, "../img/bt_save.gif", "document.form_insert.submit();", "", "", "", "" %>
<iframe name="gToday:normal:agenda.js" id="gToday:normal:agenda.js"
        src="../_calendar/source/ipopeng.htm" scrolling="no" frameborder="0"
        style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe> 
</body>
</html>