<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_NF", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 600
WMD_WIDTHTTITLES = 110
' -------------------------------------------------------------------------------
Dim objConn, objRS, strSQL
Dim strCODCONTRATO, strENTTIPO, strENTCODIGO, strENTNOME, strCODCONTAPR, strNUMDOC, dblVLRCONTAPR
Dim strMSG

  strCODCONTAPR  = UCase(GetParam("var_chavereg"))
  AbreDBConn objConn, CFG_DB
  '--------------------------------------------------------
  ' Busca informações do titulo, contrato, entidade e etc..
  '--------------------------------------------------------
  strSQL =          " SELECT COD_CONTA_PAGAR_RECEBER"
  strSQL = strSQL & " ,PAGAR_RECEBER"
  strSQL = strSQL & " ,TIPO"
  strSQL = strSQL & " ,CODIGO"
  strSQL = strSQL & " ,VLR_CONTA"
  strSQL = strSQL & " ,NUM_DOCUMENTO"
  strSQL = strSQL & " ,SITUACAO"
  strSQL = strSQL & " ,COD_CONTRATO"
  strSQL = strSQL & " ,COD_NF"
  strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER"
  strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER=" & strCODCONTAPR
  AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
  'athDebug strSQL, true
  strMSG = ""
  if objRS.Eof then
    strMSG = "A Conta a Receber não foi localizada ou não existe mais."
  else
    if GetValue(objRS, "PAGAR_RECEBER") <> "0" then strMSG = "Operação não permitida. Só é possível emitir uma NF para contas a receber.<br>"
	'----------------------------------------------------------------------
	'Atualmente o módulo de NF só emite notas para a entidade CLIENTE.
	'Então validamos para não tentar emitir para outro tipo de entidade, 
	'porém recebemos todos os parametros necessários para posteriormente
	'(se for necessário) gerar NF de qualquer tipo de entidade.
	'By Vini - 29.01.2013
	'----------------------------------------------------------------------
	if UCase(GetValue(objRS, "TIPO")) <> "ENT_CLIENTE" then strMSG = strMSG & "Operação não permitida. Só é possível emitir uma NF para CLIENTES.<br>"
	if UCase(GetValue(objRS, "SITUACAO")) ="CANCELADA" then strMSG = strMSG & "Operação não permitida. A Conta Pagar/Receber está CANCELADA.<br>"
	if GetValue(objRS, "COD_NF") <> "" then strMSG = "Operação não permitida. Já existe uma NF emitida para esta conta pagar/receber.<br>"
  end if
  
  if strMSG <> "" then
    Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
  else	
    strENTTIPO     = GetValue(objRS, "TIPO")
    strENTCODIGO   = GetValue(objRS, "CODIGO")
    dblVLRCONTAPR  = GetValue(objRS, "VLR_CONTA")
	strNUMDOC      = GetValue(objRS, "NUM_DOCUMENTO")
    strCODCONTRATO = GetValue(objRS, "COD_CONTRATO")	

	FechaRecordSet objRS

	'monta sql para buscar nome/razao_social da entidade
    strSQL = " SELECT COD_CLIENTE, RAZAO_SOCIAL FROM ENT_CLIENTE WHERE COD_CLIENTE = " & strENTCODIGO
    AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

    'só deve abrir a pagina se a entidade for localizada
    if objRS.Eof then
      FechaRecordSet objRS
	  Mensagem "O cliente informado não foi identificado", "Javascript:history.back();", "Voltar", 1	  
    else
      strENTNOME = GetValue(objRS, "RAZAO_SOCIAL") 'pega a razao_social do cliente
	  FechaRecordSet objRS 'apos pegar o campo razao social fechamos o record set
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
//****** Funções de ação dos botões - Início ******
function ok() {
	document.form_insert.DEFAULT_LOCATION.value = "";
	submeterForm();
}

function cancelar() {
	parent.frames["vbTopFrame"].document.form_principal.submit();
}

function aplicar() {
	document.form_insert.JSCRIPT_ACTION.value = "";
	submeterForm();
}

function submeterForm() {
	var var_avisos = false;
	
	if (document.form_insert.var_cod_cli.value == "") {
		var_avisos = true;
		alert('Selecionar cliente.');
	}
	if (document.form_insert.var_cod_cfg_nf.value == "") {
		var_avisos = true;
		alert('Selecionar modelo de nota.');
	}
	
	if (var_avisos == false) {
		document.form_insert.submit();
	}
}

