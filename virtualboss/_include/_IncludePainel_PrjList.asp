<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" style="border:1px solid <%=strBGCOLOR1%>">
<tr>
	<td bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
	<div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_PROJETO/default.htm" target="vbNucleo">Projetos</a></b></div></td>
</tr>
<tr>
	<td align="center" bgcolor="<%=strBGCOLOR2%>"><div style="padding-top:4px; padding-bottom:4px;">
		<table width="98%" cellpadding="2" cellspacing="2" border="0">
			<tr bgcolor="<%=strBGCOLOR5%>">
				<td height="18">&nbsp;coluna A</td>
				<td>&nbsp;coluna B</td>
				<td>&nbsp;coluna C</td>
				<td>&nbsp;coluna D</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="<%=strBGCOLOR6%>"></td>
			</tr>
			<%
			For auxCont=0 to 0
			'Do While Not objRS.Eof 
			%>
			<tr bgcolor="<%=strBGCOLOR3%>">
				<td height="18">&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<%
			next
			'	objRS.MoveNext
			'Loop
			%>
			<tr>
				<td colspan="4" height="15"></td>
			</tr>
		</table></div>
	</td>
</tr>
</table>