<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim objConn, objRS, strSQL  
Dim strNOME, strTABLE, strTYPE, strFORM
Dim strTIPO
Dim strFormName

AbreDBConn objConn, CFG_DB 

strNOME  = GetParam("var_nome")
strTIPO  = GetParam("var_tipo")
strFormName = Request("var_form")
if IsEmpty(strFormName) then strFormName= "form_insert"
if IsEmpty(strTIPO) then strTIPO="_FANTASIA"

strSQL = " SELECT COD_CLIENTE AS CODIGO, NOME" &  strTIPO & " AS NOME FROM ENT_CLIENTE"

if not IsEmpty(strNOME) then strSQL = strSQL & " WHERE NOME" &  strTIPO & " LIKE '" & strNOME & "%'"

strSQL = strSQL & " ORDER BY NOME_FANTASIA "
%>
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<style type="text/css">div{ padding-left:3px; padding-right:3px; }</style>
<script>
function retornaValor(pr_cod) {
	window.opener.document.<%=strFormName%>.var_cod_cliente.value = pr_cod;	
	window.close();
}
 </script>
</head>
<body bgcolor="#ffffff" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table align="center" cellpadding="0" cellspacing="0" width="100%" height="58">
	<tr>
		<td width="04%" background="../img/Menu_TopBGLeft.jpg"></td>
		<td width="01%"><img src="../img/Menu_TopImgCenter.jpg"></td>
		<td width="95%" background="../img/Menu_TopBgRight.jpg">
			<div style="padding-top:20px;padding-right:3px;"> 
				<table align="right" height="30px" cellpadding="0" cellspacing="0" border="0">
					<form name="FormBusca" method="post" action="BuscaPorEntidade.asp">
					<input name="var_form" type="hidden" size="20" class="edtext" value="<%=strFormName%>">
					<tr>
						<td width="50" style="text-align:right" nowrap>Nome</td>
						<td width="5"></td>
						<td width="100"><input name="var_nome" type="text" size="20" class="edtext" value="<%=strNOME%>"></td>
						<td width="5"></td>
						<td width="50">
							<select name="var_tipo" class="edtext_combo" style="width:120px">
								<option value="_FANTASIA"  <% if strTIPO = "_FANTASIA"  then Response.Write "selected"%>>Fantasia</option>
								<option value="_COMERCIAL" <% if strTIPO = "_COMERCIAL" then Response.Write "selected"%>>Comercial</option>
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
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1			
   if not objRS.Eof then
%>
<table cellpadding="0" cellspacing="1" width="99%" align="center">
	<tr><td height="2" colspan="2"></td></tr>
	<tr bgcolor="#CCCCCC" bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC"> 
		<td width="5%"  align="left" class="arial11Bold">Cod </div></td>
		<td width="95%" align="left" class="arial11Bold">Nome/N.Fantasia</div></td>
	</tr>
<%
      Dim strCOLOR 

      while not objRS.Eof
  	     strCOLOR   = "#DAEEFA"
%>
	<tr bgcolor=<%=strCOLOR%> style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="retornaValor('<%=GetValue(objRS,"CODIGO")%>');"> 
		<td align="left" valign="middle" nowrap><%=GetValue(objRS,"CODIGO")%>&nbsp;</div></td>
		<td align="left" valign="middle"><%=GetValue(objRS,"NOME")%>&nbsp;</div></td>
	</tr>
<%
        objRS.MoveNext
      wend
%>
	<tr><td bgcolor="#CCCCCC" colspan="2" align="center" height="1"></td></tr>
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