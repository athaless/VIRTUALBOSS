<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
  Dim objConn, objRS, strSQL
  Dim strNome, strData, staFirst
 
  AbreDBConn objConn, CFG_DB          
	
  staFirst  = false
  strNome   = Request.Cookies("VBOSS")("ID_USUARIO")
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
	    <b>Processos</b>
		<%=montaMenuCombo("form_acoes","selNome","width:120px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR;")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Texto:</div><input name="var_texto" type="text" size="10" class="edtext">			
				<select name="var_situacao" class="edtext_combo" style="width:100px">
					<option value="">[situação]</option>
					<option value="HOMOLOGADO">Homologado</option>
					<option value="NAO_HOMOLOGADO">Não Homologado</option>
				</select>
					<select name="var_categoria" class="edtext_combo" style="width:90px">
					<option value="" selected>[categoria]</option>
					<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM PROCESSO_CATEGORIA WHERE DT_INATIVO is NULL ORDER BY NOME ", "COD_CATEGORIA", "NOME", "")%> 
				</select> 
				<select name="var_autor" class="edtext_combo" style="width:80px" >
					<%
					response.write("<option value=''>[usuário]</option>")
					montaCombo "STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO is NULL ORDER BY ID_USUARIO", "ID_USUARIO", "ID_USUARIO", ""
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
<%
  FechaDBConn objConn 
%>