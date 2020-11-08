<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../_include/IncludeUsrLogados.asp"-->
<%
	Dim strUsers, i, Colunas
%> 
<html>
<head>
<title>Usuários</title>
<link href="css/chat.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="refresh" content="30">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="users">
<div class="hdr">
	<b>Usu&aacute;rios On-Line:</b>
</div>
<div id="Lista" style="position:absolute; width:100%; height:360px; z-index:1; left: 0px; top: 30px; overflow: auto;"> 
<table width="100%" border="0" cellpadding="0" cellspacing="2">
  	<form name="frmConvida" action="ConviteInsert.asp" method="post">
    <tr> 
      <td> 
	<%
		Colunas = TotalColunasInfo()
	  	strUsers = UsersOnline()
		strUsers = Split(strUsers, "|")
		
		For i = 1 To UBound(strUsers) Step Colunas
			If CStr(strUsers(i+1)) <> CStr(CFG_USR_COD_USER) Then
				Response.Write("<input type='checkbox' name='chkName' value='" & strUsers(i+1) & "|" & strUsers(i) & "'>")
				Response.Write("<span class='ForumPequena'>" & strUsers(i) & "</span><br>")
			End If
		Next
	%> 
	</td>
    </tr>
	</form>
</table>
</div>
<div id="Convida" style="position:absolute; width:100%; height:30px; z-index:1; left: 0px; top: 390px; overflow: auto;"> 
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="100%" valign="middle" align="center">
	<input type="button" class="btn" value="Convidar" taborder="2" name="submit" border="0" title="Envia convite" onClick="javascript:frmConvida.submit();">
	</td>
  </tr>
</table>
</div>
</body>
</html>