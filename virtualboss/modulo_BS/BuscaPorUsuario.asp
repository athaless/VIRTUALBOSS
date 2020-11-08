<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim objConn, objRS, strSQL  
Dim strNOME, strTIPO
Dim strFORM

AbreDBConn objConn, CFG_DB 

strNOME = GetParam("var_nome")
strTIPO = GetParam("var_tipo")
strFORM = GetParam("var_form")

if IsEmpty(strFORM) then strFORM = "form_insert"

strSQL = " SELECT COD_USUARIO AS CODIGO, ID_USUARIO, EMAIL, NOME FROM USUARIO WHERE DT_INATIVO IS NULL " 

if strTIPO<>"" then strSQL = strSQL & " AND TIPO LIKE '" & strTIPO & "'" 
if strNOME<>"" then strSQL = strSQL & " AND NOME LIKE '" & strNOME & "%'" 

strSQL = strSQL & " ORDER BY NOME "
%>
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<style type="text/css">div{ padding-left:3px; padding-right:3px; }</style>
<script>
function retornaValor(pr_cod) {
	window.opener.document.<%=strFORM%>.var_equipe.value = window.opener.document.<%=strFORM%>.var_equipe.value + ';' + pr_cod;	
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
			<div style="padding-top:20px; padding-right:3px;"> 
				<table align="right" height="30" cellpadding="0" cellspacing="0" border="0">
				<form name="FormBusca" method="post" action="BuscaPorUsuario.asp">
					<input type="hidden" name="var_form" value="<%=strFORM%>">
		  			<tr>
						<td width="100" style="text-align:right" nowrap>Nome</td>
					 	<td width="5"></td>
					 	<td width="100"><input name="var_nome" type="text" size="20" class="edtext" value="<%=strNOME%>"></td>
					 	<td width="5"></td>
					 	<td width="50">
							<select name="var_tipo" class="edtext_combo" style="width:120px">
								<option value="">[tipo]</option>
								<option value="ENT_COLABORADOR" <%if strTIPO = "ENT_COLABORADOR" then Response.Write "selected"%>>Colaborador</option>
								<option value="ENT_CLIENTE"     <%if strTIPO = "ENT_CLIENTE"     then Response.Write "selected"%>>Cliente</option>
							</select>			
						</td>
						<td width="5"></td>
						<td width="27">
							<a href="javascript:document.FormBusca.submit();">
								<img src="../img/bt_search_mini.gif" alt="Atualizar consulta..."  border="0">
							</a>
						</td>
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
	<tr><td height="2" colspan="4"></td></tr>
  	<tr bgcolor="#CCCCCC" bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC"> 
   		<td width="01%" align="left" class="arial11Bold">Cod </div></td>
		<td width="97%" align="left" class="arial11Bold">Nome</div></td>
    	<td width="01%" align="left" class="arial11Bold" nowrap>ID Usuário </div></td>
    	<td width="01%" align="left" class="arial11Bold">Email</div></td>
  	</tr>
	<%
		while not objRS.Eof
			%>
			<tr bgcolor="#DAEEFA" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="retornaValor('<%=GetValue(objRS,"ID_USUARIO")%>');"> 
				<td align="left" valign="middle" nowrap><%=GetValue(objRS,"CODIGO")%>&nbsp;</div></td>
				<td align="left" valign="middle"><%=GetValue(objRS,"NOME")%>&nbsp;</div></td>
				<td align="left" valign="middle" nowrap><%=GetValue(objRS,"ID_USUARIO")%>&nbsp;</div></td>
				<td align="left" valign="middle" nowrap><%=GetValue(objRS,"EMAIL")%>&nbsp;</div></td>
			</tr>
	  		<%
	    	objRS.MoveNext
		wend
	%>
	<tr><td bgcolor="#CCCCCC" colspan="4" align="center" height="1"></td></tr>
</table>
<%
	end if
	FechaRecordSet objRS
%>
</body>
</html>
<% FechaDBConn objConn %>