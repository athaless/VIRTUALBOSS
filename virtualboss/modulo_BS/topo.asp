<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim strVAR_CODIGO, strVAR_TIPO
Dim strNome
AbreDBConn objConn, CFG_DB          

strNome = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
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
	else { parent.frames["vbMainFrame"].document.location.href = "InsertModelo.asp"; }
	form.value='';
}
/*<%
'function TrocaLargura(prWidth, prObjName, prFormName){
'//alert(prWidth);
'	if (prWidth<93)
'		eval("document." + prFormName + "." + prObjName).style.width = 40;
'	else
'		eval("document." + prFormName + "." + prObjName).style.width = 93;
}%>*/
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr>
	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b>Atividades/BS</b>
		<%=montaMenuCombo("form_acoes","selNome","width:90px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR;_MODELO:INS DO MODELO;")%>
	</td> 
 	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Boletim:</div><input name="var_cod_boletim" type="text" class="edtext" style="width:30px;">		
				<div class="form_label_nowidth">Título/Cliente:</div><input name="var_titulo" type="text" class="edtext" style="width:65px;">		
				<select name="var_situacao" class="edtext_combo" style="width:90px;">
					<option value="">[situacao]</option>
					<option value="ABERTO">Aberto</option>
					<option value="CANCELADO">Cancelado</option>
					<option value="EXECUTANDO">Executando</option>
					<option value="FECHADO">Fechado</option>
					<option value="_ABERTO">Não Aberto</option>
					<option value="_EXECUTANDO">Não Executando</option>
					<option value="_FECHADO" selected>Não Fechado</option>
				</select>
				<select name="var_tipo" class="edtext_combo" style="width:70px;">
					<option value="NORMAL" selected>Normais</option>
					<option value="MODELO">Modelos</option>
					<option value="TODOS">[todos]</option>
				</select> 
				<select name="var_cod_categoria" class="edtext_combo" style="width:75px;">
					<option value="">[categoria]</option>
					<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM BS_CATEGORIA ORDER BY NOME ", "COD_CATEGORIA", "NOME", "")%>
				</select>
				<select name="var_executor" class="edtext_combo" style="width:50px;">
				<%
					if ((Request.Cookies("VBOSS")("GRUPO_USUARIO")="MANAGER") or (Request.Cookies("VBOSS")("GRUPO_USUARIO")="ADMIN") or (Request.Cookies("VBOSS")("GRUPO_USUARIO")="SU")) then
						Response.Write("<option value=''>[usuario]")
						montaCombo "STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY TIPO DESC, ID_USUARIO", "ID_USUARIO", "ID_USUARIO", strNome
					else
						Response.Write("<option value='" & strNome & "' selected >" & strNome)
					end If 
				%>
				</select> 
				<div class="form_label_nowidth">Resp.:</div><input name="var_checkresp"   type="checkbox" value="true" style="height:8px; width:8px;" alt="Responsável" title="Responsável" checked>
				<div class="form_label_nowidth">Equipe:</div><input name="var_checkeqp" type="checkbox" value="true" style="height:8px; width:8px"   alt="Exeecutor" title="Exeecutor" checked>
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