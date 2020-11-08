<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_NF_CFG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

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
		if ((document.form_update.DBVAR_NUM_COD_FORNEC�.value != '') && (document.form_update.var_nome.value == ''))
			AbreJanelaPAGE('BuscaEntidadeUm.asp?var_chavereg=' + document.form_update.DBVAR_NUM_COD_FORNEC�.value + '&var_form=form_update&var_input1=DBVAR_NUM_COD_FORNEC�&var_input2=var_nome','300','200');
		else
			AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update&var_input1=DBVAR_NUM_COD_FORNEC�&var_input2=var_nome','640','390');
	}
	function LimparNome() {
		document.form_update.var_nome.value = '';
	}
	
	//****** Fun��es de a��o dos bot�es - In�cio ******
	function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
	function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
	function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
	function submeterForm() {
		var var_msg = '';
		
		if (document.form_update.DBVAR_STR_SERIE�.value == '')        var_msg += '\nS�rie';
		if (document.form_update.DBVAR_STR_DESCRICAO�.value == '')    var_msg += '\nDescri��o';
		if (document.form_update.DBVAR_STR_MODELO_HTML�.value == '')  var_msg += '\nModelo';
		if (document.form_update.DBVAR_NUM_ULT_NUM_NF�.value == '')   var_msg += '\nN�mero da NF';
		//if (document.form_update.DBVAR_NUM_ULT_NUM_FORM�.value == '') var_msg += '\nN�mero do Formul�rio';
		if (document.form_update.DBVAR_NUM_NUM_LINHAS�.value == '')   var_msg += '\nNumero de linhas';
		if (document.form_update.DBVAR_NUM_TAM_LINHA�.value == '')    var_msg += '\nTamanho da linha';
		if (document.form_update.DBVAR_NUM_COD_FORNEC�.value == '')   var_msg += '\nCod Fornecedor';	
		
		if (var_msg == ''){
			document.form_update.submit();
		} else{
			alert('Favor verificar campos obrigat�rios:\n' + var_msg);
		}
	}
	//****** Fun��es de a��o dos bot�es - Fim ******
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
	<br><div class="form_label">*S&eacute;rie:</div><input name="DBVAR_STR_SERIE�" type="text" maxlength="10" style="width:70px;" value="<%=GetValue(objRS,"SERIE")%>">
	<br><div class="form_label">*Descri��o:</div><textarea name="DBVAR_STR_DESCRICAO�" rows="4" style="width:300px;"><%=GetValue(objRS,"DESCRICAO")%></textarea>
	<br><div class="form_label">Ordem:</div><input name="DBVAR_NUM_ORDEM" type="text" style="width:40px;" value="<%=GetValue(objRS,"ORDEM")%>" onKeyPress="validateNumKey();">
	<br><div class="form_label">*Modelo:</div><input name="DBVAR_STR_MODELO_HTML�" type="text" style="width:280px;" value="<%=GetValue(objRS,"MODELO_HTML")%>">
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="NULL" <%if GetValue(objRS,"DT_INATIVO")="" then Response.Write("checked") %>>Ativo
	&nbsp;&nbsp;<div class="form_label_nowidth"><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="<%=PrepData(Date,true,false)%>" <%if IsDate(GetValue(objRS,"DT_INATIVO")) and GetValue(objRS,"DT_INATIVO")<>"" then Response.Write("checked") %>>Inativo</div>
	
	<!-- GRUPO CARACTER�STICAS. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo_collapse" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Caracter�sticas</b>
		<br><br><div class="form_label">Tipo:</div><input type="radio" class='inputclean' name="DBVAR_STR_TIPO" id="var_tipo_padrao" value="PADRAO" 
												   <% If GetValue(objRS,"TIPO") = "PADRAO" Then Response.Write("checked") %>>Padr�o
			<br><div class="form_ajuda">
				Tipo simples onde uma <u>�nica nota fiscal</u> � impressa em um <u>�nico formul�rio</u>. 
			  	A quantidade total de itens da nota &eacute; determinada pelo n�mero de linhas do formul�rio 
				e pelo tamanho das descri��es dos itens.
			</div>
			<br><div class="form_label"></div><input type="radio" class='inputclean' name="DBVAR_STR_TIPO" id="var_tipo_extendido" value="EXTENDIDO" 
												   <% If GetValue(objRS,"TIPO") = "EXTENDIDO" Then Response.Write("checked") %>>Extendido
			<br><div class="form_ajuda">
			  	Tipo mais vers�til onde uma <u>�nica nota fiscal</u> pode ser impressa em <u>v�rios formul�rios</u>. 
				N�o existe limite para a quantidade total de itens.
			</div>
	</div>
	<!-- GRUPO CARACTER�STICAS. FIM -->
	
	<!-- GRUPO N�MEROS. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>N�meros</b>
		<br><br><div class="form_label">*Nota:</div><input name="DBVAR_NUM_ULT_NUM_NF�" type="text" style="width:70px;" 
													 value="<%=GetValue(objRS,"ULT_NUM_NF")%>" onKeyPress="validateNumKey();">
											        <span class="texto_ajuda">&Uacute;ltimo n�mero de Nota impresso</span>
		<!--<br><div class="form_label">*Formul�rio:</div><input name="DBVAR_NUM_ULT_NUM_FORM�" type="text" style="width:70px;" 
													 value="<%'=GetValue(objRS,"ULT_NUM_FORM")%>" onKeyPress="validateNumKey();">
													<span class="texto_ajuda">&Uacute;ltimo n�mero de Formul�rio utilizado</span>-->
	</div>
	<!-- GRUPO N�MEROS. FIM -->	
	
	<!-- GRUPO LINHAS. EXEMPLO DE USO DO FORM_COLLAPSE -->	
	<div class="form_grupo" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
  		style="cursor:pointer;">
		<b>Linhas</b>
		<br><br><div class="form_label">*N�mero:</div><input name="DBVAR_NUM_NUM_LINHAS�" type="text" style="width:40px;" 
													  value="<%=GetValue(objRS,"NUM_LINHAS")%>">
													  <span class="texto_ajuda">Total de linhas do formul�rio para os itens</span>
		<br><div class="form_label">*Tamanho:</div><input name="DBVAR_NUM_TAM_LINHA�" type="text" style="width:40px;" 
													  value="<%=GetValue(objRS,"TAM_LINHA")%>">
													  <span class="texto_ajuda">Total de caracteres de cada linha</span>
	</div>
	<!-- GRUPO LINHAS. FIM -->	
	
	<!-- GRUPO AL�QUOTAS. EXEMPLO DE USO DO FORM_COLLAPSE -->		
	<div class="form_grupo" id="form_grupo_4">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_4" border="0" onClick="ShowArea('form_grupo_4','form_collapse_4');" 
  		style="cursor:pointer;">
		<b>Al�quotas</b>
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
	<!-- GRUPO AL�QUOTAS. FIM -->
	
	<!-- GRUPO LIMITES. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo" id="form_grupo_5">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_5" border="0" onClick="ShowArea('form_grupo_5','form_collapse_5');" 
  		style="cursor:pointer;">
		<b>Limites</b>
		<br><br><div class="form_label">IRRF (R$):</div><input name="DBVAR_MOEDA_VLR_LIM_IRRF" type="text" style="width:100px;" onKeyPress="validateFloatKey();" value="<%=FormataDecimal(GetValue(objRS,"VLR_LIM_IRRF"),2)%>">
		<br><div class="form_label">Outras Redu��es (R$):</div><input name="DBVAR_MOEDA_VLR_LIM_REDUCAO" type="text" style="width:100px;" onKeyPress="validateFloatKey();" value="<%=FormataDecimal(GetValue(objRS,"VLR_LIM_REDUCAO"),2)%>">
	</div>
	<!-- GRUPO LIMITES. FIM -->
	
	<!-- GRUPO EMISSOR. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo" id="form_grupo_6">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_6" border="0" onClick="ShowArea('form_grupo_6','form_collapse_6');" 
  		style="cursor:pointer;">
		<b>Emissor</b>
		<br><br><div class="form_label">*Fornec.:</div><input name="DBVAR_NUM_COD_FORNEC�" type="text" value="<%=GetValue(objRS,"COD_FORNEC")%>" style="width:30px;" onChange="LimparNome();" onKeyPress="validateNumKey();" maxlength="5">
		<div class="form_label_nowidth"><input name="var_nome" value="<%=GetValue(objRS,"FORNECEDOR_NOME")%>" type="text" 
										 style="width:230px;" readonly><a href="Javascript:void(0);" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0" border="0"></a></div>
 		<div class="form_ajuda">C�digo do fornecedor que utiliza o sistema. Seus dados cadastrais poder�o ser usados para a emiss�o da Nota Fiscal.</div>
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