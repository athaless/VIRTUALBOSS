<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Dim strDT_INI, strDT_FIM

strDT_INI = DateSerial(Year(Date), Month(Date), 1)
strDT_FIM = DateAdd("D", -1, DateAdd("M", 1, strDT_INI))

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input){
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
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<b>NF/Recibo</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:100px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">NF:</div><input type="text" name="var_num_nf" class="edtext" style="width:60px;" onKeyPress="validateNumKey();">			
				<select name="var_cod_cfg_nf" class="edtext_combo" style="width:140px;">
					<option value="" selected>[modelo]
					<%=MontaCombo("STR","SELECT COD_CFG_NF, DESCRICAO FROM CFG_NF WHERE DT_INATIVO IS NULL ORDER BY ORDEM, DESCRICAO ","COD_CFG_NF","DESCRICAO","")%>
				</select>
				<select name="var_cod_cli" class="edtext_combo" style="width:180px;">
					<option value="" selected>[cliente]
					<%=MontaCombo("STR","SELECT ENT_CLIENTE.COD_CLIENTE, ENT_CLIENTE.NOME_COMERCIAL FROM ENT_CLIENTE, NF_NOTA WHERE ENT_CLIENTE.COD_CLIENTE = NF_NOTA.COD_CLI AND NF_NOTA.SYS_DTT_INATIVO IS NULL GROUP BY ENT_CLIENTE.COD_CLIENTE, ENT_CLIENTE.NOME_COMERCIAL  ORDER BY ENT_CLIENTE.NOME_COMERCIAL","COD_CLIENTE","NOME_COMERCIAL","")%>
				</select>
				<div class="form_label_nowidth">Emiss&atilde;o:</div><%=InputDate("var_dt_ini","edtext",PrepData(strDT_INI,true,false),false)%>
				<div class="form_label_nowidth"> - </div><%=InputDate("var_dt_fim","edtext",PrepData(strDT_FIM,true,false),false)%>
				<select name="var_situacao" class="edtext_combo" style="width:80px;">
					<option value="">[situa&ccedil;&atilde;o]
					<option value="EM_EDICAO">Em Edição
					<option value="NAO_EMITIDA">Não Emitida
					<option value="EMITIDA">Emitida
					<option value="CANCELADA">Cancelada
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