<%
' ========================================================================
' SubRotina para envio de mensagem
' ========================================================================
Public Function ATHEnviaMail(pmTO, pmFROM, pmCC, pmBCC, pmSUBJECT, pmBODY, pmIMPORTANCE, pmBODYFORMAT, pmMAILFORMAT, pmATTACH)
'Response.ContentType = "text/html"
'Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
'Response.CodePage	= 65001
'Response.CharSet	= "UTF-8"'


 Dim strFileName, arrArquivos
 Dim objCDOSYSMail, objCDOSYSCon
	
 '
 ' INI: DO NOT SEND EMAIL ------------------------------------------------'
 ' Por um p3eríodo pra agilizar o uso do VBOSS estmaso sem envio de EMAILS
 ' a partir dele, provocando a saída (EXIT) da função log na sua entrada.                                      
 ' 16/10/2015 - liberado novamente o envio de e-mail via vboss
 '  Exit Function
 ' FIM: DO NOT SEND EMAIL ------------------------ 18/08/2015 by Aless----'
	
 On Error Resume Next
	  'cria o objeto para o envio de e-mail 
	  Set objCDOSYSMail = Server.CreateObject("CDO.Message") 
	  'cria o objeto para configuração do SMTP 
	  Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration") 
	  'SMTP 
	  'objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.virtualboss.com.br" 
	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "localhost" 
	  'porta do SMTP 
	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	  'porta do CDO 
	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
	  'timeout 
	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30 
	
	
	
	
	  'Dentro de todo o sistema as chamadas para função ATHEnviaMail madna no parâmetro pmFROM = "virtualboss@virtualboss.com.br" 
	  'para o servidor novo PS2 testa conta dá erro desta forma forçamso aqui que o envio seja feito por uma outra conta criada 
	  'para envio de emails se estivermos neste servidor. pmFROM = "noreply@virtualboss.com.br"
	  'pmFROM = "noreply@virtualboss.com.br"
	  pmFROM = "noreply@proeventovista.com.br"
	
	
	
	  'INI: NEW ** (PS2) ----------------------------------------------------------------------------------------------------------
				'parametros para smtpauthenticate
				'0 Do not authenticate [estamos usando essa pois estamos tendo possiveis problemas com o cdonts no htmail server]
				'1 basic (clear-text) authentication
	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 0  'basic (clear text) authentication
	 ' objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusername") = pmFROM 
	 ' objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "athroute66" 
	  'FIM: NEW ** (PS2) ----------------------------------------------------------------------------------------------------------
	
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
	
	  If Cstr(pmBODYFORMAT&"") = "1" Then 'conteúdo da mensagem 
		objCDOSYSMail.TextBody = pmBODY
	  End If
	
	  If Cstr(pmBODYFORMAT&"") = "0" Then 'para envio da mensagem no formato html altere o TextBody para HtmlBody 
		objCDOSYSMail.HtmlBody = pmBODY
	  End If
	
	  'objCDOSYSMail.fields.update 
	  objCDOSYSMail.Send 
	
	  Set objCDOSYSMail = Nothing 
	  Set objCDOSYSCon  = Nothing 
	
	  If err.Number <> 0 Then
		Response.Write("ERROR: [email fail]<br> ")
		Response.Write("<font face=courier>")
		Response.Write(err.Description)
		Response.Write("<br><hr>")
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

Function Email_notify(pr_body, pr_subject, pr_emails, pr_from, pr_clifolder)
Dim strMSG, strSUBJECT, strTO, strFROM, strBODY, strLOGO

