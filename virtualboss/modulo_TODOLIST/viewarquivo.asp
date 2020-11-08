<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL

abreDBConn objConn, CFG_DB

strSQL = "SELECT ARQUIVO_ANEXO FROM TL_TODOLIST WHERE COD_TODOLIST = " & GetParam("var_chavereg")
Set objRS = objConn.execute(strSQL)

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>

<body>
<table width="354" border="0" align="center" cellpadding="0" cellspacing="0" background="../img/BGLeftMenu.jpg">
  <tr> 
	      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
	        <td width="192" height="4" background="../img/inbox_top_blue.gif"></td>
	      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
	    </tr>
	    <tr> 
	      <td width="4" background="../img/inbox_left_blue.gif"></td>
	      <td>
		    <table width="345"  border="0" cellpadding="0" cellspacing="0" class="arial12">
        <tr><td height="15" bgcolor="#7DACC5" valign="middle"><div style="padding-left:5px"><font color="#FFFFFF"><b>ToDo List - Inserção de Resposta</b></font></div></td></tr>
	          <tr><td height="10"></td></tr><!-- Margem superior em relação aos itens do formulário ao centro -->
	          <tr>
			   
          <td align="center"><img src="../upload/<%=GetValue(objRS,"ARQUIVO_ANEXO")%>" border="0"> 
          </td>
			  </tr>
	          <tr><td height="10"></td></tr><!-- Margem inferior em relação aos itens do formulário ao centro -->
		    </table>
	      </td>
	      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    	</tr>
	  </table>
<table width="354" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
    <td width="150" height="4" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="8" height="32"></td>
    <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
    <td align="right" background="../img/inbox_bottom_big3.gif"><img src="../img/bt_clear.gif" width="78" height="17" hspace="6" border="0" onClick="window.close();" style="cursor:hand;"><br></td>
    <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
  </tr>
</table>
</body>
</html>
<%
FechaRecordSet(objRS)
FechaDBConn(objConn)
%>