<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_MB_DADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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

	strSQL = " SELECT * FROM mb_dado_item WHERE COD_DADO_ITEM = " & strCODIGO

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
			if (document.form_update.DBVAR_STR_TITULO�.value       == '')  var_msg += '\n T�tulo';
					
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
<%=athBeginDialog(WMD_WIDTH, "Dado Item - Altera&ccedil;&atilde;o")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="MB_DADO_ITEM">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_DADO_ITEM">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_MB_DADO/UpdateDetail.asp?var_chavereg=<%=strCODIGO%>'>
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>"/>
	<div class="form_label">Cod.:</div><div class="form_bypass"><b><%=strCODIGO%></b></div>
	<br><div class="form_label">*T�tulo:</div><input name="DBVAR_STR_TITULO�" type="text" style="width:270px;" maxlength="200" value="<%=GetValue(objRS,"TITULO")%>">
	<br><div class="form_label">Extra:</div><input name="DBVAR_STR_EXTRA" type="text" style="width:150px;" maxlength="50" value="<%=GetValue(objRS,"EXTRA")%>">
	<br><div class="form_label">Tamanho:</div><input name="DBVAR_STR_TAMANHO" type="text" style="width:150px;" maxlength="20" value="<%=GetValue(objRS,"TAMANHO")%>" />
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"--></body>
</html>
<%
	End If
FechaRecordSet objRS
FechaDBConn objConn
%>