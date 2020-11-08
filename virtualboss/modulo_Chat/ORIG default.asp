<%
 Option Explicit

 Response.Buffer = True
	
 If Session("STATUS") <> "LOGADO" Then
%>
<script language="JavaScript">
  alert("Sua sessão expirou!");
  window.close();
</script>
<%
   'Redirect("../principal/default.asp")
 End If
%>
<!--#include file="inc.common.asp" -->
<%
	' many users does not read the included README.TXT file before trying to 
	' set up this chat -- in order to help them a bit we check if we have the
	' required objects properly initialised
	On Error Resume Next
	If (NOT IsObject(conquerChatUsers) OR NOT IsObject(conquerChatRooms)) Then
		Response.Redirect("errorInSetup.asp")
		Response.End
	End If
	
	Dim userId

	' make sure we don't show any inactive users for new chat users
	kickInactiveUsers()
	
	If (conquerChatRooms.Count = 0) Then
		setupRooms()
	End If


	' do not show login screen if a valid session exists
	If (loggedOn()) Then
		Response.Redirect "frames.asp"
		Response.End
	End If
	
	Dim mode, errorMessage
	mode = Session("MODE")
	
	If (mode = "userLogin") Then
		
		Dim userName
		userName = Server.HTMLEncode(Session("COD_USER"))
		
		If (countUsers() >= USERS) Then
			errorMessage = getMsg("error.maximum_users_reached")
		ElseIf (Len(userName) = 0)  Then
			errorMessage = getMsg("error.missing_username")
		ElseIf (Len(userName) > MAX_USERNAME_LENGTH) Then
			errorMessage = getMsg("error.username_length_exceeded", MAX_USERNAME_LENGTH)
		ElseIf (userExists(userName)) Then
			errorMessage = getMsg("error.username_in_use")
		ElseIf (NOT isValidUsername(userName)) Then
			errorMessage = getMsg("error.invalid_username")
		ElseIf (isUserNameBlocked(userName)) Then
			errorMessage = getMsg("error.username_blocked")
		Else
			
			Dim p
			Set p = New Person
			p.id = -1
			p.name = userName
			p.roomId = 0
			p.ipAddress = Request.ServerVariables("REMOTE_ADDR")
			
			' we have a new chat user thus we need to create a new
			' id for him/her
			Set p = addUser(p)
			
			' tell all other users about this new user
			Call addMessage( _
				p.id, _
				"-1", _
				"<span class=LoggedIn><img src='images/new.gif' height=9 width=9>&nbsp;" & getMsg("user.logged_on", p.name, Now()) & "</span><br>" _
			)
			
			Session("user") = p.data
			
			' redirect to new frame window and create a new user login
			Response.Redirect("frames.asp")
			Response.End
		End If
		
	End If ' > If (mode = "userLogin") Then	
%>
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		
		function init() {
			// set focus on 'username' field
			f = document.frmLogin;
			if (typeof f != 'undefined' && typeof f.username != 'undefined') {
				f.username.select();
				f.username.focus();
			}
			
		}
		
	// -->
	</script>
</head>

<body class="frontpage" onload="init()">



<table border="0" cellspacing="0" cellpadding="0" style="position: absolute; top: 90px" width="100%">
<tr>
	<td class="hdr"><%= getMsg("login.join_chat", getMsg("application.name") & " " & getMsg("application.version")) %></td>
</tr>
<tr>
	<td style="background-color: #ededed; border-top: 1px dashed #ffffff; border-bottom: 1px dashed #ffffff" align=center>
		
		<br>
		
		<table width="240" border="0" cellspacing="0" cellpadding="2">
        <!--<form name="frmLogin" method="GET" action="default.asp">
		<input type="hidden" name="mode" value="userLogin">-->
		<tr>
			<!--  <td>&nbsp;</td>
			<td align=right style="font-size: 10px;"><= getMsg("login.username") %></td>-->
			<td width="100%" colspan="3"><br>
<% If (Len(errorMessage) > 0) Then %>
		<%= errorMessage %>
<% End If %><!--  <input type=text name=username value="<= Server.HTMLEncode(userName) %>" class=editField size=28 maxlength=32 tabindex=1>--></td>
			<td>&nbsp;</td>
		</tr>
		<!-- <tr>
			<td>&nbsp;</td>
			<td colspan=2 align=right> <input type=submit class=btn name=login value="<= getMsg("button.login") %>" border=0 tabindex=2 title="<= getMsg("button.login.title") %>"></td>
			<td>&nbsp;</td>
		</tr>
		</form>-->
		<tr>
			<td>&nbsp;</td>
			<td colspan=2 align=center style="color: #999999;">
				<br>
				<br>
				<br>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			
          <td colspan=2>&nbsp; </td>
			<td>&nbsp;</td>
		</tr>
		</table>
		
		<br>
		
	</td>
</tr>
<tr>
	<td></td>
</tr>
</table>
</body>
</html>