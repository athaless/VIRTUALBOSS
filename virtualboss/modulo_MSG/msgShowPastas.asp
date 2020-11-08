<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<!--#include file="ConfigMSG.asp"--> 
<%
	Dim objRS, objConn, strSQL
	Dim strLIDAS_CxEntrada, strLIDAS_CxSaida, strLIDAS_CxExcluidos, strLIDAS

	AbreDBConn objConn, CFG_DB

	Function RetornarNaoLidas(strPASTA)
		strSQL = 			" SELECT COUNT(COD_MSG_PASTA) AS LIDAS FROM MSG_PASTA "
		strSQL =	strSQL &	" WHERE DT_LIDO IS NULL AND PASTA = '" & strPASTA & "'"
		strSQL =	strSQL &	"   AND COD_USER LIKE '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " 
				 
		Set objRS = objConn.execute(strSQL)
		
		RetornarNaoLidas = "" 
		if CInt(objRS("LIDAS")) > 0 then RetornarNaoLidas = " (" & objRS("LIDAS") & ")" 
		
		FechaRecordSet(objRS)
	End Function 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
function visualizarMSG(pr_pasta, pr_rotulo) {
	//Atualiza parte que exibe as mensagens da pasta
	parent.msg_top_right.location.href="msgShowMensagens.asp?var_pasta=" + pr_pasta;
	parent.InfoPasta_ROTULO.value = pr_rotulo;
	parent.InfoPasta_VALOR.value = pr_pasta;
 
	//Atualiza parte que exibe conteúdo da mensagem
	parent.msg_bottom_right.location.href="msgAbreMensagem.asp";
}
</script>
</head>
<body>
<table border="0" width="100%" cellpadding="0" cellspacing="2">
<%
	strLIDAS_CxEntrada   = RetornarNaoLidas(CX_ENTRADA_Value) 
	strLIDAS_CxSaida     = RetornarNaoLidas(CX_SAIDA_Value) 
	strLIDAS_CxExcluidos = RetornarNaoLidas(CX_EXCLUIDOS_Value) 
%>
	<tr valign="top" onClick="visualizarMSG('<%=CX_ENTRADA_Value%>', '<%=CX_ENTRADA_Caption%>')" style="cursor:hand"> 
   	<td width="1%"><div style="padding-left:7px;padding-right:12px;"><img src="../img/msg_ico_cxentrada.gif"></div></td>
    	<td width="99%"><b><%=CX_ENTRADA_Caption%> <%=strLIDAS_CxEntrada%></b></td>
  	</tr>
  	<tr valign="top" onClick="visualizarMSG('<%=CX_SAIDA_Value%>', '<%=CX_SAIDA_Caption%>')" style="cursor:hand"> 
    	<td width="1%"><div style="padding-left:7px;padding-right:12px;"><img src="../img/msg_ico_cxsaida.gif"></div></td>
    	<td width="99%"><b><%=CX_SAIDA_Caption%> <%=strLIDAS_CxSaida%></b></td>
  	</tr>
  	<tr valign="top" onClick="visualizarMSG('<%=CX_EXCLUIDOS_Value%>', '<%=CX_EXCLUIDOS_Caption%>')" style="cursor:hand"> 
    	<td width="1%"><div style="padding-left:7px;padding-right:12px;"><img src="../img/msg_ico_itensdel.gif"></div></td>
		<td width="99%"><b><%=CX_EXCLUIDOS_Caption%> <%=strLIDAS_CxExcluidos%></b></td>
  	</tr>
<% 
	strSQL = " SELECT PASTA FROM MSG_PASTA " &_ 
	         " WHERE COD_USER LIKE '" & Request.Cookies("INETECPP")("COD_USER") & "'" &_ 
			 	" AND PASTA NOT LIKE '" & CX_ENTRADA_Value & "' " 	&_
			 	" AND PASTA NOT LIKE '" & CX_SAIDA_Value & "' " 	&_
			 	" AND PASTA NOT LIKE '" & CX_EXCLUIDOS_Value & "' "
	Set objRS = objConn.execute(strSQL)
	while not objRS.EOF
 		strLIDAS = RetornarLidas(objRS("PASTA"))
%>
  	<tr valign="top" onClick="visualizarMSG('<%=objRS("PASTA")%>')" style="cursor:hand"> 
   	<td width="1%"><div style="padding-left:7px;padding-right:12px;"><img src="../img/msg_ico_pasta.gif"></div></td>
		<td width="99%"><b><%=objRS("PASTA")%> <%=strLIDAS%></b></td>
  	</tr>
<%
	   objRS.MoveNext 
	wend
	FechaRecordSet(objRS)
%>
</table>
</body>
</html>
<%	FechaDBConn objConn %>