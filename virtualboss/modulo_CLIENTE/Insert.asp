<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CLIENTE", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 
 Dim arrESTADOS, arrNOMES, Cont
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_insert.submit(); }
//****** Funções de ação dos botões - Fim ******
function CopiaDados(pr_form, pr_fieldbase)
{
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_ENDERECO.value = " + pr_form + ".DBVAR_STR_FATURA_ENDERECO.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_NUMERO.value = " + pr_form + ".DBVAR_STR_FATURA_NUMERO.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_COMPLEMENTO.value = " + pr_form + ".DBVAR_STR_FATURA_COMPLEMENTO.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_CEP.value = " + pr_form + ".DBVAR_STR_FATURA_CEP.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_BAIRRO.value = " + pr_form + ".DBVAR_STR_FATURA_BAIRRO.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_CIDADE.value = " + pr_form + ".DBVAR_STR_FATURA_CIDADE.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_ESTADO.options[" + pr_form + ".DBVAR_STR_FATURA_ESTADO.selectedIndex].selected = true;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_PAIS.value = " + pr_form + ".DBVAR_STR_FATURA_PAIS.value;");
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Cliente - Inserção")%>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE" value="ENT_CLIENTE">
	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME" value="COD_CLIENTE">
	<input type="hidden" name="DBVAR_DATE_DT_CADASTRO" value="<%=Date()%>">
	<input type="hidden" name="JSCRIPT_ACTION"   	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_CLIENTE/insert.asp'>
	<div class="form_label">Raz&atilde;o Social:</div><input name="DBVAR_STR_RAZAO_SOCIAL" type="text" style="width:300px">
	<br><div class="form_label">Nome Fantasia:</div><input name="DBVAR_STR_NOME_FANTASIA" type="text" style="width:300px">
	<br><div class="form_label">Nome Comercial:</div><input name="DBVAR_STR_NOME_COMERCIAL" type="text" style="width:300px">
	<br><div class="form_label">Sigla Ponto:</div><input name="DBVAR_STR_SIGLA_PONTO" type="text" maxlength="5" style="width:40px">
    <br><div class="form_label">N&uacute;m. Documento:</div><select name="DBVAR_STR_TIPO_DOC" style="width:80px">
													         <option value="F">CPF</option>
													         <option value="J">CNPJ</option>
														  </select><input name="DBVAR_STR_NUM_DOC" type="text" style="width:120px">
    <br><div class="form_label">Inscri&ccedil;&atilde;o Estuadual:</div><input name="DBVAR_STR_INSC_ESTADUAL" type="text" style="width:120px">
	<br><div class="form_label">Inscri&ccedil;&atilde;o Municipal:</div><input name="DBVAR_STR_INSC_MUNICIPAL" type="text" style="width:120px">
    <br><div class="form_label">Fone:</div><input name="DBVAR_STR_FONE_1" type="text" style="width:100px" maxlength="25">
    <br><div class="form_label">Fone Extra:</div><input name="DBVAR_STR_FONE_2" type="text" style="width:100px">
    <br><div class="form_label">Fax:</div><input name="DBVAR_STR_FAX" type="text" style="width:100px">
	<br><div class="form_label">E-mail:</div><input name="DBVAR_STR_EMAIL" type="text" style="width:300px">
    <br><div class="form_label">Dom&iacute;nio:</div><input name="DBVAR_STR_SITE" type="text" style="width:300px">
    <br><div class="form_label">Contato:</div><input name="DBVAR_STR_CONTATO" type="text" style="width:120px">
	<br><div class="form_label">Classe:</div><input name="DBVAR_STR_CLASSE" type="text" style="width:120px">
	<br><div class="form_label">Tipo de Chamado:</div><select name="DBVAR_STR_TIPO_CHAMADO" style="width:100px">
												         <option value="LIVRE" selected="selected">LIVRE</option>
												         <option value="BLOQUEADO">BLOQUEADO</option>
													  </select>
    <br><div class="texto_ajuda" style="padding-left:110px; padding-right:20px;">Indica se os chamados criados pelo cliente necessitam ou não de pré-aprovação para execução.</div>                                                      
	<br><div class="form_label">Observação:</div><textarea name="DBVAR_STR_OBS" rows="10" style="width:340px;"></textarea>
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" class="inputclean" type="radio" value="NULL" checked>Ativo&nbsp;&nbsp;<input name="DBVAR_DATE_DT_INATIVO" class="inputclean" type="radio" value="<%=Date()%>">Inativo
	
	<div class="form_grupo_collapse" id="form_grupo_4">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_4" border="0" onClick="ShowArea('form_grupo_4','form_collapse_4');" 
  		style="cursor:pointer;">
		<b>Alíquota IRPJ</b><br>
		<br><div class="form_label">IRPJ Específico:</div><input name="DBVAR_BOOL_TEM_ALIQ_IRPJ" class="inputclean" type="radio" value="TRUE">Sim&nbsp;&nbsp;<input name="DBVAR_BOOL_TEM_ALIQ_IRPJ" class="inputclean" type="radio" value="FALSE" checked>Não
		<br><div class="form_label">Alíquota:</div><input name="DBVAR_MOEDA_ALIQ_IRPJ" type="text" style="width:60px;" maxlength="15" onKeyPress="validateFloatKey();">
		<div style="padding-left:110px;"><span class="texto_ajuda"><i>Marque a opção e informe o percentual se cliente possui uma<br>alíquota específica de IRPJ.</i></span></div>
	</div>	
	
	<div class="form_grupo" id="form_grupo_33">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" style="cursor:pointer;">
		<b>Dados Bancários</b><br>
		<br><div class="form_label">Banco:</div><select name="DBVAR_NUM_COD_BANCO" style="width:120px">
													<% montaCombo "STR", "SELECT COD_BANCO, NOME FROM FIN_BANCO ORDER BY NOME ", "COD_BANCO", "NOME", "" %>
												</select>
		<br><div class="form_label">Agênca:</div><input name="DBVAR_STR_AGENCIA" type="text" style="width:70px" maxlength="50" value="">
		<br><div class="form_label">Conta:</div><input name="DBVAR_STR_CONTA" type="text" style="width:100px" maxlength="50" value="">
		<br><div class="form_label">Favorecido:</div><input name="DBVAR_STR_FAVORECIDO" type="text" style="width:300px" maxlength="120" value="">
	</div>

	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Endereço de Fatura</b>
		<br><br><div class="form_label">Endere&ccedil;o:</div><input name="DBVAR_STR_FATURA_ENDERECO" type="text" style="width:300px" maxlength="190">
		<br><div class="form_label">N&uacute;mero:</div><input name="DBVAR_STR_FATURA_NUMERO" type="text" style="width:50px" maxlength="20"><div class="form_label_nowidth">Complemento:</div><input name="DBVAR_STR_FATURA_COMPLEMENTO" type="text" style="width:50px" maxlength="40">
		<br><div class="form_label">CEP:</div><input name="DBVAR_STR_FATURA_CEP" type="text" style="width:90px">
		<br><div class="form_label">Bairro:</div><input name="DBVAR_STR_FATURA_BAIRRO" type="text" style="width:150px">
		<br><div class="form_label">Cidade:</div><input name="DBVAR_STR_FATURA_CIDADE" type="text" style="width:200px">
		<br><div class="form_label">Estado:</div><select name="DBVAR_STR_FATURA_ESTADO" style="width:200px">
										         	<option value="">Selecione...</option>
													<%
													arrESTADOS = array("AC","AL","AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
													arrNOMES = array("Acre","Alagoas","Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goias", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins")
													
													For Cont = 0 To UBound(arrESTADOS)
														Response.Write("<option value='" & arrESTADOS(Cont) & "'>" & UCase(arrNOMES(Cont)) & "</option>")
													Next
												    %>
											      </select>
		<br><div class="form_label">Pa&iacute;s:</div><input type="text" name="DBVAR_STR_FATURA_PAIS" style="width:150px">
	</div>	
	
	<div class="form_grupo_collapse" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Endereço de Cobrança</b>&nbsp;<a style="cursor:hand" onClick="CopiaDados('form_insert','COBR');">(Copiar Dados)</a>
		<br><br><div class="form_label">Endere&ccedil;o:</div><input name="DBVAR_STR_COBR_ENDERECO" type="text" style="width:300px">
		<br><div class="form_label">N&uacute;mero:</div><input name="DBVAR_STR_COBR_NUMERO" type="text" style="width:50px"><div class="form_label_nowidth">Complemento:</div><input name="DBVAR_STR_COBR_COMPLEMENTO" type="text" style="width:50px">
		<br><div class="form_label">CEP:</div><input name="DBVAR_STR_COBR_CEP" type="text" style="width:90px">
		<br><div class="form_label">Bairro:</div><input name="DBVAR_STR_COBR_BAIRRO" type="text" style="width:150px">
		<br><div class="form_label">Cidade:</div><input name="DBVAR_STR_COBR_CIDADE" type="text" style="width:200px">
		<br><div class="form_label">Estado:</div><select name="DBVAR_STR_COBR_ESTADO" style="width:200px">
													<option value="">Selecione...</option>
													<%
													arrESTADOS = array("AC","AL","AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
													arrNOMES = array("Acre","Alagoas","Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goias", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins")
													
													For Cont = 0 To UBound(arrESTADOS)
														Response.Write("<option value='" & arrESTADOS(Cont) & "'>" & UCase(arrNOMES(Cont)) & "</option>")
													Next
													%>
										        </select>
		<br><div class="form_label">Pa&iacute;s:</div><input type="text" name="DBVAR_STR_COBR_PAIS" style="width:150px">
	</div>
	
	<div class="form_grupo_collapse" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
  		style="cursor:pointer;">
		<b>Endereço de Entrega</b>&nbsp;<a style="cursor:hand" onClick="CopiaDados('form_insert','ENTR');">(Copiar Dados)</a>
		<br><br><div class="form_label">Endere&ccedil;o:</div><input name="DBVAR_STR_ENTR_ENDERECO" type="text" style="width:300px">
		<br><div class="form_label">N&uacute;mero:</div><input name="DBVAR_STR_ENTR_NUMERO" type="text" style="width:50px">
		<div class="form_label_nowidth">Complemento:</div><input name="DBVAR_STR_ENTR_COMPLEMENTO" type="text" style="width:50px"> 
      	<br><div class="form_label">CEP:</div><input name="DBVAR_STR_ENTR_CEP" type="text" style="width:90px">
		<br><div class="form_label">Bairro:</div><input name="DBVAR_STR_ENTR_BAIRRO" type="text" style="width:150px">
		<br><div class="form_label">Cidade:</div><input name="DBVAR_STR_ENTR_CIDADE" type="text" style="width:200px">
		<br><div class="form_label">Estado:</div><select name="DBVAR_STR_ENTR_ESTADO" style="width:200px">
													<option value="">Selecione...</option>
											        <%
													arrESTADOS = array("AC","AL","AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
													arrNOMES = array("Acre","Alagoas","Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goias", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins")
													
													For Cont = 0 To UBound(arrESTADOS)
														Response.Write("<option value='" & arrESTADOS(Cont) & "'>" & UCase(arrNOMES(Cont)) & "</option>")
													Next
												    %>	
											     </select>
		<br><div class="form_label">Pa&iacute;s:</div><input type="text" name="DBVAR_STR_ENTR_PAIS" style="width:150px">
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>