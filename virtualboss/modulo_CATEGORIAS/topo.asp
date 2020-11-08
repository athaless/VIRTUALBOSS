<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
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
	    <b>Categorias</b>
		<%=montaMenuCombo("form_acoes","selNome","width:90px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR;")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<select name="var_tabela" class="edtext_combo" style="width:140px;">
					<option value="">[tabela]</option>
					<option value="AG_" selected>AGENDA</option>
					<option value="CH_">CHAMADOS</option>
					<option value="PT_FOLGA_">FOLGAS</option>
					<option value="PROCESSO_">PROCESSOS</option>
					<option value="ASLW_">RELATÓRIOS</option>
					<option value="SV_">SERVIÇOS</option>
					<optgroup label="Project Manager">
					<option value="TL_">TAREFAS</option>
					<option value="BS_">ATIVIDADES</option>
					<option value="PRJ_">PROJETOS</option>
					</optgroup>
					<optgroup label="Biblioteca">
					<option value="MB_LIVRO_">LIVROS</option>
					<option value="MB_REVISTA_">REVISTAS</option>
					<option value="MB_MANUAL_">MANUAIS</option>
					<option value="MB_VIDEO_">VÍDEOS</option>
					<option value="MB_DISCO_">DISCOS</option>
					<option value="MB_DADO_">DADOS</option>
					</optgroup>
				</select>
				<select name="var_letra" class="edtext_combo" style="width:60px">
					<option value="" selected>[letra]</option>
					<% 
						Dim i
						for i=65 to 90 'A..Z
							Response.Write("<option value='" & chr(i) & "'>" & chr(i) & "</option>")												
						next
					%>
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