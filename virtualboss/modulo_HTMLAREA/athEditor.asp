<%
    strTextBoxName = Server.HTMLEncode(Request("var_TextBoxName"))
	strIndexForm   = Server.HTMLEncode(Request("var_IndexForm"))
	strTipo        = request("var_tipo")
	
	if strTipo <> "" then
	  strIMAGEM = "bt_gravar_alterar.gif"
	  strACTION = "associa.asp"
	  strTARGET = "atheditor"
	  strEVENTO = " onClick=""window.open('','atheditor','popup=yes,width=550 height=540,resizable=yes,scrollbars=1')"""
	else
	  strIMAGEM = "bt_enviar.gif"
	  strACTION = "sampleposteddata.asp"
	  strTARGET = ""
	  strEVENTO = ""
	end if
	'strContent     = Request("var_Content")
%>
<html>
  <head>
    <title>Athenas Content Site Manager - Editor de HTML </title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <script type="text/javascript">
      _editor_url = "htmlarea/";
      _editor_lang = "pt_br";
    </script>
    <script type="text/javascript" src="htmlarea/htmlarea.js"></script>
    <script type="text/javascript" src="htmlarea/dialog.js"></script>
    <script type="text/javascript" src="htmlarea/popupwin.js"></script>
    <!-- <script type="text/javascript" src="htmlarea/popupdiv.js"></script> -->
    <script type="text/javascript">
	  <%if strTipo = "" then%>
	  function setValue()
	  {
	 	formhtmlarea.htmlarea.value = window.opener.document.forms[<%=strIndexForm%>].<%=strTextBoxName%>.value
	  }
	  <%end if%>
      HTMLArea.loadPlugin("ContextMenu");
      //HTMLArea.loadPlugin("FullPage");
      //HTMLArea.loadPlugin("SpellChecker");
      HTMLArea.loadPlugin("TableOperations");

      var editor = null;
      function initDocument() {
        editor = new HTMLArea("editor");
        editor.registerPlugin(ContextMenu);
        //editor.registerPlugin(FullPage);
        //editor.registerPlugin(SpellChecker);
        editor.registerPlugin(TableOperations);
        editor.generate();
		<%if strTipo = "" then%>
		  setValue();
		<%end if%>
      }
    </script>
  <link rel="stylesheet" href="htmlarea/htmlarea.css" type="text/css">
  </head>
  <body onload="initDocument();" topmargin="0" leftmargin="0">
  <form name="formhtmlarea" action="<%=strACTION%>" method="post" target="<%=strTARGET%>">
	<input type="hidden" name="var_TextBoxName" value="<%=strTextBoxName%>">
	<input type="hidden" name="var_IndexForm" value="<%=strIndexForm%>">    
    <textarea id=editor name="htmlarea" style="height:33em;"></textarea>
    <hr/>
    <input type="image" src="../img/<%=strIMAGEM%>"<%=strEVENTO%>>
  </form>
  </body>
</html>
