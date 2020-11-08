<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
' 
' $Id: frames.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
' 
' @author	Peter Theill	peter@theill.com
' 
If (NOT loggedOn()) Then
  Response.Redirect "expired.asp?reload=true"
  Response.End
End If
%>
<html>
<head>
<title><%= getMsg("application.name") %></title>
<link rel="stylesheet" type="text/css" href="css/chat.css">
<script type="text/javascript" language="JavaScript1.2">
<!--
<!--
		
function showLogOffWindow() 
{
  executeGetParam('action=logoff');
  // you might enable this code if you will -force- a log out if the close
  // the browser window entirely without logging out. however most systems
  // are having popup blockers installed and this will disable the log out
  // anyway :-/
  var mConquerChatLogOut = window.open("logout.asp",null,"toolbar=no,width=380,height=80,resizable=0");
			
  mConquerChatLogOut.focus();
}

function onLoggedOff() 
{
  ;
}
	
// showLogOffWindow();-->
//-->
</script>
</head>
<frameset rows="*,94" onUnLoad="window.open('desloga.asp?action=logoff', 'A', 'status=yes,width=15,height=15,left=5000,top=5000');">
  <frameset cols="*,150">
    <frame name="messages" src="window.asp">
	<frameset rows="60%,30%,10%">
	  <frame name="users" src="users.asp" scrolling=yes>
	  <frame name="rooms" src="rooms.asp" scrolling=yes>
	  <frame name="call_users" src="Call.asp" scrolling=no>
	</frameset>
  </frameset>
<frame name="message" src="message.asp" scrolling=yes noresize>
<noframes>
 <body>Seu browser não aceita frames.</body>
</noframes>
</frameset>
</html>