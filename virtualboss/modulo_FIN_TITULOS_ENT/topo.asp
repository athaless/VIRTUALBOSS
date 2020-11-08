<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim objConn, objRS, strSQL
Dim strDT_INI, strDT_FIM
Dim strTIPO, strSITUACAO

AbreDBConn objConn, CFG_DB 

strDT_INI = DateSerial(Year(Date), Month(Date), 1)
strDT_FIM = DateAdd("D", -1, DateAdd("M", 1, strDT_INI))

strTIPO		= GetParam("var_pr")	
strSITUACAO	= GetParam("var_situacao")

'athDebug strSITUACAO, true

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">

var x=0;
function BuscaEntidade(valor) {
	x=x+1;
	if (valor!='')
		AbreJanelaPAGE (
			'BuscaPorEntidade.asp' 		+
			'?var_form=form_principal' 	+
			'&var_input=var_codigo' 	+ 
			'&var_input_tipo=var_tipo' +
			'&var_tipo=' + document.form_principal.var_entidade.value+
			'&var_vezes='+ x, 
			'640', 
			'390'
		);
	document.form_principal.var_tipo.value='';
	document.form_principal.var_codigo.value='';	
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="35" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<div style="padding-top:0px"><b>Títulos<br>(por Entidade)</b></div>
	</td>	
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;">
		<img src="../img/Menu_TopImgCenter.jpg">
	</td>
	<td width="85%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<select name="var_situacao" class="edtext_combo" size="1" style="width:80px;" title="Situação">
					<option value=""             <%if strSITUACAO=""             then Response.Write("selected")%>>[Situação] </option>				
					<option value="ABERTA"       <%if strSITUACAO="ABERTA"       then Response.Write("selected")%>>Aberta     </option>
					<option value="LCTO_PARCIAL" <%if strSITUACAO="LCTO_PARCIAL" then Response.Write("selected")%>>Parcial    </option>
					<option value="LCTO_TOTAL"   <%if strSITUACAO="LCTO_TOTAL"   then Response.Write("selected")%>>Quitada    </option>
					<option value="CANCELADA"    <%if strSITUACAO="CANCELADA"    then Response.Write("selected")%>>Cancelada  </option>											
					<option value="_ABERTA"      <%if strSITUACAO="_ABERTA"      then Response.Write("selected")%>>Não Aberta </option>											
					<option value="_LCTO_TOTAL"  <%if strSITUACAO="_LCTO_TOTAL"  then Response.Write("selected")%>>Não Quitada</option>																																	
				</select>
				<input name="var_codigo" id="var_codigo" type="hidden" value=""> 
				<input name="var_tipo" id="var_tipo" type="hidden" value=""> 				
				<select name="var_entidade"  class="edtext_combo" size="1" title="Entidade" onChange="JavaScript:BuscaEntidade(this.value);">
					<option value="" selected>[Entidade]</option>										
					<% MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", "" %>
				</select>
				<div class="form_label_nowidth">&nbsp;&nbsp;Histórico:</div><input name="var_historico" id="var_historico" type="text" style="width:200px;" class="edtext" maxlength="250" value=""> 

				<!-- Para diminuir ou eliminar a ocorrência de cache passamso um parâmetro DUMMY com um número diferente 
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