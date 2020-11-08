<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<!-- #include file="inc.view.asp" -->
<%
	Dim user
	Set user = getLoggedOnUser()

'	If (GetParam("action") = "logoff") Then
		
		' add a leaving message to chatroom and remove user from list of active
		' users in this chat room
		logoutUser(user.id)
		removeUser(user.id)
		
		' remove user variable stored in session
		Session.Contents.Remove(SESSIONKEY_USER)
		
		' execute javascript function where redirection occurs
		Response.Write("onLoggedOff();")
		Response.Write("<html><script language='Javascript'>window.close();</script></html>")
		Set user = Nothing
'	End If

	kickInactiveUsers()
	
	If (CLEAR_ON_EMPTY AND (countUsers() = 0)) Then		
		' clear all messages in all rooms
		conquerChatMessages.RemoveAll
	End If
%>