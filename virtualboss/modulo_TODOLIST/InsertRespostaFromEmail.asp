<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
  Dim strCODIGO, strIDEXECUTOR
  Dim strUserID, strUserCOD, strUserpwd, strCLINAME


 ' Na  [_database}athEnviaAlert.asp]
 ' na fun��o [MontaHeaderToDo], aproximadamente na linha 71,
 ' temos um trecho de c�digo que monta, no email que vai ser enviado,
 ' um FORMUL�RIO com um bot�o de [RESPONDER], para que leitor possa 
 ' clicar e ser direcionado diretamente � inserir uma repsosta a essa 
 ' tarefa.
 ' Este bot�o aciona essa p�gina (aqui) que tenta ent�o criar as condi��es 
 ' de Cookies e Sess�o adequadas para permitir chamar a DIALOG de inser��o 
 ' de respostas do modulo_TODOLIST

  CFG_DB			= GetParam("var_dbselect")	  
  strCODIGO     	= GetParam("var_chavereg")
  strUserID			= GetParam("var_userid")	    
  strUserCOD		= GetParam("var_cod_usuario")   
  strUserpwd		= GetParam("var_senha")		  	
  strCLINAME		= Replace(CFG_DB,"vboss_","") 'Pega o nome do Cliente apartir do nome do banco de dados
  
  Response.Cookies("VBOSS")("COD_USUARIO")	 = strUserCOD
  Response.Cookies("VBOSS")("ID_USUARIO")	 = strUserID
  Response.Cookies("VBOSS")("SENHA")		 = strUserpwd 'esta em MD5
  Response.Cookies("VBOSS")("DBNAME")		 = CFG_DB
  Response.Cookies("VBOSS")("DT_LOGIN")		 = now()
  Response.Cookies("VBOSS")("CLINAME")		 = strCLINAME
%>
<html>
<head>
<title>VirtualBOSS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body onLoad="document.getElementById('formInsRepFromEmail').submuit();">
<form name="formInsRepFromEmail" action="InsertResposta.asp" method="post">
	<input type="hidden" name="var_chavereg"  value="<%=strCODIGO%>">
	<input type="hidden" name="var_ultexec"   value="<%=strUserID%>">
</form>
</body>
</html>