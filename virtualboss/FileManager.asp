<!--#include file="_database/athdbConn.asp"--><!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn -->
<% VerificaDireito "|FULL|", BuscaDireitosFromDB("modulo_FILEEXPLORER", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<table width="100%" border="0" cellspacing="10" cellpadding="0">
  <tr>
    <td align="left" valign="top">
		<!--#include file="FileManager_engine.asp"-->
	</td>
  </tr>
</table>
</body>
</html>
