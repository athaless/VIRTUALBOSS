<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_PREV_ORCA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 520
WMD_WIDTHTTITLES = 100
' -------------------------------------------------------------------------------
Dim objConn, objRS, strSQL
Dim strCOD_PREV_ORCA
		
strCOD_PREV_ORCA = GetParam("var_chavereg")
	
if strCOD_PREV_ORCA <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL = "SELECT DESCRICAO, DT_PREV_INI, DT_PREV_FIM FROM FIN_PREV_ORCA WHERE COD_PREV_ORCA=" & strCOD_PREV_ORCA
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<% athBeginDialog WMD_WIDTH, "Previsão Orçamentária - Exclusão" %>
<%'-- --------------------------------------------------- --%>
<%'-- INIC: TABELA DE ITENS DO FORMULÁRIO --------------- --%>
<%'-- --------------------------------------------------- --%>
<table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
	<tr><td align="right">Cod:&nbsp;</td><td><%=strCOD_PREV_ORCA%></td></tr>
	<tr><td align="right">Data Início:&nbsp;</td><td><%=GetValue(objRS,"DT_PREV_INI")%></td></tr>
	<tr><td align="right">Data Fim:&nbsp;</td><td><%=GetValue(objRS,"DT_PREV_FIM")%></td></tr>
	<tr><td align="right">Observação:&nbsp;</td><td><%=GetValue(objRS,"DESCRICAO")%></td></tr>
</table><br>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td width="1%"><div  style="padding-left:20px"><img src="../img/Alert_Caution01.gif"></div></td>
		<td>
			<div style="padding-left:5px">
				 ATEN&Ccedil;&Atilde;O! 
				 Voc&ecirc; est&aacute; prestes a excluir o registro 
				 que est&aacute; sendo <br>
				 visualizado. Para confirmar a exclusão
				 clique no bot&atilde;o [ok], para <br>
				 desistir clique em [cancelar] 
			</div>
		</td>
	 </tr>
</table>
<%'-- -------------------------------------------------- --%>
<%'-- FIM: TABELA DE ITENS DO FORMULÁRIO --------------- --%>
<%'-- -------------------------------------------------- --%>
<% athEndDialog WMD_WIDTH, "../img/bt_ok.gif", "location.href='../modulo_FIN_PREV_ORCA/Delete_Exec.asp?var_chavereg="& strCOD_PREV_ORCA & "';", "../img/bt_cancelar.gif", "history.go(-1);", "", "" %>
</body>
</html>
<%
		end if 
    	FechaRecordSet objRS
   	FechaDBConn objConn
	end if 
%>