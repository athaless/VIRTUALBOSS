<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|CALC_TAXAS|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim objConn, objRS1, objRS2, objRS3, strSQL
	Dim strCOD_CONTA_PAGAR_RECEBER, strENTIDADE
	Dim strLABEL_PARCELA, strLABEL_ENT, strLABEL_COR
	
	AbreDBConn objConn, CFG_DB 
	
	strCOD_CONTA_PAGAR_RECEBER = GetParam("var_chavereg")
	
	If strCOD_CONTA_PAGAR_RECEBER <> "" Then
		strSQL =	"SELECT "											&_
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
					",	T1.COD_CONTA "									&_
					",	T1.SITUACAO "									&_
					",	T1.OBS "										&_
					",	T3.NOME AS PLANO_CONTA "						&_
					",	T3.COD_PLANO_CONTA "							&_
					",	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO "	&_
					",	T4.NOME AS CENTRO_CUSTO "						&_
					",	T4.COD_CENTRO_CUSTO "							&_
					",	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO "	&_
					",	T1.COD_NF "										&_
					",	T1.NUM_NF "										&_
					",	T1.ARQUIVO_ANEXO "								&_
					",	T5.RAZAO_SOCIAL AS CLIENTE "					&_
					",	T6.RAZAO_SOCIAL AS FORNECEDOR "					&_
					",	T7.NOME AS COLABORADOR "						&_
					",	T8.COD_CONTA_TAXAS "							&_
					"FROM FIN_CONTA_PAGAR_RECEBER AS T1 " 				&_
					"LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) " &_
					"LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) " &_
					"LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " &_
					"LEFT OUTER JOIN ENT_CLIENTE AS T5 ON (T1.CODIGO=T5.COD_CLIENTE) " &_
					"LEFT OUTER JOIN ENT_FORNECEDOR AS T6 ON (T1.CODIGO=T6.COD_FORNECEDOR) " &_
					"LEFT OUTER JOIN ENT_COLABORADOR AS T7 ON (T1.CODIGO=T7.COD_COLABORADOR) " &_
					"LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER_TAXAS AS T8 ON (T1.COD_CONTA_PAGAR_RECEBER=T8.COD_CONTA_PAGAR_RECEBER) " &_
					"WHERE T1.COD_CONTA_PAGAR_RECEBER=" & strCOD_CONTA_PAGAR_RECEBER
		
		AbreRecordSet objRS1, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
		if not objRS1.Eof then				 
			if GetValue(objRS1,"PAGAR_RECEBER") <> "0" then
				strLABEL_PARCELA = "Conta a Pagar"
				strLABEL_ENT     = "Pagar para:"		
				strLABEL_COR     = "color:#FF0000;" 'vermelho
			else
				strLABEL_PARCELA = "Conta a Receber"
				strLABEL_ENT     = "Receber de:"
				strLABEL_COR     = "color:#00C000;" 'verde		
			end if
			
			strENTIDADE = ""
			If GetValue(objRS1, "TIPO") = "ENT_CLIENTE" Then strENTIDADE = GetValue(objRS1, "CODIGO") & " - " & GetValue(objRS1, "CLIENTE")
			If GetValue(objRS1, "TIPO") = "ENT_FORNECEDOR" Then strENTIDADE = GetValue(objRS1, "CODIGO") & " - " & GetValue(objRS1, "FORNECEDOR")
			If GetValue(objRS1, "TIPO") = "ENT_COLABORADOR" Then strENTIDADE = GetValue(objRS1, "CODIGO") & " - " & GetValue(objRS1, "COLABORADOR")
			
			'strMSG = ""
			'If GetValue(objRS1, "SITUACAO") <> "ABERTA" Then strMSG = strMSG & "Conta em situação diferente de aberta<br>"
			'If GetValue(objRS1, "COD_NF") <> "" Then strMSG = strMSG & "Conta possui uma Nota Fiscal associada<br>"
			
			'If strMSG <> "" Then
			'	Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
			'	Response.End()
			'End If
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { }
function submeterForm() { 
	var var_msg = '';
	
	if (document.form_insert.var_chavereg.value == '') var_msg += '\nParâmetro inválido para contrato';
	if (document.form_insert.var_cod_cfg_nf.value == '') var_msg += '\nParâmetro inválido para modelo';
	
	if (var_msg == '') 
		document.form_insert.submit(); 
	else {
		alert('Verificar mensagens:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, strLABEL_PARCELA & " - Geração de Taxas") %>
<form name="form_insert" action="GeraTaxasTituloP2.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCOD_CONTA_PAGAR_RECEBER%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCOD_CONTA_PAGAR_RECEBER%></div>
	<br><div class="form_label">Conta:</div><div class="form_bypass"><%=GetValue(objRS1, "CONTA")%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass"><%=strENTIDADE%></div>
	<br><div class="form_label">Plano de Conta:</div><div class="form_bypass"><%=GetValue(objRS1,"PLANO_CONTA_COD_REDUZIDO")%>&nbsp;&nbsp;<%=GetValue(objRS1,"PLANO_CONTA")%></div>
	<br><div class="form_label">Centro de Custo:</div><div class="form_bypass"><%=GetValue(objRS1,"CENTRO_CUSTO")%></div>
	<br><div class="form_label">Valor:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS1, "VLR_CONTA"), 2)%></div>
	<br><div class="form_label">Tipo Documento:</div><div class="form_bypass"><%
	if GetValue(objRS1,"TIPO_DOCUMENTO") = "BOLETO"           then Response.Write("Boleto")
	if GetValue(objRS1,"TIPO_DOCUMENTO") = "CHEQUE"           then Response.Write("Cheque")
	if GetValue(objRS1,"TIPO_DOCUMENTO") = "DUPLICATA"        then Response.Write("Duplicata")
	if GetValue(objRS1,"TIPO_DOCUMENTO") = "FATURA"           then Response.Write("Fatura")
	if GetValue(objRS1,"TIPO_DOCUMENTO") = "NOTA_PROMISSORIA" then Response.Write("Nota Promissória")
	if GetValue(objRS1,"TIPO_DOCUMENTO") = "DOC"              then Response.Write("Doc")
	if GetValue(objRS1,"TIPO_DOCUMENTO") = "TED"              then Response.Write("TED")
	if GetValue(objRS1,"TIPO_DOCUMENTO") = "OUTROS"           then Response.Write("Outros")
	%></div>
	<br><div class="form_label">Número:</div><div class="form_bypass"><%=GetValue(objRS1, "NUM_DOCUMENTO")%></div>
	<br><div class="form_label">Data Emissão:</div><div class="form_bypass"><%=PrepData(GetValue(objRS1,"DT_EMISSAO"), True, False)%></strong></div>
	<br><div class="form_label">Data Vcto:</div><div class="form_bypass"><%=PrepData(GetValue(objRS1,"DT_VCTO"), True, False)%></div>
	<br><div class="form_label">Histórico:</div><div class="form_bypass"><%=GetValue(objRS1,"HISTORICO")%></div>
	<br><div class="form_label">Situação:</div><div class="form_bypass"><%
		If GetValue(objRS1,"SITUACAO") = "ABERTA" Then Response.Write("Aberta")
		If GetValue(objRS1,"SITUACAO") = "LCTO_PARCIAL" Then Response.Write("Parcial")
		If GetValue(objRS1,"SITUACAO") = "LCTO_TOTAL" Then Response.Write("Quitada")
		If GetValue(objRS1,"SITUACAO") = "CANCELADA" Then Response.Write("Cancelada")
		%></div>
	<br><div class="form_label">Arquivo Anexo:</div><div class="form_bypass"><%
		If GetValue(objRS1,"ARQUIVO_ANEXO") <> "" Then
			Response.Write("<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/FIN_Titulos/" & GetValue(objRS1,"ARQUIVO_ANEXO") & "' target='_blank'>" & GetValue(objRS1,"ARQUIVO_ANEXO") & "</a>")
		End If
		%></div>
	<br><div class="form_label">Observação:</div><div class="form_bypass_multiline"><%=GetValue(objRS1,"OBS")%></div>
	<br>
	<% If GetValue(objRS1,"COD_CONTA_TAXAS") <> "" Then %>
		<br><div class="form_label">&nbsp;</div><input type="radio" name="var_opcao" id="var_opcao_canc" value="canc" class="inputclean">Cancelar Taxas
		<br><div class="form_label">&nbsp;</div><div class="form_bypass_multiline">Se este título estiver acumulando IRRF ou Outros Serviços, seja neste título ou em outro, estes outros títulos terão suas taxas canceladas também!</div>
		<br><div class="form_label">&nbsp;</div><input type="radio" name="var_opcao" id="var_opcao_recalc" value="recalc" class="inputclean" checked="checked">Recalcular Taxas
		<br><div class="form_label">&nbsp;</div><div class="form_bypass">Usar alíquota abaixo:</div>
		<br><div class="form_label">&nbsp;</div><select name="var_cod_cfg_nf" size="1" style="width:280px;" class="edtext_combo">
			<%=montaCombo("STR", " SELECT COD_CFG_NF, DESCRICAO FROM CFG_NF WHERE DT_INATIVO IS NULL ORDER BY ORDEM, DESCRICAO ", "COD_CFG_NF", "DESCRICAO", "") %>
		</select>
	<% Else %>
		<br><div class="form_label">&nbsp;</div><input type="radio" name="var_opcao" id="var_opcao_calc" value="calc" class="inputclean" checked="checked">Calcular Taxas
		<br><div class="form_label">&nbsp;</div><div class="form_bypass">Usar alíquota abaixo:</div>
		<br><div class="form_label">&nbsp;</div><select name="var_cod_cfg_nf" size="1" style="width:280px;" class="edtext_combo">
			<%=montaCombo("STR", " SELECT COD_CFG_NF, DESCRICAO FROM CFG_NF WHERE DT_INATIVO IS NULL ORDER BY ORDEM, DESCRICAO ", "COD_CFG_NF", "DESCRICAO", "") %>
		</select>
	<% End If %>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
		End If
		FechaRecordSet objRS1
	End If
	FechaDBConn objConn
%>
