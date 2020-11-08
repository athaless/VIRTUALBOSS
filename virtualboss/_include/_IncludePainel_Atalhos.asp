<%
'Colocar declaração na página onde for incluído
'Dim strID_USUARIO
strID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

AbreDBConn objConn, CFG_DB

strSQL = " SELECT ROTULO, LINK, IMG, TARGET FROM SYS_PAINEL WHERE DT_INATIVO IS NULL AND ID_USUARIO='" & strID_USUARIO & "' ORDER BY ORDEM "
Set objRS = objConn.execute(strSQL)
%>
<table width="170" height="150" cellpadding="0" cellspacing="0" border="0" align="center" style="border:1px solid <%=strBGCOLOR1%>">
<tr>
  <td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
   <table width="100%" cellpadding="0" cellspacing="0" border="0">
	 <tr>
	   <td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_ICONPAINEL/default.htm" target="vbNucleo">Atalhos</a></b></div></td>
	   <td align="right" width="99%"> &nbsp;&nbsp; </td>
	 </tr>
   </table>
  </td>
</tr>
<tr>
  <td width="170" height="140" align="center" valign="top">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr><td colspan="3" height="3" ></td></tr>
  <%
    if objRS.EOF then
  %>
	<tr>
	      <td colspan="3" width="164" height="120" align="center" valign="middle"> 
            Você ainda não criou seus atalhos. Para criar atalhos personalizados 
            <a href="../modulo_ICONPAINEL/Default.htm" target="vbNucleo">clique aqui</a> 
          </td>
    </tr>
  <%
    end if
    While Not objRS.EOF
  %>
    
	<tr style="cursor:hand;">
	  <td width="5" height="30"></td>
	  <td width="34" height="30" background="../img/<%=GetValue(objRS,"IMG")%>"></td>
	  <td nowrap><a href="<%=GetValue(objRS,"LINK")%>" target="<%=GetValue(objRS,"TARGET")%>">&nbsp;<%=GetValue(objRS,"ROTULO")%></a></td>
    </tr>
	<tr><td colspan="3" height="3" ></td></tr>
  <%
     objRS.MoveNext
    Wend
  %>
	</table>
  </td>
</tr>
</table>
<%
 FechaRecordSet(objRS)
%>