<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<% Response.Expires = 300 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<%
 DIM strUser, strPass, strDB, strExtra
 
 strUser	= Request("var_user")
 strPass	= Request("var_password")
 strDB		= Request("var_db")
 strExtra	= Request("var_extra")
%>
<html>
<head>
<title>VirtualBOSS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset rows="25,*,25" frameborder="0" border="0"> 
  <frame name="vbfr_mtop" src="../virtualboss/moldura_top.asp?var_pwidth=*" scrolling="no" marginwidth="0" marginheight="0" frameborder="no">
  <frameset cols="25,*,25" frameborder="0" border="0"> 
    <frame name="vbfr_mleft"   src="../virtualboss/moldura_left.asp"  scrolling="no" marginwidth="0" marginheight="0" frameborder="no">
    <frame name="vbfr_pcenter" 
	       src="login.asp?var_user=<%=strUser%>&var_password=<%=strPass%>&var_db=<%=strDB%>&var_extra=<%=strExtra%>" 
	       scrolling="no" 
		   frameborder="0"
		   style="padding:0px; margin:0px;">
    <frame name="vbfr_mright"  src="../virtualboss/moldura_right.asp" scrolling="no" marginwidth="0" marginheight="0" frameborder="no">
  </frameset>
  <frame name="vbfr_mbottom" src="../virtualboss/moldura_bottom.asp?var_pwidth=*" scrolling="NO" marginwidth="0" marginheight="0" frameborder="no">
</frameset>
<noframes><body>
</body></noframes>
</html>