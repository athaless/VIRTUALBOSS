<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CATEGORIAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim strSQL, objRS, objConn 
 Dim strCODIGO, strTABELA, strCATEGORIA_NAME
		
 strCODIGO = GetParam("var_chavereg")
 strTABELA        = GetParam("var_table")

 if strCODIGO<> "" and strTABELA<>"" then

	select case strTABELA	
		case "AG_" 			strCATEGORIA_NAME = "Agenda"
		case "CH_"          strCATEGORIA_NAME = "Chamado"
		case "PROCESSO_"	strCATEGORIA_NAME = "Processos"		
		case "ASLW_"		strCATEGORIA_NAME = "Relatórios"		
		case "SV_"			strCATEGORIA_NAME = "Serviços"
		case "PT_FOLGA_"	strCATEGORIA_NAME = "Folgas"
		case "TL_"			strCATEGORIA_NAME = "Tarefas"
		case "BS_"			strCATEGORIA_NAME = "Atividades"		
		case "PRJ_"			strCATEGORIA_NAME = "Projetos"
		case "MB_LIVRO_"	strCATEGORIA_NAME = "Livros"
		case "MB_REVISTA_"	strCATEGORIA_NAME = "Revistas"
		case "MB_MANUAL_"	strCATEGORIA_NAME = "Manuais"
		case "MB_VIDEO_"	strCATEGORIA_NAME = "Vídeos"
		case "MB_DISCO_"	strCATEGORIA_NAME = "Discos"
		case "MB_DADO_"	    strCATEGORIA_NAME = "Dados"
	end select


	AbreDBConn objConn, CFG_DB 
	strSQL = "SELECT NOME,DESCRICAO FROM " & strTABELA & "CATEGORIA WHERE COD_CATEGORIA=" & strCODIGO
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
function submeterForm(){ 
	var var_msg = '';
	if (document.form_update.DBVAR_STR_NOMEô.value == '') { var_msg += '\nCategoria'; }
	if (var_msg == ''){
		document.form_update.submit();
	}else {
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body onLoad="form_update.DBVAR_STR_NOMEô.focus();">
<%=athBeginDialog(WMD_WIDTH, "Categoria " & strCATEGORIA_NAME & " - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="<%=strTABELA%>CATEGORIA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CATEGORIA">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_CATEGORIAS/Update.asp?var_chavereg=<%=strCODIGO%>&var_table=<%=strTABELA%>">
	<div class='form_label'>Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class='form_label'>*Categoria:</div><input name="DBVAR_STR_NOMEô" type="text" style="width:130px;" value="<%=GetValue(objRS,"NOME")%>">
	<br><div class='form_label'>Descrição:</div><textarea name="DBVAR_STR_DESCRICAO" type="text" cols="40" rows="5"><%=GetValue(objRS,"DESCRICAO")%></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if 
%>