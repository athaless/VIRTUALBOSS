<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athTaxasFunctions.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO! Você está prestes a gravar as taxas para este título. Para confirmar clique no botão [ok], para desistir clique em [cancelar]." '"<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 
	Dim objConn, objRS1, objRS2, objRS3, strSQL
	Dim strCOD_DADO, strENTIDADE, strCOD_CFG_NF
	Dim strLABEL_PARCELA, strLABEL_ENT, strLABEL_COR, strPREFIXO
	Dim strALIQ_ISSQN, strALIQ_IRPJ, strALIQ_COFINS, strALIQ_PIS, strALIQ_CSOCIAL, strALIQ_IRRF
	Dim strVLR_BASE, strTOTAL_IRRF, strTOTAL_PIS, strTOTAL_COFINS, strTOTAL_CSOCIAL
	Dim strTOTAL_IRPJ, strTOTAL_ISSQN, strTOTAL_REDUCAO, strTOTAL_IMPOSTOS, strVLR_FINAL
	Dim strENTIDADE_CODIGO, strENTIDADE_TIPO
	Dim strVLR_LIM_IRRF, strVLR_LIM_REDUCAO
	Dim strACUMULOU_IRRF, strACUMULOU_REDUCAO			'Indica se teve acúmulo ou não
	Dim strTOTAL_ACUM_IRRF, strTOTAL_ACUM_REDUCAO		'Total dos valores acumulados
	Dim strCODIGOS_ACUM_IRRF, strCODIGOS_ACUM_REDUCAO	'Códigos dos títulos que receberão marca de que teve acúmulo
	Dim strCOD_ACUM_IRRF, strCOD_ACUM_REDUCAO			'Código do título se ele chegar a acumular, os outros títulos terão esse código em si mesmos para marcar em qual título foi acumulado
	Dim strALIQ_IRPJ_ENTIDADE, strALIQ_ISSQN_SERVICO, strMSG, strOPCAO
	
	AbreDBConn objConn, CFG_DB 
	
	strCOD_DADO = GetParam("var_chavereg")
	strCOD_CFG_NF = GetParam("var_cod_cfg_nf")
	strOPCAO = GetParam("var_opcao")
	
	strMSG = ""
	If strCOD_DADO = "" Then strMSG = strMSG & "Parâmetro inválido para código<br>"
	If strOPCAO <> "canc" And strOPCAO <> "calc" And strOPCAO <> "recalc" Then strMSG = strMSG & "Parâmetro inválido para opção de ação<br>"
	
	If strMSG <> "" Then
		Mensagem strMSG, "Javascript:history.go(-1);", "Voltar", 1
		Response.End()
	End If
	
	If strOPCAO = "canc" Then
		ApagaTaxasGeral strCOD_DADO, objConn
		%>
		<script>
			parent.frames["vbTopFrame"].document.form_principal.submit();
		</script>
		<%
	Else
		strSQL =	" SELECT "											&_
					"	T1.COD_CONTA_PAGAR_RECEBER "					&_
					" ,	T1.TIPO "										&_
					" ,	T1.CODIGO "										&_
					" ,	T1.DT_EMISSAO "									&_
					" ,	T1.HISTORICO "									&_
					" ,	T1.TIPO_DOCUMENTO "								&_
					" ,	T1.NUM_DOCUMENTO "								&_
					" ,	T1.PAGAR_RECEBER "								&_
					" ,	T1.DT_VCTO "									&_
					" ,	T1.VLR_CONTA "									&_
					" ,	T2.NOME AS CONTA "								&_
					" ,	T1.COD_CONTA "									&_
					" ,	T1.SITUACAO "									&_
					" ,	T1.OBS "										&_
					" ,	T3.NOME AS PLANO_CONTA "						&_
					" ,	T3.COD_PLANO_CONTA "							&_
					" ,	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO "	&_
					" ,	T4.NOME AS CENTRO_CUSTO "						&_
					" ,	T4.COD_CENTRO_CUSTO "							&_
					" ,	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO "	&_
					" ,	T1.COD_NF "										&_
					" ,	T1.NUM_NF "										&_
					" ,	T1.ARQUIVO_ANEXO "								&_
					" ,	T5.RAZAO_SOCIAL AS CLIENTE "					&_
					" ,	T6.RAZAO_SOCIAL AS FORNECEDOR "					&_
					" ,	T7.NOME AS COLABORADOR "						&_
					" ,	T1.COD_CONTRATO "								&_
					" ,	T5.TEM_ALIQ_IRPJ AS CLI_TEM_ALIQ_IRPJ "			&_
					" ,	T5.ALIQ_IRPJ AS CLI_ALIQ_IRPJ "					&_
					" ,	T6.TEM_ALIQ_IRPJ AS FORNEC_TEM_ALIQ_IRPJ "		&_
					" ,	T6.ALIQ_IRPJ AS FORNEC_ALIQ_IRPJ "				&_
					" FROM FIN_CONTA_PAGAR_RECEBER AS T1 " 				&_
					" LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA = T2.COD_CONTA) " &_
					" LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA = T3.COD_PLANO_CONTA) " &_
					" LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO = T4.COD_CENTRO_CUSTO) " &_
					" LEFT OUTER JOIN ENT_CLIENTE AS T5 ON (T1.CODIGO = T5.COD_CLIENTE) " &_
					" LEFT OUTER JOIN ENT_FORNECEDOR AS T6 ON (T1.CODIGO = T6.COD_FORNECEDOR) " &_
					" LEFT OUTER JOIN ENT_COLABORADOR AS T7 ON (T1.CODIGO = T7.COD_COLABORADOR) " &_
					" WHERE T1.COD_CONTA_PAGAR_RECEBER = " & strCOD_DADO
		
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
			
			strENTIDADE_CODIGO = GetValue(objRS1, "CODIGO")
			strENTIDADE_TIPO = GetValue(objRS1, "TIPO")
			
			strENTIDADE = ""
			If strENTIDADE_TIPO = "ENT_CLIENTE" Then strENTIDADE = strENTIDADE_CODIGO & " - " & GetValue(objRS1, "CLIENTE")
			If strENTIDADE_TIPO = "ENT_FORNECEDOR" Then strENTIDADE = strENTIDADE_CODIGO & " - " & GetValue(objRS1, "FORNECEDOR")
			If strENTIDADE_TIPO = "ENT_COLABORADOR" Then strENTIDADE = strENTIDADE_CODIGO & " - " & GetValue(objRS1, "COLABORADOR")
			
			'-------------------------------------------------------------------------------------------
			'Busca as alíquotas e limites do modelo de NF para cálculo das taxas e limites de acúmulo
			'-------------------------------------------------------------------------------------------
			strSQL =          " SELECT ALIQ_ISSQN, ALIQ_IRPJ, ALIQ_COFINS, ALIQ_PIS, ALIQ_CSOCIAL "
			strSQL = strSQL & "      , ALIQ_IRRF, VLR_LIM_IRRF, VLR_LIM_REDUCAO "
			strSQL = strSQL & " FROM CFG_NF WHERE COD_CFG_NF = " & strCOD_CFG_NF
			
			Set objRS2 = objConn.Execute(strSQL)
			
			If Not objRS2.Eof Then
				strALIQ_ISSQN   = GetValue(objRS2, "ALIQ_ISSQN")
				strALIQ_IRPJ    = GetValue(objRS2, "ALIQ_IRPJ")
				strALIQ_COFINS  = GetValue(objRS2, "ALIQ_COFINS")
				strALIQ_PIS     = GetValue(objRS2, "ALIQ_PIS")
				strALIQ_CSOCIAL = GetValue(objRS2, "ALIQ_CSOCIAL")
				strALIQ_IRRF    = GetValue(objRS2, "ALIQ_IRRF")
				
				strVLR_LIM_IRRF    = GetValue(objRS2, "VLR_LIM_IRRF")
				strVLR_LIM_REDUCAO = GetValue(objRS2, "VLR_LIM_REDUCAO")
			End If
			FechaRecordSet objRS2
			
			If IsNumeric(strALIQ_ISSQN)   Then strALIQ_ISSQN   = CDbl("0" & strALIQ_ISSQN)   Else strALIQ_ISSQN   = 0 End If
			If IsNumeric(strALIQ_IRPJ)    Then strALIQ_IRPJ    = CDbl("0" & strALIQ_IRPJ)    Else strALIQ_IRPJ    = 0 End If
			If IsNumeric(strALIQ_COFINS)  Then strALIQ_COFINS  = CDbl("0" & strALIQ_COFINS)  Else strALIQ_COFINS  = 0 End If
			If IsNumeric(strALIQ_PIS)     Then strALIQ_PIS     = CDbl("0" & strALIQ_PIS)     Else strALIQ_PIS     = 0 End If
			If IsNumeric(strALIQ_CSOCIAL) Then strALIQ_CSOCIAL = CDbl("0" & strALIQ_CSOCIAL) Else strALIQ_CSOCIAL = 0 End If
			If IsNumeric(strALIQ_IRRF)    Then strALIQ_IRRF    = CDbl("0" & strALIQ_IRRF)    Else strALIQ_IRRF    = 0 End If
			
			If IsNumeric(strVLR_LIM_IRRF)    Then strVLR_LIM_IRRF    = CDbl("0" & strVLR_LIM_IRRF)    Else strVLR_LIM_IRRF    = 0 End If
			If IsNumeric(strVLR_LIM_REDUCAO) Then strVLR_LIM_REDUCAO = CDbl("0" & strVLR_LIM_REDUCAO) Else strVLR_LIM_REDUCAO = 0 End If
			
			'-------------------------------------------------------------------------------------------
			'Se cliente/fornecedor tiver uma alíquota específica de IRPJ busca o percentual
			'-------------------------------------------------------------------------------------------
			strPREFIXO = ""
			strALIQ_IRPJ_ENTIDADE = ""
			
			If strENTIDADE_TIPO = "ENT_CLIENTE"    Then strPREFIXO = "CLI_"
			If strENTIDADE_TIPO = "ENT_FORNECEDOR" Then strPREFIXO = "FORNEC_"
			
			If strPREFIXO <> "" Then
				If GetValue(objRS1, strPREFIXO & "TEM_ALIQ_IRPJ") <> "0" And GetValue(objRS1, strPREFIXO & "TEM_ALIQ_IRPJ") <> "" Then
					strALIQ_IRPJ_ENTIDADE = GetValue(objRS1, strPREFIXO & "ALIQ_IRPJ")
				End If
			End If
			
			If IsNumeric(strALIQ_IRPJ_ENTIDADE) Then strALIQ_IRPJ = CDbl("0" & strALIQ_IRPJ_ENTIDADE)
			
			'-------------------------------------------------------------------------------------------
			'Se conta pagar e receber tiver vínculo com contrato então busca alíquota 
			'de ISSQN do serviço. Se não tiver usa o geral já lido.
			'-------------------------------------------------------------------------------------------
			If GetValue(objRS1, "COD_CONTRATO") <> "" Then
				strSQL = " SELECT ALIQ_ISSQN_SERVICO FROM CONTRATO WHERE COD_CONTRATO = " & GetValue(objRS1, "COD_CONTRATO")
				
				Set objRS2 = objConn.Execute(strSQL)
				If Not objRS2.Eof Then strALIQ_ISSQN_SERVICO = GetValue(objRS2, "ALIQ_ISSQN_SERVICO")
				FechaRecordSet objRS2
				
				If IsNumeric(strALIQ_ISSQN_SERVICO) Then strALIQ_ISSQN = CDbl("0" & strALIQ_ISSQN_SERVICO)
			End If
			
			'-----------------------------------
			'Cálculos
			'-----------------------------------
			strVLR_BASE = GetValue(objRS1, "VLR_CONTA")
			If Not IsNumeric(strVLR_BASE) Then strVLR_BASE = 0
			
			strTOTAL_ISSQN   = strVLR_BASE * (strALIQ_ISSQN / 100)
			strTOTAL_IRPJ    = strVLR_BASE * (strALIQ_IRPJ / 100)
			strTOTAL_COFINS  = strVLR_BASE * (strALIQ_COFINS / 100)
			strTOTAL_PIS     = strVLR_BASE * (strALIQ_PIS / 100)
			strTOTAL_CSOCIAL = strVLR_BASE * (strALIQ_CSOCIAL / 100)
			strTOTAL_IRRF    = strVLR_BASE * (strALIQ_IRRF / 100)
			
			strTOTAL_REDUCAO  = strTOTAL_PIS + strTOTAL_COFINS + strTOTAL_CSOCIAL
			strTOTAL_IMPOSTOS = strTOTAL_PIS + strTOTAL_COFINS + strTOTAL_CSOCIAL + strTOTAL_IRPJ + strTOTAL_ISSQN
			strVLR_FINAL      = strVLR_BASE
			
			'--------------------------------------------------------------------
			'Busca os títulos da mesma entidade que possuem taxas calculadas
			'no mês/ano para verificar acúmulo de IRRF
			'--------------------------------------------------------------------
			strSQL =          " SELECT COD_CONTA_PAGAR_RECEBER, TOTAL_IRRF "
			strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER_TAXAS "
			strSQL = strSQL & " WHERE CODIGO = " & strENTIDADE_CODIGO
			strSQL = strSQL & " AND TIPO LIKE '" & strENTIDADE_TIPO & "' "
			strSQL = strSQL & " AND Month(SYS_DT_CRIACAO) = " & Month(Date)
			strSQL = strSQL & " AND Year(SYS_DT_CRIACAO) = " & Year(Date)
			strSQL = strSQL & " AND COD_ACUM_IRRF IS NULL "
			
			Set objRS3 = objConn.Execute(strSQL)
			
			strCODIGOS_ACUM_IRRF = ""
			strTOTAL_ACUM_IRRF = strTOTAL_IRRF
			
			'athDebug "<br>IRRF", False
			
			Do While Not objRS3.Eof
				strCODIGOS_ACUM_IRRF = strCODIGOS_ACUM_IRRF & "," & GetValue(objRS3, "COD_CONTA_PAGAR_RECEBER")
				strTOTAL_ACUM_IRRF = strTOTAL_ACUM_IRRF + CDbl("0" & GetValue(objRS3, "TOTAL_IRRF"))
				
				'athDebug "<br>codigos: " & strCODIGOS_ACUM_IRRF, False
				'athDebug "<br>valor: " & GetValue(objRS3, "TOTAL_IRRF"), False
				
				objRS3.MoveNext
			Loop
			FechaRecordSet objRS3
			
			If strCODIGOS_ACUM_IRRF <> "" Then strCODIGOS_ACUM_IRRF = Mid(strCODIGOS_ACUM_IRRF, 2)
			If (strTOTAL_ACUM_IRRF >= strVLR_LIM_IRRF) And (strVLR_LIM_IRRF > 0) Then
				strACUMULOU_IRRF = True
			Else
				strACUMULOU_IRRF = False
				strTOTAL_ACUM_IRRF = 0
				strCODIGOS_ACUM_IRRF = ""
			End If
			
			'--------------------------------------------------------------------
			'Busca os títulos da mesma entidade que possuem taxas calculadas 
			'no mês/ano para verificar acúmulo de Outras Reduções
			'--------------------------------------------------------------------
			strSQL =          " SELECT COD_CONTA_PAGAR_RECEBER, TOTAL_CSOCIAL, TOTAL_PIS, TOTAL_COFINS "
			strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER_TAXAS "
			strSQL = strSQL & " WHERE CODIGO = " & strENTIDADE_CODIGO
			strSQL = strSQL & " AND TIPO LIKE '" & strENTIDADE_TIPO & "' "
			strSQL = strSQL & " AND Month(SYS_DT_CRIACAO) = " & Month(Date)
			strSQL = strSQL & " AND Year(SYS_DT_CRIACAO) = " & Year(Date)
			strSQL = strSQL & " AND COD_ACUM_REDUCAO IS NULL "
			
			Set objRS3 = objConn.Execute(strSQL)
			
			strCODIGOS_ACUM_REDUCAO = ""
			strTOTAL_ACUM_REDUCAO = strTOTAL_REDUCAO
			
			'athDebug "<br>REDUCAO " & strTOTAL_REDUCAO, False
			
			Do While Not objRS3.Eof
				strCODIGOS_ACUM_REDUCAO = strCODIGOS_ACUM_REDUCAO & "," & GetValue(objRS3, "COD_CONTA_PAGAR_RECEBER")
				strTOTAL_ACUM_REDUCAO = strTOTAL_ACUM_REDUCAO + CDbl("0" & GetValue(objRS3, "TOTAL_CSOCIAL"))
				strTOTAL_ACUM_REDUCAO = strTOTAL_ACUM_REDUCAO + CDbl("0" & GetValue(objRS3, "TOTAL_PIS"))
				strTOTAL_ACUM_REDUCAO = strTOTAL_ACUM_REDUCAO + CDbl("0" & GetValue(objRS3, "TOTAL_COFINS"))
				
				'athDebug "<br>codigos: " & strCODIGOS_ACUM_REDUCAO, False
				'athDebug "<br>valores: " & GetValue(objRS3, "TOTAL_CSOCIAL") & " - " & GetValue(objRS3, "TOTAL_PIS") & " - " & GetValue(objRS3, "TOTAL_COFINS"), False
				'athDebug "<br>total: " & strTOTAL_ACUM_REDUCAO, False
				
				objRS3.MoveNext
			Loop
			FechaRecordSet objRS3
			
			If strCODIGOS_ACUM_REDUCAO <> "" Then strCODIGOS_ACUM_REDUCAO = Mid(strCODIGOS_ACUM_REDUCAO, 2)
			If (strTOTAL_ACUM_REDUCAO >= strVLR_LIM_REDUCAO) And (strVLR_LIM_REDUCAO > 0) Then
				strACUMULOU_REDUCAO = True
			Else
				strACUMULOU_REDUCAO = False
				strTOTAL_ACUM_REDUCAO = 0
				strCODIGOS_ACUM_REDUCAO = ""
			End If
			
			'------------------------------
			'Desconta se teve acúmulos
			'------------------------------
			If strACUMULOU_IRRF Then
				strVLR_FINAL = strVLR_FINAL - strTOTAL_ACUM_IRRF
			Else
				If strTOTAL_IRRF >= strVLR_LIM_IRRF Then strVLR_FINAL = strVLR_FINAL - strTOTAL_IRRF
			End If
			If strACUMULOU_REDUCAO Then
				strVLR_FINAL = strVLR_FINAL - strTOTAL_ACUM_REDUCAO
			Else
				If strTOTAL_REDUCAO >= strVLR_LIM_REDUCAO Then strVLR_FINAL = strVLR_FINAL - strTOTAL_REDUCAO
			End If
			
			strCOD_ACUM_IRRF = ""
			strCOD_ACUM_REDUCAO = ""
			If strACUMULOU_IRRF    Then strCOD_ACUM_IRRF = strCOD_DADO
			If strACUMULOU_REDUCAO Then strCOD_ACUM_REDUCAO = strCOD_DADO
			
			strALIQ_IRRF    = FormataDecimal(strALIQ_IRRF, 2)
			strALIQ_PIS     = FormataDecimal(strALIQ_PIS, 2)
			strALIQ_COFINS  = FormataDecimal(strALIQ_COFINS, 2)
			strALIQ_CSOCIAL = FormataDecimal(strALIQ_CSOCIAL, 2)
			strALIQ_IRPJ    = FormataDecimal(strALIQ_IRPJ, 2)
			strALIQ_ISSQN   = FormataDecimal(strALIQ_ISSQN, 2)
			
			strVLR_BASE       = FormataDecimal(strVLR_BASE, 2)
			strTOTAL_IRRF     = FormataDecimal(strTOTAL_IRRF, 2)
			strTOTAL_PIS      = FormataDecimal(strTOTAL_PIS, 2)
			strTOTAL_COFINS   = FormataDecimal(strTOTAL_COFINS, 2)
			strTOTAL_CSOCIAL  = FormataDecimal(strTOTAL_CSOCIAL, 2)
			strTOTAL_IRPJ     = FormataDecimal(strTOTAL_IRPJ, 2)
			strTOTAL_ISSQN    = FormataDecimal(strTOTAL_ISSQN, 2)
			strTOTAL_REDUCAO  = FormataDecimal(strTOTAL_REDUCAO, 2)
			strTOTAL_IMPOSTOS = FormataDecimal(strTOTAL_IMPOSTOS, 2)
			strVLR_FINAL      = FormataDecimal(strVLR_FINAL, 2)
			
			strVLR_LIM_IRRF       = FormataDecimal(strVLR_LIM_IRRF, 2)
			strVLR_LIM_REDUCAO    = FormataDecimal(strVLR_LIM_REDUCAO, 2)
			strTOTAL_ACUM_IRRF    = FormataDecimal(strTOTAL_ACUM_IRRF, 2)
			strTOTAL_ACUM_REDUCAO = FormataDecimal(strTOTAL_ACUM_REDUCAO, 2)
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
<form name="form_insert" action="GeraTaxasTitulo_Exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCOD_DADO%>">
	<input type="hidden" name="var_tipo" value="<%=strENTIDADE_TIPO%>">
	<input type="hidden" name="var_codigo" value="<%=strENTIDADE_CODIGO%>">
	
	<input type="hidden" name="var_cod_cfg_nf"     value="<%=strCOD_CFG_NF%>">
	<input type="hidden" name="var_aliq_issqn"     value="<%=FormataDouble(strALIQ_ISSQN)%>">
	<input type="hidden" name="var_aliq_irpj"      value="<%=FormataDouble(strALIQ_IRPJ)%>">
	<input type="hidden" name="var_aliq_cofins"    value="<%=FormataDouble(strALIQ_COFINS)%>">
	<input type="hidden" name="var_aliq_pis"       value="<%=FormataDouble(strALIQ_PIS)%>">
	<input type="hidden" name="var_aliq_csocial"   value="<%=FormataDouble(strALIQ_CSOCIAL)%>">
	<input type="hidden" name="var_aliq_irrf"      value="<%=FormataDouble(strALIQ_IRRF)%>">
	<input type="hidden" name="var_vlr_base"       value="<%=FormataDouble(strVLR_BASE)%>">
	<input type="hidden" name="var_total_irrf"     value="<%=FormataDouble(strTOTAL_IRRF)%>">
	<input type="hidden" name="var_total_pis"      value="<%=FormataDouble(strTOTAL_PIS)%>">
	<input type="hidden" name="var_total_cofins"   value="<%=FormataDouble(strTOTAL_COFINS)%>">
	<input type="hidden" name="var_total_csocial"  value="<%=FormataDouble(strTOTAL_CSOCIAL)%>">
	<input type="hidden" name="var_total_irpj"     value="<%=FormataDouble(strTOTAL_IRPJ)%>">
	<input type="hidden" name="var_total_issqn"    value="<%=FormataDouble(strTOTAL_ISSQN)%>">
	<input type="hidden" name="var_total_impostos" value="<%=FormataDouble(strTOTAL_IMPOSTOS)%>">
	<input type="hidden" name="var_total_reducao"  value="<%=FormataDouble(strTOTAL_REDUCAO)%>">
	<input type="hidden" name="var_vlr_final"      value="<%=FormataDouble(strVLR_FINAL)%>">
	
	<input type="hidden" name="var_cod_acum_irrf"        value="<%=strCOD_ACUM_IRRF%>">
	<input type="hidden" name="var_cod_acum_reducao"     value="<%=strCOD_ACUM_REDUCAO%>">
	<input type="hidden" name="var_total_acum_irrf"      value="<%=FormataDouble(strTOTAL_ACUM_IRRF)%>">
	<input type="hidden" name="var_total_acum_reducao"   value="<%=FormataDouble(strTOTAL_ACUM_REDUCAO)%>">
	<input type="hidden" name="var_codigos_acum_irrf"    value="<%=strCODIGOS_ACUM_IRRF%>">
	<input type="hidden" name="var_codigos_acum_reducao" value="<%=strCODIGOS_ACUM_REDUCAO%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCOD_DADO%></div>
	<br><div class="form_label">Conta:</div><div class="form_bypass"><%=GetValue(objRS1, "CONTA")%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass"><%=strENTIDADE%></div>
	<br><div class="form_label">Plano de Conta:</div><div class="form_bypass"><%=GetValue(objRS1,"PLANO_CONTA_COD_REDUZIDO")%>&nbsp;&nbsp;<%=GetValue(objRS1,"PLANO_CONTA")%></div>
	<br><div class="form_label">Centro de Custo:</div><div class="form_bypass"><%=GetValue(objRS1,"CENTRO_CUSTO")%></div>
	<br><div class="form_label">Valor:</div><div class="form_bypass"><%=strVLR_BASE%></div>
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
	<div class="form_grupo_collapse" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
		style="cursor:pointer;">
		<b>Alíquotas</b><br>
		<br><div class="form_label">IRRF:</div><div class="form_bypass"><%=strALIQ_IRRF%></div>
		<br><div class="form_label">PIS:</div><div class="form_bypass"><%=strALIQ_PIS%></div>
		<br><div class="form_label">COFINS:</div><div class="form_bypass"><%=strALIQ_COFINS%></div>
		<br><div class="form_label">CSOCIAL:</div><div class="form_bypass"><%=strALIQ_CSOCIAL%></div>
		<br><div class="form_label">IRPJ:</div><div class="form_bypass"><%=strALIQ_IRPJ%></div>
		<br><div class="form_label">ISSQN:</div><div class="form_bypass"><%=strALIQ_ISSQN%></div>
	</div>
	<br>
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
		style="cursor:pointer;">
		<b>Taxas Calculadas</b><br>
		<br><div class="form_label">Valor Base:</div><div class="form_bypass"><%=strVLR_BASE%></div>
		<br><div class="form_label">Total IRRF:</div><div class="form_bypass"><%=strTOTAL_IRRF%></div>
		<br><div class="form_label">Total PIS:</div><div class="form_bypass"><%=strTOTAL_PIS%></div>
		<br><div class="form_label">Total COFINS:</div><div class="form_bypass"><%=strTOTAL_COFINS%></div>
		<br><div class="form_label">Total CSOCIAL:</div><div class="form_bypass"><%=strTOTAL_CSOCIAL%></div>
		<br><div class="form_label">Total IRPJ:</div><div class="form_bypass"><%=strTOTAL_IRPJ%></div>
		<br><div class="form_label">Total ISSQN:</div><div class="form_bypass"><%=strTOTAL_ISSQN%></div>
		<br><div class="form_label">Total Impostos:</div><div class="form_bypass"><%=strTOTAL_IMPOSTOS%></div>
		<br><div class="form_label">Total Redução Outros:</div><div class="form_bypass"><%=strTOTAL_REDUCAO%></div>
		<br><div class="form_label">Valor Final:</div><div class="form_bypass"><%=strVLR_FINAL%></div>
	</div>
	<br>
	<% If strACUMULOU_IRRF Or strACUMULOU_REDUCAO Then %>
		<div class="form_grupo" id="form_grupo_3">
			<div class="form_label"></div>
			<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
			style="cursor:pointer;">
	<% Else %>
		<div class="form_grupo_collapse" id="form_grupo_3">
			<div class="form_label"></div>
			<img src="../img/BulletMais.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
			style="cursor:pointer;">
	<% End If %>
		<b>Limites e Acúmulos Calculados</b><br>
		<br><div class="form_label">IRRF:</div><div class="form_bypass"><%=strVLR_LIM_IRRF%></div>
		<br><div class="form_label">Outras Reduções:</div><div class="form_bypass"><%=strVLR_LIM_REDUCAO%></div>
		<br><div class="form_label">Acumulou IRRF:</div><div class="form_bypass"><%
		If strACUMULOU_IRRF Then
			Response.Write("Sim, no total de R$ " & strTOTAL_ACUM_IRRF)
			If strCODIGOS_ACUM_IRRF <> "" Then
				Response.Write(" (desta conta e de outras)")
			Else
				Response.Write(" (apenas nesta conta)")
			End If
		Else
			Response.Write("Não")
		End If
		%></div>
		<br><div class="form_label">Acumulou Reduções:</div><div class="form_bypass"><%
		If strACUMULOU_REDUCAO Then
			Response.Write("Sim, no total de R$ " & strTOTAL_ACUM_REDUCAO)
			If strCODIGOS_ACUM_REDUCAO <> "" Then
				Response.Write(" (desta conta e de outras)")
			Else
				Response.Write(" (apenas nesta conta)")
			End If
		Else
			Response.Write "Não"
		End If
		%></div>
	</div>
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
