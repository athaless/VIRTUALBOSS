<%
  auxSTR = "" 
  strSQL = " SELECT COD_RECADO,SYS_ID_USUARIO_INS, SYS_DTT_INS FROM RECADO WHERE ID_USUARIO_TO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' and SYS_DTT_VIEW is NULL ORDER BY SYS_DTT_INS" 

  Set objRS = objConn.Execute(strSQL) 
	
%>
<table width="170" cellpadding="0" cellspacing="0" border="0" align="center" style="border:1px solid <%=strBGCOLOR1%>">
<tr>
	<td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
	<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-bottom:1px solid <%=strBGCOLOR1%>">
		<tr>
			<td align="left" width="1%" nowrap ><div style="padding-left:3px; padding-right:3px;"><b>Recados</b></div></td>
			<td align="right" width="99%"><a href="JavaScript:AbreJanelaPAGENew('../modulo_RECADO/insert.asp',480,600,'no','');"><img src="../img/IconAction_DETAILadd.gif" border="0" alt="Inserir recado"></a>&nbsp;&nbsp;</td>
		</tr>
	</table>
	</td>
</tr>
<%
  If Not objRS.EOF and Not objRS.BOF Then
%>
<tr>
  <td width="164" align="center" valign="top">
   <table width="160" cellpadding="0" cellspacing="2" border="0">
    <%
    while not objRS.EOF
	  auxSTR = GetValue(objRS,"SYS_ID_USUARIO_INS") & "<BR>" & GetValue(objRS,"SYS_DTT_INS")
    %>
     <tr style="cursor:hand;"><a href="JavaScript:AbreJanelaPAGENew('../modulo_RECADO/detail.asp?var_chavereg=<%=GetValue(objRS,"COD_RECADO")%>',420,480,'no','');">
	   <td width="40" height="30" align="left" valign="top" background="../img/ICO_VBOSS_26.gif" style="background-repeat:no-repeat;"></td>
	   <td width="124" align="left" valign="top"><b>from:</b>&nbsp;<%=auxSTR%><br></td></a>
	 </tr>
    <%
	 objRS.movenext
    wend
    %>
   </table>
  </td>
</tr>
<%
 End If 
%>
</table>
<%
 FechaRecordSet objRS
%>