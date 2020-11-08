<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO
	
	strCODIGO = GetParam("var_chavereg")

	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSQL =          " SELECT COD_QUESTAO, QUESTAO,  ORDEM, EN_ENQUETE.TITULO "		
		strSQL = strSQL & " FROM EN_QUESTAO "
		strSQL = strSQL & " INNER JOIN EN_ENQUETE ON  EN_QUESTAO.COD_ENQUETE = EN_ENQUETE.COD_ENQUETE "
		strSQL = strSQL & " WHERE COD_QUESTAO = " & strCODIGO 
		'RESPONSE.Write(STRSQL)
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
<%=athBeginDialog(WMD_WIDTH, "Questão - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE" value="EN_QUESTAO">
	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME" value="COD_QUESTAO">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_ENQUETE_QUESTAO/update.asp?var_chavereg=<%=strCODIGO%>">
    <div class="form_label">Cód.:</div><div class="form_bypass"><%=strCODIGO%></div>
    <br><div class="form_label">Enquete:</div><div class="form_bypass"><%=getValue(objRS,"TITULO")%></div>
	<br><div class="form_label">Questão:</div><input name="DBVAR_STR_QUESTAO" type="text" style="width:300px" value="<%=GetValue(objRS,"QUESTAO")%>" maxlength="250">
	<br><div class="form_label">Ordem:</div><input name="DBVAR_STR_ORDEM" type="text" style="width:100px" value="<%=GetValue(objRS,"ORDEM")%>">
	
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