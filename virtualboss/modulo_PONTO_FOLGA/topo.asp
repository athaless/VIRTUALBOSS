<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
  Dim objConn, objRS, strSQL
  Dim strNome, strData, strStatus, strMes, strAno, staFirst
 
  AbreDBConn objConn, CFG_DB          
	
  strMes = month(date)
  if len(strMes) = 1 then
	strMes = "0" & strMes
	staFirst = true
  end if
  staFirst  = false
  strStatus = "REALIZADO"
  strAno    = Year(Date)
  strNome   = Request.Cookies("VBOSS")("ID_USUARIO")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {
	var form = eval('document.' + pr_form + '.' + pr_input);
	if (form.value=='INSERIR') { parent.frames["vbMainFrame"].document.location.href = "Insert.asp"; }
	form.value='';
}
</script>
</head>
<body  onLoad="document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b><a href="Help.htm" target="vbMainFrame" title="sobre este módulo...">[?]&nbsp;</a>Folga</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:100px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
			<select name="var_cod_categoria" class="edtext_combo" style="width:180px" >
				<option value="">[categoria]</option>
				 <%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM PT_FOLGA_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME ", "COD_CATEGORIA", "NOME", "")%> 
			</select>
			<select name="var_id_usuario" class="edtext_combo" style="width:100px" >
					<%
						if ((Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER") or (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "SU")) then 
							Response.Write("<option value=''>[usuário]</option>")
							montaCombo "STR"," SELECT ID_USUARIO FROM USUARIO WHERE TIPO LIKE '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "' AND GRP_USER <> 'SU' AND DT_INATIVO IS NULL ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")
						else
							Response.Write("<option value='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' selected >" & Request.Cookies("VBOSS")("ID_USUARIO") & "</option>" )
						end If 
					%>
			</select>
			<input type="hidden" name="var_mes" value="Todos">
			<!--
			<td width="5">&nbsp;</td>
			<td height="20" bgcolor="#FFFFFF" align="center" valign="middle">
			  <select name="selMes" class="edtext" style="width: 55px" >
				<option value="Todos" <% 'if strMes = "Todos" then response.write("selected")%>>[mês]</option>
				<option value="01" <% 'if strMes = "01" then response.write("selected")%>>Jan</option>
				<option value="02" <% 'if strMes = "02" then response.write("selected")%>>Fev</option>
				<option value="03" <% 'if strMes = "03" then response.write("selected")%>>Mar</option>
				<option value="04" <% 'if strMes = "04" then response.write("selected")%>>Abr</option>
				<option value="05" <% 'if strMes = "05" then response.write("selected")%>>Mai</option>
				<option value="06" <% 'if strMes = "06" then response.write("selected")%>>Jun</option>
				<option value="07" <% 'if strMes = "07" then response.write("selected")%>>Jul</option>
				<option value="08" <% 'if strMes = "08" then response.write("selected")%>>Ago</option>
				<option value="09" <% 'if strMes = "09" then response.write("selected")%>>Set</option>
				<option value="10" <% 'if strMes = "10" then response.write("selected")%>>Out</option>
				<option value="11" <% 'if strMes = "11" then response.write("selected")%>>Nov</option>
				<option value="12" <% 'if strMes = "12" then response.write("selected")%>>Dez</option>
			  </select>	
			  -->
			  <select name="var_ano" class="edtext_combo" style="width: 55px" >
			    <%=montaComboAno(6)%>
			  </select>					
			  <!-- Para diminuir ou eliminar a ocorrência de cahce passamso um parâmetro DUMMY com um número diferente 
			  a cada execução. Isso força o navegador a interpretar como um request diferente a página,m evitando cache - by Aless 06/10/10 -->
			  <input type="hidden" id="rndrequest" name="rndrequest" value="">
			  <div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); document.form_principal.submit();" class="btsearch"></div>
			</form>
	   </div>
	</td>
</tr>
</table>
</body>
</html>
<%
  FechaDBConn objConn 
%>