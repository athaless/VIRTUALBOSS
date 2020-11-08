<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim objConn, objRS, strSQL  
Dim strPALAVRA_CHAVE, strCor
Dim strFormName, strInput1, strInput2, strInput3

AbreDBConn objConn, CFG_DB 

strInput1	= GetParam("var_input1")
strInput2	= GetParam("var_input2")
strFormName	= GetParam("var_form")
strPALAVRA_CHAVE = GetParam("var_palavra_chave")

%>
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<script>
function Retorna(prEntidadeCod, prEntidadeNome, prTipoChamado) { 
	window.opener.document.<%=strFormName%>.<%=strInput1%>.value = prEntidadeCod;
	window.opener.document.<%=strFormName%>.<%=strInput2%>.value = prEntidadeNome;
	
	window.close();
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table align="center" cellpadding="0" cellspacing="0" width="100%" height="58">
	<tr>
		<td width="04%" background="../img/Menu_TopBGLeft.jpg"></td>
		<td width="01%"><img src="../img/Menu_TopImgCenter.jpg"></td>
		<td width="95%" background="../img/Menu_TopBgRight.jpg" align="right">
			<div style="padding-top:20px;padding-right:3px;"> 
				<table width="100%" height="30" cellpadding="0" cellspacing="3" border="0">
					<form name="FormBusca" method="post" action="BuscaPorEntidade.asp">
					<input name="var_form" 	 type="hidden" value="<%=strFormName%>"><%'Form que deve ser enviado o valor%>
					<input name="var_input1" type="hidden" value="<%=strInput1%>"><%'Nome do input que recebe o cod%>
					<input name="var_input2" type="hidden" value="<%=strInput2%>"><%'Nome do combo que recebe o nomer%>					
					<tr>
                    	 <td width="1%"  align="right" nowrap style="text-align:right">Nome&nbsp;</td>
                    	 <td width="98%"  align="right" nowrap><input name="var_palavra_chave" type="text" size="20" class="edtext" value="<%=strPALAVRA_CHAVE%>" style="width:100%; display:block;"></td>
                         <td width="1%" align="left"  nowrap><a href="javascript:document.FormBusca.submit();"><img src="../img/bt_search_mini.gif" title="Atualizar consulta..." border="0"></a></td>
					</tr>
					</form>
				</table>
			</div>
		</td>
	</tr>
</table>
<%
	strSQL =		  "SELECT COD_CLIENTE AS CODIGO, if(NOME_FANTASIA is not null, NOME_FANTASIA, RAZAO_SOCIAL) AS NOME, RAZAO_SOCIAL, TIPO_CHAMADO "
	strSQL = strSQL & "  FROM ENT_CLIENTE " 
	strSQL = strSQL & " WHERE (NOME_FANTASIA IS NOT NULL OR RAZAO_SOCIAL IS NOT NULL)" 
	strSQL = strSQL & "   AND DT_INATIVO IS NULL " 
	If strPALAVRA_CHAVE <> "" Then
		strSQL = strSQL & " AND ( NOME_FANTASIA  LIKE '" & strPALAVRA_CHAVE & "%' OR "
		strSQL = strSQL & "       RAZAO_SOCIAL   LIKE '" & strPALAVRA_CHAVE & "%' OR "
		strSQL = strSQL & "       NOME_COMERCIAL LIKE '" & strPALAVRA_CHAVE & "%' ) "
	End If 
	strSQL = strSQL & " ORDER BY 2 " 
	AbreDBConn objConn, CFG_DB
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
   if not objRS.Eof then
%>
<table cellpadding="0" cellspacing="2" width="99%" align="center">
	<tr><td height="2" colspan="3"></td></tr>
	<tr bgcolor="#CCCCCC" bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC" class="arial11Bold">  
		<td width="01%" height="20" ><div style="padding-left:3px; padding-right:3px;">Cod.</div></td>
		<td><div style="padding-left:3px; padding-right:3px;">Nome/N.Fantasia</div></td>
		<td><div style="padding-left:3px; padding-right:3px;">Razão Soc.</div></td>
	</tr>
<%
      while not objRS.Eof
  	    strCor = "#DAEEFA"
		%>
		<tr bgcolor="<%=strCor%>" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="Retorna('<%=GetValue(objRS,"CODIGO")%>','<%=GetValue(objRS,"NOME")%>','<%=GetValue(objRS,"TIPO_CHAMADO")%>');"> 
			<td valign="middle" height="20" nowrap><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"CODIGO")%>&nbsp;</div></td>
			<td valign="middle"><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"NOME")%>&nbsp;</div></td>
			<td valign="middle"><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"RAZAO_SOCIAL")%>&nbsp;</div></td>
		</tr>
		<%
        objRS.MoveNext
      wend
%>
	<tr><td bgcolor="#CCCCCC" colspan="11" align="center" height="1"></td></tr>
</table>
<%
		FechaRecordSet objRS
	else
		Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	end if
%>
</body>
</html>
<% FechaDBConn objConn %>