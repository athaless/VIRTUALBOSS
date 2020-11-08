<%
  ' ========================================================================
  ' SubRotina para envio de mensagem
  ' ========================================================================
Public Function ATHEnviaMail(pmTO, pmFROM, pmCC, pmBCC, pmSUBJECT, pmBODY, pmIMPORTANCE, pmBODYFORMAT, pmMAILFORMAT, pmATTACH)
Dim strFileName, arrArquivos
Dim objCDOSYSMail, objCDOSYSCon

On Error Resume Next
 
  'cria o objeto para o envio de e-mail 
  Set objCDOSYSMail = Server.CreateObject("CDO.Message") 
  'cria o objeto para configuração do SMTP 
  Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration") 
  'SMTP 
  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "localhost" 
  'porta do SMTP 
  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
  'porta do CDO 
  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
  'timeout 
  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30 

  objCDOSYSCon.Fields.update 

  'atualiza a configuração do CDOSYS para o envio do e-mail 
  Set objCDOSYSMail.Configuration = objCDOSYSCon 

  'e-mail do remetente 
  objCDOSYSMail.From = pmFROM

  'e-mail do destinatário 
  objCDOSYSMail.To = pmTO

  'e-mail do cópia 
  If pmCC <> "" Then
    objCDOSYSMail.Cc = pmCC
  End If

  'e-mail do cópia oculta
  If pmBCC <> "" Then
    objCDOSYSMail.Bcc = pmBCC
  End If

  'assunto da mensagem 
  objCDOSYSMail.Subject = pmSUBJECT

  'anexo
  If pmATTACH <> "" Then
    arrArquivos = split(pmATTACH,"|")
    For Each strFileName In arrArquivos
      objCDOSYSMail.AddAttachment(strFileName)
    Next
  End If


'  If Cstr(pmBODYFORMAT&"") = "1" Then
    'conteúdo da mensagem 
'    objCDOSYSMail.TextBody = pmBODY
'  End If

'  If Cstr(pmBODYFORMAT&"") = "0" Then
    'para envio da mensagem no formato html altere o TextBody para HtmlBody 
    objCDOSYSMail.HtmlBody = pmBODY
'  End If


  'objCDOSYSMail.fields.update 
  'envia o e-mail 
  objCDOSYSMail.Send 

  'destrói os objetos 
  Set objCDOSYSMail = Nothing 
  Set objCDOSYSCon = Nothing 


  If err.Number <> 0 Then
    Response.Write("ERROR:<br> ")
    Response.Write("<font face=courier>")
    Response.Write(err.Description)
    Response.Write("<br><br>Para entrar em contato conosco utilize o e-mail: <a href=" & pmTO & ">" & pmTO & "</a><br><hr>")
    'DEBUG:
	  Response.Write("<br>pmTO..........:" & pmTO)
	  Response.Write("<br>pmFROM........:" & pmFROM)
	  Response.Write("<br>pmCC..........:" & pmCC)
	  Response.Write("<br>pmBCC.........:" & pmBCC)
	  Response.Write("<br>pmSUBJECT.....:" & pmSUBJECT)
	  Response.Write("<br>pmIMPORTANCE..:" & pmIMPORTANCE)
	  Response.Write("<br>pmBODYFORMAT..:" & pmBODYFORMAT) 
      Response.Write("<br>pmMAILFORMAT..:" & pmMAILFORMAT)
      Response.Write("<br>pmATTACH......:" & pmATTACH)
	  Response.Write("<br>pmBODY........:" & pmBODY) 
	  Response.Write("</font>")
    Response.Write("<hr>Pedimos desculpas pelo inconveniente.")
    Response.End()
  End If
  ATHEnviaMail = err.Number
End Function
%>