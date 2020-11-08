<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../_include/IncludeUsrLogados.asp"-->
<%
	Dim strUsers, i, Colunas
%> 
<html>
<head>
<title>Usuários</title>
<link href="css/chat.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="users">
<div class="hdr">
	<b>Usu&aacute;rios On-Line:</b>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="2">
  <tr> 
    <td>
		<%
		Colunas = TotalColunasInfo()
	  	strUsers = UsersOnline()
		strUsers = Split(strUsers, "|")

		For i = 1 To UBound(strUsers) Step Colunas
			Response.Write("<span class='ForumPequena'>" & strUsers(i) & "</span><br>")
		Next
		%>
	</td>
  </tr>
</table>
</body>
</html>