<%
	
	'
	' Builds view to be shown as "list of available users"
	'
	Function getUsersUI(userId)
	
		' we need to show all users available in this room
		Dim thisUser
		Set thisUser = getUser(userId)
		If (IsNull(thisUser)) Then
			Exit Function
		End If
		
		getUsersUI = "<table border=0 width=100% cellspacing=0 cellpadding=2>"
		
		Dim userId_
		For Each userId_ In conquerChatUsers
			Set user = getUser(userId_)
			If (user.roomId = thisUser.roomId) Then
				
				getUsersUI = getUsersUI & "<tr>"
				getUsersUI = getUsersUI & " <td><img src='images/" & getUserIcon(user) & "' width=16 height=16 border=0></td>"
				
				If (user.id = thisUser.id) Then
					' print users own name in bold
					getUsersUI = getUsersUI & " <td width=100% class=infoText><b>" & user.name & "</b>&nbsp;</td>"
				Else
					' users are able to send private messages to all other users
					' but themselves
					getUsersUI = getUsersUI & _
						"<td width=100% class=infoText>" & _
						"<a href=""javascript:openUserProfile('" & user.id & "', '" & thisUser.id & "')"" title='" & getMsg("users.profile.title") & "'>" & _
						user.name & _
						"</a>" & _
						"&nbsp;" & _
						"<a href=""javascript:openPrivateChat('" & thisUser.id & "', '" & user.id & "')"" title='" & getMsg("users.chat.title") & "'>" & _
						"(chat)" & _
						"</a>" & _
						"</td>"
				End If
				
				getUsersUI = getUsersUI & "</tr>"
			End If
			
		Next ' // > For Each userId_ In conquerChatUsers
		
		getUsersUI = getUsersUI & "</table>"
		
	End Function ' // > Function getUsersUI(...)
	
	
	'
	' Builds view of available rooms for user
	'
	Function getRoomsUI(userId)
		
		Dim user
		Set user = getUser(userId)
		
		getRoomsUI = "<table border=0 width=100% cellspacing=0 cellpadding=2>"
		
		Dim rooms, room, i
		Dim strRoomTags
		rooms = conquerChatRooms.Keys
		If (IsArray(rooms)) Then
			For i = 0 To UBound(rooms)
				Set room = getRoom(rooms(i))
				
				Dim cssClass
				If (room.id = user.roomId) Then
					' this room is where the user is located so apply different style
					cssClass = "rc"
				Else
					cssClass = "r"
				End If
				
				strRoomTags = "" 
				If (room.createdBy = user.id) Then 
					strRoomTags = strRoomTags & "<a href='rooms.asp?chatId=" & userId & "&action=remove&roomId=" & room.id & "' onClick=""return confirmRemoveRoom('" & Server.HTMLEncode(room.name) & "')"">"
					strRoomTags = strRoomTags & "<img src='images/ico.room.remove.gif' width=16 height=16 alt='Remove " & Server.HTMLEncode(room.name) & "' border=0></a>"
				Else
					If (room.tipoPublica = True) Then 
						If (user.acessarSalaPublica = True) Then 
							strRoomTags = strRoomTags & "<img src='images/ico.room.public.gif' width=16 height=16 alt='" & Server.HTMLEncode(room.name) & "' border=0></td>" 
						End If 
					Else 
						If InStr(1, user.comQuemFala, room.tipoCriador, vbTextCompare) > 0 Then 
							strRoomTags = strRoomTags & "<img src='images/ico.room.personal.gif' width=16 height=16 alt='" & Server.HTMLEncode(room.name) & "' border=0></td>" 
						End If 
					End If
				End If
				
				If strRoomTags <> "" Then 
					getRoomsUI = getRoomsUI & "<tr>"
					getRoomsUI = getRoomsUI & "	<td class=" & cssClass & ">" & strRoomTags & "</td>"
					getRoomsUI = getRoomsUI & "	<td class=" & cssClass & " width='100%'><a href=""javascript:goToRoom('" & room.id & "')"">" & Server.HTMLEncode(room.name) & "</a></td>"
					getRoomsUI = getRoomsUI & "	<td class=" & cssClass & " align='right'>" & countUsersInRoom(room.id) & "</td>"
					getRoomsUI = getRoomsUI & "</tr>"
				End If 
			Next
		Else
			'getRoomsUI = getRoomsUI & "<tr><td colspan=2>No rooms available</td></tr>"
			getRoomsUI = getRoomsUI & "<tr><td colspan=2></td></tr>"
		End If
		
		getRoomsUI = getRoomsUI & "</table>"
		
	End Function
	
	
	'
	' Returns script used for logging out of chat. "wrap" indicates if the code
	' should be wrapped in a <script></script block.
	'
	Function getLoggedOutScript(wrap)
		
		getLoggedOutScript = ""
		
		If (wrap) Then
			getLoggedOutScript = "<script type='text/javascript'>"
		End If
		
		getLoggedOutScript = getLoggedOutScript & "document.location.replace('" & PAGE_EXPIRED & "');"
		
		If (wrap) Then
			getLoggedOutScript = getLoggedOutScript & "</script>"
		End If
		
	End Function
	
%>