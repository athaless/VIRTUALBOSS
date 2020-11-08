<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 
 Dim objConn, strSQL, objRS, objRSAux, strEntCliRef, strSQLCombo
 Dim auxCont, auxSTR
 Dim strBGCOLOR1, strBGCOLOR2, strBGCOLOR3, strBGCOLOR4, strBGCOLOR5, strBGCOLOR6 
 Dim strUSER_ID, strDIA_SEL, strPARAMS
 Dim intTamNew
 Dim bUpdTODO, bInsRespTODO, bViewTODO
 Dim strGRUPOS, strGRUPO_USUARIO, strCOOKIE_ID_USUARIO
 Dim strDT_INI, strHORAS, strWeekDay
 Dim strDT_ENVIO, strTELA, strNUM_DIAS, strTIPO_ENTIDADE, strEXIBE_ENQUETE, strVAL1
 
 Dim strTPNote
  
 Dim strCOD_CATEGORIA, strCOD_CATEGORIA_Old
 Dim strCOD_CHAMADO, strSITUACAO, strSITUACAO_Old
 
 dim matMeusCh(), matOutrCh()
 dim intTAMlin, intTAMcol
 dim i,strUSUARIO
 
 strDIA_SEL = GetParam("var_dia_selected")
 
 If strDIA_SEL = "" Then strDIA_SEL = Date
 
 strBGCOLOR1 = "#DADCD9" 'Borda da linha da tabela 
 strBGCOLOR2 = "#F7F7F7" 'Fundo do cabeçalho 
 strBGCOLOR3 = "#F7F7F7" 'Fundo das linhas 
 strBGCOLOR4 = "#FFFFFF" 'Fundo das linhas 
 strBGCOLOR5 = "#E7E7E7" 
 strBGCOLOR6 = "#000000" 
 
 strNUM_DIAS = 5 'Exibir ToDos de chamados fechados até X dias atrás
 
 const CH_COD     = 0
 const CH_TIT     = 1
 const CH_PRIO    = 2
 const CH_SIT     = 3
 const CH_ARQ     = 4
 const CH_DTT_INS = 5
 const CH_USR_INS = 6
 const CH_DTT_UPD = 7
 const CH_USR_UPD = 8
 
 const CAT_COD  = 9
 const CAT_NOME = 10
 
 const TASK_COD    = 11
 const TASK_DT_INI = 12
 const TASK_PREV   = 13
 const TASK_RESP   = 14
 const TASK_EXEC   = 15
 const TASK_SIT    = 16
 
 const RESP_FROM    = 17
 const RESP_TO      = 18
 const RESP_DTT_INS = 19
 
 Function ExibeCATEGORIA(prCODIGO, prNOME)
	Dim strSAIDA
	
	strSAIDA =            "<table width='99%' height='20' bgcolor='#E9E9E9' cellpadding='2' cellspacing='0'>" & vbNewLine
	strSAIDA = strSAIDA & "	  <tr>" & vbNewLine
	strSAIDA = strSAIDA & "		<td width='16' align='center'><a href=""Javascript: MyShowArea('categ_" & prCODIGO & "', 'icon_categ_" & prCODIGO & "');""><img src='../img/BulletMenos.gif' border='0' align='absmiddle' name='icon_categ_" & prCODIGO & "' id='icon_categ_" & prCODIGO & "'></a></td>" & vbNewLine
	strSAIDA = strSAIDA & "		<td>" & prNOME & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	  </tr>" & vbNewLine
	strSAIDA = strSAIDA & "</table>" & vbNewLine
	strSAIDA = strSAIDA & "<div id='categ_" & prCODIGO & "' style='padding:0px;'>" & vbNewLine
	
	ExibeCATEGORIA = strSAIDA
 End Function
 
 Function ExibeMEUS_CHAMADOS(prCODIGO, prTITULO, prPRIORIDADE, prSITUACAO, prARQ_ANEXO, prDTT_INS, prUSR_INS, prDTT_UPD, prUSR_UPD, prTASK_COD, prTASK_DT_INI, prTASK_PREV, prTASK_RESP, prTASK_EXEC, prTASK_SIT, prRESP_FROM, prRESP_TO, prRESP_DTT_INS, prCABECALHO)
	Dim strSAIDA, auxBgColor
	
	if prTASK_PREV<>"" then prTASK_PREV = FormataHoraNumToHHMM(prTASK_PREV) else prTASK_PREV = "&nbsp;" end if
	auxBgColor="#FFFFF0"
	'if IsDate(prDT_INI) then
	'	if (prSITUACAO<>"FECHADO") then
	'		if (prDT_INI<Now) then auxBgColor = "#FFF0F0"
	'		if (prDT_INI=Date) then auxBgColor = "#FFFFF0"
	'	end if
	'else
	'	auxBgColor = "#FFFFFF"
	'end if
	
	If prCABECALHO Then
		strSAIDA =            "<table width='99%' height='20' bgcolor='#FFFFFF' cellpadding='2' cellspacing='1' border='0'>" & vbNewLine
		strSAIDA = strSAIDA & "<tr bgcolor='#EFEDED' class='arial11' valign='middle'>" & vbNewLine

		strSAIDA = strSAIDA & "	<td width='10' bgcolor='#FFFFFF'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'></td>"				& vbNewLine 
		strSAIDA = strSAIDA & "	<td width='10'></td>"				& vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'></td>"				& vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'>Cod</td>"			& vbNewLine
		strSAIDA = strSAIDA & "	<td width=''>Título</td>"			& vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'>User</td>"			& vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'>Solicitação</td>"	& vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'></td>" 				& vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'></td>"				& vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'></td>"				& vbNewLine
		strSAIDA = strSAIDA & "	<td width='' nowrap='nowrap'>Tarefa para</td>"	& vbNewLine
		strSAIDA = strSAIDA & "	<td width='' nowrap='nowrap'>Prev Hs</td>"		& vbNewLine
		strSAIDA = strSAIDA & "	<td width=''>Últ interação</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'>De</td>"				& vbNewLine
		strSAIDA = strSAIDA & "	<td width='10'>Para</td>"			& vbNewLine

		strSAIDA = strSAIDA & "</tr>" & vbNewLine
		'Linha fina e escura --------------------------------------------------
		strSAIDA = strSAIDA & "<tr>" & vbNewLine
		strSAIDA = strSAIDA & " <td></td>" & vbNewLine
		strSAIDA = strSAIDA & " <td colspan='15' height='1' bgcolor='#C9C9C9'></td>" & vbNewLine
		strSAIDA = strSAIDA & "</tr>" & vbNewLine
	End If
	
	strSAIDA = strSAIDA & "<tr bgcolor='" & auxBgColor & "' class='arial11' valign='middle'>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='12' bgcolor='#FFFFFF'></td>" & vbNewLine

	strSAIDA = strSAIDA & "	<td align='center' valign='top'>"
	If prSITUACAO = "FECHADO" Then
		strSAIDA = strSAIDA & MontaLinkPopup("modulo_CHAMADO", "Evaluate.asp", prTASK_COD, "IconAction_EVALUATE.gif", "AVALIAR", "720", "550", "yes")
	End If
	strSAIDA = strSAIDA & " </td>" & vbNewLine

	strSAIDA = strSAIDA & "	<td align='center' valign='top'>"
	If bViewTODO Then
		strSAIDA = strSAIDA & MontaLinkPopup("modulo_CHAMADO", "DetailHistorico.asp", prTASK_COD, "IconAction_DETAIL.gif", "VISUALIZAR", "720", "550", "yes")
	End If
	strSAIDA = strSAIDA & " </td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td align='center' valign='top'>"
	If (bInsRespTODO And (LCase(prTASK_RESP) = strUSER_ID Or LCase(prTASK_EXEC) = strUSER_ID)) Then
		strSAIDA = strSAIDA & MontaLinkGrade("modulo_CHAMADO", "InsertResposta.asp", prTASK_COD, "IconAction_DETAILadd.gif", "INSERIR RESPOSTA")
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td valign='top'>" & prTASK_COD & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & prTITULO & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & prUSR_INS & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top' nowrap='nowrap'>" & prDTT_INS & "</td>" & vbNewLine
	strSAIDA = strSAIDA & " <td align='center' valign='top'><img src='../img/IconStatus_" & prSITUACAO & ".gif' alt='SITUAÇÃO: " & prSITUACAO & "' title='SITUAÇÃO: " & prSITUACAO & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td align='center' valign='top'><img src='../img/IconPrio_" & prPRIORIDADE & ".gif' alt='PRIORIDADE: " & prPRIORIDADE & "' title='PRIORIDADE: " & prPRIORIDADE & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td align='center' valign='top'>"
	If prARQ_ANEXO <> "" Then
		'strSAIDA = strSAIDA & "<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/TODO_Anexos/" & prARQ_ANEXO & "' target='_blank' style='cursor:hand;'>"
        strSAIDA = strSAIDA & "<a href='../athdownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME") & "&var_tipo=TODO_Anexos&var_arquivo=" & prARQ_ANEXO & "' target='_blank' style='cursor:hand;'>"
		strSAIDA = strSAIDA & "<img src='../img/IcoAnexo.gif' title='ANEXO: " & prARQ_ANEXO & "' border='0'>"
		strSAIDA = strSAIDA & "</a>"
	End If
	strSAIDA = strSAIDA & "</td>"
	
	strSAIDA = strSAIDA & "	<td valign='top'>" & prTASK_DT_INI & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & prTASK_PREV & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top' nowrap='nowrap'>" & prRESP_DTT_INS & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & LCase(prRESP_FROM) & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & LCase(prRESP_TO) & "</td>" & vbNewLine
	
	'If prTASK_SIT <> "" Then
	'	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top' height='20'><img src='../img/IconStatus_" & prTASK_SIT & ".gif' title='SITUAÇÃO: " & prTASK_SIT & "'></td>" & vbNewLine
	'End If
	
	strSAIDA = strSAIDA & "</tr>" & vbNewLine
	
	'Final da tabela é por fora, quando se troca de Categoria
	'strSAIDA = strSAIDA & "</table>" & vbNewLine
	
	ExibeMEUS_CHAMADOS = strSAIDA
 End Function
 
 Function ExibeOUTROS_CHAMADOS(prCODIGO, prTITULO, prPRIORIDADE, prSITUACAO, prARQ_ANEXO, prDTT_INS, prUSR_INS, prDTT_UPD, prUSR_UPD, prTASK_COD, prTASK_DT_INI, prTASK_PREV, prTASK_RESP, prTASK_EXEC, prTASK_SIT, prCABECALHO)
	Dim strSAIDA, auxBgColor
	
	if prTASK_PREV<>"" then prTASK_PREV = FormataHoraNumToHHMM(prTASK_PREV) else prTASK_PREV = "&nbsp;" end if
	auxBgColor="#FFFFF0"
	'if IsDate(prDT_INI) then
	'	if (prSITUACAO<>"FECHADO") then
	'		if (prDT_INI<Now) then auxBgColor = "#FFF0F0"
	'		if (prDT_INI=Date) then auxBgColor = "#FFFFF0"
	'	end if
	'else
	'	auxBgColor = "#FFFFFF"
	'end if
	
	If prCABECALHO Then
		strSAIDA =            "<table width='99%' height='20' bgcolor='#FFFFFF' cellpadding='2' cellspacing='1' border='0'>" & vbNewLine
		strSAIDA = strSAIDA & "<tr bgcolor='#EFEDED' class='arial11' valign='middle'>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16' bgcolor='#FFFFFF'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='30'>Cod</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td nowrap>Título</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td colspan='2' width='90' nowrap='nowrap'>Solicitação</td>" & vbNewLine
		'strSAIDA = strSAIDA & "	<td width='30'>Alterado por</td>" & vbNewLine
		'strSAIDA = strSAIDA & "	<td width='20'>em</td>" & vbNewLine
		'strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='60'>Tarefa para</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='40'>Prev Hs</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='60'>Executor atual</td>" & vbNewLine
		'strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "</tr>" & vbNewLine
		
		'Linha fina e escura
		strSAIDA = strSAIDA & "<tr>" & vbNewLine
		strSAIDA = strSAIDA & " <td></td>" & vbNewLine
		strSAIDA = strSAIDA & " <td colspan='12' height='1' bgcolor='#C9C9C9'></td>" & vbNewLine
		strSAIDA = strSAIDA & "</tr>" & vbNewLine
	End If
	
	strSAIDA = strSAIDA & "<tr bgcolor='" & auxBgColor & "' class='arial11' valign='middle'>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' bgcolor='#FFFFFF'></td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If bViewTODO Then
		strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_CHAMADO/DetailHistorico.asp?var_chavereg=" & prTASK_COD & "'><img src='../img/IconAction_DETAIL.gif' border='0' alt='VISUALIZAR' title='VISUALIZAR'></a>"
	End If
	strSAIDA = strSAIDA & " </td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If (bInsRespTODO And (LCase(prTASK_RESP) = strUSER_ID Or LCase(prTASK_EXEC) = strUSER_ID)) Then
		strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_CHAMADO/DetailHistorico.asp?var_chavereg=" & prTASK_COD & "&var_resposta=true'><img src='../img/IconAction_DETAILadd.gif' border='0' alt='INSERIR ANDAMENTO' title='INSERIR ANDAMENTO'></a>"
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td valign='top'>" & prTASK_COD & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & prTITULO & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='60' valign='top'>" & prUSR_INS & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='30' valign='top' nowrap='nowrap'>" & prDTT_INS & "</td>" & vbNewLine
	'strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top' height='20'><img src='../img/IconStatus_" & prSITUACAO & ".gif' title='SITUAÇÃO: " & prSITUACAO & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'><img src='../img/IconPrio_" & prPRIORIDADE & ".gif' alt='PRIORIDADE: " & prPRIORIDADE & "' title='PRIORIDADE: " & prPRIORIDADE & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If prARQ_ANEXO <> "" Then
		'strSAIDA = strSAIDA & "<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/TODO_Anexos/" & prARQ_ANEXO & "' target='_blank' style='cursor:hand;'>"
		strSAIDA = strSAIDA & "<a href='../athdownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME") & "&var_tipo=TODO_Anexos&var_arquivo=" & prARQ_ANEXO & "' target='_blank' style='cursor:hand;'>"		
		strSAIDA = strSAIDA & "<img src='../img/IcoAnexo.gif' title='ANEXO: " & prARQ_ANEXO & "' border='0'>"
		strSAIDA = strSAIDA & "</a>"
	End If
	strSAIDA = strSAIDA & "</td>"
	
	strSAIDA = strSAIDA & "	<td width='60' valign='top'>" & prTASK_DT_INI & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='40' valign='top'>" & prTASK_PREV & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='90' valign='top'>" & LCase(prTASK_EXEC) & "</td>" & vbNewLine
	
	'If prTASK_SIT <> "" Then
	'	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top' height='20'><img src='../img/IconStatus_" & prTASK_SIT & ".gif' title='SITUAÇÃO: " & prTASK_SIT & "'></td>" & vbNewLine
	'End If
	
	strSAIDA = strSAIDA & "</tr>" & vbNewLine
	
	'Final da tabela é por fora, quando se troca de Categoria
	'strSAIDA = strSAIDA & "</table>" & vbNewLine
	
	ExibeOUTROS_CHAMADOS = strSAIDA
 End Function
 
 AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
