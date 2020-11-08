<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PROJETO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
    Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
    Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO
	
	strCODIGO = GetParam("var_chavereg")

	if strCODIGO<>"" then
		AbreDBConn objConn, CFG_DB 
		
		strSQL = " SELECT COD_PROJETO, COD_CATEGORIA, TITULO, DESCRICAO, DT_DEADLINE FROM PRJ_PROJETO WHERE COD_PROJETO = " & strCODIGO
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()       { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.DBVAR_STR_TITULO�.value == '') var_msg += '\nT�tulo';
	
	if (var_msg == ''){
		document.form_update.submit();
    }
	else
		alert('Favor verificar campos obrigat�rios:\n' + var_msg);
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Projeto - Altera��o") %>
  <form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
  	<input type="hidden" name="DEFAULT_TABLE" value="PRJ_PROJETO">
  	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
    <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
  	<input type="hidden" name="RECORD_KEY_NAME" value="COD_PROJETO">
	<input type="hidden" name="DBVAR_DATE_SYS_DTT_INS" value="<%=PrepDataBrToUni(Now, False)%>">
	<input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">	
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PROJETO/update.asp'>
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
  	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=GetValue(objRS, "COD_PROJETO")%>">	
  	<br><div class='form_label'>*T�tulo:</div><input name="DBVAR_STR_TITULO�" type="text" style="width:300px;" value="<%=GetValue(objRS,"TITULO")%>" maxlength="255">
	<br><div class='form_label'>Descri��o:</div><textarea name="DBVAR_STR_DESCRICAO" style="width:350px; height:120px;"><%=GetValue(objRS,"DESCRICAO")%></textarea>
	<div class='form_label'>Categoria:</div><select name="DBVAR_NUM_COD_CATEGORIA" style="width:100px;">
                           				    <option value="">[selecione]</option>
											<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM PRJ_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME","COD_CATEGORIA","NOME",GetValue(objRS,"COD_CATEGORIA"))%>
			                              </select>
    <br><div class='form_label'>Deadline:</div><%=InputDate("DBVAR_DATE_DT_DEADLINE","",GetValue(objRS,"DT_DEADLINE"),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_DEADLINE", "ver calend�rio")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
  </form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If
		FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>