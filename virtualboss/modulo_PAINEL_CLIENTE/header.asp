<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title></title>
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body marginheight="0" marginwidth="0" leftmargin="0" topmargin="0" bottommargin="0" rightmargin="0">
<table width="100%" height="57" cellspacing="0" cellpadding="0" border="0" background="../img/BgInterTop.jpg">
	<tr>
	  <td width="1%" align="center"><a href="nucleo.htm" target="vbNucleo" style='cursor:pointer; text-decoration:none; border:none; outline:none;'><img src="../img/LogoVBoss.gif" width="229" height="37" hspace="30" border="0"></a></td>
	  <td width="99%" align="right" valign="top">
		<table width="100%" height="57" cellpadding="0" cellspacing="0" border="0" background="../img/BgInterTop.jpg">
		  <tr>
			<td width="98%" align="right" valign="top" style="text-align:right; padding-right:5px;" nowrap>
			  <%=Request.Cookies("VBOSS")("GRUPO_USUARIO")%><br>
			  <b><%=Request.Cookies("VBOSS")("NOME_USUARIO")%></b>
			  <br><%="DB " & Replace(Request.Cookies("VBOSS")("DBNAME"), "vboss_", "") %>
			</td>
			<td width="1%" align="right" valign="top"><a href="../logout.asp" target="vbfr_pcenter" alt="Sair/Logout" title="Sair/Logout"><img src="../img/IcoLogout.gif" border="0"></a></td>
		   </tr>
		</table>
	  </td>
	</tr>
</table>
</body>
</html>