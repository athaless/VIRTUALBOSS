<%
strSQL =          " SELECT T1.ID_USUARIO, COUNT(T2.COD_CHAMADO) AS TOTAL "
strSQL = strSQL & " FROM USUARIO T1 "
strSQL = strSQL & " LEFT OUTER JOIN CH_CHAMADO T2 ON (T1.ID_USUARIO = T2.SYS_ID_USUARIO_INS AND (T2.SITUACAO = 'ABERTO' OR T2.SITUACAO = 'EXECUTANDO')) "
strSQL = strSQL & " WHERE T1.TIPO = 'ENT_CLIENTE' "
strSQL = strSQL & " AND T1.CODIGO = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
strSQL = strSQL & " AND T1.DT_INATIVO IS NULL "
'strSQL = strSQL & " AND T1.ID_USUARIO NOT LIKE '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
strSQL = strSQL & " GROUP BY T1.ID_USUARIO "
strSQL = strSQL & " ORDER BY 2 DESC, 1 "

'athDebug stRSQL, True

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
%>
<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
		<!-- (<%'=Replace(Request.Cookies("VBOSS")("ENTIDADE_TIPO"), "ENT_","")%>&nbsp;<%'=Request.Cookies("VBOSS")("ENTIDADE_CODIGO")%>)-->
		<div style="padding-left:3px; padding-right:3px;"><b>Usuários</b></div>
		</td>
	</tr>
<% if not objRS.eof and not objRS.bof then %>
	<tr>
		<td width="164" align="center" valign="top">
			<table width="170" cellpadding="0" cellspacing="2" border="0">
			<%
			auxSTR = ""
			While not objRS.eof
				auxSTR = auxSTR & GetValue(objRS, "ID_USUARIO") & ";"
			%>
			<tr>
				<td width="5"></td>
				<td width="10" style="text-align:right; border-bottom:1px solid #CCCCCC;"><a href="JavaScript:AbreJanelaPAGENew('../modulo_MSG/msgNovaMensagem.asp?var_destino=<%=GetValue(objRS, "ID_USUARIO")%>', '590', '380', 'no', 'yes');"><img src="../img/IconAction_DETAILadd.gif" border="0" alt="Enviar Mensagem" title="Enviar Mensagem"></a></td>
				<td width="140" height="16" style="text-align:left; padding:2px; border-bottom:1px solid #CCCCCC"><%
				Response.Write(GetValue(objRS, "ID_USUARIO"))
				If CDbl(GetValue(objRS, "TOTAL")) > 0 Then Response.Write("&nbsp;<span title='Qtde de chamados'>(" & GetValue(objRS, "TOTAL") & ")</span>")
				%></td>
				<td width="5">
			</tr>
			<%
				objRS.MoveNext
			WEnd
			%>
			<% If auxSTR <> "" Then %>
				<tr>
				<td colspan="2"></td>
				<td style="text-align:right; padding:2px; border-bottom:0px solid #CCCCCC"><a href="JavaScript:AbreJanelaPAGENew('../modulo_MSG/msgNovaMensagem.asp?var_destino=<%=auxSTR%>', '590', '380', 'no', 'yes');">enviar para todos</a></td>
				<td></td>
				</tr>
			<% End If %>
			<tr><td colspan="4" height="5"></td></tr>
			</table>
		</td>
	</tr>
<% end if %>
</table>
<% FechaRecordSet objRS %>