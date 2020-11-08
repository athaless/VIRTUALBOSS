<%
auxSTR = "" 
strSQL = "" 

strSQL = strSQL & "SELECT '30 dias' as FECHADAS " 
strSQL = strSQL & "  ,TRUNCATE(SUM(tabela.TOT_MIN),2) as HORAS " 
strSQL = strSQL & "  ,COUNT(*) as QTDE " 
strSQL = strSQL & "FROM " 
strSQL = strSQL & "   ( SELECT (SELECT SUM(t3.HORAS) FROM tl_resposta t3 WHERE t1.cod_todolist = t3.cod_todolist) as TOT_MIN " 
strSQL = strSQL & "       FROM tl_todolist t1 " 
strSQL = strSQL & "      WHERE t1.DT_REALIZADO > DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) " 
strSQL = strSQL & "        AND t1.SITUACAO like 'FECHADO' " 
strSQL = strSQL & "    ) as tabela " 
strSQL = strSQL & "GROUP By 1 " 
strSQL = strSQL & "UNION " 
strSQL = strSQL & "SELECT '15 dias' as FECHADAS " 
strSQL = strSQL & "  ,TRUNCATE(SUM(tabela.TOT_MIN),2) as HORAS " 
strSQL = strSQL & "  ,COUNT(*) as QTDE " 
strSQL = strSQL & "FROM " 
strSQL = strSQL & "   ( SELECT (SELECT SUM(t3.HORAS) FROM tl_resposta t3 WHERE t1.cod_todolist = t3.cod_todolist) as TOT_MIN " 
strSQL = strSQL & "       FROM tl_todolist t1 " 
strSQL = strSQL & "      WHERE t1.DT_REALIZADO > DATE_SUB(CURRENT_DATE, INTERVAL 15 DAY) " 
strSQL = strSQL & "        AND t1.SITUACAO like 'FECHADO' " 
strSQL = strSQL & "    ) as tabela " 
strSQL = strSQL & "GROUP By 1 " 
strSQL = strSQL & "UNION " 

strSQL = strSQL & "SELECT '7 dias' as FECHADAS " 
strSQL = strSQL & "  ,TRUNCATE(SUM(tabela.TOT_MIN),2) as HORAS " 
strSQL = strSQL & "  ,COUNT(*) as QTDE " 
strSQL = strSQL & "FROM " 
strSQL = strSQL & "   ( SELECT (SELECT SUM(t3.HORAS) FROM tl_resposta t3 WHERE t1.cod_todolist = t3.cod_todolist) as TOT_MIN " 
strSQL = strSQL & "       FROM tl_todolist t1 " 
strSQL = strSQL & "      WHERE t1.DT_REALIZADO > DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY) " 
strSQL = strSQL & "        AND t1.SITUACAO like 'FECHADO' " 
strSQL = strSQL & "    ) as tabela " 
strSQL = strSQL & "GROUP By 1 " 
strSQL = strSQL & "UNION " 
strSQL = strSQL & "SELECT '4 dias' as FECHADAS " 
strSQL = strSQL & "  ,TRUNCATE(SUM(tabela.TOT_MIN),2) as HORAS " 
strSQL = strSQL & "  ,COUNT(*) as QTDE " 
strSQL = strSQL & "FROM " 
strSQL = strSQL & "   ( SELECT (SELECT SUM(t3.HORAS) FROM tl_resposta t3 WHERE t1.cod_todolist = t3.cod_todolist) as TOT_MIN " 
strSQL = strSQL & "       FROM tl_todolist t1 " 
strSQL = strSQL & "      WHERE t1.DT_REALIZADO > DATE_SUB(CURRENT_DATE, INTERVAL 4 DAY) " 
strSQL = strSQL & "        AND t1.SITUACAO like 'FECHADO' " 
strSQL = strSQL & "    ) as tabela " 
strSQL = strSQL & "GROUP By 1 " 
strSQL = strSQL & "UNION " 
strSQL = strSQL & "SELECT '2 dias' as FECHADAS " 
strSQL = strSQL & "  ,TRUNCATE(SUM(tabela.TOT_MIN),2) as HORAS " 
strSQL = strSQL & "  ,COUNT(*) as QTDE " 
strSQL = strSQL & "FROM " 
strSQL = strSQL & "   ( SELECT (SELECT SUM(t3.HORAS) FROM tl_resposta t3 WHERE t1.cod_todolist = t3.cod_todolist) as TOT_MIN " 
strSQL = strSQL & "       FROM tl_todolist t1 " 
strSQL = strSQL & "      WHERE t1.DT_REALIZADO > DATE_SUB(CURRENT_DATE, INTERVAL 2 DAY) " 
strSQL = strSQL & "        AND t1.SITUACAO like 'FECHADO' " 
strSQL = strSQL & "    ) as tabela " 
strSQL = strSQL & "GROUP By 1 " 
strSQL = strSQL & "UNION " 
strSQL = strSQL & "SELECT '<b>HOJE</b>' as FECHADAS " 
strSQL = strSQL & "  ,TRUNCATE(SUM(tabela.TOT_MIN),2) as HORAS " 
strSQL = strSQL & "  ,COUNT(*) as QTDE " 
strSQL = strSQL & "FROM " 
strSQL = strSQL & "   ( SELECT (SELECT SUM(t3.HORAS) FROM tl_resposta t3 WHERE t1.cod_todolist = t3.cod_todolist) as TOT_MIN " 
strSQL = strSQL & "       FROM tl_todolist t1 " 
strSQL = strSQL & "      WHERE t1.DT_REALIZADO > DATE_SUB(CURRENT_DATE, INTERVAL 0 DAY) " 
strSQL = strSQL & "        AND t1.SITUACAO like 'FECHADO' " 
strSQL = strSQL & "    ) as tabela " 
strSQL = strSQL & "GROUP By 1 " 

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
'set objRS = objConn.Execute(strSQL) 
if not objRS.eof and not objRS.bof then 
%>
<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b>Tarefas</b>&nbsp;(fechadas)</div></td>
				<td width="99%" style="text-align:right"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="170" align="center" valign="top">
			<table width="170" cellpadding="0" cellspacing="2" border="0">
				<tr valign='top'>
					<td style='border-bottom:0px solid #999'>NOS ÚLTIMOS</td>
					<td style='text-align:right; border-bottom:0px solid #999'>HORAS</td>
					<td style='text-align:right; border-bottom:0px solid #999'>QTDE</td>
                </tr>	
				<tr style='cursor:pointer;' valign='top'>
					<%
					While (not ObjRS.BOF) AND (not ObjRS.EOF)
						Response.write ("<tr>")
						Response.write ("<td>" & GetValue(objRS,"FECHADAS") & "</td>")
						auxstr = Int(CDbl(GetValue(objRS,"HORAS")))
						Response.write ("<td style='text-align:right;'>" & auxstr & ":" & int(round((CDbl(GetValue(objRS,"HORAS")) - auxstr)*60)) & "</td>")
						'Response.write ("<td style='text-align:right;'></td>")
						Response.write ("<td style='text-align:right;'>" & GetValue(objRS,"QTDE")     & "</td>")
						Response.write ("</tr>")
						ObjRS.MoveNext
					 WEnd
					 %>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%
end if 
FechaRecordSet objRS 
%>