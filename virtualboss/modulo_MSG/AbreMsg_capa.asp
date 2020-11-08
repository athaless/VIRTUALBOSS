<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<%
	Dim strSQL, strSQLAux, objConn, objRS, objRSAux, objRSPasta , auxStr
	Dim strCODIGO, strPASTA, strANEXOS, strRESIZE
	
	strCODIGO = GetParam("var_chavereg")
	
	strPASTA = "CX_ENTRADA"
	
	AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body>
<table align="right" border="0px" cellpadding="0px" cellspacing="0px" width="100%" height="100%"> 
	<tr>
		<td height="29px" valign="bottom" style="padding:0px 0px 5px 5px;"><strong>Mensagem</strong></td>
		<td  valign="middle" style="text-align:right; padding-right:10px;" 
		onClick="JavaScript:location='msgNovaMensagem.asp?var_params=<%=strCODIGO%>&var_action=RESPONDER&var_pasta_atual=CX_SAIDA'; document.title='Responder Mensagem'">
			<u style="cursor:pointer;">Responder</u>
		</td>
	</tr>
	<tr><td bgcolor="#333333" colspan="2" height="1"></td></tr>	
	  <td colspan="2" height="99%" valign="middle" align="left" style="vertical-align:middle; text-align:left;">
		<!--#include file="../_Include/_IncludeMsgAbre.asp"-->
	  </td>
	</tr>
	<tr><td bgcolor="#333333" colspan="2" height="1"></td></tr>	
</table>
</body>
</html>
<%
	FechaDBConn objConn
%>