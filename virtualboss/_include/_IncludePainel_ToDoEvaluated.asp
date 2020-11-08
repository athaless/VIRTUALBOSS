<%
Dim acNota, acQtde

auxSTR = "" 

strSQL = "" 
strSQL = strSQL & "SELECT DISTINCT (SYS_EVALUATE) AS NOTA "
strSQL = strSQL & "      ,COUNT(SYS_EVALUATE) AS QTDE "
strSQL = strSQL & "  FROM tl_todolist "
strSQL = strSQL & " WHERE SYS_EVALUATE > 0 "
strSQL = strSQL & "   AND YEAR(sys_dtt_ins) >= 2017 " 'Considera elementos apenas a partir 2017 (foi quando essa feature de avaliação foi implementada)
strSQL = strSQL & " GROUP BY 1 "
strSQL = strSQL & " ORDER BY NOTA DESC"
 
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
'set objRS = objConn.Execute(strSQL) 
if not objRS.eof and not objRS.bof then 
%>
<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b>Avaliações</b>&nbsp;(tarefas)</div></td>
				<td width="99%" style="text-align:right"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="170" align="center" valign="top">
			<table width="170" cellpadding="0" cellspacing="2" border="0">
				<tr valign='top'>
					<td width="48" style='border-bottom:0px solid #999;'></td>
					<td width="49" style='border-bottom:1px solid #999; text-align:right;'>Nota</td>
					<td width="65" style='border-bottom:1px solid #999; text-align:right;'>Qtde</td>
                </tr>	
					<%
					acNota = 0
					acQtde = 0
					While (not objRS.BOF) AND (not objRS.EOF)
						Response.write ("<tr style='cursor:pointer;' valign='top'>")
						Response.write ("  <td>&nbsp;</td>")
						Response.write ("  <td style='text-align:right;'>" & GetValue(objRS,"NOTA") & "</td>")
						Response.write ("  <td style='text-align:right;'>" & GetValue(objRS,"QTDE") & "</td>")
						Response.write ("</tr>")
						acNota = acNota + CInt(GetValue(objRS,"NOTA")) * CInt(GetValue(objRS,"QTDE"))
						acQtde = acQtde + CInt(GetValue(objRS,"QTDE"))
						objRS.MoveNext
			            'athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
					 WEnd
					%>
				<tr>
					<td style='border-top:0px solid #999;'>Média/Tot</td>
					<td style='border-top:1px solid #999; text-align:right;'><%=FormataDecimal(acNota/acQtde,2)%></td>
					<td style='border-top:1px solid #999; text-align:right;'><%=acQtde%></td>
                </tr>	
			</table>
		</td>
	</tr>
</table>
<%
end if 
FechaRecordSet objRS 
%>