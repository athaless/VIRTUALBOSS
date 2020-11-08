<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim strNome, i
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
	else if (form.value=="PERIODICAS"){ parent.frames["vbMainFrame"].document.location.href = "insert_periodica.asp?var_tipo=" + form.value; }
		 else { parent.frames["vbMainFrame"].document.location.href = "TransfereTarefa.asp" }	
	form.value='';
}

</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr>
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<b>Tarefas</b>
		<%=montaMenuCombo("form_acoes", "var_nome", "width:120px", "ExecAcao(this.form.name,this.name);", "INSERIR:INSERIR;PERIODICAS:INSERIR PERIODICA;TRANFERIR:TRANSFERIR")%> 
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Cód.:</div><input name="var_cod_todo" type="text" class="edtext" style="width:40px;" maxlength="10">
				<div class="form_label_nowidth">Título/Cliente:</div><input name="var_titulo" type="text" class="edtext" style="width:65px;">			
				<select name="var_situacao" class="edtext_combo" style="width:115px;">
					<option value="">[situação]</option>
					<option value="ABERTO">Aberto</option>
					<option value="EXECUTANDO">Executando</option>
					<option value="CANCELADO">Cancelado</option>
					<option value="FECHADO">Fechado</option>
					<option value="OCULTO">Oculto</option>
					<option value="_ABERTO">Não aberto</option>
					<option value="_EXECUTANDO">Não Executando</option>
					<option value="_CANCELADO" selected>Não Cancelado</option>
					<option value="_FECHADO" selected>Não Fechado</option>
				</select>
				<select name="var_categoria" id="var_categoria" class="edtext_combo" style="width:80px;">
					<option value="">[categoria]</option>
					<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM tl_categoria WHERE DT_INATIVO IS NULL ORDER BY NOME", "COD_CATEGORIA", "NOME", "")%>
				</select>
				<select name="var_dia" class="edtext_combo" style="width:55px;">
					<option value="" selected>[dia]</option>
					<% for i=1 to 31 
						 Response.Write("<option value='" & ATHFormataTamLeft(i,2,"0") & "'>" & ATHFormataTamLeft(i,2,"0") & "</option>") 
					   next	%>
				</select>
				<select name="var_mes" class="edtext_combo" style="width:60px;" >
					<option value="" >[mes]</option>
					<%=montaComboMes("00")%>
				</select>
				<select name="selAno" class="edtext_combo" style="width:55px;">
				    <%=montaComboAno(10)%>
				</select>
				<select name="var_executor" class="edtext_combo" style="width:80px;">
					<option value="">[usuário]</option>
					<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY TIPO DESC, ID_USUARIO", "ID_USUARIO", "ID_USUARIO", strNome)%>
				</select>
				<div class="form_label_nowidth">Resp.:</div><input name="var_checkresp" type="checkbox" value="true" style="height:8px; width:8px;" checked="checked">
				<div class="form_label_nowidth">Exec:</div><input name="var_checkexec" type="checkbox" value="true" style="height:8px; width:8px" checked="checked">
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
<% FechaDBConn objConn %>