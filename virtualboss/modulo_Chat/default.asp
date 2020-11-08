<!-- include file="../_database/ConfigInc.asp"-->
<!--#include file="../_database/inc.config.asp"-->
<!--#include file="../_database/athDbConn.asp"-->
<!--#include file="../_database/athUtils.asp"-->
<!-- Includes do sistema RC -->
<%
	Response.Buffer = True
	
	If CFG_USR_STATUS <> "LOGADO" Then
		%>
		<script language="JavaScript">
			alert("Sua sessão expirou!");
			window.close();
		</script>
		<%
		Response.End()
		'Redirect("../principal/default.asp")
	End If
	
	Dim strSQL, objConn, objRS 
	Dim strATIVADO, strATIVAR_SALAS_PUBLICAS, strSALAS_PUBLICAS, strACESSAR_SALAS_PUBLICAS 
	Dim strCRIAR_SALAS_PUBLICAS, strCRIAR_SALAS_PESSOAIS 
	Dim strCOM_QUEM_FALA 
	Dim strDT_AGORA, strID 
	
%>
<!--#include file="inc.common.asp" -->
<%

	AbreDBConn ObjConn, CFG_DB
	
	'--------------------------------
	' Busca configurações 
	'--------------------------------
	strSQL = " SELECT ATIVADO " &_ 
			 "      , ATIVAR_SALAS_PUBLICAS, SALAS_PUBLICAS, ACESSAR_SALAS_PUBLICAS " &_ 
			 "      , CRIAR_SALAS_PUBLICAS, CRIAR_SALAS_PESSOAIS " &_ 
			 " FROM CHAT_CONFIG " 
	Set objRS = objConn.Execute(strSQL) 
	
	strATIVADO = "" 
	strATIVAR_SALAS_PUBLICAS  = "" 
	strSALAS_PUBLICAS         = "" 
	strACESSAR_SALAS_PUBLICAS = "" 
	strCRIAR_SALAS_PUBLICAS   = "" 
	strCRIAR_SALAS_PESSOAIS   = "" 
	
	If Not objRS.Eof Then
		strATIVADO                = UCase(CStr(GetValue(objRS, "ATIVADO") & "")) 
		strATIVAR_SALAS_PUBLICAS  = UCase(CStr(GetValue(objRS, "ATIVAR_SALAS_PUBLICAS") & "")) 
		strSALAS_PUBLICAS         = Trim(CStr(GetValue(objRS, "SALAS_PUBLICAS") & "")) 
		strACESSAR_SALAS_PUBLICAS = Trim(CStr(GetValue(objRS, "ACESSAR_SALAS_PUBLICAS") & "")) 
		strCRIAR_SALAS_PUBLICAS   = Trim(CStr(GetValue(objRS, "CRIAR_SALAS_PUBLICAS") & "")) 
		strCRIAR_SALAS_PESSOAIS   = Trim(CStr(GetValue(objRS, "CRIAR_SALAS_PESSOAIS") & "")) 
	End If 
	FechaRecordSet(objRS) 
	
	If strATIVADO <> "TRUE" And strATIVADO <> "FALSE" Then strATIVADO = "FALSE" 
	If strATIVAR_SALAS_PUBLICAS <> "TRUE" And strATIVAR_SALAS_PUBLICAS <> "FALSE" Then strATIVAR_SALAS_PUBLICAS = "TRUE" 
	If strSALAS_PUBLICAS = "" Then strSALAS_PUBLICAS = DEFAULT_ROOMS 
	
	'--------------------------------
	' Busca regras de conversação 
	'--------------------------------
	strSQL = " SELECT COM_QUEM_FALA FROM CHAT_REGRA_CONVERSA WHERE QUEM_FALA LIKE '" & CFG_USR_TIPO & "' " 
	Set objRS = objConn.Execute(strSQL) 
	
	strCOM_QUEM_FALA = "" 
	Do While Not objRS.Eof 
		strCOM_QUEM_FALA = strCOM_QUEM_FALA & GetValue(objRS, "COM_QUEM_FALA") & ";"  
		objRS.MoveNext
	Loop 
	FechaRecordSet(objRS) 
	
	FechaDBConn ObjConn
	
	'--------------------------------
	' Verifica status do Chat
	'--------------------------------
	If strATIVADO <> "TRUE" Then
		%>
		<script language="JavaScript">
			alert("Chat encontra-se desativado!");
			window.close();
		</script>
		<%
		Response.End()
		'Redirect("../principal/default.asp")
	End If
	
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
	
	'Antigamente apenas verificava quantidade de salas criadas e criava as salas com base numa constante 
	'Agora verifica se deve criar e passa a relação de salas 
	'
	'If (conquerChatRooms.Count = 0) Then
	'	setupRooms()
	'End If
	If strATIVAR_SALAS_PUBLICAS = "TRUE" Then 
		If countPublicRooms = 0 Then setupPublicRooms(strSALAS_PUBLICAS) 
	End If 
	
	' do not show login screen if a valid session exists
	If (loggedOn()) Then
		Response.Redirect "frames.asp"
		Response.End
	End If
	
	Dim mode, errorMessage
	mode = CFG_USR_MODE
	
	If (mode = "userLogin") Then
		
		Dim userName
		userName = Server.HTMLEncode(CFG_USR_COD_USER)
		
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
			p.tipoUsuario = CFG_USR_TIPO 
			
			'Verifica se tipo do usuário pode criar salas (públicas e pessoais)
			'e se pode acessar salas públicas
			p.criarSalaPublica = False 
			p.criarSalaPessoal = False 
			p.acessarSalaPublica = True 
			
			If InStr(1, strCRIAR_SALAS_PUBLICAS  , CFG_USR_TIPO, vbTextCompare) > 0 Then p.criarSalaPublica = True 
			If InStr(1, strCRIAR_SALAS_PESSOAIS  , CFG_USR_TIPO, vbTextCompare) > 0 Then p.criarSalaPessoal = True 
			If InStr(1, strACESSAR_SALAS_PUBLICAS, CFG_USR_TIPO, vbTextCompare) > 0 Then p.acessarSalaPublica = True 
			
			'Grava com que tipo de usuário pode falar
			p.comQuemFala = strCOM_QUEM_FALA 
			
			' we have a new chat user thus we need to create a new
			' id for him/her
			Set p = addUser(p)
			
			Session(SESSIONKEY_USER) = p.data
			
			'Se existem restrições de com quem pode falar, então cria sala pessoal
			If p.comQuemFala <> "" Then 
				If countPersonalRooms(p.id) = 0 Then addRoom p.name, p.id, False, p.tipoUsuario 
			End If 
			
			'Se não existem restrições, coloca numa sala pública
			'Senão busca sala pessoal criada e coloca nela
			strID = "" 
			If (p.acessarSalaPublica = True) Or (p.comQuemFala = "") Then
				strID = getFirstPublicRoom() 
			Else
				strID = getRoomByName(p.name)
			End If
			If strID <> "" Then enterRoom p.id, strID 
			
			' tell all other users about this new user
			strDT_AGORA = PrepData(Now(), True, True) 
			Call addMessage( _
				p.id, _
				"-1", _
				"<span class=LoggedIn><img src='images/new.gif' height=9 width=9>&nbsp;" & getMsg("user.logged_on", p.name, strDT_AGORA) & "</span><br>" _
			)
			
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
<%
	'Fechamento mais acima
	'FechaDBConn ObjConn
%>