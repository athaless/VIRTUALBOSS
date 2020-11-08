<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 520
WMD_WIDTHTTITLES = 120
' -------------------------------------------------------------------------------
Dim strSQL, objRS, ObjConn
Dim strCODIGO, strRESPOSTA, strBOLETIM, aux, auxHS, acHORAS, strArquivo
Dim strTITULO,strSITUACAO,strCATEGORIA,strPRIORIDADE,strRESPONSAVEL
Dim strEXECUTOR,strDESC,strPREV_DT_INI,strPREV_HR_INI,strPREV_HORAS
Dim strDT_REALIZADO,strFULLCATEGORIA,strARQUIVOANEXO,strCODTODOLIST

strCODIGO   = GetParam("var_chavereg") 'COD_TODOLIST (TL_TODOLIST)
strRESPOSTA = UCase(GetParam("var_resposta"))
strBOLETIM  = GetParam("var_codigo") 'COD_BOLETIM (BS_BOLETIM)	
	
if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 

	strSQL =          "SELECT T1.COD_TODOLIST, T1.ARQUIVO_ANEXO, T1.ID_RESPONSAVEL, T1.ID_ULT_EXECUTOR "
	strSQL = strSQL & "     , T1.TITULO, T1.DESCRICAO, T1.SITUACAO, T1.PREV_DT_INI, T1.PREV_HR_INI "
	strSQL = strSQL & "     , T1.PREV_HORAS, T1.DT_REALIZADO, T1.PRIORIDADE, T2.COD_CATEGORIA, T2.NOME " 
	strSQL = strSQL & "  FROM TL_TODOLIST T1, TL_CATEGORIA T2 "
	strSQL = strSQL & " WHERE T1.COD_CATEGORIA = T2.COD_CATEGORIA " 
	strSQL = strSQL & "   AND T1.COD_TODOLIST = " & strCODIGO 		
	strSQL = strSQL & " ORDER BY T1.PREV_DT_INI, T1.SYS_DTT_INS, T1.SYS_DTT_ALT "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.eof then 
		strCODTODOLIST   = GetValue(objRS,"COD_TODOLIST")
		strTITULO        = GetValue(objRS,"TITULO")
		strSITUACAO      = GetValue(objRS,"SITUACAO")
		strCATEGORIA     = GetValue(objRS,"NOME")
		strPRIORIDADE    = GetValue(objRS,"PRIORIDADE")
		strRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		strEXECUTOR      = LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))
		strDESC          = GetValue(objRS,"DESCRICAO")
		strPREV_DT_INI   = PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)
		strPREV_HR_INI   = GetValue(objRS,"PREV_HR_INI")
		strPREV_HORAS    = FormataHoraNumToHHMM(GetValue(objRS, "PREV_HORAS"))
		strDT_REALIZADO  = PrepData(GetValue(objRS,"DT_REALIZADO"),true,false)
		strFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & strCATEGORIA
		strARQUIVOANEXO  = GetValue(objRS,"ARQUIVO_ANEXO")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>

</script>
</head>
<body>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<tr><td width=<%=WMD_WIDTHTTITLES%> style="text-align:right;">Título:&nbsp;</td><td><%=strTITULO%></td></tr>
	<tr><td style="text-align:right;">Situação:&nbsp;</td><td><%=strSITUACAO%></td></tr>
	<tr><td style="text-align:right;">Categoria:&nbsp;</td><td><%=strCATEGORIA%></td></tr>
	<tr><td style="text-align:right;">Prioridade:&nbsp;</td><td><%=strPRIORIDADE%></td></tr>
	<tr><td style="text-align:right;">Responsável:&nbsp;</td><td><%=strRESPONSAVEL%></td></tr>
	<tr><td style="text-align:right;">Executor Atual:&nbsp;</td><td><%=strEXECUTOR%></td></tr>
	<tr><td style="text-align:right;">Previsão:&nbsp;</td><td><%=strPREV_DT_INI%>&nbsp;&nbsp;<%=strPREV_HR_INI%>&nbsp;&nbsp;(&nbsp;<%=strPREV_HORAS%>&nbsp;)</td></tr>
	<tr><td style="text-align:right;">Data Realizado:&nbsp;</td><td><%=strDT_REALIZADO%></td></tr>
	<tr>
		<td style="text-align:right;" valign="top">Tarefa:&nbsp;</td>
    	<td>
			<%=Replace(Replace(strDESC,"<ASLW_APOSTROFE>","'"),CHR(13),"<br>")%><br><br>
			<% if strARQUIVOANEXO<>"" then %>
					<a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=strARQUIVOANEXO%>" style="cursor:hand;text-decoration:none;" target="new">						<img src="../img/ico_clip.gif" border="0" title="Anexo">Ver Anexo
					</a>
					<%
					strArquivo = mid(strARQUIVOANEXO,InStr(1,strARQUIVOANEXO,"_")+1)
					strArquivo = mid(strArquivo,InStr(1,strArquivo,"_")+1)
					%>
					(<%=strArquivo%>) 
			<% end if %>
		</td>
	</tr>
