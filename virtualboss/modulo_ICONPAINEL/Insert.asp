<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_ICONPAINEL", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
' -------------------------------------------------------------------------------
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
var id_antigo = "01";
function SinalizaIcone(pr_cod) {
	document.getElementById("img" + pr_cod).border = 1;
	document.getElementById("rd_img" + pr_cod).checked = true;
	document.getElementById("img" + id_antigo).border = 0;
	document.getElementById("rd_img" + id_antigo).checked = false;
	id_antigo = pr_cod;
}

function enableField()
{
 //alert(document.form_insert.DUMMYCheckA.checked);
 //alert(document.form_insert.DUMMYCheckB.checked);
 document.form_insert.DBVAR_STR_LINK_A.disabled = !document.form_insert.DUMMYCheckA.checked;
 document.form_insert.DBVAR_STR_LINK_B.disabled = !document.form_insert.DUMMYCheckB.checked;
}

//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.DBVAR_STR_ID_USUARIOô.value == '') var_msg += '\nUsuário';
	if (document.form_insert.DBVAR_STR_ROTULOô.value == '')     var_msg += '\nRótulo';
	if (document.form_insert.DBVAR_STR_IMGô.value == '')        var_msg += '\nImagem\Icone';
	if (document.form_insert.DBVAR_STR_DESCRICAOô.value == '')  var_msg += '\nDescricao';
	if (document.form_insert.DBVAR_NUM_ORDEMô.value == '')      var_msg += '\nOrdem';

	
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Painel de Controle/Atalhos - Inserção")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
<input type="hidden" name="DEFAULT_TABLE"    value="SYS_PAINEL">
<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
<input type="hidden" name="RECORD_KEY_NAME"  value="COD_PAINEL">
<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_ICONPAINEL/insert.asp'>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<%if UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))="MANAGER" or UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))="SU" then %>
	<tr>
		<td style="text-align:right;">*Usuário:&nbsp;</td>
		<td>
			<select name="DBVAR_STR_ID_USUARIOô"style="width:125px;">
				<option value="">[Selecione]</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL", "ID_USUARIO", "ID_USUARIO", "")%>
			</select>
		</td>
	</tr>
	<% else %>
		<input type="hidden" name="DBVAR_STR_ID_USUARIOô" value="<%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%>">
	<% end if %>
	<tr><td height="2px"></td></tr>					
	<tr> 
		<td style="text-align:right;" width="100px">*Rótulo:&nbsp;</td>
		<td><input name="DBVAR_STR_ROTULOô" maxlength="80" style="width:150px" type="text"></td>
	</tr>
	<tr><td height="2px"></td></tr>					 
	<tr> 
		<td style="text-align:right;" valign="top"><div style="padding-top:10px;">*Imagem:&nbsp;</div></td>
		<td>
			<div style="padding-top:10px; width:400px;">
			<%
				Dim i
				i="01"
				While LocalizaARQUIVO(FindUploadPath() & "\img\","ICO_VBOSS_"& i &".gif")
					%>
					<input name="DBVAR_STR_IMGô" id="rd_img<%=i%>" type="radio" value="<%="ICO_VBOSS_"& i &".gif"%>" onClick="SinalizaIcone('<%=i%>')" class="inputclean">
					<span style="height:47px; vertical-align:middle; width:37px;"><img id="img<%=i%>" border="0px" src="../img/<%="ICO_VBOSS_"& i &".gif"%>" onClick="SinalizaIcone('<%=i%>')"></span>
					<%
					if (i mod 6)=0 then Response.Write("<br>")
					i = ATHFormataTamLeft(Cint(i)+1,2,"0")
				Wend
			%>
			</div>
		</td>
	</tr>
	<tr><td height="2px"></td></tr>					 
	<tr> 
		<td style="text-align:right;">*Descrição:&nbsp;</td>
		<td><textarea name="DBVAR_STR_DESCRICAOô" rows="3" style="width:370px;"></textarea></td>
	</tr>
	<tr><td height="2px"></td></tr>					 
	<tr> 
		<td style="text-align:right;">*Aplicativo/Link:&nbsp;</td>
		<td>

			<table style="border: 1px solid #c9c9c9">
			  <tr><td>Escolha o aplicativo abaixo ou digite a url correspondente ao atalho.</td></tr>
			  <tr><td height="5"></td></tr>
			  <tr>
				<td><input type="radio" name="DUMMYCheck" id="DUMMYCheckA" checked="checked" onClick="enableField()" class="inputclean"> Aplicativo:
					<select name="DBVAR_STR_LINK" id="DBVAR_STR_LINK_A" style="width:125px;">
						<option value="" selected="selected">[selecione]</option>
						<optgroup label="Cadastros">
							<option value="../modulo_ACCOUNT/default.htm">Accounts</option>
							<option value="../modulo_COLABORADOR/default.htm">Colaboradores</option>
							<option value="../modulo_CLIENTE/default.htm">Clientes</option>
							<option value="../modulo_FORNECEDOR/default.htm">Fornecedores</option>
						</optgroup>
						<optgroup label="Configurações">
							<option value="../modulo_CATEGORIAS/default.htm">Categorias</option>
						</optgroup>
						<optgroup label="Financeiro">
							<option value="../modulo_FIN_PAINEL/default.htm">Painel Financeiro</option>
						</optgroup>
						<optgroup label="Gestão">
							<option value="../modulo_AGENDA/default.htm">Agenda</option>
							<option value="../modulo_CHAMADO/default.htm">Chamados</option>
							<option value="../modulo_INVENTARIO/default.htm">Inventário</option>
							<option value="../modulo_PROCESSO/default.htm">Processos</option>
						</optgroup>
						<optgroup label="Project Manager">
							<option value="../modulo_TODOLIST/default.htm">Tarefas</option>
							<option value="../modulo_BS/default.htm">Atividades/BS</option>
							<option value="../modulo_PROJETO/default.htm">Projetos</option>
						</optgroup>
						<optgroup label="Usuários">
							<option value="../modulo_PONTO/Default.htm">Controle de Horas</option>
							<option value="../modulo_USUARIO/default.htm">Usuários</option>
						</optgroup>
					</select>
				</td>
			  </tr>
			  <tr><td><input type="radio" name="DUMMYCheck" id="DUMMYCheckB" onClick="enableField()" class="inputclean"> Link/URL: &nbsp;<input name="DBVAR_STR_LINK" id="DBVAR_STR_LINK_B" class="edtext" maxlength="250" style="width:200px;" type="text"   disabled="disabled"></tr>
			</table>
		</td>
	</tr>
	<tr><td height="2px"></td></tr>					 
	<tr> 
		<td style="text-align:right;">Par&acirc;metro:&nbsp;</td>
		<td><input name="DBVAR_STR_LINK_PARAM" maxlength="50" style="width:150px;" type="text">
		&nbsp;Target:&nbsp;
			<select name="DBVAR_STR_TARGET" style="width:125px;">
				<option value="_self">_self</option>
				<option value="_parent">_parent</option>
				<option value="_top">_top</option>
				<option value="_blank">_blank</option>
				<option value="vbNucleo" selected="selected">vbNucleo</option>
				<option value="vbMainFrame">vbMainFrame</option>
				<option value="mainframe">mainframe</option>
			</select>
		
		</td>
	</tr>
	<tr><td height="2px"></td></tr>					 
	<tr> 
		<td style="text-align:right;">*Ordem:&nbsp;</td>
		<td><input name="DBVAR_NUM_ORDEMô" type="text" style="width:70px;" onKeyPress="validateNumKey();"></td>
	</tr>
	<tr><td height="2px"></td></tr>					
	<tr>
		<td style="text-align:right;">Status:&nbsp;</td>
		<td nowrap>
			<input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="NULL" checked>Ativo
			&nbsp;&nbsp; 
			<input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="<%=Date%>">Inativo
		</td>
	</tr>
	<tr><td></td><td class="texto_ajuda"><i><span style="font-size:8px; vertical-align:middle; width:10px;"></span></i></td>
	</tr>	 
</table>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</form>
</body>
</html>