<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_BOLETO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
	strSQL = "SELECT" 						&_
				"	COD_CFG_BOLETO,"		&_
				"	DESCRICAO,"				&_
				"	CEDENTE_NOME," 			&_
				"	CEDENTE_ENDERECO," 		&_
				"	CEDENTE_AGENCIA," 		&_
				"	CEDENTE_CNPJ," 			&_
				"	CEDENTE_CODIGO,"		&_
				"	CEDENTE_CODIGO_DV,"		&_				
				"	COD_CLIENTE,"			&_				
				"	BANCO_CODIGO," 			&_
				"	BANCO_DV," 				&_
				"	BANCO_IMG," 			&_
				"	BOLETO_ACEITE," 		&_
				"	BOLETO_CARTEIRA," 		&_
				"	BOLETO_ESPECIE," 		&_
				"	BOLETO_TIPO_DOC,"		&_
				"	LOCAL_PGTO," 			&_
				"	INSTRUCOES," 			&_
				"	DT_INATIVO," 			&_				
				"	MODELO_HTML " 			&_				
				"FROM" 						&_
				"	CFG_BOLETO " 			&_ 
				"WHERE"	 					&_
				"	COD_CFG_BOLETO=" & strCODIGO
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
		AbreJanelaPAGE('BuscaPorEntidade.asp?var_input1=DBVAR_STR_CEDENTE_NOME�&var_input2=DBVAR_STR_CEDENTE_CNPJ�&var_tipo=ENT_CLIENTE&var_form=form_update','640','390');
	}
	
	//****** Fun��es de a��o dos bot�es - In�cio ******
	function ok() { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
	function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
	function aplicar() { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
	function submeterForm() {
		var var_msg = '';
		
		if (document.form_update.DBVAR_STR_MODELO_HTML�.value == '')        var_msg += '\nBoleto (modelo)';
		if (document.form_update.DBVAR_STR_CEDENTE_NOME�.value == '')       var_msg += '\nCedente';
		if (document.form_update.DBVAR_STR_CEDENTE_ENDERECO�.value == '')   var_msg += '\nEndere�o Cedente';
		if (document.form_update.DBVAR_STR_CEDENTE_CNPJ�.value == '')       var_msg += '\nCNPJ Cedente';
		if (document.form_update.DBVAR_NUM_CEDENTE_CODIGO�.value == '')     var_msg += '\nConta (c�digo)';
		if (document.form_update.DBVAR_STR_CEDENTE_CODIGO_DV�.value == '')  var_msg += '\nConta (dv)';
		if (document.form_update.DBVAR_NUM_BANCO_CODIGO�.value == '')       var_msg += '\nBanco (c�digo)';
		if (document.form_update.DBVAR_STR_BANCO_DV�.value == '')           var_msg += '\nBanco (dv)';
		if (document.form_update.DBVAR_STR_CEDENTE_AGENCIA� == '')          var_msg += '\nBanco (ag�ncia)';
		if (document.form_update.DBVAR_STR_BOLETO_CARTEIRA�.value == '')    var_msg += '\nBoleto Carteira';
		if (document.form_update.DBVAR_STR_BOLETO_ACEITE�.value == '')      var_msg += '\nBoleto Aceite';
		if (document.form_update.DBVAR_STR_LOCAL_PGTO�.value == '')         var_msg += '\nLocal Pagamento';
		if (document.form_update.DBVAR_STR_INSTRUCOES�.value == '')         var_msg += '\nInstru��es';
	
		if (var_msg == '')
			document.form_update.submit();
		else
			alert('Favor verificar campos obrigat�rios:\n' + var_msg);
	}
	//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Boletos - Altera��o")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="CFG_BOLETO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CFG_BOLETO">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_FIN_BOLETO/Update.asp?var_chavereg=<%=strCODIGO%>">
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=GetValue(objRS,"COD_CFG_BOLETO")%></div>
	<br><div class="form_label">*Boleto:</div><select name="DBVAR_STR_MODELO_HTML�" style="width:120px;">
								<option value="">[selecione]</option>
								<option value="Boleto_Itau.asp"
								<%if LCase(GetValue(objRS,"MODELO_HTML")) = "boleto_itau.asp" then Response.Write("selected")%>>Ita� 341 - 7</option>
								<option value="Boleto_Unibanco.asp"
								<%if LCase(GetValue(objRS,"MODELO_HTML")) = "boleto_unibanco.asp" then Response.Write("selected")%>>Unibanco 409 - 1</option>
						  </select>
	<br><div class="form_label">*Descri��o:</div><input name="DBVAR_STR_DESCRICAO�" type="text" style="width:250px;" value="<%=GetValue(objRS,"DESCRICAO")%>">
    
	<!-- GRUPO CEDENTE -->
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Dados do Cedente</b>
    	<br><br><div class="form_label">*Cedente:</div><input name="DBVAR_STR_CEDENTE_NOME�" type="text" style="width:250px;" value="<%=GetValue(objRS,"CEDENTE_NOME")%>"><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" hspace="0" style="vertical-align:top; padding-top:2px"></a>
    	<br><div class="form_label">*Endere�o:</div><input name="DBVAR_STR_CEDENTE_ENDERECO�" type="text" style="width:340px;" value="<%=GetValue(objRS,"CEDENTE_ENDERECO")%>">
		<br><div class="form_label">*CNPJ: </div><input name="DBVAR_STR_CEDENTE_CNPJ�" type="text" style="width:125px;" value="<%=GetValue(objRS,"CEDENTE_CNPJ")%>">
		<br><div class="form_label">*Conta:</div><input name="DBVAR_NUM_CEDENTE_CODIGO�" type="text" style="width:70px;" 
												  onKeyPress="validateNumKey();" value="<%=GetValue(objRS,"CEDENTE_CODIGO")%>">&nbsp;-&nbsp;<input name="DBVAR_STR_CEDENTE_CODIGO_DV�" type="text" style="width:18px;" 
							  					  onKeyPress="validateNumKey();" value="<%=GetValue(objRS,"CEDENTE_CODIGO_DV")%>">
		<br><div class="form_label">Cod. Cliente:</div><input name="DBVAR_STR_COD_CLIENTE" type="text" maxlength="10" style="width:125px;" value="<%=GetValue(objRS,"COD_CLIENTE")%>">
	</div>
	<!-- FIM CEDENTE -->
	
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Dados do Boleto</b>
		<br><br><div class="form_label">*Cod. Banco:</div><input name="DBVAR_NUM_BANCO_CODIGO�" type="text" style="width:60px;" 
														   onKeyPress="validateNumKey();" 
														   value="<%=GetValue(objRS,"BANCO_CODIGO")%>">&nbsp;-&nbsp;<input name="DBVAR_STR_BANCO_DV�" type="text" 
														   style="width:18px;" value="<%=GetValue(objRS,"BANCO_DV")%>">
		<br><div class="form_label">*Ag�ncia:</div><input maxlength="10" name="DBVAR_STR_CEDENTE_AGENCIA�" type="text" 
													style="width:80px;" value="<%=GetValue(objRS,"CEDENTE_AGENCIA")%>" 
													onKeyPress="validateNumKey();">
		<br><div class="form_label">*Carteira:</div><input maxlength="03" name="DBVAR_STR_BOLETO_CARTEIRA�" type="text" 
													 style="width:120px;" value="<%=GetValue(objRS,"BOLETO_CARTEIRA")%>">
		<br><div class="form_label">*Aceite:</div><input maxlength="14" name="DBVAR_STR_BOLETO_ACEITE�" type="text" 
												   style="width:80px;" value="<%=GetValue(objRS,"BOLETO_ACEITE")%>">
		<br><div class="form_label">Tipo Doc.:</div><input maxlength="50" name="DBVAR_STR_BOLETO_TIPO_DOC" type="text" 
												   style="width:120px;" value="<%=GetValue(objRS,"BOLETO_TIPO_DOC")%>">
		<br><div class="form_label">*Esp�cie:</div><input maxlength="14" name="DBVAR_STR_BOLETO_ESPECIE�" type="text" 
												    style="width:80px;" value="<%=GetValue(objRS,"BOLETO_ESPECIE")%>">
	   	<br><div class="form_label">*Local Pgto.:</div><textarea name="DBVAR_STR_LOCAL_PGTO�" rows="6" style="width:301px;"><%=GetValue(objRS,"LOCAL_PGTO")%></textarea>
		<br><div class="form_label">*Instru��es:</div><textarea name="DBVAR_STR_INSTRUCOES�" rows="6" style="width:301px;"><%=GetValue(objRS,"INSTRUCOES")%></textarea>
		<br><div class="form_label">Imagem:</div><input name="DBVAR_STR_BANCO_IMG" style="width:250px;" value="<%=GetValue(objRS,"BANCO_IMG")%>"><%'a href="Javascript://;" onClick="Javascript:UploadImage('form_insert','DBVAR_STR_BANCO_IMG', '<%=strUploadPath>');"><img src="../img/bt_upload.gif" border="0" hspace="4" align="absmiddle"></a%>
		<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="NULL" <%if GetValue(objRS,"DT_INATIVO")="" then Response.Write("checked") %>>Ativo&nbsp;&nbsp;<input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="<%=PrepData(Date,true,false)%>" <%if IsDate(GetValue(objRS,"DT_INATIVO")) and GetValue(objRS,"DT_INATIVO")<>"" then Response.Write("checked") %>>Inativo
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
		FechaRecordSet objRS
	end if 
	FechaDBConn objConn
end if
%>