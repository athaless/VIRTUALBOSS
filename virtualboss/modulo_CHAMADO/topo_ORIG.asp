<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim objConn, strSQL, objRS
	
	AbreDBConn objConn, CFG_DB 
%>
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
	    <b>Chamado</b>
		<%=montaMenuCombo("form_acoes","selNome","width:100px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Cód.:</div><input name="var_cod_chamado" type="text" class="edtext" style="width:40px;" maxlength="10">
				<div class="form_label_nowidth">Título:</div><input name="var_titulo" type="text" class="edtext" style="width:100px;" maxlength="255">
				<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
					<div class="form_label_nowidth"></div>
					<select name="var_cliente" class="edtext_combo" style="width:140px;">
						<option value="">[cliente]</option>
						<%
						strSQL =          " SELECT DISTINCT T2.NOME_COMERCIAL AS CLIENTE "
						strSQL = strSQL & " FROM CH_CHAMADO T1, ENT_CLIENTE T2 "
						strSQL = strSQL & " WHERE T1.COD_CLI = T2.COD_CLIENTE "
						strSQL = strSQL & " ORDER BY T2.NOME_COMERCIAL "
						
						Set objRS = objConn.Execute(strSQL)
						
						Do While Not objRS.Eof
							If GetValue(objRS, "CLIENTE") <> "" Then Response.Write("<option value='" & UCase(GetValue(objRS, "CLIENTE")) & "'>" & GetValue(objRS, "CLIENTE") & "</option>")
							objRS.MoveNext
						Loop
						FechaRecordSet objRS
						%>
					</select>
				<% Else %>
					<select name="var_solicitante" class="edtext_combo" style="width:110px;">
						<option value="" selected>[solicitante]</option>
						<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE CODIGO = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO") & " AND TIPO = 'ENT_CLIENTE' ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", "") %>
					</select>
				<% End If %>
				<select name="var_situacao" class="edtext_combo" style="width:115px;">
					<option value="">[situação]</option>
					<option value="ABERTO">Aberto</option>
					<option value="EXECUTANDO">Executando</option>
					<option value="FECHADO">Fechado</option>
					<option value="_ABERTO">Não aberto</option>
					<option value="_EXECUTANDO">Não Executando</option>
					<option value="_FECHADO" selected>Não Fechado</option>
				</select>
				<select name="var_cod_categoria" class="edtext_combo" style="width:110px;">
					<option value="" selected>[categoria]</option>
					<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM CH_CATEGORIA ORDER BY NOME ", "COD_CATEGORIA", "NOME", "") %>
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