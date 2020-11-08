<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Dim objConn, objRS, objRSa, objRSb, objRSc, strSQL
 Dim strCOD_CONTA_PAGAR_RECEBER, strVLR_LCTO
 Dim strENTIDADE, strCODEnt, strTITLE
 Dim strCOLOR, strDIA, strMES, strANO 
 Dim strINS_LCTO_NO_MES
 Dim strCODIGOS, bDel, bUpd
 
 strINS_LCTO_NO_MES = "F"
 If VerificaDireito("|INS_NO_MES|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
	strINS_LCTO_NO_MES = "T"
 End If
 
 bDel = VerificaDireito("|DEL|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), false)
 bUpd = VerificaDireito("|UPD|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), false)
 
 strCOD_CONTA_PAGAR_RECEBER = GetParam("var_chavereg")
 
 'Coleta variáveis para testar campos do FORM INSERT LCTO
 strDIA = DatePart("D", Date)
 strMES = DatePart("M", Date)
 strANO = DatePart("YYYY", Date)			
 
 if strCOD_CONTA_PAGAR_RECEBER <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT"											&_
				"	T1.COD_CONTA_PAGAR_RECEBER "					&_
				",	T1.TIPO "										&_
				",	T1.CODIGO "										&_
				",	T1.DT_EMISSAO "									&_
				",	T1.HISTORICO "									&_
				",	T1.TIPO_DOCUMENTO "								&_
				",	T1.NUM_DOCUMENTO "								&_
				",	T1.PAGAR_RECEBER "								&_
				",	T1.DT_VCTO "									&_
				",	T1.VLR_CONTA "									&_
				",	T2.NOME AS CONTA "								&_
				",	T1.SITUACAO "									&_
				",	T1.OBS "										&_
				",	T3.NOME AS PLANO_CONTA "						&_
				",	T3.COD_PLANO_CONTA "							&_
				",	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO "	&_
				",	T4.NOME AS CENTRO_CUSTO "						&_
				",	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO "	&_
				",	T1.ARQUIVO_ANEXO "								&_
				",	T5.COD_CONTA_TAXAS "							&_
				",	T5.VLR_BASE " 									&_
				",	T5.TOTAL_IRRF "									&_
				",	T5.TOTAL_PIS "									&_
				",	T5.TOTAL_COFINS "								&_
				",	T5.TOTAL_CSOCIAL "								&_
				",	T5.TOTAL_IRPJ "									&_
				",	T5.TOTAL_ISSQN "								&_
				",	T5.TOTAL_IMPOSTOS "								&_
				",	T5.TOTAL_REDUCAO "								&_
				",	T5.VLR_FINAL "									&_
				",	T5.COD_ACUM_IRRF "								&_
				",	T5.COD_ACUM_REDUCAO "							&_
				",	T5.TOTAL_ACUM_IRRF "							&_
				",	T5.TOTAL_ACUM_REDUCAO "							&_
				",	T5.SYS_DT_CRIACAO AS SYS_DT_CRIACAO_TAXAS "		&_
				",	T5.SYS_COD_USER_CRIACAO AS SYS_COD_USER_CRIACAO_TAXAS "	&_
				"FROM FIN_CONTA_PAGAR_RECEBER AS T1 "				&_
				"LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) " &_
				"LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) " &_
				"LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	&_
				"LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER_TAXAS AS T5 ON (T1.COD_CONTA_PAGAR_RECEBER=T5.COD_CONTA_PAGAR_RECEBER) " &_
				"WHERE T1.COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_PAGAR_RECEBER
	
	'response.Write(strSQL)
	'response.End()
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
		if GetValue(objRS,"VLR_CONTA")<>"" then strVLR_LCTO = FormataDecimal(GetValue(objRS,"VLR_CONTA"),2)
		strSQL=""					 
		strCODEnt = GetValue(objRS,"CODIGO")

		if GetValue(objRS,"TIPO")="ENT_CLIENTE"	    and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE WHERE COD_CLIENTE =" & strCODEnt
		if GetValue(objRS,"TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR =" & strCODEnt
		if GetValue(objRS,"TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & strCODEnt
		
		strENTIDADE=""
		if strSQL<>"" then
			AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
			if not objRSa.Eof then strENTIDADE = GetValue(objRSa, "NOME")
			FechaRecordSet objRSa
		end if
		
		if GetValue(objRS,"PAGAR_RECEBER") <> "0" then
			strTITLE = "Conta a Pagar "
		else
			strTITLE = "Conta a Receber "
		end if
		
		strSQL = "SELECT" &_
					"	ORD.COD_LCTO_ORDINARIO," &_
					"	ORD.COD_CONTA_PAGAR_RECEBER,"	&_
					"	CTA.NOME AS CONTA,"				&_
					"	PLN.NOME AS PL_CONTA," 	&_
					"	CST.NOME AS CT_CUSTO," 	&_
					"	ORD.HISTORICO,"	&_
					"	ORD.NUM_LCTO," 	&_
					"	ORD.DT_LCTO," 	&_
					"	ORD.VLR_LCTO "	&_
					"FROM " 	&_
					"	FIN_LCTO_ORDINARIO ORD " &_
					"INNER JOIN" 	&_
					"	FIN_CONTA CTA ON (ORD.COD_CONTA=CTA.COD_CONTA) " &_
					"INNER JOIN" 	&_
					"	FIN_CENTRO_CUSTO CST ON (ORD.COD_CENTRO_CUSTO=CST.COD_CENTRO_CUSTO) " 	&_
					"INNER JOIN" 	&_
					"	FIN_PLANO_CONTA PLN ON (ORD.COD_PLANO_CONTA=PLN.COD_PLANO_CONTA) " 		&_
					"INNER JOIN" 	&_
					"	FIN_CONTA_PAGAR_RECEBER PR ON (ORD.COD_CONTA_PAGAR_RECEBER=PR.COD_CONTA_PAGAR_RECEBER) " &_
					"WHERE " 		&_
					"	ORD.COD_CONTA_PAGAR_RECEBER=" & strCOD_CONTA_PAGAR_RECEBER & " AND " &_
					"	ORD.SYS_DT_CANCEL IS NULL AND ORD.SYS_COD_USER_CANCEL IS NULL "	&_
					"ORDER BY" 		&_
					"	ORD.DT_LCTO" 
		AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
%>
<html>
<head>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
<script>
/****** Funções de ação dos botões - Início ******/
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
/****** Funções de ação dos botões - Fim ******/

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
	if (document.form_insert.var_historico.value == '') var_msg += '\nInformar histórico';
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
	/*if (document.form_insert.var_vlr_lcto.value != '') {
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
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "TITULO <strong>" & strCOD_CONTA_PAGAR_RECEBER & "</strong>", "", 0
	athEndCssMenu("")
%>
<div id="table_header">
	<table align="center" cellpadding="0" cellspacing="1" class="tableheader">
	 <!-- Possibilidades de tipo de sort...
	  class="sortable-date-dmy"
	  class="sortable-currency"
	  class="sortable-numeric"
	  class="sortable"
	 -->
	 <!--thead> 
		<tr>
		  <th width="150"></th>
		  <th>Título</th>
		</tr>
	 </thead-->
	 <tbody style="text-align:left;">
		<tr><td align="right">Conta:</td><td><%=GetValue(objRS,"CONTA")%></td></tr>    
		<tr><td align="right">Entidade:</td><td><%=CStr(strCODEnt) & " - " & strENTIDADE%></td></tr>
		<tr><td align="right">Plano de Conta:</td><td><%=GetValue(objRS,"PLANO_CONTA_COD_REDUZIDO")%>&nbsp;&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td></tr>
		<tr><td align="right">Centro de Custo:</td><td><%=GetValue(objRS,"CENTRO_CUSTO")%></td></tr>    
		<tr><td align="right">Valor:</td><td><%=strVLR_LCTO%></td></tr>
		<tr>
			<td align="right">Tipo Documento:</td>
			<td>
				<% if GetValue(objRS,"TIPO_DOCUMENTO")="BOLETO"           then Response.Write("Boleto")           %>
				<% if GetValue(objRS,"TIPO_DOCUMENTO")="CHEQUE"           then Response.Write("Cheque")           %>
				<% if GetValue(objRS,"TIPO_DOCUMENTO")="DUPLICATA"        then Response.Write("Duplicata")        %>
				<% if GetValue(objRS,"TIPO_DOCUMENTO")="FATURA"           then Response.Write("Fatura")           %>
				<% if GetValue(objRS,"TIPO_DOCUMENTO")="NOTA_PROMISSORIA" then Response.Write("Nota Promissória") %>
				<% if GetValue(objRS,"TIPO_DOCUMENTO")="DOC" 			  then Response.Write("Doc") 			  %>
				<% if GetValue(objRS,"TIPO_DOCUMENTO")="TED" 			  then Response.Write("TED") 			  %>
				<% if GetValue(objRS,"TIPO_DOCUMENTO")="OUTROS" 		  then Response.Write("Outros") 		  %>									
			</td>
		</tr>
		<tr><td align="right">Número:</td><td><%=GetValue(objRS,"NUM_DOCUMENTO")%></td></tr>    
		<tr><td align="right">Data Emissão:</td><td><%=PrepData(GetValue(objRS,"DT_EMISSAO"),true,false)%></td></tr>
		<tr><td align="right">Data Vcto:</td><td><%=PrepData(GetValue(objRS,"DT_VCTO"),true,false)%></td></tr>
		<tr><td align="right">Histórico:</td><td><%=GetValue(objRS,"HISTORICO")%></td></tr>
		<tr><td align="right">Situação:</td><td><%
		If GetValue(objRS,"SITUACAO") = "ABERTA" Then Response.Write("Aberta")
		If GetValue(objRS,"SITUACAO") = "LCTO_PARCIAL" Then Response.Write("Parcial")
		If GetValue(objRS,"SITUACAO") = "LCTO_TOTAL" Then Response.Write("Quitada")
		If GetValue(objRS,"SITUACAO") = "CANCELADA" Then Response.Write("Cancelada")
		%></td></tr>
		<tr><td align="right">Arquivo Anexo:</td><td><%
		If GetValue(objRS,"ARQUIVO_ANEXO") <> "" Then
			Response.Write("<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/FIN_Titulos/" & GetValue(objRS,"ARQUIVO_ANEXO") & "' target='_blank'>" & GetValue(objRS,"ARQUIVO_ANEXO") & "</a>")
		End If
		%></td></tr>
		<% If GetValue(objRS, "COD_CONTA_TAXAS") = "" Then %>
			<tr id="tableheader_last_row"><td align="right">Observação:</td><td><%=GetValue(objRS,"OBS")%></td></tr>
		<% Else %>
			<tr><td align="right">Observação:</td><td><%=GetValue(objRS,"OBS")%></td></tr>
			<tr><td align="right">IRRF:</td><td><%=FormataDecimal(GetValue(objRS, "TOTAL_IRRF"), 2)%></td></tr>
			<tr><td align="right">PIS:</td><td><%=FormataDecimal(GetValue(objRS, "TOTAL_PIS"), 2)%></td></tr>
			<tr><td align="right">COFINS:</td><td><%=FormataDecimal(GetValue(objRS, "TOTAL_COFINS"), 2)%></td></tr>
			<tr><td align="right">CSOCIAL:</td><td><%=FormataDecimal(GetValue(objRS, "TOTAL_CSOCIAL"), 2)%></td></tr>
			<tr><td align="right">IRPJ:</td><td><%=FormataDecimal(GetValue(objRS, "TOTAL_IRPJ"), 2)%></td></tr>
			<tr><td align="right">ISSQN:</td><td><%=FormataDecimal(GetValue(objRS, "TOTAL_ISSQN"), 2)%></td></tr>
			<tr><td align="right">Total Impostos:</td><td><%=FormataDecimal(GetValue(objRS, "TOTAL_IMPOSTOS"), 2)%></td></tr>
			<tr><td align="right">Total Redução:</td><td><%=FormataDecimal(GetValue(objRS, "TOTAL_REDUCAO"), 2)%></td></tr>
			<tr><td align="right">Valor Base:</td><td><%=FormataDecimal(GetValue(objRS, "VLR_BASE"), 2)%></td></tr>
			<tr><td align="right">Valor Final:</td><td><%=FormataDecimal(GetValue(objRS, "VLR_FINAL"), 2)%></td></tr>
			<tr><td align="right">Acúmulo de IRRF:</td><td>
			<%
			If GetValue(objRS, "COD_ACUM_IRRF") <> "" Then
				If CDbl("0" & GetValue(objRS, "TOTAL_ACUM_IRRF")) > 0 Then
					strSQL = " SELECT COD_CONTA_PAGAR_RECEBER FROM FIN_CONTA_PAGAR_RECEBER_TAXAS WHERE COD_ACUM_IRRF = " & strCOD_CONTA_PAGAR_RECEBER
					
					Set objRSc = objConn.Execute(strSQL)
					
					strCODIGOS = "," & strCOD_CONTA_PAGAR_RECEBER
					Do While Not objRSc.Eof
						If CStr(GetValue(objRSc, "COD_CONTA_PAGAR_RECEBER")) <> CStr(strCOD_CONTA_PAGAR_RECEBER) Then strCODIGOS = strCODIGOS & "," & GetValue(objRSc, "COD_CONTA_PAGAR_RECEBER")
						objRSc.MoveNext
					Loop
					FechaRecordSet objRSc
					strCODIGOS = Mid(strCODIGOS, 2)
					
					Response.Write("No total de R$ " & FormataDecimal(GetValue(objRS, "TOTAL_ACUM_IRRF"), 2))
					If InStr(strCODIGOS, ",") > 0 Then
						Response.Write(", somou os IRRFs dos títulos " & strCODIGOS)
					Else
						Response.Write(", acúmulo apenas deste título")
					End If
				Else
					Response.Write("O total de IRRF deste título acumulou no título " & GetValue(objRS, "COD_ACUM_IRRF"))
				End If
			End If
			%>
			</td></tr>
			<tr><td align="right">Acúmulo de Outras Reduções:</td><td>
			<%
			If GetValue(objRS, "COD_ACUM_REDUCAO") <> "" Then
				If CDbl("0" & GetValue(objRS, "TOTAL_ACUM_REDUCAO")) > 0 Then
					strSQL = " SELECT COD_CONTA_PAGAR_RECEBER FROM FIN_CONTA_PAGAR_RECEBER_TAXAS WHERE COD_ACUM_REDUCAO = " & strCOD_CONTA_PAGAR_RECEBER
					
					Set objRSc = objConn.Execute(strSQL)
					
					strCODIGOS = "," & strCOD_CONTA_PAGAR_RECEBER
					Do While Not objRSc.Eof
						If CStr(GetValue(objRSc, "COD_CONTA_PAGAR_RECEBER")) <> CStr(strCOD_CONTA_PAGAR_RECEBER) Then strCODIGOS = strCODIGOS & "," & GetValue(objRSc, "COD_CONTA_PAGAR_RECEBER")
						objRSc.MoveNext
					Loop
					FechaRecordSet objRSc
					strCODIGOS = Mid(strCODIGOS, 2)
					
					Response.Write("No total de R$ " & FormataDecimal(GetValue(objRS, "TOTAL_ACUM_REDUCAO"), 2))
					If InStr(strCODIGOS, ",") > 0 Then
						Response.Write(", somou as Outras Reduções dos títulos " & strCODIGOS)
					Else
						Response.Write(", acúmulo apenas deste título")
					End If
				Else
					Response.Write("O total das Outras Reduções deste título acumulou no título " & GetValue(objRS, "COD_ACUM_REDUCAO"))
				End If
			End If
			%>
			</td></tr>
			<tr id="tableheader_last_row"><td align="right">Cálculo das Taxas:</td><td>por <%=GetValue(objRS, "SYS_COD_USER_CRIACAO_TAXAS")%>,  em <%=PrepData(GetValue(objRS, "SYS_DT_CRIACAO_TAXAS"), True, True)%></td></tr>
		<%
		End If
		%>
	 </tbody>
	</table>
</div>
<br/>
<%
	'Montagem do MENU DETAIL
	athBeginCssMenu()
		athCssMenuAddItem "", "", "_self", "LANÇAMENTOS", "", 1
		athBeginCssSubMenu()
			athCssMenuAddItem "InsertLcto.asp?var_chavereg=" & strCOD_CONTA_PAGAR_RECEBER, "", "_self", "Inserir Lançamento", "div_modal", 0
		athEndCssSubMenu()
	athEndCssMenu("div_modal")
	
	if not objRSa.Eof then 
%>
<table align="center" cellpadding="0" cellspacing="1" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead> 
	<tr>
		<th width="01%"></th>
		<th width="01%"></th>
		<th width="01%"></th>
		<th width="01%" class="sortable" nowrap>Cod</th>
		<th width="15%" class="sortable" nowrap>Conta</th>
		<th width="15%" class="sortable" nowrap>Plano de Conta</th>
		<th width="15%" class="sortable" nowrap>Centro de Custo</th>
		<th width="33%" class="sortable" nowrap>Histórico</th>
		<th width="06%" class="sortable" nowrap>Num Lcto</th>
		<th width="06%" class="sortable-date-dmy" nowrap>Dt Lcto</th>
		<th width="06%" class="sortable-currency" nowrap>Vlr Lcto</th>
	</tr>
  </thead>
 <tbody style="text-align:left;">
	<%
      While Not objRSa.Eof
        strCOLOR = swapString (strCOLOR," #FFFFFF", "#F5FAFA")
		strVLR_LCTO = "0,00"			
		if GetValue(objRSa,"VLR_LCTO")<>"" then strVLR_LCTO = FormataDecimal(GetValue(objRSa,"VLR_LCTO"),2)				
	%>
    <tr bgcolor=<%=strCOLOR%>> 
		<td><% If bDel = True Then Response.Write(MontaLinkGrade("modulo_FIN_TITULOS","DeleteLcto.asp",GetValue(objRSa,"COD_LCTO_ORDINARIO"),"IconAction_DEL.gif","REMOVER")) End If %></td>
		<td><% If bUpd = True Then Response.Write(MontaLinkGrade("modulo_FIN_TITULOS","UpdateLcto.asp",GetValue(objRSa,"COD_LCTO_ORDINARIO"),"IconAction_EDIT.gif","ALTERAR")) End If %></td>
		<td><%=MontaLinkGrade("modulo_FIN_TITULOS","DetailLcto.asp",GetValue(objRSa,"COD_LCTO_ORDINARIO"),"IconAction_DETAIL.gif","DETALHE") %></td>
		<td><%=GetValue(objRSa,"COD_LCTO_ORDINARIO")%></td>
		<td><%=GetValue(objRSa,"CONTA")%></td>
		<td><%=GetValue(objRSa,"PL_CONTA")%></td>
		<td><%=GetValue(objRSa,"CT_CUSTO")%></td>
		<td><%=GetValue(objRSa,"HISTORICO")%></td>
		<td><%=GetValue(objRSa,"NUM_LCTO")%></td>
		<td><%=PrepData(GetValue(objRSa,"DT_LCTO"), True, False)%></td>				
		<td><%=strVLR_LCTO%></td>
	</tr>
	<%			
		athMoveNext objRSa, ContFlush, CFG_FLUSH_LIMIT
	wend
	%>
 </tbody>
</table>
<br/>
<%	end if %>		
</body>
</html>
<%
	end if	 
	FechaRecordSet objRSa
end if 
FechaRecordSet objRS
FechaDBConn objConn
%>