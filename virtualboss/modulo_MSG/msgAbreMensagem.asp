<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Dim strSQL, strSQLAux, objConn, objRS, objRSAux, objRSPasta , auxStr
	Dim strCODIGO, strPASTA, strANEXOS
	
	strCODIGO = GetParam("var_chavereg")
	strPASTA = GetParam("var_pasta")
	
	AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../_Include/_IncludeMsgAbre.asp"-->
</body>
</html>
<%
	FechaDBConn objConn
%>