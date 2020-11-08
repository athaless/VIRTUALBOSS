<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Dim objConn, objRS, strSQL  
	Dim strNOME, strTIPO

	AbreDBConn objConn, CFG_DB 

 	strNOME  = GetParam("var_nome")
 	strTIPO  = GetParam("var_tipo")
 
 	strSql =          " SELECT COD_USUARIO AS CODIGO, ID_USUARIO, EMAIL, NOME"
 	strSql = strSql & " FROM USUARIO WHERE DT_INATIVO IS NULL " 
 
 	if strTIPO <> "" then strSql = strSql & " AND TIPO LIKE '" & strTIPO & "'" 
 	if strNOME <> "" then strSql = strSql & " AND NOME LIKE '" & strNOME & "%'" 
 
 	strSql = strSql & " ORDER BY NOME "
%>
<html>
<head>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<script>
function retornaValor(pr_cod) {
	if (window.opener.document.formeditor.var_destinatarios.value !='') {
		window.opener.document.formeditor.var_destinatarios.value = window.opener.document.formeditor.var_destinatarios.value + ';' + pr_cod;	
	}
	else {	
		window.opener.document.formeditor.var_destinatarios.value = pr_cod;
	}
	window.close();
}
</script>
</head>
<body bgcolor="#ffffff" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr>
	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
	<div class="form_line">
		<form name="form_principal" method="post" action="BuscaPorUsuario.asp">
			<div class="form_label_nowidth">Nome:</div><input name="var_nome" type="text" class="edtext" style="width:100px;" value="<%=strNOME%>">
			<select name="var_tipo" class="edtext_combo" size="1" style="width:120px">
				<option value="">[tipo]</option>
				<option value="ENT_COLABORADOR" <%if strTIPO="ENT_COLABORADOR" then response.write "selected"%>>Colaborador</option>
				<option value="ENT_CLIENTE"     <%if strTIPO="ENT_CLIENTE"     then response.write "selected"%>>Cliente</option>
			</select>
			<div onClick="document.form_principal.submit();" class="btsearch"></div>
		</form>
	</div>
	</td>
</tr>
</table>
<%
   Set objRS = objConn.Execute(strSql) 
   if not objRS.EOF then
%>
<table cellpadding="0" cellspacing="1" width="99%" align="center" border="0">
	<tr><td height="2" colspan="4"></td></tr>
  	<tr bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC"> 
   	<td width="1%"  bgcolor="#CCCCCC" align="left" class="arial11Bold">
			<div style="padding-left:3px; padding-right:3px;">Cod </div>
		</td>
		<td width="97%" bgcolor="#CCCCCC" align="left" class="arial11Bold">
			<div style="padding-left:3px; padding-right:3px;">Nome</div>
		</td>
    	<td width="1%"  bgcolor="#CCCCCC" align="left" class="arial11Bold" nowrap>
			<div style="padding-left:3px; padding-right:3px;">ID Usuário </div>
		</td>
    	<td width="1%"  bgcolor="#CCCCCC" align="left" class="arial11Bold">
			<div style="padding-left:3px; padding-right:3px;">Email</div>
		</td>
  	</tr>
	<%
      while not objRS.Eof
  	%>
  	<tr bgcolor="#DAEEFA" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="retornaValor('<%=GetValue(objRS,"ID_USUARIO")%>');"> 
    	<td align="left" valign="middle" nowrap>
			<div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"CODIGO")%>&nbsp;</div>
		</td>
    	<td align="left" valign="middle">
			<div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"NOME")%>&nbsp;</div>
		</td>
    	<td align="left" valign="middle" nowrap>
			<div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"ID_USUARIO")%>&nbsp;</div>
		</td>
    	<td align="left" valign="middle" nowrap>
			<div style="padding-left:3px; padding-right:3px;"><%=GetValue(objRS,"EMAIL")%>&nbsp;</div>
		</td>
  	</tr>
  	<%
        objRS.MoveNext
      wend
  	%>
	<tr><td bgcolor="#CCCCCC" colspan="4" align="center" height="1"></td></tr>
</table>
<%
    	FechaRecordSet objRS
 	end if
%>
</body>
</html>
<%
	FechaDBConn objConn
%>