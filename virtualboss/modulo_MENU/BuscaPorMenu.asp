<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Dim objConn, objRS, strSQL  
 Dim strROTULO, strFORM, strCAMPO

 AbreDBConn objConn, CFG_DB 

 strROTULO = GetParam("var_rotulo")
 strFORM = GetParam("var_form")
 strCAMPO = GetParam("var_campo")
 
 strSQL = " SELECT COD_MENU, ROTULO, LINK, GRP_USER FROM SYS_MENU "
 If strROTULO <> "" Then strSQL = strSQL & " WHERE ROTULO LIKE '" & strROTULO & "%' "
 strSQL = strSQL & " ORDER BY GRP_USER, ORDEM "
%>
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<script>
  function retornaValor(pr_cod)
  {
    window.opener.SetFormField('<%=strFORM%>','<%=strCAMPO%>','edit',pr_cod);
	window.close();
  }
</script>
</head>
<body bgcolor="#ffffff" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table align="center" cellpadding="0" cellspacing="0" width="100%" height="58">
  <tr>
    <td width="4%" background="../img/Menu_TopBGLeft.jpg"></td>
    <td width="1%" ><img src="../img/Menu_TopImgCenter.jpg"></td>
    <td width="95%" background="../img/Menu_TopBgRight.jpg"><div style="padding-top:20px;padding-right:3px;"> 
	  <table height="30" cellpadding="0" cellspacing="0" border="0" align="right">
		<form name="FormBusca" method="post" action="BuscaPorMenu.asp">
		 <input name="var_form" type="hidden" size="20" class="edtext" value="<%=strFORM%>">
		  <tr>
		    <td width="40" align="right" nowrap>Rótulo</td>
		    <td width="5"></td>
		    <td width="100"><input name="var_rotulo" type="text" size="20" class="edtext" value="<%=strROTULO%>"></td>
		    <td width="5"></td>
		    <td width="27"><a href="javascript:document.FormBusca.submit();"> 
              <img src="../img/bt_search_mini.gif" alt="Atualizar consulta..."  border="0"></a>
			</td>
		  </tr>
		</form>
	  </table></div>
	</td>
  </tr>
</table>
<%
   Set objRS = objConn.Execute(strSql) 
   If Not objRS.EOF Then
%>
<table cellpadding="0" cellspacing="1" width="99%" align="center">
  <tr><td height="2" colspan="4"></td></tr>
  <tr bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC"> 
    <td width="1%"  bgcolor="#CCCCCC" align="left" class="arial11Bold"><div style="padding-left:3px; padding-right:3px;">Cod </div></td>
	<td width="97%" bgcolor="#CCCCCC" align="left" class="arial11Bold"><div style="padding-left:3px; padding-right:3px;">Rótulo</div></td>
	<td width="1%" bgcolor="#CCCCCC" align="left" class="arial11Bold"><div style="padding-left:3px; padding-right:3px;">Grupo</div></td>
    <td width="1%"  bgcolor="#CCCCCC" align="left" class="arial11Bold"><div style="padding-left:3px; padding-right:3px;">Link </div></td>
  </tr>
  <%
      While Not objRS.Eof
  %>
  <tr bgcolor="#DAEEFA" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="retornaValor('<%=GetValue(objRS,"COD_MENU")%>');"> 
    <td align="left" valign="middle" nowrap><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"COD_MENU")%>&nbsp;</div></td>
    <td align="left" valign="middle"><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"ROTULO")%>&nbsp;</div></td>
    <td align="left" valign="middle" nowrap><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"GRP_USER")%>&nbsp;</div></td>
	<td align="left" valign="middle" nowrap><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"LINK")%>&nbsp;</div></td>
  </tr>
  <%
        objRS.MoveNext
      Wend
  %>
  <tr><td bgcolor="#CCCCCC" colspan="4" align="center" height="1"></td></tr>
</table>
<%
   else
    Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
   end if
%>
</body>
</html>
<%
 FechaRecordSet objRS
 FechaDBConn objConn
%>