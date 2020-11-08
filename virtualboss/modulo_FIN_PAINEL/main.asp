<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_PAINEL", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Dim strSQL, objConn, objRS
	Dim strBGCOLOR, strInativoCOLOR
	Dim strVLR_SALDO_GERAL, strVLR_SALDO, strENTIDADE, strICONE
	Dim objRS1, objRS2
	Dim strGRADE_CORLINHA1, strGRADE_CORLINHA2, strGRADE_CORHEADER2
	Dim acPAGAR, acRECEBER
	
	AbreDBConn objConn, CFG_DB 
	
	strGRADE_CORLINHA1 = "#F2F2F2"
	strGRADE_CORLINHA2 = "#FFFFFF"
	strGRADE_CORHEADER2 = "#999999"
%>	
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" cellpadding="4" cellspacing="0" border="0" bgcolor="#FFFFFF">
<tr>
	<td width="2%" height="100%" align="center" valign="top">
	<table width="100%" height="100%" cellpadding="4" cellspacing="0" border="0">
		<tr><td align="center" valign="top" height="1%"><!--#include file="../_include/_IncludeFinanceiro_Atalhos.asp"--></td></tr>
		<tr><td align="center" valign="top" height="99%"><!--include file="../_include/IncludeFinanceiroTarefas.asp"--></td></tr>
	</table>
	</td>
	<td width="96%" height="100%" align="center" valign="top">
	<table width="100%" height="100%" cellpadding="4" cellspacing="0" border="0">
		<tr><td align="center" valign="top" height="1%"><!--#include file="../_include/_IncludeFinanceiro_Saldos.asp"--></td></tr>
		<tr><td align="center" valign="top" height="1%"><!--#include file="../_include/_IncludeFinanceiro_PrevGraf.asp"--></td></tr>
		<tr><td align="center" valign="top" height="98%"><!--#include file="../_include/_IncludeFinanceiro_Previsao.asp"--></td></tr>
	</table>
	</td>
	<td width="2%" height="100%" align="center" valign="top">
	<table width="100%" height="100%" cellpadding="4" cellspacing="0" border="0">
		<tr><td align="center" valign="top" height="1%"><!--#include file="../_include/_IncludeFinanceiro_Resumo.asp"--></td></tr>
		<tr><td align="center" valign="top" height="1%"><!--#include file="../_include/_IncludeFinanceiro_MesAtual.asp"--></td></tr>
		<tr><td align="center" valign="top" height="98%"><!--#include file="../_include/_IncludeFinanceiro_Outros.asp"--></td></tr>
	</table>
	</td>
</tr>
</table>
</body>
</html>
<%
	FechaDBConn ObjConn
%>