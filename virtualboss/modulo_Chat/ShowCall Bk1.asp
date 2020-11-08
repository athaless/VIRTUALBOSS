<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../_database/adovbs.inc"-->
<!--#include file="../_database/athUtils.asp"--> 
<!--include file="../_database/athDbConn.asp"--> 
<!--#include file="../_include/funcoes_UsrAS.asp"-->
<!--#include file="inc.common.asp"-->
<%
	'RemoveTodos()
	'If UCase(Session("STATUS")) <> "LOGADO" Then Response.Redirect("../modulo_Principal/Default.asp")

	Dim objConn, strSQL, objRS
	Dim strAux, m
	', objRSAux
	'Dim strCOD_CATEGORIA, strNRO_TOPICOS, strNRO_MSG
	'Dim strLAST_MSG, strINTERNAUTA, strCOD_INTERNAUTA
	'Dim strTOTAL_MSG, strTOTAL_CADASTRADOS
	'Dim strNEW_NOME, strNEW_COD

	'AbreDBConn objConn, CFG_DB
    
	'Pega o total de pessoas cadastradas
	'strSQL = " SELECT COUNT(COD_USER) AS TOTAL " &_
	'		 " FROM USUARIOS " &_
	'		 " WHERE DT_INATIVO IS NULL "
	'Set objRS = objConn.Execute(strSQL)
	
	'If Not objRS.EOF Then
	'	strTOTAL_CADASTRADOS = GetValue(objRS, "TOTAL")
	'Else
	'	strTOTAL_CADASTRADOS = "0"
	'End If
	'FechaRecordset(objRS)
%> 
<html>
<head>
<title>Convidar Usuário</title>
<link href="css/chat.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="refresh" content="30">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="users">
<div class="hdr">
	<b>Usu&aacute;rios On-Line:</b>
</div>
<div id="Lista" style="position:absolute; width:100%; height:200px; z-index:1; left: 0px; top: 30px; overflow: auto;"> 
<table width="100%" border="0" cellpadding="0" cellspacing="2">
  	<form name="frmConvida" action="ConviteInsert.asp" method="post">
    <tr>
      <td height="8"></td>
    </tr>
    <tr> 
      <td> 
	<%
	  	strAux = UsersOnline()
		strAux = Split(strAux, "|")

		For m = 1 To UBound(strAux) Step 2
			If Not userExists(strAux(m)) And CStr(strAux(m)) <> CStr(Session("COD_USER")) Then
				Response.Write(" <input type=""checkbox"" name=""chkName"" value=""" & strAux(m+1) & "|" & strAux(m) & """><span class=""ForumPequena"">" & strAux(m) & "<br>")
			End If
		Next
	%> 
	</td>
    </tr>
	</form>
</table>
</div>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td>&nbsp;11</td>
  </tr>
  <tr>
    <td height="30" align="center"><a href="#" onClick="javascript:frmConvida.submit();"><img src="../img/BtEnviar.gif" width="41" height="18" border="0"></a></td>
  </tr>
</table>
</body>
</html>