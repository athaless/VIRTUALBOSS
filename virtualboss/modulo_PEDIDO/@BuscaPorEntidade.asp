<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim objConn, objRS, strSQL  
Dim strPALAVRA_CHAVE, strCor
Dim strFormName, strInput1, strInput2, strInput3, strTIPO

strInput1 = GetParam("var_input1")
strInput2 = GetParam("var_input2")
strInput3 = GetParam("var_input3")
strFormName = GetParam("var_form")
strPALAVRA_CHAVE = GetParam("var_palavra_chave")
strTIPO = GetParam("var_tipo")

AbreDBConn objConn, CFG_DB 

If strTIPO = "" Then strTIPO = "ENT_CLIENTE"

%>
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<script>
function Retorna(prEntidadeCod, prEntidadeTipo, prEntidadeNome) { 
	window.opener.document.<%=strFormName%>.<%=strInput1%>.value = prEntidadeCod;
	window.opener.document.<%=strFormName%>.<%=strInput2%>.value = prEntidadeTipo;
	window.opener.document.<%=strFormName%>.<%=strInput3%>.value = prEntidadeNome;
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
				<table height="30" cellpadding="0" cellspacing="0" border="0">
					<form name="FormBusca" method="post" action="BuscaPorEntidade.asp">
					<input name="var_form" 	 type="hidden" value="<%=strFormName%>">
					<input name="var_input1" type="hidden" value="<%=strInput1%>">
					<input name="var_input2" type="hidden" value="<%=strInput2%>">
					<input name="var_input3" type="hidden" value="<%=strInput3%>">
					<tr>
						<td width="100" align="right" nowrap>Nome</td>
						<td width="5"></td><td width="100"><input name="var_palavra_chave" type="text" size="20" class="edtext" value="<%=strPALAVRA_CHAVE%>"></td><td width="5"></td>
						<td width="50">
							<select name="var_tipo" class="edtext" size="1">
								<%'=MontaCombo("STR","SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY ORDEM, DESCRICAO","TIPO","DESCRICAO",strTIPO)%>
								<option value="ENT_CLIENTE" selected="selected">Clientes</option>
							</select>
						</td>
						<td width="5"></td>
						<td width="27"><a href="javascript:document.FormBusca.submit();"><img src="../img/bt_search_mini.gif" title="Atualizar consulta..." border="0"></a></td>
					</tr>
					</form>
				</table>
			</div>
		</td>
	</tr>
</table>
<%
	If strTIPO = "ENT_CLIENTE" Then
		strSQL = " SELECT COD_CLIENTE AS CODIGO, NOME_FANTASIA AS NOME FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL " 
		If strPALAVRA_CHAVE <> "" Then
			strSQL = strSQL & " AND (NOME_FANTASIA LIKE '%" & strPALAVRA_CHAVE & "%' OR RAZAO_SOCIAL LIKE '%" & strPALAVRA_CHAVE & "%' OR NOME_COMERCIAL LIKE '%" & strPALAVRA_CHAVE & "%') "
		End If 
		strSQL = strSQL & " ORDER BY NOME_FANTASIA " 
	End If
	
	If strTIPO = "ENT_FORNECEDOR" Then
		strSQL = " SELECT COD_FORNECEDOR AS CODIGO, NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR WHERE DT_INATIVO IS NULL " 
		If strPALAVRA_CHAVE <> "" Then
			strSQL = strSQL & " AND (NOME_FANTASIA LIKE '%" & strPALAVRA_CHAVE & "%' OR RAZAO_SOCIAL LIKE '%" & strPALAVRA_CHAVE & "%' OR NOME_COMERCIAL LIKE '%" & strPALAVRA_CHAVE & "%') "
		End If 
		strSQL = strSQL & " ORDER BY NOME_FANTASIA " 
	End If
	
	If strTIPO = "ENT_COLABORADOR" Then
		strSQL = " SELECT COD_COLABORADOR AS CODIGO, NOME FROM ENT_COLABORADOR WHERE DT_INATIVO IS NULL " 
		If strPALAVRA_CHAVE <> "" Then
			strSQL = strSQL & " AND (NOME LIKE '%" & strPALAVRA_CHAVE & "%') "
		End If 
		strSQL = strSQL & " ORDER BY NOME " 
	End If
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
	
	if not objRS.Eof then
%>
<table cellpadding="0" cellspacing="1" width="99%" align="center">
	<tr><td height="2" colspan="3"></td></tr>
	<tr bgcolor="#CCCCCC" bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC" class="arial11Bold">
		<td width="01%"><div style="padding-left:3px; padding-right:3px;">Cod.</div></td>
		<td width="99%"><div style="padding-left:3px; padding-right:3px;">Nome</div></td>
	</tr>
<%
      while not objRS.Eof
  	     strCor = "#DAEEFA"
%>
	<tr bgcolor=<%=strCor%> style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="Retorna('<%=GetValue(objRS,"CODIGO")%>','<%=strTIPO%>','<%=GetValue(objRS,"NOME")%>');">
		<td valign="middle"nowrap><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"CODIGO")%>&nbsp;</div></td>
		<td valign="middle"><div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"NOME")%>&nbsp;</div></td>
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