<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_BS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 
 Dim strSQL, objRS, ObjConn
 Dim strCODIGO, strRESPOSTA, strTDTITULO, auxHS
 Dim auxSTRTITULO, auxSTRSITUACAO, auxSTRCATEGORIA 
 Dim auxSTRPRIORIDADE, auxSTRRESPONSAVEL, auxSTRDESC
 Dim auxSTRPREV_DT_INI, auxSTRPREV_HR_INI, strPREV_HORAS
 Dim auxSTRCLIENTE, auxSTRDT_REALIZADO, auxSTRFULLCATEGORIA
 Dim auxSTRCOD_BOLETIM, strGRUPOS, strGRUPO_USUARIO
 Dim strCOOKIE_ID_USUARIO, strID_RESPONSAVEL
 Dim strCLIENTE, strEQUIPE, arrBS_EQUIPE

 strCODIGO = GetParam("var_chavereg")

 strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 strGRUPO_USUARIO = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))	

 AbreDBConn objConn, CFG_DB 

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.VAR_TITULO.value == '')        		var_msg += '\nTítulo';
	if (document.form_insert.var_cod_cliente.value == '')        	var_msg += '\nCliente';
	if (document.form_insert.var_situacao.value == '')        		var_msg += '\nSituação';
	if (document.form_insert.var_cod_e_desc_categoria.value == '')  var_msg += '\nCategoria';
	if (document.form_insert.var_prioridade.value == '')        	var_msg += '\nPrioridade';
	if (document.form_insert.var_id_responsavel.value == '')        var_msg += '\nResponsável';
	if (document.form_insert.var_descricao.value == '')        		var_msg += '\nTarefa';
	
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Atividade/BS - Inser&ccedil;&atilde;o")%>
<form name="form_insert" action="Insert_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='insert.asp'>
	<div class="form_label">*Título:</div><input name="VAR_TITULO" type="text" style="width:300px">
	<br><div class="form_label">*Cliente:</div><input name="var_cod_cliente" type="text" value="<%=strCLIENTE%>" size="5" onKeyPress="validateNumKey();">&nbsp;<a href="#" onClick="JavaScript:AbreJanelaPAGE('BuscaPorEntidade.asp', '600', '350');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Situação:</div><select name="var_situacao" style="width:100px;">
													<option value="ABERTO" selected>ABERTO</option>
													<option value="FECHADO">FECHADO</option>
												</select>
	<br><div class="form_label">*Categoria:</div><select name="var_cod_e_desc_categoria" style="width:100px;" onChange="form_insert.var_equipe.value=';<%=strCOOKIE_ID_USUARIO%>';">
													<option value="" selected>[selecione]</option>
				<%
				strSQL = " SELECT COD_CATEGORIA, NOME FROM BS_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME "
				Set objRS = objConn.Execute(strSQL)
				
				Do While Not objRS.Eof
					Response.Write("<option value='" & GetValue(objRS,"COD_CATEGORIA") & " - " & GetValue(objRS,"NOME") & "'>")
					Response.Write(GetValue(objRS,"NOME") & "</option>")
					
					objRS.MoveNext
				Loop
				FechaRecordSet objRS
				%>
												</select>
	<br><div class="form_label">*Prioridade:</div><select name="var_prioridade" style="width:100px;">
													<option value="NORMAL" selected>NORMAL</option>
													<option value="BAIXA">BAIXA</option>
													<option value="MEDIA">MÉDIA</option>
													<option value="ALTA">ALTA</option>
												</select>
	<br><div class="form_label">*Responsável:</div><select name="var_id_responsavel" style="width:100px;">
				<option value="">[selecione]</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(Request.Cookies("VBOSS")("ID_USUARIO")))%> 
			</select>
	<br><div class="form_label">Equipe:</div><input name="var_equipe" type="text" value="<%=strEQUIPE%>" style="width:300px;">&nbsp;<a href="#" onClick="JavaScript:AbreJanelaPAGE('BuscaPorUsuario.asp', '600', '350');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
	<br><div class="form_label">Tipo:</div><select name="var_tipo" style="width:100px;">
												<option value="MODELO">MODELO</option>
												<option value="NORMAL" selected="selected">NORMAL</option>
											</select>
	<br><div class="form_label">*Tarefa:</div><textarea name="var_descricao" style="width:350px; height:160px;"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%	FechaDBConn objConn %>