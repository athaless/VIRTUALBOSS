<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Dim objConn, objRS, strSQL, auxSTRTIT
 Dim strSAIDA, auxBgColor, strMARGEM
 Dim strCOD_CLIENTE, strCOD_CLIENTE_Old, strCOD_CLI
 Dim bSEM_CHAMADOS, bATENDE, bEDITA, bDELETA, bDESBLOQUEIA
 
 strMARGEM  = GetParam("var_margem")
 strCOD_CLI = GetParam("var_cod_cli") 'pode receber os códigos dos clientes que o user pode ver os chamado (separados por virgula - enviado pelo IncludePainel_ChamadosAbertos.asp)
 
 if strCOD_CLI = "" then Response.End()
  
 'Grava a última opção de filtragem selecionada
 Response.Cookies("VBOSS")("PREF_FITLRO_CHAMADOS") = strCOD_CLI
 
 AbreDBConn objConn, CFG_DB 

  Function ExibeCLIENTE(prCODIGO, prCLIENTE)
	Dim strSAIDA
	
	strSAIDA =            "<table width='100%' height='20' bgcolor='#E9E9E9' cellpadding='2' cellspacing='0'>" & vbNewLine
	strSAIDA = strSAIDA & "	  <tr>" & vbNewLine
	strSAIDA = strSAIDA & "		<td width='16' align='center'><a href=""Javascript: MyShowArea('cli_" & prCODIGO & "', 'icon_cli_" & prCODIGO & "');""><img src='../img/BulletMenos.gif' border='0' align='absmiddle' name='icon_cli_" & prCODIGO & "' id='icon_cli_" & prCODIGO & "'></a></td>" & vbNewLine
	strSAIDA = strSAIDA & "		<td>" & prCODIGO & " - " & prCLIENTE & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	  </tr>" & vbNewLine
	strSAIDA = strSAIDA & "</table>" & vbNewLine
	strSAIDA = strSAIDA & "<div id='cli_" & prCODIGO & "' style='padding:0px;'>" & vbNewLine
	
	ExibeCLIENTE = strSAIDA
  End Function
  
  Function ExibeCHAMADO(prCODIGO, prTITULO, prCATEGORIA, prREQUISITANTE, prQUANDO, prPRIORIDADE, prSITUACAO, prARQUIVO_ANEXO, prVALOR, prBGCOLOR, prCABECALHO, prDELETA, prEDITA, prATENDE, prLIBERA)
	Dim strSAIDA
	
	strSAIDA = ""
	
	If prCABECALHO Then
		strSAIDA = strSAIDA & "<table width='100%' height='20' bgcolor='#FFFFFF' cellpadding='2' cellspacing='1' border='0'>"
		strSAIDA = strSAIDA & "<tr bgcolor='#EFEDED' class='arial11' valign='middle'>"
		strSAIDA = strSAIDA & "	<td bgcolor='#FFFFFF'></td>"
		strSAIDA = strSAIDA & "	<td></td>"
		strSAIDA = strSAIDA & "	<td></td>"
		strSAIDA = strSAIDA & "	<td></td>"
		strSAIDA = strSAIDA & "	<td></td>"
		strSAIDA = strSAIDA & "	<td align='left'>Categoria</td>"
		strSAIDA = strSAIDA & "	<td align='left'>Título</td>"
		strSAIDA = strSAIDA & "	<td colspan='2' align='left'>Solicitação</td>"
		strSAIDA = strSAIDA & "	<td></td>"
		strSAIDA = strSAIDA & "	<td></td>"
		strSAIDA = strSAIDA & "	<td></td>"
		strSAIDA = strSAIDA & "</tr>"
		strSAIDA = strSAIDA & "<tr><td bgcolor='#FFFFFF'><td colspan='11' height='1' bgcolor='#C9C9C9'></td></tr>"
	End If
	
	strSAIDA = strSAIDA & "<tr class='arial11' valign='middle' bgcolor='" & prBGCOLOR & "'>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' bgcolor='#FFFFFF'></td>"
	strSAIDA = strSAIDA & "	<td width='16'>"
	If prDELETA Then strSAIDA = strSAIDA & "<a target='_parent' style='cursor:hand;' href='../modulo_CHAMADO/Delete.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_DEL.gif' border='0' alt='DELETAR' title='DELETAR'></a>"
	strSAIDA = strSAIDA & " </td>"
	strSAIDA = strSAIDA & "	<td width='16'>"
	If prEDITA Then strSAIDA = strSAIDA & "<a target='_parent' style='cursor:hand;' href='../modulo_CHAMADO/Update.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_EDIT.gif' border='0' alt='ALTERAR' title='ALTERAR'></a>"
	strSAIDA = strSAIDA & " </td>"
	strSAIDA = strSAIDA & "	<td width='16'><a href=""JavaScript:AbreJanelaPAGENew('../modulo_CHAMADO/Detail.asp?var_chavereg=" & prCODIGO & "', '700', '450', 'yes', 'yes');""><img src='../img/IconAction_DETAIL.gif' border='0' alt='VISUALIZAR' title='VISUALIZAR'></a></td>"
	strSAIDA = strSAIDA & "	<td width='16'>"
	If prSITUACAO = "ABERTO" And prATENDE Then strSAIDA = strSAIDA & "<a target='_parent' style='cursor:hand;' href='../modulo_CHAMADO/Atende_Chamado.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_PLAY.gif' border='0' alt='ATENDER' title='ATENDER'></a>"
	If prSITUACAO = "BLOQUEADO" And prLIBERA Then strSAIDA = strSAIDA & "<a target='_parent' style='cursor:hand;' href='../modulo_CHAMADO/Desbloqueia_Chamado.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_BLOQUED.gif' border='0' alt='DESBLOQUEAR' title='DESBLOQUEAR'></a>"
	strSAIDA = strSAIDA & " </td>"
	strSAIDA = strSAIDA & "	<td width='90' valign='top' align='left'>" & prCATEGORIA & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top' align='left'>" & prTITULO
	If CDbl("0" & prVALOR) > 0 Then strSAIDA = strSAIDA & " ($)"
	strSAIDA = strSAIDA & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='80' valign='top' align='left'>" & prREQUISITANTE & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='120' valign='top' align='left'>" & prQUANDO & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'><img src='../img/IconStatus_" & prSITUACAO & ".gif' title='SITUACAO: " & prSITUACAO & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'><img src='../img/IconPrio_" & prPRIORIDADE & ".gif' title='PRIORIDADE: " & prPRIORIDADE & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If prARQUIVO_ANEXO <> "" Then	   
		'strSAIDA = strSAIDA & "<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/TODO_Anexos/" & prARQUIVO_ANEXO & "' target='_blank' style='cursor:hand;'>"
  		strSAIDA = strSAIDA & "<a href='../athdownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME") & "&var_tipo=TODO_Anexos&var_arquivo=" & prARQUIVO_ANEXO & "' target='_blank' style='cursor:hand;'>"
		strSAIDA = strSAIDA & "<img src='../img/IcoAnexo.gif' border='0' title='ANEXO: " & prARQUIVO_ANEXO & "'>"
		strSAIDA = strSAIDA & "</a>"
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	strSAIDA = strSAIDA & "</tr>" & vbNewLine
	
	ExibeCHAMADO = strSAIDA
  End Function
  
  strSQL =          " SELECT T1.COD_CHAMADO, T1.TITULO, T1.PRIORIDADE, T1.ARQUIVO_ANEXO, T1.SITUACAO, T1.VALOR, T1.EXTRA "
  strSQL = strSQL & "      , T1.SYS_DTT_INS, T1.SYS_ID_USUARIO_INS, T2.NOME AS CATEGORIA "
  strSQL = strSQL & "      , T3.COD_CLIENTE, T3.NOME_FANTASIA AS CLIENTE "
  strSQL = strSQL & " FROM CH_CHAMADO T1, CH_CATEGORIA T2, ENT_CLIENTE T3 "
  strSQL = strSQL & " WHERE (T1.SITUACAO LIKE 'ABERTO' OR T1.SITUACAO LIKE 'BLOQUEADO') "
  strSQL = strSQL & " AND T1.COD_CATEGORIA = T2.COD_CATEGORIA "
  strSQL = strSQL & " AND T1.COD_CLI = T3.COD_CLIENTE "
  If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" And Request.Cookies("VBOSS")("ENTIDADE_TIPO") = "ENT_CLIENTE" Then
  	strSQL = strSQL & " AND T3.COD_CLIENTE = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
  Else
	If strCOD_CLI <> "" Then
		strSQL = strSQL & " AND T3.COD_CLIENTE IN (" & strCOD_CLI & ")" 'ATENÇÃO - Utilizar sempre "IN (<codigo cliente>)"  pois na variavel pode vir mais de um código separado por virgula
	End If
  End If
  strSQL = strSQL & " ORDER BY T3.NOME_FANTASIA, T1.SYS_DTT_INS "
