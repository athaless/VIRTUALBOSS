<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao()
{
	var form = document.form_acoes;
	if (form.selNome.value == 'INSERIR'){
		parent.frames["vbMainFrame"].document.location.href = "insert.asp";
	} else if (form.selNome.value == 'VISUALIZAR'){
		window.open("VisualizarMenu.asp","MENU_DET","width=300, height=600, left=30, top=30, scrollbars=1, status=0");
	}
	
	
	form.selNome.value = '';
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<b>Menu Principal</b>
		<%=montaMenuCombo("form_acoes","selNome","width:120px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR;VISUALIZAR:VISUALIZAR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">R�tulo:</div><input name="var_rotulo" type="text" size="20" class="edtext">			
                <select name="var_cod_menu_pai" class="edtext_combo">
                   <option value="" selected>[filhos de]</option>
				   <% montacombo "STR", " SELECT COD_MENU, ROTULO FROM SYS_MENU ORDER BY ROTULO ", "COD_MENU", "ROTULO", "" %>
                </select>						
				<select name="var_situacao" class="edtext_combo" style="width:70px">
					<!--option value="">[situa��o]</option-->
					<option value="ATIVO" selected>Ativo</option>
					<option value="INATIVO">Inativo</option>
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
