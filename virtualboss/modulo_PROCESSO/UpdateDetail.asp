<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PROCESSO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim objRS1, objRS2
	Dim strCODIGO, strIDEXECUTOR, strTO
    Dim strTITULO, strRESPONSAVEL, strTAREFA, strDT_AGENDADO, strFULLCATEGORIA 

	AbreDBConn objConn, CFG_DB 

	strCODIGO = GetParam("var_chavereg")

	strSQL = " SELECT COD_PROCESSO, DESC_OQUE, DESC_QUEM, DESC_QUANDO, NUMERO, COMPLEMENTAR, ARQ_ANEXO " &_
			 " FROM PROCESSO_TAREFA WHERE COD_TAREFA = " & strCODIGO

	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

	If Not objRS.Eof Then
%>
<html>
<head>
	<title>vboss</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
	<script language="JavaScript" type="text/javascript">
		//****** Fun��es de a��o dos bot�es - In�cio ******
		function ok()			{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
		function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
		function aplicar()      { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
				
		function submeterForm() {
			var var_msg = '';
			if (document.form_update.DBVAR_NUM_NUMERO�.value       == '')  var_msg += '\n N�mero';
			if (document.form_update.DBVAR_STR_DESC_OQUE�.value    == '')  var_msg += '\n O Qu�';
			if (document.form_update.DBVAR_STR_DESC_QUEM�.value    == '')  var_msg += '\n Quem';
			if (document.form_update.DBVAR_STR_DESC_QUANDO�.value  == '')  var_msg += '\n Quando';
		
			if (var_msg == ''){ document.form_update.submit(); } 
				else{ alert('Favor verificar campos obrigat�rios:\n' + var_msg); }
			}
		//****** Fun��es de a��o dos bot�es - Fim ******
		
		function UploadImage(formname,fieldname, dir_upload){
		var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
		window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
		}
	</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Tarefa de Processo - Altera&ccedil;&atilde;o")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="PROCESSO_TAREFA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_TAREFA">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PROCESSO/UpdateDetail.asp?var_chavereg=<%=strCODIGO%>'>
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>"/>
	<div class="form_label">Cod. Tarefa:</div><div class="form_bypass"><b><%=strCODIGO%></b></div>
	<br><div class='form_label'>*N�mero:</div><input name="DBVAR_NUM_NUMERO�" type="text" size="10" value="<%=GetValue(objRS,"NUMERO")%>">
	<br><div class='form_label'>*O que:</div><textarea name="DBVAR_STR_DESC_OQUE�" style="width:250px;height:100px"><%=GetValue(objRS,"DESC_OQUE")%></textarea>
	<br><div class='form_label'>*Quem:</div><input name="DBVAR_STR_DESC_QUEM�" type="text" size="25" value="<%=GetValue(objRS,"DESC_QUEM")%>">
	<br><div class='form_label'>*Quando:</div><input name="DBVAR_STR_DESC_QUANDO�" type="text" size="15" value="<%=GetValue(objRS,"DESC_QUANDO")%>">
	<br><div class='form_label'>Complementar:</div><input name="DBVAR_STR_COMPLEMENTAR" type="text" value="<%=GetValue(objRS,"COMPLEMENTAR")%>">
	<br><div class='form_label'>Anexo:</div><input name="DBVAR_STR_ARQ_ANEXO" type="text" maxlength="255" value="<%=GetValue(objRS,"ARQ_ANEXO")%>"><a href="javascript:UploadImage('form_update','DBVAR_STR_ARQ_ANEXO', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"><img src="../img/BtUpload.gif" border="0" align="absmiddle"></a>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"--></body>
</html>
<%
	End If
FechaRecordSet objRS
FechaDBConn objConn
%>