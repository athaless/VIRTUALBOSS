<%
	
	Option Explicit
	
	Response.Buffer = True
	
%>
<!-- #include file="inc.common.asp" -->
<%
	
	Dim error
	error = ""
	
	If (GetParam("action") = "login") Then
		
		' log on if available
		If (GetParam("password") = ADMINISTRATOR_PASSWORD) Then
			Session("com.theill.conquerchat.administrator") = "True"
			Response.Redirect("admin.display.asp")
		Else
			error = getMsg("admin.error.incorrect_password")
		End If
		
	End If
	
%>
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
</head>

<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" style="background-color: #cccccc">

<% If (Len(error) > 0) Then %>
<center>
	<br>
	<div class=err>
		<%= error %>
	</div>
</center>
<% End If %>

<table width=100% border=0 cellspacing=0 cellpadding=0 style="position: absolute; top: 90px">
<tr>
	<td class="hdr"><%= getMsg("admin.login", APPLICATION_NAME) %></td>
</tr>
<tr>
	<td style="background-color: #b3d68e; border-top: 1px dashed #ffffff; border-bottom: 1px dashed #ffffff" align=center>
		
		<br>
		
		<table width=240 border=0 cellspacing=0 cellpadding=2>
		<form method=POST action="admin.asp">
		<input type=hidden name=action value=login>
		<tr>
			<td>&nbsp;</td>
			<td align=right style="font-size: 10px;"><%= getMsg("admin.password") %></td>
			<td width="100%"><input type=password name=password value="<%= Server.HTMLEncode(GetParam("password")) %>" class=editField size=28 maxlength=32 tabindex=1></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan=2 align=right><input type=submit class=btn name=login value="<%= getMsg("button.login") %>" border=0 tabindex=2></td>
			<td>&nbsp;</td>
		</tr>
		</form>
		</table>
		
		<br>
		
	</td>
</tr>
</table>
</body>
</html>