<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
  Dim strSQL, objRS, ObjConn
  Dim strCODIGO

  strCODIGO = GetParam("var_chavereg")

  AbreDBConn objConn, CFG_DB
	
  'Marca o Recado como lido -------------------------------------------------------------------------------------
  strSQL = " UPDATE RECADO SET SYS_DTT_VIEW = '"& PrepDataBrToUni(now,true) & "' WHERE COD_RECADO=" & strCODIGO
  objConn.Execute(strSQL)
  '--------------------------------------------------------------------------------------------------------------
  
  strSQL = " SELECT ID_USUARIO_TO, TEXTO FROM RECADO WHERE COD_RECADO=" & strCODIGO 
  Set objRS = objConn.Execute(strSQL)
%>
<html>
<head>
<title>VBoss - Recados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onUnload="javascript:opener.location.reload();">
<table width="150" height="28" cellpadding="0" cellspacing="0" border="0">
 <tr><td colspan="4" height="10"></td></tr>
 <tr>
   <td align="left" valign="middle" width="10">&nbsp;</td>
   <td align="left" valign="middle" width="10"><a href="JavaScript:window.print();"><img src="../img/IconPrint.gif" alt="imprimir..." border="0"></a></td>
   <td align="left" valign="middle" width="5">&nbsp;</td>
   <td align="left" valign="middle" width="115" bgcolor="#F2F2F2">&nbsp;&nbsp;<b>Para: <%=GetValue(objRS,"ID_USUARIO_TO")%></b></td>
 </tr>
</table>
<br>
<div style="padding-left:10px"><%=objRS("TEXTO")%></div>
</body>
</html>
<%
  FechaRecordSet objRS
  FechaDBConn objConn
%>