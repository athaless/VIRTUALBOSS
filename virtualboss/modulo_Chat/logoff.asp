<%	Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: logoff.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' 
	' 
	' @author	Peter Theill	peter@theill.com
	' 
	
	If (isLoggedIn(GetParam("chatId"))) Then
		logoutUser(GetParam("chatId"))
		kickInactiveUsers()
	End If
	
	Response.Redirect "default.asp"
	
%>