<%
auxSTR = "" 

strSQL =	" SELECT T4.COD_MENSAGEM, T4.ASSUNTO, T1.COD_USER_REMETENTE, T4.DT_ENVIO "	&_
			" FROM MSG_REMETENTE T1 " 													&_
			" INNER JOIN MSG_PASTA T2 ON (T2.COD_MENSAGEM=T1.COD_MENSAGEM) " 			&_
			" INNER JOIN MSG_DESTINATARIO T3 ON (T3.COD_MENSAGEM=T1.COD_MENSAGEM) " 	&_
			" INNER JOIN MSG_MENSAGEM T4 ON (T4.COD_MENSAGEM=T1.COD_MENSAGEM) " 		&_
			" WHERE T2.PASTA = 'CX_ENTRADA' " 											&_
			" AND T2.COD_USER = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " 		&_
			" AND T3.COD_USER_DESTINATARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " &_
			" AND T2.LIDO = 0 " 	&_
			" ORDER BY T4.DT_ENVIO DESC "
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
%>
<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_MSG/default.htm" target="vbNucleo">Mensagens</a></b></div></td>
				<td width="99%" style="text-align:right">
				<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
					<a href="JavaScript:AbreJanelaPAGENew('../modulo_MSG/msgNovaMensagem.asp', '590', '380', 'no', 'yes');"><img src="../img/IconAction_DETAILadd.gif" border="0" alt="Criar Mensagem" title="Criar Mensagem"></a>&nbsp;
				<% End If %>
				</td>
			</tr>
			</table>
		</td>
	</tr>
<% if not objRS.eof and not objRS.bof then %>
	<tr>
		<td width="164" align="center" valign="top">
			<table width="160" cellpadding="0" cellspacing="2" border="0">
			<%
				while not objRS.eof
					strDT_ENVIO = PrepData(GetValue(objRS,"DT_ENVIO"),true,true) 
					strDT_ENVIO = mid(strDT_ENVIO,1,InStrRev(strDT_ENVIO,":")-1)
					auxSTR = GetValue(objRS,"COD_USER_REMETENTE") & "<br>" & strDT_ENVIO
			%>
				<tr style="cursor:pointer;" onClick="JavaScript:AbreJanelaPAGENew('../modulo_MSG/AbreMsg_capa.asp?var_chavereg=<%=GetValue(objRS,"COD_MENSAGEM")%>', '590', '380', 'yes', 'yes');" title="Assunto: <%=GetValue(objRS,"ASSUNTO")%>" valign="top">
					<td width="040px" height="30px" background="../img/ICO_VBOSS_06.gif" style="background-repeat:no-repeat;"></td>
					<td width="124px"><b>from:</b>&nbsp;<%=auxSTR%><br></td>
				</tr>
			<%
					objRS.MoveNext
				wend
			%>
			</table>
		</td>
	</tr>
<% end if %>
</table>
<% FechaRecordSet objRS %>