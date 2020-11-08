<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
  Dim objConn, objRS, strSQL
 
  AbreDBConn objConn, CFG_DB          
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {
	var form = eval("document." + pr_form + "." + pr_input);
	if (form.value == "IMPRIMIR")   { 
		parent.frames["vbMainFrame"].focus();
		parent.frames["vbMainFrame"].print();
	}
	form.value='';
}

</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">

<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b>Respostas</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:120px","ExecAcao(this.form.name,this.name);","IMPRIMIR:IMPRIMIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Tarefa:</div><input name="var_tarefa" type="text" style="width:120px;" maxlength="250" class="edtext">
				<div class="form_label_nowidth">Resposta:</div><input name="var_resposta" type="text" style="width:120px;" maxlength="250" class="edtext">
				<div class="form_label_nowidth">de:</div><input name="var_id_from" type="text" style="width:50px;" maxlength="250" class="edtext">
				<div class="form_label_nowidth">para:</div><input name="var_id_to" type="text" style="width:50px;" maxlength="250" class="edtext">
				<select name="var_mes" class="edtext_combo" style="width:60px;">
					<option value="">[mês]</option>
					<%=montaComboMes(Month(date()))%>
				</select>
				<select name="var_ano" class="edtext_combo" style="width:55px;">
					<option value="">[ano]</option>
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