<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_NF_CFG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim objConn, objRS, strSQL
 Dim strCODIGO
 AbreDBConn objConn, CFG_DB 

 strCODIGO = GetParam("var_chavereg")

 if strCODIGO<>"" then 
	strSQL =          " SELECT T1.COD_CFG_NF, T1.SERIE, T1.TIPO, T1.ULT_NUM_NF " ', T1.ULT_NUM_FORM
	strSQL = strSQL & "	     , T1.MODELO_HTML, T1.NUM_LINHAS, T1.TAM_LINHA, T1.DESCRICAO "
	strSQL = strSQL & "      , T1.ALIQ_ISSQN, ALIQ_IRRF, T1.ALIQ_IRPJ, T1.ALIQ_COFINS, T1.ALIQ_PIS, T1.ALIQ_CSOCIAL "
	strSQL = strSQL & "      , T1.VLR_LIM_IRRF, T1.VLR_LIM_REDUCAO, T1.ORDEM, T1.DT_INATIVO "
	strSQL = strSQL & "	     , T1.COD_FORNEC, T2.NOME_FANTASIA AS FORNECEDOR_NOME "
	strSQL = strSQL & "	FROM CFG_NF T1 "
	strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T2 ON (T1.COD_FORNEC = T2.COD_FORNECEDOR) "
	strSQL = strSQL & " WHERE T1.COD_CFG_NF = " & strCODIGO
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
	function BuscaEntidade() {
		if ((document.form_update.DBVAR_NUM_COD_FORNECô.value != '') && (document.form_update.var_nome.value == ''))
			AbreJanelaPAGE('BuscaEntidadeUm.asp?var_chavereg=' + document.form_update.DBVAR_NUM_COD_FORNECô.value + '&var_form=form_update&var_input1=DBVAR_NUM_COD_FORNECô&var_input2=var_nome','300','200');
		else
			AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update&var_input1=DBVAR_NUM_COD_FORNECô&var_input2=var_nome','640','390');
	}
	function LimparNome() {
		document.form_update.var_nome.value = '';
	}
	
	//****** Funções de ação dos botões - Início ******
	function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
	function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
	function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
	function submeterForm() {
		var var_msg = '';
		
		if (document.form_update.DBVAR_STR_SERIEô.value == '')        var_msg += '\nSérie';
		if (document.form_update.DBVAR_STR_DESCRICAOô.value == '')    var_msg += '\nDescrição';
		if (document.form_update.DBVAR_STR_MODELO_HTMLô.value == '')  var_msg += '\nModelo';
		if (document.form_update.DBVAR_NUM_ULT_NUM_NFô.value == '')   var_msg += '\nNúmero da NF';
		//if (document.form_update.DBVAR_NUM_ULT_NUM_FORMô.value == '') var_msg += '\nNúmero do Formulário';
		if (document.form_update.DBVAR_NUM_NUM_LINHASô.value == '')   var_msg += '\nNumero de linhas';
		if (document.form_update.DBVAR_NUM_TAM_LINHAô.value == '')    var_msg += '\nTamanho da linha';
		if (document.form_update.DBVAR_NUM_COD_FORNECô.value == '')   var_msg += '\nCod Fornecedor';	
		
		if (var_msg == ''){
			document.form_update.submit();
		} else{
			alert('Favor verificar campos obrigatórios:\n' + var_msg);
		}
	}
	//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Nota Fiscal - Altera&ccedil;&atilde;o")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="CFG_NF">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CFG_NF">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_FIN_NF_CFG/Update.asp?var_chavereg=<%=strCODIGO%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=GetValue(objRS,"COD_CFG_NF")%></div>
	<br><div class="form_label">*S&eacute;rie:</div><input name="DBVAR_STR_SERIEô" type="text" maxlength="10" style="width:70px;" value="<%=GetValue(objRS,"SERIE")%>">
	<br><div class="form_label">*Descrição:</div><textarea name="DBVAR_STR_DESCRICAOô" rows="4" style="width:300px;"><%=GetValue(objRS,"DESCRICAO")%></textarea>
	<br><div class="form_label">Ordem:</div><input name="DBVAR_NUM_ORDEM" type="text" style="width:40px;" value="<%=GetValue(objRS,"ORDEM")%>" onKeyPress="validateNumKey();">
	<br><div class="form_label">*Modelo:</div><input name="DBVAR_STR_MODELO_HTMLô" type="text" style="width:280px;" value="<%=GetValue(objRS,"MODELO_HTML")%>">
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="NULL" <%if GetValue(objRS,"DT_INATIVO")="" then Response.Write("checked") %>>Ativo
	&nbsp;&nbsp;<div class="form_label_nowidth"><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="<%=PrepData(Date,true,false)%>" <%if IsDate(GetValue(objRS,"DT_INATIVO")) and GetValue(objRS,"DT_INATIVO")<>"" then Response.Write("checked") %>>Inativo</div>
	
	<!-- GRUPO CARACTERÍSTICAS. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo_collapse" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Características</b>
		<br><br><div class="form_label">Tipo:</div><input type="radio" class='inputclean' name="DBVAR_STR_TIPO" id="var_tipo_padrao" value="PADRAO" 
												   <% If GetValue(objRS,"TIPO") = "PADRAO" Then Response.Write("checked") %>>Padrão
			<br><div class="form_ajuda">
				Tipo simples onde uma <u>única nota fiscal</u> é impressa em um <u>único formulário</u>. 
			  	A quantidade total de itens da nota &eacute; determinada pelo número de linhas do formulário 
				e pelo tamanho das descrições dos itens.
			</div>
			<br><div class="form_label"></div><input type="radio" class='inputclean' name="DBVAR_STR_TIPO" id="var_tipo_extendido" value="EXTENDIDO" 
												   <% If GetValue(objRS,"TIPO") = "EXTENDIDO" Then Response.Write("checked") %>>Extendido
			<br><div class="form_ajuda">
			  	Tipo mais versátil onde uma <u>única nota fiscal</u> pode ser impressa em <u>vários formulários</u>. 
				Não existe limite para a quantidade total de itens.
			</div>
	</div>
	<!-- GRUPO CARACTERÍSTICAS. FIM -->
	
	<!-- GRUPO NÚMEROS. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Números</b>
		<br><br><div class="form_label">*Nota:</div><input name="DBVAR_NUM_ULT_NUM_NFô" type="text" style="width:70px;" 
													 value="<%=GetValue(objRS,"ULT_NUM_NF")%>" onKeyPress="validateNumKey();">
											        <span class="texto_ajuda">&Uacute;ltimo número de Nota impresso</span>
		<!--<br><div class="form_label">*Formulário:</div><input name="DBVAR_NUM_ULT_NUM_FORMô" type="text" style="width:70px;" 
													 value="<%'=GetValue(objRS,"ULT_NUM_FORM")%>" onKeyPress="validateNumKey();">
													<span class="texto_ajuda">&Uacute;ltimo número de Formulário utilizado</span>-->
	</div>
	<!-- GRUPO NÚMEROS. FIM -->	
	
	<!-- GRUPO LINHAS. EXEMPLO DE USO DO FORM_COLLAPSE -->	
	<div class="form_grupo" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
  		style="cursor:pointer;">
		<b>Linhas</b>
		<br><br><div class="form_label">*Número:</div><input name="DBVAR_NUM_NUM_LINHASô" type="text" style="width:40px;" 
													  value="<%=GetValue(objRS,"NUM_LINHAS")%>">
													  <span class="texto_ajuda">Total de linhas do formulário para os itens</span>
		<br><div class="form_label">*Tamanho:</div><input name="DBVAR_NUM_TAM_LINHAô" type="text" style="width:40px;" 
													  value="<%=GetValue(objRS,"TAM_LINHA")%>">
													  <span class="texto_ajuda">Total de caracteres de cada linha</span>
	</div>
	<!-- GRUPO LINHAS. FIM -->	
	
	<!-- GRUPO ALÍQUOTAS. EXEMPLO DE USO DO FORM_COLLAPSE -->		
	<div class="form_grupo" id="form_grupo_4">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_4" border="0" onClick="ShowArea('form_grupo_4','form_collapse_4');" 
  		style="cursor:pointer;">
		<b>Alíquotas</b>
		<br><br><div class="form_label">IRRF:</div><input name="DBVAR_MOEDA_ALIQ_IRRF" type="text" maxlength="5" style="width:40px;" 
													onKeyPress="validateFloatKey();" value="<%=FormataDecimal(GetValue(objRS,"ALIQ_IRRF"),2)%>">%
												 <div class="form_label" style="width:65px;">IRPJ:</div><input name="DBVAR_MOEDA_ALIQ_IRPJ" 
																				type="text" maxlength="5" style="width:40px;" 
																				onKeyPress="validateFloatKey();" 
																				value="<%=FormataDecimal(GetValue(objRS,"ALIQ_IRPJ"),2)%>">%
		<br><div class="form_label">ISSQN:</div><input name="DBVAR_MOEDA_ALIQ_ISSQN" type="text" maxlength="5" style="width:40px;" 
												 onKeyPress="validateFloatKey();" value="<%=FormataDecimal(GetValue(objRS,"ALIQ_ISSQN"),2)%>">%
												 <div class="form_label" style="width:65px;">PIS:</div><input name="DBVAR_MOEDA_ALIQ_PIS" 
												 								type="text" maxlength="5" style="width:40px;" 
																				onKeyPress="validateFloatKey();"  
																				value="<%=FormataDecimal(GetValue(objRS,"ALIQ_PIS"),2)%>">%
		<br><div class="form_label">COFINS:</div><input name="DBVAR_MOEDA_ALIQ_COFINS" type="text" maxlength="5" style="width:40px;" 
												  onKeyPress="validateFloatKey();" value="<%=FormataDecimal(GetValue(objRS,"ALIQ_COFINS"),2)%>">%
												 <div class="form_label" style="width:65px;">Contr. Social:</div><input 
												 								name="DBVAR_MOEDA_ALIQ_CSOCIAL" type="text" maxlength="5"
																				style="width:40px;" onKeyPress="validateFloatKey();" 
																				value="<%=FormataDecimal(GetValue(objRS,"ALIQ_CSOCIAL"),2)%>">%
	</div>
	<!-- GRUPO ALÍQUOTAS. FIM -->
	
	<!-- GRUPO LIMITES. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo" id="form_grupo_5">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_5" border="0" onClick="ShowArea('form_grupo_5','form_collapse_5');" 
  		style="cursor:pointer;">
		<b>Limites</b>
		<br><br><div class="form_label">IRRF (R$):</div><input name="DBVAR_MOEDA_VLR_LIM_IRRF" type="text" style="width:100px;" onKeyPress="validateFloatKey();" value="<%=FormataDecimal(GetValue(objRS,"VLR_LIM_IRRF"),2)%>">
		<br><div class="form_label">Outras Reduções (R$):</div><input name="DBVAR_MOEDA_VLR_LIM_REDUCAO" type="text" style="width:100px;" onKeyPress="validateFloatKey();" value="<%=FormataDecimal(GetValue(objRS,"VLR_LIM_REDUCAO"),2)%>">
	</div>
	<!-- GRUPO LIMITES. FIM -->
	
	<!-- GRUPO EMISSOR. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo" id="form_grupo_6">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_6" border="0" onClick="ShowArea('form_grupo_6','form_collapse_6');" 
  		style="cursor:pointer;">
		<b>Emissor</b>
		<br><br><div class="form_label">*Fornec.:</div><input name="DBVAR_NUM_COD_FORNECô" type="text" value="<%=GetValue(objRS,"COD_FORNEC")%>" style="width:30px;" onChange="LimparNome();" onKeyPress="validateNumKey();" maxlength="5">
		<div class="form_label_nowidth"><input name="var_nome" value="<%=GetValue(objRS,"FORNECEDOR_NOME")%>" type="text" 
										 style="width:230px;" readonly><a href="Javascript:void(0);" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0" border="0"></a></div>
 		<div class="form_ajuda">Código do fornecedor que utiliza o sistema. Seus dados cadastrais poderão ser usados para a emissão da Nota Fiscal.</div>
	</div>
	<!-- GRUPO EMISSOR. FIM -->
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
end if
FechaDBConn objConn
%>