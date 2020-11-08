<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim strALL_PARAMS 
strALL_PARAMS = Request.QueryString
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset rows="80,*" frameborder="NO" border="0" framespacing="0">
  <frame src="topo.asp?<%=strALL_PARAMS%>" name="vbTopFrame" scrolling="NO" noresize >
  <frame src="main.asp?<%=strALL_PARAMS%>" name="vbMainFrame">
</frameset>
<noframes><body></body></noframes>
</html>
