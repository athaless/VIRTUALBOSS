<!--#include file="../virtualboss/_database/athdbConn.asp" //--> <!-- ATEN��O: language, option explicit, etc... est�o no athDBConn //-->
<!--
  ATEN��O ******************************************************
  Para logins externos, ou seja direto via o site do clietne,  basta chamar esta 
  p�gina: default_LoginViasite.asp com os respectivos par�metros:
 
 <form id='chamado' name='chamado' action='http://www.virtualboss.com.br/proevento/default_LoginViasite.asp'	target='_blank'	method='post'>
	<input type='hidden' id='var_user'		name='var_user'		value=''>
	<input type='hidden' id='var_password'	name='var_password'	value=''>
	<input type='hidden' id='var_db'		name='var_db'		value=''>
	<input type='hidden' id='var_extra'		name='var_extra'		value=''>
	<input type='image'      src='../img/ButHelpDesk.gif'      border='0'      title='Abrir chamado ...'     alt='Abrir chamado...'>
 </form>
  ****************************************************************
//-->
<%
 DIM strUser, strPass, strDB, strExtra
 
 strUser	= GetParam("var_user")
 strPass	= GetParam("var_password")
 strDB		= GetParam("var_db")
 strExtra	= GetParam("var_extra")	
%>
<html>
<head>
<title>VirtualBOSS</title>
</head>
 <frameset rows="*,0" frameborder="NO" border="0" framespacing="0">
   <frame src="VirtualBoss.asp?var_user=<%=strUser%>&var_password=<%=strPass%>&var_db=<%=strDB%>&var_extra=<%=strExtra%>" name="vboss_mainFrame" scrolling="NO" noresize>
   <frame src="about:blank" name="topFrame">
 </frameset>
<noframes>
 <body>Este navegador n�o suporta frames!</body>
</noframes>
</html>