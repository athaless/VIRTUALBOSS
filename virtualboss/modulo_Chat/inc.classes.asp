<%
	
	' 
	' $Id: inc.classes.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' All classes used in ConquerChat to store user information, rooms and 
	' messages.
	' 
	' @author	Peter Theill	peter@theill.com
	' 
	
	Class Person
		
		Private id_
		Private name_
		Private roomId_
		Private lastAction_
		
		Private loggedOn_
		Private ipAddress_
		Private sendMessages_
		
		'Propriedade(s) que sistemas RC precisam
		Private criarSalaPublica_
		Private criarSalaPessoal_
		Private acessarSalaPublica_
		Private comQuemFala_
		Private tipoUsuario_
		
		Private Sub Class_Initialize()
			id_ = -1
			name_ = "Guest"
			roomId_ = -1
			action()
			loggedOn_ = Now()
			ipAddress = ""
			sendMessages_ = 0
			criarSalaPublica_ = False
			criarSalaPessoal_ = False
			acessarSalaPublica_ = True
			comQuemFala_ = ""
			tipoUsuario_ = ""
		End Sub
		
		'Get functions
		Public Property Get id
			id = id_
		End Property
		
		Public Property Get name
			name = name_
		End Property
		
		Public Property Get roomId
			roomId = roomId_
		End Property
		
		Public Property Get lastAction
			lastAction = lastAction_
		End Property
		
		Public Property Get loggedOn
			loggedOn = loggedOn_
		End Property
		
		Public Property Get ipAddress
			ipAddress = ipAddress_
		End Property
		
		Public Property Get sendMessages
			sendMessages = sendMessages_
		End Property
		
		Public Property Get criarSalaPublica
			criarSalaPublica = criarSalaPublica_
		End Property
		
		Public Property Get criarSalaPessoal
			criarSalaPessoal = criarSalaPessoal_
		End Property
		
		Public Property Get acessarSalaPublica
			acessarSalaPublica = acessarSalaPublica_
		End Property

		Public Property Get comQuemFala
			comQuemFala = comQuemFala_
		End Property
		
		Public Property Get tipoUsuario
			tipoUsuario = tipoUsuario_
		End Property
		
		'Let functions
		Public Property Let id(v)
			id_ = v
		End Property
		
		Public Property Let name(v)
			name_ = v
		End Property
		
		Public Property Let roomId(v)
			roomId_ = v
		End Property
		
		Public Sub action()
			lastAction_ = CStr(Now())
		End Sub
		
		Private Property Let loggedOn(v)
			loggedOn_ = v
		End Property
		
		Public Property Let ipAddress(v)
			ipAddress_ = v
		End Property
		
		Public Property Let sendMessages(v)
			sendMessages_ = v
		End Property
		
		Public Property Let criarSalaPublica(v)
			criarSalaPublica_ = v
		End Property
		
		Public Property Let criarSalaPessoal(v)
			criarSalaPessoal_ = v
		End Property
		
		Public Property Let acessarSalaPublica(v)
			acessarSalaPublica_ = v
		End Property
		
		Public Property Let comQuemFala(v)
			comQuemFala_ = v
		End Property
		
		Public Property Let tipoUsuario(v)
			tipoUsuario_ = v
		End Property
		
		'Data functions
		Public Property Get data
			data = id_ & Chr(1) & name_ & Chr(1) & roomId_ & Chr(1) & lastAction_ & Chr(1) & loggedOn_ & Chr(1) & ipAddress_ & Chr(1) & sendMessages_ &	Chr(1) & criarSalaPublica_ & Chr(1) & criarSalaPessoal_ & Chr(1) & acessarSalaPublica_ & Chr(1) & comQuemFala_ & Chr(1) & tipoUsuario_ 
		End Property
		
		Public Property Let data(v)
			Dim dataArray
			dataArray = Split(v, Chr(1))
			If (IsArray(dataArray) AND (UBound(dataArray) >= 11)) Then
				id_ = dataArray(0)
				name_ = dataArray(1)
				roomId_ = dataArray(2)
				lastAction_ = dataArray(3)
				loggedOn_ = dataArray(4)
				ipAddress_ = dataArray(5)
				sendMessages_ = dataArray(6)
				criarSalaPublica_ = dataArray(7)
				criarSalaPessoal_ = dataArray(8)
				acessarSalaPublica_ = dataArray(9)
				comQuemFala_ = dataArray(10)
				tipoUsuario_ = dataArray(11)
			End If
		End Property
		
		Private Sub debug()
			Response.Write "<table>"
			Response.Write "<tr><td colspan=11><b>User</b></td></tr>"
			Response.Write "<tr><td>" & id_ & "</td>"
			Response.Write "	<td>" & name_ & "</td>"
			Response.Write "	<td>" & roomId_ & "</td>"
			Response.Write "	<td>" & lastAction_ & "</td>"
			Response.Write "	<td>" & loggedOn_ & "</td>"
			Response.Write "	<td>" & ipAddress_ & "</td>"
			Response.Write "	<td>" & criarSalaPublica_ & "</td>"
			Response.Write "	<td>" & criarSalaPessoal_ & "</td>"
			Response.Write "	<td>" & acessarSalaPublica_ & "</td>"
			Response.Write "	<td>" & comQuemFala_ & "</td>"
			Response.Write "	<td>" & tipoUsuario_ & "</td>"
			Response.Write "</tr>"
			Response.Write "</table>"
		End Sub
		
	End Class ' // > Class Person
	
	
	Class Room
		
		Private id_
		Private name_		
		Private createdBy_
		'Propriedade(s) que sistemas RC precisam
		Private tipoPublica_
		Private tipoCriador_
		
		Private Sub Class_Initialize()
			id_ = -1
			name_ = "Default"
			createdBy_ = -1
			tipoPublica_ = True
			tipoCriador_ = ""
		End Sub
		
		'Get functions
		Public Property Get id
			id = id_
		End Property
		
		Public Property Get name
			name = name_
		End Property
		
		Public Property Get createdBy
			createdBy = createdBy_
		End Property
		
		Public Property Get tipoPublica
			tipoPublica = tipoPublica_
		End Property
		
		Public Property Get tipoCriador
			tipoCriador = tipoCriador_
		End Property

		'Let functions
		Public Property Let id(v)
			id_ = v
		End Property
		
		Public Property Let name(v)
			name_ = v
		End Property
		
		Public Property Let createdBy(v)
			createdBy_ = v
		End Property

		Public Property Let tipoPublica(v)
			tipoPublica_ = v
		End Property

		Public Property Let tipoCriador(v)
			tipoCriador_ = v
		End Property
		
		'Data functions
		Public Property Get data
			data = id_ & Chr(1) & name_ & Chr(1) & createdBy_ & Chr(1) & tipoPublica_ & Chr(1) & tipoCriador_ 
		End Property
		
		Public Property Let data(v)
			Dim dataArray
			dataArray = Split(v, Chr(1))
			If (IsArray(dataArray) AND (UBound(dataArray) >= 4)) Then
				id_ = dataArray(0)
				name_ = dataArray(1)
				createdBy_ = dataArray(2)
				tipoPublica_ = dataArray(3)
				tipoCriador_ = dataArray(4)
			End If
		End Property
		
		Private Sub debug()
			Response.Write "<table>"
			Response.Write "<tr><td colspan=5><b>Room</b></td></tr>"
			Response.Write "<tr><td>" & id_ & "</td>"
			Response.Write "	<td>" & name_ & "</td>"
			Response.Write "	<td>" & createdBy_ & "</td>"
			Response.Write "	<td>" & tipoPublica_ & "</td>"
			Response.Write "	<td>" & tipoCriador_ & "</td>"
			Response.Write "</tr>"
			Response.Write "</table>"
		End Sub
		
	End Class ' // > Class Room
	
	
	Class Message
		
		Private roomId_			' room where message appears
		Private position_		' line number for message (starting from 0)
		Private userId_			' user sending message
		Private receiverId_		' user receiving message (-1 for all)
		Private text_			' message
		
		'Get functions
		Public Property Get roomId
			roomId = roomId_
		End Property
		
		Public Property Get position
			position = position_
		End Property
		
		Public Property Get userId
			userId = userId_
		End Property
		
		Public Property Get receiverId
			receiverId = receiverId_
		End Property
		
		Public Property Get text
			text = text_
		End Property
		
		'Let functions
		Public Property Let roomId(v)
			roomId_ = v
		End Property
		
		Public Property Let position(v)
			position_ = v
		End Property
		
		Public Property Let userId(v)
			userId_ = v
		End Property
		
		Public Property Let receiverId(v)
			receiverId_ = v
		End Property
		
		Public Property Let text(v)
			text_ = v
		End Property
		
		'Data functions
		Public Property Get data
			data = roomId_ & Chr(1) & position & Chr(1) & userId_ & Chr(1) & receiverId_ & Chr(1) & text_
		End Property
		
		Public Property Let data(v)
			Dim dataArray
			dataArray = Split(v, Chr(1))
			If (IsArray(dataArray) AND (UBound(dataArray) >= 4)) Then
				roomId_ = dataArray(0)
				position_ = dataArray(1)
				userId_ = dataArray(2)
				receiverId_ = dataArray(3)
				text_ = dataArray(4)
			End If
		End Property
		
		Public Sub debug()
			Response.Write "<table>"
			Response.Write "<tr><td colspan=5><b>Message</b></td></tr>"
			Response.Write "<tr><td>" & roomId_ & "</td>"
			Response.Write "	<td>" & position_ & "</td>"
			Response.Write "	<td>" & userId_ & "</td>"
			Response.Write "	<td>" & receiverId_ & "</td>"
			Response.Write "	<td>" & text_ & "</td>"
			Response.Write "</tr>"
			Response.Write "</table>"
		End Sub
		
	End Class ' // > Class Message
	
%>