function pageReload(prView) {
  document.location ='painel.asp?var_view=' + prView + '&var_dia_selected=<%=strDIA_SEL%>';
}
</script>
</head>
<body>
<!-- body onLoad="<!-- AbreJanelaPAGENew('Evaluate_verify.asp', '640', '480', 'no', 'yes');" //-->
	<div style="padding-top:4px;">
		<!-- Moldura A INIC -->
		<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="5" height="100%">&nbsp;</td>
				<td width="164" height="100%" valign="top">
                	<!--#include file="../_include/_IncludePainel_Enquete.asp"-->
					<!-- Tabela pro CALENDÁRIO INIC -->
					<table width="170" cellpadding="0" cellspacing="0" border="0" align="center" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
					<tr>
						<td bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td align="left">
                                </td>
							</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td valign="top" align="left" bgcolor="#FFFFFF">
						<div align="left" style="padding-left:5px;">
							<iframe name="vboss_frcalendar" src="Box_Calendar.asp?var_dia_selected=<%=strDIA_SEL%>" width="160" height="150" frameborder="0"></iframe>
						</div>
						</td>
					</tr>
					</table>
					<!-- Tabela pro CALENDÁRIO FIM -->										
					<!--#include file="../_include/_IncludePainel_Mensagens.asp"-->                    
					<!--#include file="../_include/_IncludePainel_UsrChamado.asp"-->
                    
                    
				</td>
				<td width="5" height="100%">&nbsp;</td>
				<td width="96%" height="100%" valign="top">
				    <% strTPNote = "%" %>
					<!--#include file="../_include/_IncludePainel_Notepad.asp"-->
                    <iframe id="vboss_frVerifyEvaluate" name="vboss_frVerifyEvaluate" src="Evaluate_verify.asp" width="100%" height="500" frameborder="0" scrolling="no"></iframe>
					<!--#include file="../_include/_IncludePainel_ChamadosAbertos.asp"-->
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<tr><td width="100%" height="30%"><!--#include file="../_include/_IncludePainel_ChamadosMeus.asp"--></td></tr>
						<tr><td width="100%" height="30%"><!--#include file="../_include/_IncludePainel_ChamadosOutros.asp"--></td></tr>
					</table>
                  <!-- Moldura B FIM -->
				  </td></tr>
				</td>
				<td width="5" height="100%">&nbsp;</td>
			</tr>
			<tr><td colspan="3" height="4"></td></tr> <!-- Apenas Margem -->
		</table>
		<!-- Moldura A FIM -->
	</div>
</body>
</html>
<%
  FechaDBConn objConn
%>