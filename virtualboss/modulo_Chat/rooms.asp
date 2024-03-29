<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: rooms.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' 
	' 
	' @author	Peter Theill	peter@theill.com
	' 
	
	Response.Buffer = True
	
	If (NOT loggedOn()) Then
		Response.Write(getLoggedOutScript(True))
		Response.End
	End If
	
	Dim user
	Set user = getLoggedOnUser()
	
	If ((GetParam("action") = "remove") AND (GetParam("roomId") <> "")) Then
		
		' administrator of this room want to have it removed
		removeRoom(GetParam("roomId"))
		
	End If
	
%>
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script language="JavaScript1.2" type="text/javascript" src="js/update.js"></script>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		
		/**
		 * Setup time to refresh page in intervals.
		 * 
		 */
		function init() {
			
			refreshFunction = 'executeGetParam(\'action=update.rooms\')';
			eval(refreshFunction);
			
			setInterval(refreshFunction, <%= (ROOMS_REFRESH_RATE * 1000) %>);
			
		} // > function init(...)
		
		
		function confirmRemoveRoom(roomName) {
			return confirm('Please confirm you want to remove\n\n\t' + roomName + '\n\nfrom the list of available chat rooms?');
		}
		
		
		/**
		 * Moves current user to another room.
		 * 
		 * NOTICE! This function is referred from other frames so leave function name
		 * intact.
		 *
		 */
		function goToRoom(roomId) {
			setTimeout(
				'executeGetParam(\'action=room.switch,roomId=' + roomId + '\')',
				0
			);
			
			focusMessageArea();
		}
		
	// -->
	</script>
</head>

<body class="rooms" onLoad="init()">
<div class="hdr">
	<%= getMsg("rooms.title") %>
</div>

<div id="data" name="data"></div>

</body>
</html>