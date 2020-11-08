<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
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
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Colaborador - Inserção")%>     
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="ENT_COLABORADOR">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_COLABORADOR">
	<input type="hidden" name="DBVAR_AUTODATE_DT_CADASTRO" value="">
	<input type="hidden" name="JSCRIPT_ACTION"   	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_COLABORADOR/insert.asp'>
    <div class="form_label">Nome:</div><input name="DBVAR_STR_NOME" type="text" style="width:300px" value="" maxlength="250">
    <br><div class="form_label">RG:</div><input name="DBVAR_STR_RG" type="text" style="width:110px" value=""><div class="form_bypass">Órgão Expeditor:</div><input name="DBVAR_STR_ORGAO_EXPEDITOR" type="text" style="width:60px" maxlength="10" value="">
    <br><div class="form_label">CPF:</div><input name="DBVAR_STR_CPF" type="text" style="width:110px" value="">
	<br><div class="form_label">Fone:</div><input name="DBVAR_STR_FONE_1" type="text" style="width:100px" value="">
	<br><div class="form_label">Fone Extra:</div><input name="DBVAR_STR_FONE_2" type="text" style="width:100px" value="">
	<br><div class="form_label">Celular:</div><input name="DBVAR_STR_CELULAR" type="text" style="width:100px" value="">
	<br><div class="form_label">E-mail:</div><input name="DBVAR_STR_EMAIL" type="text" style="width:200px" value="">
	<br><div class="form_label">E-mail extra:</div><input name="DBVAR_STR_EMAIL_EXTRA" type="text" style="width:200px" value="">
	<br><div class="form_label">MSN/FBOOK::</div><input name="DBVAR_STR_MSN_MESSENGER" type="text" style="width:200px" maxlength="250" value="">
	<br><div class="form_label">Foto:</div><input name="DBVAR_STR_FOTO" type="text" maxlength="250" value="" style="width:200px;"><a href="javascript:UploadArquivo('form_insert','DBVAR_STR_FOTO', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">Data Nascimento:</div><%=InputDate("DBVAR_DATE_DT_NASC","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_NASC", "ver calendário")%>
	<br><div class="form_label">Nome do Pai:</div><input name="DBVAR_STR_FILIACAO_PAI" type="text" style="width:300px" maxlength="250" value="">
	<br><div class="form_label">Nome da Mãe:</div><input name="DBVAR_STR_FILIACAO_MAE" type="text" style="width:300px" maxlength="250" value="">
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="NULL" checked>Ativo&nbsp;&nbsp; <input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="<%=Date()%>">Inativo
    
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Endereçamento</b><br>
		<br><div class="form_label">Endere&ccedil;o:</div><input name="DBVAR_STR_ENDERECO" type="text" style="width:300px" value="">
		<br><div class="form_label">N&uacute;mero:</div><input name="DBVAR_STR_NUMERO" type="text" style="width:50px" value=""><div class="form_bypass">Complemento</div><input name="DBVAR_STR_COMPLEMENTO" type="text" style="width:50px" value="">
		<br><div class="form_label">CEP:</div><input name="DBVAR_STR_CEP" type="text" style="width:90px" value="">
    	<br><div class="form_label">Bairro:</div><input name="DBVAR_STR_BAIRRO" type="text" style="width:150px" value="">
		<br><div class="form_label">Cidade:</div><input name="DBVAR_STR_CIDADE" type="text" style="width:200px" value="">
		<br><div class="form_label">Estado:</div><select name="DBVAR_STR_ESTADO" style="width:200px">
											          <option value="">Selecione...</option>
          <%
			arrESTADOS = array("AC","AL","AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
			arrNOMES = array("Acre","Alagoas","Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goias", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins")
			
			For Cont = 0 To UBound(arrESTADOS)
				Response.Write("<option value='" & arrESTADOS(Cont) & "' >" & UCase(arrNOMES(Cont)) & "</option>")
			Next
		  %>
												 </select>
		<br><div class="form_label">Pa&iacute;s:</div><input type="text" name="DBVAR_STR_PAIS" value="" style="width:150px">
	</div>
	
	<% If VerificaDireito("|DADOS_RH|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then %>
		<div class="form_grupo" id="form_grupo_2">
			<div class="form_label"></div>
			<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');"
			style="cursor:pointer;">
			<b>Contratação</b><br>
			<br><div class="form_label">Filial Vinculada:</div><select name="DBVAR_STR_FILIAL_VINCULADA" style="width:120px">
																<option value="PORTO ALEGRE">Porto Alegre</option>
																<option value="SAO PAULO">São Paulo</option>
															</select>
			<br><div class="form_label">Data Contratação:</div><%=InputDate("DBVAR_DATE_DT_CONTRATACAO","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_CONTRATACAO", "ver calendário")%>
			<br><div class="form_label">Data Assin. Carteira:</div><%=InputDate("DBVAR_DATE_DT_ASSIN_CARTEIRA","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_ASSIN_CARTEIRA", "ver calendário")%>
			<br><div class="form_label">Data Desligamento:</div><%=InputDate("DBVAR_DATE_DT_DESLIGAMENTO","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_DT_DESLIGAMENTO", "ver calendário")%>
			<br><div class="form_label">Setor:</div><input name="DBVAR_STR_SETOR" type="text" style="width:200px" maxlength="250" value="">
			<br><div class="form_label">Remuneração Mensal:</div><input name="DBVAR_MOEDA_REMUNERACAO_MENSAL" type="text" maxlength="20" style="width:80px;" value="" onKeyPress="validateFloatKey();">
			<br><div class="form_label">Regime:</div><select name="DBVAR_STR_REGIME" style="width:100px">
														<option value="CLT">CLT</option>
														<option value="SOCIO">Sócio</option>
														<option value="TEMPORARIO">Temporário</option>
														<option value="AUTÔNOMO">Autônomo</option> 
														<option value="PJ">PJ</option> 
													</select>
			<br><div class="form_label">Auxílio Estudo:</div><select name="DBVAR_STR_AUXILIO_ESTUDO" style="width:80px">
																<option value="">Não</option>
																<option value="10%">10%</option>
																<option value="20%">10%</option>
																<option value="30%">30%</option>
																<option value="40%">40%</option>
																<option value="50%">50%</option>
																<option value="100%">Integral(100%)</option>
															</select>
			<br><div class="form_label">Forma de Pagamento:</div><select name="DBVAR_STR_FORMA_PGTO" style="width:80px">
																<option value="CHEQUE">Cheque</option>
																<option value="DEPOSITO">Depósito</option>
															</select>
			<br><div class="form_label">Vale Transporte:</div><select name="DBVAR_STR_UTILIZA_VT" style="width:80px">
																		<option value="">Não</option>
																		<option value="VT">Sim</option>
																	</select>
			<br><div class="form_label">Valor Unitário:</div><input name="DBVAR_MOEDA_VLR_VT_UNIT" type="text" maxlength="20" style="width:80px;" value="" onKeyPress="validateFloatKey();"><div class="form_bypass">Qtde por Dia:</div><input name="DBVAR_NUM_QTDE_VT_DIA" type="text" maxlength="10" style="width:80px;" value="" onKeyPress="validateNumKey();">
			<br><div class="form_label">Vale Refeição/Alim.:</div><select name="DBVAR_STR_UTILIZA_VRVA" style="width:100px">
																<option value="">Não</option>
																<option value="VR">Vale Refeição</option>
																<option value="VA">Vale Alimentação</option>
															</select><div class="form_bypass">Valor:</div><input name="DBVAR_MOEDA_VLR_VRVA" type="text" maxlength="20" style="width:80px;" value="" onKeyPress="validateFloatKey();">
		</div>
		
		<div class="form_grupo" id="form_grupo_3">
			<div class="form_label"></div>
			<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
			style="cursor:pointer;">
			<b>Dados Bancários</b><br>
			<br><div class="form_label">Banco:</div><select name="DBVAR_NUM_COD_BANCO" style="width:120px">
														<% montaCombo "STR", "SELECT COD_BANCO, NOME FROM FIN_BANCO ORDER BY NOME ", "COD_BANCO", "NOME", "" %>
													</select>
			<br><div class="form_label">Agênca:</div><input name="DBVAR_STR_AGENCIA" type="text" style="width:70px" maxlength="50" value="">
			<br><div class="form_label">Conta:</div><input name="DBVAR_STR_CONTA" type="text" style="width:100px" maxlength="50" value="">
		</div>
	<% End If %>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>