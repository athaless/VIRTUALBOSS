<%

	Dim userId, dstUserId
	userId = CStr(GetParam("srcUserId"))
	dstUserId = CStr(GetParam("dstUserId"))

%>
<html>

<head>
	<title><%=CFG_SISTEMA_TITULO%></title>
</head>

<frameset rows="*,40">
  <frame name="messages" target="footnotes" src="private.asp?srcUserId=<%= userId %>&dstUserId=<%= dstUserId %>">
  <frame name="message" src="private.message.asp?srcUserId=<%= userId %>&dstUserId=<%= dstUserId %>" scrolling=no>
  <noframes>
  <body>

  <p>This page uses frames, but your browser doesn't support them.</p>

  </body>
  </noframes>
</frameset>

</html>