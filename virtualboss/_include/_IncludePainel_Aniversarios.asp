<%
auxSTR = "" 

strSQL = " SELECT usuario.ID_USUARIO " &_
		 "      , ent_colaborador.NOME " &_
		 "      , ent_colaborador.DT_NASC " &_
		 "   FROM ent_colaborador, usuario " &_
		 "  WHERE ent_colaborador.DT_INATIVO is NULL " &_
		 "    AND ent_colaborador.COD_COLABORADOR = usuario.CODIGO " &_
		 "    AND upper(usuario.TIPO) = 'ENT_COLABORADOR' " &_
		 "    AND MONTH(ent_colaborador.DT_NASC) = MONTH(CURRENT_DATE) " &_
		 "    AND usuario.DT_INATIVO IS NULL  AND usuario.ID_USUARIO not like 'gabriel' " &_
		 "  ORDER BY DAY(ent_colaborador.DT_NASC) "
  
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
'set objRS = objConn.Execute(strSQL) 
if not objRS.eof and not objRS.bof then 
%>
<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b>Aniversariantes</b>&nbsp;-&nbsp;<%=MesExtenso(DatePart("m",Date()))%></div></td>
				<td width="99%" style="text-align:right"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="164" align="center" valign="top">
			<table width="160" cellpadding="0" cellspacing="2" border="0">
			<%
				while not objRS.eof
					strDT_ENVIO = PrepData(GetValue(objRS,"DT_NASC"),true,false) 
			%>
				<tr style='cursor:pointer;' valign='top' title='<%=GetValue(objRS,"NOME")%>'>
					<%
					IF (Day(CDate(strDT_ENVIO)) = Day(Date())) AND (Month(CDate(strDT_ENVIO)) = Month(Date())) Then 
						auxSTR = "../img/niver_today.png"
					ELSE
						auxSTR = "../img/niver_info.png"
					END IF	
					%>
					<td width='040px' height='30px' style='background:URL(<%=auxSTR%>); background-repeat:no-repeat; background-position:center;'></td>
					<td width="124px">
					<%
					If IsDate(GetValue(objRS,"DT_NASC")) Then 
						strIDADE = DateDiff("M", GetValue(objRS,"DT_NASC"), Date)
						If strIDADE > 0 Then strIDADE = Fix(strIDADE / 12) End If
					End If
					%>
					<%=ucase(GetValue(objRS,"ID_USUARIO"))%>&nbsp;<small>(<%=strIDADE%> anos)</small><br />
					<%=strDT_ENVIO%><br>
					</td>
				</tr>
			<%
					objRS.MoveNext
				wend
			%>
			</table>
		</td>
	</tr>
</table>
<% 
 end if 
 FechaRecordSet objRS 
%>