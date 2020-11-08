<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="_database/athdbConn.asp"-->
<%  Response.Expires = 0 %>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table width="100%" border="0" cellspacing="10" cellpadding="0">
  <tr>
    <td align="left" valign="top">
<%	If VerificaAcesso("ADMIN", "Javascript:history.back()") Then %>
		<!--#include file="_FileManager_engine.asp"-->
<%  End If %>
	</td>
  </tr>
</table>
</body>
</html>