Response.ContentType = "text/html"
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CodePage	= 65001
Response.CharSet	= "UTF-8"


 ' ---------------------------------------------------------------------------
 ' Esta página envia um e-mails de avisos | by aless & alan (24/11/2006) 
 ' Parâmetros recebidos **
 ' ---------------------------------------------------------------------------
 ' pr_emails.....: email de destino, caso não seja recebido nenhum, ela manda 
 '                 pra todos os cadastrados na tablea internautas
 ' pr_subject....: assunto a ser colocado na mensagem
 ' pr_body.......: mensagem propriamente dita
 ' pr_clifolder..: pasta do cliente que vai no link
 ' --------------------------------------------------------------------------- 
 
  strMSG      = pr_body
  strSUBJECT  = pr_subject
  strTO		  = pr_emails
  strFROM	  = pr_from	
  
  'strLOGO = "LogoVBoss.gif"

  strBODY =	"<table border='0px' cellpadding='0px' cellspacing='0px' width='100%' style='font:11px Tahoma;'>" & VbCrLf
  strBODY =	strBODY & "	<tr><td colspan='2'><img src='http://virtualboss.proevento.com.br/virtualboss/img/LogoVBoss.gif' border='0'></td></tr>" & VbCrLf
  strBODY =	strBODY & "	<tr><td colspan='2' height='1px' bgcolor='#C9C9C9'></td></tr>" & VbCrLf
  strBODY =	strBODY & "	<tr><td height='25px' width='80px'></td><td style='font-weight:bold; padding-left:10px;'>Informações</td></tr>" & VbCrLf
  strBODY =	strBODY & "	<tr><td align='right'>Remetente:&nbsp;</td><td style='padding-left:10px;'>" & strFROM & "</td></tr>" & VbCrLf
  strBODY =	strBODY & "	<tr><td height='3px'></td></tr><tr><td align='right'>Data:&nbsp;</td><td style='padding-left:10px;'>" & Now() & "</td></tr>" & VbCrLf
  strBODY =	strBODY & "	<tr><td height='3px'></td></tr><tr><td align='right'>Mensagem:&nbsp;</td><td style='padding-left:10px;'>" & strMSG & "</td></tr>" & VbCrLf
  strBODY =	strBODY & "	<tr><td height='3px'></td></tr>" & VbCrLf
  strBODY =	strBODY & "	<tr>" & VbCrLf
  strBODY =	strBODY & "		<td></td>" & VbCrLf
  strBODY =	strBODY & "		<td style='padding-left:10px;'>" & VbCrLf
  strBODY =	strBODY & "			<a href='http://virtualboss.proevento.com.br/" & pr_clifolder & "/' target='_blank' style='color:#006699; text-decoration:none;'>Clique aqui</a>" & VbCrLf
  strBODY =	strBODY & "			para acessar suas mensagens no VirtualBOSS." & VbCrLf
  strBODY =	strBODY & "		</td>" & VbCrLf
  strBODY =	strBODY & "	<tr>" & VbCrLf
  strBODY =	strBODY & "	<tr><td height='20px'></td></tr><tr><td colspan='2' height='1' bgcolor='#C9C9C9'></td></tr>" & VbCrLf
  strBODY =	strBODY & "	<tr>" & VbCrLf
  strBODY =	strBODY & "   <td colspan='2'>" & VbCrLf
  strBODY =	strBODY & "		<table width='100%' style='font-family:Tahoma, Verdana; font-size:9;'>" & VbCrLf
  strBODY =	strBODY & "       	<tr>" & VbCrLf
  strBODY =	strBODY & "        		<td align='left' style='width:100%; padding-left:5px; text-align:left; color:#999999;' >" & VbCrLf
  strBODY =	strBODY & "           		<font style='color:#999999;'>Mensagem enviada automaticamente, NÃO RESPONDER DIRETAMENTE ESTE EMAIL, para responder acesse o VirtualBOSS.</font>" & VbCrLf
  strBODY =	strBODY & "           	</td>" & VbCrLf
 'strBODY =	strBODY & "           	<td align='right' style='width:50%; padding-right:5px; text-align:right; color:#999999;'>" & VbCrLf
 'strBODY =	strBODY & "           		VIRTUAL BOSS - desenvolvido por" & VbCrLf
 'strBODY =	strBODY & "               	<a href='http://www.proevento.com.br' target='_blank' style='color:#006699; font:none 11px; text-decoration:none;'>PROEVENTO <span style='font-size=8px; font-family: Arial color: #006699; text-decoration: none; letter-spacing:2px;'>TECNOLOGIA</span></a>." & VbCrLf
 'strBODY =	strBODY & "           	</td>" & VbCrLf
  strBODY =	strBODY & "        	</tr>" & VbCrLf
  strBODY =	strBODY & "		</table>" & VbCrLf
  strBODY =	strBODY & "   </td>" & VbCrLf
  strBODY =	strBODY & "	</tr>" & VbCrLf
  strBODY =	strBODY & "</table>" & VbCrLf
  
  
  AthEnviaMail strTO, "noreply@proeventovista.com.br", "", "ath.virtualboss@gmail.com", strSUBJECT, strBODY, 1, 0, 0, ""
End Function
%>