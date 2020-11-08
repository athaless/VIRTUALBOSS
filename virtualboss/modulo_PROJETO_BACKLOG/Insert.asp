<!--#include file="../_database/athdbConn.asp"--><!-- ATEN��O: language, option explicit, etc... est�o no athDBConn -->
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PROJETO_BACKLOG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

 Dim strSQL, objRS, ObjConn
 Dim strCODIGO 

 strCODIGO = GetParam("var_cod_projeto")
 'Se recebe o cod_projeto, ent�o pe proque esta sendo aberta da dentro 
 'de outro m�dulo e isto significa que a escolha do projeto n�o deve ser 
 'permitida o combo ser� trancado neste caso mais abaixo com o cod_proejto recebido
 
 'AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.DBVAR_STR_TITULO�.value == '') var_msg += '\nT�tulo';
	if (document.form_insert.DBVAR_NUM_COD_PROJETO�.value == '')  var_msg += '\nProjeto';	
	
	if (var_msg == ''){
		document.form_insert.submit();
    }
	else
		alert('Favor verificar campos obrigat�rios:\n' + var_msg);
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Projeto Backlog - Inser��o")%>  
<form name="form_insert" action="../_database/athInsertToDB.asp" method="POST">
  	<input type="hidden" id="DEFAULT_TABLE" 	name="DEFAULT_TABLE"	value="PRJ_BACKLOG">
  	<input type="hidden" id="DEFAULT_DB"		name="DEFAULT_DB"		value="<%=CFG_DB%>">
    <input type="hidden" id="FIELD_PREFIX"		name="FIELD_PREFIX"		value="DBVAR_">
  	<input type="hidden" id="RECORD_KEY_NAME"	name="RECORD_KEY_NAME"	value="COD_PRJ_BACKLOG">
	<input type="hidden" id="DBVAR_DATE_SYS_DTT_INS"  		name="DBVAR_DATE_SYS_DTT_INS" value="<%=PrepDataBrToUni(Now, False)%>">
	<input type="hidden" id="DBVAR_STR_SYS_ID_USUARIO_INS"  name="DBVAR_STR_SYS_ID_USUARIO_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">	
	<input type="hidden" id="DEFAULT_LOCATION"	name="DEFAULT_LOCATION" value='../modulo_PROJETO_BACKLOG/insert.asp'>
	<input type="hidden" id="JSCRIPT_ACTION"	name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" id="DBVAR_STR_STATUS"  name="DBVAR_STR_STATUS" value="ABERTO">

	<div class='form_label'>*Projeto:</div><select id="DBVAR_NUM_COD_PROJETO�" name="DBVAR_NUM_COD_PROJETO�" style="width:100px;">
											<%
											IF (strCODIGO<>"") THEN 
												Response.Write(montaCombo("STR"," SELECT COD_PROJETO, TITULO FROM PRJ_PROJETO WHERE COD_PROJETO = " & strCODIGO & " ORDER BY TITULO ", "COD_PROJETO","TITULO",strCODIGO))
											ELSE
												Response.Write("<option value='' selected='selected'>[selecione]</option>")
 					                            Response.Write(montaCombo("STR"," SELECT COD_PROJETO, TITULO FROM PRJ_PROJETO ORDER BY TITULO ", "COD_PROJETO","TITULO",strCODIGO))
											END IF
											%>
			                              </select>
  	<br><div class='form_label'>*T�tulo:</div><input id="DBVAR_STR_TITULO�" name="DBVAR_STR_TITULO�" type="text" style="width:300px;" value="" maxlength="255">
	<br><div class='form_label'>Descri��o:</div><textarea if="DBVAR_STR_DESCRICAO" name="DBVAR_STR_DESCRICAO" style="width:350px; height:160px;"></textarea>
    <br><div class='form_label'>Tamanho:</div><input id=="DBVAR_NUM_TAMANHO" name="DBVAR_NUM_TAMANHO" type="text" style="width:60px;" maxlength="10" value="" onKeyPress="validateNumKey();">
	<br><div class='form_label'></div><span class="texto_ajuda">&nbsp;estimativa de tamanho, classifica��o (de 1 a 10), quantidade de horas, etc.</span>
    <br><div class='form_label'>ROI:</div><input id=="DBVAR_NUM_ROI" name="DBVAR_NUM_ROI" type="text" style="width:80px;" maxlength="15" value="" onKeyPress="validateNumKey();">
    <br><div class='form_label'></div><span class="texto_ajuda">&nbsp;quanto maior o ROI, maior prioridade p/ entrada em sprint,</span>
    <br><div class='form_label'></div><span class="texto_ajuda">&nbsp;seguindo recomenda��o para aplica��o do framework SCRUM.</span> 	
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
'  FechaRecordSet objRS
'  FechaDBConn objConn
%>