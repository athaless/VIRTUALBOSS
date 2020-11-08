<% @ Language="VBScript" %>
<% Option Explicit %>
<%
' PROVISÓRIO
' Este código não é dos melhores pois procura uma lista específica de componentes
' Tenho um código melhor que lista TODOS os componenes instalados, assim que econtrá-lo vou substituir 
'  ------------------------------------------------------------------------------------------------------------- by Aless
 
Dim theComponent(12)
Dim theComponentName(12)
Dim i

' componentes
theComponent(0) = "ADODB.Connection"
theComponent(1) = "SoftArtisans.FileUp"
theComponent(2) = "AspHTTP.Conn"
theComponent(3) = "AspImage.Image"
theComponent(4) = "LastMod.FileObj"
theComponent(5) = "Scripting.FileSystemObject"
theComponent(6) = "SMTPsvg.Mailer"
theComponent(7) = "CDONTS.NewMail"
theComponent(8) = "Jmail.smtpmail"
theComponent(9) = "SmtpMail.SmtpMail.1"
theComponent(10) = "Persits.Upload"
theComponent(11) = "Persits.Upload.1"
theComponent(12) = "UnitedBinary.AutoImageSize"

' apelido do componente!
theComponentName(0) = "ADODB"
theComponentName(1) = "SA-FileUp"
theComponentName(2) = "AspHTTP"
theComponentName(3) = "AspImage"
theComponentName(4) = "LastMod"
theComponentName(5) = "FileSystemObject"
theComponentName(6) = "ASPMail"
theComponentName(7) = "CDONTS"
theComponentName(8) = "JMail"
theComponentName(9) = "SMTP"
theComponentName(10) = "Persits Upload"
theComponentName(11) = "Persits Upload 1"
theComponentName(12) = "AutoImageSize"

Function IsObjInstalled(strClassString)
  Dim xTestObj
	On Error Resume Next
	IsObjInstalled = False
	Err = 0
	Set xTestObj = Server.CreateObject(strClassString)
	If 0 = Err Then IsObjInstalled = True
	Set xTestObj = Nothing
	Err = 0
End Function
%>
<html>
<head>
<title></title>
</head>
<body>
<b>Componentes instalados:</b><br><br>
    <% 
    For i=0 to UBound(theComponent)
		If Not IsObjInstalled(theComponent(i)) Then
		Else
			Response.Write theComponentName(i) & vbCrLf
			Response.Write "<hr>" & vbCrLf
		End If
	Next 
	%>
</body>
</html>