</table>
<br>
	<%	if CStr(strRESPOSTA)="TRUE" then %>
<table align="center" border="0" cellpadding="3" cellspacing="0" width="100%">
	<tr>
		<td align="center" width="100%" style="text-align:center;">
			<iframe name="ifrm_resposta" src="InsertResposta.asp?var_chavereg=<%=strCODIGO%>&var_ultexec=<%=strEXECUTOR%>&var_codigo=<%=strBOLETIM%>"
			width="520px" height="400px" frameborder="0" scrolling="no"></iframe>
		</td>
	</tr>
</table>
<% 
		end if
		
		FechaRecordSet objRS
		
		strSQL = " SELECT COD_TL_RESPOSTA, SYS_ID_USUARIO_INS, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA, HORAS FROM TL_RESPOSTA " 
		strSQL = strSQL & " WHERE COD_TODOLIST = " & strCODIGO & " ORDER BY DTT_RESPOSTA DESC " 
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRS.eof then 
%>
<table width="95%" border="0" align="center" cellpadding="3" cellspacing="0">
	<tr><td><b>Respostas</b></td></tr> 
	<tr> 
		<td align="center"> 
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
				<tr>
					<td align='left' valign='top' nowrap width="10%"></div></td>
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
				<tr><td colspan="7" height="2" width="100%" style="border-bottom:1px solid #999999"></td></tr>
				<tr>
				<% if GetValue(objRS,"SYS_ID_USUARIO_INS")<>"" and LCase(GetValue(objRS,"ID_FROM"))=LCase(Request.Cookies("VBOSS")("ID_USUARIO")) and aux=0 then %>
					<td align='left' valign='top' nowrap width="10%" height="18px">
					<a style="cursor:hand;" onClick="window.open('delete_resp.asp?var_chavereg=<%=GetValue(objRS,"COD_TL_RESPOSTA")%>','','popup,width=10,height=10');">
						<img src='../img/IconAction_DEL.gif' border='0'>
					</a>
					</td>
				<% else %>
					<td align='left' valign='top' nowrap width="10%" height="18px"></td>
				<% end if %> 
					<td align='left' valign='top' nowrap width="02%"><%=PrepData(GetValue(objRS,"DTT_RESPOSTA"),true,true)%></div></td>
					<td align='left' valign='top' nowrap width="04%">
						<div style="color:#999999;"><% if GetValue(objRS,"SYS_ID_USUARIO_INS")<>"" then response.write LCase(GetValue(objRS,"ID_FROM"))%></div>
					</td>
					<td align='left' valign='top' nowrap width="04%"><b><%if GetValue(objRS,"SYS_ID_USUARIO_INS")<>"" then response.write LCase(GetValue(objRS,"ID_TO"))%></b></div></td>
					<td align="left" valign="top" width="78%"><%=Replace(strResposta,CHR(13),"<br>")%></div></td>
					<td align='left' valign='top' nowrap width="02%"><%=FormataHoraNumToHHMM(auxHS)%></div></td>
				</tr>
</b>
<%
					aux = 1
					acHoras = (acHoras + auxHS)
					objRS.MoveNext
				loop 
				FechaRecordSet objRS
%>
				<tr><td colspan="7" height="2" width="100%" style="border-bottom:1px solid #999999"></td></tr>
				<tr><td style="text-align:right;"height="30px" colspan="6" width="100%" valign="middle">Total: <%=FormataHoraNumToHHMM(acHORAS)%></td></tr>
		</table>
		</td>
	</tr>
</table>
<%	end if %>
</body>
</html>
<%
	end if 
	'FechaRecordSet objRS
	FechaDBConn objConn
end if 
%>