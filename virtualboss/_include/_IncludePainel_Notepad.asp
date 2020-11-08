<%
  auxSTR = "" 
  strSQL =           " SELECT COD_NOTEPAD, ID_USUARIO, TITULO, TEXTO, TIPO, USUARIOS, SYS_DTT_INS, SYS_DTT_UPD "
  strSQL = strSQL  & "   FROM NOTEPAD "
  strSQL = strSQL  & "  WHERE ( (ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "') OR " 
  strSQL = strSQL  & "          ( (LOCATE('" & Request.Cookies("VBOSS")("ID_USUARIO") & ";',USUARIOS) > 0) AND (USUARIOS is NOT NULL) )"
  strSQL = strSQL  & "		  ) " 
  strSQL = strSQL  & "     AND TIPO like '" & strTPNote & "' " 
  strSQL = strSQL  & "  ORDER BY SYS_DTT_UPD DESC,  SYS_DTT_INS DESC,  TITULO ASC" 
  
  Set objRS = objConn.Execute(strSQL) 
   if not objRS.EOF OR strTPNote = "LEFT" then 
   'Só no tipo LEFT mostar o box vazio para dar acesso a inserção de annotações
%>
<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td width="160" height="22" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" style="border-bottom:1px solid <%=strBGCOLOR1%>">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_NOTEPAD/default.htm" target="vbNucleo">Anotações</a></b></div></td>
				<td align="right" width="99%" style="text-align:right"><%
				  if (strTPNote<>"%") then
				    response.write(MontaLinkGrade("modulo_NOTEPAD","Insert.asp","","IconAction_DETAILadd.gif","INSERIR"))
				  end if %>&nbsp;			
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr><td width="160" height="99%" align="right" valign="top" style="padding-top:5px; padding-bottom:5px;">
			<%	while not objRS.eof  %>
				<div align="left" style="border:0px solid #00FF00; 
										 height:140px; 
				                         padding-top:5px; padding-left:15px; padding-bottom:0px; padding-right:12px; 
										 <% 
										  if (GetValue(objRS,"USUARIOS")<>"") then
										   response.write (" background-image:url('../img/bg_notepadpub.jpg'); ") 
										  else 
										   response.write (" background-image:url('../img/bg_notepad.jpg'); ") 
										  end if 
										 %>
										 background-repeat:no-repeat; 
										 float:left;"> 
					<div align="left" style="border:0px solid #FF0000;overflow:hidden; height:110px; width:140px;"> 
					<% 'Se o post-it que aparece não é do cara então ele não pode ser deletado, pois é de outra pessoa (um post-it PUBLIC por exemplo)
					   if (GetValue(objRS,"ID_USUARIO")=Request.Cookies("VBOSS")("ID_USUARIO")) then
					     response.write MontaLinkGrade("modulo_NOTEPAD","Delete.asp",GetValue(objRS,"COD_NOTEPAD"),"IconAction_NotePadDEL.gif","REMOVER")
					   end if
					   'Se o post-it que aparece não é do cara então o link vai pra detail e não pra update(um post-it PUBLIC por exemplo)
					   if (GetValue(objRS,"ID_USUARIO")=Request.Cookies("VBOSS")("ID_USUARIO")) then
					     auxSTR = "../modulo_NOTEPAD/Update.asp?var_chavereg=" & GetValue(objRS,"COD_NOTEPAD")
					   else
					     auxSTR = "../modulo_NOTEPAD/Detail.asp?var_chavereg=" & GetValue(objRS,"COD_NOTEPAD")
					   end if	 
					%>
					<a href="<%=auxSTR%>"><span>
						<%
						auxSTR = GetValue(objRS,"SYS_DTT_INS")
						response.write (UCase(WeekDayName(WeekDay(auxSTR),1)) & " - ")
						response.write (PrepData(auxSTR, True, False) & " " & DatePart("h",CDate(auxSTR)) & ":" & DatePart("n",CDate(auxSTR)))
						%>
						</span>
						<br /><b><%=GetValue(objRS,"TITULO")%></b><br>
						<span class="texto_ajuda" style="color:#404040;"><%
						'= Server.HTMLEncode(GetValue(objRS,"TEXTO")
						auxSTR = Server.HTMLEncode(GetValue(objRS,"TEXTO"))
						auxSTR = Replace(auxSTR,"<ASLW_APOSTROFE>","'")
						auxSTR = Replace(auxSTR, "''", "'")
						auxSTR = Replace(auxSTR,CHR(13),"<br>")
						response.write(auxStr)
						%>
						</span>
					</a>
					</div>
				</div>
			<%
					objRS.MoveNext
				wend
			%>
	</td></tr>
</table>
<%
    End If
  FechaRecordSet objRS
%>