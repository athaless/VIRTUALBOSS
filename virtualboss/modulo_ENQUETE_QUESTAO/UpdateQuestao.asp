<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO, strData, strRESP, arrESTADOS, arrNOMES, Cont
	
	strCODIGO = GetParam("var_chavereg")

	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSQL =          " SELECT COD_COLABORADOR, NOME, CPF, RG, FONE_1, FONE_2, CELULAR, EMAIL, EMAIL_EXTRA, FILIACAO_PAI, FILIACAO_MAE "
		strSQL = strSQL & "      , ENDERECO,NUMERO, COMPLEMENTO, CEP, BAIRRO, CIDADE, ESTADO, PAIS, DT_CADASTRO, DT_INATIVO "
		strSQL = strSQL & "      , ORGAO_EXPEDITOR, MSN_MESSENGER, FOTO, DT_NASC, FILIAL_VINCULADA, DT_CONTRATACAO "
		strSQL = strSQL & "      , DT_DESLIGAMENTO, SETOR, REMUNERACAO_MENSAL, REGIME, DT_ASSIN_CARTEIRA, UTILIZA_VT, VLR_VT_UNIT "
		strSQL = strSQL & "      , QTDE_VT_DIA, UTILIZA_VRVA,VLR_VRVA, AUXILIO_ESTUDO, COD_BANCO, AGENCIA, CONTA, FORMA_PGTO, FOTO "
		strSQL = strSQL & " FROM ENT_COLABORADOR "
		strSQL = strSQL & " WHERE COD_COLABORADOR = " & strCODIGO 
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Colaborador - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE" value="ENT_COLABORADOR">
	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME" value="COD_COLABORADOR">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_COLABORADOR/update.asp?var_chavereg=<%=strCODIGO%>">
    <div class="form_label">Cód.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Nome:</div><input name="DBVAR_STR_NOME" type="text" style="width:300px" value="<%=GetValue(objRS,"NOME")%>" maxlength="250">
	<br><div class="form_label">RG:</div><input name="DBVAR_STR_RG" type="text" style="width:100px" value="<%=GetValue(objRS,"RG")%>"><div class="form_bypass">Órgão Expeditor:</div><input name="DBVAR_STR_ORGAO_EXPEDITOR" type="text" style="width:60px" maxlength="10" value="<%=GetValue(objRS,"ORGAO_EXPEDITOR")%>">
	<br><div class="form_label">CPF:</div><input name="DBVAR_STR_CPF" type="text" style="width:100px" value="<%=GetValue(objRS,"CPF")%>">
	<br><div class="form_label">Fone:</div><input name="DBVAR_STR_FONE_1" type="text" style="width:100px" value="<%=GetValue(objRS,"FONE_1")%>">
	<br><div class="form_label">Fone Extra:</div><input name="DBVAR_STR_FONE_2" type="text" style="width:100px" value="<%=GetValue(objRS,"FONE_2")%>">
	<br><div class="form_label">Celular:</div><input name="DBVAR_STR_CELULAR" type="text" style="width:100px" value="<%=GetValue(objRS,"CELULAR")%>">
	<br><div class="form_label">E-mail:</div><input name="DBVAR_STR_EMAIL" type="text" style="width:200px" value="<%=GetValue(objRS,"EMAIL")%>">
	<br><div class="form_label">E-mail extra:</div><input name="DBVAR_STR_EMAIL_EXTRA" type="text" style="width:200px" value="<%=GetValue(objRS,"EMAIL_EXTRA")%>">
	<br><div class="form_label">MSN Messenger:</div><input name="DBVAR_STR_MSN_MESSENGER" type="text" style="width:200px" maxlength="250" value="<%=GetValue(objRS,"MSN_MESSENGER")%>">
	<br><div class="form_label">Foto:</div><input name="DBVAR_STR_FOTO" type="text" maxlength="250" value="<%=GetValue(objRS,"FOTO")%>" style="width:200px;"><a href="javascript:UploadArquivo('form_update','DBVAR_STR_FOTO', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">&nbsp;</div>
	<% If GetValue(objRS,"FOTO") <> "" Then %>
		<!-- div style='height:16px; position:relative; overflow:visible;text-align:right;padding-right:10px;' //-->
          <img src='../upload/<%=Request.Cookies("VBOSS")("CLINAME")%>/<%=GetValue(objRS,"FOTO")%>' width='160' />
        <!-- div //-->
	<% End If %>

	<br><div class="form_label">Data Nascimento:</div><%=InputDate("DBVAR_DATE_DT_NASC","",PrepData(GetValue(objRS,"DT_NASC"),True,False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_NASC", "ver calendário")%>
	<br><div class="form_label">Nome do Pai:</div><input name="DBVAR_STR_FILIACAO_PAI" type="text" style="width:300px" maxlength="250" value="<%=GetValue(objRS,"FILIACAO_PAI")%>">
	<br><div class="form_label">Nome da Mãe:</div><input name="DBVAR_STR_FILIACAO_MAE" type="text" style="width:300px" maxlength="250" value="<%=GetValue(objRS,"FILIACAO_MAE")%>">
	<br><div class="form_label">Status:</div><%
		If GetValue(objRS,"DT_INATIVO") = "" Then
			Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL' checked>Ativo")
			Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "'>Inativo")
		Else
			Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL'>Ativo")
			Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "' checked>Inativo")
		End If
	 %>
	
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Endereçamento</b>
		<br><br><div class="form_label">Endere&ccedil;o:</div><input name="DBVAR_STR_ENDERECO" type="text" style="width:300px" value="<%=GetValue(objRS,"ENDERECO")%>">
		<br><div class="form_label">N&uacute;mero:</div><input name="DBVAR_STR_NUMERO" type="text" style="width:50px" value="<%=GetValue(objRS,"NUMERO")%>">
		<br><div class="form_label">Complemento</div><input name="DBVAR_STR_COMPLEMENTO" type="text" style="width:50px" value="<%=GetValue(objRS,"COMPLEMENTO")%>">
		<br><div class="form_label">CEP:</div><input name="DBVAR_STR_CEP" type="text" style="width:90px" value="<%=GetValue(objRS,"CEP")%>">
		<br><div class="form_label">Bairro:</div><input name="DBVAR_STR_BAIRRO" type="text" style="width:150px" value="<%=GetValue(objRS,"BAIRRO")%>">
		<br><div class="form_label">Cidade:</div><input name="DBVAR_STR_CIDADE" type="text" style="width:200px" value="<%=GetValue(objRS,"CIDADE")%>">
		<br><div class="form_label">Estado:</div><select name="DBVAR_STR_ESTADO" style="width:200px">
										          <option value="">Selecione...</option>
          <%
			arrESTADOS = array("AC","AL","AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
			arrNOMES = array("Acre","Alagoas","Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goias", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins")
			
			For Cont = 0 To UBound(arrESTADOS)
				Response.Write("<option value='" & arrESTADOS(Cont) & "' ")
				if Cstr(arrESTADOS(Cont)) = Cstr(GetValue(objRS,"ESTADO")&"") then Response.Write(" selected")  
				Response.Write(">" & UCase(arrNOMES(Cont)) & "</option>")
			Next
			%>
        										</select>
		<br><div class="form_label">Pa&iacute;s:</div><input type="text" name="DBVAR_STR_PAIS" value="<%=GetValue(objRS,"PAIS")%>" style="width:150px">
	</div>
	
	<% If VerificaDireito("|DADOS_RH|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then %>
		<div class="form_grupo" id="form_grupo_2">
			<div class="form_label"></div>
			<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');"
			style="cursor:pointer;">
			<b>Contratação</b><br>
			<br><div class="form_label">Filial Vinculada:</div><select name="DBVAR_STR_FILIAL_VINCULADA" style="width:120px">
																<option value="PORTO ALEGRE" <% If GetValue(objRS,"FILIAL_VINCULADA") = "PORTO ALEGRE" Then Response.Write "selected" %>>Porto Alegre</option>
																<option value="SAO PAULO" <% If GetValue(objRS,"FILIAL_VINCULADA") = "SAO PAULO" Then Response.Write "selected" %>>São Paulo</option>
															</select>
			<br><div class="form_label">Data Contratação:</div><%=InputDate("DBVAR_DATE_DT_CONTRATACAO","",PrepData(GetValue(objRS,"DT_CONTRATACAO"),True,False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_CONTRATACAO", "ver calendário")%>
			<br><div class="form_label">Data Assin. Carteira:</div><%=InputDate("DBVAR_DATE_DT_ASSIN_CARTEIRA","",PrepData(GetValue(objRS,"DT_ASSIN_CARTEIRA"),True,False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_ASSIN_CARTEIRA", "ver calendário")%>
			<br><div class="form_label">Data Desligamento:</div><%=InputDate("DBVAR_DATE_DT_DESLIGAMENTO","",PrepData(GetValue(objRS,"DT_DESLIGAMENTO"),True,False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_DESLIGAMENTO", "ver calendário")%>
			<br><div class="form_label">Setor:</div><input name="DBVAR_STR_SETOR" type="text" style="width:200px" maxlength="250" value="<%=GetValue(objRS,"SETOR")%>">
			<br><div class="form_label">Remuneração Mensal:</div><input name="DBVAR_MOEDA_REMUNERACAO_MENSAL" type="text" maxlength="20" style="width:80px;" value="<%=FormataDecimal(GetValue(objRS,"REMUNERACAO_MENSAL"), 2)%>" onKeyPress="validateFloatKey();">
			<br><div class="form_label">Regime:</div><select name="DBVAR_STR_REGIME" style="width:100px">
														<option value="CLT" <% If GetValue(objRS,"REGIME") = "CLT" Then Response.Write "selected" %>>CLT</option>
														<option value="SOCIO" <% If GetValue(objRS,"REGIME") = "SOCIO" Then Response.Write "selected" %>>Sócio</option>
														<option value="TEMPORARIO" <% If GetValue(objRS,"REGIME") = "TEMPORARIO" Then Response.Write "selected" %>>Temporário</option>
														<option value="AUTÔNOMO" <% If GetValue(objRS,"REGIME") = "AUTÔNOMO" Then Response.Write "selected" %>>Autônomo</option> 
														<option value="PJ" <% If GetValue(objRS,"REGIME") = "PJ" Then Response.Write "selected" %>>PJ</option> 
													</select>
			<br><div class="form_label">Auxílio Estudo:</div><select name="DBVAR_STR_AUXILIO_ESTUDO" style="width:80px">
																<option value="">Não</option>
																<option value="10%"  <% If GetValue(objRS,"AUXILIO_ESTUDO") = "10%"   Then Response.Write "selected" %>>10%</option>
																<option value="20%"  <% If GetValue(objRS,"AUXILIO_ESTUDO") = "20%"   Then Response.Write "selected" %>>20%</option>
																<option value="30%"  <% If GetValue(objRS,"AUXILIO_ESTUDO") = "30%"   Then Response.Write "selected" %>>30%</option>
																<option value="40%"  <% If GetValue(objRS,"AUXILIO_ESTUDO") = "40%"   Then Response.Write "selected" %>>40%</option>
																<option value="50%"  <% If GetValue(objRS,"AUXILIO_ESTUDO") = "50%"   Then Response.Write "selected" %>>50%</option>
																<option value="100%" <% If GetValue(objRS,"AUXILIO_ESTUDO") = "100%"  Then Response.Write "selected" %>>Integral(100%)</option>
															</select>
			<br><div class="form_label">Forma de Pagamento:</div><select name="DBVAR_STR_FORMA_PGTO" style="width:80px">
																<option value="CHEQUE" <% If GetValue(objRS,"FORMA_PGTO") = "CHEQUE" Then Response.Write "selected" %>>Cheque</option>
																<option value="DEPOSITO" <% If GetValue(objRS,"FORMA_PGTO") = "DEPOSITO" Then Response.Write "selected" %>>Depósito</option>
															</select>
			<br><div class="form_label">Vale Transporte:</div><select name="DBVAR_STR_UTILIZA_VT" style="width:80px">
																		<option value="" <% If GetValue(objRS,"UTILIZA_VT") = "" Then Response.Write "selected" %>>Não</option>
																		<option value="VT" <% If GetValue(objRS,"UTILIZA_VT") = "VT" Then Response.Write "selected" %>>Sim</option>
																	</select>
			<br><div class="form_label">Valor Unitário:</div><input name="DBVAR_MOEDA_VLR_VT_UNIT" type="text" maxlength="20" style="width:80px;" value="<%=FormataDecimal(GetValue(objRS,"VLR_VT_UNIT"), 2)%>" onKeyPress="validateFloatKey();"><div class="form_bypass">Qtde por Dia:</div><input name="DBVAR_NUM_QTDE_VT_DIA" type="text" maxlength="10" style="width:40px;" value="<%=GetValue(objRS, "QTDE_VT_DIA")%>" onKeyPress="validateNumKey();">
			<br><div class="form_label">Vale Refeição/Alim.:</div><select name="DBVAR_STR_UTILIZA_VRVA" style="width:100px">
																<option value="" <% If GetValue(objRS,"UTILIZA_VRVA") = "" Then Response.Write "selected" %>>Não</option>
																<option value="VR" <% If GetValue(objRS,"UTILIZA_VRVA") = "VR" Then Response.Write "selected" %>>Vale Refeição</option>
																<option value="VA" <% If GetValue(objRS,"UTILIZA_VRVA") = "VA" Then Response.Write "selected" %>>Vale Alimentação</option>
															</select><div class="form_bypass">Valor:</div><input name="DBVAR_MOEDA_VLR_VRVA" type="text" maxlength="20" style="width:80px;" value="<%=FormataDecimal(GetValue(objRS,"VLR_VRVA"), 2)%>" onKeyPress="validateFloatKey();">
		</div>
		
		<div class="form_grupo" id="form_grupo_3">
			<div class="form_label"></div>
			<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
			style="cursor:pointer;">
			<b>Dados Bancários</b><br>
			<br><div class="form_label">Banco:</div><select name="DBVAR_NUM_COD_BANCO" style="width:120px">
														<% montaCombo "STR", "SELECT COD_BANCO, NOME FROM FIN_BANCO ORDER BY NOME ", "COD_BANCO", "NOME", GetValue(objRS,"COD_BANCO") %>
													</select>
			<br><div class="form_label">Agênca:</div><input name="DBVAR_STR_AGENCIA" type="text" style="width:70px" maxlength="50" value="<%=GetValue(objRS,"AGENCIA")%>">
			<br><div class="form_label">Conta:</div><input name="DBVAR_STR_CONTA" type="text" style="width:100px" maxlength="50" value="<%=GetValue(objRS,"CONTA")%>">
		</div>
	<% End If %>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If 
	    FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>