//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Emiss&atilde;o NF - Inser&ccedil;&atilde;o") %>
<table width="100%" border="0px" cellpadding="1px" cellspacing="0px">
	<form name="form_insert" action="InsertNFdeTitulo_Exec.asp" method="post">
      <input name="var_cod_conta_pag_rec" type="hidden" value="<%=strCODCONTAPR%>">	
      <input name="var_ent_tipo" type="hidden" value="<%=strENTTIPO%>">
      <input name="var_cod_cli" type="hidden" value="<%=strENTCODIGO%>">	
	  <input name="var_cli_nome" type="hidden" value="<%=strENTNOME%>">		
      <input name="var_cod_contrato" type="hidden" value="<%=strCODCONTRATO%>">
      <input name="var_vlr_conta_pag_rec" type="hidden" value="<%=dblVLRCONTAPR%>">
	  <input name="var_num_doc" type="hidden" value="<%=strNUMDOC%>">
	  <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	  <input type="hidden" name="DEFAULT_LOCATION" value='../modulo_FIN_FLUXOCAIXA/InsertNFdeTitulo.asp'>
	<tr> 
		<td width="<%=WMD_WIDTHTTITLES%>" style="text-align:right;"></td>
		<td>
			<!-- Desabilitei o combo pois esta opção no momento não pode ser diferente de CLIENTE - by Vini 20.11.2012 - copiado do modulo de NF //-->
			<select disabled="disabled" name="var_tipo" size="1" style="width:170px;"><% MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", "ENT_CLIENTE" %></select>
		</td>
	</tr>
	<tr> 
		<td style="text-align:right;">*Cliente:&nbsp;</td>
		<td><%=strENTCODIGO & " - " & strENTNOME%></td>
	</tr>
	<tr> 
		<td style="text-align:right;width:120px;">Data de Emissão:&nbsp;</td>
		<td>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td style="width:160px;" nowrap="nowrap"><%=InputDate("var_dt_emissao","",PrepData(Now,true,false),false)%>
			<a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form_update.var_dt_emissao);return false;">
			<img class="PopcalTrigger" align="absmiddle" src="../img/bullet_dataatual.gif" border="0" alt="" style="cursor:hand" title="ver calendário">
			</a><span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span></td>
			<td style="width:100px; text-align:right;" nowrap="nowrap">&nbsp;&nbsp;Prazo de Vcto:&nbsp;</td>
			<td><input name="var_prz_vcto" type="text" size="6" maxlength="4" value="" onKeyPress="validateNumKey();"></td>
		</tr>
		</table>
	</tr>
	<tr>
		<td style="text-align:right;">*Modelo:&nbsp;</td>
		<td>
		<select name="var_cod_cfg_nf" size="1" style="width:200px;">
		<% montaCombo "STR", " SELECT COD_CFG_NF, DESCRICAO FROM CFG_NF WHERE DT_INATIVO IS NULL ORDER BY ORDEM, DESCRICAO ", "COD_CFG_NF", "DESCRICAO", "" %>
		</select>
		</td>
	</tr>
	<tr>
		<td style="text-align:right;" valign="top">Observa&ccedil;&atilde;o:&nbsp;</td>
		<td><textarea name="var_obs_nf" rows="5" style="width:365px;"></textarea></td>
	</tr>
	</td>
	</form>
</table>
<div class="texto_ajuda" style="padding-left:30px; font-style:italic;">
	Campos com <span style="font:8px; vertical-align:middle; width:10px;">&nbsp;*</span> são obrigatórios
</div>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<% 
'If strABERTURA = "EXTERNA" Then 
'	athEndDialog WMD_WIDTH, "../img/bt_save.gif", "Javascript:Verifica();", "../img/bt_cancelar.gif", "window.close();", "", "" 
'Else
'	athEndDialog WMD_WIDTH, "../img/bt_save.gif", "Javascript:Verifica();", "../img/bt_cancelar.gif", "history.go(-1);", "", "" 
'End If
%>
<iframe name="gToday:normal:agenda.js" id="gToday:normal:agenda.js"
        src="../_calendar/source/ipopeng.htm" scrolling="no" frameborder="0"
        style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe>
</body>
</html>
<%
    end if  
  end if
  FechaDBConn objConn
%>