<!--#include file="../_database/athdbConn.asp"--> <%'-- ATEN��O: language, option explicit, etc... est�o no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim i
 
AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {
	var form = eval('document.' + pr_form + '.' + pr_input);
	if (form.value=='INSERIR') {  parent.frames["vbMainFrame"].document.location.href = "Insert.asp"; }
	form.value='';
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b><a href="Help.htm" target="vbMainFrame" title="sobre este m�dulo...">[?]&nbsp;</a>Hor�rio</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:100px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<select name="var_diasemana" class="edtext_combo" style="width:55px" >
					<option value="" selected>[dia]</option>
					<%	for i=1 to 7 %>
						<option value="<%=WeekDay(i,1)%>"><%=UCase(WeekDayName(i,1,1))%></option>													
					<%	next	%>											
				</select> 
				<select name="var_id_usuario" class="edtext_combo" style="width:120px" >
					<%
						if ((Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER") or (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "SU")) then 
							Response.Write("<option value=''>[usu�rio]</option>")
							montaCombo "STR"," SELECT ID_USUARIO FROM USUARIO WHERE TIPO LIKE '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "' AND GRP_USER <> 'SU' AND DT_INATIVO IS NULL ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")
						else
							Response.Write("<option value='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' selected >" & Request.Cookies("VBOSS")("ID_USUARIO") & "</option>" )
						end If 
					%>
				</select> 
				<!-- Para diminuir ou eliminar a ocorr�ncia de cahce passamso um par�metro DUMMY com um n�mero diferente 
				a cada execu��o. Isso for�a o navegador a interpretar como um request diferente a p�gina,m evitando cache - by Aless 06/10/10 -->
				<input type="hidden" id="rndrequest" name="rndrequest" value="">
				<div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); document.form_principal.submit();" class="btsearch"></div>
			</form>
	   </div>
	</td>
</tr>
</table>
</body>
</html>
<% FechaDBConn objConn %>