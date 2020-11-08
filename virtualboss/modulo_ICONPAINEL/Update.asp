<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_ICONPAINEL", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strCODIGO, strIMG_INDEX
Dim objConn, objRS, strSQL

AbreDBConn objConn, CFG_DB

strCODIGO = GetParam("var_chavereg")

strSQL = "SELECT ROTULO, DESCRICAO, IMG, LINK, LINK_PARAM, TARGET, ORDEM, DT_INATIVO, ID_USUARIO FROM SYS_PAINEL WHERE COD_PAINEL = " & strCODIGO
Set objRS = objConn.execute(strSQL)
strIMG_INDEX = Replace(Replace(GetValue(objRS,"IMG"),"ICO_VBOSS_",""),".gif","")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
var id_antigo = "<%=strIMG_INDEX%>";
function SinalizaIcone(pr_cod)
 {
  document.getElementById("img" + pr_cod).border = 1;
  document.getElementById("rd_img" + pr_cod).checked = true;
  document.getElementById("img" + id_antigo).border = 0;
  document.getElementById("rd_img" + id_antigo).checked = false;
  id_antigo = pr_cod;
 }
//****** Funções de ação dos botões - Início ******
function ok() { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Painel de Controle - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
<input type="hidden" name="DEFAULT_TABLE"    value="SYS_PAINEL">
<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
<input type="hidden" name="RECORD_KEY_NAME"  value="COD_PAINEL">
<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_ICONPAINEL/Update.asp?var_chavereg=<%=strCODIGO%>'>
<table width="100%" border="0px" cellpadding="1px" cellspacing="0px">
	<% if UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))="MANAGER" or UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))="SU" then %>
	<tr>
		<td style="text-align:right;">*Usuário:&nbsp;</td>
		<td>
			<select name="DBVAR_STR_ID_USUARIOô" style="width:125px;">
				<option value="">[Selecione]</option>
				<%=montaCombo("STR","SELECT Distinct(ID_USUARIO) FROM USUARIO WHERE DT_INATIVO is NULL", "ID_USUARIO", "ID_USUARIO", LCase(GetValue(objRS,"ID_USUARIO")))%>
			</select>
		</td>
	</tr>
	<% else %>
	  <input type="hidden" name="DBVAR_STR_ID_USUARIOô" value="<%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%>">
	<% end if %>
	<tr><td height="2px"></td></tr>	
	<tr> 
		<td width="100" style="text-align:right;">*Rotulo:&nbsp;</td>
		<td><input name="DBVAR_STR_ROTULOô" maxlength="255" style="width:150px;" type="text" value="<%=GetValue(objRS,"ROTULO")%>"></td>
	</tr>
	<tr><td height="2px"></td></tr>	 
	<tr> 
		<td style="text-align:right;" valign="top"><div style="padding-top:10px;">*Imagem:&nbsp;</div></td>
		<td> 
			<div style="padding-top:10px; width:320px;">
			<%
				Dim i
				i="01"
				While LocalizaARQUIVO(FindUploadPath() & "\img\","ICO_VBOSS_"& i &".gif")
			%>
					<input name="DBVAR_STR_IMGô" id="rd_img<%=i%>" type="radio" class="inputclean" value="<%="ICO_VBOSS_"& i &".gif"%>" onClick="SinalizaIcone('<%=i%>');"
					<%if GetValue(objRS,"IMG")="ICO_VBOSS_"& i &".gif" then%> checked <%end if%>>
					<span style="height:47px; vertical-align:middle; width:37px;"><img src="../img/<%="ICO_VBOSS_"& i &".gif"%>" id="img<%=i%>" <%if GetValue(objRS,"IMG")="ICO_VBOSS_"& i &".gif" then%> border="1"<%end if%> onClick="SinalizaIcone('<%=i%>')"></span>
			<%
					if (i mod 5)=0 then Response.Write("<br>")
					i = ATHFormataTamLeft(Cint(i)+1,2,"0")
				Wend
			%>
			</div>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;">Descrição:&nbsp;</td>
		<td><textarea name="DBVAR_STR_DESCRICAO" rows="6" style="width:300px;"><%=GetValue(objRS,"DESCRICAO")%></textarea></td>
	</tr>
	<tr><td height="2px"></td></tr>
	<tr> 
		<td style="text-align:right;">*Link:&nbsp;</td>
		<td>
		<input name="DBVAR_STR_LINK" maxlength="250" style="width:300px;" type="text" value="<%=GetValue(objRS,"LINK")%>">
		<!--
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
		-->
		</td>
	</tr>
	<tr><td height="2px"></td></tr>					 
	<tr> 
		<td style="text-align:right;">Par&acirc;metro:&nbsp;</td>
		<td><input name="DBVAR_STR_LINK_PARAM" type="text" style="width:150px;" maxlength="50" value="<%=GetValue(objRS,"LINK_PARAM")%>"></td>
	</tr>
	<tr><td height="2px"></td></tr>					 
	<tr> 
		<td style="text-align:right;">Target:&nbsp;</td>
		<td>
			<select name="DBVAR_STR_TARGET" style="width:125px;">
				<option value="_self" 	<%if GetValue(objRS,"TARGET") = "_self" then%> 	selected<%end if%>>_self</option>
				<option value="_parent" <%if GetValue(objRS,"TARGET") = "_parent" then%>selected<%end if%>>_parent</option>
				<option value="_top" 	<%if GetValue(objRS,"TARGET") = "_top" then%> 	selected<%end if%>>_top</option>
				<option value="_blank" 	<%if GetValue(objRS,"TARGET") = "_blank" then%> selected<%end if%>>_blank</option>
				<option value="vbNucleo" <%if GetValue(objRS,"TARGET")= "vbNucleo" then%> selected<%end if%>>vbNucleo</option>
				<option value="vbMainFrame"<%if GetValue(objRS,"TARGET")= "vbMainFrame" then%>selected<%end if%>>vbMainFrame</option>
				<option value="mainframe" 	<%if GetValue(objRS,"TARGET")= "mainframe" then%> 	selected<%end if%>>mainframe</option>
			</select>
		</td>
	</tr>
	<tr><td height="2px"></td></tr>					 
	<tr> 
		<td style="text-align:right;">*Ordem:&nbsp;</td>
		<td><input name="DBVAR_NUM_ORDEMô" style="width:70px;" type="text" value="<%=GetValue(objRS,"ORDEM")%>" onKeyPress="validateNumKey();"></td>
	</tr>
	<tr><td height="2px"></td></tr>				
	<tr> 
		<td style="text-align:right;">Status:&nbsp;</td>
		<td nowrap>
		<%
			If GetValue(objRS,"DT_INATIVO")="" Then
				Response.Write("<input name='DBVAR_DATE_DT_INATIVO' class='inputclean' type='radio' value='NULL' checked>Ativo")
				Response.Write("<input name='DBVAR_DATE_DT_INATIVO' class='inputclean' type='radio' value='"& Date &"'>Inativo")
			Else
				Response.Write("<input name='DBVAR_DATE_DT_INATIVO' class='inputclean' type='radio' value='NULL'>Ativo")
				Response.Write("<input name='DBVAR_DATE_DT_INATIVO' class='inputclean' type='radio' value='"& Date &"' checked>Inativo")
			End If
		%>
		</td>
	</tr>
	<tr><td></td><td class="texto_ajuda"><i>Campos com <span style="font-size:8px; vertical-align:midlde; width:10px;">*</span>são obrigatórios</i></td></tr>	 
</table>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</form>
</body>
</html>