'response.Write(strSQL)
  Set objRS = objConn.Execute(strSQL)
  
  bSEM_CHAMADOS = True
  If Not objRS.Eof Then bSEM_CHAMADOS = False
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<% If strMARGEM = "sim" Then %>
	<body leftmargin="8" topmargin="8" bottommargin="8" rightmargin="8">
<% Else %>
	<body leftmargin="0" topmargin="0" bottommargin="0" rightmargin="0">
<% End If %>
<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
<tr>
	<td align="left">
  <%
  strCOD_CLIENTE = ""
  strCOD_CLIENTE_Old = "-1"
  
  bATENDE      = VerificaDireito("|ATENDE|"     , BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), False)
  bDESBLOQUEIA = VerificaDireito("|DESBLOQUEIA|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), False)
  
  Do While Not objRS.Eof
	strCOD_CLIENTE = GetValue(objRS, "COD_CLIENTE")
	
	bEDITA = (GetValue(objRS, "SYS_ID_USUARIO_INS") = Request.Cookies("VBOSS")("ID_USUARIO"))
	bDELETA = (GetValue(objRS, "SYS_ID_USUARIO_INS") = Request.Cookies("VBOSS")("ID_USUARIO"))
	
	'auxBgColor = "#FFFFF0"
	'if IsDate(GetValue(objRS, "SYS_DTT_INS")) then
	'	if (GetValue(objRS, "SYS_DTT_INS") < Date) then auxBgColor = "#FFF0F0"
	'	if (GetValue(objRS, "SYS_DTT_INS") = Date) then auxBgColor = "#FFFFF0"
	'else
	'	auxBgColor = "#FFFFFF"
	'end if
	
	auxBgColor = "#FFFFFF"
	
	auxSTRTIT = GetValue(objRS, "COD_CHAMADO") & " - " & GetValue(objRS, "TITULO") 
	If (GetValue(objRS, "EXTRA")<>"") Then auxSTRTIT = auxSTRTIT & " (" & GetValue(objRS, "EXTRA") & ")"

	If (strCOD_CLIENTE <> strCOD_CLIENTE_Old) Then 
		If strCOD_CLIENTE_Old <> "-1" Then Response.Write("</table><!--cli_" & strCOD_CLIENTE_Old & "--></div>" & vbNewLine)
		
		Response.Write(ExibeCLIENTE(GetValue(objRS, "COD_CLIENTE"), GetValue(objRS, "CLIENTE")))
		Response.Write(ExibeCHAMADO(GetValue(objRS, "COD_CHAMADO"),auxSTRTIT, GetValue(objRS, "CATEGORIA"), GetValue(objRS, "SYS_ID_USUARIO_INS"), PrepData(GetValue(objRS, "SYS_DTT_INS"), True, True), GetValue(objRS, "PRIORIDADE"), GetValue(objRS, "SITUACAO"), GetValue(objRS, "ARQUIVO_ANEXO"), GetValue(objRS, "VALOR"), auxBgColor, True, bDELETA, bEDITA, bATENDE, bDESBLOQUEIA)) 
		
		strCOD_CLIENTE_Old = strCOD_CLIENTE
	Else
		Response.Write(ExibeCHAMADO(GetValue(objRS, "COD_CHAMADO"), auxSTRTIT, GetValue(objRS, "CATEGORIA"), GetValue(objRS, "SYS_ID_USUARIO_INS"), PrepData(GetValue(objRS, "SYS_DTT_INS"), True, True), GetValue(objRS, "PRIORIDADE"), GetValue(objRS, "SITUACAO"), GetValue(objRS, "ARQUIVO_ANEXO"), GetValue(objRS, "VALOR"), auxBgColor, False, bDELETA, bEDITA, bATENDE, bDESBLOQUEIA)) 
	End If
	
	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
  Loop
  If strCOD_CLIENTE_Old <> "-1" Then Response.Write("</table><!--cli_" & strCOD_CLIENTE_Old & "--></div>" & vbNewLine)
  %>
	</table>
	</td>
</tr>
</table>
</body>
</html>
<%
  FechaRecordSet objRS
  FechaDBConn objConn
  
  If bSEM_CHAMADOS And strMARGEM = "" Then
%>
<script>parent.document.getElementById("iframe_chamados").height = 0;</script>
<%
  Else
%>
<script>parent.document.getElementById("iframe_chamados").height = 174;</script>
<%
  End If
%>
