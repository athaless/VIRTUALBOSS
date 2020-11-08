<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_SERVICO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
	strSQL = "SELECT COD_SERVICO "		&_
				"	,COD_CATEGORIA "	&_
				"	,DESCRICAO"			&_
				"	,TITULO"			&_
				"	,OBS"				&_
				"	,DT_INATIVO"		&_
				"	,VALOR "			&_
				"	,ALIQ_ISSQN "		&_
				"FROM"					&_
				"	SV_SERVICO "		&_
				"WHERE"					&_
				"	COD_SERVICO=" & strCODIGO
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
		if not objRS.eof then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() 	{ document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Servi&ccedil;os - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="SV_SERVICO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_SERVICO">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_FIN_SERVICO/Update.asp?var_chavereg=<%=strCODIGO%>'>
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">*T&iacute;tulo:</div><input name="DBVAR_STR_TITULOô" type="text" style="width:250px;" value="<%=GetValue(objRS,"TITULO")%>">
	<br><div class="form_label">Descri&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_DESCRICAO" rows="6" style="width:250px;"><%=GetValue(objRS,"DESCRICAO")%></textarea>
	<br><div class="form_label">*Valor:</div><input name="DBVAR_MOEDA_VALORô" type="text" maxlength="15" style="width:60px;" value="<%=FormataDecimal(GetValue(objRS,"VALOR"),2)%>" onKeyPress="validateFloatKey();">
	<br><div class="form_label">Alíquota ISSQN:</div><input name="DBVAR_MOEDA_ALIQ_ISSQN" type="text" maxlength="15" style="width:60px;" value="<%=FormataDecimal(GetValue(objRS,"ALIQ_ISSQN"),2)%>" onKeyPress="validateFloatKey();">
	<br><div class="form_label">*Categoria:</div><select name="DBVAR_NUM_COD_CATEGORIAô" style="width:120px;">
			<%=MontaCombo("STR","SELECT COD_CATEGORIA, NOME FROM SV_CATEGORIA ORDER BY 2","COD_CATEGORIA","NOME",GetValue(objRS,"COD_CATEGORIA"))%>
		</select>
	<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_OBS" rows="6" style="width:250px;"><%=GetValue(objRS,"OBS")%></textarea>
	<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="NULL" <%if GetValue(objRS,"DT_INATIVO")="" then Response.Write("checked") %>>Ativo&nbsp;&nbsp;<input name="DBVAR_DATE_DT_INATIVO" type="radio" class="inputclean" value="<%=PrepData(Date,true,false)%>" <%if IsDate(GetValue(objRS,"DT_INATIVO")) and GetValue(objRS,"DT_INATIVO")<>"" then Response.Write("checked") %>>Inativo
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<%
		FechaRecordSet objRS
	end if 
	FechaDBConn objConn
end if
%>
</body>
</html>
