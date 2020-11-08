<%
  ' ========================================================================
  ' SubRotina para envio de mensagem
  ' ========================================================================
Public Function ATHEnviaMail(pmTO, pmFROM, pmCC, pmBCC, pmSUBJECT, pmBODY, pmIMPORTANCE, pmBODYFORMAT, pmMAILFORMAT, pmATTACH)
    Dim objCDO, strFileName, arrArquivos

    'On Error Resume Next
 
    Set objCDO = Server.CreateObject("CDONTS.NewMail")

    objCDO.To         = pmTO
    objCDO.From       = pmFROM
    objCDO.Cc         = pmCC
    objCDO.Bcc        = pmBCC
    objCDO.Subject    = pmSUBJECT
    objCDO.Body       = pmBody
	objCDO.Importance = pmIMPORTANCE
    ' BodyFormat = 0 significa que o corpo da mensagem contém tags em HTML
    '              1 significa que o corpo da mensagem utiliza texto simples
    objCDO.BodyFormat = pmBODYFORMAT 'Formato do Outlook
    objCDO.MailFormat = pmMAILFORMAT 'Formato de alguns outros programas de e-mail
	If pmATTACH <> "" Then
      arrArquivos = split(pmATTACH,"|")
  	  For Each strFileName In arrArquivos
        objCDO.AttachFile(strFileName)
      Next
	End If
    objCDO.Send

    Set objCDO = Nothing

    ATHEnviaMail = err.Number
End Function
%>