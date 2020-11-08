<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_CONTAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 
 Dim objConn, objRS, strSQL
 Dim strCODIGO, strSALDO_INI, strSALDO

 strCODIGO = GetParam("var_chavereg")

 if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" 			&_	
				"	NOME,"			&_
				"	DESCRICAO,"		&_
				"	TIPO,"			&_
				"	COD_BANCO,"		&_
				"	AGENCIA,"		&_
				"	CONTA,"			&_
				"	DT_CADASTRO," 	&_
				"	VLR_SALDO_INI,"	&_
				"	VLR_SALDO,"		&_
				"	DT_INATIVO,"	&_
				"	ORDEM "			&_
				"FROM"				&_
				"	FIN_CONTA "		&_
				"WHERE COD_CONTA=" & strCODIGO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
		if GetValue(objRS,"VLR_SALDO_INI")<>"" then 	strSALDO_INI= FormataDecimal(GetValue(objRS,"VLR_SALDO_INI"),2)
		if GetValue(objRS,"VLR_SALDO")<>"" then 		strSALDO 	= FormataDecimal(GetValue(objRS,"VLR_SALDO"),2)
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
<%=athBeginDialog(WMD_WIDTH, "Conta Banco - Alteração") %>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="FIN_CONTA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CONTA">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_FIN_CONTAS/Update.asp?var_chavereg=<%=strCODIGO%>">
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">*Nome:</div><input name="DBVAR_STR_NOMEô" type="text" maxlength="255" value="<%=GetValue(objRS,"NOME")%>" style="width:230px;">
	<br><div class="form_label">Tipo:</div><select name="DBVAR_STR_TIPO" style="width:140px;">
				<option value="" 					<%if GetValue(objRS,"TIPO")="" then                  Response.Write("selected")%>>[selecione]</option>
				<option value="CONTA CORRENTE" 		<%if GetValue(objRS,"TIPO")="CONTA CORRENTE" then    Response.Write("selected")%>>Conta-corrente</option>
				<option value="CARTAO DE CREDITO"	<%if GetValue(objRS,"TIPO")="CARTAO DE CREDITO" then Response.Write("selected")%>>Cartão de Crédito</option>
				<option value="DINHEIRO" 			<%if GetValue(objRS,"TIPO")="DINHEIRO" then          Response.Write("selected")%>>Dinheiro</option>
				<option value="INVESTIMENTOS" 		<%if GetValue(objRS,"TIPO")="INVESTIMENTOS" then     Response.Write("selected")%>>Investimentos</option>
				<option value="POUPANCA" 			<%if GetValue(objRS,"TIPO")="POUPANCA" then          Response.Write("selected")%>>Poupança</option>
				<option value="OUTROS" 				<%if GetValue(objRS,"TIPO")="OUTROS" then            Response.Write("selected")%>>Outros</option>
			</select>
	<br><div class="form_label">Saldo Inicial:</div><div class="form_bypass"><%=strSALDO_INI%></div>
	<br><div class="form_label">Saldo Atual:</div><div class="form_bypass"><%=strSALDO%></div>
	<br><div class="form_label">Data Cadastro:</div><div class="form_bypass"><%=PrepData(GetValue(objRS,"DT_CADASTRO"), True, False)%></div>
	<br><div class="form_label">Descrição:</div><textarea name="DBVAR_STR_DESCRICAO" rows="5" style="width:230px;"><%=GetValue(objRS,"DESCRICAO")%></textarea>
	<br><div class="form_label">Ordem:</div><input name="DBVAR_NUM_ORDEM" type="text" value="<%=GetValue(objRS,"ORDEM")%>" style="width:40px;" onKeyPress="validateNumKey();">
	<br><div class="form_label">Status:</div>
	<%
    If GetValue(objRS,"DT_INATIVO") = "" Then
		Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL' checked>Ativo")
		Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & PrepDataBrToUni(Date, False) & "'>Inativo")
    Else
		Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL'>Ativo")
		Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & PrepDataBrToUni(Date, False) & "' checked>Inativo")
    End If
	%>
	
	<!-- GRUPO CARACTERÍSTICAS. EXEMPLO DE USO DO FORM_COLLAPSE -->
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Informações sobre o Banco</b><br>
		<br><div class="form_label">*Banco:</div><select name="DBVAR_NUM_COD_BANCOô" style="width:140px;">
				<%=montaCombo("STR","SELECT COD_BANCO, NOME FROM FIN_BANCO ORDER BY COD_BANCO","COD_BANCO","NOME",GetValue(objRS,"COD_BANCO"))%>
			</select>
		<br><div class="form_label">Agência:</div><input name="DBVAR_STR_AGENCIA" type="text" maxlength="50" value="<%=GetValue(objRS,"AGENCIA")%>" style="width:80px;">
		<br><div class="form_label">Conta:</div><input name="DBVAR_STR_CONTA" type="text" maxlength="50" value="<%=GetValue(objRS,"CONTA")%>" style="width:120px;">
	</div>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
 end if 
%>