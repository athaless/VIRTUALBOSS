<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_MSG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim strPASTA

strPASTA = GetParam("var_pasta")

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset rows="170,*" frameborder="NO" border="0" framespacing="0">
  <frame name="msg_top" id="msg_top" src="mainheader.asp?var_pasta=<%=strPASTA%>" scrolling="NO" noresize>
  <frame name="msg_bottom_right" id="msg_bottom_right" src="msgAbreMensagem.asp">
</frameset>
<noframes><body>
</body></noframes>
</html>
