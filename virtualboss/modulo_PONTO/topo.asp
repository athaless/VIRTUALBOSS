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
	if (form.value=='INSERIR') { parent.frames["vbMainFrame"].document.location.href = "ins_upd.asp"; }
	form.value='';
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b><a href="Help.htm" target="vbMainFrame" title="sobre este módulo...">[?]&nbsp;</a>Reg. Horas</b>
		<%=montaMenuCombo("form_acoes","selNome","width:100px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<select name="selNome" class="edtext_combo" style="width:100px" >
					 <!--option value="Todos" <%'if GetParam("selNome") = "Todos" then response.write("selected")%>>[usuários]</option-->
					 <%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL AND TIPO LIKE 'ENT_COLABORADOR' ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", strNome)%>
				</select>
				<select name="selEmp" class="edtext_combo" style="width: 145px">
					<option value="Todos" <%if GetParam("selEmp") = "Todos" then response.write("selected")%>>[empresas]</option>
					<%=montaCombo("STR", "SELECT SIGLA_PONTO, NOME_COMERCIAL FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL AND SIGLA_PONTO IS NOT NULL ORDER BY NOME_COMERCIAL", "SIGLA_PONTO", "NOME_COMERCIAL", "")%> 
					<option value="EXT">Extra/Outros</option>
				</select>						
				<select name="selMes" class="edtext_combo" style="width: 55px" >
					<option value="Todos" <% if strMes = "Todos" then response.write("selected")%>>[mês]</option>
					<option value="01" <% if strMes = "01" then response.write("selected")%>>Jan</option>
					<option value="02" <% if strMes = "02" then response.write("selected")%>>Fev</option>
					<option value="03" <% if strMes = "03" then response.write("selected")%>>Mar</option>
					<option value="04" <% if strMes = "04" then response.write("selected")%>>Abr</option>
					<option value="05" <% if strMes = "05" then response.write("selected")%>>Mai</option>
					<option value="06" <% if strMes = "06" then response.write("selected")%>>Jun</option>
					<option value="07" <% if strMes = "07" then response.write("selected")%>>Jul</option>
					<option value="08" <% if strMes = "08" then response.write("selected")%>>Ago</option>
					<option value="09" <% if strMes = "09" then response.write("selected")%>>Set</option>
					<option value="10" <% if strMes = "10" then response.write("selected")%>>Out</option>
					<option value="11" <% if strMes = "11" then response.write("selected")%>>Nov</option>
					<option value="12" <% if strMes = "12" then response.write("selected")%>>Dez</option>
				</select>
				<select name="selAno" class="edtext_combo" style="width: 55px" ><%=montaComboAno(-5)%></select>
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