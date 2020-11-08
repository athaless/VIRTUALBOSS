<%@ CodePage="1252" Language="VBScript"%>
<% 
	Dim sForm
	sForm = Replace(Replace(Request.Form("htmlarea"), """", "'"), VbCrLf, "")

	Dim strtextboxname, strIndexForm
	strTextBoxName = Server.HTMLEncode(Request("var_TextBoxName"))
	strIndexForm   = Server.HTMLEncode(Request("var_IndexForm"))

%>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script language="JavaScript">
			function Trim(str)
			{
				while (str.charAt(0) == " ")
				str = str.substr(1,str.length -1);

				while (str.charAt(str.length-1) == " ")
				str = str.substr(0,str.length-1);

				return str;
			} 
			function Carrega()
			{
				window.opener.document.forms[<%=strIndexForm%>].<%=strTextBoxName%>.value = Trim("<%=sForm%>");
				self.close();
			}
		</script>
	</head>
	<body onLoad="javascript:Carrega();"></body>
</html>