<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
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
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<b>ASP Component</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:120px","ExecAcao(this.form.name,this.name);","IMPRIMIR:IMPRIMIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
	      <form name="form_principal" method="post" action="main.asp" target="vbMainFrame">
	          <select name="var_status" class="edtext_combo" style="width:120px;">
	            <option value="1">[todos]</option>
	            <option value="2" selected>Instalados COMs</option>
	            <option value="3">N�o Instalados COMs</option>
	          </select>
	          <select name="var_categ" class="edtext_combo" style="width:150px;">>
	            <option value="all" selected>[categoria]</option>
	            <option value=0>Miscelanea</option>
	            <option value=1>Email</option>
	            <option value=2>Browser</option>
	            <option value=3>Upload</option>
	            <option value=4>Imagem</option>
	            <option value=5>Manipula��o de Arquivos</option>
	            <option value=6>Gr�ficos</option>
	            <option value=7>Gerenciamento de Usu�rios</option>
	            <option value=8>E-Commerce</option>
	            <option value=9>Formul�rios</option>
	            <option value=10>XML</option>
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
