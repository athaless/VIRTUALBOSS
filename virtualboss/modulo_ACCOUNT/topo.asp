<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
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
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b>Accounts...</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:100px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form method="get" name="form_principal" id="form_principal" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Grupo:</div><input name="var_grupo" type="text" size="20" class="edtext" style="width:60px;">
				<div class="form_label_nowidth">Fornec:</div><input name="var_fornec" type="text" size="20" class="edtext" style="width:80px;">
				<div class="form_label_nowidth">Account:</div><input name="var_titulo" type="text" size="20" class="edtext" style="width:80px;">
				<!-- select name="var_fornec"  class="edtext_combo" size="1" title="Fornecedor" style="width:130px;">
					<option value="" selected>[Fornecedor]</option>										
					<% 'MontaCombo "STR", "SELECT DISTINCT fornecedor, fornecedor FROM account_service ORDER BY fornecedor ", "fornecedor", "fornecedor", "fornecedor" %>
				</select //-->
				<select name="var_tipo" class="edtext_combo" style="width:60px">
					<option value="" selected>[tipo]</option>
					<optgroup label="DATABASE">
						<option value="mysql">mysql</option>
						<option value="odbc">odbc</option>
						<option value="postgre">postgre</option>
					</optgroup>
					<optgroup label="EMAIL">
						<option value="e-mail">e-mail</option>
						<option value="gmail">gmail</option>
					</optgroup>
					<optgroup label="PAINEL">
						<option value="painel">painel</option>
						<option value="plesk">plesk</option>
						<option value="helpdesk">helpdesk</option>
					</optgroup>
					<optgroup label="PROTOCOLO">
						<option value="ftp">ftp</option>
						<option value="vpn">vpn</option>
						<option value="ssl">ssl</option>
						<option value="ssH">ssH</option>
					</optgroup>
					<optgroup label="REMOTE">
						<option value="vnc">vnc</option>
	   					<option value="teamviewer">teamviewer</option>
						<option value="logmein">logmein</option>                    
						<option value="telnet">telnet</option>
					</optgroup>
					<optgroup label="R.SOCIAL">
                        <option value="facebook">facebook</option>
                        <option value="google+">google+</option>
                        <!-- option value="gazzag">gazzag</option //-->
						<!-- option value="icq">icq</option //-->
						<option value="msn">msn</option>
                        <option value="orkut">orkut</option>
                        <option value="skype">skype</option>
                        <option value="twitter">twitter</option>
					</optgroup>
					<optgroup label="REAL">
						<option value="bank">bank</option>
						<option value="card">card</option>
					</optgroup>

					<optgroup label="SISTEMA">
						<option value="athcsm4">athcsm4</option>
						<option value="datawide">datawide</option>
						<option value="tradeunion">tradeunion</option>
						<option value="vboss">vboss</option>
						<option value="pvista">pvista</option>
					</optgroup>

					<option value="outros">outros</option>
				</select>	
				<select name="var_situacao" class="edtext_combo" style="width:70px">
					<!--option value="">[situação]</option-->
					<option value="ATIVO" selected>Ativo</option>
					<option value="INATIVO">Inativo</option>
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
