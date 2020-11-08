<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim strNome, strData, strStatus, staFirst
 
AbreDBConn objConn, CFG_DB          

staFirst  = false
strStatus = "REALIZADO"
strNome   = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {
	var form = eval("document." + pr_form + "." + pr_input);
	if (form.value=="INSERIR") { parent.frames["vbMainFrame"].document.location.href = "Insert.asp"; }
	else { parent.frames["vbMainFrame"].document.location.href = "InsertCopia.asp?var_tipo=" + form.value; }
	form.value='';
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr>
	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b>Agenda</b>
		<%=montaMenuCombo("form_acoes","selNome","width:120px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR;")%>
	</td> 
 	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Título:</div><input name="var_titulo" type="text" size="10" class="edtext">			
				<select name="var_situacao" class="edtext_combo" style="width:70px">
					<option value="">[situação]</option>
					<option value="ABERTO" selected>Aberto</option>
					<option value="FECHADO">Fechado</option>
				</select>
				<select name="var_categoria" class="edtext_combo" style="width:90px">
					<option value="" selected>[categoria]</option>
					<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM AG_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME ", "COD_CATEGORIA", "NOME", "")%> 
				</select> 
				<select name="var_mes" class="edtext_combo" style="width: 55px">
					<option value="">[mês]</option>
					<%=montaComboMes(month(date))%>
				</select>
				<select name="selAno" class="edtext_combo" style="width:55px;"><%=montaComboAno(7)%></select>
				<select name="var_executor" class="edtext_combo" style="width:70px;">
					<%
					  If ( (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER") or (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "ADMIN") or (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "SU") ) Then 
							Response.Write("<option value=''>[usuário]</option>")
							 montaCombo "STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO is NULL ORDER BY ID_USUARIO", "ID_USUARIO", "ID_USUARIO", LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
					  Else
							Response.Write("<option value='" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' selected >" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "</option>" )
					  End If 
					%>
				</select>
				<div class="form_label_nowidth">Resp.:</div><input name="var_checkresp"   type="checkbox" value="true" style="height:8px; width:8px;" checked="checked">
				<div class="form_label_nowidth">Exec:</div><input name="var_checkcitado" type="checkbox" value="true" style="height:8px; width:8px"  checked="checked">
				<!-- div class="form_label_nowidth"> 
				<table cellpadding="0" cellspacing="0" border="0" height="18">
					<tr> 
					  <td valign="top"><input name="var_checkresp" type="checkbox" value="true"  style="height:8px; width:8px;" checked></td>
					  <td class="arial10" valign="middle">&nbsp;Resp.</td>
					</tr>
					<tr> 
					  <td valign="top"><input name="var_checkcitado" type="checkbox" value="true" style="height:8px; width:8px" checked></td>
					  <td class="arial10" valign="middle">&nbsp;Citado</td>
					</tr>
				</table> 
				</div -->
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