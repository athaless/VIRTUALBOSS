<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 585
WMD_WIDTHTTITLES = 100
' -------------------------------------------------------------------------------
Dim i, CFG_TD_BLANK
CFG_TD_BLANK = "<td width='12px'></td>"

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
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" Onload="selecionaop();">
<% athBeginDialog WMD_WIDTH, "ToDo List - Inser&ccedil;&atilde;o Peri&oacute;dica" %>
<form name="form_insert" action="insert_periodica_exec.asp" method="post">
<input type="hidden" name="var_situacao" value="ABERTO">
<table width="580px" border="0" cellpadding="0" cellspacing="0" style="padding-left:10px; padding-right:10px;">
	<tr> 
		<td colspan="3" valign="top">
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
	<tr><td colspan="3"><hr/></td></tr>
	<tr><td colspan="3">Defina o intervalo para o agendamento:</td></tr>
	<tr><td colspan="3" height="5px"></td></tr>
	<tr> 
		<td colspan="3">
			<table width="300" border="0" cellpadding="0" cellspacing="0" style="padding:5px 0px 5px 0px;">
			<tr> 
				<td width="33%" colspan="2">Data de &iacute;nício:</td>
				<td width="67%" colspan="2">Data de fim:</td>
			</tr>
			<tr><td colspan="2" height="5px"></td></tr>
			<tr>
				<td valign="middle" nowrap="nowrap"><%=InputDate("var_data_inicio","edtext",PrepData(Date,true,false),false)%><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form_insert.var_data_inicio);return false;"><img class="PopcalTrigger" align="absmiddle" src="../img/bullet_dataatual.gif" border="0" alt="" style="cursor:hand" title="ver calendário" hspace="4"></a><span class="texto_ajuda"><i>dd/mm/aaaa</i></span></td>
				<td valign="middle">&nbsp;</td>
				<td valign="middle" nowrap="nowrap"><%=InputDate("var_data_fim","edtext",PrepData(Date,true,false),false)%><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form_insert.var_data_fim);return false;"><img class="PopcalTrigger" align="absmiddle" src="../img/bullet_dataatual.gif" border="0" alt="" style="cursor:hand" title="ver calendário" hspace="4"></a><span class="texto_ajuda"><i>dd/mm/aaaa</i></span></td>
				<td valign="middle"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="3"><hr/></td></tr>
	<tr><td colspan="3">Inserir atividade apenas nos seguintes meses dentro do per&iacute;odo selecionado:</td></tr>
	<tr><td colspan="3" height="5px"></td></tr>
	<tr> 
		<td colspan="3" align="left" class="Tahomapreta10">
			<table align="left" border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>		
				<% for i=1 to 12
						if i<10 then %>						
							<td style="text-align:right;" valign="middle"><input name="var_mes" type="checkbox" id="chbmes<%=i%>" value="0<%=i%>" style="height:15px; width:15px;"></td>
							<td align="left" valign="middle" style="padding-right:2px;">&nbsp;<%=mid(MesExtenso(i),1,3)%></td>
				<%		else %>
							<td style="text-align:right;" valign="middle"><input name="var_mes" type="checkbox" id="chbmes<%=i%>" value="<%=i%>" style="height:15px; width:15px;"></td>
							<td align="left" valign="middle" style="padding-right:2px;">&nbsp;<%=mid(MesExtenso(i),1,3)%></td>
				<%
						end if
					next
				%>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="3" height="5px"></td></tr>
	<tr> 
		<td class="Tahomapreta10" valign="middle"><input type="radio" name="r1" id="var_dianumsel" onClick="selecionaop();" checked/>Agendamento pelo dia do m&ecirc;s:</td>
		<td valign="middle" colspan="2">
			<select name="var_dianum" onFocus="if(disabled)blur();" class="edtext">
				<% for i=1 to 31 %>
					<option value="<%=i%>"><%=i%></option>
				<% next %>
			</select>
		</td>
	</tr>
	<tr><td colspan="3" height="5px"></td></tr>
	<tr>
		<td class="Tahomapreta10" valign="middle"><input type="radio" name="r1" id="var_diasemsel" onClick="selecionaop();" />Agendamento pelo dia da semana:</td>
		<td class="Tahomapreta10" valign="middle" nowrap colspan="2">
			<table style="text-align:right;" bgcolor="#E4E4E4" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr align="center">
					<td height="22px" width="5px"></td>
					<td valign="middle"><input name="var_diasem" type="checkbox" value="1" id="chb1" style="height:10px; width:10px;"></td>
					<td valign="middle" style="color:#FF0000;">&nbsp;Dom&nbsp;</td><td width="10px"></td>
					<td valign="middle"><input name="var_diasem" type="checkbox" value="2" id="chb2" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Seg&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="var_diasem" type="checkbox" value="3" id="chb3" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Ter&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="var_diasem" type="checkbox" value="4" id="chb4" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Qua&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="var_diasem" type="checkbox" value="5" id="chb5" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Qui&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="var_diasem" type="checkbox" value="6" id="chb6" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;Sex&nbsp;</td><%=CFG_TD_BLANK%>
					<td valign="middle"><input name="var_diasem" type="checkbox" value="7" id="chb7" style="height:10px; width:10px;"></td>
					<td valign="middle">&nbsp;S&aacute;b&nbsp;</td><td width="15px"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="3"><hr/></td></tr>
	<tr> 
		<td colspan="3">
			<table align="left" border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr> 
					<td width="1%" style="text-align:right;" nowrap="nowrap">*T&iacute;tulo:&nbsp;</td>
					<td colspan="3"><input name="var_titulo" type="text" class="edtext" size="50" style="width:302px;"></td>
				</tr>
				<tr><td colspan="4" height="5px"></td></tr>
				<tr> 
					<td style="text-align:right;" nowrap="nowrap">*Situação:&nbsp;</td>
					<td colspan="3">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="22%">
									<select name="var_situacao" class="edtext" style="width:100px;">
										<option value="ABERTO" selected>ABERTO</option>
										<option value="OCULTO">OCULTO</option>
									</select>
								</td>
								<td width="20%" style="text-align:right;" nowrap="nowrap">&nbsp;*Categoria:&nbsp;</td>
								<td width="20%" style="text-align:right;">
									<select name="var_cod_e_desc_categoria" class="edtext" style="width:100px">
										<option value="" selected>Selecione</option>
										<%
				strSQL = " SELECT COD_CATEGORIA, NOME FROM TL_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME "
				Set objRSAux = objConn.Execute(strSQL)
				
				Do While Not objRSAux.Eof
					Response.Write("<option value='" & GetValue(objRSAux,"COD_CATEGORIA") & " - " & GetValue(objRSAux,"NOME") & "'>")
					Response.Write(GetValue(objRSAux,"NOME") & "</option>")
					
					objRSAux.MoveNext
				Loop
				FechaRecordSet objRSAux
										%>
									</select>
								</td>
								<td width="20%" style="text-align:right;" nowrap="nowrap">&nbsp;*Prioridade:&nbsp;</td>
								<td width="20%" style="text-align:right;">
									<select name="var_prioridade" class="edtext" style="width:100px">
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
					<td style="text-align:right;" nowrap>*Responsável:&nbsp;</td>
					<td colspan="3">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="22%">								
									<select name="var_id_responsavel" class="edtext" style="width:100px">
										<option value="">Selecione</option>
										<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(Request.Cookies("VBOSS")("ID_USUARIO")))%> 
									</select>
								</td>
								<td width="20%" style="text-align:right;" nowrap="nowrap">&nbsp;*Executor:&nbsp;</td>
								<td width="20%" style="text-align:right;">
									<select name="var_id_executor" size="1" class="edtext" style="width:100px">
										<option value="">Selecione</option>
										<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO","")%> 
									</select>
								</td>	
								<td width="60.99%"></td>
							</tr>
						</table>																																
					</td>
				</tr>
				<tr><td colspan="4" height="5px"></td></tr>							
				<tr> 
					<td width="1%" style="text-align:right;">Hora de Início:&nbsp;</td>
					<td>
					<select name="var_prev_hr_ini_hora" size="1" class="edtext">
						<option value="" selected="selected"></option>
						<% 
						For Cont = 0 to 23
							If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
							Response.Write("<option value='" & strVALOR & "'>" & strVALOR & "</option>")
						Next
						%>
					</select>
					<select name="var_prev_hr_ini_min" size="1" class="edtext">
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
					</td>
				</tr>
				<tr><td colspan="4" height="5px"></td></tr>							
				<tr> 
					<td width="1%" style="text-align:right;">Prev. Horas:&nbsp;</td>
					<td>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td><input name="var_prev_horas" type="text" class="edtext" style="width:50px" maxlength="5" value="" onKeyPress="validateNumKey();">&nbsp;h&nbsp;</td>
								<td>
									<select name="var_prev_minutos" class="edtext" style="width:70px">
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
					<td colspan="3"><textarea name="var_descricao" class="edtext" style="width:302px; height:80px;"></textarea></td>
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
<%
FechaDBConn objConn
%>