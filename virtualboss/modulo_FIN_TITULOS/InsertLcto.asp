<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim objConn, objRS, objRSa, strSQL
Dim strTIPO_CONTA, strTITLE 
Dim strLABEL_ENT
Dim strLABEL_COR
Dim strCOD_CONTA_PAGAR_RECEBER, strVLR_LCTO
Dim strENTIDADE, strCODEnt, strVAR_CODIGO, strVLR_ORIG
Dim strMSG, strVLR_TOTAL_LCTO
Dim strVLR_TOTAL_DESC, strVLR_TOTAL_MULTA
Dim strVLR_TOTAL_JUROS, strVLR_TOTAL_PAGO
Dim strVLR_TOTAL_DEBITO
Dim strDIA, strMES, strANO
Dim strINS_LCTO_NO_MES

strCOD_CONTA_PAGAR_RECEBER = GetParam("var_chavereg")

strDIA = DatePart("D", Date)
strMES = DatePart("M", Date)
strANO = DatePart("YYYY", Date)

strINS_LCTO_NO_MES = "F"
If VerificaDireito("|INS_NO_MES|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
	strINS_LCTO_NO_MES = "T"
End If

if strCOD_CONTA_PAGAR_RECEBER <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" 								&_	
				"	T1.COD_CONTA_PAGAR_RECEBER,"		&_	
				"	T1.TIPO," 							&_
				"	T1.CODIGO," 						&_
				"	T1.DT_EMISSAO," 					&_
				"	T1.HISTORICO,"						&_
				"	T1.TIPO_DOCUMENTO,"					&_
				"	T1.NUM_DOCUMENTO," 					&_
				"	T1.PAGAR_RECEBER," 					&_
				"	T1.DT_VCTO,"	 					&_
				"	T1.VLR_CONTA," 	 					&_
				"	T2.COD_CONTA," 						&_
				"	T2.NOME AS CONTA," 					&_
				"	T1.SITUACAO,"						&_
				"	T1.OBS,"							&_				
				"	T3.NOME AS PLANO_CONTA," 			&_
				"	T3.COD_PLANO_CONTA," 				&_
				"	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO," &_
				"	T4.COD_CENTRO_CUSTO," 				&_
				"	T4.NOME AS CENTRO_CUSTO," 			&_
				"	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO, " &_
				"	T1.ARQUIVO_ANEXO " 					&_
				"FROM" 									&_
				"	FIN_CONTA_PAGAR_RECEBER AS T1,"		&_
				"	FIN_CONTA AS T2," 					&_
				"	FIN_PLANO_CONTA AS T3,"				&_
				"	FIN_CENTRO_CUSTO AS T4 " 			&_
				"WHERE"									&_
				"	T1.COD_CONTA = T2.COD_CONTA AND"	&_
				"	T1.COD_PLANO_CONTA = T3.COD_PLANO_CONTA AND"	&_
				"	T1.COD_CENTRO_CUSTO = T4.COD_CENTRO_CUSTO AND" 	&_
				"	T1.COD_CONTA_PAGAR_RECEBER=" &  strCOD_CONTA_PAGAR_RECEBER
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	

	if not objRS.Eof then				 
		if GetValue(objRS,"VLR_CONTA")<>"" then strVLR_LCTO = FormataDecimal(GetValue(objRS,"VLR_CONTA"),2)

		strSQL=""					 
		strCODEnt = GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO")="ENT_CLIENTE"     and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE		WHERE COD_CLIENTE     =" & strCODEnt
		if GetValue(objRS,"TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR  =" & strCODEnt
		if GetValue(objRS,"TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME                  FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & strCODEnt
		
		strENTIDADE=""
		if strSQL<>"" then
			AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
			if not objRSa.Eof then strENTIDADE = GetValue(objRSa, "NOME")
			FechaRecordSet objRSa
		end if
		
		strVAR_CODIGO = GetValue(objRS,"CODIGO") 		
		strVLR_ORIG = FormataDecimal(strVLR_LCTO,2)
		
		'-------------------------------
		'Verifica situação da conta
		'-------------------------------
		strMSG = ""
		If GetValue(objRS,"SITUACAO") = "CANCELADA"  Then strMSG = "Conta encontra-se CANCELADA!"
		If GetValue(objRS,"SITUACAO") = "LCTO_TOTAL" Then strMSG = "Conta encontra-se QUITADA!"
		
		If strMSG <> "" Then
			Mensagem strMSG, "Javascript:history.back();","Voltar", 1
			Response.End()
		End If
		
		'-------------------------------------------------------
		'Busca os totais já lançados e calcula o débito total
		'-------------------------------------------------------
		strSQL =          " SELECT SUM(VLR_LCTO)  AS VLR_TOTAL_LCTO "
		strSQL = strSQL & "      , SUM(VLR_DESC)  AS VLR_TOTAL_DESC "
		strSQL = strSQL & "      , SUM(VLR_MULTA) AS VLR_TOTAL_MULTA "
		strSQL = strSQL & "      , SUM(VLR_JUROS) AS VLR_TOTAL_JUROS "
		strSQL = strSQL & " FROM FIN_LCTO_ORDINARIO "
		strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_PAGAR_RECEBER
		strSQL = strSQL & " AND SYS_DT_CANCEL IS NULL "
		
		Set objRSa = objConn.Execute(strSQL)
		
		strVLR_TOTAL_LCTO  = 0 
		strVLR_TOTAL_DESC  = 0 
		strVLR_TOTAL_MULTA = 0 
		strVLR_TOTAL_JUROS = 0 
		
		If Not objRSa.Eof Then
			strVLR_TOTAL_LCTO  = GetValue(objRSa,"VLR_TOTAL_LCTO") 
			strVLR_TOTAL_DESC  = GetValue(objRSa,"VLR_TOTAL_DESC") 
			strVLR_TOTAL_MULTA = GetValue(objRSa,"VLR_TOTAL_MULTA") 
			strVLR_TOTAL_JUROS = GetValue(objRSa,"VLR_TOTAL_JUROS") 
		End If 
		
		If strVLR_TOTAL_LCTO  = "" Or Not IsNumeric(strVLR_TOTAL_LCTO)  Then strVLR_TOTAL_LCTO  = 0
		If strVLR_TOTAL_DESC  = "" Or Not IsNumeric(strVLR_TOTAL_DESC)  Then strVLR_TOTAL_DESC  = 0
		If strVLR_TOTAL_MULTA = "" Or Not IsNumeric(strVLR_TOTAL_MULTA) Then strVLR_TOTAL_MULTA = 0
		If strVLR_TOTAL_JUROS = "" Or Not IsNumeric(strVLR_TOTAL_JUROS) Then strVLR_TOTAL_JUROS = 0
		
		FechaRecordSet objRSa
		
		strVLR_TOTAL_PAGO = strVLR_TOTAL_LCTO + strVLR_TOTAL_DESC - strVLR_TOTAL_MULTA - strVLR_TOTAL_JUROS
		strVLR_TOTAL_PAGO = FormataDecimal(strVLR_TOTAL_PAGO,2)
		
		strVLR_TOTAL_DEBITO = strVLR_ORIG - strVLR_TOTAL_PAGO
		If strVLR_TOTAL_DEBITO = "" Or Not IsNumeric(strVLR_TOTAL_DEBITO) Then strVLR_TOTAL_DEBITO = 0
		strVLR_TOTAL_DEBITO = FormataDecimal(strVLR_TOTAL_DEBITO,2)		
		
		if GetValue(objRS,"PAGAR_RECEBER") <> "0" then
			strTITLE = "Pagar"
			'strLABEL_ENT = "Pagar para"
			strLABEL_ENT = "PAGAR"
			strLABEL_COR = "color:#FF0000;" 'vermelho
		else
			strTITLE = "Receber"
			'strLABEL_ENT = "Receber de"
			strLABEL_ENT = "RECEBER"
			strLABEL_COR = "color:#03A103;" 'verde		
		end if 	
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
//****** Funções de ação dos botões - Fim ******

function BuscaEntidade() {
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input=var_codigo&var_input_tipo=var_tipo&var_tipo=' + document.form_insert.var_tipo.value, '640', '390');
}

function Verifica(prDiaHoje, prMesHoje, prAnoHoje, prInsLctoNoMes) {
	var var_msg = '';
	var var_vlr_orig, var_vlr_multa, var_vlr_juros, var_vlr_desc, var_vlr_lcto;
	var arrData, var_dt_lcto;
	var MesLcto, AnoHoje, AnoLcto;
	
	if (document.form_insert.var_chavereg.value == '') var_msg += '\nParâmetro inválido para conta pagar e receber';
	if ((document.form_insert.var_tipo_conta.value != 'PAGAR') && (document.form_insert.var_tipo_conta.value != 'RECEBER')) var_msg += '';
	if (document.form_insert.var_cod_conta.value == '') var_msg += '\nParâmetro inválido para conta';
	if ((document.form_insert.var_codigo.value == '') || (document.form_insert.var_tipo.value == '')) var_msg += '\nInformar entidade';
	if (document.form_insert.var_cod_centro_custo.value == '') var_msg += '\nInformar centro de custo';
	if (document.form_insert.var_cod_plano_conta.value == '') var_msg += '\nInformar plano de conta';
	if (document.form_insert.var_num_lcto.value == '') var_msg += '\nInformar número do lançamento';
	//if (document.form_insert.var_historico.value == '') var_msg += '\nInformar histórico';
	if (document.form_insert.var_dt_lcto.value == '') var_msg += '\nInformar data do lançamento';
	
	if (document.form_insert.var_dt_lcto.value != '') {
		arrData = document.form_insert.var_dt_lcto.value;
		arrData = arrData.split("/");
		
		DiaLcto = arrData[0];
		MesLcto = arrData[1];
		AnoLcto = arrData[2];
		
		DiaLcto = Number(DiaLcto);
		MesLcto = Number(MesLcto);
		AnoLcto = Number(AnoLcto);
		
		prDiaHoje = Number(prDiaHoje);
		prMesHoje = Number(prMesHoje);
		prAnoHoje = Number(prAnoHoje);
		
		if ((AnoLcto > prAnoHoje) || ((MesLcto > prMesHoje) && (AnoLcto == prAnoHoje)) || ((DiaLcto > prDiaHoje) && (MesLcto == prMesHoje) && (AnoLcto == prAnoHoje))) 
			var_msg += '\nNão é permitido lançamento com data futura (' + document.form_insert.var_dt_lcto.value + ')';
		//Se tiver direito INS_NO_MES é porque só pode inserir no mês corrente
		if (prInsLctoNoMes == 'T') 
			if (((MesLcto != prMesHoje) && (AnoLcto == prAnoHoje)) || (AnoLcto != prAnoHoje)) 
				var_msg += '\nNão é permitido lançamento fora do mês corrente (' + document.form_insert.var_dt_lcto.value + ')';
	}
	if ((!document.form_insert.var_documento_din.checked) && (!document.form_insert.var_documento_ch.checked) && (!document.form_insert.var_documento_cartao.checked) && (!document.form_insert.var_documento_pgto_eletr.checked) && (!document.form_insert.var_documento_transf_eletr.checked)) var_msg += '\nInformar documento do lançamento';
	if (document.form_insert.var_documento_ch.checked) {
		if (document.form_insert.var_cheque_numero.value == '') var_msg += '\nInformar número do cheque';
	}
	if ((document.form_insert.var_documento_cartao.checked) && ((document.form_insert.var_cartao_numero.value == '') || (document.form_insert.var_cartao_validade.value == '') || (document.form_insert.var_cartao_portador.value == ''))) var_msg += '\nInformar todos os dados do cartão de crédito';
	
	if (document.form_insert.var_vlr_orig.value != '') {
		var_vlr_orig = eval("document.form_insert.var_vlr_orig.value");
		var_vlr_orig = var_vlr_orig.toString();
		var_vlr_orig = var_vlr_orig.replace(',', '.');
		
		if (var_vlr_orig <= 0) var_msg += '\nParâmetro inválido para o valor original';
	}
	if (document.form_insert.var_vlr_multa.value != '') {
		var_vlr_multa = eval("document.form_insert.var_vlr_multa.value");
		var_vlr_multa = var_vlr_multa.toString();
		var_vlr_multa = var_vlr_multa.replace(',', '.');
		
		if (var_vlr_multa < 0) var_msg += '\nInformar valor válido para multa';
	}
	if (document.form_insert.var_vlr_juros.value != '') {
		var_vlr_juros = eval("document.form_insert.var_vlr_juros.value");
		var_vlr_juros = var_vlr_juros.toString();
		var_vlr_juros = var_vlr_juros.replace(',', '.');
		
		if (var_vlr_juros < 0) var_msg += '\nInformar valor válido para juros';
	}
	if (document.form_insert.var_vlr_desc.value != '') {
		var_vlr_desc = eval("document.form_insert.var_vlr_desc.value");
		var_vlr_desc = var_vlr_desc.toString();
		var_vlr_desc = var_vlr_desc.replace(',', '.');
		
		if (var_vlr_desc < 0) var_msg += '\nInformar valor válido para desconto';
	}
	/*
	if (document.form_insert.var_vlr_lcto.value != '') {
		var_vlr_lcto = eval("document.form_insert.var_vlr_lcto.value");
		var_vlr_lcto = var_vlr_lcto.toString();
		var_vlr_lcto = var_vlr_lcto.replace(',', '.');
		
		if (var_vlr_lcto <= 0) var_msg += '\nInformar valor válido para lançamento';
	}
	else {
		var_msg += '\nInformar valor válido para lançamento';
	}*/
	//Passamos a permitir zero no valor de lançamento. By Lumertz - 09/11/2012
    if ((document.form_insert.var_vlr_lcto.value.replace(' ','')) == '') {	
		var_msg += '\nInformar valor válido para lançamento';
	}			
	if (var_msg == '') {
		return true;
	}
	else {
		alert('Verificar mensagem(ns) abaixo:\n' + var_msg);
		return false;
	}
}

function submeterForm() {
	var var_msg;
	var var_vlr_orig, var_vlr_lcto, var_vlr_desc, var_vlr_pago, var_vlr_difer1, var_vlr_difer2;
	
	if (Verifica('<%=strDIA%>', '<%=strMES%>', '<%=strANO%>', '<%=strINS_LCTO_NO_MES%>')) {
		var_vlr_orig = eval("document.form_insert.var_vlr_orig.value");
		var_vlr_lcto = eval("document.form_insert.var_vlr_lcto.value");
		var_vlr_desc = eval("document.form_insert.var_vlr_desc.value");
		var_vlr_pago = eval("document.form_insert.var_vlr_pago.value");
		
		var_vlr_orig = var_vlr_orig.toString();
		var_vlr_lcto = var_vlr_lcto.toString();
		var_vlr_desc = var_vlr_desc.toString();
		var_vlr_pago = var_vlr_pago.toString();
		
		var_vlr_orig = var_vlr_orig.replace('.', '');
		var_vlr_lcto = var_vlr_lcto.replace('.', '');
		var_vlr_desc = var_vlr_desc.replace('.', '');
		var_vlr_pago = var_vlr_pago.replace('.', '');
		
		var_vlr_orig = var_vlr_orig.replace(',', '.');
		var_vlr_lcto = var_vlr_lcto.replace(',', '.');
		var_vlr_desc = var_vlr_desc.replace(',', '.');
		var_vlr_pago = var_vlr_pago.replace(',', '.');
		
		document.form_insert.var_vlr_restante_desc.value = 0;
		var_vlr_difer1 = var_vlr_orig - var_vlr_pago - var_vlr_lcto - var_vlr_desc;
		if (var_vlr_difer1 > 0) {
			//var_vlr_difer2 = roundNumber(var_vlr_difer1, 2);
			//var_vlr_difer2 = var_vlr_difer2.toString();
			//var_vlr_difer2 = var_vlr_difer2.replace('.', ',');
			
			//var_msg = 'Deseja lançar a diferença de R$ ' + var_vlr_difer2 + ' como desconto de forma automática?\n\nClique Ok para Sim\nClique Cancelar para Não';
			//if (confirm(var_msg)) {
			//	document.form_insert.var_vlr_restante_desc.value = var_vlr_difer1;
			//}
			alert('Título continua em aberto após este lançamento.');
		}
		
		document.form_insert.submit();
	}
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Lançamento em Conta - Inserção")%>
<form name="form_insert" action="../modulo_FIN_TITULOS/InsertLcto_Exec.asp" method="post">
	<input type="hidden" name="var_chavereg"			value="<%=strCOD_CONTA_PAGAR_RECEBER%>">
	<input type="hidden" name="var_tipo_conta"			value="<%=UCase(strTITLE)%>">
	<input type="hidden" name="var_vlr_orig" 			value="<%=strVLR_ORIG%>">
	<input type="hidden" name="var_vlr_pago" 			value="<%=strVLR_TOTAL_PAGO%>">
	<input type="hidden" name="var_vlr_restante_desc"	value="">
	<input type="hidden" name="JSCRIPT_ACTION"		    value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION"		value='../modulo_FIN_TITULOS/InsertLcto.asp?var_chavereg=<%=strCOD_CONTA_PAGAR_RECEBER%>'>
	<div class="form_grupo_collapse" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" style="cursor:pointer;">
		<b>Dados da Conta a <%=strTITLE%></b><br>
		<br><div class="form_label">Código:</div><div class="form_bypass"><%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%></div>
		<br><div class="form_label"><%=strLABEL_ENT%>:</div><div class="form_bypass"><%=CStr(strCODEnt) & " - " & strENTIDADE%></div>
		<br><div class="form_label">Conta:</div><div class="form_bypass"><%=GetValue(objRS,"CONTA")%></div>
		<br><div class="form_label">Plano de Conta:</div><div class="form_bypass"><% 
			Response.Write(GetValue(objRS,"PLANO_CONTA"))
			if GetValue(objRS,"PLANO_CONTA_COD_REDUZIDO")<>"" then Response.Write("&nbsp;&nbsp;&nbsp;" & GetValue(objRS,"PLANO_CONTA_COD_REDUZIDO"))
		%></div>
		<br><div class="form_label">Centro de Custo:</div><div class="form_bypass"><% 
			Response.Write(GetValue(objRS,"CENTRO_CUSTO"))
			if GetValue(objRS,"CENTRO_CUSTO_COD_REDUZIDO")<>"" then Response.Write("&nbsp;&nbsp;&nbsp;" & GetValue(objRS, "CENTRO_CUSTO_COD_REDUZIDO"))
		%></div>
		<br><div class="form_label">Valor:</div><div class="form_bypass"><%=strVLR_LCTO%></div>
		<br><div class="form_label">Tipo Documento:</div><div class="form_bypass"><%
			if GetValue(objRS,"TIPO_DOCUMENTO") = "BOLETO"           then Response.Write("Boleto")
			if GetValue(objRS,"TIPO_DOCUMENTO") = "CHEQUE"           then Response.Write("Cheque")
			if GetValue(objRS,"TIPO_DOCUMENTO") = "DUPLICATA"        then Response.Write("Duplicata")
			if GetValue(objRS,"TIPO_DOCUMENTO") = "FATURA"           then Response.Write("Fatura")
			if GetValue(objRS,"TIPO_DOCUMENTO") = "NOTA_PROMISSORIA" then Response.Write("Nota Promissória") 
		%></div>
		<br><div class="form_label">Número:</div><div class="form_bypass"><%=GetValue(objRS, "NUM_DOCUMENTO")%></div>
		<br><div class="form_label">Data Emissão:</div><div class="form_bypass"><%=PrepData(GetValue(objRS,"DT_EMISSAO"),true,false)%></div>
		<br><div class="form_label">Data Vcto:</div><div class="form_bypass"><%=PrepData(GetValue(objRS,"DT_VCTO"),true,false)%></div>
		<br><div class="form_label">Histórico:</div><div class="form_bypass"><%=GetValue(objRS, "HISTORICO")%></div>
		<br><div class="form_label">Situação:</div><div class="form_bypass"><%
			If GetValue(objRS,"SITUACAO") = "ABERTA" Then Response.Write("Aberta")
			If GetValue(objRS,"SITUACAO") = "LCTO_PARCIAL" Then Response.Write("Parcial")
			If GetValue(objRS,"SITUACAO") = "LCTO_TOTAL" Then Response.Write("Quitada")
			If GetValue(objRS,"SITUACAO") = "CANCELADA" Then Response.Write("Cancelada")
		%></div>
		<br><div class="form_label">Arquivo Anexo:</div><div class="form_bypass"><%
			If GetValue(objRS,"ARQUIVO_ANEXO") <> "" Then
				Response.Write("<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/FIN_Titulos/" & GetValue(objRS,"ARQUIVO_ANEXO") & "' target='_blank'>" & GetValue(objRS,"ARQUIVO_ANEXO") & "</a>")
			End If
		%></div>
		<br><div class="form_label">Observação:</div><div class="form_bypass"><%=GetValue(objRS, "OBS")%></div>
	</div>
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Dados do Lançamento</b><br>
		<br><div class="form_label"></div><div class="form_bypass"><font style="<%=strLABEL_COR%>"><b><%=strLABEL_ENT%></b></font></div>
		 	<!-- Achamos que um lançamento não deve poder ser para uma entidade diferente do título, 
				 por isso tornamos os combo e o input invisível. Como a modelagem tem o CODO e TIPO 
				 no Lct então os objetos continuam existando e pasasndo seus valores via formulário 
				 para _exec que os provcessa normalemente. by Aless 17/01/2011 -->
			<div style="display:none">
						<input name="var_codigo" type="text" maxlength="10" value="<%=strVAR_CODIGO%>" onKeyPress="validateNumKey();" style="vertical-align:bottom; width:40px;">
						<select name="var_tipo" size="1" style="width:181px;">
							<%=MontaCombo("STR","SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ","TIPO","DESCRICAO",GetValue(objRS,"TIPO"))%>
						</select>
						<a href="Javascript://;" onClick="Javascript://BuscaEntidade();" style="display:none">
							<img src="../img/BtBuscar.gif"border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0">
						</a> 
			</div>
			<!-- ******************************************************************************** -->
		<br><div class="form_label">*Conta:</div><select name="var_cod_conta" style="width:230px;">
				<%
				strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
				strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
				strSQL = strSQL & " ORDER BY NOME "
				
				Set objRSa = objConn.Execute(strSQL)
				
				Do While Not objRSa.Eof
					Response.Write("<option value='" & GetValue(objRSa, "COD_CONTA") & "'")
					If CStr(GetValue(objRS, "COD_CONTA")) = CStr(GetValue(objRSa, "COD_CONTA")) Then Response.Write(" selected")
					Response.Write(">" & GetValue(objRSa, "NOME") & "</option>")
					
					objRSa.MoveNext
				Loop
				
				FechaRecordSet objRSa
				%>
			</select>
		<br><div class="form_label">*Plano de Conta:</div><select name="var_cod_plano_conta" style="width:230px;">
							<%
							strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 
							strSQL = strSQL & " FROM FIN_PLANO_CONTA T1 " 
							strSQL = strSQL & " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_PLANO_CONTA=T2.COD_PLANO_CONTA) "
							strSQL = strSQL & " WHERE T1.DT_INATIVO IS NULL " 
							'strSQL = strSQL & " AND ((T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_PLANO_CONTA = " & GetValue(objRS, "COD_PLANO_CONTA") & ")) " 
							strSQL = strSQL & " ORDER BY 2 " 
							Set objRSa = objConn.Execute(stRSQL)
							
							Do While Not objRSa.Eof
								Response.Write("<option value='" & GetValue(objRSa, "COD_PLANO_CONTA") & "'")
								If CStr(GetValue(objRS,"COD_PLANO_CONTA")) = CStr(GetValue(objRSa, "COD_PLANO_CONTA")) Then Response.Write(" selected")
								Response.Write(">")
								If GetValue(objRSa, "COD_REDUZIDO") <> "" Then Response.Write(GetValue(objRSa, "COD_REDUZIDO") & " ")
								Response.Write(GetValue(objRSa, "NOME") & "</option>")
								
								objRSa.MoveNext
							Loop
							FechaRecordSet objRSa
							%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('../modulo_FIN_TITULOS/BuscaPlanoConta.asp?var_form=form_insert&var_retorno1=var_cod_plano_conta', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
		<br><div class="form_label">*Centro de Custo:</div><%
							strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME " 
							strSQL = strSQL & " FROM FIN_CENTRO_CUSTO T1 " 
							strSQL = strSQL & " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) " 
							strSQL = strSQL & " WHERE T1.DT_INATIVO IS NULL " 
							'strSQL = strSQL & " AND ((T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_CENTRO_CUSTO = " & GetValue(objRS, "COD_CENTRO_CUSTO") & ")) " 
							strSQL = strSQL & " ORDER BY 2 "
						%><select name="var_cod_centro_custo" style="width:230px;">
							<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME",GetValue(objRS,"COD_CENTRO_CUSTO"))%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('../modulo_FIN_TITULOS/BuscaCentroCusto.asp?var_form=form_insert&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
		<br><div class="form_label">Valor Original:</div><div class="form_bypass"><%=strVLR_ORIG%></div>
		<br><div class="form_label">Valor Já Pago:</div><div class="form_bypass"><%=strVLR_TOTAL_PAGO%></div>
		<br><div class="form_label">Valor Débito:</div><div class="form_bypass"><%=strVLR_TOTAL_DEBITO%></div>
		<br><div class="form_label">Valor Multa:</div><input name="var_vlr_multa" maxlength="12" type="text" style="width:80px;" onKeyPress="validateFloatKey();">
		<br><div class="form_label">Valor Juros:</div><input name="var_vlr_juros" maxlength="12" type="text" style="width:80px;" onKeyPress="validateFloatKey();">
		
		<br><div class="form_label">Valor Desconto:</div><input name="var_vlr_desc" maxlength="12" type="text" style="width:80px;" onKeyPress="validateFloatKey();"><!--<span class="texto_ajuda"><i>Para lcto. a desconto digite o valor do título</i></span>-->				
		
		<br><div class="form_label">Valor Lançamento:</div><input name="var_vlr_lcto" maxlength="12" type="text" style="width:80px;" onKeyPress="validateFloatKey();" value="<%=strVLR_TOTAL_DEBITO%>"><!--<span class="texto_ajuda"><i>Para lcto. a desconto digite zero.</i></span>-->				 		
		
		<br><div class="form_label"></div><span class="texto_ajuda"><i>Para lançamento de título a desconto, o Valor Desconto deve ser igual o valor</i></span>
		<br><div class="form_label"></div><span class="texto_ajuda"><i>do título e o Valor do Lançamento deve ser zero.</i></span>				
			
		<br><div class="form_label">*Número:</div><input name="var_num_lcto" type="text" maxlength="50" value="<%=GetValue(objRS,"NUM_DOCUMENTO")%>" style="width:155px;">
		<br><div class="form_label">*Data:</div><%=InputDate("var_dt_lcto","",GetValue(objRS,"DT_VCTO"),false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_lcto", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
		<br><div class="form_label">Histórico:</div><input name="var_historico" type="text" maxlength="50" value="<%=GetValue(objRS,"HISTORICO")%>" style="width:280px;">
		<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="6" style="width:280px;"></textarea>
	</div>
	<div class="form_grupo_collapse" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
  		style="cursor:pointer;">
		<b>Dados do Documento</b><br>
		<br><div class="form_label"></div>
		<div class="form_bypass">
				<input name="var_documento" id="var_documento_din" type="radio" class="inputclean" checked value="DINHEIRO">Dinheiro
			<br><input name="var_documento" id="var_documento_ch" type="radio" class="inputclean" value="CHEQUE">Cheque
			<br><div class="form_label_nowidth" style="width:55px; text-align:left;">*Número:</div><input name="var_cheque_numero" type="text" maxlength="50" style="width:105px;">
			<br><input name="var_documento" id="var_documento_cartao" type="radio" class="inputclean" value="CARTAO_CREDITO">Cartão de Crédito
			<br><div class="form_label_nowidth" style="width:55px; text-align:left;">*Número:</div><input name="var_cartao_numero" type="text" maxlength="50" style="width:70px;"><span class="texto_ajuda"><i>Últimos 4 números</i></span>
			<br><div class="form_label_nowidth" style="width:55px; text-align:left;">*Validade:</div><input name="var_cartao_validade" type="text" maxlength="50" style="width:70px;"><span class="texto_ajuda"><i>mm/aaaa</i></span>
			<br><div class="form_label_nowidth" style="width:55px; text-align:left;">*Portador:</div><input name="var_cartao_portador" type="text" maxlength="50" style="width:225px;">
			<br>&nbsp;
		</div>
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
	end if
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>