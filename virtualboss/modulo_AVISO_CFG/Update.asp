<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_AVISO_CFG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
	strSQL =          " SELECT T1.COD_CFG_AVISO, T1.AVISAR_MANAGER_BS_TODO "
	strSQL = strSQL & "	FROM CFG_AVISO T1 "
	strSQL = strSQL & " WHERE T1.COD_CFG_AVISO = " & strCODIGO
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
%>
<html>
<head>
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Aviso - Altera&ccedil;&atilde;o") %>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="CFG_AVISO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CFG_AVISO">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_AVISO_CFG/Update.asp?var_chavereg=<%=strCODIGO%>">
	<div class='form_label'>Cod:</div>*Aviso a Todos Managers sobre BSes e TODOs:</div><input name="DBVAR_BOOL_AVISAR_MANAGER_BS_TODO" type="text" maxlength="10" style="width:70px;" value="<%=GetValue(objRS,"AVISAR_MANAGER_BS_TODO")%>">
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>